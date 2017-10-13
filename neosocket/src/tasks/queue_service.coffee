Q         = require 'q'

mongo     = require '../dbs/mongo'
sql       = require '../dbs/sql'
bk        = require '../dbs/broadcast'
config    = require '../../config'
tools     = require '../tools'
log       = require('../log').create 'QueueService'
moment_tz    = require('moment-timezone')
moment       = require('moment')
service      = require './service'
data_adapter = require '../dbs/data_adapter'

@execute_job = () ->
  @df = moment(moment_tz().tz("America/Buenos_Aires").format());
  @df.add(moment.duration(config.bids_algorithm.moment, 'seconds'));

  Q()
  .then =>
    mongo.CompanyConfig.find
      has_driver_dispatcher_function: true
  .then (companies) =>
    Q.all(
      for company in companies
        @execute_queue_from_rtaxi company.rtaxi_id, @df
    )
  .fail (err) ->
    log.ex err, "queue_service:execute_job", "#{err.stack}"



@execute_queue_from_rtaxi = (rtaxi_id, df) =>
  Q()
  .then =>
    mongo.Operation.find
      status  : 'IN_QUEUE'
      rtaxi_id: rtaxi_id
    .populate('place_from place_to driver option user queue_drivers_obj')
    .exec()
  .then (mg_operations) =>
    Q.all(
      for operation in mg_operations
        @process_operation operation, df
    )

  .fail (err) ->
    log.ex err, "queue_service:execute_job", "#{err.stack}"

@process_operation = (operation, date_now) ->
  Q()
  .then =>
    service.getAndCreateConfig operation.rtaxi_id
  .then (config) =>
    if not config
      throw new Error("NOT_CONFIG_FOUND")

    dt = Math.round((date_now - operation.queue_date)/1000);
    trip_dispute = Math.round(config.dispute_time_trip/1000);
    console.log "MATH----- QUEUE TRIP #{dt} > #{trip_dispute} "
    if dt > trip_dispute
      console.log "DISPATCHING #{operation.queue_drivers.length}"
      if operation.queue_drivers.length is 0
        Q()
        .then =>
          @sendToPending operation
        .fail (err) ->
          log.ex err, "queue_service:process_operation.sendToPending", "#{err.stack}"
      else
        Q()
        .then =>
          mongo.Driver.find
            location: $near:
              $geometry:
                type       : "Point",
                coordinates: operation.place_from.location
            driver_id: $in: operation.queue_drivers
            status: $in: ['ONLINE','OFFLINE','DISCONNECTED']
        .then (drivers) =>
          console.log "FIRST DRIVER GET#{JSON.stringify drivers}"
          if drivers.length is 0
            Q()
            .then =>
              @sendToPending operation
            .then =>
              console.log "going to pending"
            .fail (err) ->
              log.ex err, "queue_service:process_operation:going_pending", "#{err.stack}"
          else
            if drivers.length > 1
              Q()
              .then =>
                mongo.DriverParkingQueue
                  .where('position').nin([-1])
                  .where('driver').in([drivers[0]])
                  .populate('driver parking')
                  .sort([['position', 1]])
                .exec()
              .then (drivers_parking) =>
                console.log "GET DRIVER IN PARKINGS #{drivers_parking}"
                if not drivers_parking or drivers_parking.length is 0
                  console.log('process_operation');
                  service.assignTripTo operation, drivers[0]
                else
                  Q()
                  .then =>
                    # @getBestDriverInParking drivers, drivers_parking[0], operation.place_from.location
                    @getFirstDriverInParking drivers, drivers_parking[0]
                  .then (driver) =>
                    console.log "getFIRST DRIVER IN PARKING #{drivers}"
                    if not driver
                      @sendToPending operation
                    else
                      console.log('process_operation');
                      service.assignTripTo operation, driver
                  .then =>
                    return
              .fail (err) ->
                if err.message not in ['NOT_DRIVERS_FOUND', 'INSUFFICIENT_PERMISSIONS']
                  log.ex err, "queue_service:process_operation", "#{err.stack}"

            else
              console.log('process_operation');
              service.assignTripTo operation, drivers[0]
        .fail (err) ->
          if err.message not in ['NOT_DRIVERS_FOUND', 'INSUFFICIENT_PERMISSIONS']
            log.ex err, "queue_service:process_operation", "#{err.stack}"
  .fail (err) ->
    if err.message not in ['NOT_DRIVERS_FOUND']
      log.ex err, "queue_service:process_operation", "#{err.stack}"

@getFirstDriverInParking = (drivers, parking) ->
  Q()
  .then =>
    ObjectId = require('mongoose').Types.ObjectId
    parkings = []
    driver_tuple = []
    parkings.push ObjectId("#{parking._id}")
    driver_tuple.push ObjectId("#{parking._id}") for driver in drivers
    mongo.DriverParkingQueue
    .where('position').nin([-1])
    .where('driver').in(driver_tuple)
    .where('parking').in(parkings)
    .populate('driver parking')
    .sort([['position', 'descending']])
    .exec()
  .then (drivers_parking) =>
    if not drivers_parking or drivers_parking.length is 0
      return drivers[0]
    else
      return drivers_parking[0].driver

@getBestDriverInParking = (drivers, drivers_parking, user_location) ->
  parkings = []

  ObjectId = require('mongoose').Types.ObjectId
  parkings.push ObjectId("#{dri_park.parking._id}") for dri_park in drivers_parking

  Q()
  .then =>
    mongo.Parking
    .where('_id').in(parkings)
    .where('coordinates_out').near({
        center: {
            type: 'Point',
            coordinates: user_location
        },
        maxDistance: 50000 * 1000
    })
    .exec()
  .then (parkings_sorted) =>
    if not parkings_sorted
      return drivers[0]

    sorted_parking = parkings_sorted[0]

    best_drivers = []
    for driver_par in drivers_parking
      if "#{driver_par.parking._id}" is "#{sorted_parking._id}"
        best_drivers.push driver_par

    best_sorted_drivers = best_drivers[0]
    for best_d in best_drivers
      if best_sorted_drivers.parking.position < best_d.parking.position
        best_sorted_drivers = best_d

    return best_sorted_drivers.driver

@sendToPending = (operation) ->
  @df = moment(moment_tz().tz("America/Buenos_Aires").format());
  @df.add(moment.duration(config.bids_algorithm.moment, 'seconds'));
  Q()
  .then =>
    sql.addOperationLog
      user_id     : operation.user.user_id
      operation_id: operation.operation_id
      status      : service.TRANSACTIONSTATUS.PENDING
  .then (log_operation) =>
    @mg_operation = operation

    @mg_operation.queue_date = @df.toDate()
    @mg_operation.status = service.TRANSACTIONSTATUS.PENDING
    @mg_operation.save()
  .then (mg_op) =>
    @mg_op = mg_op
    to_update = {
      'id'        : operation.operation_id,
      'status'    : service.TRANSACTIONSTATUS.PENDING,
      'clazz'     : tools.getClazz(@mg_operation.user),
      'queue_date': @df.toDate()
    }
    sql.updateOperation(to_update)
  .then () =>
    op_docu =  data_adapter.operationFromMongoToClient @mg_op
    msj_oper = {
      'operation' :op_docu,
      'is_web_user' : true,
      'is_new_user' : true,
      'action' :'web/rollback'
    }
    bk.broadcastToAllOperators operation.rtaxi, msj_oper
  .fail (err) ->
    log.ex err, "sendToPending", "operation: #{JSON.stringify operation}"
