config     = require '../../config'
moment     = require('moment')
moment_tz  = require('moment-timezone')


knex = require('knex')
  client    : 'mysql'
  connection: config.mysql
  pool:
    min: config.mysql_pool.min
    max: config.mysql_pool.max
  debug: false


###*
  -----------
    USERS
  -----------
###
@findUser = (filter) ->
  query = knex
    .select(
      'user.id as user_id', 'user.rtaxi_id',
      'user.email', 'user.first_name', 'user.last_name', 'user.phone',
      'user.company_name', 'user.class as clazz',
      'user.is_frequent', 'user.lang', 'user.city_id',
      'login.token','user.cost_center_id',
      'corp.name as company_name'
    ).from 'user'
    .leftOuterJoin 'persistent_logins as login' , ->
      @on    'login.username', '=', 'user.username'
      @andOn 'login.rtaxi', '=', 'user.rtaxi_id'
    .leftOuterJoin 'cost_center as c_c' , ->
      @on    'c_c.id', '=', 'user.cost_center_id'
    .leftOuterJoin 'corporate as corp' , ->
      @on    'corp.id', '=', 'c_c.corporate_id'

  if 'id' of filter
    query.where 'user.id': filter.id
  query

@findUserByOperation = (filter) ->
  query = knex
    .select(
      'user.id as user_id', 'user.rtaxi_id',
      'user.email', 'user.first_name', 'user.last_name', 'user.phone',
      'user.company_name', 'user.class as clazz',
      'user.lang as language', 'user.city_id',
    ).from 'user'
    .leftOuterJoin 'operation as operation' , ->
      @on    'user.id', '=', 'operation.user_id'

  if 'id' of filter
    query.where 'operation.id': filter.id
  query

@findConfigBy = (filter) ->
  query = knex
    .select(
      'usr.id as rtaxi_id', 'cfg.time_delay_trip','cfg.distance_search_trip' ,
      'cfg.driver_search_trip','cfg.parking',
      'cfg.parking_distance_driver',
      'cfg.parking_distance_trip','cfg.percentage_search_ratio',
      'cfg.has_zone_active',
      'cfg.cost_rute','cfg.cost_rute_per_km','cfg.cost_rute_per_km_min',
      'cfg.has_required_zone', 'cfg.has_mobile_payment', 'cfg.zoho',
      'cfg.endless_dispatch', 'cfg.had_user_number', 'usr.phone as phone_number',
      'cfg.has_driver_dispatcher_function', 'cfg.is_fare_calculator_active','cfg.credit_card_enable',
      'cfg.fare_initial_cost', 'cfg.fare_cost_per_km', 'cfg.fare_config_activate_time_per_distance',
      'cfg.fare_config_time_sec_wait', 'cfg.fare_config_time_initial_sec_wait', 'cfg.fare_cost_time_wait_perxseg',
      'cfg.fare_cost_time_initial_sec_wait','cfg.fare_config_grace_period_meters as fare_config_grace_period_meters',
      'cfg.fare_config_grace_time as fare_config_grace_time','cfg.driver_cancel_trip', 'cfg.parking_polygon',
      'cfg.is_queue_trip_activated', 'cfg.dispute_time_trip', 'cfg.queue_trip_type',
      'cfg.android_token','cfg.apple_password','cfg.apple_ip','cfg.apple_port','cfg.apple_certificate_path','cfg.paypal'
    ).from 'user as usr'
    .innerJoin 'configuration_app as cfg' , ->
      @on    'cfg.id', '=', 'usr.wlconfig_id'
  query.where 'usr.id': filter.id
  query

@findUserProfile = (filter) ->
  query = knex
    .select(
      'user.id',
      'user.first_name','user.last_name','user.phone','user.email',
      'user.type_employ as type_user'
    ).from 'user as user'
  query.where 'user.id': filter.id
  query

@findUserProfileByAdmin = (filter) ->
  query = knex
    .select(
      'user.id',
      'user.first_name','user.last_name','user.phone','user.email',
      'user.type_employ as type_user'
    ).from 'user as user'
  query.where 'user.id'       : filter.id
  query.where 'user.rtaxi_id' : filter.rtaxi_id
  query

