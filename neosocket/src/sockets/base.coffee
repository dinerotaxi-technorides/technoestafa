Q      = require 'q'
url    = require 'url'
moment = require 'moment'

redis        = require '../dbs/redis'
mongo        = require '../dbs/mongo'
sql          = require '../dbs/sql'
data_adapter = require '../dbs/data_adapter'
bcast        = require '../dbs/broadcast'
DataStore    = require '../dbs/data_store'
parking_v2   = require '../tasks/driver_parking_queue'

service = require '../tasks/service'
config  = require '../../config'
tools   = require '../tools'
models  = require '../models_sequelize'

operation_enum  = require '../enum/operation_enum'

log = require('../log').create 'BaseHandler'

tryLog = (self, fname) -> ->
  try
    self[fname].apply self, arguments

  catch err
    log.e "#{self.constructor.name}.#{fname}: #{err.stack}"


class @BaseHandler
  log: log.create 'BaseHandler'

  constructor: (@socket) ->
    @store = new DataStore

    parsed_url = url.parse @socket.upgradeReq.url, true
    if config.show_ip?
      log.w @socket.upgradeReq.connection.remoteAddress
    if @socket?

      Q().then =>
        @domain = parsed_url.pathname
        @params = parsed_url.query
        @validateLoginConstructor(@params)
      .then (login_is_valid) =>
        unless login_is_valid
          @closeSocket 4001, "Invalid User"
        @params.ip = @socket.upgradeReq.connection.remoteAddress
        @_subscriber = new redis.Subscriber tryLog(@, 'onRedisMessage'), @onRedisError
        @channels = [
          "redis.#{@params.rtaxi}",
          "redis.#{@params.rtaxi}.#{@kind()}",
          "redis.#{@params.rtaxi}.#{@kind()}.#{@params.id}"
        ]

        @socket.on 'close', =>
          tryLog(@, 'onDisconnected')()

        Q.mcall @, 'onConnected'
        .then =>
          @socket.on 'message', tryLog @, 'onMessage'

        .fail (err) =>
          log.ex err, "BaseHandler:constructor", "params: #{@params}"
          @closeSocket 4000, "4000"
      .fail (err) ->
        log.ex err, "onConnected", ""

    else
      # console.log "BaseHandler:SOCKET ERROR HANDLER DIDNT EXIST #{parsed_url}"
      log.e "BaseHandler:SOCKET ERROR HANDLER DIDNT EXIST #{parsed_url}"


  onRedisError : (err) ->
    log.ex err, "onRedisError", ""


  onConnected: ->
    # If onConnected() returns a Promise, this BaseHandler will wait until
    # its fullfilment before attaching the onMessage callback. This enables
    # async initialization before messages start flowing in.

    connection_record = new mongo.Connection

    connection_record.db_id = @params.id
    connection_record.rtaxi = @params.rtaxi
    connection_record.kind  = @kind()
    connection_record.type  = "CONNECTED"

    connection_record.save()

    Q()
    .then =>
      @validateLogin()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"

    .fail (err) ->
      log.ex err, "onConnected", ""


  validateLogin: ->
    Q()
    .then =>
      if !config.validate_login_token
        throw new Error('IS_VALID')
      @_isLoginValid(@params.token, @params.rtaxi)
    .then (is_valid) =>
      if is_valid
        throw new Error('IS_VALID')

      return false
    .fail (err) ->
      if err.message is 'IS_VALID'
        return true
      else if err.message is 'NOT_DRIVER_FOUND'
        return false
      else
        log.ex err, "NOT_DRIVER_FOUND", ""
        return false

  validateLoginConstructor: (args) ->
    Q()
    .then =>
      if !config.validate_login_token_constructor
        throw new Error('IS_VALID')

      @_isLoginValid(args.token, args.rtaxi)
    .then (is_valid) =>
      if is_valid
        throw new Error('IS_VALID')

      return false
    .fail (err) ->
      if err.message is 'IS_VALID'
        return true
      else if err.message is 'NOT_DRIVER_FOUND'
        return false
      else
        log.ex err, "NOT_DRIVER_FOUND", ""
        return false

  validateLoginDriver: ->
    Q()
    .then =>
      if !config.validate_login_driver_token
        throw new Error('IS_VALID')
      @_isLoginValid(@params.token, @params.rtaxi)
    .then (is_valid) =>
      if is_valid
        throw new Error('IS_VALID')

      mongo.Driver.findOne
        driver_id: @params.id
      .exec()
    .then (driver) =>
      if not driver
        throw new Error('NOT_DRIVER_FOUND')

      driver.is_connected  = false
      driver.status = 'DISCONNECTED'
      driver.save()
    .then (driver_s) =>
      parking_v2.checkParking driver_s
    .then =>

      return false
    .fail (err) ->
      if err.message is 'IS_VALID'
        return true
      else if err.message is 'NOT_DRIVER_FOUND'
        return false
      else
        log.ex err, "NOT_DRIVER_FOUND", ""
        return false


  _isLoginValid: (token, rtaxi) ->
    Q()
    .then =>
      models.persistent_logins.find
        where:
          token   : token
          rtaxi   : rtaxi
    .then (user) =>
      if not user
        throw new Error('NOT_LOGGED_USER')

      return true
    .fail (err) ->
      if err.message not in ['NOT_LOGGED_USER']
        log.ex err, "validateLogin", ""
      return false


  closeSocket : (code, message) ->
    log.d "closeSocket"
    if @socket?
      Q()
      .then =>
        @_subscriber.punsubscribe()
        @socket.close(code, message)
      .fail (err) =>
        log.ex err, "closeSocket", ""


  onDisconnected: ->
    log.d "onDisconnected"

    Q()
    .then =>
      connection_record = new mongo.Connection()

      connection_record.db_id = @params.id
      connection_record.rtaxi = @params.rtaxi
      connection_record.kind  = @kind()
      connection_record.type  = "DISCONNECTED"

      connection_record.save()
    .then =>
      @_subscriber.punsubscribe()
    .fail (err) ->
      log.ex err, "onDisconnected", ""


  subscribe: (channel) ->
    Q()
    .then =>
      @_subscriber.subscribe channel
    .fail (err) ->
      log.ex err, "subscribe", ""


  #mensaje que viene por redis
  onRedisMessage: (channel, message) ->
    Q()
    .then =>
      @onMessage message, 'redis'
    .fail (err) ->
      log.ex err, "onRedisMessage", ""


  send_message: (message) ->
    date_format = moment().format 'MMMM Do YYYY, h:mm:ss a'
    # console.log "Here Vzla send_message"

    try

      if @socket.readyState is @socket.CLOSING
        return
      @socket.send JSON.stringify(message),(err)=>
        if err?
          # console.log "#{date_format} send_message SEND = message:#{JSON.stringify message}  error:#{err.stack}"
          # log.ex err, "send_message", "message:#{JSON.stringify message}","socket state:#{@socket.readyState}"
          @closeSocket 4000, "4000"
    catch e
      # console.log "#{date_format} send_message = message:#{JSON.stringify message}  error:#{e.stack}"
      log.ex e, "send_message", "message:#{JSON.stringify message}","socket state:#{@socket.readyState}"
      if  'not opened' in e
        # console.log "#{date_format} the socket will be close because can't send message"
        if config.send_msg_ex_force_close
          @closeSocket 4000, "4000"


  onMessage: (bytes, source = 'socket') ->
    try
      message = JSON.parse bytes
    catch
      SyntaxErrorlog.ex SyntaxError, "onMessage", "bytes: #{@bytes[..50]}(trunc 50), source: #{source}", "Malformed message"
      return

    message.source = source

    try
      if source is 'redis'
        if message.action is 'close'
          @closeSocket message.code, message.reason
          return
        @send_message message
        return

      if not message?.action?
        log.e "Unknown action in #{@constructor.name}"
        return

      if '/' in message.action
        [domain, action] = message.action.split '/'
      else
        action = message.action

      callback = @actions[action]

      if callback?
        callback.call @, message
      else
        log.e "Unknown action #{action} in #{@constructor.name}"
    catch e
      log.ex err, "getOperation", ""


  kind: ->
    return "base"


  @action = (type, callback) ->
    # Adds an entry in the class-level registry of callbacks by action type
    # See subclasses for usage
    @prototype.actions = {} unless @prototype.hasOwnProperty 'actions'
    @prototype.actions[type] = (message) ->
      Q.try =>
        promise = callback.call @, message

        record = message

        record.source = undefined
        if record.action is "driver/PullingTrips" or record.action is "driver/PullInTransaction"
          action_log = new mongo.PositionLog(record)
        else
          action_log = new mongo.DebugLog(record)

        action_log.type = "action"
        action_log.save()

        return promise

      .fail (err) =>
        log.ex err, "action", "message: #{JSON.stringify message}", "#{@kind()} #{type} #{err}"

  sendSms: (message, action) ->
    Q()
    .then =>
      mongo.Operation.find operation_id: message.opid
      .populate('place_from place_to driver option user')
      .exec()
    .then ([mg_operation]) =>
      if not mg_operation?
        log.e 'Company:CancelTrip:not operation exception'
        throw new Error 'Company:CancelTrip:not operation exception'
      operation = mg_operation
      msg = @createOperationMessage(action, message)

      bdcast = bcast.bkDest operation

      bcast.broadcastOperation(bdcast, msg)

    .fail (err) =>
      log.ex err, "sendSms", "message: #{JSON.stringify message}, action; #{action}"

  genericOperation: (message, action) ->
    msg = null
    operation = null

    Q()
    .then =>
      mongo.Operation.find
        operation_id: message.opid
      .populate('place_from place_to driver option user')
      .exec()
    .then ([mg_operation]) =>

      operation = mg_operation
      if not mg_operation?
        log.e 'Company:CancelTrip:not operation exception'
        throw new Error 'Company:CancelTrip:not operation exception'

      is_valid_to_update = tools.isValidToUpdate(mg_operation, message.status)
      operation.status = message.status

      to_update = {
        'id'    : operation.operation_id,
        'status': operation.status,
        'clazz' : tools.getClazz(operation.user),
      }
      @msg = @createOperationMessage(action, message)

      if 'HOLDINGUSER' is message.status
        operation.at_the_door_at = new Date()

      if message.amount?
        message.amount = message.amount
        if typeof message.amount is 'string'
          message.amount.replace(',','.')
        operation.amount = message.amount
        to_update.amount = message.amount

      # lo necesita setAmount,
      if operation.driver isnt null
        @msg.driver =  operation.driver.driver_id

      bdcast = bcast.bkDest operation
      if is_valid_to_update
        Q()
        .then =>
          sql.getOperationChargesForDriver
            operation_id: operation.operation_id
        .then (result)=>
          for res in result[0]
            @msg["#{res.type_charge}"] = res.charge.toFixed(2)
          operation.save()
        .then (operation_) =>
          sql.updateOperation(to_update)
        .then () =>
          message_ack_mg = data_adapter.PushMessageToMongo(mg_operation, @msg, 0)
          message_ack_mg.save()
        .then (mssg_ack) =>
          # console.log mssg_ack
          @msg.message_id = mssg_ack._id
          bcast.broadcastOperation(bdcast, @msg)
        .fail (err) =>
          # console.log "#{err}"
      else
        # console.log "is not valid to update"
        if 'driver' in action.split '/'
          Q()
          .then =>
            message_ack_mg = data_adapter.PushMessageToMongo(mg_operation, @msg, 0)
            message_ack_mg.save()
          .then (mssg_ack) =>
            @msg.message_id = mssg_ack._id
            # console.log bdcast
            bcast.broadcastToDriver(bdcast.rtaxi_id, bdcast.driver_id, @msg)
          .fail (err) =>
            # console.log "#{err}"
        else if 'company' in action.split '/'
          bcast.broadcastToAllOperators(bdcast.rtaxi_id, @msg)
        else if 'passenger'in action.split '/'
          Q()
          .then =>
            message_ack_mg = data_adapter.PushMessageToMongo(mg_operation, @msg, 0)
            message_ack_mg.save()
          .then (mssg_ack) =>
            @msg.message_id = mssg_ack._id
            bcast.broadcastToUser(bdcast.rtaxi_id, bdcast.driver_id, @msg)
          .fail (err) =>
            console.log "#{err}"


    .fail (err) =>
      msg = @createOperationMessage(action, message)
      #TODO mandarle una alerta al operador de que paso x y tal sujeto no puedo hacer la accion
      #de esta manera nos salvamos el error
      @send_message msg
      log.ex err, "genericOperation", "message: #{JSON.stringify message}, action; #{action}"

  resendOperation: (message, action) ->
    msg = null
    operation = null
    Q()
    .then =>
      mongo.Operation.find operation_id: message.opid
      .populate('place_from place_to driver option user')
      .exec()
    .then ([mg_operation]) =>

      operation = mg_operation
      if not mg_operation?
        log.e 'Company:CancelTrip:not operation exception'
        throw new Error 'Company:CancelTrip:not operation exception'

      @msg = @createOperationMessage(action, message)
      operation.status = 'PENDING'
      operation.deletetrip = true
      @msg.status      = operation.status

      @to_update = {
        'id'    : operation.operation_id,
        'status': operation.status,
        'driver': null,
        'clazz' : tools.getClazz(operation.user),
      }
      # lo necesita setAmount,
      if operation.driver isnt null
        operation.driver =  null

      @bdcast = bcast.bkDest operation

      operation.save()
    .then () =>
      sql.updateOperation(@to_update)
    .then () =>
      bcast.broadcastOperation(@bdcast, @msg)
      service.dispatchTrip operation.operation_id

    .fail (err) =>
      msg = @createOperationMessage(action, message)
      #TODO mandarle una alerta al operador de que paso x y tal sujeto no puedo hacer la accion
      #de esta manera nos salvamos el error
      @send_message msg
      log.ex err, "genericOperation", "message: #{JSON.stringify message}, action; #{action}"


  createOperationMessage: (action, original_message) ->
    return {
        'opid'  : original_message.opid,
        'status': original_message.status,
        'device': original_message.device,

        'action':  action,

        'SMS_code' : original_message.SMS_code,
        'SMS_content' : original_message.SMS_content

        'amount'  : original_message.amount

        'notification_id'           : 2003,
        'message_id'                : '5312495272a1fa62f90003cd',
        'message_need_confirmation' : true
      }




  notifyDriverStatus : (driver) ->
    log.i "notifyDriverStatus"

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")

      opId = ""
      if driver.operation_id then opId = driver.operation_id

      driver_pool = {
        'id': driver.driver_id
        'rtaxi': driver.rtaxi
        'state': driver.status
        'lat': driver.location[1]
        'lng': driver.location[0]
        'firstName': driver.first_name
        'lastName': driver.last_name
        'phone': driver.phone
        'email': driver.email
        'brandCompany': driver.brand
        'model': driver.model
        'plate': driver.plate
        'version': driver.version
        'action': 'driver/PullingTrips'
        'driverNumber': driver.email.split('@')[0]
        'updated_at': driver.updated_at
        'operation_id': opId
      }

      bcast.broadcastToAllOperators(driver.rtaxi_id, driver_pool)

      mongo.User.find
        rtaxi_id : driver.rtaxi_id
        is_connected : true
      .exec()
    .then (passengers) =>
      driver_data_simple = {
          'state': driver.status
          'lat'  : driver.location[1]
          'lng'  : driver.location[0]
          'driverNumber' : driver.email.split('@')[0]

          'message_need_confirmation' : false
          'notification_id'           : 2003

          'action'       : 'driver/PullingTrips'
      }
      for passenger in passengers
        bcast.broadcastToUser(driver.rtaxi_id, passenger.user_id, driver_data_simple)

    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "notifyDriverStatus", "driver: #{JSON.stringify driver}"


  genericAssignTrip: (message) ->
    log.i "genericAssignTrip"

    operation = null
    assigned_driver = null

    Q()
    .then =>
      service.getAndCreateDriverByEmail message.email
    .then (driver) =>
      if not driver?
        msg = {
            'action' : 'company/AssignDriverNotFound'
            'opid'   : message.opid,
            'email'  : message.email
        }
        @send_message msg
        throw new Error 'company/AnotherDriverAssigned'

      @assigned_driver = driver
      @store.getOperation message.opid
    .then (mg_operation) =>

      operation = mg_operation

      # console.log("###### Start operation ########")
      # console.log(operation)
      # console.log("###### End operation ########")

      if not mg_operation?
        log.e 'Company:AssignTrip:not operation exception'
        throw new Error 'Company:AssignTrip:not operation exception'

      if @operationUndispatchable(operation) or operation.status == 'ASSIGNEDTAXI'
        service.notifyAnotherDriverAssigned(@assigned_driver)
        throw new Error 'company/AnotherDriverAssigned'

      boundNotify = (@notifyAssignTripFailed).bind(this)

      estimated_time = 5
      if( message?.timeEstimated)
        estimated_time = parseInt( message?.timeEstimated, 10 )

      if( message?.estimated_time)
        estimated_time =  parseInt( message?.estimated_time, 10 )

      # console.log('vzla genericAssignTrip');
      service.assignTripTo operation, @assigned_driver, estimated_time, boundNotify
    .fail (err) ->
      unless err.message is 'company/AnotherDriverAssigned'
        log.ex err, "genericAssignTrip", "message: #{JSON.stringify message}"

  operationUndispatchable: (operation) ->
    isUndespatchable =  (operation.driver isnt null or operation.status in config.oper_status.cancel) and (operation.deletetrip)
    return isUndespatchable

  notifyAssignTripFailed: ->
    try
      msg = {
          'action' : 'driver/AcceptTrip',
          'message': 404
        }

      @send_message msg
    catch err
      log.ex err, "notifyAssignTripFailed"


  genericNewAudio: (message, is_for_drivers = true) ->
    if(is_for_drivers)
      message.sender_id   = parseInt(message.operator)
    else
      message.sender_id   = parseInt(message.driver)

    Q()
    .then =>
      message.is_for_drivers = is_for_drivers
      service.message_service.save_message message, 0
    .then (ac_message) =>
      msg = {
        'operator'    : message.operator,
        'driver'      : message.driver,
        'rtaxi'       : message.rtaxi,
        'filename'    : message.filename,
        'bytes'       : message.bytes,
        'bucket'      : message.bucket,
        'sender_name' : message.sender_name,
        'message_need_confirmation' : false,
        'message_id'  : "#{ac_message._id}",

        'action':'AlertNewAudioBroadcast'
      }
      if is_for_drivers
        log.d "send to drivers"
        bcast.broadcastToAllDrivers(message.rtaxi, msg)

      log.d "send to operators"
      bcast.broadcastToAllOperators(message.rtaxi, msg)

    .fail (err) =>
      log.ex err, "genericNewAudio #{err.stack} #{message} "

  genericNewAudioForOne: (message, is_for_driver = true) ->
    if(is_for_driver)
      message.sender_id   = message.operator
      if(message?.driver)
        message.receiver_id = message.driver
      if(message?.driver_id)
        message.receiver_id = message.driver_id
    else
      message.receiver_id = message.operator
      if(message?.driver)
        message.receiver_id = message.driver
      if(message?.driver_id)
        message.receiver_id = message.driver_id

    Q()
    .then =>
      service.message_service.save_message message, 1
    .then (ac_message) =>

      msg = {
        'operator'    : message.operator,
        'driver'      : "",
        'rtaxi'       : message.rtaxi,
        'filename'    : message.filename,
        'bytes'       : message.bytes,
        'bucket'      : message.bucket,
        'sender_name' : message.sender_name,
        'message_id'  : "#{ac_message._id}",
        'message_need_confirmation' : false,

        'action':'AlertNewAudioBroadcast'
      }
      bcast.broadcastToDriver(message.rtaxi_id, message.driver_id,  msg)
    .fail (err) ->
      log.ex err, "genericNewAudioForOne #{err.stack}"


  genericAckChatMessage: (message) ->
    Q()
    .then =>
      mongo.ChatMessage.findOne
        _id: message.id
      .exec()
    .then (mg_chats) =>
      if not mg_chats
        throw new Error('not_exist')
      mg_chats.recipients_ack.push @params.id
      mg_chats.save()
    .then (mg_chats_s) =>
      return mg_chats_s

    .fail (err) ->
      log.ex err, "base:ackChatReceived", "#{err.stack}"

  genericAckMessage: (message) ->
    Q()
    .then =>
      mongo.PushMessage.findOne
        _id: message.id
      .exec()
    .then (mg_chats) =>
      if not mg_chats
        throw new Error('not_exist')
      mg_chats.recipients_ack.push @params.id
      mg_chats.save()
    .then (mg_chats_s) =>
      return mg_chats_s

    .fail (err) ->
      if err.message not in ['not_exist']
        log.ex err, "base:genericAckMessage", "#{err.stack}"

  genericSendMessage: (message) ->

    Q()
    .then =>

      if message.rtaxi_id?
        message.rtaxi = message.rtaxi_id

      message.type_user_receiver = tools.getTypeUser message.type_user_receiver
      message.type_user_sender   = tools.getTypeUser message.type_user_sender

      @msg = {
        'sender_id'         : message.sender_id,
        'type_user_sender'  : message.type_user_sender ? 0,
        'recipients'        : message.recipients,
        'type_user_receiver': message.type_user_receiver ? 0,
        'rtaxi'             : message.rtaxi_id,
        'filename'          : message.filename,
        'bytes'             : message.bytes,
        'sender_name'       : message.sender_name,
        'type_message'      : message.type_message,
        'type'              : message.type,
        'message_need_confirmation' : true,
        'action':'NewMessage'
      }

      service.message_service.save_message message
    .then (ac_message) =>
      @msg.message_id = ac_message._id
      @msg.created_at = new Date()
      if(ac_message.type is 1 )
        if(ac_message.recipients.length is 1 )
          if(message.type_user_receiver is 1)
            bcast.broadcastToDriver(message.rtaxi_id, ac_message.recipients[0],  @msg)
          else
            bcast.broadcastToOperator(message.rtaxi_id, ac_message.recipients[0],  @msg)
      else
        bcast.broadcastToAllDrivers(message.rtaxi_id, @msg)
        bcast.broadcastToAllOperators(message.rtaxi_id, @msg)

    .fail (err) ->
      log.ex err, "genericSendMessage #{err.stack}"


  genericPoolDriver: (statuses_to_ignore = []) ->
    today = moment().startOf('day')
    tomorrow = moment(today).add(1, 'days')
    if not @params.rtaxi
      return
    Q()
    .then =>
      mongo.Driver.find
        rtaxi_id  : @params.rtaxi
        status    : $nin: statuses_to_ignore
        is_blocked: false
        updated_at:
          $gte: today.toDate()
          $lt: tomorrow.toDate()
      .lean().exec()
    .then (mg_driver) =>
      drivers = []

      #Search those oprations which match since yesterday (Timezone local machine uses UTC-3)
      yesterday = moment(moment().startOf('day')).subtract(1, 'days')

      for driver in mg_driver
         operation =
           mongo.Operation.findOne
             driver: driver
             status: $in: ['PENDING','INTRANSACTION','INTRANSACTIONRADIOTAXI','HOLDINGUSER','RINGUSER','ASSIGNEDRADIOTAXI','ASSIGNEDTAXI','REASIGNTRIP','SETAMOUNT','ACCEPT_TRIP_DRIVER']
             created_at:
              $gte: yesterday.toDate()
           .sort
              operation_id: -1
           .exec()

         if operation
            driver.operation_id = operation.operation_id

         drivers.push( data_adapter.DriverFromMongoToClient(driver) )

      r_message = {
        "id"     : @params.id,
        "rtaxi"  : @params.rtaxi,
        "drivers": drivers,

        "action": "#{@kind()}/PullDrivers",
      }

      @send_message r_message
    .fail (err) ->
      log.ex err, "genericPoolDriver", "#{err.stack}"
