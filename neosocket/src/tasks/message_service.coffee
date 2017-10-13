Q            = require 'q'
geo          = require '../geo/google_maps'
data_adapter = require '../dbs/data_adapter'
mongo        = require '../dbs/mongo'
sql          = require '../dbs/sql'
service      = require './service'
tools        = require '../tools'
config       = require '../../config'

log     = require('../log').create 'MessageService'

@getUserByTokenOrRtaxi = (params) ->
    console.log "Here Vzla getUserByTokenOrRtaxi"

  Q()
  .then =>
    sql.findUserByToken {token : params.token}
  .then ([user]) =>
    if user
      return user
    else
      Q()
      .then =>
        sql.findAdminByToken  {token : params.token}
      .then ([user]) =>
        if not user
          return null
        else
          Q()
          .then =>
            sql.findUserProfileByAdmin {id:params.user_id, rtaxi_id: user.id}
          .then ([user]) =>
            if not user
              return null
            return user


@conversation_to_list = (message, in_conversation) ->
  Q()
  .then =>
    console.log "LAST CHATs#{message.receiver_id}, #{message.sender_id}"

    mongo.ChatMessage.find
      $or: [
        {sender_id: message.sender_id  , type: 1 , recipients: $in: [message.receiver_id] },
        {sender_id: message.receiver_id, type: 1 , recipients: $in: [message.sender_id]}
      ]
    .limit(1)
    .sort
      created_at: -1
  .then ([message_chat]) =>
    if not message_chat
      message_chat = {}

    data_adapter.conversationFromMongoToWeb message, message_chat, in_conversation
  .then (new_message) =>
    console.log new_message
    return new_message
  .fail (err) =>
    log.ex err, "chat_rest:conversation/list #{err.stack}", ""
    return {}

@message_list = (message) ->
  Q()
  .then =>
    service.getUserProfile id:message.sender_id
  .then (sender) =>
    sender.type_user = tools.getTypeUser sender.type_user
    @sender = sender
    new_message = data_adapter.chatMessageFromMongoToWeb message, @sender
    return new_message

@save_message = (message) ->
  if(not config.new_chat)
    console.log "chat disabled"
    return {
      _id:'53161f3e72a1fa9803000106'
    }
  @message_mg = data_adapter.chatMessageToMongo message
  Q()
  .then =>
    console.log "save message"
    if(@message_mg.type is 1)
      @generate_receiver(message)
    else
      @generate_receiver_broadcast(@message_mg)
  .then (receivers)=>
    @message_mg.recipients.push receiver for receiver in receivers
    @message_mg.save()
  .then (ac_message) =>
    return ac_message

@generate_receiver = (message_mg) ->
  receivers_ids = []
  if(not message_mg?.receiver_id)
    return []

  filter_conversation  =
    sender_id  : message_mg.sender_id
    receiver_id: message_mg.receiver_id

  Q()
  .then =>
    mongo.Conversation.findOne filter_conversation
  .then (conversation) =>
    if(not conversation?)
      conversation = new mongo.Conversation filter_conversation
    conversation.save()
  .then (conversation_ng) =>
    receivers_ids.push message_mg.receiver_id
    return receivers_ids

@generate_receiver_broadcast = (message_mg) ->
  timeout = new Date
  timeout.setSeconds(
    timeout.getSeconds() - config.time_out_disconnect_driver
  )
  receivers_ids = []

  rtaxi_id = message_mg.rtaxi_id
  user_id  = message_mg.sender_id
  #Broadcast All
  Q()
  .then =>

    mongo.Driver
    .where('updated_at').gte(timeout)
    .where('rtaxi_id').equals(rtaxi_id)
    .where('user_id').ne(user_id)
    .where('is_connected').equals(true).exec()
  .then (drivers) =>
    receivers_ids.push driver.driver_id for driver in drivers

    mongo.Company
    .where('updated_at').gte(timeout)
    .where('rtaxi_id').equals(rtaxi_id)
    .where('company_id').ne(user_id)
    .where('is_connected').equals(true)
    .exec()
  .then (operators) =>
    for operator in operators
      receivers_ids.push operator.company_id

    return receivers_ids
