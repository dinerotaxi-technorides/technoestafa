Q          = require 'q'
geo     = require '../geo/google_maps'
mongo   = require '../dbs/mongo'
sql     = require '../dbs/sql'
service = require './service'
tools   = require '../tools'
config  = require '../../config'

log     = require('../log').create 'costCalculatorService'

NO_PATH_FOUND = "no path found"
NOT_IN_A_ZONE = "not in a zone"
PRICE_FOUND   = "price found"

@calculateCost = (rtaxi_id, from, to, token) ->
  log.i "calculateCost"

  @result_set =
    amount   : 0
    km       : 0
    zone_from: ''
    zone_to  : ''
    data_json: '{}'
  company_config = null
  Q()
  .then =>
    service.getAndCreateConfig rtaxi_id
  .then (config) =>

    company_config = config
    console.log("Start operation")
    console.log(company_config.has_zone_active)
    console.log(rtaxi_id)
    if company_config.has_zone_active
      console.log('Inside of if');
      Q()
      .then =>
        geo.getKmDistance(from, to)
      .then (data) =>
        @data = data ? '{}'
        @calculateCostFromZone rtaxi_id, from, to, token
      .then (cost) =>
        amount = 0
        if cost?.amount
          amount = cost.amount.toFixed(2)
        @result_set =
          amount   : amount ? 0
          zone_from: cost.zone_from ? ''
          zone_to  : cost.zone_to   ? ''
          data_json: @data
          is_zone  : true

        return @result_set
      .fail (err) =>
        log.ex err, "calculateCost", "rtaxi_id: #{rtaxi_id}, from: #{from}, to: #{to}"
        return @result_set
    else

      Q()
      .then =>
        @calculateCostFromDistance company_config, from, to
      .then (cost) =>
        console.log('Inside of else');
        console.log(cost);
        amount = 0
        if cost?.amount
          amount = cost.amount.toFixed(2)
        @result_set =
          amount   : amount
          km       : cost.km
          data_json: cost.data_json
          is_zone  : false
        return @result_set
      .fail (err) =>
        log.ex err, "calculateCost", "rtaxi_id: #{rtaxi_id}, from: #{from}, to: #{to}"
        return @result_set
  .fail (err) =>
    log.ex err, "calculateCost", "rtaxi_id: #{rtaxi_id}, from: #{from}, to: #{to}"
    return @result_set


@calculateCostFromZone = (rtaxi_id, from, to, token) ->
  zone_to = null
  zone_from = null

  trip_price = null
  Q()
  .then =>
    @detectZoneByGeoRef rtaxi_id, to, token
  .then (zone) =>
    zone_to = zone
    console.log("%%%%%%%%%%%%zone_to%%%%%%%%%%%%%")
    console.log(zone_to)
    console.log("%%%%%%%%%%%%zone_to%%%%%%%%%%%%%")
    @detectZoneByGeoRef rtaxi_id, from, token
  .then (zone) =>
    zone_from = zone
    console.log("%%%%%%%%%%%%zone_from%%%%%%%%%%%%%")
    console.log(zone_from)
    console.log("%%%%%%%%%%%%zone_from%%%%%%%%%%%%%")

    unless zone_from? and zone_to?
      throw new Error (NOT_IN_A_ZONE)

    sql.findZonesPricing
      zone_from_id  : zone_from.zone_id
      zone_to_id    : zone_to.zone_id
      rtaxi_id      : rtaxi_id
  .then ([price]) =>
    if price?
      trip_price = price

    sql.findZonesPricing
      zone_from_id  : zone_to.zone_id
      zone_to_id    : zone_from.zone_id
      rtaxi_id      : rtaxi_id
  .then ([price]) =>
    if not trip_price and price?
      trip_price = price

    return {
      zone_from:
        name: zone_from.name
        id  : zone_from.zone_id
      zone_to:
        name: zone_to.name
        id  : zone_to.zone_id
      amount: trip_price.amount
    }

  .fail (err) =>
    unless err.message in [NOT_IN_A_ZONE, PRICE_FOUND]
      log.ex err, "calculateCostFromZone", "rtaxi_id: #{rtaxi_id}, from: #{from}, to: #{to}"
    return 0

