###
loadtest = require 'loadtest'

#This should be a global config
exeute_stress = true

runTest = (name, promise) ->
  promise
  .then (rows) ->
    console.log name, 'ok', rows
  .catch (err) ->
    console.log name, 'error', err
  .finally ->
    console.log name, 'finished'

socketPullingTrip = (max, threads) ->
    options = {
        url: 'http://localhost:8000',
        maxRequests: max,
        concurrency: threads
        #maxSeconds: 10,

    }
    runTest 'pullingTrip', loadtest.loadTest{options}


if exeute_stress?
  socketPullingTrip 50, 100

###