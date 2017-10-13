###
Parking class, this class take the responsabilitiy for the parking and manage the queue.
###
M      = require 'mongoose'

mongo    = require '../dbs/mongo'
sql      = require '../dbs/sql'
bk       = require '../dbs/broadcast'
service  = require './service'
config   = require '../../config'
tools    = require '../tools'

Q      = require 'q'
log    = require('../log').create 'ParkingService'


NO_QUEUE    = "no queue"


@checkParking = (driver) ->
  log.i "checking parking queue #{driver.status}"
  if driver.status is 'ONLINE'
    @updateParkingStatus driver
  else
    @removeDriverFromAllParkings driver.driver_id, driver.rtaxi_id

@getParkingByDriver = (driver, cfg) ->
  Q()
  .then =>
    if cfg.parking_polygon
      Q()
      .then =>
        query = {
          "coordinates_in": {
            "$geoIntersects": {
              "$geometry": {
                "type": "Point",
                "coordinates": driver.location
              }
            }
          },
          "rtaxi_id"  : driver.rtaxi_id,
          "is_polygon": true,
          "business_model":{
            "$in":driver.business_model
          }
        }
        query = mongo.Parking.find query
        query.exec()
      .then (parking) =>
        return parking
    else
      Q()
      .then =>
        mongo.Parking.find
          location: $near:
            $geometry:
              type       : "Point",
              coordinates: driver.location
            $maxDistance: cfg.parking_distance_driver
          rtaxi_id: driver.rtaxi_id
      .then (parking) =>
        return parking

@getParkingByUser = (location, cfg, rtaxi_id, business_model) ->
  Q()
  .then =>
    if cfg.parking_polygon
      Q()
      .then =>
        query = {
          "coordinates_out": {
            "$geoIntersects": {
              "$geometry": {
                "type": "Point",
                "coordinates": location
              }
            }
          },
          "rtaxi_id"  : rtaxi_id,
          "is_polygon": true
          "business_model":business_model
        }
        query = mongo.Parking.find query
        query.exec()
      .then (parking) =>
        return parking
    else
      Q()
      .then =>
        mongo.Parking.find
          location: $near:
            $geometry:
              type       : "Point",
              coordinates: location
            $maxDistance: cfg.parking_distance_trip
          rtaxi_id: rtaxi_id
          business_model: business_model
      .then (parking) =>
        return parking

@updateParkingStatus = (driver) ->
  driver_id = driver.driver_id
  rtaxi_id = driver.rtaxi_id
  position = driver.position
  Q()
  .then =>
    service.getAndCreateConfig rtaxi_id
  .then (cfg) =>
    @cfg = cfg
    #find parking for driver
    @getParkingByDriver driver, @cfg
  .then (parking) =>
    if parking? and parking.length >0
      Q()
      .then =>
        @getParkingContainingDriver driver_id
      .then (parking_containing_driver) =>
        if parking_containing_driver? and parking[0].parking_id isnt parking_containing_driver.parking_id

          Q()
          .then =>
            @removeDriverFromAllParkings driver_id, rtaxi_id
          .then =>
            @putDriverInParking driver_id, parking[0], rtaxi_id
          .fail (err) ->
            log.ex err, "updateParkingStatus", "driver_id: #{driver_id}, rtaxi_id: #{rtaxi_id}, position: #{position}"
        else

          @putDriverInParking driver_id, parking[0], rtaxi_id
      .fail (err) ->
        log.ex err, "updateParkingStatus", "driver_id: #{driver_id}, rtaxi_id: #{rtaxi_id}, position: #{position}"

    else
      @removeDriverFromAllParkings driver_id, rtaxi_id

  .fail (err) =>
    log.ex err, "parking_service.updateParkingStatus", "driver_id: #{driver_id}, rtaxi_id: #{rtaxi_id}, position: #{position}"


