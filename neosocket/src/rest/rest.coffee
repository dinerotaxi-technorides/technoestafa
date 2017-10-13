Q            = require 'q'
express      = require 'express'
fs           = require 'fs'
bodyParser   = require 'body-parser'
moment       = require 'moment'
request      = require 'request'
util         = require 'util'
https        = require 'https'
mongo        = require '../dbs/mongo'
sql          = require '../dbs/sql'
bk           = require '../dbs/broadcast'
data_adapter = require '../dbs/data_adapter'
DataStore    = require '../dbs/data_store'
reports      = require '../dbs/reports'
chat_rest       = require './chat_rest'
google_places   = require './google_places'
recharge_driver = require './recharge_driver'
stripe_rest     = require './stripe_rest'
service         = require '../tasks/service'
costs           = require '../tasks/cost_calculator'
payment         = require '../tasks/payment_utils'
tools           = require '../tools'
config          = require '../../config'
countries       = require '../../countries'
paypal          = require './paypal'
swagger         = require './swagger'
adyen           = require './adyen'
zoho            = require './zoho'
log             = require('../log').create 'Rest'

credit_card_information = require './credit_card_information'

#v3_api                           = require '../v3/routes'
#internal_server_error_middleware = require '../v3/middlewares/internal_server_error_middleware'


store = new DataStore
@app = app = express()
app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

#for now, this is not enabled
#app.use '/v3', v3_api
#app.use '/v3', internal_server_error_middleware
app.use '/chat'   , chat_rest
app.use '/google' , google_places
app.use '/driver/recharge', recharge_driver
app.use '/stripe' , stripe_rest
app.use '/payment', credit_card_information
app.use '/paypal' , paypal
app.use '/swagger', swagger

#warning no funcionan los recursos
# app.use (req, res, next) ->
#   res.status 404
#   # respond with html page
#   if req.accepts('jade')
#     res.send '{"status":404}'
#     return
#   # respond with json
#   if req.accepts('json')
#     res.send error: 'Not found'
#     return
#   # default to plain-text. send()
#   res.type('txt').send 'Not found'
#   return


servers = []

INVALID_TOKEN = "invalid token"
NO_LOG        = "NO_LOG"
@startServer = ->
  console.log "started:rest_server"
  deferred = Q.defer()

  if config.rest.ports.length < 1
    throw new Error "no rest defined. Please check your config"

  for port in config.rest.ports
    server = app.listen port, (err) ->
      if err?
        deferred.reject err
      else
        log.i "Started"
        deferred.resolve()

    servers.push server
  if config.ssl.is_enabled

    hskey   = fs.readFileSync(config.ssl.key)
    hscert  = fs.readFileSync(config.ssl.certificate)
    options =
      key : hskey
      cert: hscert

    secureServer = https.createServer(options, app)
    secureServer.listen config.ssl.port, (err) ->
      if err?
        deferred.reject err
      else
        log.i "SSL STARTED Started"
        deferred.resolve()



@stopServer = ->
  for server in servers
    if server?
      log.i "Stopped"
      server.close()
    else
      log.w "stopServer() called, but server is not running"

  # This function is actually synchronous: we return a Promise to blend in with
  # other services that require async shutdown.
  Q()

app.all '*', (req, res, next) ->

  Q()
  .then ->

    res.header('Access-Control-Allow-Origin', '*')
    res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
    res.header('Access-Control-Allow-Headers', 'Content-Type')

    rest_log = new mongo.DebugLog
      type : "rest"
      url  : util.inspect res.req._parsedUrl.pathname
      body : JSON.stringify req.body
    rest_log.save()
  .then (log)->
    next()
  .fail (err) =>
    log.ex err, "app.all ", ""
    next()

app.get '/', (req, res, next) ->
  res.send '{"status":200}'

# { token: 'Dhu06ShDXjpsywfPI2tUxg==',add_from: '-12.0049798,-77.10775919999998',  add_to: '-12.031088082136112,-77.0950562581055' }
app.get '/costCalculator/:token/:add_from/:add_to', (req, res, next) ->
  Q()
  .then ->

    store.validateToken(req.params.token)
  .then (token)->
    if not token
      throw new Error INVALID_TOKEN

    sql.findUserByToken {token : req.params.token}
  .then ([user]) ->
    if not user
      throw new Error "User not found"

    costs.calculateCost user.rtaxi_id, req.params.add_from, req.params.add_to, req.params.token
  .then (cost) ->
    console.log cost
    if cost?
      log.d "Cost was #{cost}"
      response =
        status: 200
        amount: cost.amount
        json  : cost
    else
      response =
        status: 400
        amount:  0
        json  : {}
        description: "can't find path from origin to destination"

    res.send JSON.stringify response
  .fail (err) =>
    if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message}
      return

    response =
      status: 400
      err   : err.stack
    res.send JSON.stringify response


