Q             = require 'q'
request       = require 'request'
GoogleMapsAPI = require 'googlemaps'
log           = require('../log').create 'Maps'
config        = require '../../config'

@getKmDistance = (from, to)->
  log.d "generateKmDistance"
  Q().then =>
    gmAPI = new GoogleMapsAPI(config.google_api)
    dir_config =
      origin     :from.toString()
      destination:to.toString()

    deferred = Q.defer()

    gmAPI.directions dir_config, (err, data) =>
      if err
        deferred.reject(new Error(err))
      else
        deferred.resolve(data)

    return deferred.promise
  .fail (err) =>
    log.ex err, "generateKmDistance", "#{err.stack}"
    return null
