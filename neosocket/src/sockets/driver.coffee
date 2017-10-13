Q      = require 'q'

redis  = require '../dbs/redis'
mongo  = require '../dbs/mongo'
sql    = require '../dbs/sql'
data_adapter    = require '../dbs/data_adapter'
bcast    = require '../dbs/broadcast'

base   = require './base'

service    = require '../tasks/service'
parking    = require '../tasks/parking_service'
parking_v2 = require '../tasks/driver_parking_queue'

config = require '../../config'
tools  = require '../tools'
moment = require('moment')
log    = require('../log').create 'Driver'


NO_OPERATION      = "no_operation"

class @DriverHandler extends base.BaseHandler
  log: log.create 'DriverHandler'

  kind: =>
    return "driver"

  onConnected: ->
    super
    Q()
    .then =>
    #this line kill another user connected

      tools.closeConnection 'driver', @params.rtaxi, @params.id
    # .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      mongo.Driver.findOne
        driver_id: @params.id
      .exec()
    .then (driver) =>
      # Read or init mongo data:
      @driver = driver ?
        new mongo.Driver
          driver_id: @params.id
          rtaxi_id : @params.rtaxi ? 0

      sql.findDriver id: @params.id
    .then ([user]) =>
      # Read SQL data:
      @driver.first_name = user.first_name ? ''
      @driver.last_name  = user.last_name  ? ''
      @driver.email      = user.email      ? ''
      @driver.phone      = user.phone      ? ''
      @driver.model      = user.model   ? ''
      @driver.brand      = user.brand   ? ''
      @driver.plate      = user.plate   ? ''

      mongo.Operation.findOne
        driver: @driver
      .sort
        operation_id: -1
      .exec()
    .then (operation) =>
      @operation = operation
      # Read ws query string data:
      @driver.token   = @params.token   ? ''
      @driver.serial  = @params.serial  ? ''
      @driver.version = @params.version ? ''

      {lat, lng} = @params

      @driver.location = [
        if lng? and -180 < lng < 180 then lng else 0.0
        if lat? and  -90 < lat < 90  then lat else 0.0
      ]

    .then =>
      @driver.status = 'ONLINE'

      if @operation?
        finished_states = config.oper_status.cancel.concat(config.oper_status.completed)
        if @operation.status in finished_states
          operation =
            action: 'company/FinishTrip'
            opid  : @operation.operation_id
            amount: @operation.amount
            message_id: 1
            message_need_confirmation: false

          @send_message operation
        else
          log.op @operation.operation_id, @params.ip, 'DRIVER',  'ONCONNECTED', @params
          if @operation.status in config.oper_status.in_tx
            @driver.status = 'INTRAVEL'
          else
            @driver.status = 'SEARCHINGPASSENGER'

      @driver.device_key  = @params.device_key  ? @driver.device_key
      @driver.device_type = @params.device_type ? @driver.device_type
      @driver.save()
      #replace to baseHandler in all Handlers
      @channels = bcast.driverChannels(@params.rtaxi, @params.id)

      for channel in @channels
        @subscribe channel

      @notifyDriverStatus @driver


      @logDriverConnection @driver
      log.d "Driver connection ok #{@driver.driver_id}"
    .fail (err) =>
      if err.message is not 'INVALID_TOKEN'
        # console.log  "connect driver #{err} #{JSON.stringify @params}"
        @closeSocket 4000, "4000"
        log.ex err, "onConnected", ""


  closeSocket: (code, message) ->
    if config.parking?
      Q()
      .then =>
        mongo.Driver.findOne
          driver_id: @params.id
        .exec()
      .then (driver) =>
        @parkingQueue driver

        @logDriverOperation driver, 'closeSocket', @params
        @logDriverConnection driver

      .fail (err) =>
        log.ex err, "closeSocket", "code: #{@code}, message: #{message}"

    super


  onDisconnected: ->
    super

    log.d "Connection closed"

    Q()
    .then =>
      mongo.Driver.findOne
        driver_id: @params.id
      .exec()
    .then (driver) =>
      driver.is_connected  = false
      driver.status = 'DISCONNECTED'

      @notifyDriverStatus driver
      @logDriverOperation driver, 'onDisconnected', @params
      @logDriverConnection driver
      driver.save()
    .then (driver) =>
      return
      # if config.parking_v2
      #   console.log ":logout driver #{driver.email}"
      #   # parking_v2.removeDriverFromAllParkings driver
      # else
        # parking.removeDriverFromAllParkings driver.driver_id, driver.rtaxi_id, false

    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "onDisconnected", ""

  logDriverOperation : (driver,method_s,params) ->

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      mongo.Operation.findOne
        driver: driver
      .sort
        operation_id: -1
      .exec()
    .then (operation) =>
      finished_states = config.oper_status.cancel.concat(config.oper_status.completed)
      if operation? and operation.status not in finished_states
        log.op operation.operation_id,  @params.ip,'DRIVER',  method_s, params
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "logDriverOperation", ""


  logDriverConnection : (driver) ->
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      logdriver = new mongo.DriverConnectionLog
        driver_id: driver.driver_id
        location : driver.location
        status   : driver.status

      logdriver.save()
    .then =>
      log.i "logDriverConnection:OK"
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "logDriverOperation", ""


  parkingQueue:(driver) ->
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      parking.checkParking driver
    .then =>
      parking_v2.checkParking driver
    .then =>
      log.i "sucess"
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "parkingQueue", "driver: #{JSON.stringify driver}"


  validateToken: (token, operation) ->
    if token != @params.token
      throw new Error("Invalid Token")

    if token != operation.driver.token
      throw new Error("Invalid Token for operation")


  @action 'AlertNewAudioBroadcast', (message) ->
    log.d "Driver:AlertNewAudioBroadcast: #{message}"

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
      message.sender_name = "#{@driver.email} - #{@driver.first_name} #{@driver.last_name}"
      if config.walkie_talkie
        @genericNewAudio message, false
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "AlertNewAudioBroadcast", ""

  @action 'SendMessage', (message) ->
    # console.log JSON.stringify message
    log.d "SendMessage : #{message}"

    Q()
    .then =>
    #   @validateLoginDriver()
    # .then (login_is_valid) =>
    #   unless login_is_valid
    #     @closeSocket 4001, "Invalid User"
    #     throw new Error("INVALID_TOKEN")
      message.sender_name = "#{@driver.email} - #{@driver.first_name} #{@driver.last_name}"
      # console.log config.walkie_talkie
      if config.walkie_talkie
        @genericSendMessage message
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "SendMessage", ""

  @action 'ackChatReceived', (message) ->
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      @genericAckChatMessage message
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "SendMessage", ""


  @action 'ackMessageReceived', (message) ->
    # console.log "ackMessageReceived"

  @action 'ackPushMessageReceived', (message) ->
    # console.log "PUSH MESSAGE2 #{JSON.stringify message}"
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      @genericAckMessage message
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "SendMessage", ""


  @action 'ReadMessage', (message) ->
    log.d "Driver:ReadMessage: #{message}"


  @action 'Pong', (message) ->
    # console.log "PONG #{message}"
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      service.fc_service.log_wave message
    .then =>
      service.updateDriverByPing message, @params.id
    .then (driver) =>
      @driver = driver

    .fail (err) ->
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "Driver:Pong ", "#{JSON.stringify message}"

  @action 'RejectTrip', (message) ->
    log.d "Driver:RejectTrip: #{message}"
    # console.log ("Here Vzla RejectTrip")
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.REJECT_TRIP_DRIVER
    .then (log_operation) =>
      log.op message.opid, @params.ip, 'DRIVER',  service.TRANSACTIONSTATUS.REJECT_TRIP_DRIVER, message
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "Driver:RejectTrip ", "#{JSON.stringify message}"

  @action 'AssignTrip', (message) ->
    log.d "AssignTrip : #{JSON.stringify message}"
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'OPERATOR',  service.TRANSACTIONSTATUS.ASSIGNEDTAXI, message
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.ASSIGNEDTAXI
    .then (log_operation) =>
      console.log('because AssignTrip')
      @genericAssignTrip message
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN']
        log.ex err, "AssignTrip", ""


  @action 'joinToQueue', (message) ->
    log.d "joinToQueue : #{JSON.stringify message}"
    # console.log "joinToQueue"
    msg =
      action: 'driver/JoinToQueue'
      opid  : message.operation_id
      message_need_confirmation: false

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      mongo.Driver.findOne
        driver_id: @params.id
      .exec()
    .then (mg_driver) =>
      @mg_driver = mg_driver

      mongo.Operation.findOne
        operation_id: message.operation_id
        rtaxi_id    : @params.rtaxi
        status      : 'IN_QUEUE'
      .populate('place_from place_to driver option user')
      .exec()

    .then (mg_operation) =>
      @mg_operation = mg_operation
      if not mg_operation
        throw new Error(NO_OPERATION)
      operation = mg_operation
      log.op message.opid, @params.ip, 'DRIVER',  service.TRANSACTIONSTATUS.IN_QUEUE, message
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.IN_QUEUE
    .then (log_operation) =>
      # add date to subast
      # @mg_operation.queue_date = new Date()

      @mg_operation.queue_drivers.push(@mg_driver.driver_id)
      @mg_operation.queue_drivers_obj.push(@mg_driver)
      @mg_operation.save()
    .then (_mg_save_op) =>
      bcast.broadcastToDriver(@params.rtaxi, @params.id, msg)

    .fail (err) =>
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "addToQueue", ""

  @action 'addToQueue', (message) ->
    log.d "addToQueue : #{JSON.stringify message}"

    ajust = config.ajust_my_sql_clock
    @dftome_b = new Date()
    @dftome_b.setSeconds(@dftome_b.getSeconds() - ajust)
    # console.log "addToQueue #{@dftome_b.getTime()}"
    @dftome = new Date(@dftome_b.getTime())

    # console.log "addToQueue #{JSON.stringify message} #{@dftome}"
    msg =
      action: 'driver/AcceptQueue'
      opid  : message.operation_id
      message_need_confirmation: false

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      mongo.Driver.findOne
        driver_id: @params.id
      .exec()
    .then (mg_driver) =>
      @mg_driver = mg_driver
      mongo.Operation.findOne
        operation_id: message.operation_id
        rtaxi_id    : @params.rtaxi
        status      : 'PENDING'
      .populate('place_from place_to driver option user')
      .exec()
    .then (mg_operation) =>
      @mg_operation = mg_operation

      if not mg_operation
        throw new Error(NO_OPERATION)

      operation = mg_operation
      log.op message.opid, @params.ip, 'DRIVER',  service.TRANSACTIONSTATUS.IN_QUEUE, message

      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.IN_QUEUE
    .then (log_operation) =>
      @mg_operation.queue_date = new Date()

      @mg_operation.queue_drivers.push(@mg_driver.driver_id)
      @mg_operation.queue_drivers_obj.push(@mg_driver)
      @mg_operation.status = service.TRANSACTIONSTATUS.IN_QUEUE
      @mg_operation.save()
    .then (_mg_save_op) =>
      to_update = {
        'id'        : message.operation_id,
        'status'    : service.TRANSACTIONSTATUS.IN_QUEUE,
        'clazz'     : tools.getClazz(@mg_operation.user),
        'queue_date': @dftome
      }
      # console.log to_update
      sql.updateOperation(to_update)
    .then () =>
      bcast.broadcastToAllDrivers(@params.rtaxi, msg)
      # console.log "BROADCAST DRIVERS"
      log.d "send to operators"
      bcast.broadcastToAllOperators(@params.rtaxi, msg)
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "addToQueue", ""


  @action 'RejectTripOnQueue', (message) ->
    log.d "Driver:RejectTripOnQueue: #{message}"
    # console.log ("Here Vzla RejectTripOnQueue")

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.REJECT_TRIP_QUEUE_DRIVER
    .then (log_operation) =>
      log.op message.opid, @params.ip, 'DRIVER', service.TRANSACTIONSTATUS.REJECT_TRIP_QUEUE_DRIVER, message
    .fail (err) =>
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "RejectTripOnQueue", ""


  @action 'PullingTrips', (message) ->

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      service.updateDriverByPing message, @params.id
    .then (driver) =>
      @driver = driver

      service.getAndCreateConfig @params.rtaxi
    .then (cfg) =>
      #This part check if the driver is in one operation if that is correct ignore the pull out of the operation
      @cfg = cfg
      if config.parking and @cfg.parking
        @parkingQueue @driver

      #Search those oprations which match since yesterday (Timezone local machine uses UTC-3)
      mongo.Operation.findOne
        driver: @driver
        status: $in: ['PENDING','INTRANSACTION','INTRANSACTIONRADIOTAXI','HOLDINGUSER','RINGUSER','ASSIGNEDRADIOTAXI','ASSIGNEDTAXI','REASIGNTRIP','SETAMOUNT','ACCEPT_TRIP_DRIVER']
        created_at:
          $gte: moment(moment().startOf('day')).subtract(1, 'days').toDate()
      .sort
          operation_id: -1
      .exec()
    .then (operation) =>
      if operation
        @driver.operation_id = operation.operation_id

      @notifyDriverStatus @driver
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "PullingTrips ", "#{JSON.stringify message}"


  @action 'PullInTransaction', (message) ->
    log.d "Driver:PullInTransaction: #{message}"
    if not message.opid? or message.opid is ""
      log.w "PullInTransaction without transaction"
      return
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'DRIVER',  'UPDATEDRIVERPOSITION', message
      log.i message.id
    .then =>
      mongo.Operation.findOne
        operation_id: message.opid
      .populate('place_from place_to driver option user')
      .exec()
    .then (mg_operation) =>

      @mg_operation = mg_operation

      if not mg_operation?
        log.e "Driver:PullInTransaction:not operation exception #{JSON.stringify message}. Caller was #{@params.email}, v:#{@params.version}"
        @closeSocket 3000, "3000"
        throw new Error "Driver:PullInTransaction:not operation exception #{JSON.stringify message}"

      mongo.Driver.findOne
        driver_id: @params.id
      .exec()
    .then (driver) =>
      @driver = driver

      if not @driver?
        log.e "updateDriverPosition:not driver exception #{JSON.stringify message}"
        @closeSocket 4000, "4000"
        throw new Error "updateDriverPosition:not driver exception #{JSON.stringify message}"

      @driver.location = [
        if message.lng? and -180 < message.lng < 180 then message.lng else 0.0
        if message.lat? and  -90 < message.lat < 90  then message.lat else 0.0
      ]

      @driver.status   = message.state
      @driver.is_connected = true
      service.fc_service.process_fare_driver_realtime message, @driver, @mg_operation
    .then (car_status) =>
      @driver.car_status = car_status
      @driver.save()
    .then (driver_saved) =>
      #Search those oprations which match since yesterday (Timezone local machine uses UTC-3)
      mongo.Operation.findOne
        driver: @driver
        status: $in: ['PENDING','INTRANSACTION','INTRANSACTIONRADIOTAXI','HOLDINGUSER','RINGUSER','ASSIGNEDRADIOTAXI','ASSIGNEDTAXI','REASIGNTRIP','SETAMOUNT','ACCEPT_TRIP_DRIVER']
        created_at:
          $gte: moment(moment().startOf('day')).subtract(1, 'days').toDate()
      .sort
          operation_id: -1
      .exec()
    .then (operation) =>
      if operation
        @driver.operation_id = operation.operation_id

      msg = data_adapter.DriverFromMongoToClient @driver
      msg.action = 'driver/PullInTransaction'
      msg.message_need_confirmation = false

      bdcast = bcast.bkDest @mg_operation
      bcast.broadcastLocationDriver bdcast, msg

    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "PullInTransaction",  "#{JSON.stringify message}"


  @action 'Ping', (message) ->
    log.d "Ping : #{message}"

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      service.fc_service.log_wave message
    .then =>
      mongo.Driver.find
        driver_id:@params.id
      .exec()
    .then ([driver]) =>
      driver.is_connected = true
      driver.save()
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "Ping", ""


  @action 'AcceptTrip', (message) ->

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")

      console.log('+++++++++++++++');
      console.log(message);
      console.log('+++++++++++++++');

      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.ACCEPT_TRIP_DRIVER

    .then (log_operation) =>

      message.timeEstimated = 5
      console.log('because AcceptTrip')
      @genericAssignTrip message

    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "AcceptTrip", ""

  @action 'HoldingUser', (message) ->
    log.d "Driver:HoldingUser: #{message}"

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'DRIVER',  'WAITINGUSER', message
      service.fc_service.log_wave message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.HOLDINGUSER
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/HoldingUser"

    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "HoldingUser", ""


  @action 'CancelTrip', (message) ->
    log.d "CancelTrip : #{message}"
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'DRIVER',  'CANCELTRIP', message
      msg_reason = ''
      if message.reason
        msg_reason = message.reason

      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        reason      : msg_reason
        code        : 1
        status      : service.TRANSACTIONSTATUS.CANCELED_DRIVER
    .then (log_operation) =>
      service.getAndCreateConfig @params.rtaxi
    .then (cfg) =>
      if cfg.driver_cancel_trip
        message.status = 'CANCELED_DRIVER'
        @genericOperation message, "#{@kind()}/CancelTrip"
      else
        @resendOperation message, "#{@kind()}/ResendTrip"

        msg = @createOperationMessage("#{@kind()}/CancelTrip" , message )

        @send_message msg

    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "CancelTrip", ""


  @action 'FinishTrip', (message) ->
    log.d "FinishTrip : #{message}"
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid,  @params.ip,'DRIVER',  service.TRANSACTIONSTATUS.COMPLETED, message
      service.fc_service.log_wave message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.COMPLETED
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/FinishTrip"
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "FinishTrip", ""


  @action 'SetAmount', (message) ->
    log.d "SetAmount : #{message}"
    # console.log message
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'DRIVER',  service.TRANSACTIONSTATUS.SETAMOUNT, message
      service.fc_service.add_additionals message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.SETAMOUNT
    .then (log_operation) =>
      #Search the Operation to find the Company ID 'rtaxi'
      sql.findOperation message.opid
    .then ([operation]) =>
      #If the operation exists, returns the record or otherwise throws an exception
      if not operation?
        throw new Error (NO_OPERATION)
      else
        message.device = operation.device
        sql.findConfigBy
          id : operation.rtaxi_id
    .then ([config_app]) =>
      #Double check if company has CC payment mode enabled
      if config_app?
        #Due NetPay or Paypal is active keeps the operation in SETAMOUNT status
        if config_app.has_mobile_payment[0] == 1 or config_app.paypal[0] == 1
          message.status =  service.TRANSACTIONSTATUS.SETAMOUNT
      else
        message.status =  service.TRANSACTIONSTATUS.COMPLETED

      @genericOperation message, "#{@kind()}/SetAmount"
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "SetAmount", ""

  @action 'RingUser', (message) ->
    log.d "RingUser : #{message}"

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'DRIVER',  service.TRANSACTIONSTATUS.RINGUSER, message
      service.fc_service.log_wave message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.RINGUSER
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/RingUser"
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "RingUser", ""

  @action 'updateDriverPosition', (message) ->
    log.d "updateDriverPosition : #{message}"
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'DRIVER',  'UPDATEDRIVERPOSITION', message
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "updateDriverPosition", ""

  @action 'InTransactionTrip', (message) ->
    log.d "InTransactionTrip : #{message}"
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'DRIVER',  service.TRANSACTIONSTATUS.INTRANSACTION, message
      service.fc_service.log_wave message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.INTRANSACTION
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/InTransactionTrip"
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "InTransactionTrip", ""

  @action 'sendSms', (message) ->
    log.d "sendSms"

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")
      log.op message.opid, @params.ip, 'DRIVER',  'SENDSMS', message
      @sendSms message, "#{@kind()}/sendSms"
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "sendSms", ""




  @action 'PaymentStarted', (message) ->
    log.d "PaymentStarted : #{message}"

    operation = null

    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")

      log.op message.opid, @params.ip, 'DRIVER',  'PAYMENTSTARTED', message
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

          'message_id'                : '53161f3e72a1fa9803000104',
          'message_need_confirmation' : true
        }
      bcast.broadcastToUser(operation.rtaxi_id, operation.user.user_id, msg)
    .fail (err) ->
      log.ex err, "PaymentStarted", ""


  @action 'getOperation', (message) ->
    log.d "getOperation : #{message}"
    Q()
    .then =>
      @validateLoginDriver()
    .then (login_is_valid) =>
      unless login_is_valid
        @closeSocket 4001, "Invalid User"
        throw new Error("INVALID_TOKEN")

      mongo.Driver.findOne
        driver_id: @params.id
      .exec()
    .then (driver) =>
      finished_states = config.oper_status.cancel.concat(config.oper_status.completed)

      mongo.Operation.findOne
        status:
          $nin: finished_states
        driver: driver
        created_at:
          $gte: moment(moment().startOf('day')).subtract(1, 'days').toDate()
          $lt: moment(moment().startOf('day')).add(1, 'days').toDate()
      .populate('driver place_from place_to user option')
      .sort
        operation_id: -1
      .lean()
      .exec()
    .then (operation) =>
      if operation? and  operation.driver? and operation.driver.driver_id is @driver.driver_id
        log.op operation.operation_id, @params.ip, 'DRIVER',  'getOperation', message
        operation = data_adapter.operationFromMongoToClient operation

        operation.action = "getOperation"
        operation.message_id = '53161f3e72a1fa9803000106'
        operation.message_need_confirmation = false
        @send_message operation

        return
    .fail (err) ->
      if err.message not in ['INVALID_TOKEN',NO_OPERATION]
        log.ex err, "getOperation", ""
