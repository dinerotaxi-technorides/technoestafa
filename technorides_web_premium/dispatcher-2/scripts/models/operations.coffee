technoridesApp.factory '$operations',['$operations.adapter','$map','$webSocket','$webSocketAdapter', '$timeout', '$user', '$company', '$drivers', '$interval', '$filter', '$chat', ($api, $map, $webSocket, $webSocketAdapter, $timeout, $user, $company, $drivers, $interval, $filter,$chat) ->
  $operations =
    list : []
    scheduled : []
    parkings  :
      list : []
      parking : ""
    operation : {}
    mapInstace: {}
    detailMarkerOrig: {}
    detailMarkerDest : {}
    directionsDisplay: {}
    driverMarker : {}
    driverIndex: 0
    driverDirections : {}

    getParkings : () ->
      $operations.parkings = []

      $api.getParkings({
        done : (adapted) ->
          $operations.parkings.list = adapted
          listeners = []

          listeners.push
            event : "click"
            callback : (marker) ->

              $operations.parkings.parking = @.driver
              $api.getParkingList(
                id: $operations.parkings.parking.id
                done : (adapted) ->
                  $operations.parkings.parking.drivers = adapted
                fail : ->
                  $operations.parkings.parking.drivers = []
              )
              $(".show-parking").modal("show")
              false

          for parking in $operations.parkings.list

            options =
              position     : $map.latLng {lat:parking.lat, lng:parking.lng}
              icon         : "/common/assets/markers/parking.png"
              labelContent : parking.name
              labelClass   : "operationMarkerLabels"
              labelAnchor  : ''#new google.maps.Point(25, -5)
              driver       : parking
              doCluster    : true

            circleOptions =
              center        : $map.latLng {lat:parking.lat, lng:parking.lng}


            circleOptions.radius = $company.configuration.parking.distance.passenger
            $map.addCircle "parkingsPassenger", parking.id, circleOptions

            circleOptions.radius = $company.configuration.parking.distance.driver
            $map.addCircle "parkingsDriver", parking.id, circleOptions

            listeners.push
              event    : "mouseover"
              callback : (marker) ->
                for circleName in ["Passenger", "Driver"]
                  $map.showCircle "parkingsDriver", @.driver.id
                  $map.showCircle "parkingsPassenger", @.driver.id

            listeners.push
              event    : "mouseout"
              callback : (marker) ->
                for circleName in ["Passenger", "Driver"]
                  $map.hideCircle "parkingsDriver", @.driver.id
                  $map.hideCircle "parkingsPassenger", @.driver.id
            $map.addMarker "parkings", parking.id, options, listeners
      })

    add : (operation) ->
      $("#arrived").get(0).play()

      #check if operation is already on the list
      opExists = false
      for op in $operations.list
        if op.id is operation.id
          opExists = true
      unless opExists

        $operations.list.push operation

        options =
          position     : $map.latLng {lat:operation.coords.latitude, lng:operation.coords.longitude}
          icon         : "/common/assets/markers/operation_#{operation.status}.png"
          title        : "#{operation.id}"
          labelContent : "#{operation.id}"
          labelClass   : "operationMarkerLabels"
          labelAnchor  : ''#new google.maps.Point(25, -5)
          operation    : operation
          doCluster    : true

        # FIXME Hacer reutilizable porque también está en el mainCtrl pero con diferentes IDs
        circleOptions =
          strokeColor   : "#ffffff"
          strokeOpacity : 1
          strokeWeight  : 1
          fillOpacity   : 0.1
          fillColor     : "#ffc700"
          center        : $map.latLng {lat:operation.coords.latitude, lng:operation.coords.longitude}
          map           : null

        circleOptions.radius = $company.configuration.operations.autorecieve.distance
        $map.addCircle "operations", operation.id, circleOptions

        circleOptions.radius      = $company.configuration.operations.autorecieve.distance * (1 + $company.configuration.operations.autorecieve.relaunch)
        $map.addCircle "operations2", operation.id, circleOptions

        circleOptions.radius = $company.configuration.operations.autorecieve.distance * (1 + ($company.configuration.operations.autorecieve.relaunch * 2))
        $map.addCircle "operations3", operation.id, circleOptions

        listeners = []

        listeners.push
          event    : "mouseover"
          callback : (marker) ->
            for circleName in ["", "2", "3"]
              $map.showCircle "operations#{circleName}",operation.id

        listeners.push
          event    : "mouseout"
          callback : (marker) ->
            for circleName in ["", "2", "3"]
              $map.hideCircle "operations#{circleName}",operation.id

        if operation.status isnt "canceled" and operation.status isnt "history"
          $map.addOrUpdateMarker "operations", operation.id, options, listeners

    save : (operations) ->
      $operations.list = []

      $map.clearMarkers("operations")

      for operation in operations
        $operations.add operation

      $operations.listRemote = $operations.list

    filter: (page, searchString, searchField) ->
      $operations.list = []

      for operation in $operations.listRemote
        switch searchField
          when "driver_id"
            if operation.driver?.id?
              $operations.list.push operation if searchString is "" || operation.driver.id.match(searchString)
          else
            $operations.list.push operation

    getScheduled : (action, page) ->
      $api.getScheduled(
        page : page?=0
        action: action?=''
        rows : 3
        done: (adapted) ->
          $operations.scheduled = []
          $operations.scheduled = $operations.scheduled.concat(adapted.list)
          $operations.scheduledPages = _.range(adapted.pages)
          $operations.scheduledPage = adapted.page
          $operations.scheduledTotal = adapted.records

        )

    new : (operation) ->
      itsOn = false
      for op in $operations.list
        if op.status is "pending" or op.status is "intransaction"
          if operation.user.id is op.passenger.id
            itsOn = true
      if itsOn
        userQuestion = confirm $filter("translate")("alreadyOnOperation")
        if userQuestion

          $api.new(
            operation : operation
            done      : (adapted) ->
              $map.removeMarker "newOperation", "from"
              $map.removeMarker "newOperation", "to"
          )

      else
        $api.new(
          operation : operation
          done      : (adapted) ->
            $map.removeMarker "newOperation", "from"
            $map.removeMarker "newOperation", "to"
        )

        $operations.getScheduled()

    # OPTIONS
    finish: (operation, modal) ->
      if modal
        $webSocket.send $webSocket.webSocketAdapter.output.finishOperation($operations.operation.id)
        $operations.operation = {}
        $(".finish-operation").modal("hide")
        false
      else
        $operations.operation = operation
        $(".finish-operation").modal("show")
        false

    cancel: (operation, modal) ->
      if modal
        if $operations.operation.status is "scheduled"
          $api.cancelScheduled(
            data :
              id: $operations.operation.id
            done : (adapted) ->
              $operations.getScheduled()
              $operations.operation.status = "canceled"
              #remove marker
              # $map.removeMarker "operations", operations.operation.id
              $operations.list.push($operations.operation)
              $operations.operation = {}
          )
        else
          $webSocket.send $webSocket.webSocketAdapter.output.cancelOperation($operations.operation.id, $operations.operation.reason)



        $(".cancel-operation").modal('hide')
        false

      else
        $operations.operation = operation
        $(".cancel-operation").modal('show')
        false

    assign : (operation, modal) ->
      if modal
        $webSocket.send $webSocket.webSocketAdapter.output.assignOperation($operations.operation)
        $operations.operation = {}
        $(".assing-operation").modal('hide')
        false
      else
        if not operation.driver.id?
          operation.driver = {}
        $operations.operation = operation
        $(".assing-operation").modal('show')
        false

    # Negrion
    assign_delay_trip : (operation, modal) ->
      if modal
        $api.assignScheduled(
          data:
            id: $operations.operation.id
            driver: $operations.operation.driver.id
          done : ->
            $(".assign_delay_trip").modal('hide')
            $operations.getScheduled()
            $operations.operation = {}
        )
        false
      else
        if not operation.driver.id?
          operation.driver = {}
        $operations.operation = operation
        $(".assign_delay_trip").modal('show')
        false

    find : (operation, modal) ->
      if modal
        $webSocket.send $webSocketAdapter.output.findDriver $operations.operation.id
        $(".find-driver").modal("hide")
        false
      else
        $(".find-driver").modal("show")
        $operations.operation = operation

    setAmount : (operation, modal) ->
      if modal
        $(".set-amount").modal("hide")
        $webSocket.send $webSocketAdapter.output.setAmount $operations.operation
      else
        $(".set-amount").modal("show")
        $operations.operation = operation

    onBoard : (operation, modal) ->
      if modal
        $webSocket.send $webSocketAdapter.output.setOnBoard $operations.operation.id
        $(".set-passenger-on-board").modal("hide")
        $operations.operation = {}
      else
        $operations.operation = operation
        $(".set-passenger-on-board").modal("show")
        false

    ringPassenger : (operation, modal) ->
      if modal
        $(".ring-passenger").modal("hide")
        $webSocket.send $webSocketAdapter.output.ringPassenger $operations.operation.id
        $operations.operation = {}
      else
        $operations.operation = operation
        $(".ring-passenger").modal("show")
        false

    atTheDoor : (operation, modal)  ->
      if modal
        $(".at-the-door").modal("hide")
        $webSocket.send $webSocketAdapter.output.holdingUser $operations.operation.id
        $operations.operation = {}
      else
        $operations.operation = operation
        $(".at-the-door").modal("show")
        false

    # actualDate = new Date()
    # actualDate.setDate(actualDate.getDate()-5);

    editScheduled : (operation, modal) ->
      if modal
        id = $operations.operation.id

        origin = $map.getMarker "newOperation", "from"
        destination = $map.getMarker "newOperation", "to"

        $operations.operation.addressFrom.lat = origin.position.lat()
        $operations.operation.addressFrom.lng = origin.position.lng()
        $operations.operation.addressTo.lat  = destination.position.lat()
        $operations.operation.addressTo.lng  = destination.position.lng()
        $api.editScheduled(
          operation : $operations.operation
          done      : (adapted) ->
            # $api.cancelScheduled(
            #   data :
            #     id: id
            #   done : (adapted) ->
            #     $operations.operation = {}
            #     $operations.getScheduled()
            # )
        )



      else
        # Adapt op from socket for sending it to the api (also the form works this way), i hate you.
        adapted =
          type : "relaunch"
          id : operation.id
          addressFrom :
            address  : operation.address.from.street
            floor    : operation.address.from.floor
            apartment: operation.address.from.apartment
            lat      : operation.address.from.coords.latitude
            lng      : operation.address.from.coords.longitude
          addressTo  :
            address   : operation.address.to.street
            floor     : operation.address.to.floor
            apartment : operation.address.to.apartment
            lat       : operation.address.to.coords.latitude
            lng       : operation.address.to.coords.longitude
          options :
            messaging         : operation.options.messaging
            pet               : operation.options.pet
            airConditioner    : operation.options.airConditioning
            smoker            : operation.options.smoker
            specialAssistance : operation.options.specialAssistant
            luggage           : operation.options.luggage
            vip               : operation.options.vip
            airport           : operation.options.airport
            invoice           : operation.options.invoice
          user:
            name   : operation.passenger.name
            surname: operation.passenger.lastName
            email  : operation.passenger.email
            phone  : operation.passenger.phone
          driver   : operation.driver.id
          comments : operation.comments
          date  : operation.date
          executiontime: operation.executiontime?=$company.configuration.operations.scheduled.executiontime

        $operations.operation = adapted
        $map.showMarker "newOperation", "from"

        options =
          position: $map.latLng {lat:operation.address.from.coords.latitude, lng:operation.address.from.coords.longitude}

        $map.updateMarker "newOperation", "from", options

        if operation.address.to.coords.latitude?
          options =
            position: $map.latLng({lat:operation.address.to.coords.latitude, lng:operation.address.to.coords.longitude})

          $map.updateMarker "newOperation", "to", options

        $map.centerInMarker "newOperation", "from"

    calculatePrice : ->
      # From and to completed?
      if $operations.operation?.addressFrom?.address? and $operations.operation?.addressTo?.address?
        if $operations.operation.addressTo.address is  ""
          return;

        addressFrom = $map.getMarkerPosition "newOperation", "from"
        addressTo   = $map.getMarkerPosition "newOperation", "to"

        # From or to changed?
        if $operations.operation.lastAddressFrom != addressFrom or $operations.operation.lastAddressTo != addressTo
          $operations.operation.lastAddressFrom = addressFrom
          $operations.operation.lastAddressTo   = addressTo

          # Prevents multiple calls
          $timeout.cancel $operations.calculatePriceTimeout
          $operations.calculatePriceTimeout = $timeout(
            ->
              $api.calculatePrice(
                from        :
                  latitude  : addressFrom.lat
                  longitude : addressFrom.lng
                to          :
                  latitude  : addressTo.lat
                  longitude : addressTo.lng
                done        : (adapted) ->
                  $operations.operation.price = adapted

                  #$map.showRoute adapted.route

                  $('[data-toggle="popover"]').popover()
                  false
              )
            1000
            true
          )

    getFareCalculator : (operation) ->
      $api.getFareCalculator(
        id: operation.id
        done : (response) ->
          $timeout(
            ->
              map = new google.maps.Map document.getElementById('map_details'),
                zoom : 13
                center : $map.latLng {lat:operation.address.from.coords.latitude, lng:operation.address.from.coords.longitude}
                mapTypeId: google.maps.MapTypeId.ROADMAP
                disableDefaultUI: true

              infoWindow = ->
                new google.maps.InfoWindow
                  content: "<span>any html goes here</span>"

              addMarker = (map, title, lat, lng, icon) ->

              $operations.fareCalculatorLog =
                map : map
                from :  addMarker map, "", operation.address.from.coords.latitude, operation.address.from.coords.longitude, "/common/assets/markers/origin.png"
                to :  addMarker map, "", operation.address.to.coords.latitude, operation.address.to.coords.longitude, "/common/assets/markers/destination.png"
                log : []


              if response.events?
                oldLat = 0
                oldLng = 0

                for event in response.events
                  lat = event.location[1]
                  lng = event.location[0]

                  if lat isnt oldLat and lng isnt oldLng
                    oldLat = lat
                    oldLng = lng

                    marker = new addMarker  map, "#{event.operation_status} ID:#{event.driver_id}", lat, lng, "/common/assets/markers/driver_online.png"

                    marker.content = "<p><b>Status:</b> #{event.status}</p>
                              <p><b>Op Status:</b> #{event.operation_status}</p>
                              <p><b>Created At:</b> #{event.created_at}</p>
                              <p><b>Updated At:</b> #{event.updated_at}</p>"

                    $operations.fareCalculatorLog.log.push marker


                    marker.addListener 'click', ->
                      infowindow = new google.maps.InfoWindow
                        content: this.content
                      infowindow.open map, this
            ,
              1000
          )
      )

    show : (operation) ->
      $operations.operation = operation

      false


    relaunch : (operation, modal) ->
      if modal
        $api.relaunch(
          operation : $operations.operation
          done : ->
            $(".relaunch-operation").modal("hide")
            $operations.operation = {}

        )
      else
        $(".relaunch-operation").modal("show")
        $operations.operation = operation


    updateAddres : (coords, tochange) ->
      $map.reverseGeolocalize(coords, (address) ->

        $operations.operation["address#{tochange.charAt(0).toUpperCase()+tochange.slice(1)}"].address = "#{address}"

      )


]
