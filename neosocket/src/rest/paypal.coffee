Q            = require 'q'
config       = require '../../config'
util         = require 'util'
log          = require('../log').create 'PayPal'
express      = require 'express'
rp           = require 'request-promise'
config       = require '../../config'
sql          = require '../dbs/sql'
mongo        = require '../dbs/mongo'
bcast        = require '../dbs/broadcast'
middleware   =
  bodyParser: require 'body-parser'

module.exports = router = express.Router()

router.use middleware.bodyParser.urlencoded extended: true
router.use middleware.bodyParser.json()

@base_request =
  method: 'POST'
  uri: config.payments.paypal.host.concat config.payments.paypal.path
  json: true

router.all '*', (req, res, next) =>
  Q()
  .then =>

    res.header('Access-Control-Allow-Origin', '*')
    res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
    res.header('Access-Control-Allow-Headers', 'Content-Type')
    # res.header('Content-length', 183)

    # console.log("_______________ _____________")
    # console.log(res.req._parsedUrl.pathname)
    # console.log(res.req._parsedUrl)
    #
    rest_log = new mongo.DebugLog
      type : "rest"
      url  : util.inspect res.req._parsedUrl.pathname
      body : JSON.stringify req.body
    rest_log.save()
  .then (log)=>
    next()
  .fail (err) =>
    log.ex err, "app.all ", ""
    next()


###*
  * @swagger
  * /paypal/checkout:
  *  post:
  *    tags: [Paypal]
  *    description: Post the Paypal payment checkout data
  *    parameters: [
  *      {name: token,in: formData,description: the token from users session,required: true,type: string},
  *      {name: amount,in: formData,description: amount of the operation,required: true, type: number},
  *      {name: operation,in: formData,description: the operation ID,required: true, type: integer}
  *    ]
  *    responses:
  *      200:
  *        description: Returns the Paypal token
  *      411:
  *        description: Returns any error from Paypal
 ###
router.post '/checkout',(req,res,next) =>
  Q()
  .then =>
    console.log req.body.token
    @validateTokenAndUser req.body.token
  .then (user) =>
    unless user.rtaxi_id
      throw new Error "SESSION TOKEN OR USER NOT VALID"

    sql.getPaypalMerchant {rtaxi_id: user.rtaxi_id}
  .then ([merchant]) =>
    if not merchant?
      throw new Error "PAYPAL ACCOUNT DOESN`T EXIST"
    unless req.body.amount?
      throw new Error "REQUIRED: AMOUNT IS MANDATORY"
    unless req.body.operation?
      throw new Error "REQUIRED: OPERATION IS MANDATORY"

    set_echeckout_req = @base_request
    set_echeckout_req.form =
      USER: merchant.caller_id
      PWD: merchant.caller_password
      SIGNATURE: merchant.caller_signature
      METHOD: 'SetExpressCheckout'
      VERSION: 93
      PAYMENTREQUEST_0_PAYMENTACTION: 'SALE'
      PAYMENTREQUEST_0_AMT: req.body.amount
      RETURNURL: config.payments.paypal.url_return.concat "/#{req.body.operation}"
      CANCELURL: config.payments.paypal.url_cancel.concat "/#{req.body.operation}"

    rp set_echeckout_req
  .then (pp_resp) =>
    log.i pp_resp
    @convertToJSON pp_resp
  .then (json_resp) =>
    if json_resp.ACK? and json_resp.ACK isnt 'Success'
      throw new Error "PAYPAL ERROR CODE: #{json_resp.L_ERRORCODE0} - #{json_resp.L_LONGMESSAGE0}"
    res.send JSON.stringify {status:200, token:json_resp.TOKEN}
  .fail (err) =>
    res.send JSON.stringify {status:411, msg:err.message}


###*
  * @swagger
  * /paypal/url/return/{operation}:
  *  get:
  *    tags: [Paypal]
  *    description: Paypal callback return if success
  *    parameters: [
  *      {name: operation,in: path,description: the operation ID,required: true, type: integer}
  *    ]
  *    responses:
  *      411:
  *        description: Returns any error from Paypal
 ###
