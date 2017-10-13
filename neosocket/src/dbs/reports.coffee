Q       = require 'q'

mongo     = require '../dbs/mongo'
config    = require '../../config'
DataStore = require './data_store'
tools     = require '../tools'
log       = require('../log').create 'Reports'

store = new DataStore

@getOperations = (token, start_date, end_date) ->
  log.d "getOperations"

  Q()
  .then ->
    store.getMonitorFromToken(token)
  .then (user) =>
    store.getOperationsFromPeriod(user.rtaxi_id, start_date, end_date)
  .then (operations) ->
    return operations
  .fail (err) ->
    log.ex err, "getOperations", "token: #{token}, start_date: #{start_date}, end_date: #{end_date}"
    throw err

@getDriversVersion = (token) ->
  log.d "getDriversVersion"

  Q()
  .then ->
    store.getAdminFromToken(token)
  .then (user) =>
    store.getDrivers(user.id)
  .then (drivers) ->
    return drivers
  .fail (err) ->
    log.ex err, "getDriversVersion", "token: #{token}"
    throw err

@getOperationStatuses = (token, start_date, end_date) ->
  log.d "getOperationStatuses"

  Q()
  .then =>
    store.getMonitorFromToken(token)
  .then (user) =>
    store.getOperationsFromPeriod(user.rtaxi_id, start_date, end_date)
  .then (operations) =>
    return @_countOperationStatuses(operations)
  .fail (err) ->
    log.ex err, "getOperationStatuses", "token: #{token}, start_date: #{start_date}, end_date: #{end_date}"
    throw err

@getOperationDevices = (token, start_date, end_date) ->
  log.d "getOperationDevices"

  Q()
  .then =>
    store.getMonitorFromToken(token)
  .then (user) =>
    store.getOperationsFromPeriod(user.rtaxi_id, start_date, end_date)
  .then (operations) =>
    return @_countOperationDevices(operations)
  .fail (err) ->
    log.ex err, "getOperationDevices", "token: #{token}, start_date: #{start_date}, end_date: #{end_date}"
    throw err

@getEarnings = (token, start_date, end_date) ->
  log.d "getEarnings"

  Q()
  .then =>
    store.getMonitorFromToken(token)
  .then (user) =>
    store.getOperationsFromPeriod(user.rtaxi_id, start_date, end_date)
  .then (operations) =>
    return @_countEarnings(operations)
  .fail (err) ->
    log.ex err, "getEarnings", "token: #{token}, start_date: #{start_date}, end_date: #{end_date}"
    throw err

@getOperationsWeeklyDigest = (token, start_date, end_date) ->
  log.d "getOperationsWeeklyDigest"

  Q()
  .then =>
    store.getMonitorFromToken(token)
  .then (user) =>
    today = new Date
    oneWeekAgo = new Date(new Date().setDate(new Date().getDate() - 7))
    store.getOperationsFromPeriod(user.rtaxi_id, oneWeekAgo, today)
  .then (operations) =>
    return @_countOperationsStatusesByDay(operations)
  .fail (err) ->
    log.ex err, "getOperationsWeeklyDigest", "token: #{token}, start_date: #{start_date}, end_date: #{end_date}"
    throw err

@getPassengersAmount = (token) ->
  log.d "getPassengersAmount"

  Q()
  .then =>
    store.getMonitorFromToken(token)
  .then (user) =>
    store.getPassengers(user.rtaxi_id)
  .then (passengers) =>
    return passengers.length
  .fail (err) ->
    log.ex err, "getPassengersAmount", "token: #{token}"
    throw err

@getOperationFlow = (op_id, token) ->
  log.d "getOperationFlow"

  Q()
  .then =>
    store.getMonitorFromToken(token)
  .then (user) =>
    store.getOperationFlow(op_id)
  .then (flow) =>
    return flow
  .fail (err) ->
    log.ex err, "getOperationFlow", "op_id: #{op_id}, token: #{token}"
    throw err


@getParkingLog = (parking_id, token) ->
  log.d "getParkingLog"
  # if config.parking_v2
  Q()
  .then =>
    mongo.Parking.findOne
      parking_id : parking_id
    .exec()
  .then (parking) =>
    mongo.DriverParkingQueue.find {parking: parking}
    .populate('driver')
    .exec()
  .then (logs) =>
    parking_list = []
    Q.all(
      for l in logs
        @getDriverByDriverParkingQueue(l)
    )
  .then (logs_l) =>

    return logs_l
  .fail (err) ->
    log.ex err, "getParkingLog", "parking_id: #{parking_id}, token: #{token}"
    throw err
  # else
  # Q()
  # .then =>
  #   mongo.ParkingQueues.find {parking_id: parking_id}
  #   .lean()
  #   .exec()
  # .then (logs) =>
  #   parking_list = []
  #   Q.all(
  #     for l in logs
  #       @getDriverByParkingQueueV1(l)
  #   )
  # .then (logs_l) =>
  #
  #   return logs_l
  # .fail (err) ->
  #   log.ex err, "getParkingLog", "parking_id: #{parking_id}, token: #{token}"
  #   throw err

