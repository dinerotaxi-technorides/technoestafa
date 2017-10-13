Q         = require 'q'

mongo     = require '../dbs/mongo'
sql       = require '../dbs/sql'
config    = require '../../config'
models    = require '../models_sequelize'
tools     = require '../tools'
log       = require('../log').create 'PushService'
moment    = require('moment')
gcm       = require('node-gcm')
apn       = require('apn')
service      = require './service'
data_adapter = require '../dbs/data_adapter'
INVALID_TOKEN = 'Invalid Token Specified, must be a Buffer or valid hex String'
@execute_job = () ->
  Q()
  .then =>
    console.log "pushService"
    sql.getPendingDelayOperations()
  .then (opertions) =>
    @updateDelayOperations opertions
  .then =>

    mongo.ChatMessage.find
      status      : 'PENDING'
    .exec()
  .then (mg_chats) =>
    @mg_chats = mg_chats
    Q.all(
      for chat in @mg_chats
        @push_step_2 chat
    )
  .then (chat) =>
    for chats in @mg_chats
      @process_chat chats

    today =  new Date()
    today.setSeconds(today.getSeconds() - 15)

    mongo.PushMessage.find
      status    : 'PENDING'
      created_at:
        $lt: today
    .exec()
  .then (mg_pushs) =>
    @mg_pushs = mg_pushs
    Q.all(
      for push in @mg_pushs
        @push_step_2 push
    )
  .then (chat) =>
    for push in @mg_pushs
      @process_push push
  .fail (err) ->
    log.ex err, "push:execute_job", "#{err.stack}"

@updateDelayOperations = (operations) ->
  if operations.length is 0
    return
  Q()
  .then =>
    operations_to_push = []
    for operation in operations
      operations_to_push.push operation.id
    sql.updatePushOperationDelay(operations_to_push.join(','))
  .then =>
    for operation in operations
      @addPushMessageToUser operation

@addPushMessageToUser = (operation) ->
  Q()
  .then =>
    msg =
      action                    : 'delayOperationPush'
      opid                      : operation.id
      rtaxi_id                  : operation.rtaxi_id
      message_id                : '5312495272a1fa62f90003cd'
      message_need_confirmation : false

    message_ack_mg = data_adapter.PushMessageUserToMongo(operation,msg,operation)
    message_ack_mg.save()
  .then (mssg_ack) =>
    console.log "send_push_alert_delay_operation"
    return
  .fail (err) ->
    log.ex err, "push:addPushMessageToUser", "#{err.stack}"

@push_step_2 = (chat) ->
  Q()
  .then =>
    chat.status = "FATAL_ERROR"
    chat.save()
  .then (c_) =>
    return c_

@process_push = (push) ->
  Q()
  .then =>
    if not push.recipients?
      throw new Error("not_ready1")

    if not push.recipients_ack?
      throw new Error("not_ready2")
    service.getAndCreateConfig push.rtaxi_id
  .then (cfg) =>
    if not cfg
      throw new Error("NO_CONFIG_FOUND")
    @cfg = cfg

    if  push.recipients.length isnt  push.recipients_ack.length
      Q()
      .then =>
        push.status = "COMPLETED"
        push.save()
      .then (c_) =>
        @process_message_push push, @cfg
      .then (e)=>
        throw new Error("not_ready3")
    else
      Q()
      .then =>
        push.status = "COMPLETED"
        push.save()
      .then (c_) =>
        return c_
  .fail (err) ->
    if err.message not in ['not_ready1','not_ready2','not_ready3']
      log.ex err, "push:process_push", "#{err.stack}"

@process_message_push = (push, cfg) ->
  if not push.recipients
    return
  for receiver in push.recipients
    if  push.recipients_ack.length is 0 or receiver not in push.recipients_ack
      console.log receiver
      @sub_process_push push, cfg, receiver



@process_chat = (chat) ->
  if not chat.rtaxi_id
    return
  Q()
  .then =>
    if not chat.recipients?
      throw new Error("not_ready1")

    if not chat.recipients_ack?
      throw new Error("not_ready2")

    service.getAndCreateConfig chat.rtaxi_id
  .then (cfg) =>
    if not cfg
      throw new Error("NO_CONFIG_FOUND")
    @cfg = cfg
    if  chat.recipients.length isnt  chat.recipients_ack.length
      Q()
      .then =>
        @process_message chat, @cfg
      .then (e)=>
        return
    else
      Q()
      .then =>
        chat.status = "COMPLETED"
        chat.save()
      .then (c_) =>
        return c_
  .fail (err) ->
    if err.message not in ['not_ready1','not_ready2','not_ready3']
      log.ex err, "push:process_chat", "#{err.stack}"


@process_message = (chat, cfg) ->
  if not chat.recipients
    return
  for receiver in chat.recipients
    if  chat.recipients_ack.length is 0 or receiver not in chat.recipients_ack
      @sub_process chat, cfg, receiver