@findUserByToken = (filter) ->
  if not filter.token
    return []

  query = knex
    .select(
      'pl.username', 'pl.rtaxi as rtaxi_id', 'usr.type_employ as user_type', 'usr.class as type', 'usr.id'
    ).from 'persistent_logins as pl'
    .innerJoin 'user as usr', ->
      @on 'usr.username' , '=','pl.username'
      @on 'usr.rtaxi_id' , '=','pl.rtaxi'
    .where 'pl.token' , '=',filter.token
  query

@findAdminByToken = (filter) ->
  if not filter.token
    return []

  query = knex
    .select(
      'pl.username', 'usr.type_employ as user_type', 'usr.class as type', 'usr.id'
    ).from 'persistent_logins as pl'
    .innerJoin 'user as usr', ->
      @on 'usr.username' , '=','pl.username'
    .where 'pl.token'    , '=',filter.token
    .where knex.raw("usr.class = 'ar.com.goliath.Company'")
  query

@findUserBusinessModel = (filter) ->
  query = knex
    .select(
      'bs.name'
    ).from 'user_business_model as ubs'
    .leftOuterJoin 'business_model as bs' , ->
      @on    'bs.id', '=', 'ubs.business_model_id'

  if 'id' of filter
    query.where 'ubs.user_id': filter.id
  query

@findRecentDisabledUsers = (filter) ->
  if not filter.type_employ
    return []

  tz = moment_tz()
    .tz "America/Buenos_Aires"
    .format 'YYYY-MM-DD HH:mm:ss'

  dateTo = moment(tz)
    .toDate()

  dateFrom = moment(tz)
    .add config.tasks.disconectBlockedUsers.timer.split(" ")[0] * -1, 'seconds'
    .toDate()

  query = knex
    .select(
      'user.id as user_id', 'user.rtaxi_id'
    ).from 'user'
    .whereBetween 'last_modified_date', [dateFrom, dateTo]
    .whereIn 'type_employ', filter.type_employ
    .where 'enabled': false
  query



###*
  -----------
    COMPANY
  -----------
###

@findAllCompanies = ->
  query = knex
    .select(
      'id'
    ).from 'user as usr'
    .where
        'usr.class': 'ar.com.goliath.Company',
        'enabled'  :  true
  query


###*
  -----------
  OPERATIONS
  -----------
###

@reportForOperation = (filter) ->
  query = knex
    .select(
      'user.id as user_id', 'user.created_date',
      'user.ip', 'user.first_name', 'user.last_name', 'operation.status'
    ).from 'operation as operation'
    .leftOuterJoin 'user as user' , ->
      @on  'user.id', '=', 'operation.user_id'

  if 'id' of filter
    query.where 'operation.id': filter.id
  query

@findPendingOperations = () ->
  d = new Date()
  d.setHours(d.getHours() - 1)
  d1 = new Date()
  d1.setHours(d1.getHours() + 1)
  query = knex
    .select(
      'op.id as operation_id' ,'op.driver_number'    ,
      'op.driver_number'      ,'op.payment_reference',
      'op.created_by_operator','op.ip'               ,
      'op.is_delay_operation' ,'op.status'            ,
      'op.id as operation_id' ,'op.dev as device'     ,
      'op.class as clazz'     ,'op.cost_center_id'   ,
      'op.user_id'            ,'op.company_id as rtaxi'   ,
      'op.is_delay_operation' ,'fav.comments',
      'op.amount','op.company_id as rtaxi_id'  ,'op.send_to_socket' ,


      'place_from.lng as place_from_lng','place_from.lat as place_from_lat',
      'place_to.lng as place_to_lng'    ,'place_to.lat as place_to_lat',
      'place_from.street_number as place_from_street_n'   ,'place_to.street_number as place_to_street_n',

      'place_from.json as p_from_json'          ,'place_to.json as p_to_json',
      'fav.place_from_dto'       ,'fav.place_from_pso',
      'fav.place_to_apartment'   ,'fav.place_to_floor',

      'opt.messaging'        ,'opt.pet',
      'opt.air_conditioning' ,'opt.smoker',
      'opt.special_assistant','opt.luggage',
      'opt.airport'          ,'opt.vip',
      'opt.invoice'

    ).from 'operation as op'
    .leftOuterJoin 'user as user' , ->
      @on    'user.id', '=', 'op.user_id'
    .leftOuterJoin 'temporal_favorites as fav' , ->
      @on    'fav.id', '=', 'op.favorites_id'
    .leftOuterJoin 'place as place_from' , ->
      @on    'place_from.id', '=', 'fav.place_from_id'
    .leftOuterJoin 'place as place_to' , ->
      @on    'place_to.id', '=', 'fav.place_to_id'
    .leftOuterJoin 'options as opt' , ->
      @on    'opt.id', '=', 'op.options_id'
    .leftOuterJoin 'corporate as corp' , ->
      @on    'corp.id', '=', 'op.corporate_id'
    .leftOuterJoin 'cost_center as c_c' , ->
      @on    'c_c.id', '=', 'op.cost_center_id'
    .whereBetween 'op.created_date',[d, d1]
    .where 'op.send_to_socket',knex.raw('false')
  query

