Q            = require 'q'
mongo        = require '../dbs/mongo'
sql          = require '../dbs/sql'
bk           = require '../dbs/broadcast'
data_adapter = require '../dbs/data_adapter'
service      = require '../tasks/service'
config       = require '../../config'
DataStore    = require '../dbs/data_store'
util         = require 'util'
models       = require '../models_sequelize'
log          = require('../log').create 'StripeRest'
config       = require '../../config'
stripe       = require('stripe')(config.stripe.pushable_key)
express      = require 'express'
middleware   =
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
  response =
    status:200
  res.send response

router.post '/process_pay',(req,res,next) ->
  obj = req.body
  Q()
  .then =>
    stripe.setApiKey(config.stripe.secret_key)
    stripe.customers.create { email: 'customer@example.com' }
  .then (customer) =>

    response =
      status:200
    res.send response
  .fail (err) ->
    console.log err.stack
    # if err.message is INVALID_TOKEN
    #   res.send "{'status':411}"
    # else
    #   log.ex err, "chat_rest:messages", "token: #{tok}"
    res.send "{'status':412}"
