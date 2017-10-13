moment  = require 'moment'
mongo   = require '../dbs/mongo'
log     = require('../log').create 'DataAdapter'
Q       = require 'q'
service = require '../tasks/service'
tools   = require '../tools'

#IMPORTANT: Mongo saves coordinates as [longitude, latitude], not [latitude, longitude]

@OptionsFromApiToMongo = (in_options) ->
  out_options = new mongo.Options
  out_options.messaging = in_options.messaging
  out_options.pet       = in_options.pet
  out_options.smoker    = in_options.smoker
  out_options.airConditioning   = in_options.airConditioning
  out_options.specialAssistant  = in_options.specialAssistant
  out_options.luggage   = in_options.luggage
  out_options.vip       = in_options.vip
  out_options.airport   = in_options.airport
  out_options.invoice   = in_options.invoice

  return out_options


@PlaceFromApiToMongo = (in_place) ->
  out_place = new mongo.Place
  out_place.location      = [in_place.lng, in_place.lat]
  out_place.country       = in_place.country ? ''
  out_place.locality      = in_place.locality ? ''
  out_place.street        = in_place.street ? ''
  out_place.street_number = in_place.streetNumber ? ''
  out_place.floor         = in_place.floor ? ''
  out_place.appartment    = in_place.appartment ? ''
  out_place.admin_1_code  = in_place.admin_1_code ? ''

  return out_place


@chatMessageToMongo = (message) ->
  chat_m = new mongo.ChatMessage
  chat_m.sender_id      = message.sender_id

  chat_m.rtaxi_id           = message.rtaxi
  chat_m.security_email     = message.security_email ? ''
  chat_m.sender_name        = message.sender_name ? ''
  chat_m.filename           = message.filename ? ''
  chat_m.bytes              = message.bytes ? ''
  chat_m.type_user          = message.type_user ? 0
  chat_m.type_user_sender   = message.type_user_sender ? 0
  chat_m.type_user_receiver = message.type_user_receiver ? 0
  chat_m.type_message       = message.type_message ? 0
  chat_m.type               = message.type ? 0

  return chat_m

@PushMessageToMongo = (operation, msg, type_op) ->
  mess = new mongo.PushMessage
  mess.recipients = []
  mess.type       = type_op
  mess.rtaxi_id   = operation.rtaxi_id
  mess.message    = JSON.stringify(msg)
  driver = operation.driver
  user   = operation.user

  console.log "---PushMessageToMongo---#{JSON.stringify operation.driver}"
  if user?
    mess.recipients.push user.user_id

  if driver?
    mess.recipients.push driver.driver_id

  return mess

@PushMessageDriverToMongo = (operation, msg, driver) ->
  mess = new mongo.PushMessage
  mess.recipients = []
  mess.type       = 1
  mess.rtaxi_id   = operation.rtaxi_id
  mess.message    = JSON.stringify(msg)

  if driver.driver_id?
    mess.recipients.push driver.driver_id

  return mess

@PushMessageDriversToMongo = (rtaxi, msg, drivers) ->
  console.log rtaxi,drivers
  mess = new mongo.PushMessage
  mess.recipients = []
  mess.type       = 1
  mess.rtaxi_id   = rtaxi
  mess.message    = JSON.stringify(msg)
  for driver in drivers
    mess.recipients.push parseInt(driver)

  return mess

@PushMessageUserToMongo = (operation, msg, user) ->
  mess = new mongo.PushMessage
  mess.recipients = []
  mess.type       = 1
  mess.rtaxi_id   = operation.rtaxi_id
  mess.message    = JSON.stringify(msg)

  if user.user_id?
    mess.recipients.push user.user_id

  return mess

@chatMessageFromMongoToWeb = (message,sender) ->
  chat_m = {}
  chat_m.bytes          = ""
  chat_m.id             = message._id
  chat_m.type           = message.type
  chat_m.type_message   = message.type_message
  chat_m.rtaxi_id       = message.rtaxi_id
  chat_m.sender_name    = message.sender_name
  chat_m.sender_id      = message.sender_id
  chat_m.filename       = message.filename

  chat_m.created_at     = message.created_at
  chat_m.recipients_ack = message.recipients_ack
  chat_m.recipients     = message.recipients

  chat_m.sender = sender

  if(message.type_message is 1)
    chat_m.bytes          = message.bytes

  return chat_m

