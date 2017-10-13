Q      = require 'q'

redis  = require '../dbs/redis'
mongo  = require '../dbs/mongo'
sql    = require '../dbs/sql'
data_adapter = require '../dbs/data_adapter'
bcast    = require '../dbs/broadcast'


base   = require './base'

service= require '../tasks/service'

config = require '../../config'
tools  = require '../tools'
moment = require 'moment'
crypto = require 'crypto'

log    = require('../log').create 'Passenger'

mail    = require '../mail/mailer'

class @PassengerHandler extends base.BaseHandler
  log: log.create 'PassengerHandler'

  kind: =>
    super
    return "passenger"

  onConnected: ->
    super
    Q()
    .then =>
      #this line kill another user connected
      tools.closeConnection 'user', @params.rtaxi, @params.id
      mongo.User.findOne
        user_id: @params.id
      .exec()
    .then (user) =>
      # Read or init mongo data:
      @user = user ?
        new mongo.User
          user_id: @params.id
          rtaxi_id : @params.rtaxi ? 0

      sql.findUser id: @params.id
    .then ([user]) =>
      # Read SQL data:
      @user.first_name = user.first_name ? ''
      @user.last_name  = user.last_name  ? ''
      @user.email      = user.email      ? ''
      @user.phone      = user.phone      ? ''
      @user.language   = user.lang ? ''

      @user.city_id    = user.city_id ? ''
      @user.employee_id = user.employee_id ? ''
      @user.company_name = user.company_name ? ''
      @user.is_frequent = user.is_frequent ? false
      @user.is_cc = tools.getUserClazz(user.clazz)

    .then =>
      # Read ws query string data:
      @user.token   = @params.token   ? ''
      @user.is_connected  = false

      @user.device_key  = @params.device_key  ? @user.device_key
      @user.device_type = @params.device_type ? @user.device_type
      @user.save()

      @channels = bcast.userChannels(@params.rtaxi, @params.id)

      for channel in @channels
        @subscribe channel

      console.log "Passenger logged in"
      mongo.Operation.findOne
        operation_id: 835194
      .exec()
    .then (operation) =>
      console.log(operation)

      # setTimeout((->
      #   console.log "Pinged"
      #   ), 10000)
      #
      # setTimeout (-> console.log "Pinged2"), 1000
      #
      #
      # sleep = (time)  ->
      #  start = Date.now()
      #  stop = start + time
      #  console.log(start)
      #  console.log(stop)
      # sleep(5000)

      # log.d "Connection ok", @user

    .fail (err) =>
      console.log  "connect passenger #{err} #{JSON.stringify @params}"
      if @socket?
        try
          @closeSocket 4000, "4000"
        catch e
          log.ex e, "onConnected", ""


  closeSocket: (code, message) ->
    super

  onDisconnected: ->
    super
    log.d "Connection closed"

    Q()
    .then =>
      mongo.User.findOne
        user_id: @params.id
      .exec()
    .then (user) =>
      if user?
        user.is_connected  = false
        user.save()
    .fail (err) =>
      log.ex err, "onDisconnected", ""


  validateToken: (token, operation) ->
    if token != @params.token
      throw new Error("Invalid Token")

    if token != operation.user.token
      throw new Error("Invalid Token for operation")


  validateHmac: (text, key, hmac) ->
    if hmac != @createHmac text, key, hmac
      throw new Error("Invalid HMAC!")

  createHmac: (text, key) ->
    hash = crypto.createHmac('sha1', key).update(text).digest('base64')
    return hash

  sendMail: (message) ->
    if message.ccId?
      params
        orderId : message.orderId  ## orderId: NetPay payment operation generated code
        ccId    : message.ccId     ## ccId: card ID to collect additional required inforamtion
      mail.sendMailPayment message.opid, params, 'email.payment'

  @action 'Ping', (message) ->
    log.d "Ping : #{message}"
    Q()
    .then =>
      service.updateUserByPing message,@params.id
    .then (user) =>
      log.d "Ping Success #{message}"
    .fail (err) =>
      log.e "PassengerHandler:Ping : #{err}"

  @action 'Pong', (message) ->
    Q()
    .then =>
      service.updateUserByPing message, @params.id
    .then (user) =>
      log.d "Pong Success #{message}"
    .fail (err) =>
      log.e "PassengerHandler:Pong : #{err}"

  @action 'PullDrivers', (message) ->
    log.d "PullDrivers : #{message}"

    Q()
    .then =>
      @genericPoolDriver(['DISCONNECTED'])
    .fail (err) =>
      log.ex err, "PullDrivers", ""

  @action 'CancelTrip', (message) ->
    log.d "CancelTrip : #{message}"
    Q()
    .then =>
      log.op message.opid, @params.ip, 'PASSENGER',  service.TRANSACTIONSTATUS.CANCELED, message

      message.status =  service.TRANSACTIONSTATUS.CANCELED
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.CANCELED
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/CancelTrip"
    .fail (err) =>
      log.ex err, "CancelTrip", ""

  @action 'CreditCardPaymentCompleted', (message) ->
    log.d "CreditCardPaymentCompleted : #{message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'PASSENGER',  'CREDITCARDTXFINISHED', message

      message.status =  service.TRANSACTIONSTATUS.COMPLETED
      message.token = ''
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.COMPLETED
    .then (log_operation) =>
       @genericOperation message, "#{@kind()}/CreditCardPaymentCompleted"
    .then () =>
      @sendMail message
    .fail (err) =>
      log.ex err, "creditCardPaymentCompleted", ""

  @action 'FinishTrip', (message) ->
    log.d "FinishTrip : #{message}"
    Q()
    .then =>

      log.op message.opid, @params.ip, 'PASSENGER',  service.TRANSACTIONSTATUS.COMPLETED, message
      service.fc_service.log_wave message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.COMPLETED
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/FinishTrip"
    .fail (err) =>
      log.ex err, "FinishTrip", ""

  @action 'SetAmount', (message) ->
    log.d "SetAmount : #{message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'PASSENGER',  service.TRANSACTIONSTATUS.SETAMOUNT, message
      service.fc_service.log_wave message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.SETAMOUNT
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/SetAmount"
    .fail (err) =>
      log.ex err, "SetAmount", ""

  @action 'ResetAmount', (message) ->
    log.d "ResetAmount : #{message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'PASSENGER',  'RESETAMOUNT', message
      @genericOperation message, "#{@kind()}/ResetAmount"
    .fail (err) =>
      log.ex err, "ResetAmount", ""


  @action 'InTransactionTrip', (message) ->
    log.d "InTransactionTrip : #{message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'PASSENGER',  service.TRANSACTIONSTATUS.INTRANSACTION, message
      service.fc_service.log_wave message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.INTRANSACTION
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/InTransactionTrip"
    .fail (err) =>
      log.ex err, "InTransactionTrip", ""


  @action 'sendSms', (message) ->
    log.d "sendSms"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'PASSENGER',  'SENDSMS', message

      @sendSms message, "#{@kind()}/sendSms"
    .fail (err) =>
      log.ex err, "InTransactionTrip", ""


  @action 'PaymentStarted', (message) ->
    log.d "PaymentStarted : #{message}"

    operation = null

    Q()
    .then =>
      log.op message.opid, @params.ip, 'PASSENGER',  'PAYMENTSTARTED', message
      mongo.Operation.find
        operation_id: message.opid
      .populate('driver user')
      .exec()
    .then ([mg_operation]) =>
      operation = mg_operation
      @validateToken message.token, mg_operation

      msg = {
        'action' : "PaymentStarted",
        'opid'   : message.opid,
        'method' : message.method,

        'message_id'                : '53161f3e72a1fa9803000103',
        'message_need_confirmation' : true
      }
      bcast.broadcastToDriver(operation.rtaxi_id, operation.driver.driver_id, msg)
    .fail (err) =>
      log.ex err, "onDisconnected", ""


  @action 'CreditTransactionFinished', (message) ->
    log.d "CreditTransactionFinished : #{message}"

    operation = null

    Q()
    .then =>

      log.op message.opid, @params.ip, 'PASSENGER',  'CREDITCARDTXFINISHED', message

      mongo.Operation.find
        operation_id: message.opid
      .populate('driver user')
      .exec()
    .then ([mg_operation]) =>
      operation = mg_operation
      @validateToken message.token, mg_operation

      salt = operation.rtaxi_id
      key = "fd4486egbfjiWfgds46hbLM89j73r1df0efui9f8"
      secret = message.token + message.opid + message.result + salt
      @validateHmac secret, key, message.HMAC.trim()

      msg = {
          'action' : "CreditTransactionFinished",
          'opid'   : message.opid,
          'result' : message.result,
          'amount' : message.amount,

          'message_id'                : '53161f3e72a1fa9803000104',
          'message_need_confirmation' : true
        }
      bcast.broadcastToDriver(operation.rtaxi_id, operation.driver.driver_id, msg)
    .fail (err) =>
      log.ex err, "CreditTransactionFinished", ""


  @action 'ReadMessage', (message) ->
    log.d "Passenger:ReadMessage: #{message}"

  @action 'ackPushMessageReceived', (message) ->
    @genericAckMessage message

  @action 'getOperation', (message) ->
    log.d "getOperation : #{message}"
    Q()
    .then =>

      mongo.User.findOne
        user_id : @params.id
      .exec()
    .then (user) =>
      finished_states = config.oper_status.cancel.concat(config.oper_status.completed)

      today     = moment().startOf('day')
      yesterday = moment(today).subtract(1, 'days')
      tomorrow  = moment(today).add(1, 'days')
      mongo.Operation.findOne
        status:
          $nin: finished_states
        user: user
        created_at:
          $gte: yesterday.toDate()
          $lt: tomorrow.toDate()
      .populate('driver place_from place_to user option')
      .sort
        operation_id: -1
      .lean()
      .exec()
    .then (operation) =>
      @operation = operation

      if operation? and operation.rtaxi_id?
        Q()
        .then =>
          log.op @operation.operation_id, @params.ip, 'DRIVER',  'getOperation', message
          @operation = data_adapter.operationFromMongoToClient @operation
          @operation.action = "passenger/getOperation"
          @operation.message_id = '53161f3e72a1fa9803000106'
          @operation.message_need_confirmation = false
          service.getPhoneToCall(@operation.rtaxi, @operation.driver)
        .then (phone_to_call) =>
            if not phone_to_call?
              phone_to_call = ''
            @operation.phone_to_call = phone_to_call

            @send_message @operation
            return

        .fail (err) ->
          log.ex err, "passenger/getOperation", ""
    .fail (err) ->
      log.ex err, "passenger/getOperation", ""
