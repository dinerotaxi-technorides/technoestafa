log    = require('./log').create 'Tools'
config = require '../config'
bk = require './dbs/broadcast'

@getClazz = (user)->
  if user?.is_cc and user.is_cc
      return "ar.com.operation.OperationCompanyHistory"

  return "ar.com.operation.OperationHistory"
@getClassHistoryByClass = (clazz) ->
  if clazz in ['ar.com.operation.OperationHistory','ar.com.operation.OperationPending']
    return 'ar.com.operation.OperationHistory'
  else
    return 'ar.com.operation.OperationCompanyHistory'

@getUserClazz = (clazz = "")->
  if 'ar.com.goliath.corporate.CorporateUser' is clazz.toString()
    return true

  return false

@getTypeUser = (type_user) ->

  if(type_user is 'TAXISTA')
    return 1
  else if(type_user is 'OPERADOR')
    return 0
  else if(type_user is 'TELEFONISTA')
    return 3
  else if(type_user is 'MONITOR')
    return 2
  else
    return type_user

@getDistanceFromLatLonInMeters = (lat1, lon1, lat2, lon2) ->
  R = 6371
  # Radius of the earth in km
  dLat = @deg2rad(lat2 - lat1)
  # deg2rad below
  dLon = @deg2rad(lon2 - lon1)
  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(@deg2rad(lat1)) * Math.cos(@deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  d = (R * c)
  # Distance in Meters
  return  Math.floor(d * 1000)

@deg2rad = (deg) ->
  deg * Math.PI / 180

#epsz maquina de estados
@isValidToUpdate = (mg_operation, new_status) ->
  pending  = config.oper_status.pending
  assigned = config.oper_status.assigned
  holding  = config.oper_status.holding
  in_tx    = config.oper_status.in_tx
  complete = config.oper_status.completed
  cancel   = config.oper_status.cancel

  if mg_operation.status in pending
    return true

  if mg_operation.status in assigned
    log.i "assigned"
    if mg_operation.status in pending
      return false

  if mg_operation.status in holding
    log.i "holding"
    if new_status in pending
      return false

  if mg_operation.status in in_tx
    log.i "in_tx"
    if new_status in pending or new_status in assigned
      return false

  if mg_operation.status in complete or mg_operation.status in cancel
    log.i "completed"
    if new_status in pending or new_status in assigned or new_status in in_tx
      return false

  return true

@closeConnection = (type, rtaxi, id, code = 3000, reason = "3000" ) ->

  messg = {
    'action' : "close"
    'code'   : code
    'reason' : reason
  }

  if type is 'operator'
    bk.broadcastToOperator rtaxi, id, messg
  else if type is 'driver'
    bk.broadcastToDriver rtaxi, id, messg
  else if type is 'user'
    bk.broadcastToUser rtaxi, id, messg

@reportControlUser = (actor, isCC) ->

  if actor is not 'PASSENGER'
    IMG = 'O_WEB'
  else
    if isCC
      IMG = "CORP_P_WEB"
    else
      IMG = "P_WEB"


#------------ZONES------------
@toGeoJSON = (polygon) ->
  # `polygon` is an array of [lng, lat]

  longLat = ([point[1],point[0]] for point in polygon)
  longLat.push [ polygon[0][1], polygon[0][0] ]

  type       : 'Polygon'
  coordinates: [ longLat ]
#------------ZONES------------