@conversationFromMongoToWeb = (message, message_chat,in_conversation ) ->
  conversation_m = {}
  conversation_m.id          = message._id
  conversation_m.sender_id   = message.sender_id
  conversation_m.receiver_id = message.receiver_id

  conversation_m.message_chat   = message_chat

  conversation_m.updated_at      = message.updated_at
  conversation_m.in_conversation = in_conversation

  Q()
  .then =>
    service.getUserProfile
      id: message.sender_id
  .then (sender) =>
    sender.type_user = tools.getTypeUser sender.type_user
    conversation_m.sender = sender
    service.getUserProfile
      id: message.receiver_id
  .then (receiver) =>
    receiver.type_user = tools.getTypeUser receiver.type_user
    conversation_m.receiver = receiver
    return conversation_m
  .fail (err) =>
    console.log err.stack
    return {}


@PlaceFromMongoToClient = (in_place) ->
  if not in_place?
    return {
        'street'        : ''
        'appartment'    : ''
        'streetNumber'  : ''
        'locality'      : ''
        'lat'           : 0.0
        'country'       : ''
        'lng'           : 0.0
        'floor'         : ''
        'admin1Code'    : ''
      }

  return {
        'street'        : in_place.street
        'appartment'    : in_place.appartment
        'streetNumber'  : in_place.street_number
        'locality'      : in_place.locality
        'country'       : in_place.country
        'floor'         : in_place.floor
        'lat'           : in_place.location[1] ? 0
        'lng'           : in_place.location[0] ? 0
        'admin1Code'    : in_place.admin_1_code
      }


@PassengerFromMongoToClient = (in_passenger) ->
  if in_passenger?
    return {
        'id'        : in_passenger.user_id
        'rtaxi'     : in_passenger.rtaxi_id
        'cityName'  : ''
        'cityCode'  : ''
        'email'     : in_passenger.email
        'firstName' : in_passenger.first_name
        'lastName'  : in_passenger.last_name
        'phone'       :in_passenger.phone
        'companyName' :in_passenger.company_name
        'lang'        :in_passenger.language
        'isFrequent'  :in_passenger.is_frequent
        'isCC'        :in_passenger.is_cc
    }
  else
    return {}


@DriverFromMongoToClient = (in_driver) ->
    if not in_driver?
      return null

    rtaxi_id = ""
    if in_driver.rtaxi_id then rtaxi_id = in_driver.rtaxi_id

    opId = ""
    if in_driver.operation_id then opId = in_driver.operation_id

    return {
      'id': in_driver.driver_id
      'rtaxi': rtaxi_id
      'state': in_driver.status
      'status': in_driver.status
      'lat': in_driver.location[1]
      'lng': in_driver.location[0]
      'firstName': in_driver.first_name
      'lastName': in_driver.last_name
      'phone': in_driver.phone
      'email': in_driver.email
      'brandCompany': in_driver.brand
      'model': in_driver.model
      'plate': in_driver.plate
      'version': in_driver.version ? '0.0.0'
      'driverNumber': in_driver.email.split('@')[0]
      'number': in_driver.email.split('@')[0]
      'serial': in_driver?.serial?
      'is_fake': in_driver?.is_fake
      'is_blocked': in_driver?.is_blocked
      'is_connected': in_driver?.is_connected
      'updated_at': in_driver.updated_at ? ''
      'notification_id': 2003
      'message_id': '5312495272a1fa62f90003cd'
      'message_need_confirmation': false
      'operation_id': opId
    }


@OptionsFromMongoToClient = (in_options) ->
  console.log in_options
  return {
      'messaging'         : in_options?.messaging ? false
      'pet'               : in_options?.pet ? false
      'smoker'            : in_options?.smoker ? false
      'airConditioning'   : in_options?.airConditioning ? false
      'specialAssistant'  : in_options?.specialAssistant ? false
      'luggage'           : in_options?.luggage ? false
      'vip'               : in_options?.vip ? false
      'airport'           : in_options?.airport ? false
      'invoice'           : in_options?.invoice ? false
  }

