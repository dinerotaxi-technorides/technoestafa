Q       = require 'q'
moment  = require 'moment'

mongo        = require '../dbs/mongo'
sql          = require '../dbs/sql'
bk           = require '../dbs/broadcast'
data_adapter = require '../dbs/data_adapter'
config       = require '../../config'
tools        = require '../tools'
DataStore    = require '../dbs/data_store'

@bs_service         = require './business_model_service'
@parking_service    = require './parking_service'
@queue_service      = require './queue_service'
@push_service       = require './push_service'
@fc_service         = require './fare_calculator_service'
@dispatcher_service = require './dispatcher_service'
@message_service    = require './message_service'
@user_service       = require './user_service'
operation_service   = require './operation_service'
operation_enum      = require './../enum/operation_enum'
fc_enum             = require './../enum/fare_calculator_enum'

@TRANSACTIONSTATUS = operation_enum.TRANSACTIONSTATUS
@FC_TYPE           = fc_enum.FC_TYPE

log     = require('../log').create 'Service'

store = new DataStore

@getAndCreateConfig = (id) ->
  log.i "CompanyConfig:getAndCreateConfig #{id}"
  Q()
  .then =>
    mongo.CompanyConfig.findOne
      rtaxi_id: id
    .exec()
  .then (config) =>
    # Read or init mongo data:
    if config
      return config
    else
      return @createConfig(id)


  .fail (err) =>
    log.ex err, "getAndCreateConfig", "id: #{id}"

@createConfig = (id) ->
  Q()
  .then =>
    sql.findConfigBy {id:id}
  .then ([sql_config]) =>
    if not sql_config
      throw new Error "Error config id:#{id} is #{sql_config}"

    sql_config.has_zone_active     = sql_config.has_zone_active[0] == 1
    sql_config.parking             = sql_config.parking[0] == 1
    sql_config.endless_dispatch    = sql_config.endless_dispatch[0] == 1
    sql_config.had_user_number     = sql_config.had_user_number[0] == 1
    sql_config.has_mobile_payment  = sql_config.has_mobile_payment[0] == 1
    sql_config.paypal              = sql_config.paypal[0] == 1
    sql_config.has_required_zone   = sql_config.has_required_zone[0] == 1
    sql_config.driver_cancel_trip  = sql_config.driver_cancel_trip[0] == 1
    sql_config.parking_polygon     = sql_config.parking_polygon[0] == 1

    sql_config.has_driver_dispatcher_function = sql_config.has_driver_dispatcher_function[0] == 1
    sql_config.is_fare_calculator_active      = sql_config.is_fare_calculator_active[0] == 1
    sql_config.credit_card_enable             = sql_config.credit_card_enable[0] == 1
    sql_config.is_queue_trip_activated        = sql_config.is_queue_trip_activated[0] == 1
    mongo.CompanyConfig.update
      rtaxi_id : sql_config.rtaxi_id
      sql_config
      upsert : true
    .exec()
  .then (write_message) =>
    return @getAndCreateConfig(id)
  .fail (err) ->
    log.ex err, "createConfig", "id: #{id}"

@updateAllCompaniesConfig = ->
  console.log "CompanyConfig:updateAllCompaniesConfig"
  log.i "CompanyConfig:updateAllCompaniesConfig"
  Q()
  .then =>
    sql.findAllCompanies()
  .then (companies) =>
    for company in companies
      @createConfig company.id

  .fail (err) =>
    log.ex err, "updateAllCompaniesConfig", ""

@updateAllConfig = ->
  log.i "CompanyConfig:update-config"
  today = moment().startOf('day')
  seven_days = moment(today).subtract(7, 'days')
  one_day = moment(today).subtract(1, 'days')
  Q()
  .then =>
    console.log "removing chat"
    mongo.ChatMessage.remove
      status: 'FATAL_ERROR'
    .remove().exec()
  .then =>
    mongo.ChatMessage.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing Connection"
    mongo.Connection.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing Conversation"
    mongo.Conversation.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing DebugLog"
    mongo.DebugLog.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then (ele) =>
    console.log "removing DriverConnectionLog"
    mongo.DriverConnectionLog.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing DriverOperationTopologyLog"
    mongo.DriverOperationTopologyLog.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing ErrorLog"
    mongo.ErrorLog.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing OperationLog"
    mongo.OperationLog.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing PositionLog"
    mongo.PositionLog.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing PushMessage"
    mongo.PushMessage.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing TextNotification"
    mongo.TextNotification.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>
    console.log "removing OperationFlow"
    mongo.OperationFlow.remove
      created_at:
        $lt: one_day.toDate()
    .remove().exec()
  .then =>

    sql.findAllCompanies()
  .then (companies) =>
    for company in companies
      @createConfig company.id

  .fail (err) =>
    log.ex err, "updateAllConfig", ""