app.get '/zones/:rtaxi_id', (req, res, next) ->
  log.i req.params.rtaxi_id
  #69108
  Q()
  .then =>

    store.validateToken(req.query.token)
  .then (token)->
    if not token
      throw new Error INVALID_TOKEN

    mongo.Zone.remove
      rtaxi_id: req.params.rtaxi_id
  .then =>
    sql.loadZonesById({rtaxi_id:req.params.rtaxi_id})
  .then (zones) =>
    for zone in zones
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

        .fail (err) ->
          log.ex err, "loadZones", "", "IN"
  .then =>
    res.send '{"status":200}'
  .fail (err) ->
    if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message}
      return
    else
      log.ex err, "calculateCost", "token: #{token}"
      res.send {'status':400, reason:err.message}


#http://technorides.co:2001/disconnect_driver/d303be78d55dfdf8df06031a76cd9065/16889/3000/3000
app.get '/disconnect_driver/:token/:id/:code/:reason', (req, res, next) ->

  log.e "disconnect_driver #{req.connection.remoteAddress}, #{req.params.id} ,#{req.params.code}, "
  if req.params.token is config.token_admin
    Q()
    .then =>

      store.validateToken(req.params.token)
    .then (token)->
      if not token
        throw new Error INVALID_TOKEN

      mongo.Driver.findOne
        driver_id: req.params.id
      .exec()
    .then (user) =>
      code = parseInt( req.params.code, 10 )
      if user?
        tools.closeConnection 'driver',user.rtaxi_id, user.driver_id, code, req.params.reason

        res.send '{"status":200}'
      else
        res.send '{"status":200,"reason":"doesnt exist"}'
    .fail (e)->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
        return
      else
        log.ex e, "disconnect_driver", ""
        res.send {'status':11, reason:err.message}
  else
    res.send '{"status":200}'

#http://technorides.co:2001/disconnect_operator/password/16888/3000/3000
app.get '/disconnect_operator/:token/:id/:code/:reason', (req, res, next) ->

  log.e "disconnect_operator #{req.connection.remoteAddress}, #{req.params.id} ,#{req.params.code}, "
  if req.params.token is config.token_admin
    Q()
    .then =>

      store.validateToken(req.params.token)
    .then (token)->
      if not token
        throw new Error INVALID_TOKEN

      mongo.Company.findOne
        company_id: req.params.id
      .exec()
    .then (user) =>
      code = parseInt( req.params.code, 10 )

      if user?
        tools.closeConnection 'operator',user.rtaxi_id, user.company_id, code, req.params.reason
        res.send '{"status":200}'
      else
        res.send '{"status":11,"reason":"doesnt exist"}'

    .fail (e)->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
        return
      else
        log.ex e, "disconnect_operator", ""
        res.send "{'status':11,'reason':#{e}}"

  else
    res.send '{"status":200}'


#http://technorides.co:2001/disconnect_user/password/35108/3000/3000
app.get '/disconnect_user/:token/:id/:code/:reason', (req, res, next) ->
  log.e "disconnect_user #{req.connection.remoteAddress}, #{req.params.id} ,#{req.params.code}, "

  if req.params.token is config.token_admin
    Q()
    .then =>

      store.validateToken(req.params.token)
    .then (token)->
      if not token
        throw new Error INVALID_TOKEN
      mongo.User.findOne
        user_id: req.params.id
      .exec()
    .then (user) =>
      code = parseInt( req.params.code, 10 )

      if user?

        tools.closeConnection 'user',user.rtaxi_id, user.user_id, code, req.params.reason
        res.send '{"status":200}'
      else
        res.send '{"status":11,"reason":"doesnt exist"}'

    .fail (e)->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
        return
      else
        res.send "{'status':11,'reason':#{e}}"
        log.ex e, "disconnect_user", ""
  else
    res.send '{"status":200}'
