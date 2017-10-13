Q          = require 'q'

mongo        = require '../dbs/mongo'
sql          = require '../dbs/sql'
bk           = require '../dbs/broadcast'
data_adapter = require '../dbs/data_adapter'
service      = require '../tasks/service'
config       = require '../../config'
DataStore    = require '../dbs/data_store'
models       = require '../models_sequelize'

util         = require 'util'
log        = require('../log').create 'ChatRest'

express    = require 'express'
middleware =
  bodyParser: require 'body-parser'
store = new DataStore

module.exports = router = express.Router()

router.use middleware.bodyParser.urlencoded extended: true
router.use middleware.bodyParser.json()


INVALID_TOKEN = "invalid token"
#/rest/scanner/list?init=&limit=
#/rest/scanner/list/5537dac91027b74c2f62caa4
# curl -H "Content-Type: application/json" -X POST -d '{"id":"5537dac91027b74c2f62caa4","owner_name":"Pedro Esquivel","owner_phone":"Pedro Esquivel","owner_email":"Pedro Esquivel","status":"NOT_FOUND"}' http://localhost:8000/rest/scanner/edit


router.all '*', (req, res, next) ->
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


router.get '/',(req,res,next) ->
  res.send '{}'

router.get '/:rtaxi_id/:driver_id/:amount/:reference', (req, res, next) ->
  Q()
  .then ->
    console.log req.params

    if not  config.prepaid[req.params.rtaxi_id]
      throw new Error('NOT_CONFIG')

    @amount       = req.params.amount
    limit         = config.prepaid[req.params.rtaxi_id].limit
    @payment_mode = config.prepaid[req.params.rtaxi_id].payment_mode
    if @amount < 0 or @amount > config.prepaid[req.params.rtaxi_id].limit
      throw new Error('AMOUNT_QUOTA_ERROR')

    driver = "#{req.params.driver_id}#{config.prepaid[req.params.rtaxi_id].rtaxi}"

    mongo.Driver.findOne
      email: driver
    .exec()
  .then (driver) =>

    if not driver
      throw new Error('DRIVER_NOT_EXIST')

    models.pre_paid_driver_payment.create
      driver_id   : driver.driver_id
      status      : 'PAID'
      reference   : req.params.reference
      version     : 0
      amount      : @amount
      amount_unused : @amount
      payment_date: new Date()
      payment_mode: @payment_mode
  .then (payment_) =>
    res.send
      status: 200
  .fail (err) =>
    if err.message is 'NOT_CONFIG'
      status = 1
    else if err.message is 'DRIVER_NOT_EXIST'
      status = 2
    else if err.message is 'AMOUNT_QUOTA_ERROR'
      status = 3
    else
      status = 400
      log.ex err, "google_places", ""

    res.send
      status:status
