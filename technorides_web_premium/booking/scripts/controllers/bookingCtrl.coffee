technoridesApp.controller 'bookingCtrl' ,($scope, $driver, $user, $company, $order, $api, $location, $map, $webSocket, $error,$webSocketAdapter,$apiHandler, $webSocketHandler , $apiAdapter ,$rootScope, $settings, $window, ipCookie) ->

  # Used by common
  $scope.settings = $settings
  $scope.settings.unstableVersion = false

  # set adapter and handler for websocket and api
  $webSocket.setAdapter($webSocketAdapter)
  $webSocket.setHandler($webSocketHandler)

  $api.setAdapter($apiAdapter)
  $api.setHandler($apiHandler)

  # Setup the mail models into the scope
  $scope.company = $company
  $scope.user    = $user
  $scope.order   = $order
  $scope.map     = $map.booking
  $scope.origin  = $map.booking.origin
  $scope.error   = $error
  $scope.driver  = $driver

  # URL
  host = $location.host()
  path = $location.path()

  # Host
  $company.domain = host

  # i.e.: /rtaxi/16887 (iframe)
  $company.rtaxi = path.split("/")[2] if (/\/rtaxi\/.+/g).test(path)

  # Iframe?
  if $company.rtaxi?
    $api.send 'getCompanyData', $company.rtaxi, ->
      if $user.isLogged
        $api.send 'sslCert', {}
  else
    $api.send 'getCompanyDataByDomain', host, ->
      if $user.isLogged
        $api.send 'sslCert', {}


  # Watching for wrong accesses
  $rootScope.$watch ->
      $location.path()
    (path) ->
      inLoggedPath = not (path is "" or path is "/" or path is "/login" or path is "/register" or path is "/forgot-password")

      # Wrong access?
      if $user.isLogged isnt inLoggedPath
        $location.path(if $user.isLogged then "/order" else "/")# Redirect to right path

  if $user.isCorporateAdmin
    ipCookie "rtaxi", $company.rtaxi
    $user.loginCorporateAdmin()
    $window.location = "corporate"

  $scope.login = (credentials) ->
    $user.logout()
    $api.send 'login', credentials, ->
      if $user.isLogged
        $api.send 'sslCert', {}

  $scope.logout = () ->
    $order.cancel()
    $driver.unsetDriver()
    $user.logout()
    $webSocket.close()
    $webSocket.stopReconnecting()


  $scope.register = (credentials) ->
    $api.send 'registerUser', credentials


  $scope.contact = (credentials) ->
    $api.send 'contactEmail' ,credentials


  $scope.forgotPassword = (credentials) ->
    $api.send 'forgotPassword',credentials.email


  $scope.createTrip = (origin ,destination, others) ->
    data =
      origin      : origin
      destination : destination
      others      : others

    if data.others?.scheduled isnt "true"
      $api.send 'createTrip', data
    else
      $api.send 'createScheduledTrip', data
    $map.booking.markerDest.options.visible = false


  $scope.geolocateDestination = (destination, callback) ->
    $map.booking.geolocateDestination(destination, callback)
    $map.booking.markerDest.options.visible = true


  $scope.geolocateOrigin = (origin, callback) ->
    $map.booking.geolocateOrigin(origin, callback)


  $scope.priceCalculator = () ->
    $api.priceCalculator 'priceCalculator', {}


  $scope.cancelTrip = () ->
    $webSocket.send $webSocketAdapter.output.cancelTrip()
    $map.booking.geolocate()
