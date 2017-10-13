technoridesApp.factory '$apiAdapter',['$settings', '$user', '$company','$sugestions','$map','$filter','$price',($settings, $user, $company,$sugestions,$map, $filter, $price) ->

  # Api and new api urls
  $apiLink                = $settings[$settings.environment].api
  $newApiLink             = $settings[$settings.environment].newApi
  $auth       = $settings[$settings.environment].websocket.replace "wss", "https"

  $apiAdapter =

    isSuccessStatus : (key, status) ->
      $codes =
        success:
          login                   : 100
          getCounters             : 100
          cancelScheduledOperation: 100
          createOperation         : 100
          priceCalculator         : 200
          updateSugestions        : 100
          updateFavoritesOrigin   : 100
          createScheduledOperation: 100
          sendEmail               : 100
          getParkings             : 100
          getParkingPositions     : 100
          getZones                : 100
          getCompanyConfiguration : 100
          getOperationsByStatus   : 100
          getOperationsByDevice   : 100
          getOperationsEarnings   : 100
          getOperationsByDate     : 100
          getPassengers           : 100
          assignScheduledOperation: 100
          operationFlow           : 100
          editScheduledOperation  : 100
      $codes.success[key] == status


    url :
      operationFlow            : "#{$newApiLink}operations/flows/"
      login                    : "#{$apiLink}technoRidesLoginApi/login"
      getCounters              : "#{$apiLink}technoRidesUsersApi/jq_monitor_counter"
      getScheduledTrips        : "#{$apiLink}technoRidesDelayOperationsApi/jq_delay_operation_by_company"
      getOperationsByStatus    : "#{$newApiLink}operations/status"
      getOperationsByDevice    : "#{$newApiLink}operations/devices"
      getOperationsEarnings    : "#{$newApiLink}operations/earnings"
      getOperationsByDate      : "#{$newApiLink}operations/weeklyDigest"
      getPassengers            : "#{$newApiLink}passengers/amount"
      cancelScheduledOperation : "#{$apiLink}technoRidesDelayOperationsApi/delete_trip"
      assignScheduledOperation : "#{$apiLink}technoRidesDelayOperationsApi/edit_trip"
      createOperation          : "#{$apiLink}technoRidesOperationsApi/create_trip"
      updateSugestions         : "#{$apiLink}technoRidesUsersApi/jq_get_user_by"
      updateFavoritesOrigin    : "#{$apiLink}technoRidesOperationsApi/jq_operation_history_by_user"
      createScheduledOperation : "#{$apiLink}technoRidesDelayOperationsApi/create_trip"
      sendEmail                : "#{$apiLink}technoRidesEmailApi/send_mail?"
      priceCalculator          : "#{$newApiLink}costCalculator/"
      getParkings              : "#{$apiLink}technoRidesParkingApi/jq_parking"
      getParkingPositions      : "#{$newApiLink}parking_queue/"
      getZones                 : "#{$apiLink}technoRidesZoneApi/jq_zone"
      getCompanyConfiguration  : "#{$apiLink}technoRidesConfigurationAppApi/jq_config"
      editScheduledOperation   : "#{$apiLink}technoRidesDelayOperationsApi/edit_trip"
      sslCert                  : $auth


    input :
      priceCalculator : (response) ->
        if not response.json.is_zone
          $zoneFrom = {}
          $zoneTo   = {}
          $km        = response.json.km
        else
          $zoneFrom = response.json.zone_from
          $zoneTo   = response.json.zone_to
          $km        = null
        amount   : response.json.amount?=undefined
        isZone   : response.json.is_zone
        km       : $km
        zoneFrom : $zoneFrom
        zoneTo   : $zoneTo

      operationFlow: (response) ->
        sentTo = []
        for sent in response.flow.sent_to
          sentTo.push
            driverEmail : sent?.driver_email
            at : sent?.at_time

        flow =
          operationId : response.flow.operation_id
          sentTo : sentTo
          assignedTo:
            dirver : response.flow.assigned_to?.driver_email
            at : response.flow.assigned_to?.at_time
          acceptedBy:
            driver : response.flow.accepted_by?.driver_email
            at :  response.flow.accepted_by?.at_time
          estimatedTime : response.flow.estimated_time_to_door
          timeAtDoor : response.flow.at_the_door_at
          ringsUser :  response.flow.ring_user_at
          onBoardAt : response.flow.on_board_at
          canceledByUser : response.flow.canceled_by_user_at
          canceledByDriver : response.flow.canceled_by_driver_at
          canceledByOperator :
            operator : response.flow.canceled_by_operator?.operator
            at : response.flow.canceled_by_operator?.at_time
          finishedByUser : response.flow.finished_by_user_at
          finishdByDriver : response.flow.finished_by_driver_at
          finishedByOperator :
            operator : response.flow.finished_by_operator?.operator
            at : response.flow.finished_by_operator?.at_time
          updatedAt : response.flow.updated_at


      getCompanyConfiguration : (response) ->
        $company.config =
          operations :
            autorecieve :
              distance         : response.distanceSearchTrip*1000
              relaunch         : response.percentageSearchRatio
            scheduled :
              executiontime : response.timeDelayTrip
          parking :
            enabled : response.parking
            distance :
              driver : response.parkingDistanceDriver
              passenger : response.parkingDistanceTrip
          zones :
            enabled : response.hasZoneActive
        $company.config.operations.autorecieve.relaunchDistance = $company.config.operations.autorecieve.distance * $company.config.operations.autorecieve.relaunch


      getParkings : (response) ->
        for parking in $map.dispatcher.parkings
          $map.dispatcher.parkings.pop()

        for parking in response.rows
          $map.dispatcher.parkings.push(
            id : parking.id
            latitude : parking.lat
            longitude : parking.lng
            center :
              latitude : parking.lat
              longitude : parking.lng
            options :
              draggable: false
              icon : "/common/assets/markers/parking.png"
              visible: false
              labelContent : "#{parking.name}"
              labelClass: 'markerLabels'
              labelAnchor: "10 0"
            radius:
              visible: false

            name : parking.name
            )

      getParkingPositions : (response) ->


      getZones : (response) ->
        zones = []

        # Delete old data
        for zone in $map.dispatcher.zones
          $map.dispatcher.zones.pop()

        for zone in response.result
          coords = zone.coordinates.split("|")
          coordinates = []

          for cord in coords
            latlng = cord.split(",")
            cod =
              latitude : Number latlng[0]
              longitude: Number latlng[1]
            coordinates.push(cod)
          r = Math.floor(Math.random() * 256)
          g = Math.floor(Math.random() * 256)
          b = Math.floor(Math.random() * 256)

          $map.dispatcher.zones.push(
            id      : zone.id
            path    : coordinates
            name    : zone.name
            visible : false
            color   :
              color   : "rgb(#{r},#{g},#{b})"
              opacity : 0.2
            stroke  :
              color : "rgb(#{r},#{g},#{b})"
              weight: 1
              opacity: 0.3
            )


      login : (response) ->
        role = "default"

        switch response.roles

          when 'ROLE_OPERATOR'
            role = "operator"

          when 'ROLE_MONITOR'
            role = "monitor"

          when 'ROLE_TELEPHONIST'
            role = "calltaker"

        token       : response.token
        lang        : response.lang
        latitude    : parseFloat(response.latitude)
        longitude   : parseFloat(response.longitude)
        country     : response.country
        timeZone    : response.time_zone
        adminCode   : response.admin_code
        countryCode : response.country_code
        id          : response.id
        firstName   : response.first_name
        lastName    : response.last_name
        company     : response.company
        rtaxi       : response.rtaxi
        email       : response.email
        host        : response.host
        role        : role
        isLogged    : true


      getCounters: (response) ->
        operations  : response.operations
        passengers  : response.customers


      updateSugestions : (response) ->
        $sugestions.options = response.rows


      updateFavoritesOrigin : (response) ->
        $sugestions.favoritesFrom = []

        for favorite in response.result
          $sugestions.favoritesFrom.push(
            id            : favorite.id
            street        : favorite.street
            number        : favorite.street_number
            city          : favorite.locality
            country       : favorite.country
            countryCode   : favorite.country_code
            floor         : favorite.floor
            department    : favorite.department
            latitude      : favorite.lat
            longitude     : favorite.lng
            comments      : favorite.comments
            )


      getScheduledTrips: (response) ->
        for key,op of $company.operations
          if op.status is "scheduled"
            delete $company.operations[op.id]
        for operation in response.result
          $company.operations[operation.id] =
            id             : operation.id
            status         : "scheduled"
            originalStatus : "scheduled"
            driver         :
              id           : operation.driver_number
            createdAt      : ""
            date           : new Date(operation.date)
            comments       : operation.comments
            options        :
              invoice           : operation.options.invoice
              airport           : operation.options.airport
              vip               : operation.options.vip
              luggage           : operation.options.luggage
              specialAssistance : operation.options.specialAssistant
              airConditioner    : operation.options.airConditioning
              smoker            : operation.options.smoker
              pet               : operation.options.pet
              courier           : operation.options.messaging
            placeFrom      :
              street        : operation.placeFrom.street
              appartment    : operation.placeFrom.appartment
              number        : operation.placeFrom.streetNumber
              locality      : operation.placeFrom.locality
              country       : operation.placeFrom.country
              floor         : operation.placeFrom.floor
              latitude      : operation.placeFrom.lat
              longitude     : operation.placeFrom.lng
            placeTo       :
              street        : operation.placeTo.street
              appartment    : operation.placeTo.appartment
              number        : operation.placeTo.streetNumber
              locality      : operation.placeTo.locality
              country       : operation.placeTo.country
              floor         : operation.placeTo.floor
              latitude      : operation.placeTo.lat
              longitude     : operation.placeTo.lng
            user          :
              id            : operation.user.id
              email         : operation.user.email
              firstName     : operation.user.firstName
              lastName      : operation.user.lastName
              phone         : operation.user.phone
              isFrequent    : operation.user.isFrequent
              isCorporative : operation.user.isCC
            shown: $company.operations[operation.id]?.shown


      getOperationsByStatus: (response) ->
        json =
          finished     : parseInt(response.operations["FINISHED"])
          canceled     : parseInt(response.operations["CANCELED"])
          inTransaction: parseInt(response.operations["IN_TRANSACTION"])

        json.total = json.finished + json.canceled + json.inTransaction

        json


      getOperationsByDevice: (response) ->
        web    : parseInt(response.operations["WEB"])
        android: parseInt(response.operations["ANDROID"])
        others : parseInt(response.operations["OTHER"] + 1)


      getOperationsEarnings: (response) ->
        parseInt(response.amount)


      getOperationsByDate: (response) ->
        json =
          finished: []
          canceled: []
          max     : 0

        for key, operations of response.operations
          date = new Date(
            (new Date()).setDate((new Date()).getDate() - (7 - parseInt(key)))
          )

          formatedDate = "#{date.getDate()}/#{date.getMonth() + 1}"
          json.finished[key] = [
            formatedDate
            operations["FINISHED"]
          ]

          json.canceled[key] = [
            formatedDate
            operations["CANCELED"]
          ]

          json.max = Math.max(json.max, operations["FINISHED"], operations["CANCELED"])

        json


      getPassengers: (response) ->
        parseInt(response.amount)


    output :
      sslCert : ->

      editScheduledOperation : (op) ->
        id              : op.id
        execution_date  : $filter('date')(new Date(op.date),'yyyy-MM-dd HH:mm:ss')
        driver_number   : op.driver.id?=""
        token           : $user.token


      operationFlow : (id) ->
        url = "#{id}?token=#{encodeURIComponent($user.token)}"


      getParkings : ->
        token : $user.token


      getParkingPositions : (parkingAttributes) ->
        "#{parkingAttributes.id}?token=#{encodeURIComponent($user.token)}"


      getZones : ->
        token : $user.token


      login : (credentials) ->
        json :
          email : credentials.user
          password: credentials.password


      getCounters: ->
        token: $user.token


      getScheduledTrips : ->
        token : $user.token


      updateFavoritesOrigin : (id) ->
        user_id : id
        token   : $user.token
        max     : 3


      getOperationsByStatus : ->
        token     : $user.token
        start_date: (
          new Date(
            (new Date()).setDate((new Date()).getDate() - $settings[$settings.environment].statistics.days)
          )
        ).toISOString()
        end_date  : (new Date()).toISOString()


      getOperationsByDevice : ->
        token     : $user.token
        start_date: (
          new Date(
            (new Date()).setDate((new Date()).getDate() - $settings[$settings.environment].statistics.days)
          )
        ).toISOString()
        end_date: (new Date()).toISOString()


      getOperationsEarnings : ->
        token     : $user.token
        start_date: (
          new Date(
            (new Date()).setDate((new Date()).getDate() - $settings[$settings.environment].statistics.days)
          )
        ).toISOString()
        end_date  : (new Date()).toISOString()


      getOperationsByDate : ->
        token     : $user.token


      getPassengers : ->
        token     : $user.token
        start_date: (
          new Date(
            (new Date()).setDate((new Date()).getDate() - $settings[$settings.environment].statistics.days)
          )
        ).toISOString()
        end_date  : (new Date()).toISOString()


      cancelScheduledOperation : (opid) ->
        token: $user.token
        id: opid


      assignScheduledOperation : (op) ->
        id : op.id
        token : $user.token
        driver_number : op.driver


      updateSugestions : (data) ->
        type : data.type
        term : data.text
        token : $user.token


      relaunchOperation: (operation) ->
        unless operation.options?
          operation.options = {}

        unless operation.placeTo?
          operationAttributes.placeTo =
            address   : ""
            number    : ""
            floor     : ""
            apartment : ""

        unless operation.driver?
          operation.driver = null

        type       : "email"
        is_web_user: true
        token      : $user.token
        rtaxi      : $user.rtaxi
        device     :
          userType : "WEB"
          deviceKey: "Sarasa"
        comments   : operation.comments
        user       :
          email     : operation.user.email
          phone     : operation.user.phone
          name      : operation.user.firstName
          surname   : operation.user.lastName
        addressFrom :
          country   : $user.country
          ccode     : $user.countryCode
          city      : $user.adminCode
          address    : operation.placeFrom.street
          number    : operation.placeFrom.number
          floor     : operation.placeFrom.floor
          apartment : operation.placeFrom.appartment
          lat       : operation.placeFrom.latitude.toString()
          lng       : operation.placeFrom.longitude.toString()
        addressTo   :
          country   : $user.country
          ccode     : $user.countryCode
          city      : $user.adminCode
          address    : operation.placeTo.street
          number    : operation.placeTo.number
          floor     : operation.placeTo.floor
          apartment : operation.placeTo.appartment
          lat       : operation.placeTo.latitude.toString()
          lng       : operation.placeTo.longitude.toString()
        options     :
          messaging       : operation.options.messaging
          pet             : operation.options.pet
          airConditioner : operation.options.airConditioner
          smoker          : operation.options.smoker
          specialAssistance: operation.options.specialAssistance
          luggage         : operation.options.luggage
          vip             : operation.options.vip
          airport         : operation.options.airport
          invoice         : operation.options.invoice
        driver_number     : operation.driver


      createOperation: (operationAttributes) ->
        if typeof operationAttributes.options is "undefined"
          operationAttributes.options = {}

        if !operationAttributes.addressFrom.number?
          operationAttributes.addressFrom.number = ""

        unless operationAttributes.addressTo?
          operationAttributes.addressTo =
            address   : ""
            number    : ""
            floor     : ""
            apartment : ""

        if !operationAttributes.addressTo.number?
          operationAttributes.addressTo.number = ""

        unless operationAttributes.driver?
          operationAttributes.driver = null

        if operationAttributes.type?
        else
          operationAttributes.addressFrom.lat = $map.dispatcher.markerOrigin.coords.latitude
          operationAttributes.addressFrom.lng = $map.dispatcher.markerOrigin.coords.longitude
          operationAttributes.addressTo.lat = $map.dispatcher.markerDest.coords.latitude
          operationAttributes.addressTo.lng = $map.dispatcher.markerDest.coords.longitude

        unless operationAttributes.user.email? && operationAttributes.user.email.match(/@/)
          operationAttributes.user.email = "#{operationAttributes.user.phone}@#{$user.host}"

        unless operationAttributes.user.name?
          operationAttributes.user.name = "-"

        unless operationAttributes.user.surname?
          operationAttributes.user.surname = "-"


        amount     : $price.object.amount?=null
        type       : "email"
        is_web_user: true
        token      : $user.token
        rtaxi      : $user.rtaxi
        device     :
          userType : "WEB"
          deviceKey: "Sarasa"
        comments   : operationAttributes.comments
        user       :
          email     : operationAttributes.user.email
          phone     : operationAttributes.user.phone
          first_name: operationAttributes.user.name
          last_name : operationAttributes.user.surname
        addressFrom :
          country   : $user.country
          ccode     : $user.countryCode
          city      : $user.adminCode
          street    : operationAttributes.addressFrom.address
          number    : operationAttributes.addressFrom.number
          floor     : operationAttributes.addressFrom.floor
          apartment : operationAttributes.addressFrom.apartment
          lat       : operationAttributes.addressFrom.lat.toString()
          lng       : operationAttributes.addressFrom.lng.toString()
        addressTo   :
          country   : $user.country
          ccode     : $user.countryCode
          city      : $user.adminCode
          street    : operationAttributes.addressTo.address
          number    : operationAttributes.addressTo.number
          floor     : operationAttributes.addressTo.floor
          apartment : operationAttributes.addressTo.apartment
          lat       : operationAttributes.addressTo.lat.toString()
          lng       : operationAttributes.addressTo.lng.toString()
        options     :
          messaging       : operationAttributes.options.messaging
          pet             : operationAttributes.options.pet
          airConditioning : operationAttributes.options.airConditioner
          smoker          : operationAttributes.options.smoker
          specialAssistant: operationAttributes.options.specialAssistance
          luggage         : operationAttributes.options.luggage
          vip             : operationAttributes.options.vip
          airport         : operationAttributes.options.airport
          invoice         : operationAttributes.options.invoice
        driver_number     : operationAttributes.driver


      createScheduledOperation : (operationAttributes) ->

        $map.dispatcher.markerOrigin.radius.visible = false

        unless operationAttributes.options?
          operationAttributes.options = {}

        if !operationAttributes.addressFrom.number?
          operationAttributes.addressFrom.number = ""

        unless operationAttributes.addressTo?
          operationAttributes.addressTo =
            address   : ""
            number    : ""
            floor     : ""
            apartment : ""

        if !operationAttributes.addressTo.number?
          operationAttributes.addressTo.number = ""

        unless operationAttributes.driver?
          operationAttributes.driver = null

        type          : "email"
        is_web_user   : true
        token         : $user.token
        device        :
          userType:  "WEB"
          deviceKey: navigator.userAgent
        comments      : operationAttributes.comments
        user:
          email     : operationAttributes.user.email
          phone     : operationAttributes.user.phone
          first_name: operationAttributes.user.name
          last_name : operationAttributes.user.surname
        addressFrom:
          country     : $user.country
          ccode       : $user.countryCode
          city        : $user.adminCode
          street      : operationAttributes.addressFrom.address
          number      : operationAttributes.addressFrom.number
          floor       : operationAttributes.addressFrom.floor
          apartment   : operationAttributes.addressFrom.department
          lat         : $map.dispatcher.markerOrigin.coords.latitude.toString()
          lng         : $map.dispatcher.markerOrigin.coords.longitude.toString()
        addressTo:
          country     : $user.country
          ccode       : $user.countryCode
          city        : $user.adminCode
          street      : operationAttributes.addressTo.address
          number      : operationAttributes.addressTo.number
          floor       : operationAttributes.addressTo.floor
          apartment   : operationAttributes.addressTo.department
          lat         : $map.dispatcher.markerDest.coords.latitude.toString()
          lng         : $map.dispatcher.markerDest.coords.longitude.toString()
        options:
          messaging       : operationAttributes.options.messaging
          pet             : operationAttributes.options.pet
          airConditioning : operationAttributes.options.airConditioner
          smoker          : operationAttributes.options.smoker
          specialAssistant: operationAttributes.options.specialAssistance
          luggage         : operationAttributes.options.luggage
          vip             : operationAttributes.options.vip
          airport         : operationAttributes.options.airport
          invoice         : operationAttributes.options.invoice
        executionTime : $filter('date')(operationAttributes.date,'yyyy-MM-dd HH:mm:ss a')
        driver_number : operationAttributes.driver


      sendEmail: (emailAttributes) ->
        emailAttributes


      priceCalculator : ->
        url = "#{encodeURIComponent($user.token)}/#{encodeURIComponent($map.dispatcher.markerOrigin.coords.latitude)},#{encodeURIComponent($map.dispatcher.markerOrigin.coords.longitude)}/#{+encodeURIComponent($map.dispatcher.markerDest.coords.latitude)},#{encodeURIComponent($map.dispatcher.markerDest.coords.longitude)}"

      getCompanyConfiguration : ->
        token : $user.token


]

