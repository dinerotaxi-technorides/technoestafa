technoridesApp.controller 'bookingCtrl' ,($scope, $user, $location,$company, $map, $timeout, $routeParams, $operation, $webSocket, $webSocketAdapter, $webSocketHandler, $window, $main) ->
  $scope.map = $map

  if $company.info?
    $company.getInfo()

  $user.cookie.load($company.rtaxi)


  #broadcast from operation changes on the service #thankyousanti!, apply changes to scope
  $scope.$on 'operationChanged', ->
    if not $scope.$$phase
      $scope.$apply ->
        $scope.operation = $operation

  unless $user.isLogged
    $location.path "/"
  else
    $scope.operation = $operation

    #Get user position and set it
    $map.geolocate $operation.setOrigin
    $operation.resetDate()

    #set the initial tab
    $scope.tab = 'order'

    #Get user favorites trips (not available for this kind of user, yet)
    #$user.getFavorites()

    #Connect to Web-socket
    $main.sslCert done : ->
      $webSocket.setAdapter($webSocketAdapter)
      $webSocket.setHandler($webSocketHandler)
      $webSocket.connect()

    #THE FIXING FUNCTIONS (holy grail)
    #for corporate admins that want to use our prety booking web ;>
    $scope.backToAdmin = ->
      $webSocket.close()
      $location.path "/corporate"

    #Tooltips---ACTIVATE----(machinery noise) gat damn iframe

    $scope.activateTooltips = ->
      $('.tool').tooltip()
      false

    #Another fucking fix of plugin (this time angular datetimepicker to force future dates only)
    # $scope.validateOldDates = ($dates) ->
    #   dateToUTC = (date) ->
    #     new Date(
    #       date.getUTCFullYear()
    #       date.getUTCMonth()
    #       date.getUTCDate()
    #       date.getUTCHours()
    #       date.getUTCMinutes()
    #       date.getUTCSeconds()
    #     )
    #   minDate = dateToUTC(new Date()).setHours(0, 0, 0, 0)

    #   for value, key in $dates
    #     currentDate = dateToUTC(new Date($dates[key].utcDateValue)).setHours(0, 0, 0, 0)

    #     if currentDate < minDate
    #       $dates[key].selectable = false