@operationFromMongoToClient = (in_operation) ->
  amount = 0.0
  if (in_operation.amount)
    amount = in_operation.amount

  return {
      'id'      : in_operation.operation_id
      'rtaxi'   : in_operation.rtaxi_id
      'status'  : in_operation.status
      'amount'  : amount
      'comments': in_operation.comments
      'created_at'      : moment(in_operation.created_at).format('YYYY-MM-DD hh:mm:ss a ZZ')
      'assigned_at'     : moment(in_operation.assigned_at).format('YYYY-MM-DD hh:mm:ss a ZZ')
      'at_the_door_at'  : moment(in_operation.at_the_door_at).format('YYYY-MM-DD hh:mm:ss a ZZ')
      'estimated_time'  : in_operation.estimated_time
      'is_web_user'     : in_operation.is_web_user
      'finding_driver'  : in_operation.finding_driver
      'device'          : in_operation.device
      'options'     : @OptionsFromMongoToClient(in_operation.option)
      'placeFrom'   : @PlaceFromMongoToClient(in_operation.place_from)
      'placeTo'     : @PlaceFromMongoToClient(in_operation.place_to)
      'driver'      : @DriverFromMongoToClient(in_operation.driver)
      'user'        : @PassengerFromMongoToClient(in_operation.user)
      'lat'         : in_operation.location[1]
      'lng'         : in_operation.location[0]
      'notification_id'           : 2003
      'message_id'                : '5312495272a1fa62f90003cd'
      'message_need_confirmation' : false
    }

@driverEventFromMongoToClient = (in_event) ->
  out_event = {}
  out_event.driver_email = in_event.driver_email
  out_event.at_time = moment(in_event.at_time).format('YYYY-MM-DD hh:mm:ss a ZZ')
  return out_event

@operatorEventFromMongoToClient = (in_event) ->
  out_event = {}
  out_event.operator = in_event.operator
  out_event.at_time = moment(in_event.at_time).format('YYYY-MM-DD hh:mm:ss a ZZ')
  return out_event

@flowFromMongoToClient = (in_flow) ->
  out_flow = {}

  out_flow.operation_id = in_flow.operation_id
  out_flow.created_at = moment(in_flow.created_at).format('YYYY-MM-DD hh:mm:ss a ZZ')

  out_flow.sent_to = []
  for sent in in_flow.sent_to
    out_flow.sent_to.push(@driverEventFromMongoToClient(sent))
  if in_flow.assigned_to?
    out_flow.assigned_to = @driverEventFromMongoToClient(in_flow.assigned_to)
  if in_flow.accepted_by?
    out_flow.accepted_by = @driverEventFromMongoToClient(in_flow.accepted_by)
  out_flow.estimated_time_to_door = in_flow.estimated_time_to_door
  if in_flow.at_the_door_at?
    out_flow.at_the_door_at = moment(in_flow.at_the_door_at).format('YYYY-MM-DD hh:mm:ss a ZZ')
  if in_flow.on_board_at?
    out_flow.on_board_at = moment(in_flow.on_board_at).format('YYYY-MM-DD hh:mm:ss a ZZ')
  out_flow.ring_user_at = []
  for ring in in_flow.ring_user_at
    out_flow.push(moment(ring).format('YYYY-MM-DD hh:mm:ss a ZZ'))

  if in_flow.canceled_by_user_at?
    out_flow.canceled_by_user_at = moment(in_flow.canceled_by_user_at).format('YYYY-MM-DD hh:mm:ss a ZZ')

  if in_flow.canceled_by_driver_at?
    out_flow.canceled_by_driver_at = moment(in_flow.canceled_by_driver_at).format('YYYY-MM-DD hh:mm:ss a ZZ')

  if in_flow.finished_by_user_at?
    out_flow.finished_by_user_at = moment(in_flow.finished_by_user_at).format('YYYY-MM-DD hh:mm:ss a ZZ')

  if in_flow.finished_by_driver_at?
    out_flow.finished_by_driver_at = moment(in_flow.finished_by_driver_at).format('YYYY-MM-DD hh:mm:ss a ZZ')

  if in_flow.canceled_by_operator?
    out_flow.canceled_by_operator = @operatorEventFromMongoToClient(in_flow.canceled_by_operator)

  if in_flow.finished_by_operator?
    out_flow.finished_by_operator = @operatorEventFromMongoToClient(in_flow.finished_by_operator)

  return out_flow

@get_created_by = (op) ->
  if op.created_by_operator[0] is 1
    return "OPERATOR"
  if op.clazz is "ar.com.operation.OperationPending"
    return 'PASSENGER'
  else
    return 'C_PASSENGER'

@get_programmed_trip = (op) ->
  return @getSQLBoolean op.is_delay_operation

@getSQLBoolean = (val) ->
  if not val
    return false
  return val[0] is 1
