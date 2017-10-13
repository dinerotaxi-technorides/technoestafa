Q       = require 'q'

mongo   = require '../dbs/mongo'
sql     = require '../dbs/sql'
adapter = require '../dbs/data_adapter'
log     = require('../log').create 'DataStore'

INVALID_TOKEN = "invalid token"
INSUFFICIENT_PERMISSIONS = "insufficient permissions"

class DataStore

  constructor: ->

  getOperationsFromPeriod: (rtaxi_id, start_date, end_date) ->
    log.d "getOperationsFromPeriod"

    Q()
    .then =>
      @_operations_for_period_query(rtaxi_id, start_date, end_date).lean().exec()
    .then (operations) =>
      return @_adaptOperations(operations)
    .fail (err) ->
      log.ex err, "getOperationsFromPeriod", "rtaxi_id: #{rtaxi_id}, start_date: #{start_date}, end_date: #{end_date}"

  getPassengers: (rtaxi_id) ->
    log.d "getPassengers"

    Q()
    .then =>
      @_passengers_for_company_query(rtaxi_id).lean().exec()
    .then (passengers) =>
      return @_adaptPassengers(passengers)
    .fail (err) ->
      log.ex err, "getPassengers", "rtaxi_id: #{rtaxi_id}"

  getUserFromToken: (token) ->
    Q()
    .then ->
      console.log token
      sql.findUserByToken {token : token}
    .then ([user]) ->
      log.d user
      unless user?
        throw new Error INVALID_TOKEN
      log.d 4
      return user
    .fail (err) ->
      if err.message is INVALID_TOKEN
        throw err
      else
        log.ex err, "getUserFromToken", "token: #{token}"

  getMonitorFromToken: (token) ->
    Q()
    .then ->
      sql.findUserByToken {token : token}
    .then ([user]) ->
      unless user?
        throw new Error INVALID_TOKEN
      unless user.user_type in ["OPERADOR", "TELEFONISTA", "MONITOR"]
        throw new Error INSUFFICIENT_PERMISSIONS
      return user
    .fail (err) ->
      if err.message in [INVALID_TOKEN, INSUFFICIENT_PERMISSIONS]
        throw err
      else
        throw err
        log.ex err, "getMonitorFromToken", "token: #{token}"

  getAdminFromToken: (token) ->
    Q()
    .then ->
      sql.findAdminByToken {token : token}
    .then ([user]) ->
      unless user?
        throw new Error INSUFFICIENT_PERMISSIONS
      return user
    .fail (err) ->
      if err.message in [INVALID_TOKEN, INSUFFICIENT_PERMISSIONS]
        throw err
      else
        throw err
        log.ex err, "getMonitorFromToken", "token: #{token}"

  validateToken: (token) ->
    return true
    # Q()
    # .then ->
    #   console.log token
    #   sql.findUserByToken {token : token}
    # .then ([user]) ->
    #   unless user?
    #     return false
    #   return true
    # .fail (err) ->
    #   log.ex err, "validateToken", "token: #{token}"


  getOperation: (op_id) ->
    log.d "getOperation"

    Q()
    .then =>
      mongo.Operation.findOne
        operation_id: op_id
      .populate('place_from place_to driver option user')
      .exec()
    .then (operation) =>
      return operation
    .fail (err) ->
      log.ex err, "getOperation", "op_id: #{op_id}"

  getDrivers: (rtaxi_id) ->
    log.d "getOperation"
    Q()
    .then =>
      mongo.Driver.find
        rtaxi_id: rtaxi_id
      .exec()
    .then (drivers) =>
      return drivers
    .fail (err) ->
      log.ex err, "getDrivers", "op_id: #{op_id}"

  getOperationWithNullDriver: (op_id) ->
    log.d "getOperation"

    Q()
    .then =>
      mongo.Operation.findOne
        operation_id: op_id
        driver      : null
      .populate('place_from place_to driver option user')
      .exec()
    .then (operation) =>
      return operation
    .fail (err) ->
      log.ex err, "getOperationWithNullDriver", "op_id: #{op_id}"

  getDriverByEmail: (email) ->
    log.d "getOperation"

    Q()
    .then =>
      mongo.Driver.findOne
        email: email
      .exec()
    .then (driver) =>
      return driver
    .fail (err) ->
      log.ex err, "getDriverByEmail", "email: #{email}"

  getOrCreatePassenger: (user_id) ->
    log.d "getOrCreatePassenger"
    Q()
    .then =>
      mongo.User.findOne
        user_id: user_id
      .exec()
    .then (user) =>
      if user
        return user
      else
        Q()
        .then =>
          sql.findUser
            id: user_id
        .then ([user_db]) =>
          if not user_db.user_id?
            throw new Error "getOrCreatePassenger:Exception:user didnt exist"

          usr = new mongo.User user_db
          is_cc = true
          if not user_db.cost_center_id?
            is_cc = false
          console.log is_cc
          usr.is_cc        = is_cc
          usr.is_connected = false
          usr.save()
        .then ([usr]) =>
          return usr
        .fail (err) ->
          throw err
    .fail (err) ->
      log.ex err, "getOrCreatePassenger", "user_id: #{user_id}"
      throw err

  getOrCreateDriver: (driver_id,rtaxi_id) ->
    if not driver_id
      return null
    log.d "getOrCreateDriver"
    Q()
    .then =>
      mongo.Driver.findOne
        driver_id: driver_id
      .exec()
    .then (driver) =>
      console.log
      if driver
        return driver
      else
        Q()
        .then =>
          console.log "DRIVER GET #{driver_id}"
          sql.findDriver id: driver_id
        .then ([user]) =>
          console.log "RESULT GET DRIVER #{JSON.stringify user}"
          driver = new mongo.Driver
            driver_id  : driver_id
            rtaxi_id   : rtaxi_id
            first_name : user?.first_name ? ''
            last_name  : user?.last_name  ? ''
            email      : user?.email      ? ''
            phone      : user?.phone      ? ''
            model      : user?.model   ? ''
            brand      : user?.brand   ? ''
            plate      : user?.plate   ? ''
            token      : ''
            serial     : ''
            version    : ''
            location   : [0,0]
            status     : 'DISCONNECTED'
          driver.save()
        .then (driver_s) =>
          console.log "RESULT CREATE DRIVER #{driver_s}"
          return driver_s

    .fail (err) ->
      log.ex err, "getOrCreateDriver", "user_id: #{driver_id}"
      return null
      
  createAddress: (json, latLng, street_n = '', floor = '', appart= '') ->
    log.d "createAddress"
    Q()
    .then =>
      json = JSON.parse json
      data =
        location: latLng
        country      : json.country
        locality     : json.locality
        street       : json.street
        street_number: street_n
        floor        : floor
        appartment    : appart



      place = new mongo.Place data
      place.save()
    .then (place) =>
      return place
    .fail (err) ->
      log.ex err, "createAddress", "#{err.stack}"

  createOptions: (op) ->
    log.d "createOptions"
    Q()
    .then =>
      data =
        messaging: adapter.getSQLBoolean op.messaging
        pet: adapter.getSQLBoolean op.pet
        airConditioning: adapter.getSQLBoolean op.air_conditioning
        smoker: adapter.getSQLBoolean op.smoker
        specialAssistant: adapter.getSQLBoolean op.special_assistant
        luggage: adapter.getSQLBoolean op.luggage
        airport: adapter.getSQLBoolean op.airport
        vip: adapter.getSQLBoolean op.vip
        invoice: adapter.getSQLBoolean op.invoice

      options = new mongo.Options data
      options.save()
    .then (options) =>
      return options
    .fail (err) ->
      log.ex err, "createOptions", "#{err.stack}"

  getOperationFlow: (op_id) ->
    log.d "getOperationFlow"

    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .lean()
      .exec()
    .then (flow) =>
      return adapter.flowFromMongoToClient(flow)
    .fail (err) ->
      log.ex err, "getOperationFlow", "op_id: #{op_id}"

  saveOperationSentToDriver: (op_id, driver_email) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      flow.sent_to.push
        at_time : Date.now()
        driver_email : driver_email
      flow.save()
    .fail (err) =>
      log.ex err, "saveOperationSentToDriver", "op_id: #{op_id}, driver: #{driver_email}"

  saveOperationAssignedToDriver: (op_id, driver_email) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      flow.assigned_to =
        at_time : Date.now()
        driver_email : driver_email
      flow.save()
    .fail (err) ->
      log.ex err, "saveOperationAssignedToDriver", "op_id: #{op_id}, driver: #{driver_email}"

  saveOperationAcceptedByDriver: (op_id, driver_email) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      flow.accepted_by =
        at_time : Date.now()
        driver_email : driver_email
      flow.save()
    .fail (err) ->
      log.ex err, "saveOperationAcceptedByDriver", "op_id: #{op_id}, driver: #{driver_email}"

  saveOperationTimeEstimated: (op_id, time) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      flow.estimated_time_to_door = time
      flow.save()
    .fail (err) ->
      log.ex err, "saveOperationTimeEstimated", "op_id: #{op_id}, time: #{time}"

  saveOperationAtTheDoor: (op_id, date) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      flow.at_the_door_at = date
      flow.save()
    .fail (err) ->
      log.ex err, "saveOperationAtTheDoor", "op_id: #{op_id}, date: #{date}"

  saveOperationRingUser: (op_id, date) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      flow.ring_user_at.push(date)
      flow.save()
    .fail (err) ->
      log.ex err, "saveOperationRingUser", "op_id: #{op_id}, date: #{date}"

  saveOperationOnBoard: (op_id, date) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      flow.on_board_at = date
      flow.save()
    .fail (err) ->
      log.ex err, "saveOperationOnBoard", "op_id: #{op_id}, date: #{date}"

  saveOperationFinished: (op_id, date, kind, operator_name) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      if kind == "driver"
        flow.finished_by_driver_at = date
      if kind == "passenger"
        flow.finished_by_user_at = date
      if kind == "company"
        flow.finished_by_operator =
          operator : operator_name
          at_time  : date
      flow.save()
    .fail (err) ->
      log.ex err, "saveOperationFinished", "op_id: #{op_id}, date: #{date}, kind: #{kind}"

  saveOperationCanceled: (op_id, date, kind, operator_name) ->
    Q()
    .then =>
      mongo.OperationFlow.findOne
        operation_id: op_id
      .exec()
    .then (flow) =>
      if kind == "driver"
        flow.canceled_by_driver_at = date
      if kind == "passenger"
        flow.canceled_by_user_at = date
      if kind == "company"
        flow.canceled_by_operator =
          operator : operator_name
          at_time  : date
      flow.save()
    .fail (err) ->
      log.ex err, "saveOperationCanceled", "op_id: #{op_id}, date: #{date}, kind: #{kind}"

  _operations_for_period_query: (rtaxi_id, start_date, end_date) ->
    return @_query_for_company(@_query_for_creation_date_range(@_get_all_operations_query(), start_date, end_date), rtaxi_id)

  _passengers_for_company_query: (rtaxi_id) ->
    return @_query_for_company(@_get_all_passengers_query(), rtaxi_id)

  _adaptOperations: (operations) ->
    return (adapter.operationFromMongoToClient(op) for op in operations)

  _adaptPassengers: (passengers) ->
    return (adapter.PassengerFromMongoToClient(p) for p in passengers)

  _get_all_operations_query: ->
    return mongo.Operation.find().populate('place_from place_to driver option user')

  _get_all_passengers_query: ->
    return mongo.User.find()

  _query_for_company: (query, rtaxi_id) ->
    return query.find
      rtaxi_id : rtaxi_id

  _query_for_creation_date_range: (query, start_date, end_date) ->
    return query.find
      created_at:
        $gt: start_date
        $lt: end_date

module.exports = DataStore
