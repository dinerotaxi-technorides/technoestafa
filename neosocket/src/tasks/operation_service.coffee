Q       = require 'q'

mongo   = require '../dbs/mongo'
sql     = require '../dbs/sql'
bk      = require '../dbs/broadcast'
config  = require '../../config'

log     = require('../log').create 'OperationService'
moment  = require 'moment'

payment      = require './payment_utils'
service      = require './service'
DataStore    = require '../dbs/data_store'
data_adapter = require '../dbs/data_adapter'
store = new DataStore


@respawnTrips = () ->
  console.log "operation_sv.respawnTrips"
  console.log "Saludos desde Vzla"
  if not config.job_respawn_trips
    console.log "NO CREATE TRIP"
    return;

  Q()
  .then () ->
    sql.findStatusOperations( [
      'INTRANSACTION','INTRANSACTIONRADIOTAXI','HOLDINGUSER','PENDING'
      'ASSIGNEDRADIOTAXI','ASSIGNEDTAXI','REASIGNTRIP','RINGUSER','IN_QUEUE'], 5, false)
  .then (operations) ->
    Q.all(
      for operation in operations
        console.log "operation to dispatch"
        add operation
    )
  .then () ->
    sql.findStatusOperations( [
      'INTRANSACTION','INTRANSACTIONRADIOTAXI','HOLDINGUSER','PENDING'
      'ASSIGNEDRADIOTAXI','ASSIGNEDTAXI','REASIGNTRIP','RINGUSER','IN_QUEUE'], 1, true)
  .then (operations) ->
    Q.all(
      for operation in operations
        console.log "operation to dispatch"
        add operation
    )
  .then () ->
    console.log "finish createTripJob"

  .fail (err) ->
    log.ex err, "operation_sv:respawnTrips", "#{err.stack}"


@add = add = (op, operation_document = {}) ->
  console.log "operation_sv.add  #{op.operation_id}"

  Q()
  .then () ->
    @_programmed_trip = data_adapter.get_programmed_trip op
    updateOperation(op.operation_id)
  .then () =>
    mongo.Operation.findOne
      operation_id: op.operation_id
    .exec()
  .then (mg_operation) =>
    if mg_operation
      throw new Error "ALREADY_EXIST"

    operation_document = new mongo.Operation
      operation_id: op.operation_id
      rtaxi_id    : op.rtaxi_id
      status      : op.status
      comments    : op.comments ? ''
      amount      : op.amount
      location    : [op.place_from_lng,op.place_from_lat ]
      device      : 'UNKNOW'

    store.getOrCreatePassenger op.user_id
  .then (user) =>
    if not user
      throw new Error "OPERATION_MALFORMED_USER"

    operation_document.user = user

    store.getOrCreateDriver op.driver_id, op.rtaxi_id
  .then (driver) =>
    operation_document.driver = driver

    store.createAddress op.p_from_json, [op.place_from_lng,op.place_from_lat ], op.place_from_street_n, op.place_from_pso, op.place_from_dto
  .then (place_from) =>
    if not place_from
      throw new Error "OPERATION_MALFORMED_PLACE_FROM"

    operation_document.place_from = place_from

    store.createAddress op.p_to_json, [ op.place_to_lng ,op.place_to_lat], op.place_to_street_n, op.place_to_floor, op.place_to_apartment
  .then (place_to) =>
    if place_to
      operation_document.place_to = place_to
    store.createOptions op
  .then (options) =>
    if not options
      throw new Error "OPERATION_MALFORMED_OPTIONS"
    operation_document.options = options

    log.op op.operation_id, op.ip, op.log_created_by,  'CREATETRIP', {'params':op, 'isProgrammedTrip': @_programmed_trip}
  .then () =>

    unless op.rtaxi_id?
      throw new Error("tried to createTrip with invalid user. Operation: #{JSON.stringify op}")

    mongo.Operation.findOne
      operation_id: op.operation_id
    .exec()
  .then (mg_operation) =>
    if mg_operation
      throw new Error "ALREADY_EXIST"
    if not op.comments
      operation_document.comments = ''

    operation_document.save()
  .then (operation_document) =>
    # console.log operation_document
    if config.job_respawn_trips_broadcast
      op.finding_driver = false
      op.estimated_time = null
      op.created_at     = moment().format 'YYYY-MM-DD hh:mm:ss a ZZ'
      op.rtaxi          = op.rtaxi_id
      msj_oper = {
        'operation' :data_adapter.operationFromMongoToClient operation_document,
        'is_web_user' : true,
        'is_new_user' : true,
        '1':1
        'action' :'newTrip'
      }
      bk.broadcastToAllOperators op.rtaxi, msj_oper
    return operation_document
  .fail (err) =>
    if err.message is 'ALREADY_EXIST' or err.name is 'MongoError' and err.code is 11000
      return
    else
      log.ex err, "operation_sv:updateOperation", "#{err.stack}"
      return ;


