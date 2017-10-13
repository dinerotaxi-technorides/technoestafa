technoridesApp.factory '$webSocketAdapter',($settings, $user, $map, $company, $msgs, $timeout, $rootScope, $api, $message, $radio, $filter, $cookieStore, $sce, $translate) ->

  $socketHost = $settings[$settings.environment].websocket
  $apiLink    = $settings[$settings.environment].api
  $webSocketAdapter =
  # TODO MSGS ICON IMAGES
    close : ->
      code: 3000
      reason:"User Disconnected"


    debug : $settings[$settings.environment].debug


    makeSocketUrl : ->
      host   =  $socketHost + "company"
      params = "?rtaxi=" + $user.rtaxi + "&id=" + $user.id + "&token=" + $user.token + "&first_name=" + $user.firstName + "&last_name=" + $user.lastName
      address        = host + params


    output :
      findDriver : (id) ->
        opid : id
        action: "findDriver"

      sendMessage : (receiver, message) ->
        action         : "sendSms"
        email          : receiver
        SMS_content    : message
        security_email : $user.email
        rtaxi_id       : $user.rtaxi
        token          : $user.token


      soundMessage : (sound) ->
        operator   : $user.id
        driver     : ""
        rtaxi      : $user.rtaxi
        filename   : "operator#{(new Date()).getTime()}.mp3"
        action     : "AlertNewAudioBroadcast"
        bytes      : sound.substr(22, sound.length)
        security_email : $user.email
        rtaxi_id       : $user.rtaxi
        token          : $user.token

      soundMessageToDriver : (sound, id) ->
        operator   : $user.id
        driver_id  : id
        driver     : ""
        rtaxi      : $user.rtaxi
        filename   : "operator#{(new Date()).getTime()}.mp3"
        action     : "AlertNewDriverAudioBroadcast"
        bytes      : sound.substr(22, sound.length)
        security_email : $user.email
        rtaxi_id       : $user.rtaxi
        token          : $user.token

      finishOperation : (id) ->
        action         : "company/FinishTrip"
        id             : $user.id
        rtaxi          : $user.rtaxi
        opid           : id
        status         : "COMPLETED"
        security_email : $user.email
        rtaxi_id       : $user.rtaxi
        token          : $user.token


      setAmount  : ( amount, data ) ->
        action         : "company/SetAmount"
        rtaxi          : $user.rtaxi
        opid           : data.id
        amount         : amount
        security_email : $user.email
        rtaxi_id       : $user.rtaxi
        token          : $user.token


      passengerOnboard : (id) ->
        action          : "driver/InTransactionTrip"
        opid            : id
        status          : "INTRANSACTION"
        security_email  : $user.email
        rtaxi_id        : $user.rtaxi
        token           : $user.token


      holdingUser     : (id) ->
        action        : "driver/HoldingUser"
        opid          : id
        status        : "HOLDINGUSER"
        security_email: $user.email
        rtaxi_id      : $user.rtaxi
        token         : $user.token


      ringPassenger : (id) ->
        action        : "driver/RingUser"
        opid          : id
        status        : "HOLDINGUSER"
        security_email: $user.email
        rtaxi_id      : $user.rtaxi
        token         : $user.token


      assingOperation : (operation, id) ->
        action          : "company/AssignTrip"
        id              : $user.id
        rtaxi           : $user.rtaxi
        opid            : id
        driverNumber    : operation.driverId
        email           : "#{operation.driverId}@#{$user.host}"
        timeEstimated   : operation.estimatedTime
        status          : "ASSIGNEDTAXI"
        security_email  : $user.email
        rtaxi_id        : $user.rtaxi
        token           : $user.token


      confirmationMessage : (json) ->
        action: "messenger/ReadMessage"
        message_id: json.message_id


      cancelTrip : (id) ->
        action: "CancelTrip"
        id    : $user.id
        rtaxi : $user.rtaxi
        opid  : id
        status: "CANCELED"
        email : $user.email
        token : $user.token


      pullDrivers : ->
        action : "PullDrivers"
        id     : $user.id
        rtaxi  : $user.rtaxi
        token  : $user.token
        email  : $user.email


      ping : ->
        action: "Ping"
        id    : $user.id
        rtaxi : $user.rtaxi
        token : $user.token
        email : $user.email


      fakeAceptTrip : (message) ->
        action        : "driver/AcceptTrip"
        driver        : message.driver.id
        driverNumber  : message.driver.number
        firstName     : message.driver.firstName
        lastName      : message.driver.lastName
        brandCompany  : message.driver.brandCompany
        model         : message.driver.model
        plate         : message.driver.plate
        email         : message.driver.email


    input :
      assignDriverNotFound : (message) ->
        $message.error.show "#{message.email} not found"

      findingDriver : (message) ->
        for key,op of $company.operations
          if message.opid is $company.operations[op.id].id
            $company.operations[op.id].driver = "serching"

      driverNotFound : (message) ->
        for key,op of $company.operations
          if message.opid is $company.operations[op.id].id
            $company.operations[op.id].driver = "Not Found"
            $company.operations[op.id].try = message.count
            $company.operations[op.id].trylimit = message.remaning

      newServerMessage : (message) ->
        $translate(["serverRestartNotificationMessage"]).then (translations) ->
          messageText = message.text
          messageText = translations.serverRestartNotificationMessage if message.text == "restart"

          $message.warning.show messageText

      reciveAudio : (message) ->
        if message.operator isnt $user.id

          # Driver marker animation
          if message.driver?
            currentMarker = null
            for key, driver of $map.dispatcher.drivers
              if driver.id is message.driver
                  currentMarker = driver

          if $user.digitalRadio

            $("#recive").get(0).play()

            $msgs.logs.unshift(
              title : "#{message.sender_name}"
              text : "radio"
              icon : "assets/imgs/log/circle/assigned.png"
            )

            $timeout(->
              sund = null
              sound = new Audio("data:audio/mp3;base64,#{message.bytes}")

              $radio.sender = message.sender_name


              $radio.messages.push
                id : $radio.messages.length
                bytes : message.bytes
                played: false
                time : new Date()
                sender: message.sender_name
                marker: currentMarker
                play : ->
                  $radio.play @id

              unless $radio.active
                $radio.messages[$radio.messages.length-1].play()
                $radio.sender = $radio.message[$radio.messages.length-1].sender


            ,
            500)


      setAmount : (message) ->
        $company.operations[message.opid].atDoorAt = new Date()
        $company.operations[message.opid].status = "history"
        $company.operations[message.opid].shown  = false
        $company.operations[message.opid].amount = message.amount
        $msgs.logs.unshift(
          title : "Operation #{message.opid} Finished"
          text : "operation amount is #{$company.operations[message.opid].amount}"
          icon : ""
        )
        $map.dispatcher.operations[$company.operations[message.opid].marker.id].options.visible = false
        $map.dispatcher.operations[$company.operations[message.opid].marker.id].status = "finished"


      pullDrivers : (message) ->
        for driver in message.drivers
          $webSocketAdapter.input.updateDriver driver


      cancelOperation : (message) ->
        $company.operations[message.opid].atDoorAt = new Date()
        $company.operations[message.opid].status = "canceled"
        $company.operations[message.opid].shown  = false
        $msgs.logs.unshift(
          title : "Operation #{message.opid} canceled"
          text : ""
          icon : "assets/imgs/log/circle/cancelled.png"
        )

        $map.dispatcher.operations[$company.operations[message.opid].marker.id].options.visible = false
        $map.dispatcher.operations[$company.operations[message.opid].marker.id].status = "canceled"


      updateDriver : (message) ->

        if message.number?
          message.number = message.number
        else
          message.number = message.driverNumber

        # Status
        driverStatus = message.state.toLocaleLowerCase()
        driverStatus = "intravel" if driverStatus != "online" && driverStatus != "offline" && driverStatus != "disconnected"

        # New Driver?
        unless $company.drivers[message.number]?
          # Marker
          if $cookieStore.get("options-#{driverStatus}")?
            markerVisibility = $cookieStore.get("options-#{driverStatus}")
            $map.dispatcher.visibility[driverStatus] = $cookieStore.get("options-#{driverStatus}")
          else
            markerVisibility = $map.dispatcher.visibility[driverStatus]
          $map.dispatcher.drivers.push(
            id                  : "#{message.id}"
            latitude            : message.lat
            longitude           : message.lng
            status              : driverStatus
            options             :
              icon              : "/common/assets/markers/driver_#{driverStatus}.png"
              labelClass        : 'markerDriverLabels'
              labelContent      : "#{message.number}"
              labelAnchor       : "15 -5"
              labelInBackground : false
              title             : "
                <table>
                  <tr>
                    <td rowspan='10'>
                      <img src='http://dinerotaxi.com/taxiApi/displayDriverLogoByEmail?email=#{message.email}' onerror='this.src=\"/common/assets/user/profile.png\"'>
                    </td>
                  </tr>
                  <tr>
                    <th>Name:</th>
                    <td>#{message.firstName} #{message.lastName}</td>
                  </tr>
                  <tr>
                    <th>Phone:</th>
                    <td>#{message.phone}</td>
                  </tr>
                  <tr>
                    <th>Car:</th>
                    <td>#{message.brandCompany} (#{message.plate})</td>
                  </tr>
                  <tr class=>
                    <th>Version:</th>
                    <td>#{message.version}</td>
                  </tr>
                </table>"
              visible   : markerVisibility

            setImageUrl : ->
              $map.dispatcher.setImageUrl @


            email    : message.email
            name     : message.firstName
            lastname : message.lastName
            phone    : message.phone
            car      : message.brandCompany
            plate    : message.plate
            version  : message.version

          )

          $map.dispatcher.drivers[$map.dispatcher.drivers.length - 1].setImageUrl()


          # Driver (creation)
          $company.drivers[message.number] =
            status   : driverStatus
            marker   :
              id     : $map.dispatcher.drivers.length - 1
            email : message.email
            image : "#{$apiLink}taxiApi/displayDriverLogoByEmail?email=#{message.email}"
            name  : message.firstName
            surname: message.lastName
            number : message.number
            id     : message.id
        else
          # Status
          if $company.drivers[message.number].status isnt driverStatus
            $company.drivers[message.number].status = driverStatus
            $msgs.logs.unshift(
              title : "Driver #{message.number}"
              text : "has changed status to #{driverStatus.toLocaleUpperCase()}"
              icon : "http://dinerotaxi.com/taxiApi/displayDriverLogoByEmail?email=#{message.email}"
            )


          # Marker
          markerId = $company.drivers[message.number].marker.id

          # Latitude
          $map.dispatcher.drivers[markerId].latitude  = message.lat

          # Longitude
          $map.dispatcher.drivers[markerId].longitude = message.lng

          # LatLng
          $map.dispatcher.drivers[markerId].coords =
            latitude  : message.lat
            longitude : message.lng

          # New icon
          $map.dispatcher.drivers[markerId].options.icon = "/common/assets/markers/driver_#{$company.drivers[message.number].status}.png"

          # Visible?
          $map.dispatcher.drivers[markerId].options.visible = $map.dispatcher.visibility[$company.drivers[message.number].status]


      newOperation : (message) ->
        $api.send "getScheduledTrips"
        operation = message.operation
        operation.unadaptedStatus = operation.status

        # TAB Pending
        operation.status = "pending"

        # TAB history
        canceledStatuses = ["CANCELED", "CANCELEDEMP","CANCELED_TAXI", "COMPLETED", "CALIFICATED", "SETAMOUNT"]

        if canceledStatuses.indexOf(operation.unadaptedStatus) isnt -1
          operation.status = "canceled"

        # check the current operations (pull trips)
        exists = false

        for op in $company.operations
          if op.id is operation.id
            exists = true

        if !exists
          $msgs.logs.unshift(
            title : "New Operation #{operation.id} !"
            text : "location: #{operation.placeFrom.street} #{operation.placeFrom.streetNumber}"
            icon : "assets/imgs/log/circle/new_operation.png"
          )
          $map.dispatcher.markerOrigin.visible = false
          $map.dispatcher.markerOrigin.radius.visible = false

          if operation.status is "pending"
            operation.animation = google.maps.Animation.BOUNCE
          else
            operation.animation = ""

          if $cookieStore.get("options-operations")?
            markerVisibility = $cookieStore.get("options-operations")
          else
            markerVisibility = true

          if operation.status isnt "canceled"
            $map.dispatcher.operations.push(
              id                  : "#{operation.id}"
              latitude            : operation.placeFrom.lat
              longitude           : operation.placeFrom.lng
              options             :
                icon              : "/common/assets/markers/operation_#{operation.status}.png"
                labelClass        : 'opLabels'
                labelContent      : "#{operation.id}"
                labelAnchor       : "25 -5"
                labelInBackground : false
                animation         : operation.animation
                visible           : markerVisibility
              status              : operation.status
              radius              :
                visible           : false
            )


          $("#arrived").get(0).play()
          $company.operations[operation.id] =
            id                  : operation.id
            status              : operation.status
            originalStatus      : operation.unadaptedStatus
            driver              :
              id                : null
            marker              :
              id                : $map.dispatcher.operations.length - 1
            createdAt           : new Date(operation.created_at)
            comments            : operation.comments
            options             :
              invoice           : operation.options.invoice
              airport           : operation.options.airport
              vip               : operation.options.vip
              luggage           : operation.options.luggage
              specialAssistance : operation.options.specialAssistant
              airConditioner    : operation.options.airConditioning
              smoker            : operation.options.smoker
              pet               : operation.options.pet
              courier           : operation.options.messaging
            placeFrom           :
              street            : operation.placeFrom.street
              appartment        : operation.placeFrom.appartment
              number            : operation.placeFrom.streetNumber
              locality          : operation.placeFrom.locality
              country           : operation.placeFrom.country
              floor             : operation.placeFrom.floor
              latitude          : operation.placeFrom.lat
              longitude         : operation.placeFrom.lng
            placeTo             :
              street            : operation.placeTo.street
              appartment        : operation.placeTo.appartment
              number            : operation.placeTo.streetNumber
              locality          : operation.placeTo.locality
              country           : operation.placeTo.country
              floor             : operation.placeTo.floor
              latitude          : operation.placeTo.lat
              longitude         : operation.placeTo.lng
            user                :
              id                : operation.user.id
              email             : operation.user.email
              firstName         : operation.user.firstName
              lastName          : operation.user.lastName
              phone             : operation.user.phone
              isFrequent        : operation.user.isFrequent
              isCorporative     : operation.user.isCC
            shown               : false


      acceptOperation : (message) ->
        if message.message isnt 404
          $company.operations[message.opid].status         = "intransaction"
          $company.operations[message.opid].shown          = false
          $company.operations[message.opid].originalStatus = message.status
          $company.operations[message.opid].driver = {}
          $company.operations[message.opid].driver.id      = message.driverNumber
          $company.operations[message.opid].assignedAt     = message.assignedAt
          $company.operations[message.opid].estimatedTime  = message.timeEstimated * 60
          $company.operations[message.opid].estimatedTimeOriginal = $company.operations[message.opid].estimatedTime
          $company.operations[message.opid].try = null
          $company.operations[message.opid].trylimit = null
          $msgs.logs.unshift(
            title : "Operation #{message.opid} Asigned"
            text : "Driver assigned: #{message.driverNumber}"
            icon : "assets/imgs/log/circle/assigned.png"
          )

          if $cookieStore.get("options-operations")?
            markerVisibility = $cookieStore.get("options-operations")
          else
            markerVisibility = true

          $map.dispatcher.operations[$company.operations[message.opid].marker.id].options.icon = "/common/assets/markers/operation_intransaction.png"
          $map.dispatcher.operations[$company.operations[message.opid].marker.id].status = "intransaction"
          $map.dispatcher.operations[$company.operations[message.opid].marker.id].radius.visible = false
          $map.dispatcher.operations[$company.operations[message.opid].marker.id].options.animation = ""
          $map.dispatcher.operations[$company.operations[message.opid].marker.id].options.visible = markerVisibility

          driver = $company.drivers[message.driverNumber]

          if driver?
            marker = $map.dispatcher.drivers[driver.marker.id]
            if marker?
              $webSocketAdapter.input.updateDriver(
                number: driver.number
                email : driver.email
                lat   : marker.latitude
                lng   : marker.longitude
                state : "intravel"
                status: "intravel"
              )
        else
          $message.error.show "driverOcupied"

      finishOperation : (message) ->
        $company.operations[message.opid].atDoorAt = new Date()
        $company.operations[message.opid].status = "history"
        $company.operations[message.opid].shown  = false
        $msgs.logs.unshift(
          title : "Operation #{message.opid} finished"
          text : "operation has finished"
          icon : "assets/imgs/log/circle/canceled.png"
        )
        $map.dispatcher.operations[$company.operations[message.opid].marker.id].options.visible = false
        $map.dispatcher.operations[$company.operations[message.opid].marker.id].status = "finished"
        $map.dispatcher.operations[$company.operations[message.opid].marker.id].radius.visible = false
        $map.dispatcher.operations[$company.operations[message.opid].marker.id].options.animation = ""


      holdingUser : (message) ->
        $company.operations[message.opid].atDoorAt = new Date()
        $company.operations[message.opid].shown    = false


      getOperations : (message) ->
        for operation, index in message.operations
          operation.unadaptedStatus = operation.status
          # TAB Pending
          operation.status = "pending"
          operation.radius =
            visible : true
          driver = {}

          # TAB In Transaction
          if operation.driver?
            operation.status = "intransaction"
            driver =
              id: operation.driver.number
            operation.radius.visible = false

            # TAB history
            if op.unadaptedStatus.indexOf("CANCEL") isnt -1
              op.status = "canceled"
              operation.radius.visible = false

            if op.unadaptedStatus is "COMPLETED" or op.unadaptedStatus is "CALIFICATED" or op.unadaptedStatus is "SETAMOUNT"

              op.status = "history"
              operation.radius.visible = false

            if operation.status is ""
              operation.status = "scheduled"
              operation.radius.visible = false

          if operation.status isnt "canceled" && typeof operation.unadaptedStatus isnt "undefined"

            if operation.status is "pending"
              operation.animation = google.maps.Animation.BOUNCE
            else
              operation.animation = ""

            if $cookieStore.get("options-operations")?
              markerVisibility = $cookieStore.get("options-operations")
              if $cookieStore.get("options-operations") isnt $map.dispatcher.visibility.operations
                $map.dispatcher.toggleMarkers("operations")

            else
              markerVisibility = true


            $map.dispatcher.operations.push
              id                  : "#{operation.id}"
              latitude            : operation.placeFrom.lat
              longitude           : operation.placeFrom.lng
              options             :
                icon              : "/common/assets/markers/operation_#{operation.status}.png"
                labelClass        : 'opLabels'
                labelContent      : "#{operation.id}"
                labelAnchor       : "25 -5"
                labelInBackground : false
                animation         : ""#operation.animation
                visible           : markerVisibility
              status              : operation.status
              radius              :
                visible           : false


          if typeof operation.unadaptedStatus isnt "undefined"
            # Calculating estimated time
            assignedAt     = new Date operation.assigned_at
            estimatedTime  = new Date(assignedAt.getTime() + (operation.estimated_time * 60000))

            estimatedTimeDiff = 0
            atDoorAt          = null

            # Holding passenger
            if operation.at_the_door_at? and (operation.at_the_door_at isnt operation.assigned_at) and (operation.unadaptedStatus isnt "ASSIGNEDTAXI")
              atDoorAt          = new Date operation.at_the_door_at
              estimatedTimeDiff = estimatedTime.getTime() - atDoorAt.getTime()
            # In transaction
            else
              estimatedTimeDiff = estimatedTime - (new Date()).getTime()

            estimatedTimeDiff = Math.floor(estimatedTimeDiff / 1000)


            $company.operations[operation.id] =
              id                    : operation.id
              status                : operation.status
              originalStatus        : operation.unadaptedStatus
              driver                : driver
              comments              : operation.comments
              marker                :
                id                  : $map.dispatcher.operations.length - 1
              createdAt             : new Date(operation.created_at)
              assignedAt            : assignedAt?
              atDoorAt              : atDoorAt
              estimatedTime         : estimatedTimeDiff
              estimatedTimeOriginal : operation.estimated_time * 60
              options               :
                invoice             : operation.options.invoice
                airport             : operation.options.airport
                vip                 : operation.options.vip
                luggage             : operation.options.luggage
                specialAssistance   : operation.options.specialAssistant
                airConditioner      : operation.options.airConditioning
                smoker              : operation.options.smoker
                pet                 : operation.options.pet
                courier             : operation.options.messaging
              placeFrom             :
                street              : operation.placeFrom.street
                appartment          : operation.placeFrom.appartment
                number              : operation.placeFrom.streetNumber
                locality            : operation.placeFrom.locality
                country             : operation.placeFrom.country
                floor               : operation.placeFrom.floor
                latitude            : operation.placeFrom.lat
                longitude           : operation.placeFrom.lng
              placeTo               :
                street              : operation.placeTo.street
                appartment          : operation.placeTo.appartment
                number              : operation.placeTo.streetNumber
                locality            : operation.placeTo.locality
                country             : operation.placeTo.country
                floor               : operation.placeTo.floor
                latitude            : operation.placeTo.lat
                longitude           : operation.placeTo.lng
              user                  :
                id                  : operation.user.id
                email               : operation.user.email
                firstName           : operation.user.firstName
                lastName            : operation.user.lastName
                phone               : operation.user.phone
                isFrequent          : operation.user.isFrequent
                isCorporative       : operation.user.isCC
              shown                 : false