@findStatusOperations = (status = [], time = 5, in_status = true) ->
  d = new Date()
  d.setHours(d.getHours() - 20)
  d1 = new Date()
  d1.setMinutes(d1.getMinutes() - time)
  query = knex
    .select(
      'op.id as operation_id' ,'op.driver_number'    ,
      'op.driver_number'      ,'op.payment_reference',
      'op.created_by_operator','op.ip'               ,
      'op.is_delay_operation' ,'op.status'            ,
      'op.id as operation_id' ,'op.dev as device'     ,
      'op.class as clazz'     ,'op.cost_center_id'   ,
      'op.taxista_id as driver_id',
      'op.user_id'            ,'op.company_id as rtaxi'   ,
      'op.is_delay_operation' ,'fav.comments',
      'op.amount','op.company_id as rtaxi_id'  ,'op.send_to_socket' ,


      'place_from.lng as place_from_lng','place_from.lat as place_from_lat',
      'place_to.lng as place_to_lng'    ,'place_to.lat as place_to_lat',
      'place_from.street_number as place_from_street_n'   ,'place_to.street_number as place_to_street_n',

      'place_from.json as p_from_json'          ,'place_to.json as p_to_json',
      'fav.place_from_dto'       ,'fav.place_from_pso',
      'fav.place_to_apartment'   ,'fav.place_to_floor',

      'opt.messaging'        ,'opt.pet',
      'opt.air_conditioning' ,'opt.smoker',
      'opt.special_assistant','opt.luggage',
      'opt.airport'          ,'opt.vip',
      'opt.invoice'

    ).from 'operation as op'
    .leftOuterJoin 'user as user' , ->
      @on    'user.id', '=', 'op.user_id'
    .leftOuterJoin 'temporal_favorites as fav' , ->
      @on    'fav.id', '=', 'op.favorites_id'
    .leftOuterJoin 'place as place_from' , ->
      @on    'place_from.id', '=', 'fav.place_from_id'
    .leftOuterJoin 'place as place_to' , ->
      @on    'place_to.id', '=', 'fav.place_to_id'
    .leftOuterJoin 'options as opt' , ->
      @on    'opt.id', '=', 'op.options_id'
    .leftOuterJoin 'corporate as corp' , ->
      @on    'corp.id', '=', 'op.corporate_id'
    .leftOuterJoin 'cost_center as c_c' , ->
      @on    'c_c.id', '=', 'op.cost_center_id'
    .whereBetween 'op.created_date',[d, d1]

  if in_status
    query.whereIn 'op.status', status
  else
    query.whereNotIn 'op.status', status
  query