@putDriverInParking = (driver_id, parking, rtaxi_id) ->
  closest_parking    = null
  closest_parking_id = null

  queue_size       = null
  queue_for_driver = null

  Q()
  .then =>
    closest_parking    = parking
    closest_parking_id = parking.parking_id

    #count drivers in queue to put the driver in right position

    mongo.ParkingQueues.find
      parking_id : closest_parking_id
      position:
        $nin: [-1]
    .exec()
  .then (closest_parking_queue) =>
    queue_size = closest_parking_queue.length

    mongo.ParkingQueues.findOne
      driver_id : driver_id
    .exec()
  .then (old_driver_queue) =>
    queue_for_driver  = old_driver_queue

    if not old_driver_queue?
      queue_for_driver  = new mongo.ParkingQueues
        driver_id: driver_id

      queue_for_driver.parking_id = closest_parking_id

      log.d queue_size
      #check if the driver need to change the position
      if not queue_for_driver.position? or queue_for_driver.position is -1
        queue_for_driver.position = queue_size + 1
        queue_for_driver.save()
        queue_size += 1

        @bk_queue driver_id, rtaxi_id, closest_parking.name, queue_size
  .fail (err) =>
    log.ex err, "parking_service.putDriverInParking", "driver_id: #{driver_id}, parking: #{parking.parking_id}, rtaxi_id: #{rtaxi_id}"


@removeDriverFromAllParkings = (driver_id, rtaxi_id) ->
  log.d "removeDriverFromAllParkings"
  ###
  this method will be used to kickoff driver from a parking
  ###
  #i will search a parking
  queue_containing_driver = null
  position_in_parking = null
  parking_containing_driver = null

  Q()
  .then =>
    mongo.ParkingQueues.findOne
      position :
        $nin : [-1]
      driver_id : driver_id
    .exec()
  .then (queue) =>
    queue_containing_driver = queue

    unless queue_containing_driver?
      throw new Error NO_QUEUE

    position_in_parking = queue_containing_driver.position

    #search the queue
    mongo.Parking.findOne
      parking_id : queue_containing_driver.parking_id
    .exec()
  .then (parking) =>

    if not parking?
      throw new Error "Parking #{queue_containing_driver.parking_id} doesn't exist"

    parking_containing_driver = parking

    mongo.ParkingQueues.find
      position:
        $nin: [-1]
      parking_id : queue_containing_driver.parking_id
    .sort
      position: 1
    .exec()
  .then (drivers_in_queue) =>
    if not drivers_in_queue?
      throw new Error "The parkings are fucked"

    pos = 1
    #order all drivers in a parking
    for queue in drivers_in_queue

      if queue.driver_id isnt driver_id
        queue.position = pos
        queue.save()
        log.d "sending queue 1: #{JSON.stringify queue}"
        @bk_queue queue.driver_id, rtaxi_id, parking_containing_driver.name, queue.position
        pos += 1

      else
        queue.position   = -1
        queue.save()
        log.d "sending queue 2: #{JSON.stringify queue}"
        @bk_queue queue.driver_id, rtaxi_id, parking_containing_driver.name, queue.position

  .fail (err) =>
    unless err.message is NO_QUEUE
      log.ex err, "parking_service.removeDriverFromAllParkings", "driver_id: #{driver_id}, rtaxi_id: #{rtaxi_id}"


@getParkingContainingDriver = (driver_id) ->
  parking_id = null

  Q()
  .then =>
    mongo.ParkingQueues.find
      driver_id : driver_id
    .exec()
  .then (queues) =>
    for queue in queues
      if queue.position > 0
        parking_id = queue.parking_id

    mongo.Parking.findOne
      parking_id : parking_id
    .exec()
  .then (parking) ->
    return parking
  .fail (err) ->
    log.ex err, "parking_service.getParkingContainingDriver", "driver_id #{parking_id}"


@bk_queue  = (driver_id, rtaxi_id, name, position) ->
  bk.broadcastToDriver rtaxi_id, driver_id, @parkingMessage(name, position)

