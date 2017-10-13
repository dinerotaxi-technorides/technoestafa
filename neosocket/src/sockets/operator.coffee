Q      = require 'q'
moment = require 'moment'

base    = require './base'
service = require '../tasks/service'

redis = require '../dbs/redis'
mongo = require '../dbs/mongo'
sql   = require '../dbs/sql'
data_adapter = require '../dbs/data_adapter'
bcast    = require '../dbs/broadcast'

config = require '../../config'
tools  = require '../tools'

log = require('../log').create 'Sockets'


class @OperatorHandler extends base.BaseHandler
  log: log.create 'OperatorHandler'

  onConnected: ->
    super
    #this line kill another user connected
    Q()
    .then =>
      @params.id = parseInt(@params.id)
      @params.rtaxi = parseInt(@params.rtaxi)
      @params.company_id = parseInt(@params.id)
      tools.closeConnection 'operator', @params.rtaxi, @params.id

      log.d "OperatorHandler:onConnected"
      # ...
      mongo.Company.findOne
        company_id: @params.id
      .exec()
    .then (company) =>
      # Read or init mongo data:
      @company = company ?
        new mongo.Company
          company_id    : @params.id
          rtaxi_id      : @params.rtaxi ? 0
      @company.device_key  = @params.device_key  ? @company.device_key
      @company.device_type = @params.device_type ? @company.device_type
      @company.is_connected  = true
      @company.save()
    .then (company_) =>

      @channels = bcast.operatorChannels(@params.rtaxi, @params.id)

      for channel in @channels
        @subscribe channel

      @readTrips("")
    .fail (err) =>
      @closeSocket 4000, "4000"


  onDisconnected: ->
    log.d "OperatorHandler:onDisconnected"
    super
    Q()
    .then =>
      mongo.Company.findOne
        company_id: @params.id
      .exec()
    .then (company) =>
      if company
        company.is_connected  = false
        company.save()
    .fail (err) =>
      log.ex err, "onDisconnected", ""


  kind: =>
    super
    return "company"


  @action 'Ping', (message) ->
    log.d "Ping : #{message}"

    Q()
    .then =>
      service.updateOperatorByPing message, @params.id
    .fail (err) =>
      log.e "OperatorHandler:Ping : #{err} #{JSON.stringify message} #{@params.id}"


  @action 'Pong', (message) ->
    Q()
    .then =>
      service.updateOperatorByPing message, @params.id
    .fail (err) =>
      log.e "OperatorHandler:Ping : #{err} #{JSON.stringify message} #{@params.id}"

  @action 'PullTrips', (message) ->
    log.d "id #{@params.id} pulling trips: #{message}"

    Q()
    .then =>
      @readTrips(message)
    .fail (err) =>
      log.ex err, "PullTrips", ""