@findOperation = (operation_id) ->
  query = knex
  .select(
    'op.id as operation_id' ,'op.driver_number'    ,
    'op.driver_number'      ,'op.payment_reference',
    'op.created_by_operator','op.ip'               ,
    'op.is_delay_operation' ,'op.status'            ,
    'op.id as operation_id' ,'op.dev as device'     ,
    'op.class as clazz'     ,'op.cost_center_id'   ,
    'op.user_id'            ,'op.company_id as rtaxi'   ,
    'op.is_delay_operation' ,'fav.comments',
    'op.amount','op.company_id as rtaxi_id'  ,'op.send_to_socket' ,


    'place_from.lng as place_from_lng','place_from.lat as place_from_lat',
    'place_to.lng as place_to_lng'    ,'place_to.lat as place_to_lat',
    'place_from.street_number as place_from_street_n'   ,'place_to.street_number as place_to_street_n',

    'place_from.json as p_from_json'          ,'place_to.json as p_to_json',
    'fav.place_from_dto'       ,'fav.place_from_pso',
    'fav.place_to_apartment'   ,'fav.place_to_floor',

    'opt.messaging'        ,'opt.pet',
    'opt.air_conditioning' ,'opt.smoker',
    'opt.special_assistant','opt.luggage',
    'opt.airport'          ,'opt.vip',
    'opt.invoice'

  ).from 'operation as op'
  .leftOuterJoin 'user as user' , ->
    @on    'user.id', '=', 'op.user_id'
  .leftOuterJoin 'temporal_favorites as fav' , ->
    @on    'fav.id', '=', 'op.favorites_id'
  .leftOuterJoin 'place as place_from' , ->
    @on    'place_from.id', '=', 'fav.place_from_id'
  .leftOuterJoin 'place as place_to' , ->
    @on    'place_to.id', '=', 'fav.place_to_id'
  .leftOuterJoin 'options as opt' , ->
    @on    'opt.id', '=', 'op.options_id'
  .leftOuterJoin 'corporate as corp' , ->
    @on    'corp.id', '=', 'op.corporate_id'
  .leftOuterJoin 'cost_center as c_c' , ->
    @on    'c_c.id', '=', 'op.cost_center_id'
  .where 'op.id',operation_id
  query

@findOperation = (operation_id) ->
  query = knex
    .select(
      'op.id as operation_id' ,'op.driver_number'    ,
      'op.driver_number'      ,'op.payment_reference',
      'op.created_by_operator','op.ip'               ,
      'op.is_delay_operation' ,'op.status'            ,
      'op.id as operation_id' ,'op.dev as device'     ,
      'op.class as clazz'     ,'op.cost_center_id'   ,
      'op.user_id'            ,'op.company_id as rtaxi'   ,
      'op.is_delay_operation' ,'fav.comments',
      'op.amount','op.company_id as rtaxi_id'  ,'op.send_to_socket' ,


      'place_from.lng as place_from_lng','place_from.lat as place_from_lat',
      'place_to.lng as place_to_lng'    ,'place_to.lat as place_to_lat',
      'place_from.street_number as place_from_street_n'   ,'place_to.street_number as place_to_street_n',

      'place_from.json as p_from_json'          ,'place_to.json as p_to_json',
      'fav.place_from_dto'       ,'fav.place_from_pso',
      'fav.place_to_apartment'   ,'fav.place_to_floor',

      'opt.messaging'        ,'opt.pet',
      'opt.air_conditioning' ,'opt.smoker',
      'opt.special_assistant','opt.luggage',
      'opt.airport'          ,'opt.vip',
      'opt.invoice'

    ).from 'operation as op'
    .leftOuterJoin 'user as user' , ->
      @on    'user.id', '=', 'op.user_id'
    .leftOuterJoin 'temporal_favorites as fav' , ->
      @on    'fav.id', '=', 'op.favorites_id'
    .leftOuterJoin 'place as place_from' , ->
      @on    'place_from.id', '=', 'fav.place_from_id'
    .leftOuterJoin 'place as place_to' , ->
      @on    'place_to.id', '=', 'fav.place_to_id'
    .leftOuterJoin 'options as opt' , ->
      @on    'opt.id', '=', 'op.options_id'
    .leftOuterJoin 'corporate as corp' , ->
      @on    'corp.id', '=', 'op.corporate_id'
    .leftOuterJoin 'cost_center as c_c' , ->
      @on    'c_c.id', '=', 'op.cost_center_id'
    .where 'op.id',operation_id
  query

