Agenda       = require 'agenda'
Q            = require 'q'
config       = require '../../config'
log          = require('../log').create 'Tasks'
service      = require './service'
operation_sv = require './operation_service'

driver_parking_q = require './driver_parking_queue'


agenda = new Agenda
  db: address: "#{config.mongo.host}:#{config.mongo.port}/tasks"


agenda.on 'start', (job) ->
  log.i "Launched task '#{job.attrs.name}'" # len 'launched' = 'finished'

agenda.on 'success', (job) ->
  log.i "Finished task '#{job.attrs.name}'"

agenda.on 'fail', (err, job) ->
  log.ex err, "agenda", "", "Error during task '#{job.attrs.name}"


@startScheduler = ->
  console.log "started:job_server"

  # Remove all previous jobs:
  # WARNING: THIS IS ABSOLUTELY NOT ATOMIC, AND WILL NOT SURVIVE MULTIPLE
  # INSTANCES FIGHTING FOR IT.
  Q.npost agenda, 'jobs'
  .then (jobs) ->
    Q.all (Q.npost job, 'remove' for job in jobs)

  .then ->
    for name, task of config.tasks
      if task.active
        # console.log "JOB:#{name} started"
        agenda.every task.timer, name
      else
        # console.log "WARNING JOB:#{name} not executed"


    agenda.start();
    log.i "Started"

  .fail (err) ->
    log.ex err, "startScheduler", "", "Failed to Start"


@stopScheduler = ->
  Q.npost agenda, 'stop'
  .then ->
    log.i "Stopped"

  .fail (err) ->
    log.ex err, "stopScheduler", "", "Failed to Stop"




createTask = (name, f) ->
  agenda.define name, (job, next) ->
    Q(f.call config.tasks[name], job).nodeify next


createTask 'inconcistentOperation', (job) ->
  log.d "finishInconsistentOperation"

  Q()
  .then =>
    service.finishInconsistentOperations()
  .fail (err) ->
    log.ex err, "Schedule:inconcistentOperation", "", "Failed"


#FIX ME  ONLY NEED TO RELEASE THE CHANGED THINGS
createTask 'configRelease', (job) ->
  log.d "configRelease"
  Q.try =>
    service.updateAllConfig()
  .fail (err) ->
    log.ex err, "Schedule:configRelease", "", "Failed"

#FIX ME  ONLY NEED TO RELEASE THE CHANGED THINGS
createTask 'updateAllCompaniesConfig', (job) ->
  log.d "updateAllCompaniesConfig"
  Q.try =>
    service.updateAllCompaniesConfig()
  .fail (err) ->
    log.ex err, "Schedule:updateAllCompaniesConfig", "", "Failed"

#FIX ME  ONLY NEED TO RELEASE THE CHANGED THINGS
createTask 'updateDrivers', (job) ->
  log.d "updateDrivers"
  Q()
  .then =>
    service.bs_service.updateDrivers()
  .fail (err) ->
    log.ex err, "Schedule:updateDrivers", "", "Failed"

createTask 'updateParkings', (job) ->
  log.d "updateParkings"
  Q()
  .then =>
    service.parking_service.updateAllParkingJob()
  .fail (err) ->
    log.ex err, "Schedule:updateParkings", "", "Failed"

createTask 'refreshDriversQueue', (job) ->
  log.d "refreshDriversQueue"
  Q()
  .then =>
    driver_parking_q.batchUpdateQueues()
  .fail (err) ->
    log.ex err, "Schedule:refreshDriversQueue", "", "Failed"

createTask 'zones', (job) ->
  log.d "Zones"
  Q()
  .then =>
    service.loadZones()
  .fail (err) ->
    log.ex err, "Schedule:Zones", "", "Failed"

createTask 'timeoutConnections', (job) ->
  log.d "timeoutConnections"
  Q()
  .then =>
    service.timeoutSocketConnections()
  .fail (err) ->
    log.ex err, "Schedule:timeoutConnections", "", "Failed"

#FIX ME  ONLY NEED TO RELEASE THE CHANGED THINGS
createTask 'ping', (job) ->
  log.d "ping"
  Q()
  .then =>
    service.ping()
  .fail (err) ->
    log.ex err, "Schedule:ping", "", "Failed"

#FIX ME  ONLY NEED TO RELEASE THE CHANGED THINGS
createTask 'respawnTrips', (job) ->
  log.d "respawnTrips"
  Q.try =>
    operation_sv.respawnTrips()
  .fail (err) ->
    console.log err
    log.ex err, "Schedule:respawnTrips", "", "Failed"

createTask 'fareCalculator', (job) ->
  log.d "FareCalculator"
  Q()
  .then =>
    service.fc_service.execute_job()
  .fail (err) ->
    console.log err
    log.ex err, "Schedule:FareCalculator", "", "Failed"

createTask 'queueDriver', (job) ->
  log.d "queueDriverJOB"
  Q()
  .then =>
    service.queue_service.execute_job()
  .fail (err) ->
    log.ex err, "Schedule:queueDriverJOB", "", "Failed"


createTask 'pushService', (job) ->
  log.d "pushService"
  Q()
  .then =>
    service.push_service.execute_job()
  .fail (err) ->
    log.ex err, "Schedule:pushService", "", "Failed"


createTask 'disconectBlockedUsers', (job) ->
  log.d "disconectBlockedUsers"
  Q()
  .then =>
    service.user_service.execute_job()
  .fail (err) ->
    log.ex err, "Schedule:disconectBlockedUsers", "", "Failed"


createTask 'driverDispatcherFunction', (job) ->
  log.d "driverDispatcherFunction"
# Q()
# .then =>
#   service.dispatcher_service.execute_job()
# .fail (err) ->
#   console.log err
#   log.ex err, "Schedule:driverDispatcherFunction", "", "Failed"

createTask 'timeoutMessages', (job) ->
  log.d "timeoutMessages"
#deprecated we need to implements messages with response
# service.timeoutMessages()