@updateCompanyConfig = (id) ->
  log.i "updateCompanyConfig #{id}"
  Q()
  .then =>
    mongo.CompanyConfig.findOne
      rtaxi_id: id
    .exec()
  .then (config) =>
    if config?
      config.remove()
  .then =>
    @getAndCreateConfig id
  .fail (err) =>
    log.ex err, "updateCompanyConfig", "id: #{id}"

@IsDriverInTX = (rtaxi, driver) ->
  Q()
  .then =>
    @getAndCreateConfig rtaxi
  .then (cfg) =>
    #This part check if the driver is in one operation if that is correct ignore the pull out of the operation
    @cfg = cfg
    finished_states = config.oper_status.cancel.concat(config.oper_status.completed)

    today = moment().startOf('day')
    tomorrow = moment(today).add(1, 'days')

    mongo.Operation.findOne
      status:
        $nin: finished_states
      driver: driver
      created_at:
        $gte: today.toDate()
        $lt: tomorrow.toDate()
    .populate('driver place_from place_to user option')
    .sort
      operation_id: -1
    .lean()
    .exec()
    .then (operation) =>
      return not operation?

@getAndCreateDriver = (id) ->
  log.i "Driver:getAndCreateDriver"

  Q()
  .then =>
    mongo.Driver.findOne
      driver_id: id
    .exec()
  .then (driver) =>
    # Read or init mongo data:
    if driver
      return driver

    @driver = driver ?

      Q()
      .then =>
        sql.findDriver {id}
      .then ([driver]) =>
        if not driver
          log.i "Error driver id:#{id} is ",driver
          return

        driver = new mongo.Driver driver
        driver.status = 'DISCONNECTED'

        driver.save (err) =>
          if err?
            log.i "error driver cant create", err
        @driver = driver
        @driver

      .fail (err) =>
        log.ex err, "getAndCreateDriver", "id: #{id}", "IN"

  .fail (err) =>
    log.ex err, "getAndCreateDriver", "id: #{id}", "OUT"

@getUserProfile = (filter) ->
  Q()
  .then =>

    sql.findUserProfile filter
  .then ([user]) =>
    if not user
      log.i "Error user id:#{id} not exist "
      throw new Error "service:getUserProfile Error user id:#{id} not exist"
    return user

@getAndCreateDriverByEmail = (email) ->
  log.i "Driver:getAndCreateDriver"

  res_driver = null

  Q()
  .then =>
    mongo.Driver.findOne
      email: email
    .exec()
  .then (driver) =>
    # Read or init mongo data:
    if driver?
      return driver

    @driver = driver ?
      Q()
      .then =>
        sql.findDriver {email}
      .then ([driver]) =>
        if not driver
          log.i "Error driver email:#{email} is ",driver
          return

        driver = new mongo.Driver driver
        driver.status = 'DISCONNECTED'

        driver.save (err) =>
          if err?
            log.i "error driver cant create", err

        return driver
      .fail (err) =>
        log.ex err, "getAndCreateDriver", "email: #{email}", "IN"

  .fail (err) =>
    log.ex err, "getAndCreateDriver", "email: #{email}", "IN"

@getAndCreateDriverByNumber = (driver_number,rtaxi_id) ->
  log.i "Driver:getAndCreateDriverByNumber"

  res_driver = null

  Q()
  .then =>
    mongo.Driver.findOne
      email   : new RegExp('^'+driver_number+'@', "i")
      rtaxi_id: rtaxi_id
    .exec()
  .then (driver) =>
    log.d driver
    # Read or init mongo data:
    if driver?
      return driver

    @driver = driver ?
      Q()
      .then =>
        sql.findDriver {driver_number}
      .then ([driver]) =>
        if not driver
          log.i "Error driver number:#{driver_number} is ",driver
          return

        driver = new mongo.Driver driver
        driver.status = 'DISCONNECTED'

        driver.save (err) =>
          if err?
            log.i "error driver cant create", err

        return driver
      .fail (err) =>
        log.ex err, "getAndCreateDriverByNumber", "driver_number: #{driver_number}, rtaxi_id: #{rtaxi_id}", "IN"

  .fail (err) =>
    log.ex err, "getAndCreateDriverByNumber", "driver_number: #{driver_number}, rtaxi_id: #{rtaxi_id}", "OUT"


