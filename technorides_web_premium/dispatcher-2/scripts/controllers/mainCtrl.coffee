technoridesApp.controller 'mainCtrl', ($scope, $settings, $translate, $user, $window, $radio, $webSocket, $webSocketAdapter, $webSocketHandler, $map, $operations, $drivers, $weather, $interval, $company, $versionDetector, $message, $main, $timeout, $tutorial, $statistics, $chat, $autocomplete) ->
  # We set $map provider
  $map.chooseProvider("google")
  $map.useClusters(true)
  $scope.lang = "en"
  window.scrollTo(0,0)

  # Messages
  $scope.chat  = $chat
  $scope.error    = $message.error
  $scope.success  = $message.success
  $scope.warning  = $message.warning
  $scope.tutorial = $tutorial
  $scope.hideConnected = false
  $scope.hideDiconnected = false



  lastAddressFrom = {}
  lastAddressTo   = {}

  $interval( ->
      addressFrom = $operations.operation.addressFrom?.address
      unless addressFrom is lastAddressFrom.address or $operations.clickedFrom
        lastAddressFrom.address = addressFrom
        $autocomplete.autocompleteAddressFrom(lastAddressFrom)
      addressTo = $operations.operation.addressTo?.address
      unless addressTo is lastAddressTo.address or $operations.clickedTo
        lastAddressTo.address = addressTo
        $autocomplete.autocompleteAddressTo(lastAddressTo)
    ,
      3000
    ,
      0
  )


  #CLOCK
  $scope.clock = new Date()
  $interval ->
    $scope.clock = new Date()
  ,
    1000
  ,
    0
  ,
    true

  $user.loadFromCookies()
  loadScripts = (src, callback) ->
    script = document.createElement("script");
    script.type = "text/javascript";
    if callback
      script.onload = callback
    document.getElementsByTagName("head")[0].appendChild(script);
    script.src = src

  loadMap = ->
    # Map
    $map.initialize "map_canvas",
      latitude : $user.latitude
      longitude : $user.longitude
      zoom      : 14
      mapTypeId : "mapbox.streets"

    $map.addListener "idle", ->
      $map.hideCircles "operations"
      $map.hideCircles "operations2"
      $map.hideCircles "operations3"

    # Company
    options =
      position  : $map.getCenter()
      icon      : "/common/assets/markers/home.png"
      doCluster : false
      visible   : true
      draggable : false

    $map.addMarker "company", "home", options

    options =
      position  : $map.getCenter()
      icon      : "/common/assets/markers/origin.png"
      draggable : true
      visible   : false
      doCluster : false


    # From
    listeners = []

    # FIXME Hacer reutilizable porque también está en el getOperations pero con diferentes IDs
    circleOptions = {}

    circleOptions.radius = $company.configuration.operations.autorecieve.distance
    $map.addCircle "newOperation", "from", circleOptions

    circleOptions.radius = $company.configuration.operations.autorecieve.distance * (1 + $company.configuration.operations.autorecieve.relaunch)
    $map.addCircle "newOperation", "from2", circleOptions

    circleOptions.radius = $company.configuration.operations.autorecieve.distance * (1 + ($company.configuration.operations.autorecieve.relaunch * 2))
    $map.addCircle "newOperation", "from3", circleOptions

    listeners.push
      event    : "dragend"
      callback : (event) ->
        $operations.calculatePrice()
        $operations.updateAddres $map.getCallbackMarker(event), "from"

    listeners.push
      event    : "mouseover"
      callback : () ->
        for circleName in ["from", "from2", "from3"]
          $map.showCircle "newOperation", circleName
          $map.updateCircle "newOperation", circleName, center: $map.getMarkerPosition("newOperation", "from")

    listeners.push
      event    : "mouseout"
      callback : () ->
        for circleName in ["from", "from2", "from3"]
          $map.hideCircle "newOperation", circleName

    listeners.push
      event    : "drag"
      callback : (event) ->
        for circleName in ["from", "from2", "from3"]
          $map.updateCircle "newOperation", circleName, center: $map.getCallbackMarker(event)

    $map.addMarker "newOperation", "from", options, listeners

    # To
    options =
      position  : $map.getCenter()
      icon      : "/common/assets/markers/destination.png"
      draggable : true
      visible   : false
      doCluster : false

    listeners = []

    listeners.push
      event    : "dragend"
      callback : (event) ->
        $operations.calculatePrice()
        $operations.updateAddres $map.getCallbackMarker(event), "to"
    $map.addMarker "newOperation", "to", options, listeners

    $scope.map               = $map
    $map.visibility.parkings = $company.configuration.parking.enabled

    #PARKING NOT YET
    $operations.getParkings()

    $main.sslCert done : ->
      $webSocket.setAdapter($webSocketAdapter)
      $webSocket.setHandler($webSocketHandler)
      $webSocket.connect()

    $(window).resize ->
      newSize = window.innerHeight - $("#map_canvas").height() - 90
      $(".operations-grid .panel-body").css("max-height", newSize)
      $("#map_canvas").resizable
        handles  : "s"
        minHeight: 0
        maxHeight: window.innerHeight - 70
        resize   : ->
          $map.resize()

    $("#map_canvas").resize()

  if not $user.isLogged
    $window.location = "/login"
  else
    loadScripts("https://maps.googleapis.com/maps/api/js?v=3&libraries=places", ->
      loadScripts("/common/libs/markerwithlabel.js", ->
        loadScripts("/common/libs/markerclusterer.js", ->
          # Ask mic access
          $company.getConfig
            done: ->
              $company.getScheduledConfig()
              loadMap()

          if $user.digitalRadio
            $window.navigator.askMicAcces()
          # Set Up Panel
              # Monitor
          if $user.role is 'monitor'
            $statistics.init()
            $scope.statistics = $statistics
          $scope.user = $user
          $scope.lang = $user.lang
          $scope.$translate = $translate
          $scope.settings = $settings
          $scope.radio = $radio
          $user.radio =
            sender: ""
          $translate.use $user.lang
          $radio.sender = $user.radio.sender
          $scope.drivers = $drivers
          $scope.company = $company
          $scope.changeLang = (key) ->
            $translate.use(key)
            $scope.lang = key
          $scope.weather = $weather
          $weather.update()
          $interval($weather.update(),60000)


          $scope.validateOldDates = ($dates) ->
            dateToUTC = (date) ->
              new Date(
                date.getUTCFullYear()
                date.getUTCMonth()
                date.getUTCDate()
                date.getUTCHours()
                date.getUTCMinutes()
                date.getUTCSeconds()
              )
            minDate = dateToUTC(new Date()).setHours(0, 0, 0, 0)

            for value, key in $dates
              currentDate = dateToUTC(new Date($dates[key].utcDateValue)).setHours(0, 0, 0, 0)

              if currentDate < minDate
                $dates[key].selectable = false

          $scope.initFields = ->
            $operations.operation.count_trip   = 1
            $operations.operation.businessModel = $user.businessModel[0]
        )
      )
    )
