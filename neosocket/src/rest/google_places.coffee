Q          = require 'q'

tools        = require '../tools'
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

router.get '/company_info/:skip/:location/:distance', (req, res, next) ->
  query = {}
  lat = parseFloat(req.params.location.split(",")[0])
  lng = parseFloat(req.params.location.split(",")[1])
  console.log "company_info"
  Q()
  .then ->
    mongo.GooglePlace.count
      location: $near:
        $geometry:
          type       : "Point",
          coordinates: [lat,lng]
        $maxDistance: req.params.distance * 1000
  .then (company_count) =>
    @company_count = company_count
    mongo.GooglePlace.find
      location: $near:
        $geometry:
          type       : "Point",
          coordinates: [lat,lng]

        $maxDistance: req.params.distance * 1000
    .select('name':1,'_id':0,'location':1,'address':1)
    .skip(req.params.skip*1000)
    .limit(1000)
    .exec()
  .then (operations) =>
    # console.log @company_count
    res.send {
      data        : operations,
      page_count  : @company_count/1000,
      count_record: @company_count,
    }
    # res.send "hola"
  .fail (err) ->
    log.ex err, "google_places", ""
    res.send {
      status:400
    }

router.get '/:lat/:lng/:lat1/:lng1', (req, res, next) ->
  stat = tools.getDistanceFromLatLonInMeters(
    req.params.lat, req.params.lng,
    req.params.lat1, req.params.lng1)
  if(stat>(100*1000))
    console.log "AAAA"
  res.send {
    status:stat
  }



router.get '/company_info/:skip', (req, res, next) ->
  query = {}

  Q()
  .then ->
    mongo.GooglePlace.count
      location: $near:
        $geometry:
          type       : "Point",
          coordinates:  [-0.2362060546875,51.52412499689334]
        $maxDistance: 50* 1000
  .then (company_count) =>
    @company_count = company_count
    mongo.GooglePlace.find
      location: $near:
        $geometry:
          type       : "Point",
          coordinates: [-0.2362060546875,51.52412499689334]
        $maxDistance: 50* 1000
    .select('name':1,'_id':0,'location':1,'address':1)
    .skip(req.params.skip*1000)
    .limit(1000)
    .exec()
  .then (operations) =>
    # console.log @company_count
    res.send {
      data        : operations,
      page_count  : @company_count/1000,
      count_record: @company_count,
    }
    # res.send "hola"
  .fail (err) ->
    log.ex err, "company_info", ""
    res.send {
      status:400
    }
