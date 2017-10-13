technoridesApp.factory '$operation', [ '$map', 'operation.api','$company','ipCookie', '$webSocket','$webSocketAdapter', '$timeout', '$rootScope','$modal',($map, $api, $company, ipCookie, $webSocket, $webSocketAdapter, $timeout, $rootScope, $modal, $user) ->
  geocoder = new google.maps.Geocoder()
  $operation =
    #handle single op
    op : {}
    geolocalazing : false
    #options
    options :
      courier         : false
      pet             : false
      airConditioning : false
      smoker          : false
      specialAsistance: false
      airport         : false
      lugage          : false
      vip             : false
      invoice         : false
    #SHOW THINGS ON ORDER FORM
    scheduled : []
    history : []
    show:
      destination : false
      scheduled   : false
      passenger   : false
      extras      : false

    #DESTINATION
    destination:
      coords:
        latitude : 0
        longitude : 0

    #ORIGIN
    origin :
      coords :
        latitude: 0
        longitude: 0
    estimatedPrice : null
    sugestions :
      origin : []
      destination : []

    setOrigin : (lat, lng, noCenter) ->
      if lat is "disabled"
        $modal.open(
          temp : "views/modal/booking/geolocation-disabled.html"
          title : "Error"
        )
        lat = $company.info.lat
        lng = $company.info.lng
        $operation.changed()
      else if lat is "error"
        $modal.open(
          temp : "views/modal/booking/geolocation-error.html"
          title : "Error"
        )
        $operation.changed()
        lat = $company.info.lat
        lng = $company.info.lng
      #update origin coords
      $operation.origin.coords =
        latitude: lat
        longitude: lng

      #Marker Options
      options =
        position  : $map.latLng({lat:lat, lng:lng})
        doCluster : false
        icon : '/common/assets/markers/booking/origin.png'
        draggable: true
        visible : true

      listeners =
        event : "dragend"
        callback : (event) ->
          latLng = $map.getCallbackMarker(event)
          coords = $map.formatLatLng(latLng)
          $operation.setOrigin(coords.lat, coords.lng, false)

      if not noCenter?
        #set map center
        setTimeout($map.setCenter($map.latLng({lat:lat, lng:lng})),
          500)

      # Add Origin marker
      $map.addOrUpdateMarker "newOperation", "origin", options, [listeners]

      # Add Destination marker
      if $operation.destination.coords.latitude isnt 0 and $operation.destination.coords.longitude isnt 0
        markVisible = true
      else
        markVisible = false
      options =
        position: $map.latLng({lat:0,lng:0})
        draggable: true
        visible  : markVisible
        doCluster : false
        icon : '/common/assets/markers/booking/destination.png'

      listeners =
        event : "dragend"
        callback : (event) ->
          latLng = $map.getCallbackMarker(event)
          coords = $map.formatLatLng(latLng)
          $operation.setDestination(coords.lat, coords.lng, true)
          $operation.changed()

      $map.addOrUpdateMarker "newOperation", "destination", options, [listeners]

      $map.reverseGeolocalize {lat: lat, lng: lng}, (result) ->
        $operation.origin.address = "#{result}"
        $operation.changed()
      false
      $operation.geolocalazing = false
    # Unisex geocode
    getSugestions : (togeocode) ->
      user =
        adminCode : $company.info.countryCode
        country   : $company.info.country
        latitude  : $company.info.lat
        longitude : $company.info.lng

      $map.geolocalize
        address : "#{$operation[togeocode].address}"
        user    : user
        done    : (results) ->
          $operation.calculatePrice()
          sugestions = []
          for result in results
            sugestions.push
              address : result.name
              placeId : result.place_id
              locate  : ->
                $operation.getPlace togeocode, @.placeId, @.address

          if $operation[togeocode].address and $operation[togeocode].address isnt ""
            $operation.sugestions[togeocode] = sugestions
          else
            $operation.sugestions[togeocode] = []
    getPlace : (toget, place, address) ->
      $map.getPlace
        place : place
        done : (data) ->
          if data.source is "midware"
            $operation.setOrigin(data.geometry.location.lat, data.geometry.location.lng)
          else
            $operation.setOrigin(data.geometry.location.lat(), data.geometry.location.lng())
          $operation[toget].address = address
          $operation.sugestions[toget] = []

    setDestination : (lat, lng, noCenter) ->
      $operation.destination.coords.latitude = lat
      $operation.destination.coords.longitude = lng
      $operation.calculatePrice()
      if not noCenter?
        #set map center
        $map.map.setCenter($map.latLng({lat:lat, lng:lng}))
      $map.reverseGeolocalize({lat:lat, lng: lng}, (response) ->
        $timeout( ->
          $operation.destination.address = "#{response}"
        ,
          10
        ,
          true
        )
      )

    parseDate : ->
      # Date + Hour
      $operation.date = $operation.day
      $operation.date.setHours $operation.hour.getHours()
      $operation.date.setMinutes $operation.hour.getMinutes()
      $operation.date.setMilliseconds $operation.currentDate.getMilliseconds()

    create : () ->
      $operation.parseDate()

      # Scheduled?
      if ($operation.date - $operation.currentDate) isnt 0
        $api.createScheduled(
          operation : $operation
          done : (adapted) ->
            $modal.open(
              temp : "views/modal/booking/scheduled-success.html"
              title : "Congrats!"
            )
            $operation.reset()
          fail : ->
            $modal.open(
              temp : "views/modal/booking/scheduled-error.html"
              title : "Error"
          )
        )

      else
        #normal trip
        $api.create(
          operation : $operation
          done : (adapted) ->
            $operation.searching = true
            $operation.created = true
            $operation.id = adapted.opId

            options =
              draggable: false

            $map.updateMarker "newOperation", "origin", options
            $map.updateMarker "newOperation", "destination", options

          fail : ->
            $modal.open
              temp : "views/modal/booking/operation-error.html"
              title : "Error"

        )

    setOperation : (message) ->
      #assigns operation and stuff
      if message.driver?
        $operation.driver =
          car:
            brand: message.driver.brandCompany
            mode : message.driver.model
            plate : message.driver.plate
          name : message.driver.firstName
          lastName: message.driver.lastName
          email : message.driver.email
          id : message.driver.id
          number : message.driver.driverNumber
          phone : message.driver.phone
          image : message.driver.image
        $operation.searching = false
      else
        $operation.searching = true

      $operation.created = true

      $map.updateMarker "newOperation", "origin", draggable:false
      $map.updateMarker "newOperation", "destination", draggable: false

      $operation.id = message.id
      $operation.options =
        airConditioning : message.options.airConditioning
        airport         : message.options.airport
        invoice         : message.options.invoice
        lugage          : message.options.luggage
        courier         : message.options.messaging
        pet             : message.options.pet
        smoker          : message.options.smoker
        specialAsistance: message.options.specialAssistant
        vip             : message.options.vip

      $operation.origin.coords =
        latitude : message.placeFrom.lat
        longitude: message.placeFrom.lng
      $operation.origin.address =  message.placeFrom.street
      $operation.origin.floor = message.placeFrom.floor
      $operation.origin.apartment = message.placeFrom.appartment
      $operation.destination.coords =
        latitude : message.placeTo.lat
        longitude: message.placeTo.lng
      $operation.destination.address =  message.placeTo.street
      $operation.destination.floor = message.placeTo.floor
      $operation.destination.apartment = message.placeTo.appartment

      $operation.changed()

    cancel : (cancel) ->
      $webSocket.send $webSocketAdapter.output.cancelOperation($operation.id)

    resetDate : ->
      $operation.date        = null
      $operation.currentDate = new Date()
      $operation.day         = $operation.currentDate
      $operation.hour        = $operation.currentDate

    reset : ->
      $operation.op = {}

      $operation.resetDate()

      #options
      $operation.comments = null
      $operation.options =
        courier         : false
        pet             : false
        airConditioning : false
        smoker          : false
        specialAsistance: false
        airport         : false
        lugage          : false
        vip             : false
        invoice         : false
      #SHOW THINGS ON ORDER FORM

      $operation.show =
        destination : false
        scheduled   : false
        passenger   : false
        extras      : false

      #DESTINATION
      $operation.destination =
        coords :
          latitude : 0
          longitude: 0
      #ORIGIN
      $operation.origin =
        coords :
          latitude : 0
          longitude: 0


      $operation.id        = null
      $operation.driver    = null
      $operation.created   = false
      $operation.searching = false
      $operation.onboard   = false
      #Marker Options
      options =
        position  : new google.maps.LatLng(0,0)
        visible   : false
        draggable : true


      listeners =
        event : "dragend"
        callback : (event) ->
          latLng = $map.getCallbackMarker(event)
          coords = $map.formatLatLng(latLng)
          $operation.setOrigin(coords.lat, coords.lng,true)



      # reset Origin marker
      $map.addOrUpdateMarker "newOperation", "origin", options, [listeners]

      # reset Destination marker
      options =
        position: $map.latLng(0,0)
        visible  : false
        draggable: true
      listeners =
        event : "dragend"
        callback : (event) ->
          latLng = $map.getCallbackMarker(event)
          coords = $map.formatLatLng(latLng)
          $operation.setDestination(coords.lat, coords.lng, true)
          $operation.changed()

      $map.addOrUpdateMarker "newOperation", "destination", options, [listeners]
      $map.geolocate $operation.setOrigin
      $map.clearMarkers "driver"
      $operation.changed()

    changed: ->
      # propagates changes to the controller, this fixes angular unbinding issues. not magic after all
      $rootScope.$broadcast('operationChanged')

    getScheduled : ->
      $api.getScheduled
        done: (adapted) ->
          $operation.scheduled = adapted

    getHistory : ->
      $api.getHistory
        done : (adapted) ->
          $operation.history = adapted

    cancelScheduled: (op) ->
      if op?
        $operation.op = op
        #MODAL TO DO
        $api.cancelScheduled
          id : op.id
          done: ->
            $operation.getScheduled()
      else
        #this is the real deal

    updateDriver : (message) ->
      $operation.driver.coords =
        latitude : message.lat
        longitude: message.lng

      options =
        position  : $map.latLng({lat:message.lat, lng:message.lng})
        doCluster : false
        icon      : "/common/assets/markers/driver_online.png"

      $map.addOrUpdateMarker "driver", "#{message.driverNumber}", options

    sendSms : (sms, modal) ->
      if modal
        $webSocket.send $webSocketAdapter.output.sendSms(sms, $operation.id)
        $modal.closeIt()
        false

      else
        $modal.open
          temp : "views/modal/booking/send-message-driver.html"
          title : "SMS"

    exportHistory : (dates, id) ->
      $modal.closeIt()
      $api.exportHistory
        data: dates
        id : id

    calculatePrice : () ->
      $api.calculatePrice
        from : $operation.origin.coords
        to   : $operation.destination.coords
        done: (adapted)->
          $operation.estimatedPrice = adapted
        fail: ->
          $operation.estimatedPrice = null


    created   : false
    searching : false
    onboard   : false

]