@updateCompanyParkings = (rtaxi_id) ->
  log.i "Parking:updateCompanyParkings"

  Q mongo.Parking.find(rtaxi_id).remove().exec()
  .then (parkings_to_remove) =>

    parkings_to_remove
  .then =>

    sql.findParkings(rtaxi_id)
  .then (parkings) =>
    log.i "acaa"

    for parking in parkings
      log.i parking

      mg_parking = new mongo.Parking parking
      mg_parking.location = [parking.lng, parking.lat]

      log.d "NEW PARKING #{JSON.stringify mg_parking}"

      mg_parking.save (err) =>
        if err?
          log.i "error parking cant create", err

    @updateParkingQueues()
  .fail (err) =>
    log.ex err, "updateCompanyParkings", "rtaxi_id: #{rtaxi_id}",


@loadZones = ->
  log.i "Zones:loadZones"

  zone_ids = []

  Q()
  .then =>
    sql.loadZones()
  .then (zones) =>

    for zone in zones
      zone_ids.push zone.zone_id

      do (zone_sql = zone) ->
        Q()
        .then =>

          mongo.Zone.findOne
            zone_id : zone_sql.zone_id
          .exec()
        .then (zone_mongo) ->

          if not zone_mongo?
            zone_mongo = new mongo.Zone

          zone_mongo.rtaxi_id = zone_sql.rtaxi_id
          zone_mongo.zone_id  = zone_sql.zone_id
          zone_mongo.name     = zone_sql.name

          polygon = []
          for point in zone_sql.location.split "|"
            latlng = point.split ","
            polygon.push [parseFloat(latlng[0]),parseFloat(latlng[1])]

          zone_mongo.location = polygon
          zone_mongo.geopoly = tools.toGeoJSON(polygon)

          zone_mongo.save()

        .fail (err) =>
          # log.ex err, "loadZones", "", "IN"

    mongo.Zone.remove
      zone_id :
        $nin: zone_ids
    .exec()

  .fail (err) =>
    log.ex err, "loadZones", "", "OUT"


@updateParkingQueues = ->
  log.i "Parking:updateParkingQueues"
  Q()
  .then =>

    mongo.Parking.find().exec()
  .then (mg_parkings) =>

    parking_ids = (parking.parking_id for parking in mg_parkings)
    mongo.ParkingQueues.where('parking_id').nin(parking_ids).remove().exec()
  .then  =>

    log.i "finish updateParkingQueues"
  .fail (err) =>
    log.e "updateParkingQueues #{err}"


#cancelar operacion cuando  pasa por un timeout...
@finishInconsistentOperations = ->
  log.i "Operation:finishInconsistentOperation"

  message = null
  time_cancel_op    = new Date
  time_cancel_op.setSeconds(
    time_cancel_op.getSeconds() - config.time_out_cancel_trip_pending
  )
  search_status = [
    'PENDING',
    'INTRANSACTION',
    'INTRANSACTIONRADIOTAXI',
    'HOLDINGUSER',
    'ASSIGNEDRADIOTAXI',
    'ASSIGNEDTAXI'
  ]

  Q()
  .then =>
    sql.findDiedOperations()
  .then (op_list) =>
    @findAndFinishInconcistentOperation(op_list)
  .then () =>
    mongo.Operation
      # .where('status').in(search_status)
      .where('user').equals(null)
      .populate('user driver')
    .exec()
  .then (in_operations) =>
    for operation in in_operations
      @upgradeOperationUser operation.operation_id

    mongo.Operation
      .where('updated_at').lte(time_cancel_op)
      .where('status').in(search_status)
      .populate('user driver')
    .exec()
  .then (operations) =>

    for operation in operations
      @finishInconsistentOperation operation

  .fail (err) =>
    log.ex err, "finishInconsistentOperation", "", "OUT"

@findAndFinishInconcistentOperation = (sql_oper) ->

  Q()
  .then =>
    for opera in sql_oper
      @finishSqlAndMongoOperation opera
  .fail (err) =>
    log.ex err, "findAndFinishInconcistentOperation", "", "OUT"

@finishSqlAndMongoOperation = (sql_op) =>
  message = {
    'opid'   : sql_op.id,
    'status' : 'CANCELED',
    'action' : 'company/CancelTrip',

    'notification_id'           : 2003,
    'message_id'                : '5312495272a1fa62f90003cd',
    'message_need_confirmation' : false
  }
  Q()
  .then =>

    sql.updateOperation
      'id'    : sql_op.id,
      'status': 'CANCELED',
      'clazz':  tools.getClassHistoryByClass(sql_op.class)
  .then () =>
    mongo.Operation.findOne
      operation_id: sql_op.id
    .exec()
  .then (operation) =>

    if not operation?
      throw new Error('BROADCAST_NOT_FOUND')

    operation.status = "CANCELED"
    operation.save()
  .then (operation) =>
    bdcast = bk.bkDest operation
    bk.broadcastOperation(bdcast, message)
  .fail (err) =>
    if err.message not in ['BROADCAST_NOT_FOUND']
      log.ex err, "finishInconsistentOperation", "", "IN"