#/connected_users/d303be78d55dfdf8df06031a76cd9065
app.get '/connected_users/:token', (req, res, next) ->
  log.d "connected_users"

  connected_companies = null
  connected_drivers   = null
  connected_users     = null

  if req.params.token is config.token_admin
    Q()
    .then =>
      mongo.Company.find
        is_connected: true
      .exec()
    .then (companies) =>
      connected_companies = companies.length

      mongo.Driver.find
        is_connected: true
      .exec()
    .then (drivers) =>
      connected_drivers = drivers.length
      mongo.User.find
        is_connected: true
      .exec()
    .then (users) =>
      connected_users = users.length
      #send the infoooo
      res.send """{
        'status':200,
        'connected_users'    : #{connected_users},
        'connected_drivers'  : #{connected_drivers},
        'connected_companies': #{connected_companies},
      }
      """
    .fail (e)->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
        return
      else
        res.send {'status':411, reason:err.message}
        log.ex e, "connected_users", ""
  else
    res.send '{"status":200}'


app.get '/history_users/:token', (req, res, next) ->
  if not config.reports
    res.send '{"status":400,"history":[]}'
  else
    if req.params.token is config.token_admin
      history = ""

      Q()
      .then ->

        store.validateToken(req.params.token)
      .then (token)->
        if not token
          throw new Error INVALID_TOKEN
        mongo.Connection.find().exec()
      .then (connections) ->

        for connection in connections
          history += (JSON.stringify connection_record) + ", "

        res.send """{
          'status' : 200,
          'history': #{history}
        }"""

      .fail (e) ->
        message =
          'status': 1
          'error' : e
        res.send message
    else
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
        return
      else
        res.send '{"status":500,"history":10}'


app.get '/config/:reload', (req, res, next) ->

  if req.params.reload?
    log.i req.params.reload
    Q()
    .then =>
      service.updateCompanyConfig parseInt( req.params.reload, 10 )
    .then =>
      res.send '{"status":200}'
    .fail (e) =>
      message =
        'status' : 1
        'error'  : e
      log.ex e, "config", ""
      res.send message
  else
    if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message}
      return
    else
      log.ex err, "config/#{req.params.reload}", ""
      res.send '{"status":401}'


app.get '/parking/:reload', (req, res, next) ->
  if req.params.reload?
    log.i req.params.reload
    Q()
    .then =>
      service.updateCompanyParkings parseInt(req.params.reload, 10)
    .then =>
      res.send '{"status":200}'
    .fail (e) =>
      message =
        'status' : 1
        'error'  : e
      log.ex e, "parking", ""
      res.send message
  else
    log.ex err, "parking", ""
    res.send '{"status":401}'

app.get '/operations', (req, res, next) ->
  if not config.reports
    res.send '{"status":400,"history":[]}'
  else
    Q()
    .then =>
      reports.getOperations req.query.token, req.query.start_date, req.query.end_date
    .then (operations) =>
      res.send (operations)
    .fail (err) =>
      log.ex err, "operations", ""
      res.send '{"status":411}'


app.get '/geoname/:skip/:zone', (req, res, next) ->

  polygon = []
  Q()
  .then =>

    for point in req.params.zone.split "|"
      latlng = point.split ","
      polygon.push [parseFloat(latlng[0]),parseFloat(latlng[1])]

    query = {
      "location": {
        "$geoWithin": {
          "$geometry": tools.toGeoJSON polygon
        }
      }
    }
    mongo.Geoname.count()
  .then (geoname_count) =>
    @geoname_count = geoname_count

    mongo.Geoname.find()
    .select('name':1,'_id':0, 'geonameid':1, 'location':1,'asciiname':1,'population':1).skip(req.params.skip*1000)
    .limit(1000)
    .exec()
  .then (geonames) =>
    res.send {
      data        : geonames
      page_count  : @geoname_count/100
      count_record: @geoname_count
    }
  .fail (err) ->
    log.ex err, "geonames", ""
    res.send "{'status':400}"


