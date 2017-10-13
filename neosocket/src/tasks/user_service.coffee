Q         = require 'q'

sql       = require '../dbs/sql'
config    = require '../../config'
tools     = require '../tools'
mongo     = require '../dbs/mongo'
log       = require('../log').create 'UserService'

@execute_job = () ->
  Q()
  .then =>
    sql.findRecentDisabledUsers
      type_employ:['TAXISTA']

  .then (users) =>
    ##Double check if the array contains elements
    if users.length > 0
      Q.all(

        for user in users
          mongo.Driver.findOneAndUpdate {
              driver_id: users.id
            }, {
              status: 'DISCONNECTED'
            },
            new : false
          .exec()

          ##DIsconnect those drivers that were disabled by Technorides policies violations
          tools.closeConnection 'driver', user.rtaxi_id, user.user_id, 3005, "Blocked"
    )
  .fail (err) ->
    log.ex err, "user_service:execute_job", "#{err.stack}"