@findPendingOperationsByTime = (rtaxi_id) ->
  @dftome_b = new Date()
  @dftome_b.setSeconds(@dftome_b.getSeconds() - config.bids_algorithm.seconds_ajust_alarm)
  today     = new Date(@dftome_b.getTime())
  query = knex
    .select(knex.raw('count(1) as count'),knex.raw('GROUP_CONCAT(id) as operations'),'op.company_id as rtaxi'
    ).from 'operation as op'
    .whereIn 'op.company_id',rtaxi_id
    .where 'op.status','PENDING'
    .where 'op.created_date','<', today
    .groupByRaw('rtaxi')
  query

@findDiedOperations = () ->
  @dftome_b = new Date()
  @dftome_b.setHours(@dftome_b.getHours() - 4)
  today     = new Date(@dftome_b.getTime())

  query = knex
    .select('op.id','op.status','op.class'
    ).from 'operation as op'
    .whereNotIn 'op.status',['CANCELED','CANCELED_EMP','CANCELED_DRIVER','CALIFICATED','CANCELTIMETRIP','COMPLETED','SETAMOUNT']
    .where 'op.created_date','<', today
  query

@findTripById = (filter) ->
  query = knex
    .select(
      'id','taxista_id'
    ).from 'operation'
    .where
      'id'  :  filter.id
  query

@countPendingDelayOperations = (filter) ->
  query = knex
    .select(
      knex.raw('COUNT(id) count')
    ).from 'delay_operation'
    .where filter
  query

@getPendingDelayOperations = (filter) ->
  console.log("><><><><><><><><><><><><><><><><><><><><>")
  console.log("hello BAC-172")
  console.log(filter);
  today =  new Date()
  today.setMinutes(today.getMinutes() - 60)
  query = knex
    .select('id','user_id','company_id as rtaxi_id'
    ).from 'delay_operation'
    .where 'status':'PENDING'
    .where 'pushed_to_device':false
    .where 'execution_time','>', today
  query

@updatePushOperationDelay = (ids) ->
  query = knex('delay_operation')
    .update 'pushed_to_device':true
    .whereIn 'id', ids
  query

@updateOperation = (filter) ->
  if 'driver' of filter
    filter.taxista_id = filter.driver
    delete filter.driver
  if 'rtaxi' of filter
    filter.company_id = filter.rtaxi
    delete filter.rtaxi
  if 'clazz' of filter
    filter.class = filter.clazz
    delete filter.clazz

  query = knex('operation')
    .update filter
    .where 'id', filter.id
  query


@getOperationCharges = (filter) ->
  query = knex.raw(config.query.get_operation_charges,
    [filter.operation_id,filter.operation_id,filter.operation_id,filter.operation_id])
  query

@getOperationChargesForDriver = (filter) ->
  query = knex.raw(config.query.get_operation_charge_driver,
    [filter.operation_id,filter.operation_id,filter.operation_id])
  query

@addOperationCharges = (filter) ->
  query = knex('operation_charges')
  .insert
      operation_id: filter.operation_id
      charge      : filter.charge
      json        : filter.json
      name        : filter.name
      type_charge : filter.type_charge
      created_date: new Date()
      version     : 0

  .returning('*')
  query

@addOperationLog = (filter) ->
  if not filter.status
    filter.status = 'UNKNOW'
  if not filter.code
    filter.code = 0
  if not filter.reason
    filter.reason = ''
  query = knex('user_operation_log')
  .insert
      operation_id: filter.operation_id
      user_id     : filter.user_id
      code        : filter.code
      reason      : filter.reason
      status      : filter.status

      last_modified_date: new Date()
      created_date      : new Date()
  .returning('*')
  query


###*
  -----------
    DRIVERS
  -----------
###

@findAllDriversToLock = (filter) ->
  query = knex
    .select(
      'user.id as driver_id'
    ).from 'user as user'
    .leftOuterJoin 'user as rtaxi' , ->
      @on    'user.rtaxi_id', '=', 'rtaxi.id'
    .where
      'rtaxi.enabled'      :  true,
      'user.account_locked':  true
  query