app.get '/cities/:skip', (req, res, next) ->

  if not config.reports
    res.send '{"status":400,"history":[]}'
  else
    query = {
      "location": {
        "$geoWithin": {
          "$geometry": {
            "type": "Polygon",
            "coordinates": [[
              [-59.150390625   ,-34.11635246997273 ],
              [-59.83154296875 ,-35.245619094206795],
              [-57.755126953125,-35.639441068973916],
              [-56.84326171875 ,-35.0120020431607  ],
              [-59.150390625   ,-34.11635246997273 ]
            ]]
          }
        }
      }
    }
    Q()
    .then ->
      mongo.GooglePlace.count(query)
    .then (company_count) =>
      @company_count = company_count

      mongo.GooglePlace.find(query)
      .select('name':1,'_id':0,'location':1,'address':1).skip(req.params.skip*100)
      .limit(100)
      .exec()
    .then (operations) =>
      res.send {
        data        : operations
        page_count  : @company_count/100
        count_record: @company_count
      }
    .fail (err) ->
      log.ex err, "operations", ""


app.get '/operations/status', (req, res, next) ->

  if not config.monitor_reports
    res.send '{"status":100,"operations":[]}'
  else
    Q()
    .then ->
      store.validateToken(req.query.token)
    .then (token)->
      if not token
        throw new Error INVALID_TOKEN

      reports.getOperationStatuses req.query.token, req.query.start_date, req.query.end_date
    .then (statuses) ->
      res.send {status:100, operations:statuses}
    .fail (err) ->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message, amount : 0}
      else
        res.send {status:400, reason:err.message}
        log.ex err, "operations/status", ""


app.get '/drivers_version', (req, res, next) ->

  Q()
  .then ->
    store.validateToken(req.query.token)
  .then (token)->
    if not token
      throw new Error INVALID_TOKEN

    reports.getDriversVersion req.query.token
  .then (drivers) ->
    res.send {status:100, drivers:drivers}
  .fail (err) ->
    if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message, amount : 0}
    else
      log.ex err, "operations/status", ""
      res.send {status:400, reason:err.message}

app.get '/operations/earnings', (req, res, next) ->

  if not config.monitor_reports
    res.send '{"status":100,"amount":0}'
  else
    Q()
    .then ->
      store.validateToken(req.query.token)
    .then (token)->
      if not token
        throw new Error INVALID_TOKEN
      reports.getEarnings req.query.token, req.query.start_date, req.query.end_date
    .then (total) ->
      res.send {status:100, amount : total}
    .fail (err) ->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
      else
        res.send {'status':11, reason:err.message, amount : 0}
        log.ex err, "operations/earnings", ""

app.get '/operations/devices', (req, res, next) ->

  if not config.monitor_reports
    res.send '{"status":100,"operations":[]}'
  else
    Q()
    .then ->

      store.validateToken(req.query.token)
    .then (token)->
      if not token
        throw new Error INVALID_TOKEN
      reports.getOperationDevices req.query.token, req.query.start_date, req.query.end_date
    .then (devices) ->
      res.send {status:100, operations:devices}
    .fail (err) ->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
      else
        log.ex err, "operations/devices", ""
        res.send {status:400, reason:err.message}

app.get '/operations/weeklyDigest', (req, res, next) ->


  if not config.monitor_reports
    res.send '{"status":100,"operations":0}'
  else

    Q()
    .then ->

      store.validateToken(req.query.token)
    .then (token) ->
      if not token
        throw new Error INVALID_TOKEN

      reports.getOperationsWeeklyDigest req.query.token
    .then (devices) ->
      res.send {status:100, operations:0}
    .fail (err) ->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
      else
        res.send {status:400, reason:err.message}
        log.ex err, "operations/weeklyDigest", ""

app.get '/operations/flows/:id', (req, res, next) ->

  if not config.reports
    res.send '{"status":400,"history":[]}'
  else
    Q()
    .then ->

      store.validateToken(req.query.token)
    .then (token) ->
      if not token
        throw new Error INVALID_TOKEN

      reports.getOperationFlow(req.params.id, req.query.token)
    .then (flow) ->
      res.send {status:100, flow:flow}
    .fail (err) ->
      if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
      else
        log.ex err, "operations/flows/#{req.params.id}", ""
        res.send {status:400, reason:err.message}