@parkingMessage = (name, position) ->
  parking_mode =
    'action': 'parking'
    'name'  : name

    'queue_position': position

    'notification_id'          : 2000
    'message_id'               : '53152bfd72a1fa7efd0000e4'
    'message_need_confirmation': false

@updateAllParkingJob = ->
  log.i "Parking:updateAllParkingJob"

  Q()
  .then =>
    sql.findAllParking()
  .then (parkings) =>
    Q.all(
      for parking_p in parkings
        if parking_p.is_polygon[0] == 1
          @updateParkingPolygon parking_p
        else
          @updateParking parking_p
    )

  .then (parking_ids) =>
    parking_list = []
    for parking_id in parking_ids
      if parking_id
        parking_list.push parking_id

    @parking_ids = parking_list

    mongo.Parking.remove
      parking_id :
        $nin: parking_list
    .exec()
  .then =>
    @removeParkingQueues @parking_ids

  .fail (err) =>
    log.ex err, "parking_service.updateAllParkingJob", "",

@updateParking = (parking_p) ->
  Q()
  .then =>
    mongo.Parking.findOne
      parking_id : parking_p.parking_id
    .exec()
  .then (parking_mongo) =>
    if not parking_mongo?
      parking_mongo = new mongo.Parking
    parking_mongo.rtaxi_id    = parking_p.rtaxi_id
    parking_mongo.parking_id  = parking_p.parking_id
    parking_mongo.name        = parking_p.name
    parking_mongo.location    = [parking_p.lng, parking_p.lat]
    parking_mongo.business_model = parking_p.business_model
    parking_mongo.is_polygon  = false
    parking_mongo.coordinates_in  = undefined
    parking_mongo.coordinates_out = undefined

    parking_mongo.save()
  .then (parki_s) =>
    return parki_s.parking_id
  .fail (err) =>
    log.e "parking_service.updateParking loop: #{err}"
    console.log "REMOVE PARKING COMMON #{parking_p.parking_id}"
    @removeParkingSQL parking_p.parking_id

@updateParkingPolygon = (parking_p) ->
  Q()
  .then =>
    mongo.Parking.findOne
      parking_id : parking_p.parking_id
    .exec()
  .then (parking_mongo) =>
    if not parking_mongo?
      parking_mongo = new mongo.Parking

    coordinates_in_col  = JSON.parse parking_p.coordinates_in
    coordinates_out_col = JSON.parse parking_p.coordinates_out
    coord_in  = []
    coord_out = []
    for coordinates_in in coordinates_in_col
      coord_in.push [parseFloat(coordinates_in.lat),parseFloat(coordinates_in.lng)]
    for coordinates_out in coordinates_out_col
      coord_out.push [parseFloat(coordinates_out.lat),parseFloat(coordinates_out.lng)]

    parking_mongo.rtaxi_id    = parking_p.rtaxi_id
    parking_mongo.parking_id  = parking_p.parking_id
    parking_mongo.name        = parking_p.name
    parking_mongo.business_model = parking_p.business_model
    parking_mongo.location    = undefined
    parking_mongo.is_polygon  = true
    parking_mongo.coordinates_in =  tools.toGeoJSON(coord_in)
    parking_mongo.coordinates_out = tools.toGeoJSON(coord_out)
    parking_mongo.save()
  .then (parki_s) =>
    return parki_s.parking_id
  .fail (err) =>
    log.e "parking_service.updateParkingPolygon loop: #{err}"
    console.log "REMOVE PARKING POLYGON #{parking_p.parking_id}"
    @removeParkingSQL parking_p.parking_id

@removeParkingSQL = (parking_id) ->
  Q()
  .then =>
    sql.deleteParking( parking_id )
  .then =>
    return null

@removeParkingQueues = (existing_parkings) ->
  log.i "Parking:updateParkingQueues"

  Q()
  .then =>
    mongo.ParkingQueues.remove
      parking_id :
        $nin: existing_parkings
    .exec()
  .then =>
    log.i "updateParkingQueues"
  .fail (err) =>
    log.ex err, "parking_service.removeParkingQueues", ""