@findAllDriversByCompany = (filter) ->
  query = knex
    .select(
      'id',
      knex.raw('(visible & agree & enabled & !account_locked) is_blocked'),
      'rtaxi_id'
    ).from 'user'
    .where
      'type_employ': 'TAXISTA',
      'rtaxi_id'  :  filter.rtaxi_id
  query

@findDriver = (filter) ->
  query = knex
    .select(
      'user.id as driver_id', 'user.rtaxi_id',
      'user.first_name','user.last_name','user.phone','user.email',
      'user.employee_id','ve.marca as brand','ve.modelo as model','ve.patente as plate'
    ).from 'user as user'
    .leftOuterJoin 'enabled_cities as city' , ->
      @on    'city.id', '=', 'user.city_id'
    .leftOuterJoin 'vehicle_employ_user as ve_jo' , ->
      @on    've_jo.employ_user_id', '=', 'user.id'
    .leftOuterJoin 'vehicle as ve' , ->
      @on    've.id', '=', 've_jo.vehicle_taxistas_id'

  query.where 'user.type_employ': 'TAXISTA'

  if 'id' of filter
    query.where 'user.id': filter.id
  else if 'email' of filter
    query.where 'user.email': filter.email
  else if 'driver_number' of filter
    query.where 'user.email','like', "#{filter.driver_number}@%"
  query

###*
  -----------
    PARKING
  -----------
###

@findZones = (filter) ->
  query = knex
    .select(
      'z.id','z.coordinates','z.name','z.user_id'
    ).from 'persistent_logins as pl'
    .innerJoin 'user as usr', ->
      @on 'usr.username' , '=','pl.username'
    .innerJoin 'zone as z' , ->
      @on 'z.user_id', '=', 'usr.id'
    .where
      'pl.token': filter.token,
    .whereNull('usr.rtaxi_id')
  query

@findZonesPricing = (filter) ->
  query = knex
    .select(
      'id','amount'
    ).from 'zone_pricing'
    .where
      'zone_from_id': filter.zone_from_id,
      'zone_to_id'  : filter.zone_to_id,
      'user_id'     : filter.rtaxi_id,
  query

@loadZones = (filter) ->
  query = knex
    .select(
      'z.id as zone_id','z.coordinates as location','z.name','z.user_id as rtaxi_id'
    ).from 'zone as z'
  query

@loadZonesById = (filter) ->
  query = knex
    .select(
      'z.id as zone_id','z.coordinates as location','z.name','z.user_id as rtaxi_id'
    ).from 'zone as z'
    .where
      'user_id': filter.rtaxi_id
  query

@findAllParking = ->
  query = knex
    .select(
      'id as parking_id','lat','lng','name',
      'user_id as rtaxi_id','is_polygon',
      'coordinates_in as coordinates_out','coordinates_out as coordinates_in',
      'business_model'
    ).from 'parking'
  query

@deleteParking = (id)->
  query = knex('parking')
    .where('id':id)
    .del()
  query

@findParkings = (id)  ->
  query = knex
    .select(
      'id as parking_id','lat','lng','name','user_id as rtaxi_id'
    ).from 'parking'
    .where 'user_id': id
    .where 'is_polygon': false
  query

###*
  -----------
    PAYPAL
  -----------
###

@getPaypalMerchant = (filter) ->
  query = knex
    .select(
      'id', 'caller_id', 'caller_password', 'caller_signature'
    ).from 'paypal_merchant'

  if 'id' of filter
    query.where 'id': filter.id
  else if 'rtaxi_id' of filter
    query.where 'company_id': filter.rtaxi_id
  query

@addPaypalMerchant  = (data) ->
  query = knex('paypal_merchant')
    .insert
        caller_id       : data.caller_id
        caller_password : data.caller_password
        caller_signature: data.caller_signature
        company_id      : data.company_id
        version         : data.version
    .returning('*')
  query

@updatePaypalMerchant = (data) ->
  query = knex('paypal_merchant')
    .update data
    .where 'id', data.id
  query