@finishInconsistentOperation = (operation) =>
  message = {
    'opid'   : operation.operation_id,
    'status' : 'CANCELED',
    'action' : 'company/CancelTrip',

    'notification_id'           : 2003,
    'message_id'                : '5312495272a1fa62f90003cd',
    'message_need_confirmation' : false
  }
  Q()
  .then =>
    operation.status = "CANCELED"
    operation.save()

    sql.updateOperation
      'id'    : operation.operation_id,
      'status': operation.status,
      'clazz':  tools.getClazz(operation.user)
  .then =>
    bdcast = bk.bkDest operation
    bk.broadcastOperation(bdcast, message)
  .fail (err) =>
    log.ex err, "finishInconsistentOperation", "", "IN"

@upgradeOperationUser =(operation_id) =>
  log.i "Operation:upgradeOperationUser"

  Q()
  .then =>
    sql.findUserByOperation {id:operation_id}
  .then ([user_db])=>
    @user_db = user_db

    @user_db.is_cc = tools.getUserClazz(@user_db.clazz)
    delete @user_db.clazz

    mongo.User.findOne
      user_id: user_db.user_id
    .exec()
  .then (m_user) =>
    # Read or init mongo data:
    @user = m_user ?
      new mongo.User @user_db
    @user.save()

    mongo.Operation.findOne {operation_id}
    .exec()
  .then (m_operation) =>
    m_operation.user = @user
    m_operation.save()

  .fail (err) =>
    log.ex err, "finishInconsistentOperation", "", "OUT"


@timeoutMessages = ->
  log.i "timeoutSocketConnections";
  console.log "Here Vzla timeoutMessages";

  timeout = new Date

  timeout.setSeconds(
    timeout.getSeconds() - config.time_out_messages
  )

  Q()
  .then ->
    mongo.TextNotification
    .where('updated_at').lte(timeout).exec()
  .then (notifications) ->
    for notification in notifications
      msg =
        'action'          : "expireTextNotification"
        'text'            : notification.text
        'notification_id' : notification._id

        'message_id'                : '53161f3e72a1fa9803000102',
        'message_need_confirmation' : false

      Q()
      .then =>
        mongo.CompanyConfig.find().exec()
      .then (configs) ->

        for company_config in configs
          bk.broadcastToAllOperators company_config.rtaxi_id, msg

      .fail (err) =>
        log.ex err, "timeoutMessages", "", "IN"

  .fail (err) ->
    log.ex err, "timeoutMessages", "", "OUT"


@timeoutSocketConnections = ->
  log.i "timeoutSocketConnections"
  timeout = new Date

  timeout.setSeconds(
    timeout.getSeconds() - config.time_out_disconnect_driver
  )

  Q()
  .then =>

    mongo.Driver
    .where('updated_at').lte(timeout)
    .where('is_connected').equals(true)
    .where('status').in(['ONLINE','OFFLINE']).exec()
  .then (drivers) =>
    for driver in drivers

      driver.status = "DISCONNECTED"
      driver.is_connected = false

      driver.save()

      driver_id = driver.driver_id
      rtaxi     = driver.rtaxi_id

      driver_pool = {
        'id'   : driver_id,
        'rtaxi': rtaxi,
        'state': driver.status,
        'lat'  : driver.location[1],
        'lng'  : driver.location[0],

        'firstName': driver.first_name,
        'lastName' : driver.last_name,
        'phone'    : driver.phone,
        'email'    : driver.email,

        'brandCompany': driver.brand,
        'model'       : driver.model,
        'plate'       : driver.plate,

        'action'       : 'driver/PullingTrips',
        'driverNumber' : driver.email.split('@')[0],
      }

      tools.closeConnection 'driver', rtaxi, driver_id, 4000,"4000"
      bk.broadcastToAllOperators rtaxi, driver_pool
      if not config.parking_v2
        log.i "live driver from parking"
        Q()
        .then =>
          @parking_service.checkParking driver
          log.i "live driver DONEEE parking"
        .fail (err) =>
          log.ex err, "timeoutSocketConnections", "", "IN"

    mongo.User
    .where('updated_at').lte(timeout)
    .where('is_connected').equals(true)
    .exec()
  .then (passengers) =>

    for passenger in passengers
      passenger.is_connected = false
      passenger.save()

      passenger_id  = passenger.user_id
      rtaxi         = passenger.rtaxi_id

      tools.closeConnection 'user', rtaxi, passenger_id, 4000,"4000"

    mongo.Company
    .where('updated_at').lte(timeout)
    .where('is_connected').equals(true)
    .exec()
  .then (operators) =>
    for operator in operators
      operator.is_connected = false
      operator.save()

      operator_id  = operator.company_id
      rtaxi        = operator.rtaxi_id
      tools.closeConnection 'operator', rtaxi, operator_id, 4000,"4000"

  .fail (err) =>
    log.ex err, "timeoutSocketConnections", "", "OUT"