app.get '/operations/logs/:id', (req, res, next) ->

    Q()
    .then =>

      store.validateToken(req.query.token)
    .then (token)->
      if not token
        throw new Error INVALID_TOKEN

      reports.getOperationLog(req.params.id, req.query.token)
    .then (events) =>
      if events? and events.length < 1
        throw new Error NO_LOG

      @events = events
      sql.reportForOperation( {id : req.params.id})
    .then ([operation]) =>
      res.send {status:100, events:events,operation:operation}
    .fail (err) =>
      if err.message in [NO_LOG]
        res.send {status:400, reason:err.message}
      else if err.message in [INVALID_TOKEN]
        res.send {'status':411, reason:err.message}
      else
        log.ex err, "operations/logs/#{req.params.id}", ""
        res.send {status:400, reason:err.message}


app.get '/parking_queue/:id', (req, res, next) ->
  Q()
  .then =>

    store.validateToken(req.query.token)
  .then (token)->
    if not token
      throw new Error INVALID_TOKEN

    reports.getParkingLog(req.params.id, req.query.token)
  .then (events) =>
    if events? and events.length < 1
      throw new Error NO_LOG

    res.send {status:100, events:events}
  .fail (err) =>
    if err.message in [NO_LOG]
      res.send {status:400, reason:err.message}
    else if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message}
    else
      log.ex err, "parking_queue/#{req.params.id}", ""
      res.send {status:400, reason:"error"}


app.get '/driver_connection/:id/:page', (req, res, next) ->

  Q()
  .then =>

    store.validateToken(req.query.token)
  .then (token)->
    if not token
      throw new Error INVALID_TOKEN
    reports.getDriverConnectionLog(req.params.id, req.params.page, req.query.token)
  .then (events) =>
    if events? and events.log.length < 1
      throw new Error NO_LOG

    res.send {status:100, events:events.log,count:events.count}
  .fail (err) =>
    if err.message in [NO_LOG]
      res.send {status:400, reason:err.message,events:[]}
    else if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message,events:[]}
    else
      log.ex err, "driver_connection/#{req.params.id}/", ""
      res.send {status:400, reason:"error",events:[]}

app.get '/fare_calculator_log/:id/:page', (req, res, next) ->

  Q()
  .then =>

    store.validateToken(req.query.token)
  .then (token)->
    if not token
      throw new Error INVALID_TOKEN
    reports.getDriverOperationTopologyLog(req.params.id, req.params.page, req.query.token)
  .then (events) =>
    if events? and events.length < 1
      throw new Error NO_LOG

    res.send {status:100, events:events}
  .fail (err) =>
    if err.message in [NO_LOG]
      res.send {status:400, reason:err.message,events:[]}
    else if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message,events:[]}
    else
      log.ex err, "driver_connection/#{req.params.id}/", ""
      res.send {status:400, reason:"error",events:[]}

app.get '/passengers/amount', (req, res, next) ->
  Q()
  .then ->

    store.validateToken(req.query.token)
  .then (token)->
    if not token
      throw new Error INVALID_TOKEN

    reports.getPassengersAmount req.query.token
  .then (total) ->
    res.send {status:100, amount : total}
  .fail (err) ->
    log.ex err, "/passengers/amount", ""
    res.send {'status':411, reason:err.message, amount : 0}

app.get '/lastPings', (req, res, next) ->
  Q()
  .then ->
    reports.lastPings new Date(), req.query.rtaxi_id
  .then (amount) ->
    res.send (amount)
  .fail (err) ->
    log.ex err, "lastPings", ""
    res.send {'status':411}

app.get '/recurringPayments', (req, res, next) ->
  log.i "recurringPayments"

  Q.try =>
    adyen.AdyenPaymentProcessor.getRecurringPayments req, res, next
  .fail (err) ->
    log.ex err, "recurringPayments", ""
    res.send {'status':411}


app.get '/invoices/:invoice_id', (req, res, next) ->
  log.i "one invoice"

  # zoho.ZohoInvoice.invoice_with_id req.params.invoice_id, res, next

  res.send {'status':200}

app.get '/invoices', (req, res, next) ->
  log.i "invoices"

  res.send {'status':200}
  # zoho.ZohoInvoice.list_invoices req.query.token, res, next


app.post '/deleteZone', (req, res, next) ->
  notification = null
  msg = null

  body = req.body
  _rtaxi_id   = body.rtaxi_id
  _zone_id    = body.zone_id

  Q()
  .then ->

    store.validateToken(req.query.token)
  .then (token)->
    if not token
      throw new Error INVALID_TOKEN
    mongo.Zone.remove
      rtaxi_id : _rtaxi_id
      zone_id  : _zone_id
    .remove().exec()
  .then ->
    res.send '{"status":200}'
  .fail (err) ->
    if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message}
      return
    else
      log.ex err, "deleteZone", "_rtaxi_id: #{_rtaxi_id}, zone_id: #{_zone_id}"
      res.send '{"status":401}'