router.get '/url/return/:operation',(req,res,next) =>
  Q()
  .then =>
    unless req.params.operation?
      throw new Error "REQUIRED: OPERATION IS MANDATORY"

    mongo.Operation.findOne
      operation_id: req.params.operation
    .populate('driver user')
    .exec()
  .then (oper) =>
    if not oper?
      throw new Error "OPERATION IS NOT VALID"

    @operation = oper

    sql.getPaypalMerchant {rtaxi_id: @operation.rtaxi_id}
  .then ([merchant]) =>
    if not merchant?
      throw new Error "PAYPAL ACCOUNT DOESN`T EXIST"
    unless req.query.token?
      throw new Error "REQUIRED: TOKEN IS MANDATORY"

    @merchant = merchant

    get_echeckout_req = @base_request
    get_echeckout_req.form =
      USER: merchant.caller_id
      PWD: merchant.caller_password
      SIGNATURE: merchant.caller_signature
      METHOD: 'GetExpressCheckoutDetails'
      VERSION: 93
      TOKEN: decodeURI req.query.token

    rp get_echeckout_req
  .then (pp_resp) =>
    log.i pp_resp
    @convertToJSON pp_resp
  .then (json_resp) =>
    if json_resp.ACK? and json_resp.ACK isnt 'Success'
      throw new Error "PAYPAL ERROR CODE: #{json_resp.L_ERRORCODE0} - #{json_resp.L_LONGMESSAGE0}"
    unless req.query.PayerID?
      throw new Error "REQUIRED: PAYERID IS MANDATORY"

    @doExpressCheckout @merchant, json_resp.TOKEN, req.query.PayerID, @operation.amount
  .then (pp_resp) =>
    if pp_resp.ACK? and pp_resp.ACK isnt 'Success'
      throw new Error "PAYPAL ERROR CODE: #{json_resp.L_ERRORCODE0} - #{json_resp.L_LONGMESSAGE0}"

    @broadcastPaymentAck res, {rtaxi_id:@operation.rtaxi_id, user_id:@operation.user.user_id}, 'COMPLETED'
  .fail (err) =>
    if err.message in ["OPERATION IS NOT VALID"]
      res.send JSON.stringify {status:411, msg:err.message}
    else
      @broadcastPaymentAck res, {rtaxi_id:@operation.rtaxi_id, user_id:@operation.user.user_id}, 'ERROR', err.message

###*
  * @swagger
  * /paypal/url/cancel/{operation}:
  *  get:
  *    tags: [Paypal]
  *    description: Paypal callback return if fails or is canceled
  *    parameters: [
  *      {name: operation,in: path,description: the operation ID,required: true, type: integer}
  *    ]
  *    responses:
  *      411:
  *        description: Returns any error from Paypal
 ###
router.get '/url/cancel/:operation',(req,res,next) =>
  Q()
  .then =>
    unless req.params.operation?
      throw new Error "REQUIRED: OPERATION IS MANDATORY"

    mongo.Operation.findOne
      operation_id: req.params.operation
    .populate('driver user')
    .exec()
  .then (oper) =>
    if not oper?
      throw new Error "OPERATION IS NOT VALID"

    @operation = oper

    @broadcastPaymentAck res, {rtaxi_id:@operation.rtaxi_id, user_id:@operation.user.user_id}, 'CANCELED'
  .fail (err) =>
    if err.message in ["OPERATION IS NOT VALID"]
      res.send JSON.stringify {status:411, msg:err.message}
    else
      @broadcastPaymentAck res, {rtaxi_id:@operation.rtaxi_id, user_id:@operation.user.user_id}, 'ERROR', err.message