#lee los datos de la base y se lo envia al cliente
  readTrips: (message) ->
    log.d "populate trips"
    Q()
    .then =>

      today     = moment().startOf('day')
      yesterday = moment(today).subtract(1, 'days')
      mongo.Operation.find
        rtaxi_id: @params.rtaxi
        status:
          $nin: ['']
        created_at:
          $gt: yesterday.toDate()
      .populate('place_from place_to driver option user')
      .exec()
    .then (mg_operations) =>
      compose_operation = []

      for op in mg_operations
        #if op.status in ['PENDING', 'ASSIGNEDTAXI', 'HOLDINGUSER', 'INTRANSACTION']
        compose_operation.push(data_adapter.operationFromMongoToClient op)

      message = {
        'id'        : @params.id,
        'rtaxi'     : @params.rtaxi,
        'operations': compose_operation,

        'action': "#{@kind()}/PullTrips",
      }
      @send_message message
    .fail (err) =>
      log.ex err, "readTrips", ""


  @action 'PullDrivers', (message) ->
    log.d "PullDrivers : #{message}"
    Q.try =>
      @genericPoolDriver()
    .fail (err) ->
      log.ex err, "PullDrivers", ""


  @action 'AssignTrip', (message) ->
    log.d "AssignTrip : #{JSON.stringify message}"
    Q()
    .then =>
      log.op message.opid, @params.ip, 'OPERATOR', service.TRANSACTIONSTATUS.ASSIGNEDTAXI, message
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.ASSIGNEDTAXI
    .then (log_operation) =>
      @genericAssignTrip message
    .fail (err) =>
      log.ex err, "AssignTrip", ""

  @action 'HoldingUser', (message) ->
    log.d "Driver:HoldingUser: #{message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'OPERATOR',  service.TRANSACTIONSTATUS.HOLDINGUSER, message
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.HOLDINGUSER
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/HoldingUser"
    .fail (err) =>
      log.ex err, "HoldingUser", ""


  @action 'CancelTrip', (message) ->
    log.d "CancelTrip : #{message}"
    Q()
    .then =>
      log.op message.opid, @params.ip, 'OPERATOR',  service.TRANSACTIONSTATUS.CANCELED_EMP, message
      message.status =  service.TRANSACTIONSTATUS.CANCELED_EMP
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        reason      : message.reason
        status      : service.TRANSACTIONSTATUS.CANCELED_EMP
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/CancelTrip"
    .fail (err) =>
      log.ex err, "CancelTrip", ""


  @action 'FinishTrip', (message) ->
    log.d "FinishTrip : #{message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'OPERATOR',  service.TRANSACTIONSTATUS.COMPLETED, message
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
      service.fc_service.log_wave message
    .then =>
      message.status = "COMPLETED"
      service.fc_service.log_wave message
    .then =>
      log.op message.opid, @params.ip, 'OPERATOR',  service.TRANSACTIONSTATUS.SETAMOUNT, message
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.SETAMOUNT
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/SetAmount"
    .fail (err) =>
      log.ex err, "SetAmount", ""


  @action 'RingUser', (message) ->
    log.d "RingUser : #{message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'OPERATOR',  service.TRANSACTIONSTATUS.RINGUSER, message
      service.fc_service.log_wave message
    .then =>
      sql.addOperationLog
        user_id     : @params.id
        operation_id: message.opid
        status      : service.TRANSACTIONSTATUS.RINGUSER
    .then (log_operation) =>
      @genericOperation message, "#{@kind()}/RingUser"
    .fail (err) =>
      log.ex err, "RingUser", ""


  @action 'InTransactionTrip', (message) ->
    log.d "InTransactionTrip : #{message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'OPERATOR',  service.TRANSACTIONSTATUS.INTRANSACTION, message
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


  @action 'ReadMessage', (message) ->
    log.d "ReadMessage : #{message}"


  @action 'PullAllDrivers', (message) ->
    log.d "PullAllDrivers : #{message}"


  @action 'findDriver', (message) ->
    log.d "findDriver : #{JSON.stringify message}"

    Q()
    .then =>
      log.op message.opid, @params.ip, 'OPERATOR',  'FINDDRIVER', message
      service.dispatchTrip message.opid
    .fail (err) ->
      log.ex err, "findDriver", ""


  @action 'AlertNewAudioBroadcast', (message) ->
    log.d "AlertNewAudioBroadcast : #{message}"

    Q()
    .then =>
      message.sender_name = "#{@params.first_name} #{@params.last_name}"
      if config.walkie_talkie
        @genericNewAudio message, true
    .fail (err) =>
      log.ex err, "AlertNewAudioBroadcast", ""

  @action 'AlertNewDriverAudioBroadcast', (message) ->
    log.d "AlertNewDriverAudioBroadcast : #{message}"

    Q()
    .then =>
      message.sender_name = "#{@params.first_name} #{@params.last_name}"
      if config.walkie_talkie
        @genericNewAudioForOne message, true
    .fail (err) =>
      log.ex err, "AlertNewAudioBroadcast", ""

  @action 'SendMessage', (message) ->
    log.d "SendMessage : #{message}"

    Q()
    .then =>
      message.sender_name = "#{@params.first_name} #{@params.last_name}"
      if config.walkie_talkie
        @genericSendMessage message
    .fail (err) =>
      log.ex err, "SendMessage", ""

  @action 'ackChatReceived', (message) ->
    @genericAckChatMessage message

  @action 'ackMessageReceived', (message) ->
    # @genericAckMessage message
    console.log "ack"

  @action 'ackPushMessageReceived', (message) ->
    @genericAckMessage message

  @action 'newTextNotification', (message) ->
    log.d "newTextNotification : #{message}"

    Q()
    .then =>
      @send_message message
    .fail (err) =>
      log.ex err, "newTextNotification", ""

  @action 'expireTextNotification', (message) ->
    log.d "expireTextNotification : #{message}"

    Q()
    .then =>
      @send_message message
    .fail (err) =>
      log.ex err, "expireTextNotification", ""


  @action 'sendSms', (message) ->
    log.d "sendSms"

    msg = {
      'SMS_content' : message.SMS_content,
      'sender_name' : "#{@params.first_name} #{@params.last_name}"

      'message_id'  : '5312010e72a1fa62f900012e',

      'action'  : "#{@kind()}/sendSms"
    }

    if message.email?
      Q()
      .then =>
        @store.getDriverByEmail(message.email)
      .then (driver) =>
        log.op message.opid, @params.ip, 'OPERATOR',  'SENDSMS', message
        bcast.broadcastToDriver(@params.rtaxi, driver.driver_id, msg)
      .fail (err) =>
        log.ex err, "sendSms", "message: #{JSON.stringify message}"
    else
      Q()
      .then =>
        bcast.broadcastToAllDrivers(@params.rtaxi, msg)
      .fail (err) =>
        log.ex err, "sendSms", ""
