# `sockets` exports the startServer() function, and contains the `Handler`
# class hierarchy.

# Handlers wrap websocket objects to provide a higher-level interface.

# The SocketHandler base class is the reading starting point. It provides each
# socket with connection management, Redis pub/sub mechanics and dynamic
# dispatch.

ws       = require 'ws'
url      = require 'url'
Q        = require 'q'
https    = require 'https'
fs       = require 'fs'
express  = require 'express'

redis  = require '../dbs/redis'

config = require '../../config'

log    = require('../log').create 'Sockets'
driver  = require './driver'
operator    = require './operator'
passenger    = require './passenger'

servers = null

@startServer = ->
  console.log "started:ws_server"
  servers = [
    new ws.Server
      port: config.sockets.port

    new ws.Server
      port: config.sockets.port1
  ]

  if config.ssl.is_enabled
    options =
      key: fs.readFileSync(config.ssl.key)
      cert: fs.readFileSync(config.ssl.certificate)
      requestCert: true

    Application = express()
    Application.use (req, res, next) ->
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
      next();

    Application.get '/', (req, res, next) ->
      res.send {'status':200}

    Server = https.createServer(options, Application).listen(config.ssl.wss)

    WebSocketServer = new ws.Server
      server: Server
      autoAcceptConnections: true

    servers.push WebSocketServer

  for server in servers
    server.on 'connection', (socket) ->
      {pathname} = url.parse socket.upgradeReq.url, true

      socket.on 'error', (reason, code) ->
        console.log "socket error: reason #{reason} , code  #{code}"

      Handler = switch pathname
        when '/driver' then driver.DriverHandler
        when '/passenger' then passenger.PassengerHandler
        when '/company' then operator.OperatorHandler

      if Handler?
        handler = new Handler(socket)

      else
        console.error 'No handler for', socket.upgradeReq.url
        socket.close(4000,"4000")

  log.i "Started"


@stopServer = ->
  log.i "Stopped"

  if servers?
    server.close() for server in servers
  else
    log.w "stopServer() called, but server is not running"

  # This function is actually synchronous: we return a Promise to blend in with
  # other services that require async shutdown.
  Q()