###*
  * @swagger
  * /paypal/model/merchants:
  *  post:
  *    tags: [Paypal]
  *    description: Insert a new Paypal merchant
  *    parameters: [
  *      {name: token,in: formData,description: the token from users session,required: true, type: string},
  *      {name: caller_id,in: formData,description: the merchant's Paypal account id, required: true, type: integer},
  *      {name: caller_password,in: formData,description: the merchant's Paypal account password,required: true, type: string},
  *      {name: caller_signature,in: formData,description: the merchant's Paypal account signature,required: true, type: string}
  *    ]
  *    responses:
  *      200:
  *        description: Returns the Paypal token
  *      411:
  *        description: Returns any error from Paypal
###
router.post '/model/merchants',(req,res,next) =>
  Q()
  .then =>
    @validateTokenAndUser req.body.token
  .then (user) =>
    unless user.rtaxi_id
      throw new Error "SESSION TOKEN OR USER NOT VALID"
    if not req.body.caller_id or not req.body.caller_password or not req.body.caller_signature
      throw new Error "REQUIRED: AT LEAST ONE PAYPAL PARAMETER IS MANDATORY"

    pp_merchant =
      caller_id       : req.body.caller_id
      caller_password : req.body.caller_password
      caller_signature: req.body.caller_signature
      company_id      : user.rtaxi_id
      version         : 1

    sql.addPaypalMerchant pp_merchant
  .then (merchant) =>
    unless merchant
      throw new Error "MERCHANT CANNOT BE INSERTED"
    res.send JSON.stringify {status:200, id:merchant.id}
  .fail (err) =>
    res.send JSON.stringify {status:411, msg:err.message}


###*
  * @swagger
  * /paypal/model/merchants:
  *  put:
  *    tags: [Paypal]
  *    description: Update a Paypal merchant
  *    parameters: [
  *      {name: token,in: formData,description: the token from users session,required: true, type: string},
  *      {name: id,in: formData,description: the id from merchant, required: true, type: integer},
  *      {name: caller_id,in: formData,description: the merchant's Paypal account id, required: true, type: integer},
  *      {name: caller_password,in: formData,description: the merchant's Paypal account password,required: true, type: string},
  *      {name: caller_signature,in: formData,description: the merchant's Paypal account signature,required: true, type: string}
  *    ]
  *    responses:
  *      200:
  *        description: Returns the Paypal token
  *      411:
  *        description: Returns any error from Paypal
###
router.put '/model/merchants',(req,res,next) =>
  Q()
  .then =>
    @validateTokenAndUser req.body.token
  .then (user) =>
    unless user.rtaxi_id
      throw new Error "SESSION TOKEN OR USER NOT VALID"
    if not req.body.id or not req.body.caller_id or not req.body.caller_password or not req.body.caller_signature
      throw new Error "REQUIRED: AT LEAST ONE PAYPAL PARAMETER IS MANDATORY"

    pp_merchant =
      id              : req.body.id
      caller_id       : req.body.caller_id
      caller_password : req.body.caller_password
      caller_signature: req.body.caller_signature

    sql.updatePaypalMerchant pp_merchant
  .then (merchant) =>
    unless merchant
      throw new Error "MERCHANT CANNOT BE UPDATED"
    res.send JSON.stringify {status:200, id:merchant.id}
  .fail (err) =>
    res.send JSON.stringify {status:411, msg:err.message}


###*
  * @swagger
  * /paypal/model/merchants:
  *  get:
  *    tags: [Paypal]
  *    description: Returns all Paypal merchant's accounts
  *    parameters: [
  *      {name: token,in: query,description: the token from users session,required: true, type: string}
  *    ]
  *    responses:
  *      200:
  *        description: Returns the Paypal token
  *      411:
  *        description: Returns any error from Paypal
 ###
router.get '/model/merchants',(req,res,next) =>
  Q()
  .then =>
    @validateTokenAndUser req.query.token
  .then (user) =>
    unless user.rtaxi_id
      throw new Error "SESSION TOKEN OR USER NOT VALID"

    sql.getPaypalMerchant {rtaxi_id:user.rtaxi_id}
  .then (merchant) =>
    res.send JSON.stringify {status:200, merchant:merchant}
  .fail (err) =>
    res.send JSON.stringify {status:411, msg:err.message}


###*
  * @swagger
  * /paypal/model/merchants/{id}:
  *  get:
  *    tags: [Paypal]
  *    description: Returns all merchant's Paypal accounts
  *    parameters: [
  *      {name: token,in: query,description: the token from users session,required: true, type: string},
  *      {name: id,in: path,description: the token from users session,required: true, type: integer}
  *    ]
  *    responses:
  *      200:
  *        description: Returns the Paypal token
  *      411:
  *        description: Returns any error from Paypal
 ###
router.get '/model/merchants/:id',(req,res,next) =>
  Q()
  .then =>
    @validateTokenAndUser req.query.token
  .then (user) =>
    unless user.rtaxi_id
      throw new Error "SESSION TOKEN OR USER NOT VALID"
    if not req.query.id
      throw new Error "REQUIRED: ID IS MANDATORY"

    sql.getPaypalMerchant {id:req.query.id}
  .then (merchant) =>
    res.send JSON.stringify {status:200, merchant:merchant}
  .fail (err) =>
    res.send JSON.stringify {status:411, msg:err.message}


@validateTokenAndUser= (usr_token) ->
  Q()
  .then =>
    sql.findUserByToken {token:usr_token}
  .then ([user]) =>
    if not user
      return []
    else
      return user


@convertToJSON= (expr) ->
  Q()
  .then =>
    uri = decodeURI expr
    .replace /&/g, "\",\""
    .replace /=/g,"\":\""

    return JSON.parse "{\"#{uri}\"}"


@doExpressCheckout= (merchant, pp_token, payerid, amount) ->
  Q()
  .then =>
    do_echeckout_req = @base_request
    do_echeckout_req.form =
      USER: merchant.caller_id
      PWD: merchant.caller_password
      SIGNATURE: merchant.caller_signature
      METHOD: 'DoExpressCheckoutPayment'
      VERSION: 93
      TOKEN: decodeURI pp_token
      PAYERID: payerid
      PAYMENTREQUEST_0_PAYMENTACTION: 'SALE'
      PAYMENTREQUEST_0_AMT: amount

    rp do_echeckout_req
  .then (pp_resp) =>
    log.i pp_resp
    return @convertToJSON pp_resp


@broadcastPaymentAck= (res, data, status, message) ->
  Q()
  .then =>
    msg = {
      'action'                    :'PaymentStatus',
      'provider'                  :'PAYPAL',
      'status'                    : status,
      'message_id'                : new Date().getTime(),
      'message_need_confirmation' : true
    }

    #If an error occurs during payment transaction
    if message
      msg.error = message

    bcast.broadcastToUser data.rtaxi_id, data.user_id, msg
  .then () =>
    res.writeHead 301, {Location: 'http://aricaone.com/web-aricaone/wp-content/themes/geo-2.0.9/images/ajax_loader.gif'}
    res.end()
