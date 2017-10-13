technoridesApp.factory '$webSocketAdapter', ($webSocket, $settings, $user, $timeout, $filter, $sce) ->
  $socketHost = $settings[$settings.environment].websocket
  $webSocketAdapter =
  # TODO MSGS ICON IMAGES
    close : ->
      code: 3000
      reason:"User Disconnected"


    debug : $settings[$settings.environment].debug


    makeSocketUrl : ->
      host   = $socketHost + "company"
      params = "?rtaxi=" + $user.rtaxi + "&id=" + $user.id + "&token=" + $user.token + "&first_name=" + $user.firstName + "&last_name=" + $user.lastName
      address        = host + params

    input:

      newChatMessage : (message) ->
        adapted =
          senderId   : message.sender_id
          senderName : message.sender_name
          createdAt  : message.created_at
          messageType: message.type_message
          message    : if message.type_message is 0 then $sce.trustAsResourceUrl("data:audio/mpeg;base64,#{message.bytes}") else message.bytes
          downloaded : true
          irc        : message.type is 1

        adapted

      reciveAudio : (message) ->
        # Avoid self sending messages
        if message.operator isnt $user.id
          # has purchased digital radio?
          if $user.digitalRadio
            message
        else
          false

      # get operations (not the scheduled)
      getOperations : (message) ->
        adapted = []
        for key, op of message.operations
          op.unadaptedStatus = op.status


          if op.status?
            # Calculating estimated time
            assignedAt        = new Date op.assigned_at
            estimatedTime     = new Date(assignedAt.getTime() + (op.estimated_time * 60000))

            estimatedTimeDiff = 0
            atDoorAt          = null

            # Holding passenger
            if op.at_the_door_at? and (op.at_the_door_at isnt op.assigned_at) and (op.unadaptedStatus isnt "ASSIGNEDTAXI")
              atDoorAt          = new Date op.at_the_door_at
              estimatedTimeDiff = estimatedTime.getTime() - atDoorAt.getTime()
            # In transaction
            else
              estimatedTimeDiff = estimatedTime - (new Date()).getTime()

            estimatedTimeDiff = Math.floor(estimatedTimeDiff / 1000)


            op.status = "pending"
            op.radius =
              visible : true

            # TAB In Transaction
            if op.driver? and op.driver.id?
              if op.unadaptedStatus is "INTRANSACTION"
                op.user.onboard = true
              else
                op.user.onboard = false
              op.status = "intransaction"
            else
              op.driver = false


            if op.unadaptedStatus.indexOf("CANCEL") isnt -1
              op.status = "canceled"
            if op.unadaptedStatus is "COMPLETED" or op.unadaptedStatus is "CALIFICATED" or op.unadaptedStatus is "SETAMOUNT"
              op.status = "history"


            adapted.push
              status          : op.status
              originalStatus  : op.unadaptedStatus
              id              : op.id
              amount          : op.amount
              comments        : op.comments
              created         : new Date(op.created_at)
              assinged        : assignedAt?
              atDoorAt        : atDoorAt
              estimatedTime         : estimatedTimeDiff
              estimatedTimeOriginal : op.estimated_time * 60
              device          : op.device
              driverId        : op.driver?.number
              driver          :
                car           :
                  brand       : op.driver?.brandCompany
                  plate       : op.driver?.plate
                id            : op.driver?.number
                name          : op.driver?.firstName
                lastName      : op.driver?.lastName
                coords        :
                  latitude    : op.driver?.lat
                  longitude   : op.driver?.lng
                phone         : op.driver?.phone
                version       : op.driver?.version
                email         : op.driver?.email
              estimated       : op.estimated_time
              findingDriver   : op.finding_driver
              isWeb           : op.is_web_user
              coords          :
                latitude      : op.lat
                longitude     : op.lng
              options         : op.options
              address         :
                from          :
                  country     : op.placeFrom.country
                  flor        : op.placeFrom.floor
                  coords      :
                    latitude  : op.placeFrom.lat
                    longitude : op.placeFrom.lng
                  locality    : op.placeFrom.locality
                  street      : op.placeFrom.street
                  number      : op.placeFrom.streetNumber
                to            :
                  country     : op.placeTo.country
                  flor        : op.placeTo.floor
                  coords      :
                    latitude  : op.placeTo.lat
                    longitude : op.placeTo.lng
                  locality    : op.placeTo.locality
                  street      : op.placeTo.street
                  number      : op.placeTo.streetNumber
              passenger       :
                company       : op.user.companyName
                email         : op.user.email
                name          : op.user.firstName
                id            : op.user.id
                corporate     : op.user.isCC
                frequent      : op.user.isFrequent
                lastName      : op.user.lastName
                phone         : op.user.phone
                onboard       : op.user.onboard?=false
        adapted
        
      updateDriver : (driver) ->
        driverStatus  = driver.state.toLocaleLowerCase()
        driverStatus  = "intravel" if driverStatus not in ["online", "offline", "disconnected"]
        driver.status = driverStatus
        driver.number = driver.driverNumber
        driver.updated = if driver.updated_at? then new Date driver.updated_at else new Date()

        driver

      newOperation : (message) ->
        message.operation.status = "pending"
        message.operation.radius =
          visible : true

        # TAB In Transaction
        if message.operation.driver? and message.operation.driver.id?
          message.operation.status = "intransaction"
        else
          message.operation.driver = false

        adapted =
          radius    : message.operation.radius
          status    : message.operation.status
          id        : message.operation.id
          amount    : message.operation.amount
          comments  : message.operation.comments
          created   : new Date(message.operation.created_at)
          device    : message.operation.device
          driver    :
            car :
              brand : message.operation.driver?.brandCompany
              plate : message.operation.driver?.plate
            number  : message.operation.driver?.driverNumber
            name    : message.operation.driver?.firstName
            lastName: message.operation.driver?.lastName
            coords:
              latitude: message.operation.driver?.lat
              longitude: message.operation.driver?.lng
            phone   : message.operation.driver?.phone
            version : message.operation.driver?.version
            id      : message.operation.driver?.id
            email   : message.operation.driver?.email
          estimated     : message.operation.estimated_time
          findingDriver : message.operation.finding_driver
          isWeb     : message.operation.is_web_user
          coords  :
            latitude : message.operation.lat
            longitude: message.operation.lng
          options : message.operation.options
          address :
            from :
              country     : message.operation.placeFrom.country
              flor        : message.operation.placeFrom.floor
              coords:
                latitude    : message.operation.placeFrom.lat
                longitude   : message.operation.placeFrom.lng
              locality    : message.operation.placeFrom.locality
              street      : message.operation.placeFrom.street
              number      : message.operation.placeFrom.streetNumber
            to :
              country     : message.operation.placeTo.country
              flor        : message.operation.placeTo.floor
              coords:
                latitude    : message.operation.placeTo.lat
                longitude   : message.operation.placeTo.lng
              locality    : message.operation.placeTo.locality
              street      : message.operation.placeTo.street
              number      : message.operation.placeTo.streetNumber
          passenger :
            company   : message.operation.user.companyName
            email     : message.operation.user.email
            name      : message.operation.user.firstName
            id        : message.operation.user.id
            corporate : message.operation.user.isCC
            frequent  : message.operation.user.isFrequent
            lastName  : message.operation.user.lastName
            phone     : message.operation.user.phone

      pullingTrips : (driver) ->
        $webSocketAdapter.input.updateDriver driver

    output:

      soundMessage : (sound, id) ->
        operator   : $user.id
        driver_id  : id
        driver     : ""
        rtaxi      : $user.rtaxi
        filename   : "operator#{(new Date()).getTime()}.mp3"
        action     : if id? then "AlertNewDriverAudioBroadcast" else "AlertNewAudioBroadcast"
        bytes      : sound.substr(22, sound.length)
        security_email : $user.email
        rtaxi_id       : $user.rtaxi
        token          : $user.token

      sendChat  : (message, toUser, type, typeMessage) ->
        action             : "SendMessage"
        sender_id          : $user.id
        type               : type
        receiver_id        : toUser
        type_user_receiver : 1 #if toOperator then 0 else 1
        type_user_sender   : 0
        rtaxi_id           : $user.rtaxi
        filename           : "#{$user.id}_#{new Date().getTime()}.mp3"
        bytes              : message
        type_message       : typeMessage
        token              : $user.token


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

      setOnBoard : (id) ->
        action          : "driver/InTransactionTrip"
        opid            : id
        status          : "INTRANSACTION"
        security_email  : $user.email
        rtaxi_id        : $user.rtaxi
        token           : $user.token

      setAmount  : (operation) ->
        action         : "company/SetAmount"
        rtaxi          : $user.rtaxi
        opid           : operation.id
        amount         : operation.amount
        security_email : $user.email
        rtaxi_id       : $user.rtaxi
        token          : $user.token

      findDriver : (id) ->
        opid : id
        action: "findDriver"

      assignOperation : (operation) ->
        action          : "company/AssignTrip"
        id              : $user.id
        rtaxi           : $user.rtaxi
        opid            : operation.id
        driverNumber    : operation.driver.id
        email           : "#{operation.driver.id}@#{$user.host}"
        timeEstimated   : operation.estimatedTime
        status          : "ASSIGNEDTAXI"
        security_email  : $user.email
        rtaxi_id        : $user.rtaxi
        token           : $user.token


      finishOperation : (id) ->
        action         : "company/FinishTrip"
        id             : $user.id
        rtaxi          : $user.rtaxi
        opid           : id
        status         : "COMPLETED"
        security_email : $user.email
        rtaxi_id       : $user.rtaxi
        token          : $user.token

      cancelOperation : (id, reason) ->
        action: "CancelTrip"
        id    : $user.id
        rtaxi : $user.rtaxi
        opid  : id
        status: "CANCELED"
        email : $user.email
        token : $user.token
        reason: reason


      ping: ->
        action: "Ping"
        id    : $user.id
        rtaxi : $user.rtaxi
        token : $user.token
        email : $user.email

      pullDrivers : ->
        action : "PullDrivers"
        id     : $user.id
        rtaxi  : $user.rtaxi
        token  : $user.token
        email  : $user.email

      confirmationMessage : (json) ->
        action: "messenger/ReadMessage"
        message_id: json.message_id