@ping = ->
  log.i "ping"
  timeout = new Date
  timeout.setSeconds(
    timeout.getSeconds() - config.ping_limit_user
  )

  Q()
  .then =>

    mongo.Driver
    .where('updated_at').gte(timeout)
    .where('is_connected').equals(true).exec()
  .then (drivers) =>
    pingUser(drivers,'driver')

    mongo.User
    .where('updated_at').gte(timeout)
    .where('is_connected').equals(true)
    .exec()
  .then (users) =>
    pingUser(users,'user')
    mongo.Company
    .where('updated_at').gte(timeout)
    .where('is_connected').equals(true)
    .exec()
  .then (operators) =>
    pingUser(operators,'operators')

  .fail (err) =>
    log.ex err, "ping", "", "OUT"

pingUser = (users, type)->

  msg = {
    'action': "Ping",
    'message_id'               : '53161f3e72a1fa9803000102',
    'message_need_confirmation': false
  }
  Q()
  .then =>
    for user in users
      if type is 'driver'
        bk.broadcastToDriver user.rtaxi_id, user.driver_id, msg
      else if type is 'user'
        bk.broadcastToUser user.rtaxi_id, user.user_id, msg
      else
        bk.broadcastToOperator user.rtaxi_id, user.company_id, msg

@updateDriverByPing = (message,id) ->
  Q()
  .then =>
    mongo.Driver.findOne
      driver_id: parseInt(id)
    .exec()
  .then (driver) =>
    @driver = driver

    if not @driver?
      log.e "updateDriverPosition:not driver exception #{JSON.stringify message}"
      @closeSocket 4000, "4000"
      throw new Error "updateDriverPosition:not driver exception #{JSON.stringify message}"

    @driver.location = [
      if message.lng? and -180 < message.lng < 180 then message.lng else 0.0
      if message.lat? and  -90 < message.lat < 90  then message.lat else 0.0
    ]

    @driver.status       = message.state
    @driver.is_connected = true
    @driver.save()
    return @driver

@updateUserByPing = (message, id) ->
  Q()
  .then =>
    mongo.User.findOne
      user_id : parseInt(id)
    .exec()
  .then (user) =>
    @user = user
    @user.is_connected = true

    if not @user?
      log.e "updateUserPosition:not user exception #{JSON.stringify message}"
      @closeSocket 4000, "4000"
      throw new Error "updateUserPosition:not user exception #{JSON.stringify message}"
    if message.lat?
      @user.location = [
        if message.lng? and -180 < message.lng < 180 then message.lng else 0.0
        if message.lat? and  -90 < message.lat < 90  then message.lat else 0.0
      ]

    @user.save()
    return @user

@updateOperatorByPing = (message, id) ->
  Q()
  .then =>
    mongo.Company.findOne
      company_id : parseInt(id)
    .exec()
  .then (user) =>
    @user = user
    if not @user?
      log.e "updateOperatorByPing:not user exception #{JSON.stringify message}"
      @closeSocket 4000, "4000"
      throw new Error "updateOperatorByPing:not user exception #{JSON.stringify message}"

    @user.is_connected = true
    @user.save()
  .then (user_s) =>
    return user_s
  .fail (err) =>
    console.log err



