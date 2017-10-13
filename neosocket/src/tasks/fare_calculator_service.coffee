Q          = require 'q'
geo     = require '../geo/google_maps'
mongo   = require '../dbs/mongo'
bk      = require '../dbs/broadcast'
sql     = require '../dbs/sql'
service = require './service'
tools   = require '../tools'
config  = require '../../config'

log     = require('../log').create 'FareCalculatorService'

NO_OPERATIONS = "no_operations"
NO_DRIVER     = "no_driver"
NO_TIME_TO_ADD= "no_time_to_add"
NO_FARE_ACTIVE= "no_fare_active"
#Efecto Onda
#cuando el driver actualiza la posicion re actualizar los datos de facturacion.
#1 controlar entre punto y punto  distancia
#2 controlar entre punto y punto tiempo
#3 contadores de regla

@execute_job = () ->
  timeout = new Date
  timeout.setSeconds(
    timeout.getSeconds() - config.ping_limit_user
  )

  Q()
  .then =>
    mongo.CompanyConfig.find
      is_fare_calculator_active:true
  .then (companies) =>
    @rtaxi_ids = []
    @rtaxi_ids.push company.rtaxi_id for company in companies
  #   @process_topology 377943
  # .then () =>
    mongo.Operation.find
      rtaxi_id: $in: @rtaxi_ids
      status:   $in: config.oper_status.in_tx
    .populate('place_from place_to driver option user')
    .exec()
  .then (operations) =>
    console.log "FARE-CALCULATOR-CALCULATE length: #{operations.length}"
    if not operations.length > 0
      throw new Error NO_OPERATIONS
    @calculate_fares(operations)
  .then (fares) =>
    console.log "finish fare calculator"
  .fail (err) =>
    if err.message is NO_OPERATIONS
      return
    log.ex err, "fare_calculator:execute_job"

#This function takes in latitude and longitude of two location and returns the distance between them as the crow flies (in km)

@process_topology = (operation) ->
  Q()
  .then =>
    mongo.DriverOperationTopologyLog.find
      processed   : false
      operation_id: operation_id
    .sort
      created_at: 1
    .exec()
  .then (topologies) =>
    if topologies.length < 2
      return

    first_topo = null
    #restringe el valor por defecto minimo necesita un set de datos 2
    # no contempla caso de perdida de location
    for second_topo in topologies
      if not first_topo
        first_topo = second_topo
      else
        @calculate_and_save_fare first_topo, second_topo, config, operation
        first_topo = second_topo


@log_wave = (params) ->
  return;


#Pool IN transaction -- RealTime Function
@process_fare_driver_realtime = (params, driver, operation) ->
  if not config.fare_calculator.activated
    console.log "fare_calculator_disabled"
    return
  if operation.status not in config.oper_status.in_tx
    console.log "fare_calculator_status not implemented"
    return


  Q()
  .then =>
    service.getAndCreateConfig driver.rtaxi_id
  .then (cfg) =>
    @cfg = cfg
    if not cfg.is_fare_calculator_active
      throw new Error NO_FARE_ACTIVE
    mongo.DriverOperationTopologyLog.findOne
      processed   : false
      operation_id: operation.operation_id
    .sort
      created_at: -1
    .exec()
  .then (topology) =>
    @first_topo = topology
    status      = 'INITIAL_COST'
    if @first_topo
      status              = @first_topo.status
      grace_acum_distance = @first_topo.grace_acum_distance
      grace_acum_time     = @first_topo.grace_acum_time
    else
      grace_acum_distance = @cfg.fare_config_grace_period_meters
      grace_acum_time     = @cfg.fare_config_grace_time

    #MOVEMENT
    logdriver = new mongo.DriverOperationTopologyLog
      driver_id          : driver.driver_id
      rtaxi_id           : driver.rtaxi_id
      operation_id       : operation.operation_id
      location           : driver.location
      operation_status   : operation.status
      status             : status
      grace_acum_distance: grace_acum_distance
      grace_acum_time    : grace_acum_time


    logdriver.save()
  .then (second_topo) =>
    if @first_topo
      @calculate_and_save_fare @first_topo, second_topo, @cfg, operation
  .then =>
    @send_fares operation
    return "STOPPED";
  .fail (err) =>
    if err.message isnt NO_FARE_ACTIVE
      log.ex err, "fare_calculator:calculate_status"
    return 'NOT_LOGED'