@findDriverInParkingV2 = (operation, parking, attempts=0) ->
  log.i "findDriverInParkingV2"
  Q()
  .then =>
    query = {
      'position':{
        '$nin':[-1]
      },
      'driver':{
        '$nin':operation.blacklisted_drivers_obj
      },
      'parking':parking
    }

    #first version of filters
    # if operation.is_corporate
    #   query.driver.is_corporate = true
    # else
    #   query.driver.is_regular = true
    #
    # if operation.option.vip
    #   schema_park.where 'driver.is_vip' : true
    # if operation.option.pet
    #   schema_park.where 'driver.is_pet' : true
    # if operation.option.airConditioning
    #   schema_park.where 'driver.is_air_conditioning' : true
    # if operation.option.smoker
    #   schema_park.where 'driver.is_smoker' : true
    # if operation.option.specialAssistant
    #   schema_park.where 'driver.is_special_assistant' : true
    # if operation.option.luggage
    #   schema_park.where 'driver.is_luggage' : true
    # if operation.option.airport
    #   schema_park.where 'driver.is_airport' : true
    # if operation.option.messaging
    #   schema_park.where 'driver.is_messaging' : true
    # if operation.option.invoice
    #   schema_park.where 'driver.is_invoice' : true
    schema_park = mongo.DriverParkingQueue.find query
    schema_park.sort([['position', 1]])
    schema_park.limit(1)
    schema_park.populate('driver parking')
    schema_park.exec()
  .then (driver_pking) =>
    if not driver_pking? or driver_pking.length is 0
      log.i "findDriverInParkingV2 go to FindDriver"
      service.findDriver operation, attempts
    else
      log.i "dispatching trip in parking "
      driver_to_dispatch = driver_pking[0].driver
      Q()
      .then =>
        log.i "findDriverInParkingV2 push in parking"
        if operation.status == "PENDING"
          operation.blacklisted_drivers.push(driver_to_dispatch.driver_id)
          operation.blacklisted_drivers_obj.push(driver_to_dispatch)

          @bkDriverNewOperation operation, driver_to_dispatch
          operation.save()

        attempts++
        Q().delay config.time_find_driver_in_parking

      .then =>
        mongo.Operation.findOne
          operation_id: operation.operation_id
        .populate('place_from place_to driver option user')
        .exec()

      .then (mg_operation) =>

        operation = mg_operation

        if operation.status == "PENDING"
          log.op operation.operation_id,'0.0.0.0', 'COMPUTER',  'DISPATCHTRIPPARKING', {'attempts':attempts, 'operation':operation, 'parking':parking}
          @findDriverInParkingV2 operation, parking, attempts

      .fail (err) =>
        log.ex err, "findDriverInParkingV2", "operation: #{JSON.stringify operation} parking: #{JSON.stringify parking}", "IN"

  .fail (err) ->
    log.ex err, "findDriverInParkingV2", "operation: #{JSON.stringify operation} parking: #{JSON.stringify parking}", "OUT"

@bkDriverNewOperation = (mg_operation, driver) ->
  log.i "bkDriverNewOperation"
  Q()
  .then =>
    @msg = {
      'operation'   : data_adapter.operationFromMongoToClient mg_operation
      'is_web_user' : mg_operation.is_web_user
      'action'      : 'newTrip'
      'is_new_user' : true

      'notification_id'           : 2000
      'message_id'                : '53152bfd72a1fa7efd0000e4'
      'message_need_confirmation' : true
      'queued'                    : false
    }
    message_ack_mg = data_adapter.PushMessageDriverToMongo(mg_operation, @msg, driver)
    message_ack_mg.save()
  .then (mssg_ack) =>
    @msg.message_id = mssg_ack._id
    bk.broadcastToDriver mg_operation.rtaxi_id, driver.driver_id, @msg

