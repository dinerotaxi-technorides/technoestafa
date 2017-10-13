# main.coffee
# Executable script that runs the server
require('source-map-support').install()

try
  require('newrelic')
catch err
  console.log('\x1b[33m%s\x1b[0m ', 'Newrelic module not found. We are not tracking anything')

Q       = require 'q'
exit    = require 'exit'
os      = require 'os'

exec = require('child_process').exec

models  = require './models_sequelize'
mongo   = require './dbs/mongo'
sockets = require './sockets/sockets'
tasks   = require './tasks/tasks'
rest    = require './rest/rest'
mail    = require './mail/error_mailer'
log     = require('./log').create 'Main'
cluster = require 'cluster'
config   = require '../config'


getIpAddresses = ->
  interfaces = os.networkInterfaces()
  addresses = []
  for k,v of interfaces
    for k2,v2 of interfaces[k]
      address = interfaces[k][k2]
      if address.family is 'IPv4'
        addresses.push(address.address)
  return addresses


mailTail = ->
  child = exec('tail -n20 ' + config.log_directory,
    (error, stdout, stderr) ->
      mail_log = """
      Worker died, IP was #{JSON.stringify getIpAddresses()}

      log tail:\n
      stdout: #{stdout}\n
      stdout: #{stderr}\n
      """

      mail.sendMail mail_log

      if error?
        log.e 'exec error: ' + error
  )

startAll = ->

  if cluster.isMaster
    worker = cluster.fork().process
    cluster.on 'exit',(worker) ->
      log.i 'worker %s died. restart...', worker.process.pid
      log.i "Worker died, IP was #{JSON.stringify getIpAddresses()}"
      cluster.fork()

      if config.send_mail
        mailTail()

  else
    if config.master
      console.log "runing master instance"
      Q() # Calls below are safe to be commented out individually
      .then rest.startServer
      .then sockets.startServer
      .then -> models.sequelize.sync()
      .then tasks.startScheduler
      .fail (err) ->
        log.ex err, "startAll", "", "CRITICAL: SERVER NOT RUNNING"
    else
      console.log "runing slave instance"
      Q() # Calls below are safe to be commented out individually
      .then rest.startServer
      .then sockets.startServer
      .then -> models.sequelize.sync()
      .fail (err) ->
        log.ex err, "startAll", "", "CRITICAL: SERVER NOT RUNNING"


stopAll = ->
  if config.master
    console.log "Shutdown master instance"
    Q() # Calls below are safe to be commented out individually
      .then rest.stopServer
      .then sockets.stopServer
      .then tasks.stopScheduler

      .then ->
        log.i "Shutdown successful"

      .fail (err) ->
        log.ex err, "stopAll", "", "Shutdown Error"

      .finally ->
        exit()
  else
    console.log "Shutdown slave instance"
    Q() # Calls below are safe to be commented out individually
      .then rest.stopServer
      .then sockets.stopServer
      .then ->
        log.i "Shutdown successful"

      .fail (err) ->
        log.ex err, "stopAll", "", "Shutdown Error"

      .finally ->
        exit()



process.on 'SIGTERM', stopAll
process.on 'SIGINT' , stopAll

#Agregar ENVIO DE MAIL CUANDO HAY EXEPCION
process.on 'uncaughtException', (err) ->
  log.ex err, "uncaughtException", "", "FATAL ERROR! Uncaught exception"
  log.e "FATAL ERROR! Uncaught exception: #{err.message}"
  log.e "FATAL ERROR! Uncaught exception: #{err.stack}"
  process.exit(1)


startAll()