@calculate_and_save_fare = (first_topo, second_topo, config, operation) ->
  Q()
  .then =>
    @first_loc   = first_topo.location
    @second_loc  = second_topo.location
    @first_date  = first_topo.created_at
    @second_date = second_topo.created_at

    @impact_distance = 0
    @temp_distance   = @calc_crow @first_loc[1],@first_loc[0],
      @second_loc[1], @second_loc[0]

    @temp_distance = Math.floor @temp_distance

    if @temp_distance > 10
      @impact_distance = @temp_distance

    @impact_date     = @calc_date @first_date, @second_date
    @impact_distance = Math.floor @impact_distance

    if(@impact_distance>(100*1000))
      throw new Error('ERROR_GPS')

    # if config.fare_calculator.log
    console.log "-----FARE_OPERATION: #{first_topo.operation_id}-- DRIVER #{first_topo.driver_id}--"
    console.log "-----FARE_SECONDS: #{@impact_date}----"
    console.log "----FARE_DISTANCE #{@impact_distance}--#{@first_topo}---"
    second_topo.second_loc    = @first_loc
    second_topo.time          = @impact_date
    second_topo.distance      = @impact_distance
    if @first_topo.grace_acum_distance > 0
      second_topo.grace_acum_distance = @first_topo.grace_acum_distance - @impact_distance
      if second_topo.grace_acum_distance < 0
        second_topo.grace_acum_distance = 0
        second_topo.acum_distance = @impact_distance - @first_topo.grace_acum_distance
    else
      second_topo.grace_acum_distance = 0
      second_topo.acum_distance = @impact_distance + first_topo.acum_distance

    if @first_topo.grace_acum_time > 0
      second_topo.grace_acum_time = @first_topo.grace_acum_time - @impact_date
      if second_topo.grace_acum_time < 0
        second_topo.grace_acum_time = 0
        second_topo.acum_time = @impact_date - first_topo.acum_time
    else
      second_topo.grace_acum_time = 0
      second_topo.acum_time = @impact_date      + first_topo.acum_time

    @generate_status second_topo, config
  .then (status_topo) =>
    second_topo.status = status_topo
    second_topo.save()
  .then (second_topo_s) =>
    @chargeOperation first_topo, second_topo_s, config, operation
  .fail (err) =>
    if err.message is not 'ERROR_GPS'
      log.ex err, "fare_calculator:calculate_and_save_fare"

