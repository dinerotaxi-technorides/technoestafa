###
Parking class, this class take the responsabilitiy for the parking and manage the queue.
###
  
mongo    = require '../dbs/mongo'
bk       = require '../dbs/broadcast'
service  = require './service'
config   = require '../../config'
moment   = require 'moment'

Q      = require 'q'
log    = require('../log').create 'DriverParkingQueue'


NO_QUEUE    = "no queue"


@checkParking = (driver) ->
  log.i "checking parking queue #{driver.status}"
  if driver.status is 'ONLINE'
    @updateParkingStatus driver
  else
    @removeDriverFromAllParkings driver

# _id, rtaxi_id, position
@updateParkingStatus = (driver) ->

  Q()
  .then =>
    service.getAndCreateConfig driver.rtaxi_id
  .then (cfg) =>
    @cfg = cfg
    #find parking for driver
    service.parking_service.getParkingByDriver driver, @cfg
  .then (parking) =>
    if parking? and parking.length > 0
      Q()
      .then =>
        @putDriverInParking driver, parking[0]
      .then () =>
        log.d "The driver is in parking #{JSON.stringify driver} #{JSON.stringify parking[0]}"
      .fail (err) ->
        log.ex err, "updateParkingStatus", "driver_id: #{driver.driver_id},parking: #{parking[0].name}"

    else
      @removeDriverFromAllParkings driver

  .fail (err) =>
    log.ex err, "updateParkingStatus", "driver_id: #{driver_id}, rtaxi_id: #{rtaxi_id}, position: #{position}"


@putDriverInParking = (driver, parking) ->
  closest_parking = null
  closest_parking_id = null

  queue_size = null
  queue_for_driver = null

  Q()
  .then =>
    closest_parking    = parking
    closest_parking_id = parking.parking_id

    #count drivers in queue to put the driver in right position

    mongo.DriverParkingQueue.find
      parking : parking
      position:
        $nin: [-1]
    .populate('driver parking')
    .exec()
  .then (closest_parking_queue) =>
    @closest_parking_queue = closest_parking_queue

    mongo.DriverParkingQueue.findOne
      driver : driver
    .populate('driver parking')
    .exec()
  .then (old_driver_queue) =>
    @queue_size = @closest_parking_queue.length ? 0
    @queue_size = @queue_size + 1
    if not old_driver_queue
      queue_for_driver        =  new mongo.DriverParkingQueue()
      queue_for_driver.position = @queue_size
    else
      queue_for_driver = old_driver_queue
      if queue_for_driver.parking
        if queue_for_driver.position is -1
          queue_for_driver.position = @queue_size
        else if parking.parking_id is not queue_for_driver.parking.parking_id
          queue_for_driver.position = @queue_size
      else
        queue_for_driver.position = @queue_size

    queue_for_driver.driver = driver
    queue_for_driver.parking = parking
    queue_for_driver.save()
  .then (driver_queue) =>
    @bk_queue driver.driver_id, driver.rtaxi_id, closest_parking.name, driver_queue.position
  .fail (err) =>
    log.ex err, "putDriverInParking", "#{err.stack}"


@removeDriverFromAllParkings = (driver) ->
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
    mongo.DriverParkingQueue.findOne
      position :
        $nin : [-1]
      driver : driver
    .populate('driver parking')
    .exec()
  .then (queue) =>
    queue_containing_driver = queue

    unless queue_containing_driver?
      throw new Error NO_QUEUE

    unless  queue_containing_driver.parking?
      throw new Error NO_QUEUE
    position_in_parking = queue_containing_driver.position

    #search the queue
    mongo.Parking.findOne
      parking_id : queue_containing_driver.parking.parking_id
    .exec()
  .then (parking) =>

    if not parking?
      throw new Error "Parking #{queue_containing_driver.parking.parking_id} doesn't exist"

    @parking_containing_driver = parking

    mongo.DriverParkingQueue.find
      position:
        $nin: [-1]
      parking : parking
    .sort
      position: 1
    .populate('driver parking')
    .exec()
  .then (drivers_in_queue) =>
    if not drivers_in_queue?
      throw new Error "The parkings are fucked"

    pos = 1
    #order all drivers in a parking
    for queue in drivers_in_queue
      if queue.driver? and queue.driver.driver_id isnt driver.driver_id
        queue.position = pos
        queue.save()
        log.d "sending queue 1: #{JSON.stringify queue}"
        @bk_queue queue.driver.driver_id, queue.driver.rtaxi_id, @parking_containing_driver.name, queue.position
        pos += 1

      else
        queue.position   = -1
        queue.save()
        log.d "sending queue 2: #{JSON.stringify queue}"
        @bk_queue queue.driver.driver_id, queue.driver.rtaxi_id, @parking_containing_driver.name, queue.position

  .fail (err) =>
    unless err.message is NO_QUEUE
      log.ex err, "removeDriverFromAllParkings", "#{err.stack}"

@batchUpdateQueues = () ->
  today = moment()
  sixty_seconds = moment(today).subtract(config.parking_v2_seconds_sub, 'seconds')
  sixty_2x_seconds = moment(today).subtract(config.parking_v2_seconds_sub * 2, 'seconds')
  Q()
  .then =>

    mongo.DriverParkingQueue.find
      position :
        $nin : [-1]
      updated_at:
        $lt: sixty_seconds.toDate()
    .populate('driver parking')
    .exec()
  .then (drivers_in_queue) =>
    for queue in drivers_in_queue
      if queue.driver
        if queue.driver.updated_at and queue.driver.updated_at < sixty_2x_seconds.toDate()
          @removeDriverFromAllParkings queue.driver

  .fail (err) =>
    unless err.message is NO_QUEUE
      log.ex err, "batchUpdateQueues", "#{err.stack}"

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