#returns the zone that contains pos if all zones are square
@detectZoneByGeoRef = (rtaxi_id, pos, token) ->
  console.log("---------------------------")
  console.log(pos)
  latLng_s = pos.split ','
  console.log("---------------------------")
  console.log(latLng_s)
  pos_f = [parseFloat(latLng_s[1]), parseFloat(latLng_s[0])]
  console.log("---------------------------")
  console.log(pos_f)
  Q()
  .then =>
    query = {
      "geopoly": {
        "$geoIntersects": {
          "$geometry": {
            "type": "Point",
            "coordinates": pos_f
          }
        }
      },
      "rtaxi_id":rtaxi_id
    }
    query = mongo.Zone.find query
    query.exec()
  .then (zones) =>
    return zones[0]


@calculateCostFromDistance = (company_config, from, to) ->
  Q()
  .then =>
    geo.getKmDistance(from, to)
  .then (data) =>
    console.log("***************Start calculateCostFromDistance******************")
    console.log(data)
    console.log("***************End calculateCostFromDistance******************")
    #google maps didn't find a path from origin to destination
    if not data? or not data.routes[0]? or not data.routes[0].legs?
      throw new Error (NO_PATH_FOUND)

    distance = data.routes[0].legs[0].distance
    duration = data.routes[0].legs[0].duration

    if distance?
      distance_km = distance.value / 1000
    #else
    #  throw new Error (NO_PATH_FOUND)
    cost = company_config.cost_rute_per_km_min + (distance_km * company_config.cost_rute_per_km)

    return {
      amount   : cost
      km       : distance_km
      duration : duration
      data_json: data
    }

  .fail (err) ->
    if err.message not in [ NO_PATH_FOUND]
      log.ex err, "calculateCostFromDistance", "rtaxi_id: #{company_config.rtaxi_id}, from: #{from}, to: #{to}"
    return {
      amount  : 0
      km      : 0
      duration: 0
    }


#returns the zone that contains pos if all zones are square
@detectZone = (rtaxi_id, pos, token = '') ->
  pos_f = [parseFloat(pos[0]), parseFloat(pos[1])]
  Q()
  .then =>
    mongo.Zone.find
      rtaxi_id : rtaxi_id
    .exec()
  .then (zones) =>
    for zone in zones

      lats = (point[1] for point in zone.location)
      lngs = (point[0] for point in zone.location)


      max_lat = @getMaxOfArray lats
      min_lat = @getMinOfArray lats
      max_lng = @getMaxOfArray lngs
      min_lng = @getMinOfArray lngs

      if pos_f[1] > min_lat and pos_f[1] < max_lat
        if pos_f[0] > min_lng and pos_f[0] < max_lng
          # log.d "YES"
          return zone

    throw new Error "invalid zone"
  .fail (err) ->
    unless err.message is 'invalid zone'
      log.ex err, "detectZone", "rtaxi_id: #{rtaxi_id}, pos: #{pos}"


@getMaxOfArray = (numArray) ->
    return Math.max.apply null, numArray


@getMinOfArray = (numArray) ->
    return Math.min.apply null, numArray

@validatePolygon = (rtaxi_id, polygon, token) =>

  Q()
  .then =>
    query = mongo.ZonePoint.remove
      rtaxi_id: rtaxi_id
      token   : token
    query.exec()
  .then (points) =>
    point = new mongo.ZonePoint
    point.token    = token
    point.location = tools.toGeoJSON(polygon)
    point.rtaxi_id = rtaxi_id
    point.save()
  .then (p_saved) =>
    return p_saved