@chargeOperation = (first_topo, second_topo_s, config, operation) ->
  type_charge = "NOTHING"
  amount      = 0
  process_charge = false
  if first_topo.status is second_topo_s.status
    if second_topo_s.status is 'DISTANCE'
      type_charge = 'DISTANCE'
      amount_coin    = config.fare_cost_per_km
      coin_value     = config.fare_config_activate_time_per_distance
      coin_res       = second_topo_s.acum_distance / coin_value

      abs_res_coin   = Math.floor coin_res
      rest_res_coin  = coin_res - abs_res_coin
      total_res_coin = abs_res_coin * amount_coin

      amount         = total_res_coin
      second_topo_s.acum_distance = rest_res_coin * coin_value
      process_charge = true
    else if second_topo_s.status is 'TIME'
      type_charge = 'TIME'

      amount_coin    = config.fare_cost_time_wait_perxseg
      coin_value     = config.fare_config_time_sec_wait
      coin_res       = second_topo_s.acum_time / coin_value

      abs_res_coin   = Math.floor coin_res
      rest_res_coin  = coin_res - abs_res_coin
      total_res_coin = abs_res_coin * amount_coin

      amount         = total_res_coin
      second_topo_s.acum_time = rest_res_coin * coin_value
      process_charge = true
      # console.log "---------------------"
      # console.log "----amount_coin#{amount_coin}-coin_value:#{coin_value}--coin_res:#{coin_res}---"
      # console.log "----abs_res_coin#{abs_res_coin}-rest_res_coin:#{rest_res_coin}--total_res_coin:#{total_res_coin}---"
      # console.log "----amount#{amount}-second_topo_s.acum_time:#{second_topo_s.acum_time}--process_charge#{process_charge}---"
      # console.log "---------------------"
  else if first_topo.status is 'WAIT' and second_topo_s.status is 'TIME'
    type_charge = 'WAIT'
    #change for charge first time wait only
    amount_coin    = config.fare_cost_time_initial_sec_wait
    coin_value     = config.fare_config_time_initial_sec_wait
    coin_res       = second_topo_s.acum_time / coin_value

    abs_res_coin   = Math.floor coin_res
    rest_res_coin  = coin_res - abs_res_coin
    total_res_coin = abs_res_coin * amount_coin

    amount         = total_res_coin
    second_topo_s.acum_time = rest_res_coin * coin_value
    process_charge = true
    console.log "---------------------"
    console.log "----amount_coin#{amount_coin}-coin_value:#{coin_value}--coin_res:#{coin_res}---"
    console.log "----abs_res_coin#{abs_res_coin}-rest_res_coin:#{rest_res_coin}--total_res_coin:#{total_res_coin}---"
    console.log "----amount#{amount}-second_topo_s.acum_time:#{second_topo_s.acum_time}--process_charge#{process_charge}---"
    console.log "---------------------"

  if not amount
    amount = 0

  if not process_charge
    return

  if operation.fare_calculator_discount?
    amount = (amount - (amount * (operation.fare_calculator_discount / 100)))
    console.log "FARE CALCULATOR DISCOUNT #{operation.fare_calculator_discount} amount:#{amount} current:#{total_res_coin}"

  Q()
  .then =>
    @add_charge
      opid       : first_topo.operation_id
      amount     : amount
      type_charge: type_charge
  .then ([fc_saved]) =>
    second_topo_s.operation_charge_id = fc_saved
    second_topo_s.save()
  .then (second_topo_s_s) =>
    console.log second_topo_s_s

@calculate_amount = (topology, acum_, coin, amount_coin, is_time = true) ->
  res_coin = acum_ / coin
  abs_res_coin = Math.floor res_coin
  rest_res_coin = res_coin - abs_res_coin
  total_res_coin = abs_res_coin * amount_coin
  console.log res_coin
  console.log abs_res_coin
  console.log rest_res_coin
  console.log total_res_coin
  Q()
  .then =>
    if is_time
      topology.acum_time    = topology.acum_time - abs_res_coin
    else
      topology.acum_distance = topology.acum_distance - abs_res_coin



@generate_status = (topology, config) ->
  acum_distance = Math.floor  topology.acum_distance
  console.log topology.acum_distance
  console.log config.fare_config_activate_time_per_distance
  console.log acum_distance > config.fare_config_activate_time_per_distance
  if acum_distance > config.fare_config_activate_time_per_distance
    return 'DISTANCE'
  if topology.status is 'INITIAL_COST'
    return 'WAIT'
  return @generate_status_by_time topology, config

@generate_status_by_time = (topology,config) ->
  to_time = config.fare_config_time_initial_sec_wait + 3

  abs_res_coin   = Math.floor topology.acum_time
  rest_res_coin  = topology.acum_time - abs_res_coin
  console.log "-------------222-------------"
  console.log abs_res_coin
  console.log to_time
  console.log topology.status
  console.log "-------------222-------------"
  if topology.status is 'WAIT'
    if abs_res_coin > to_time
      return 'TIME'
    else
      return 'WAIT'
  else
    return 'TIME'


@calc_date = (t1, t2) ->
  dif = t1.getTime() - t2.getTime()
  Seconds_from_T1_to_T2 = dif / 1000
  date_return = Math.abs(Seconds_from_T1_to_T2)

  return date_return

