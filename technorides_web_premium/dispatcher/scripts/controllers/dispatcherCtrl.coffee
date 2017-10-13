technoridesApp.controller 'dispatcherCtrl' ,['$scope','$map','$api','$apiHandler','$apiAdapter','$user','$webSocket','$webSocketAdapter','$webSocketHandler','$interval','$statistics', '$settings','$company','$location', '$msgs', '$rootScope','$sugestions','$window', '$feedback','$timeout','$message','$cookieStore','$translate','$radio','$versionDetector','$menu','$http','$price',($scope, $map, $api, $apiHandler, $apiAdapter, $user, $webSocket, $webSocketAdapter, $webSocketHandler, $interval, $statistics, $settings, $company, $location, $msgs, $rootScope, $sugestions, $window, $feedback, $timeout, $message, $cookieStore, $translate, $radio, $versionDetector, $menu, $http,$price) ->

  $(window).resize ->
    newSize = window.innerHeight - $("#map_canvas").height() - 90
    $(".operations-grid .panel-body").css("max-height", newSize)
    $("#map_canvas").resizable
      handles  : "s"
      minHeight: 0
      maxHeight: window.innerHeight - 70
      resize   : ->
        $map.dispatcher.resize()

  $("#map_canvas").resize()

  $(document).ready(->
    $(window).resize()
  )
  $(document.body).live "mouseover", ->
    # Tooltip
    $(".btn[title]").tooltip()

  # Record
  $scope.recording = false
  $scope.menu      = $menu

  # Checking microphone
  $scope.microphoneDisabled = $window.navigator.microphoneDisabled

  $interval ->
    $scope.microphoneDisabled = $window.navigator.microphoneDisabled
  ,
    500
  ,
    0
  ,
    true


  $scope.play = (sound) ->
    $webSocket.send $webSocketAdapter.output.soundMessage(sound)
    navigator.recorder.clear()
    $scope.encoding = false

  $scope.radiotodriver = {}

  $scope.radiotodriver.play = (sound) ->

    $webSocket.send $webSocketAdapter.output.soundMessageToDriver(sound, $scope.radiotodriver.id)
    $scope.radiotodriver.encoding = false

  $scope.stopRecording = ->
    unless $scope.microphoneDisabled
      if $scope.recording
        console.warn "Stopped Recording..."
        navigator.recorder.stop()
        navigator.recorder.exportWAV (blob) ->
          # TODO
        $scope.recording = false
        $scope.encoding  = true

  $scope.radiotodriver.stopRecording = ->
    unless $scope.microphoneDisabled
      if $scope.radiotodriver.recording
        console.warn "Stopped Recording..."
        navigator.recorder.stop()
        navigator.recorder.exportWAV (blob) ->
          # TODO
        $scope.radiotodriver.recording = false
        $scope.radiotodriver.encoding  = true

  $scope.radiotodriver.record = (id) ->
    unless $scope.microphoneDisabled
      unless $scope.radiotodriver.recording or $scope.radiotodriver.encoding
        # Changing image
        $scope.radiotodriver.id = id
        image = new Image()
        image.src = "/dispatcher/assets/radio/radio_btn.png"
        $("img#radiodriverRecording").attr("src", image.src)
        $timeout ->
          image = new Image()
          image.src = "/dispatcher/assets/radio/radio_btn_recording.gif"
          $("img#radiodriverRecording").attr("src", image.src)
        ,
          100
        ,
          true

        # Stops current timer
        $timeout.cancel $scope.intervals.radioAutoStop

        # Starts a new timer
        $scope.intervals.radioAutoStop = $timeout ->
          if $scope.radiotodriver.recording
            $scope.radiotodriver.stopRecording()
        ,
          $settings.intervals.maxRadioMessageLength
        ,
          true

        $("#send").get(0).play()
        $timeout(->
          console.warn "Recording..."
          navigator.recorder.clear()
          navigator.recorder.record($scope.radiotodriver.play)
        ,
        500
        )
        $scope.radiotodriver.recording = true

  $scope.record = ->
    unless $scope.microphoneDisabled
      unless $scope.recording or $scope.encoding
        # Changing image
        image = new Image()
        image.src = "/dispatcher/assets/radio/radio_btn.png"
        $("img#radioRecording").attr("src", image.src)
        $timeout ->
          image = new Image()
          image.src = "/dispatcher/assets/radio/radio_btn_recording.gif"
          $("img#radioRecording").attr("src", image.src)
        ,
          100
        ,
          true

        # Stops current timer
        $timeout.cancel $scope.intervals.radioAutoStop

        # Starts a new timer
        $scope.intervals.radioAutoStop = $timeout ->
          if $scope.recording
            $scope.stopRecording()
        ,
          $settings.intervals.maxRadioMessageLength
        ,
          true

        $("#send").get(0).play()
        $timeout(->
          console.warn "Recording..."
          navigator.recorder.clear()
          navigator.recorder.record($scope.play)
        ,
        500
        )
        $scope.recording = true


  # Used by common
  $scope.settings        = $settings
  $scope.versionDetector = $versionDetector
  rMax                   = 3000
  $scope.panel           = true

  $api.setAdapter($apiAdapter)
  $api.setHandler($apiHandler)
  $webSocket.setAdapter($webSocketAdapter)
  $webSocket.setHandler($webSocketHandler)

  $scope.error   = $message.error
  $scope.success = $message.success
  $scope.warning = $message.warning

  $scope.map        = $map.dispatcher
  $scope.user       = $user
  $scope.statistics = $statistics
  $scope.operations = $company.operations

  $scope.logs         = $msgs.logs
  $scope.drivers      = $company.drivers
  $scope.company      = $company
  $scope.sugestions   = $sugestions
  $scope.radio        = $radio
  $scope.sug          = false
  $scope.newOperation = {}
  $scope.wiz          = 1
  $scope.orderby      = "id"
  $scope.feedback     = $feedback
  $scope.price        = $price

  $user.loadFromCookies()
  $scope.newOperation.addressFrom = {}
  $scope.newOperation.comments    = ""
  $scope.ops                      =
    user:
      phone    : null
      email    : null
      name     : null
      lastname : null
      id       : null

  $scope.intervals            = {}
  $scope.intervals.dispatcher = {}
  $scope.intervals.statistics = {}

  $scope.location = $location

  # Set language
  if $cookieStore.get("lang")?
    $scope.lang = $cookieStore.get("lang")
  else
    $scope.lang = $user.lang

  # Language supported?
  $scope.lang = "en" unless $.inArray $scope.lang, ["en", "es", "fr"]

  $translate.use($scope.lang)

  $scope.changeLanguage = (lang) ->
    $translate.use(lang)
    $cookieStore.remove("lang")
    $cookieStore.put("lang", lang)
    $scope.lang = lang


  setIntervals = ->
    $scope.statistics.menu.drivers.draw()
    $scope.statistics.menu.others.getData()

    if $user.role is "monitor"
      $scope.statistics.grid.operations.byStatus.getData()
      $scope.statistics.grid.operations.byDevice.getData()
      $scope.statistics.grid.operations.byDate.getData()
      $scope.statistics.grid.operations.earnings.getData()
      $scope.statistics.grid.others.passengers.getData()

    # Estimated Time
    $scope.intervals.dispatcher.estimateds = $interval(->
      for id, operation of $company.operations
        operation.estimatedTime-- unless operation.atDoorAt?
    ,
      1000
    ,
      0
    ,
      true
    )


    # Drivers
    $scope.intervals.statistics.drivers = $interval(->
      $scope.statistics.menu.drivers.draw()
    ,
      $settings[$settings.environment].intervals.statistics.menu.drivers
    ,
      0
    ,
      false
    )


    # Others
    $scope.intervals.statistics.others = $interval(->
      $scope.statistics.menu.others.getData()

      if $user.role is "monitor"
        # IMPROVE
        $timeout(->
          $scope.statistics.grid.operations.byStatus.getData()
          $scope.statistics.grid.operations.byDevice.getData()
          $scope.statistics.grid.operations.byDate.getData()
          $scope.statistics.grid.operations.earnings.getData()
          $scope.statistics.grid.others.passengers.getData()
        ,
          500
        ,
          true
        )
    ,
      $settings[$settings.environment].intervals.statistics.menu.others
    ,
      0
    ,
      true
    )


    $interval(->
      $scope.getScheduledTrips()
    ,
      $settings[$settings.environment].intervals.scheduledOperations
    ,
      0
    ,
      true
    )


  unsetIntervals = ->
    $interval.cancel($scope.intervals.statistics.drivers)
    $interval.cancel($scope.intervals.statistics.others)


  if $user.isLogged
    $map.dispatcher.center =
      latitude  : $user.latitude
      longitude : $user.longitude
    $map.dispatcher.markerHome.coords.latitude  = $user.latitude
    $map.dispatcher.markerHome.coords.longitude = $user.longitude
    $map.dispatcher.markerHome.options =
      labelContent : "#{$user.company}"
      labelClass: ''
      labelAnchor: "35 0"
      labelInBackground: false
      optimized: false
      draggable: false

    if $user.isLogged
      $api.send 'sslCert', {}

    # get zones and parkings
    $api.send "getParkings"
    $api.send "getZones"

    $api.send "getCompanyConfiguration"
    setIntervals()

    if $user.digitalRadio
      $window.navigator.askMicAcces()


  $scope.logout = ->
    $user.logout()
    unsetIntervals()
    $webSocket.close()
    $webSocket.stopReconnecting()
    $window.location = "/login"


  # Logged? or Company?
  if !$user.isLogged or ($user.role isnt "operator" and $user.role isnt "calltaker" and $user.role isnt "monitor")
    $scope.logout()

  # Watching for wrong accesses
  $rootScope.$watch ->
      $location.path()
    (path) ->
      # Logged?
      if $user.isLogged

        # Monitor
        if $user.role is "monitor"
          if path isnt "/statistics"
            $location.path "/statistics"


  # Dispatcher
  if $user.role isnt "monitor"
    $window.location = "/dispatcher-2"
  else
    if $location.path isnt "/statistics"
      $location.path "/statistics"


  $scope.getScheduledTrips = ->
    $api.send 'getScheduledTrips', {}, (response) ->
      $scope.markOperationsAsShownByStatus $scope.menu.tab


  $scope.getScheduledTrips()


  $scope.mAssingOperation = (op, status) ->
    $scope.toAssign = op
    $('.assing-operation').modal('show')
    false

  $scope.mResearchDriver = (op) ->


  $scope.mrelaunchOperation = (op) ->
    $scope.toRelaunch = op
    $('.relaunch-operation').modal("show")
    false


  $scope.relaunchOperation = (op) ->
    $(".relaunch-operation").modal("hide")
    $api.send 'createOperation', $apiAdapter.output.relaunchOperation(op), (response) ->
      $scope.getScheduledTrips()


  $scope.assignOperation = (assign,operation) ->
    if operation.status is "scheduled"
      $api.send 'assignScheduledOperation', {driver: assign.driverId, id:operation.id}, (response) ->
        $scope.getScheduledTrips()
    else
      $webSocket.send $webSocket.webSocketAdapter.output.assingOperation(assign,operation.id)

    $('.assing-operation').modal('hide')
    false


  $scope.mEditOperation = (op) ->
    $scope.toEdit = op
    $(".edit-operation").modal("show")
    false

  $scope.mFindDriver = (op) ->
    $scope.toFind = op
    $(".find-driver").modal("show")
    false


  $scope.editOperation =  (operation) ->
    $api.send "editScheduledOperation", operation, ->
      $(".edit-operation").modal("hide")
      false
      $scope.getScheduledTrips()

  $scope.mCancelOperation = (op, status) ->
    $scope.toCancel =
      id : op
      status : status
    $(".cancel-operation").modal('show')
    false

  $scope.researchDriver = (id) ->
    $webSocket.send $webSocket.webSocketAdapter.output.findDriver(id)
    $(".find-driver").modal("hide")
    false

  $scope.cancelOperation = (data) ->
    if data.status is "scheduled"
      $api.send "cancelScheduledOperation", data.id, (response) ->
        $scope.getScheduledTrips()
    else
      $webSocket.send $webSocket.webSocketAdapter.output.cancelTrip(data.id)
    $(".cancel-operation").modal('hide')
    false


  $scope.mfinishOperation = (id) ->
    $scope.toFinish =  id
    $(".finish-operation").modal("show")
    false


  $scope.finishOperation = (id) ->
    $webSocket.send $webSocket.webSocketAdapter.output.finishOperation(id)
    $(".finish-operation").modal("hide")
    false


  $scope.mAtTheDoor = (id) ->
    $(".at-the-door").modal('show')
    $scope.toAtTheDoor = id
    false


  $scope.atTheDoor = (id) ->
    $webSocket.send $webSocket.webSocketAdapter.output.holdingUser(id)
    $(".at-the-door").modal('hide')
    false


  $scope.mRingPassenger = (id) ->
    $(".ring-passenger").modal('show')
    $scope.toRing = id
    false


  $scope.ringPassenger = (id) ->
    $webSocket.send $webSocket.webSocketAdapter.output.ringPassenger(id)
    $(".ring-passenger").modal('hide')
    false


  $scope.mPassengerOnboard = (id) ->
    $scope.toSetonboard = id
    $(".set-passenger-on-board").modal('show')
    false


  $scope.setPassengerOnboard = (id) ->
    $webSocket.send $webSocket.webSocketAdapter.output.passengerOnboard(id)
    $(".set-passenger-on-board").modal('hide')
    false


  $scope.mSetAmount = (op) ->
    $scope.toSetAmount = op
    $(".set-amount").modal('show')
    false


  $scope.setAmount = (amount,toSetAmount) ->
    $webSocket.send $webSocket.webSocketAdapter.output.setAmount(amount,toSetAmount)
    $(".set-amount").modal('hide')
    false


  # Operation actions
  $scope.operationDetails = (op) ->
    $scope.showOp = op
    $(".op-info").modal('show')
    false


  $scope.operationLocate = (lat,lng) ->
    $map.dispatcher.center =
      latitude : lat
      longitude : lng


  $scope.locateDriver = (id) ->
    if $company.drivers[id]? and $map.dispatcher.visibility[$company.drivers[id].status]
      $map.dispatcher.center =
        latitude : $map.dispatcher.drivers[$company.drivers[id].marker.id].latitude
        longitude : $map.dispatcher.drivers[$company.drivers[id].marker.id].longitude
      $map.dispatcher.zoom = 16


  $scope.createOperation = (operationAttributes) ->
    if operationAttributes.dateDay isnt operationAttributes.dateHour
      operationAttributes.date = new Date(operationAttributes.dateDay)
      operationAttributes.date.setHours operationAttributes.dateHour.getHours()
      operationAttributes.date.setMinutes operationAttributes.dateHour.getMinutes()
      $api.send "createScheduledOperation", operationAttributes, (response) ->
        $scope.getScheduledTrips()
    else
      #$("#preloader").show()
      $api.send "createOperation", operationAttributes

    $scope.menu.tab = "pending"
    $scope.resetNewOperationForm()


  $scope.updateFavoritesOrigin = (id) ->
    $api.send 'updateFavoritesOrigin', id


  $scope.updateSugestionsTimeout = null
  $scope.updateSugestions = (text, type) ->
    if text?.length > 2
      $timeout.cancel $scope.updateSugestionsTimeout
      $scope.updateSugestionsTimeout = $timeout ->
        $api.send 'updateSugestions', {text: text, type: type}
      ,
        500
      ,
        true


  $scope.fillFormUserForm = (sugestion) ->
    $scope.newOperation.user =
      phone : sugestion.phone
      email : sugestion.email
      surname : sugestion.last_name
      name : sugestion.first_name
      id : sugestion.user_id
    $sugestions.options = {}


  $scope.fillFormOriginForm = (favorite) ->
    $sugestions.favoritesFrom = []
    $scope.newOperation.addressFrom =
      address   : favorite.street
      floor     : favorite.floor
      apartment : favorite.department

    if favorite.comments?
      $scope.newOperation.comments = favorite.comments
    $map.dispatcher.zoom = 16
    $map.dispatcher.setMarkerOrigin(favorite.latitude, favorite.longitude)


  $scope.priceCalculator = () ->
     $timeout ->
        $api.priceCalculator 'priceCalculator'
      ,
        1000
      ,
        true

  $scope.sugestOrigin = (response) ->
    $sugestions.googlePlaces.from = []
    # Place
    for place in response
      # Result
      $sugestions.googlePlaces.from.push
        placeName: place.name
        location:  location
        type : place.type
        place_id: place.place_id


  $scope.sugestDestiny = (response) ->
    $sugestions.googlePlaces.to = []
    # Place
    for place in response
      # Result
      $sugestions.googlePlaces.to.push
        placeName: place.name
        location:  location
        type : place.type
        place_id: place.place_id


  $scope.setOrigin = (place_id, address) ->
    # con place_id
    service = new google.maps.places.PlacesService($map.dispatcher.mapInstance);
    service.getDetails(
      placeId: place_id
      (place, status) ->
        keys = Object.keys(place.geometry.location)

        $map.dispatcher.markerOrigin.coords =
          latitude : place.geometry.location.lat()
          longitude: place.geometry.location.lng()


        $map.dispatcher.center =
          latitude : place.geometry.location.lat()
          longitude: place.geometry.location.lng()




        $map.dispatcher.markerOrigin.options.visible = true
        $map.dispatcher.markerOrigin.radius.visible  = true
    )

    $scope.newOperation.addressFrom.address = address
    $sugestions.googlePlaces.from           = []
  $scope.setDestiny = (place_id, address) ->
    # con place_id
    service = new google.maps.places.PlacesService($map.dispatcher.mapInstance);
    service.getDetails(
      placeId: place_id
      (place, status) ->
        keys = Object.keys(place.geometry.location)

        $map.dispatcher.markerDest.coords =
          latitude : place.geometry.location[keys[0]]
          longitude: place.geometry.location[keys[1]]


        $map.dispatcher.center =
          latitude : place.geometry.location[keys[0]]
          longitude: place.geometry.location[keys[1]]


        $map.dispatcher.markerDest.options.visible = true
    )

    $scope.newOperation.addressTo.address = address
    $sugestions.googlePlaces.to = []


  $scope.geolocateAddressOrigin = (address) ->
    $map.dispatcher.geolocateAddressOrigin(address)
    $map.dispatcher.markerOrigin.options.visible = true
    $map.dispatcher.markerOrigin.radius.visible  = true
    $scope.newOperation.addressFrom.address      = address
    $sugestions.googlePlaces.from                = []


  $scope.geolocateAddressDestiny = (address) ->
    $map.dispatcher.geolocateAddressDestiny(address)
    $map.dispatcher.markerDest.options.visible = true
    $scope.newOperation.addressTo.address      = address
    $sugestions.googlePlaces.to                = []


  $scope.newOperationRadius1 = 100 #$company.config.operations.autorecieve.distance
  $scope.newOperationRadius2 = 100
  $scope.newOperationRadius3 = 100


  # RADAR EFFECT FIX ME or PLEASE KILL ME
  rMin           = 0
  $scope.radius  = 0
  $scope.radius2 = 0
  $scope.radius3 = 0
  $scope.radius4 = 0

  increase     = 10
  $scope.fill1 =
    color   : '#009a80'
    opacity : 0.5
    weight  : 2

  $scope.fill2 =
    color   : '#009a80'
    opacity : 0.5
    weight  : 2

  $scope.fill3 =
    color   : '#009a80'
    opacity : 0.5
    weight  : 2

  $scope.fill4 =
    color   : '#009a80'
    opacity : 0.5
    weight  : 2

  started2 = false
  started3 = false
  started4 = false
  speed    = 20


  firstRadar = $interval (->
    if $scope.map.markerOrigin.radius.visible?
      if $company?.config?.operations?.autorecieve?.distance?
        rMax = $company.config.operations.autorecieve.distance
        startSecond = rMax/4
        startThirdh = startSecond*2
        startFourth = startSecond*3
        $scope.radius = 0  if $scope.radius >= rMax
        $scope.radius = $scope.radius + increase  if $scope.radius >= rMin

        if $scope.radius is 0
          $scope.fill1.opacity = 0.5

        if $scope.radius < startSecond
          $scope.fill1.opacity = ((rMax - $scope.radius)/rMax)

        if !started2
          if startSecond is $scope.radius
            $interval(secondRadar, speed)
            started2 = true

        if !started3
          if startThirdh is $scope.radius
            $interval(thirdRadar,speed)
            started3 = true

        if !started4
          if startFourth is $scope.radius
            $interval(fourthRadar,speed)
            started4 = true
  ), speed


  secondRadar = ->
    if $scope.map.markerOrigin.radius.visible?
      if $company?.config?.operations?.autorecieve?.distance?
        rMax = $company.config.operations.autorecieve.distance
        startSecond = rMax/4
        $scope.radius2 = 0 if $scope.radius2 >= rMax
        $scope.radius2 = $scope.radius2 + increase  if $scope.radius2 >= rMin

        if $scope.radius2 is 0
          $scope.fill2.opacity = 0.5

        if $scope.radius2 < startSecond
          $scope.fill2.opacity = ((rMax - $scope.radius2)/rMax)


  thirdRadar = ->
    if $scope.map.markerOrigin.radius.visible?
      if $company?.config?.operations?.autorecieve?.distance?
        rMax = $company.config.operations.autorecieve.distance
        startSecond = rMax/4
        $scope.radius3 = 0 if $scope.radius3 >= rMax
        $scope.radius3 = $scope.radius3 + increase  if $scope.radius3 >= rMin

        if $scope.radius2 is 0
          $scope.fill3.opacity = 0.5

        if $scope.radius3 < startSecond
          $scope.fill3.opacity = ((rMax - $scope.radius3)/rMax)


  fourthRadar = ->
    if $scope.map.markerOrigin.radius.visible?
      if $company?.config?.operations?.autorecieve?.distance?
        rMax = $company.config.operations.autorecieve.distance
        startSecond = rMax/4
        $scope.radius4 = 0 if $scope.radius4 >= rMax
        $scope.radius4 = $scope.radius4 + increase  if $scope.radius4 >= rMin

        if $scope.radius4 is 0
          $scope.fill4.opacity = 0.5

        if $scope.radius4 < startSecond
          $scope.fill4.opacity = ((rMax - $scope.radius4)/rMax)




  $scope.resetNewOperationForm                  = ->
    newDate                                     = new Date()
    newDate.setMinutes(Math.ceil(newDate.getMinutes() / 5) * 5)
    $scope.sugestions.options                   = []
    $scope.sugestions.favoritesFrom             = []
    $scope.sugestions.googlePlaces.from         = []
    $scope.sugestions.googlePlaces.to           = []
    $scope.newOperation                         =
      options                                   : {}
    $scope.datepickerMinDate                    = new Date()
    $scope.newOperation.dateDay                 = newDate
    $scope.newOperation.dateHour                = newDate
    $map.dispatcher.markerOrigin.radius.visible = false
    $map.dispatcher.resetMarkers()
    $scope.price.object.amount = undefined
    $timeout ->
      $('[data-toggle="popover"]').popover()
    ,
      100
    ,
      true


  bDist  = 0.001
  latMax = $scope.user.latitude + bDist
  latMin = $scope.user.latitude - bDist
  lngMax = $scope.user.longitude + bDist
  lngMin = $scope.user.longitude - bDist


  bounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(latMax, lngMax)
  ,
    new google.maps.LatLng(latMin, lngMin)
  )


  $scope.autocompleteOptions =
    country: $user.countryCode
    bounds : bounds


  $scope.resetNewOperationForm()


  $scope.markOperationsAsShownByStatus = (status) ->
    for id, operation of $scope.operations
      operation.shown = true if operation.status == status
      operation.shown = false unless operation.shown?


  $scope.$watch "menu.tab", (newValue, oldValue) ->
    $scope.markOperationsAsShownByStatus oldValue
    $scope.markOperationsAsShownByStatus newValue


  $scope.getOperationFlow = (id) ->
    $api.newApiSend("operationFlow", Number(id))


  $scope.sms       = {}
  $scope.sms.toAll = false


  $scope.sendMessage = (id, message) ->
    if $scope.sms.toAll
      email = undefined
    else
      email = "#{id}@#{$user.host.toLowerCase()}"
    $webSocket.send $webSocketAdapter.output.sendMessage email, message
    $scope.sms.driverId = ""
    $scope.sms.message= ""


  $scope.updateWeather = ->
    return
    if $scope.user?.latitude? and $scope.user?.longitude?
      $http.get "http://api.openweathermap.org/data/2.5/weather", params: {lat: $scope.user.latitude, lon: $scope.user.longitude, units: "metric"}
        .success (response) ->
          $scope.weather =
            temp        : "#{response.main.temp}°"
            icon        : "http://openweathermap.org/img/w/#{response.weather[0].icon}.png"
  $scope.updateWeather()


  $scope.updateClock = ->
    $scope.clock = new Date()
  $scope.updateClock()

  dateToUTC = (date) ->
    new Date(
      date.getUTCFullYear()
      date.getUTCMonth()
      date.getUTCDate()
      date.getUTCHours()
      date.getUTCMinutes()
      date.getUTCSeconds()
    )

  $scope.beforeRender = ($dates) ->
    minDate = dateToUTC(new Date()).setHours(0, 0, 0, 0)

    for value, key in $dates
      currentDate = dateToUTC(new Date($dates[key].utcDateValue)).setHours(0, 0, 0, 0)

      if currentDate < minDate
        $dates[key].selectable = false


  $interval ->
    $scope.updateClock()
  ,
    1000
  ,
    0
  ,
    true

  $interval ->
    $scope.updateWeather()
  ,
    $settings.intervals.updateWeather
  ,
    0
  ,
    true

]