@sub_process = (chat, cfg, receiver) ->
  Q()
  .then =>
    @get_user_to_push receiver
  .then (user) =>
    if not user
      throw new Error("not_user_found")
    @user = user
    models.user.findOne
      where:
        id   : user.rtaxi_id
  .then (rtaxi) =>
    lang = 'es'
    if rtaxi.lang?
      lang = rtaxi.lang

    if not @user.device_key
      chat.recipients_ack.push receiver
      chat.status = "FATAL_ERROR"
      chat.save()
      throw new Error("device_key_error")

    if @user.device_type is 'ANDROID'
      chat.recipients_ack.push receiver
      chat.save()
      @send_message_android_push(chat,'pushNewMessage', cfg, @user, lang)
    else
      if @user.device_type isnt 'IOS'
        chat.recipients_ack.push receiver
        chat.save()
        throw new Error("device_key_error")

      @send_message_ios_push chat, cfg, @user, lang
  .then (response) =>
    console.log "SUB PROCESS FINISH PUSH#{response}"
  .fail (err) ->
    if err.message not in ['not_user_found','device_key_error','not_ready3']
      log.ex err, "push:sub_process", "#{err.stack}"

@sub_process_push = (push, cfg, receiver) ->
  Q()
  .then =>
    @get_user_to_push receiver
  .then (user) =>
    if not user
      throw new Error("not_user_found")
    @user = user
    models.user.findAll
      where:
        id   : user.rtaxi_id
  .then (rtaxi) =>
    lang = 'es'
    if rtaxi.lang?
      lang = rtaxi.lang
    if not @user.device_key
      push.recipients_ack.push receiver
      push.save()
      throw new Error("device_key_error")

    if @user.device_type is 'ANDROID'
      push.recipients_ack.push receiver
      push.save()
      @send_message_android_push push, 'pushOperationMessage', cfg, @user, lang
    else
      if @user.device_type isnt 'IOS'
        push.recipients_ack.push receiver
        push.save()
        throw new Error("device_key_error")

      @send_message_ios_push push.message, cfg, @user, lang
  .fail (err) ->
    if err.message not in ['not_user_found','device_key_error','not_ready3']
      log.ex err, "push:sub_process_push", "#{err.stack}"


@send_message_android_push = (msg, action, cfg, user, lang) ->

  if not cfg.android_token
    return

  if not user.device_key
    return

  Q().then =>
    message = new gcm.Message()
    message.addData('message',JSON.stringify( msg ) )
    message.addData('action',action)
    regTokens = [user.device_key]
    sender = new gcm.Sender(cfg.android_token);
    deferred = Q.defer()
    sender.send message, { registrationTokens: regTokens },  (err, response) ->
      if(err)
        console.log err
        deferred.reject(new Error(err))
      else
        console.log response
        deferred.resolve(response)

    return deferred.promise
  .fail (err) ->
    log.ex err, "push:send_message_android_push #{err.message}", "#{err.stack}"



@send_message_ios_push = (message, cfg, user, lang) ->

  if not cfg.android_token
    return

  if not user.device_key
    return

  Q().then =>
    rute = "#{config.apple.rute}/#{cfg.apple_certificate_path}"
    if user.driver_id
      rute = "#{config.apple.rute_driver}"
    console.log rute
    options = {
      cert: "#{rute}/cert.pem"
      key : "#{rute}/key.pem"
      port: cfg.apple_port
      passphrase: cfg.apple_password
      production: config.apple.production
      address   : config.apple.address
    }
    apnConnection = new apn.Connection(options)
    apnConnection.on 'connected', ->
      console.log 'Connected'
      return
    apnConnection.on 'connected', ->
      console.log 'Connected'
      return
    apnConnection.on 'transmitted', (notification, device) ->
      console.log 'Notification transmitted to:' + device.token.toString('hex')
      return
    apnConnection.on 'transmissionError', (errCode, notification, device) ->
      console.error 'Notification caused error: ' + errCode + ' for device ', device, notification
      if errCode == 8
        console.log 'A error code of 8 indicates that the device token is invalid. This could be for a number of reasons - are you using the correct environment? i.e. Production vs. Sandbox'
      return
    apnConnection.on 'timeout', ->
      console.log 'Connection Timeout'
      return
    apnConnection.on 'disconnected', ->
      console.log 'Disconnected from APNS'
      return
    apnConnection.on 'socketError', console.error

    myDevice = new apn.Device(user.device_key)
    note = new apn.Notification();
    note.expiry = Math.floor(Date.now() / 1000) + 3600;
    note.badge = 1;
    note.sound = "ping.aiff";
    if lang is 'es'
      note.alert = "\uD83D\uDCE7 \u2709 Tienes un nuevo mensaje";
    else
      note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
    note.payload = {message:JSON.stringify(message)};

    apnConnection.pushNotification(note, myDevice);
  .then =>
    console.log "send_message_ios_push Done...."
  .fail (err) =>
    if err.message in [INVALID_TOKEN]
      console.log "AAAAA PUSH ErROR TOKEN"
      user.device_key = ''
      user.save()
    else if err.message isnt 'Invalid hex string' #This error should be filtered to prevent masive mails
      log.ex err, "push:send_message_ios_push #{err.message}", "#{err.stack}"

@get_user_to_push = (id_user) ->
  Q()
  .then =>
    service.getUserProfile({id:id_user})
  .then (profi) =>
    if not profi.type_user?
      mongo.User.findOne
        user_id:id_user
      .exec()
    else if profi.type_user is 'TAXISTA'
      mongo.Driver.findOne
        driver_id:id_user
      .exec()
    else
      mongo.Company.findOne
        company_id:id_user
      .exec()
  .fail (err) ->
    log.ex err, "push:get_user_to_push", "#{err.stack}"