@findDriver = (mg_operation, attempts=0, remaining_drivers = null) ->
  log.i "findDriver #{mg_operation.operation_id}"

  drivers_found = 0
  should_dispatch_forever = false
  operation = null


  Q()
  .then =>
    store.getOperation(mg_operation.operation_id)
  .then (op) =>
    operation = op

    unless operation.status in config.oper_status.pending
      throw new Error "DISPATCH_ENDED"

    @getAndCreateConfig operation.rtaxi_id
  .then (cfg) =>
    if not remaining_drivers
      remaining_drivers = cfg.driver_search_trip

    should_dispatch_forever = cfg.endless_dispatch

    @sendOperationToClosestDrivers operation, attempts, remaining_drivers
  .then (receivers)=>
    drivers_found += receivers
    attempts++

    Q.delay config.time_find_driver
  .then =>
    #Refactor need should_dispatch_forever
    need_to_dispatch = (attempts < 3) or (should_dispatch_forever and attempts < 99)

    if need_to_dispatch or not operation.driver
      # log.op operation.operation_id, '0.0.0.0', 'COMPUTER',  'DISPATCHTRIP', {'attempts':attempts, 'operation':operation }
      #@findDriver operation, attempts, remaining_drivers - drivers_found
      @findDriver operation, attempts, remaining_drivers
    else
      log.op operation.operation_id, '0.0.0.0', 'COMPUTER',  'DISPATCHTRIP_OUT', {'attempts':attempts, 'operation':operation }
      search_msg = {
        action  : 'company/DriverNotFound'
        opid    : operation.operation_id
      }
      # bk.broadcastToAllOperators mg_operation.rtaxi_id, search_msg
  .fail (err) =>
    unless err.message is "DISPATCH_ENDED"
      log.ex err, "findDriver", "mg_operation: #{JSON.stringify mg_operation}", "OUT"

@findDriverInParking = (operation, parking, attempts=0) ->
  log.i "findDriverInParking"

  Q()
  .then =>
    query = {
      'position':{
        '$nin':[-1]
      },
      'driver_id':{
        '$nin': operation.blacklisted_drivers
      },
      'parking_id':parking.parking_id
    }
    parking_que = mongo.ParkingQueues
      .where('position').nin([-1])
      .where('driver_id').nin(operation.blacklisted_drivers)
      .where('parking_id':parking.parking_id)
      .sort([['position', 1]])
    parking_que.exec()
  .then (driver_pking) =>
    if not driver_pking? or driver_pking.length is 0 or !driver_pking[0].driver_id
      log.i "findDriverInParking go to FindDriver"
      @findDriver operation, attempts
    else
      Q()
      .then =>
        @getAndCreateDriver driver_pking[0].driver_id
      .then (driver_to_dispatch) =>
        log.i "findDriverInParking push in parking"

        if operation.status == "PENDING"
          operation.blacklisted_drivers.push(driver_to_dispatch.driver_id)
          operation.blacklisted_drivers_obj.push(driver_to_dispatch)

          operation_service.bkDriverNewOperation operation, driver_to_dispatch
          operation.save()

        #CHECK THIS PUT ME IN BATCH PLEASE.....
        attempts++
        Q().delay config.time_find_driver_in_parking

      .then =>
        mongo.Operation.findOne
          operation_id: operation.operation_id
        .populate('place_from place_to driver option user')
        .exec()
      .done()
      .then (mg_operation) =>

        operation = mg_operation

        if operation.status == "PENDING"
          log.op operation.operation_id,'0.0.0.0', 'COMPUTER',  'DISPATCHTRIPPARKING', {'attempts':attempts, 'operation':operation, 'parking':parking}
          @findDriverInParking operation, parking, attempts

      .fail (err) =>
        log.ex err, "findDriverInParking", "operation: #{JSON.stringify operation} parking: #{JSON.stringify parking}", "IN"

  .fail (err) ->
    log.ex err, "findDriverInParking", "operation: #{JSON.stringify operation} parking: #{JSON.stringify parking}", "OUT"