app.post '/validate_polygon', (req, res, next) ->
  polygon = []

  for point in body.polygon "|"
    latlng = point.split ","
    polygon.push [parseFloat(latlng[0]),parseFloat(latlng[1])]

  query =
    "location":
      "$geoWithin":
        "$geometry": tools.toGeoJSON polygon
  Q()
  .then ->
    mongo.Geoname.count(query)
  .then (geoname_count) =>
    res.send "{'status':200}"

  .fail (err) ->
    res.send "{'status':400}"


app.post '/operator/notification', (req, res, next) ->
  notification = null
  msg = null

  body = req.body
  _user       = body.user
  _password   = body.password
  _message    = body.message
  if _user isnt "admin" or _password isnt "QOu6QjruPi0Zo4VM"
    log.d "FAIL"
    res.send '{"status":500}'
    return

  Q()
  .then ->
    notification = new mongo.TextNotification
    notification.text = _message
    notification.save()
  .then (notification) =>
    msg =
      'action'          : "newTextNotification"
      'text'            : notification.text
      'notification_id' : notification._id

      'message_id'                : '53161f3e72a1fa9803000102',
      'message_need_confirmation' : false

    mongo.CompanyConfig.find().exec()
  .then (configs) =>
    for company_config in configs
      bk.broadcastToAllOperators company_config.rtaxi_id, msg
    res.send '{"status":200}'
  .fail (err) ->
    log.ex err, "operator/notification", "body: #{body}"
    res.send {'status':411}


