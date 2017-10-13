technoridesApp.factory '$webSocketHandler', ($webSocket, $user, $location, $webSocketAdapter, $operation, $map, $settings, $modal) ->
   $apiLink    = $settings[$settings.environment].api
   $webSocketHandler =
    # Events
    #
    onMessage : (message) ->
      messageAction = message.action.replace(/.+\//, "")

      switch messageAction
        when "AcceptTrip"
          $operation.searching = false
          $operation.driver =
            car:
              brand: message.operation.driver.brandCompany
              mode : message.operation.driver.model
              plate : message.operation.driver.plate
            name : message.operation.driver.firstName
            lastName: message.operation.driver.lastName
            email : message.operation.driver.email
            id : message.operation.driver.id
            number : message.operation.driver.driverNumber
            phone : message.operation.driver.phone
            image : "#{$apiLink}taxiApi/displayDriverLogoByEmail?email=#{message.operation.driver.email}"

          $operation.changed()

        # Driver cancels the trip
        when "CancelTrip"
          $operation.created = false
          $operation.searching = false
          $operation.reset()
          $modal.open
            temp : "views/modal/booking/operation-canceled.html"
            title : "Canceled"
          $operation.changed()

          $map.updateMarker "newOperation", "origin", draggable: false
          $map.updateMarker "newOperation", "destination", draggable: false
        # Driver is on the passenger's door
        when "HoldingUser"
          $modal.open(
            temp : "views/modal/booking/driver-at-door.html"
            title : "Driver at the door"
          )
          $operation.changed()

        # Passenger asks for all the company drivers
        when "PullDrivers"
          $webSocketAdapter.input.pullDrivers message

        # Driver is on the passenger's door
        when "RingUser"
          $modal.open(
            temp : "views/modal/booking/ring-user.html"
            title : "Ring!"
          )
          $operation.changed()

        # Passenger asks for his current operation's information
        when "getOperation"
          if message.driver?
            message.driver.image = "#{$apiLink}taxiApi/displayDriverLogoByEmail?email=#{message.driver.email}"
          $operation.setOperation message

        when "FinishTrip"
          $modal.open(
            temp : "views/modal/booking/operation-finished.html"
            title : "Trip Finished"
          )
          $operation.reset()
          $operation.changed()



        when "PullInTransaction"
          $operation.updateDriver message

        # Seted on board
        when "InTransactionTrip"
          # this is a fake state, on reload this state will be losed, this is a websocket bad design issue
          $operation.onboard = true
          $operation.searching = false
          $operation.changed()
        when "sendSms"
          action = message.action.split "/"
          # recive answer only if its from a driver
          if action[0] is "driver"
            type = message.SMS_code.toLowerCase()
            $modal.open
              temp  : "views/modal/booking/#{type}.html"
              title : "Message from Driver"
            $operation.changed()

        when "ResendTrip"
         $modal.open
            temp : "views/modal/booking/driver-canceled.html"
            title : "Canceled"
          $operation.driver = {}
          $operation.onboard   = true
          $operation.searching = true
          $operation.changed()

    onOpen : (message, webSocket) ->
      webSocket.send $webSocketAdapter.output.getOperation()

    onClose : (message, webSocket) ->
      if message.code is 3000
        webSocket.stopReconnecting()
        $user.logout()
      if message.code is 1006
        webSocket.stopReconnecting()
        $user.logout()
