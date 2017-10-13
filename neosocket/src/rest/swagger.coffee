swaggerJSDoc = require 'swagger-jsdoc'
express      = require 'express'
config       = require '../../config'
middleware   =
  bodyParser: require 'body-parser'

module.exports = router = express.Router()

router.use middleware.bodyParser.urlencoded extended: true
router.use middleware.bodyParser.json()

@options =
  swaggerDefinition:
    info:
      title: config.swagger.info.title
      version: config.swagger.info.version
      description: config.swagger.info.description
    host: config.swagger.host
    basePath: config.swagger.basepath
  apis: ["#{__dirname}/*.js"]


router.all '*', (req, res, next) =>
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
  res.header('Access-Control-Allow-Headers', 'Content-Type')
  next()


router.get '/swagger.json',(req,res,next) =>
  swaggerSpec = swaggerJSDoc @options
  res.setHeader 'Content-Type', 'application/json'
  res.send swaggerSpec