@sendOperationToClosestDrivers = (mg_operation, count, remaining_drivers) ->
  log.i "sendOperationToClosestDrivers COUNT:#{count}, REMAINING:#{remaining_drivers}"

  blacklisted_drivers = mg_operation.blacklisted_drivers

  if remaining_drivers <= 0
    return 0

  Q()
  .then =>
   @getAndCreateConfig mg_operation.rtaxi_id
  .then (cfg) =>

    if not cfg?
      log.e "findDriver:not cfg exception"
      throw new Error "findDriver:not cfg exception"

    distance = cfg.distance_search_trip  * 1000
    distance = distance * (1 + cfg.percentage_search_ratio * Math.min(2,count))

    cfg_driver = {
      location: $near:
        $geometry:
          type: "Point",
          coordinates: mg_operation.place_from.location
        $maxDistance: distance
      driver_id: $nin: blacklisted_drivers
      rtaxi_id: mg_operation.rtaxi_id
      status: "ONLINE"
      business_model: $in:[mg_operation.business_model]
      is_connected:true
    }
    if mg_operation.is_corporate
      cfg_driver.is_corporate=true
    else
      cfg_driver.is_regular=true

    if mg_operation.option.vip
       cfg_driver.is_vip = true
    if mg_operation.option.pet
       cfg_driver.is_pet = true
    if mg_operation.option.airConditioning
       cfg_driver.is_air_conditioning = true
    if mg_operation.option.smoker
       cfg_driver.is_smoker = true
    if mg_operation.option.specialAssistant
       cfg_driver.is_special_assistant = true
    if mg_operation.option.luggage
       cfg_driver.is_luggage = true
    if mg_operation.option.airport
       cfg_driver.is_airport = true
    if mg_operation.option.messaging
       cfg_driver.is_messaging = true
    if mg_operation.option.invoice
       cfg_driver.is_invoice = true

    mongo.Driver.find(cfg_driver).limit(remaining_drivers)
    .exec()
  .then (drivers) =>
    @drivers = drivers
    if drivers.length > 0
      Q.all(
        for driver in drivers
          @dispatchOperationByDriver mg_operation,driver,count,remaining_drivers
      )
    else
      @dispatchDriverNotFound mg_operation,count,remaining_drivers
  .then (d_) =>
    return @drivers.length
  .fail (err) =>
    log.ex err, "sendOperationToClosestDrivers", "operation: #{JSON.stringify mg_operation}, count: {count}", ""

@dispatchDriverNotFound = (mg_operation, count, remaining_drivers) ->
  Q()
  .then =>
    log.d "sendOperationToClosestDrivers no more drivers"
    search_msg = {
      action  : 'company/DriverNotFound'
      opid    : mg_operation.operation_id
      count   : count + 1
      remaning: remaining_drivers
    }
    log.op mg_operation.operation_id, '0.0.0.0', 'COMPUTER',  'DISPATCH_NO_DRIVER_FOUND', {
      'operation'         : mg_operation,
      'count'             : count,
      'remaining_drivers' : remaining_drivers
    }

    bk.broadcastToAllOperators mg_operation.rtaxi_id, search_msg
  .then (saved) =>
    return 0
  .fail (err) =>
    log.ex err, "dispatchOperationByDriver", "operation: #{JSON.stringify mg_operation}, count: {count}", ""


@dispatchOperationByDriver = (mg_operation, driver, count, remaining_drivers) ->
  Q()
  .then =>
    log.op mg_operation.operation_id, '0.0.0.0', 'COMPUTER', 'DISPATCH_TO_DRIVER', {
      'operation'         : mg_operation,
      'driver'            : driver,
      'count'             : count,
      'remaining_drivers' : remaining_drivers}
  .then =>

    mg_operation.blacklisted_drivers.push(driver.driver_id)
    mg_operation.blacklisted_drivers_obj.push(driver)
    # mg_operation.blacklisted_drivers.pull { _id: driver._id }
    mg_operation.save()
  .then (saved) =>
    operation_service.bkDriverNewOperation mg_operation, driver
  .then =>
    return
  .fail (err) =>
    log.ex err, "dispatchOperationByDriver", "operation: #{JSON.stringify mg_operation}, count: {count}", ""

@dispatchTrip = (operation_id) ->
  operation = null
  Q()
  .then =>
    mongo.Operation.find
      operation_id: operation_id
    .populate('place_from place_to driver option user')
    .exec()
  .then ([mg_operation]) =>
    operation = mg_operation


    unless operation?
      throw new Error "no operation exception"

    if operation.driver?
      throw new Error "dispatching assigned operation exception"

    if operation.status in config.oper_status.cancel
      throw new Error "dispatching canceled operation exception"

    if operation.status in config.oper_status.completed
      throw new Error "dispatching completed operation exception"


    search_msg = {
      action  : 'company/FindingDriver'
      opid    : operation_id
    }

    bk.broadcastToAllOperators operation.rtaxi_id, search_msg

    @parking_service.getParkingByUser operation.place_from.location, cfg, operation.rtaxi_id, operation.business_model
  .then (parkings) =>
    @parkings = parkings
    @getAndCreateConfig operation.rtaxi_id
  .then (cfg) =>

    if not cfg?
      throw new Error "dispatchTrip : the config didnt exist #{rtaxi_id}"

    if not operation.deletetrip
      if !cfg.parking or @parkings.length is 0
        log.d "dispatchTrip -> findDriver"
        @findDriver operation
        return true
      else
        Q()
        .then =>
          log.op operation.operation_id, '0.0.0.0', 'COMPUTER',  'INITDISPATCH', {'operation':operation }
          if @parkings.length is 0
            @findDriver operation
          else
            if config.parking_v2
              operation_service.findDriverInParkingV2 operation, @parkings[0]
            else
              @findDriverInParking operation, @parkings[0]

  .fail (err) ->
    log.ex err, "dispatchTrip", "operation_id: #{operation_id}"