@calc_crow = (lat1, lon1, lat2, lon2) ->

  R = 6371;
  dLat = @to_rad(lat2-lat1)
  dLon = @to_rad(lon2-lon1)
  lat1 = @to_rad(lat1)
  lat2 = @to_rad(lat2)
  a = Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
  d = R * c
  d_km_to_m = d * 1000


  return d_km_to_m

# Converts numeric degrees to radians
@to_rad = (val) ->
  return val * (Math.PI / 180);

@calculate_fares = (operations) ->
  Q.all(
    for operation in operations
      @process_fare operation
  )
@process_fare = (operation) ->
  if not operation?.driver
    return null
  Q()
  .then =>
    @charge_operation operation
  .then =>
    @send_fares operation

@send_fares = (operation) ->
  if not operation?.driver
    return null

  msg =
    'action': "FareCalculator"
    'message_id'               : '53161f3e72a1fa9803000102'
    'message_need_confirmation': false

  Q()
  .then =>
    sql.getOperationChargesForDriver
      operation_id: operation.operation_id
  .then (result)=>
    for res in result[0]
      msg["#{res.type_charge}"] = res.charge.toFixed(2)
    if not operation?.driver
      throw new Error NO_DRIVER
    console.log "FARE-CALCULATOR-BROADCAST"
    console.log msg
    bk.broadcastToAllOperators operation.driver.rtaxi_id, msg
    bk.broadcastToDriver operation.rtaxi_id, operation.driver.driver_id, msg
    bk.broadcastToUser operation.rtaxi_id, operation.user.id, msg

    console.log "FARE-CALCULATOR-FINISH-BROADCAST"

  .fail (err) =>
    if err.message is NO_DRIVER
      return
    log.ex err, "fare_calculator:send_fares"

@charge_operation = (operation) ->
  console.log "charge_operation"
  if(operation.status is service.TRANSACTIONSTATUS.HOLDINGUSER)
    @check_time operation
  else if(operation.status in config.oper_status.in_tx)
    @check_time_and_distance operation


@check_time = (operation) ->
  Q()
  .then =>
    service.getAndCreateConfig operation.rtaxi_id
  .then (cfg) =>
    @cfg = cfg

    actual_date = new Date()

    date_initial = new Date(operation.created_at)
    date_initial.setSeconds(date_initial.getSeconds() + @cfg.fare_config_time_initial_sec_wait);

    interval_time = new Date(operation.created_at)
    interval_time.setSeconds(interval_time.getSeconds() + @cfg.fare_config_time_initial_sec_wait);
    interval_time.setSeconds(interval_time.getSeconds() + @cfg.fare_config_time_sec_wait);
    console.log @cfg.fare_config_time_initial_sec_wait
    console.log @cfg.fare_config_time_sec_wait

    if date_initial > actual_date
      throw new Error NO_TIME_TO_ADD

    console.log actual_date
    console.log date_initial
    console.log interval_time

    return
  .fail (err) =>
    if err.message is NO_TIME_TO_ADD
      return
    else
      log.ex err, "fare_calculator:check_time"
      throw err

@check_time_and_distance = (operation) ->
  Q()
  .then =>
  #   @check_time operation
  # .then =>
    return null


@charge_initial_time_in_zone = () ->
  return null

@charge_initial_time_in_zone = () ->
  return null

@charge_per_time_in_zone = () ->
  return null

@charge_per_distance = () ->
  return null


@final_charge = (operation_id, cfg) ->
  return null

@add_additionals = (message) ->
  if message.additionals?
    for additional in message.additionals
      service.fc_service.add_additional(additional, message)

@add_additional = (additional, params) ->
  Q()
  .then =>
    filter =
      operation_id: params.opid
      charge      : additional.amount.toFixed(2)
      json        : JSON.stringify params
      name        : additional.type
      type_charge : service.FC_TYPE.ADDITIONAL

    sql.addOperationCharges filter
  .then (charge) =>
    return charge

@add_charge = (args) ->
  Q()
  .then =>
    filter =
      operation_id: args.opid
      charge      : args.amount.toFixed(2)
      json        : JSON.stringify args
      name        : args.type_charge
      type_charge : args.type_charge
      version     : 0

    sql.addOperationCharges filter
  .then (charge) =>
    return charge
