Q          = require 'q'
geo     = require '../geo/google_maps'
mongo   = require '../dbs/mongo'
bk      = require '../dbs/broadcast'
sql     = require '../dbs/sql'
service = require './service'
tools   = require '../tools'
config  = require '../../config'

data_adapter = require '../dbs/data_adapter'

log     = require('../log').create 'DispatcherService'

NO_OPERATIONS = "no_operations"

@execute_job = () ->
  console.log "driverDispatcherFunction"
  Q()
  .then =>
    mongo.CompanyConfig.find
      has_driver_dispatcher_function:true
  .then (companies) =>
    @rtaxi_ids = []
    for company in companies
      @rtaxi_ids.push company.rtaxi_id
    @dispatch_operations @rtaxi_ids

  .fail (err) =>
    if err.message is NO_OPERATIONS
      return
    log.ex err, "dispatcher:execute_job"

@dispatch_operations = (rtaxi_s) ->
  Q()
  .then =>
    sql.findPendingOperationsByTime rtaxi_s
  .then (operations) =>
    operation_procesed = @prettyfyOperation operations, rtaxi_s
    for operation in operation_procesed
      @process_op operation
  .fail (err) =>
    log.ex err, "dispatcher:dispatch_operations"

@prettyfyOperation = (operations,rtaxi_s) ->
  new_operations = []

  for rtaxi in rtaxi_s
    not_in = true
    for operation in operations
      if rtaxi is operation.rtaxi
        not_in = false
        new_operations.push operation

    if not_in
      temp_msg =
        count     : 0
        operations: ''
        rtaxi     : rtaxi
      new_operations.push temp_msg

  return new_operations

@process_op = (result) ->

  Q()
  .then =>
    operations = []

    if result.operations?
      operations = result.operations.split ','

    @msg = {
      'action'                   : 'newOperations',
      'rtaxi_id'                 : result.rtaxi,
      'message_need_confirmation': false
    }

    if operations.length is  0
      @msg.operations = ''
    else
      @msg.operations = result.operations

    bk.broadcastToAllDrivers result.rtaxi, @msg
  .fail (err) =>
    log.ex err, "dispatcher:process_op"