@updateOperation = updateOperation = (op_id) ->
  console.log "operation_sv.updateOperation"
  console.log "Here Vzla updateOperation"

  Q.try =>
    filter =
      id            : op_id
      send_to_socket: true
    sql.updateOperation filter
  .then () ->
    return
  .fail (err) ->
    log.ex err, "operation_sv:updateOperation", "#{err.stack}"

@addOperation = (operation_id) ->
  console.log "operation_sv.add "

  _place_from     = {}
  _place_to       = {}
  _driver_number  = null
  _reference      = null
  _device         = null
  _place_from_loc = null
  _place_to_loc   = null
  _log_created_by = null
  _programmed_trip = null
  _usr            = {}

  _options        = null
  operation_document = {}

  Q()
  .then () =>
    sql.findOperation(operation_id)
  .then (op)=>
    @op = op
    _driver_number  = @op.driver_number
    _reference      = @op.payment_reference
    _device         = @op.device
    _place_from_loc = [@op.place_from_lng,@op.place_from_lat ]
    _place_to_loc   = [ @op.place_to_lng ,@op.place_to_lat]
    _log_created_by = data_adapter.get_created_by @op
    _programmed_trip = data_adapter.get_programmed_trip @op
    _usr            = {}

    _options        = @op.options

    @updateOperation(@op.operation_id)
  .then () =>
    mongo.Operation.findOne
      operation_id: @op.operation_id
    .exec()
  .then (mg_operation) =>
    if mg_operation
      throw new Error "ALREADY_EXIST"

    store.getOrCreatePassenger @op.user_id
  .then (user) =>
    _usr = user

    store.createAddress @op.p_from_json, _place_from_loc, @op.place_from_street_n, @op.place_from_pso, @op.place_from_dto
  .then (place_from) =>
    _place_from = place_from

    store.createAddress @op.p_to_json, _place_to_loc, @op.place_to_street_n, @op.place_to_floor, @op.place_to_apartment
  .then (place_to) =>
    _place_to = place_to

    store.createOptions op
  .then (options) =>
    _options = options

    log.op @op.operation_id, @op.ip, @op.log_created_by,  'RE_CREATETRIP', {'params':op, 'isProgrammedTrip': _programmed_trip}
  .then () =>
    unless @op.rtaxi?
      throw new Error("tried to createTrip with invalid user. Operation: #{JSON.stringify op}")

    payment.validateTripPayment @op.rtaxi, _place_from_loc, _place_to_loc, _reference
  .then (payment_ok) =>
    unless payment_ok
      throw new Error("tried to createTrip with invalid payment. Reference: #{_reference}")

    mongo.Operation.findOne
      operation_id: @op.operation_id
    .exec()
  .then (mg_operation) =>
    if mg_operation
      throw new Error "ALREADY_EXIST"

    operation_document = mg_operation

    if not  @op.comments
      @op.comments = ''

    unless mg_operation?
      operation_document = new mongo.Operation
        operation_id: @op.operation_id
        rtaxi_id    : @op.rtaxi

        status  : @op.status
        comments: @op.comments
        amount  : @op.amount

        location: _place_from_loc

        device  : _device

        place_from: _place_from
        place_to  : _place_to
        option    : _options
        user      : _usr
    mongo.Payment.findOne
      reference: _reference
    .exec()
  .then (payment) =>
    if payment?
      operation_document.amount = payment.amount

    operation_document.save()
  .then (op_doc) =>
    operation_document = op_doc

    console.log "#{err}" if err?


  .fail (err) =>
    if err.message is 'ALREADY_EXIST'
      @updateOperation(@op.operation_id)
    else if err.name is 'MongoError' and err.code is 11000
      @updateOperation(@op.operation_id)
    else
      log.ex err, "operation_sv:updateOperation", "#{err.stack}"
    return ;
