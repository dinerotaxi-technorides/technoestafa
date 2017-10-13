technoridesApp.factory '$driver', ['$cookieStore', '$company',($cookieStore, $company) ->

  $driver =
    name      : ''
    carModel  : ''
    carNumber : ''
    email     : ''
    id        : null

    setDriver : (driver) ->
      for key, value of driver
        $driver[key] = value


    unsetDriver : ->
      $driver.name      = ''
      $driver.carModel  = ''
      $driver.carNumber = ''
      $driver.email     = ''
      $driver.id        = null


]
