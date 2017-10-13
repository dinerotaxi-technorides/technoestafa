sql = require '../src/dbs/sql.coffee'

runTest = (name, promise) ->
  promise
    .then (rows) ->
      console.log name, 'ok', rows

    .catch (err) ->
      console.log name, 'error', err

    .finally ->
      console.log name, 'finished'


testFindUser = (id) ->
  runTest 'testFindUser', sql.findUser {id}


findConfigBy = (id) ->
  runTest 'findConfigBy', sql.findConfigBy {id}


findAllCompanies = ->
  console.log "find"
  runTest 'findAllCompanies', sql.findAllCompanies()


findAllDriversByCompany = (id) ->
  runTest 'findAllDriversByCompany', sql.findAllDriversByCompany {rtaxi_id : id}


findDriverById = (id) ->
  runTest 'findDriver', sql.findDriver {id}

findDriverByEmail = (email) ->
  runTest 'findDriver', sql.findDriver {email}

findZones = (token) ->
  runTest 'findZones', sql.findZones {token}


findUserByToken = (token) ->
  runTest 'findUserByToken', sql.findUserByToken {token}

findAllParking = ->
  runTest 'findAllParking', sql.findAllParking()

updateOperation = (op_id, status) ->
  runTest 'updateOperation', sql.updateOperation {op_id: op_id, status: status}


# testFindUser 35800

#findConfigBy 16887

# findAllCompanies()

#findAllDriversByCompany 16887

# findDriverById 16895
# findDriverByEmail '7@suempresa.com'

# findZones 'j3xC/4G2pa8jjydGMx49Bw=='

#findUserByToken 'j3xC/4G2pa8jjydGMx49Bw=='


#findAllParking()
#updateOperation 1,'COMPLETED'