app.post '/createTrip.json', (req, res, next) ->
  log.i "createTrip.json"
  console.log "Create Trip: #{req.body}"
  if not config.rest_create_trip
    res.send '{"status":200}'
    return ;
  options            = null
  place_from         = null
  place_to           = null
  usr                = null
  @operation_document = null

  body            = req.body
  _operation      = body.operation
  _driver_number  = body.operation.driver_number
  _usr            = body.operation.user
  _options        = body.operation.options
  _reference      = body.operation.payment_reference
  _place_from     = body.operation.placeFrom
  _place_to       = body.operation.placeTo
  _device         = body.operation.device
  _place_from_loc = [_place_from.lng, _place_from.lat]
  _place_to_loc   = [_place_to.lng, _place_to.lat]
  log.d "STATUS: #{_operation.status}"

  Q()
  .then =>

    log.op _operation.id, _operation.ip, _operation.log_created_by,  'CREATETRIP', {'params':body, 'isProgrammedTrip': _operation.log_programmed_operation}
    payment.validateTripPayment _usr.rtaxi, _place_from_loc, _place_to_loc, _reference
  .then (payment_ok) =>
    unless payment_ok
      throw new Error("tried to createTrip with invalid payment. Reference: #{_reference}")

    unless _usr.rtaxi?
      throw new Error("tried to createTrip with invalid user. User: #{JSON.stringify _usr}")

    service.getAndCreateConfig _usr.rtaxi
  .then (cfg) =>
    @cfg = cfg
    mongo.Operation.findOne
      operation_id: _operation.id
    .exec()
  .then (operation) =>
    if operation?
      res.send '{"status":200}'
      throw new Error("operation already exists")

    options    = data_adapter.OptionsFromApiToMongo _options
    place_from = data_adapter.PlaceFromApiToMongo _place_from
    place_to   = data_adapter.PlaceFromApiToMongo _place_to

    place_to.save()
  .then =>
    place_from.save()
  .then =>
    options.save()
  .then =>

    mongo.User.findOne
      user_id: _usr.id
    .exec()
  .then (user) =>
    usr = user
    if not user?
      #res.send '{"status":200}'
      Q()
      .then =>
        sql.findUser {id:_usr.id}
      .then ([user_db]) =>
        if not user_db?
          log.i "createTrip:Exception:user didnt exist"
          return
        usr = new mongo.User user_db

        usr.is_cc        = _usr.isCC
        usr.is_connected = true
        usr.save()
      .fail (err) ->
        log.ex err, "createTrip_add_user", "user: #{user}"

  .then =>
    mongo.Operation.findOne
      operation_id: _operation.id
    .exec()
  .then (mg_operation) =>

    @operation_document = mg_operation

    unless mg_operation?
      @operation_document = new mongo.Operation
        operation_id: _operation.id
        rtaxi_id    : _usr.rtaxi

        is_corporate: _operation.is_corporate
        status      : _operation.status
        comments    : _operation.comments
        amount      : _operation.amount

        location: _place_from_loc

        device  : _device

        place_from: place_from
        place_to  : place_to
        option    : options
        user      : usr
        business_model: _operation.businessModel

        fare_calculator_discount: _operation.discount

    mongo.Payment.findOne
      reference: _reference
    .exec()
  .then (payment) =>
    if payment?
      @operation_document.amount = payment.amount
  #   operaation_document.save()
  # .then =>
    #Ver con santi el lunes porque el save() no funciona con then->
    # @operation_document.save (err, mg_operation_doc) ->
    if(_operation.is_corporate)
      @operation_document.is_corporate = true
      @operation_document.is_regular   = false
    else
      @operation_document.is_corporate = false
      @operation_document.is_regular   = true
    if(options.is_vip)
      @operation_document.is_vip   = true
    else
      @operation_document.is_vip   = false

    @operation_document.save()
  .then (saved_dc) =>
    console.log "#{err}" if err?
    _operation.finding_driver = false
    _operation.estimated_time = null
    _operation.created_at     = moment().format 'YYYY-MM-DD hh:mm:ss a ZZ'
    _operation.rtaxi          = _usr.rtaxi

    log.d JSON.stringify @operation_document

    msj_oper = {
      'operation' : _operation,
      'is_web_user' : _operation.is_web_user?,
      'is_new_user' : _operation.is_new_user?,
      'action' :'web/newTrip'
    }
    bk.broadcastToAllOperators _usr.rtaxi, msj_oper

    res.send '{"status":200}'
    if @cfg.is_fare_calculator_active
      Q()
      .then =>
        amount = @cfg.fare_initial_cost - (@cfg.fare_initial_cost * (@operation_document.fare_calculator_discount / 100))
        service.fc_service.add_charge
          opid       : _operation.id
          amount     : amount
          type_charge: service.FC_TYPE.INITIAL_COST
          version    : 0
      .then (fc_saved) =>
        log.d JSON.stringify fc_saved
      .fail (err) =>
        log.ex err, "createTrip_FARE_INITIAL_COST", ""

    #Si hay driver_number, el viaje será asignado
    #automáticamente y no se debe despachar
    if _driver_number?
      log.d "PARTICULAR #{_driver_number}"
      Q()
      .then =>
        @operation_document.status = 'ASSIGNEDTAXI'
        @operation_document.save()
      .then =>
        service.getAndCreateDriverByNumber _driver_number, @operation_document.rtaxi_id
      .then (driver) =>
        service.assignTripTo @operation_document, driver, 5, service.dispatchTrip
      .fail (err) =>
        @operation_document.status = _operation.status
        @operation_document.save()
        log.ex err, "createTrip", "body: #{body}"
    else
      log.d "GENERAL"
      console.log "dispatiching #{ _operation.id}"
      service.dispatchTrip _operation.id

    log.d "AFTER DRIVER NUMBER #{_driver_number}"

  .fail (err) =>
    log.ex err, "createTrip", "body: #{body}"
    res.send '{"status":400}'



app.post '/payment', (req, res, next) ->
  log.i "payment"
  Q.try =>
    adyen.AdyenPaymentProcessor.encryptedPayment req, res, next
  .fail (err) ->
    res.send "{'status':400}"



app.post '/paymentRecurring', (req, res, next) ->
  log.i "payment recurring"
  Q.try =>
    adyen.AdyenPaymentProcessor.paymentRecurring req, res, next
  .fail (err) ->
    res.send "{'status':400}"


app.post '/recurringDetails', (req, res, next) ->
  log.i "recurring details"

  Q.try =>
    adyen.AdyenPaymentProcessor.recurringDetails req, res, next
  .fail (err) ->
    res.send "{'status':400}"


app.post '/adyenNotification', (req, res, next) ->
  log.i req.body.live
  log.i req.body.eventCode
  res.send '[accepted]'