@getDriverByParkingQueueV1 = (l) ->
  Q()
  .then =>
    mongo.Driver.findOne {driver_id: l.driver_id}
    .lean()
    .exec()
  .then (driver) =>
    f =
      driver_name     : driver.first_name
      driver_last_name: driver.first_name
      driver_email    : driver.email
      created_at      : l.created_at
      updated_at      : l.updated_at
      position        : l.position

    return f

@getDriverByDriverParkingQueue = (l) ->
  Q()
  .then =>
    mongo.Driver.findOne {driver_id: l.driver.driver_id}
    .lean()
    .exec()
  .then (driver) =>
    f =
      driver_name     : driver.first_name
      driver_last_name: driver.first_name
      driver_email    : driver.email
      created_at      : l.created_at
      updated_at      : l.updated_at
      position        : l.position

    return f

@getDriverConnectionLog = (driver_id, page, token) ->
  log.d "getParkingLog"

  Q()
  .then =>

    mongo.DriverConnectionLog.count
      driver_id: driver_id
  .then (count_l) =>
    @count = 0
    if count_l
      @count = count_l

    mongo.DriverConnectionLog.find
      driver_id: driver_id
    .skip(page * 10)
    .limit(10)
    .sort([['created_at', 'descending']])
    .lean()
    .exec()
  .then (logs_l) =>
    data =
      log  : logs_l
      count: @count
    return data
  .fail (err) ->
    log.ex err, "getDriverConnectionLog", "driver_id: #{driver_id}, token: #{token}"
    throw err

@getDriverOperationTopologyLog = (operation_id, page, token) ->
  log.d "getDriverOperationTopologyLog"

  Q()
  .then =>
    mongo.DriverOperationTopologyLog.find
      operation_id: operation_id
    .skip(page * 10)
    .limit(10)
    .lean()
    .exec()
  .then (logs_l) =>
    return logs_l
  .fail (err) ->
    log.ex err, "getDriverOperationTopologyLog", "operation_id: #{operation_id}, token: #{token}"
    throw err

@getOperationLog = (op_id, token) ->
  log.d "getOperationLog"

  Q()
  .then =>
    mongo.OperationLog.find {operation_id: op_id} ,
      {operation_id:1,actor:1,action:1,params:1,created_at:1},
      {sort:{created_at: 1}}
    .lean()
    .exec()
  .then (logs) =>
    for l in logs
      IMG = ""
      if l.action is 'CREATETRIP'
        IMG = tools.reportControlUser l.actor, l.params.params.operation.user.isCC
        IMG += "_" + l.action
      else
        IMG = l.actor.slice(0,1)
        if l.actor is 'PASSENGER'
          IMG += "_ANDROID_" + l.action
        else if l.actor is 'OPERATOR'
          IMG += "_WEB_" + l.action
        else if l.actor is 'DRIVER'
          IMG += "_ANDROID_" + l.action
        else
          IMG += "_" + l.action

      l.step =
        img  : IMG + ".png"
        text : IMG

      l.tooltip =
        img  : "I_"+IMG + ".png"
        text : "I_"+IMG

      delete l.params

    return logs
  .fail (err) ->
    log.ex err, "getOperationLog", "op_id: #{op_id}, token: #{token}"
    throw err


@_countOperationDevices = (operations) ->
  counts = {'WEB': 0, 'ANDROID' : 0, 'OTHER' : 0 }
  for op in operations
    if op.device is 'WEB'
      counts.WEB++
    else if op.device is 'ANDROID'
      counts.ANDROID++
    else if op.device?
      counts.other++
  return counts

@_countOperationsStatusesByDay = (operations) ->
  datesToOps = {}
  for op in operations
    date = new Date(op.created_at)
    unless datesToOps[date.getDay()]?
      datesToOps[date.getDay()] = []
    datesToOps[date.getDay()].push(op)

  datesToStatus = {}
  for date, ops of datesToOps
    datesToStatus[date] = @_countOperationStatuses (datesToOps[date])

  return datesToStatus

@_countOperationStatuses = (operations) ->
  counts = {'FINISHED': 0, 'CANCELED' : 0, 'IN_TRANSACTION' : 0 }
  for op in operations
    if op.status in config.oper_status.completed
      counts.FINISHED++
    else if op.status in config.oper_status.cancel
      counts.CANCELED++
    else if op.status?
      counts.IN_TRANSACTION++
  return counts

@_countEarnings = (operations) ->
  total = 0
  for op in operations
    if op.amount?
      total += op.amount
  return total

@lastPings = (date, rtaxi_id) ->
  log.d "lastPings"

  Q()
  .then ->
    end = date
    start  = new Date(end.valueOf() - 30000)
    mongo.PositionLog.find
      rtaxi : rtaxi_id
      created_at:
        $gt: start
        $lt: end
    .exec()
  .then (pings) ->
    return {amount: pings.length}
  .fail (err) ->
    log.ex err, "dailyOperations", "date: #{date}"
    throw err


@recurringPayments = () ->
  log.i "recurringPayments"

  Q()
  .then ->
    mongo.Payment.find
      contract : "RECURRING"
    .exec()
  .then (payments) ->
    return payments
  .fail (err) ->
    log.ex err, "recurringPayments", ""
