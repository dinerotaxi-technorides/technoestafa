redis      = require './redis'
log    = require('../log').create 'Broadcast'
Q      = require 'q'


_publishMessage = (channel, message)->
  log.i "_publishMessage #{channel}"

  if not channel? or not message?
    log.e "channel #{channel} or message :#{message} FAIL"
    return
  #CHECK IF NEED BE SINGLETON!!
  Q()
  .then =>
    unless @publisher?
      @publisher = new redis.Publisher()
      log.d "CREATED PUBLISHER"
    @publisher.publish(channel, JSON.stringify(message) )
  .fail (err) =>
    log.ex err, "_publishMessage", "channel: #{channel}, message: #{message}"

_generateChannels = (rtaxi, id, typo)->

  channels = [
    "redis.#{rtaxi}",
    "redis.#{rtaxi}.#{typo}"
  ]

  if id?
    channels.push "redis.#{rtaxi}.#{typo}.#{id}"

  return channels


@operatorChannels= (rtaxi, id) ->
  return _generateChannels rtaxi, id, "operator"


@driverChannels= (rtaxi, id) ->
  return _generateChannels rtaxi, id, "driver"


@userChannels= (rtaxi, id) ->
  return _generateChannels rtaxi, id, "user"


#bk.broadcastToUser(@params.rtaxi, @params.id)
@broadcastToAllOperators = (rtaxi, message) ->
  log.i "broadcastToAllOperators"
  _publishMessage @operatorChannels(rtaxi, null)[1], message


@broadcastToOperator = (rtaxi, id, message) ->
  log.i "broadcastToOperator"
  _publishMessage @operatorChannels(rtaxi, id)[2], message


@broadcastToAllDrivers = (rtaxi, message) ->
  log.i "broadcastToAllDrivers"
  _publishMessage @driverChannels(rtaxi, null)[1], message


@broadcastToDriver = (rtaxi, id, message) ->
  log.i "broadcastToDriver"
  _publishMessage @driverChannels(rtaxi, id)[2], message


@broadcastToUser = (rtaxi, id, message) ->
  log.i "broadcastToUser"
  _publishMessage @userChannels(rtaxi, id)[2], message


@broadcastOperation = (op, message) ->
  console.log "start to broadcast operation #{JSON.stringify message}"

  @broadcastToAllOperators op.rtaxi_id, message

  if op.user_id?
    console.log "start to broadcast user #{op.user_id}"
    @broadcastToUser   op.rtaxi_id, op.user_id, message

  console.log "is needed broadcast to driver_id#{op.driver_id}"
  #FIX THIS
  if op.driver_id?
    console.log "start to broadcast driver"
    @broadcastToDriver op.rtaxi_id, op.driver_id, message

@broadcastLocationDriver = (op,message) ->
  console.log "start to broadcast location Driver"

  @broadcastToAllOperators op.rtaxi_id, message

  console.log "start to broadcast user"

  @broadcastToUser   op.rtaxi_id, op.user_id, message


@bkDest = (operation) ->
  bdcast = {
    'rtaxi_id' : operation.rtaxi_id
  }
  #FIX THIS
  driver = operation.driver
  user   = operation.user
  if driver?
    bdcast.driver_id = operation.driver.driver_id
  if user?
    bdcast.user_id = operation.user.user_id

  return bdcast