@assignTripTo = (operation, assigned_driver, estimated_time = 5, on_error) ->
  Q()
  .then =>
    if not assigned_driver?
      throw new Error "Tried to assign operation #{operation.operation_id} to #{assigned_driver}"
    if assigned_driver.status in ['SEARCHINGPASSENGER','INTRAVEL' ,'INTRANSACTION','ASSIGNEDTAXI']
      throw new Error 'DOUBLE_ASSIGN'

    #This prevent concurrent sessions update the document at same time
    new_nonce = mongo.getRandomObjectId()

    # operation_id: operation.operation_id
    # nonce: operation.nonce?null

    mongo.Operation.findOneAndUpdate {
        operation_id: operation.operation_id
      }, {
        estimated_time: estimated_time
        status: 'ASSIGNEDTAXI'
        driver: assigned_driver
        nonce: new_nonce
      },
      new : true
    .exec()
  .then (updated_op) =>
    if updated_op
      operation = updated_op
      sql.updateOperation
        'id'    : operation.operation_id,
        'rtaxi' : operation.rtaxi_id,
        'driver': assigned_driver.driver_id,

        'status': operation.status,

        'time_travel': operation.estimated_time,
    else
      @notifyAnotherDriverAssigned(assigned_driver)
      throw new Error 'CONCURRENCE_ASSIGN'
  .then (updated) =>
    log.d "UPDATED: #{JSON.stringify updated}"
    store.getOperation operation.operation_id
  .then (operation_refresh) =>
    operation = operation_refresh
    operation.assigned_at = Date.now()
    operation.save()
  .then () =>
    @getPhoneToCall operation.rtaxi_id, operation.driver
  .then (phone_to_call) =>
    at_now = moment().format('YYYY-MM-DD hh:mm:ss a ZZ')
    amount = 0.0

    if(operation.amount)
      amount = operation.amount

    @msg = {
      'action': 'driver/AcceptTrip',
      'rtaxi' : operation.rtaxi_id,
      'opid'  : operation.operation_id,

      'driverNumber' : assigned_driver.email.split('@')[0],
      'driver'       : assigned_driver.driver_id,
      'driverIsFake' : false,
      'phone_to_call': phone_to_call,

      'email'        : assigned_driver.email,
      'timeEstimated': operation.estimated_time,

      'status'   : operation.status,
      'firstName': assigned_driver.first_name,
      'lastName' : assigned_driver.last_name,

      'plate'       : assigned_driver.plate,
      'brandCompany': assigned_driver.brand,
      'model'       : assigned_driver.model,

      'usrLat' : operation.location[1],
      'usrLng' : operation.location[0],
      'taxiLat': assigned_driver.location[1],
      'taxiLng': assigned_driver.location[0],

      'assignedAt': at_now,

      'amount': amount

      'createdDate': moment(operation.created_at).format('YYYY-MM-DD hh:mm:ss'),
      'operation' : data_adapter.operationFromMongoToClient(operation),

      'message_id'               : '531113a472a1fa38ea0000a1',
      'message_need_confirmation': true,
    }
    message_ack_mg = data_adapter.PushMessageToMongo(operation, @msg, 0)
    message_ack_mg.save()
  .then (msg_ack) =>
    @bdcast = {
      'rtaxi_id' : operation.rtaxi_id,
      'driver_id': assigned_driver.driver_id,
      'user_id'  : operation.user.user_id,
    }
    @msg.message_id = msg_ack._id
    bk.broadcastOperation(@bdcast, @msg)
  .fail (err) =>
    unless err.message is 'CONCURRENCE_ASSIGN'
      if on_error?
        on_error()
      unless err.message is 'DOUBLE_ASSIGN'
        log.ex err, "Service:assignTripTo"


@getPhoneToCall = (rtaxi_id, driver) ->
  Q()
  .then =>
    @getAndCreateConfig rtaxi_id
  .then (cfg) =>
    phone_to_call = cfg.phone_number
    if(cfg.had_user_number and driver)
      phone_to_call = driver.phone
    return phone_to_call

@notifyAnotherDriverAssigned = (driver) ->
  msg = {
    'action': "company/AnotherDriverAssigned",

    'message_id'               : '53161f3e72a1fa9803000102',
    'message_need_confirmation': false
  }
  bk.broadcastToDriver driver.rtaxi_id, driver.driver_id, msg
