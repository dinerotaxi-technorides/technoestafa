Q          = require 'q'

mongo        = require '../dbs/mongo'
sql          = require '../dbs/sql'
bk           = require '../dbs/broadcast'
data_adapter = require '../dbs/data_adapter'
service      = require '../tasks/service'
config       = require '../../config'
DataStore    = require '../dbs/data_store'

log        = require('../log').create 'ChatRest'

util       = require 'util'
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



router.all '*', (req, res, next) =>
  Q()
  .then =>

    res.header('Access-Control-Allow-Origin', '*')
    res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
    res.header('Access-Control-Allow-Headers', 'Content-Type')

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

router.get '/',(req,res,next) =>
  res.send '{}'

router.get '/messages',(req,res,next) =>
  tok = req.query.token
  c_message = []
  perPage = 10
  page = parseInt(req.query.page  ) || 0
  Q()
  .then =>

    service.message_service.getUserByTokenOrRtaxi {token : tok, user_id: req.query.user_id}
  .then (user) =>
    if not user
      throw new Error INVALID_TOKEN

    mongo.ChatMessage
    .where('sender_id').equals(user.id)
    .limit(perPage)
    .skip(perPage * page).exec()
  .then (messages) =>
    for message in messages
      c_message.push data_adapter.chatMessageFromMongoToWeb message
    res.send
      data  : c_message
      status: 200
  .fail (err) =>
    if err.message is INVALID_TOKEN
      res.send "{'status':411}"
    else
      log.ex err, "chat_rest:messages", "token: #{tok}"
      res.send "{'status':412}"

router.get '/conversation/list',(req,res,next) =>
  Q()
  .then =>
    @tok = req.query.token
    @c_message = []
    @perPage = 10
    @page = parseInt(req.query.page  ) || 0
    #LOGIN USER
    service.message_service.getUserByTokenOrRtaxi {token : @tok, user_id: req.query.user_id}
  .then (user) =>

    if not user
      throw new Error INVALID_TOKEN
    @user = user
    #GET CONVERSATIONS BY USER
    mongo.Conversation.find
      sender_id: @user.id
    .limit(@perPage)
    .skip(@perPage * @page)
    .sort
      created_at: -1
  .then (messages) =>
    Q.all(
      for message in messages
        service.message_service.conversation_to_list message, true
    )
  .then (messages_ad) =>
    block_sender = []
    block_sender.push @user.id
    for message in messages_ad
      @c_message.push message
      if message.receiver_id
        block_sender.push message.receiver_id

    mongo.Conversation.find
      receiver_id: @user.id
      sender_id  : $nin: block_sender
    .limit(@perPage)
    .skip(@perPage * @page)
    .sort
      created_at: -1
  .then (messages) =>
    Q.all(
      for message in messages
        service.message_service.conversation_to_list message, false
    )
  .then (messages_ad) =>
    for message in messages_ad
      @c_message.push message

    res.send
      data  : @c_message
      status: 200
  .fail (err) =>
    if err.message is INVALID_TOKEN
      res.send "{'status':411}"
      return
    else
      log.ex err, "chat_rest:conversation/list #{err.stack}", ""
      res.send "{'status':412}"

router.get '/conversation',(req,res,next) =>
  tok = req.query.token
  c_message = []
  perPage = 10
  page = parseInt(req.query.page  ) || 0

  other_user = req.query.receiver_id
  if not other_user
    res.send "{'status':413}"
    return
  other_user = parseInt( other_user  ) || 0

  Q()
  .then =>

    service.message_service.getUserByTokenOrRtaxi {token : tok, user_id: req.query.user_id}
  .then (user) =>
    if not user
      throw new Error INVALID_TOKEN

    mongo.ChatMessage.find
      $and: [
          { $or: [
            {sender_id: user.id, type: 1, recipients: $in: [other_user] },
            {sender_id: other_user,type: 1,recipients: $in: [user.id]} ] }
      ]
    .limit(perPage)
    .skip(perPage * page)
    .sort
      created_at: -1
  .then (messages) =>
    Q.all(
      for message in messages
        service.message_service.message_list message
    )
  .then (messages_ad) =>
    for message in messages_ad
      c_message.push message

    res.send
      data  : c_message
      status: 200
  .fail (err) =>
    if err.message is INVALID_TOKEN
      res.send "{'status':411}"
      return;
    else
      log.ex err, "chat_rest:conversation/user_id", "params: #{req.params}"
      res.send "{'status':412}"

router.get '/media/details',(req,res,next) =>
  tok = req.query.token
  _id = req.query.id
  c_message = []
  Q()
  .then =>

    service.message_service.getUserByTokenOrRtaxi {token : tok, user_id: req.query.user_id}
  .then (user) =>
    @user = user
    if not user
      throw new Error INVALID_TOKEN

    ObjectId = require('mongoose').Types.ObjectId

    mongo.ChatMessage.findById
      _id: ObjectId(_id)
  .then (messages) =>
    if not messages? or not messages?.type?
      res.send status: 404
      return
    if((not messages?.sender_id) or (messages.sender_id isnt @user.id))
      if((not messages.recipients) or (messages.recipients.length < 1) or (@user.id not in messages.recipients))
        res.send status: 411
        return

    res.send
      data  : messages
      status: 200

  .fail (err) =>
    if err.message is INVALID_TOKEN
      res.send "{'status':411}"
      return;
    else
      log.ex err, "chat_rest:audio/details/:id", "token: #{tok}"
      res.send "{'status':412}"


router.get '/irc',(req,res,next) =>
  tok = req.query.token
  c_message = []

  perPage = 10
  page = parseInt(req.query.page  ) || 0

  Q()
  .then =>

    service.message_service.getUserByTokenOrRtaxi {token : tok, user_id: req.query.user_id}
  .then (user) =>
    if not user
      throw new Error INVALID_TOKEN

    mongo.ChatMessage
    .where('type').equals(0)
    .where('rtaxi_id').equals(user.rtaxi_id)
    .limit(perPage)
    .skip(perPage * page)
    .sort(created_at: -1).exec()
  .then (messages) =>
    Q.all(
      for message in messages
        service.message_service.message_list message
    )
  .then (messages_ad) =>
    for message in messages_ad
      c_message.push message

    res.send
      data  :  c_message
      status: 200
  .fail (err) =>
    if err.message is INVALID_TOKEN
      res.send "{'status':411}"
    else
      log.ex err, "messages/list", "token: #{tok}"
      res.send "{'status':412}"
