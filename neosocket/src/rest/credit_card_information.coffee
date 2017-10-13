Q            = require 'q'
mongo        = require '../dbs/mongo'
data_adapter = require '../dbs/data_adapter'
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

router.post '/',(req,res,next) ->
  d_json = {
    status: 404
  }

  Q()
  .then ->
    store.getUserFromToken(req.body.token)
  .then (user) =>
    @user = user
    if not @user
      throw new Error INVALID_TOKEN

    models.credit_card_information.find
      where:
        card_number: req.body.card_number
        card_type: req.body.card_type
        user_id: @user.id

  .then (cc_info_item) =>

    #If the record matches, only changes the card_token
    if cc_info_item
      #throw new Error('DUPLICATE_ITEM')
      cc_info_item.updateAttributes
        card_token : req.body.card_token

    else
      #Otherwise this creates the new record
      models.credit_card_information.build
        version     : 0
        created_date: new Date()
        enabled     : true
        card_token  : req.body.card_token
        card_type   : req.body.card_type
        card_number : req.body.card_number
        card_holder : req.body.card_holder
        cvc         : req.body.cvc
        user_id     :  @user.id
        expiration_date: req.body.expiration_date
      .save()

  .then (cc_info) ->
    res.json
      status: 200
      data  : cc_info
  .catch (err) ->
    #if err.message in ['DUPLICATE_ITEM']
      #d_json.status = 1

    log.e "Netwok_user Not Added: #{err}"

    res.json d_json

router.get '/list',(req,res,next) ->
  d_json = {
    status: 404
  }

  init  = parseInt(req.query.init  ) || 0
  limit = parseInt(req.query.limit ) || 10

  page = init
  init = init * 10

  Q()
  .then ->

    store.getUserFromToken(req.query.token)
  .then (user) =>
    @user = user
    if not @user
      throw new Error INVALID_TOKEN

    models.credit_card_information.findAll
      where:
        user_id: @user.id
      limit : limit,
      offset: init
  .then (cc_info_list) =>
    @cc_info_list = cc_info_list

    models.credit_card_information.count
      where:
        user_id: @user.id
  .then (cc_info_count) =>
    cc_info_data = []

    if @cc_info_list
      for cc_info in @cc_info_list
        cc_info_data.push cc_info.dataValues

    returnset = {
      data        : cc_info_data
      count       : parseInt(cc_info_count/limit)
      current_page: page
      status      : 200
    }

    res.send JSON.stringify returnset

  .fail (err) =>
    if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message}
      return

    response =
      status: 400
      err   : err.stack
    res.send JSON.stringify response

router.post '/delete',(req,res,next) ->
  Q()
  .then ->
    store.getUserFromToken(req.body.token)
  .then (user) =>
    @user = user
    if not @user
      throw new Error INVALID_TOKEN

    models.credit_card_information.find
      where:
        id: req.body.id
        user_id: @user.id
  .then (cc_item) =>
    if not cc_item
      throw new Error('NOT_FOUND')

    cc_item.destroy()
  .then (num) ->
    res.json
      message: num + ' updated'
      status : 200
    res.send JSON.stringify {'status':200}
  .fail (err) =>
    if err.message in [INVALID_TOKEN]
      res.send {'status':411, reason:err.message}
      return

    response =
      status: 400
      err   : err.stack
    res.send JSON.stringify response
