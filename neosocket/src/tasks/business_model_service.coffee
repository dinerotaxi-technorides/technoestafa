###
Parking class, this class take the responsabilitiy for the parking and manage the queue.
###

mongo    = require '../dbs/mongo'
sql      = require '../dbs/sql'
service  = require './service'
config   = require '../../config'
tools    = require '../tools'
models   = require '../models_sequelize'

Q      = require 'q'
log    = require('../log').create 'BusinessModel'

@updateDrivers = () ->
  Q()
  .then =>
    mongo.Driver.find()
  .then (drivers) =>
    Q.all(
      for driver in drivers
        @updateDriverModels driver
    )
  .then (_d) =>
    @checkAndBlockDrivers()
  .then (_d) =>
    @syncDriversProfile()
  .fail (err) ->
    log.ex err, "updateDriverModels", ""


@checkAndBlockDrivers = ->
  log.i "Driver:checkAndBlockDrivers"

  Q()
  .then =>
    sql.findAllDriversToLock()
  .then (drivers) =>
    Q.all(
      for driver in drivers
        @updateDriverBlocked driver.driver_id

    )
  .then (drivers_) =>
    log.i "Driver:checkAndBlockDrivers FINISHED"
  .fail (err) =>
    log.ex err, "checkAndBlockDrivers", "", "IN"

@syncDriversProfile = ->
  log.i "Driver:syncDriversProfile"

  Q()
  .then =>
    models.configuration_app.findAll
      where:
        is_pre_paid_active: true
  .then (config_apps) =>
    Q.all(
      for config_app in config_apps
        @getCompanyFromConfig config_app.dataValues.id
    )
  .then (companies) =>
    Q.all(
      for company in companies
        if company.length >0
          console.log "companies #{company[0].id}"
          @syncCompany company[0].id
    )
  .fail (err) =>
    log.ex err, "syncDriversProfile", "", "IN"

@syncCompany = (rtaxi_id) ->
  if not rtaxi_id
    return
  console.log "RTAXI #{rtaxi_id}"
  Q()
  .then =>
    models.user.findAll
      where:
        rtaxi_id   : rtaxi_id
        enabled    : true
        type_employ: 'TAXISTA'
  .then (drivers) =>
    for driver in drivers
      @updateUserBySqlProfile driver
  .fail (err) =>
    log.ex err, "syncCompany", "", "IN"


@updateUserBySqlProfile = (user) ->
  if not user
    return

  Q()
  .then =>
    mongo.Driver.findOne
      driver_id: user.id
    .exec()
  .then (driver) =>
    if not driver
      throw new Error('NO_USER_FOUND')

    driver.is_vip               =  user.is_vip ? true
    driver.is_pet               =  user.is_pet ? true
    driver.is_air_conditioning  =  user.is_air_conditioning ? true
    driver.is_smoker            =  user.is_smoker ? true
    driver.is_special_assistant =  user.is_special_assistant ? true
    driver.is_luggage           =  user.is_luggage ? true
    driver.is_airport           =  user.is_airport ? true
    driver.is_invoice           =  user.is_invoice ? true
    driver.is_messaging         =  user.is_messaging ? true

    driver.is_regular           =  user.is_regular ? true
    driver.is_corporate         =  user.is_corporate ? true
    driver.save()
  .fail (err) =>
    if err.message is not 'NO_USER_FOUND'
      log.ex err, "updateUserBySqlProfile", "", "IN"


@getCompanyFromConfig = (config_app) ->
  Q()
  .then =>
    models.user.findAll
      where:
        wlconfig_id: config_app
  .then (rtaxi) =>
    return rtaxi
  .fail (err) =>
    log.ex err, "getCompanyFromConfig", "", "IN"



@updateDriverBlocked = (driver) ->
  Q()
  .then =>
    mongo.Driver.findOne
      driver_id : driver
      is_blocked: false
    .exec()
  .then (mg_driver) =>
    if not mg_driver
      log.i "driver #{driver} is ",mg_driver
      return
    mg_driver.is_blocked = true
    mg_driver.save()
  .then (mg_driver_) =>
    return mg_driver_
  .fail (err) =>
    log.ex err, "checkAndBlockDrivers", "", "IN"

@updateDriverModels = (driver) ->
  Q()
  .then =>
    @getModels driver.driver_id
  .then (models) =>
    driver.business_model = []
    driver.business_model = models
    @updateFilters driver.driver_id
  .then (filters) =>
    if filters
      driver.is_vip               =  filters.is_vip ? true
      driver.is_pet               =  filters.is_pet ? true
      driver.is_air_conditioning  =  filters.is_air_conditioning ? true
      driver.is_smoker            =  filters.is_smoker ? true
      driver.is_special_assistant =  filters.is_special_assistant ? true
      driver.is_luggage           =  filters.is_luggage ? true
      driver.is_airport           =  filters.is_airport ? true
      driver.is_invoice           =  filters.is_invoice ? true
      driver.is_regular           =  filters.is_regular ? true
      driver.is_corporate         =  filters.is_corporate ? true

    driver.save()
  .then (driver) =>
    return driver
  .fail (err) ->
    log.ex err, "updateDriverModels", "driver_id: #{driver_id}"


@getModels = (driver_id) ->
  log.i "business_model:getModels #{driver_id}"
  Q()
  .then =>
    sql.findUserBusinessModel
      id: driver_id
  .then (business_models) =>
    bs = (bs.name for bs in business_models)
    return bs
  .fail (err) ->
    log.ex err, "getModels", "driver_id: #{driver_id}"


@updateFilters = (driver_id) ->
  log.i "business_model:updateFilters #{driver_id}"
  Q()
  .then =>

    models.user.find
      where:
        id: driver_id
  .then (driver) =>
    if not driver
      throw new Error('')
    return driver
  .fail (err) ->
    log.ex err, "updateFilters", "driver_id: #{driver_id}"
