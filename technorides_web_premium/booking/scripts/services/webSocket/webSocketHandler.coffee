technoridesApp.factory '$webSocketHandler',['$settings', '$webSocketAdapter', '$user','$map','$order', '$error', '$location', '$driver' ,($settings, $webSocketAdapter, $user, $map, $order, $error, $location, $driver ) ->

  $webSocketHandler =
    # Events
    onMessage : (message) ->
      # Remove the actor from the action i.e: passenger/PullDrivers it's converted to PullDrivers
      messageAction = message.action.replace(/.+\//, "")

      switch messageAction
        # Driver accepts the trip
        when "AcceptTrip"
          $driver.setDriver $webSocketAdapter.input.acceptTrip(message)
          $order.assign()
          $error.showError "driverAssigned", "driverassigned"
          $map.booking.markerOrig.options.draggable = false
          $map.booking.markerOrig.options.icon = '/common/assets/markers/operation_assigned.png'


        # Driver cancels the trip
        when "CancelTrip"
          $order.cancel()
          $error.showError "orderCanceled", "ordercanceled"
          # update markers
          $map.booking.markerOrig.options.draggable = true
          $map.booking.markerOrig.options.icon = "/common/assets/markers/origin.png"
          $map.booking.driver.options.visible = false
          # Geolocate on finish
          $map.booking.geolocate()


        # Driver is on the passenger's door
        when "HoldingUser"
          $order.driverArrived()
          $error.showError "driverArrived", "driverssigned"
          $("#arrived").get(0).play()


        # Passenger asks for all the company drivers
        when "PullDrivers"
          $webSocketAdapter.input.pullDrivers(message)


        # Driver is on the passenger's door
        when "RingUser"
          $order.driverArrived()
          $error.showError "driverArrived", "driverarrived"
          $map.booking.markerOrig.options.icon = '/common/assets/markers/operation_intransaction.png'
          $("#arrived").get(0).play()


        # Passenger asks for his current operation's information
        when "getOperation"
          $order.createTrip $webSocketAdapter.input.getOperation(message)
          $map.booking.markerOrig.options.draggable = false
          $map.booking.markerOrig.options.icon = "/common/assets/markers/operation_pending.png"
          if message.driver?.id?
            $webSocketHandler.onMessage $webSocketAdapter.output.fakeAceptTrip(message)


        when "FinishTrip"
          $order.finish()
          $driver.unsetDriver()
          $map.booking.markerOrig.options.draggable = true
          $map.booking.markerOrig.options.icon = '/common/assets/markers/origin.png'
          $error.showError "finishedTrip", "finishedtrip"
          $map.booking.driver.options.visible = false
          # Geolocate on finish
          $map.booking.geolocate()

        when "PullInTransaction"
          coords = $webSocketAdapter.input.pullInTransaction message
          $map.booking.driver.coords = coords.coords
          $map.booking.driver.options.visible = true

    onOpen : (message, webSocket) ->
      webSocket.send $webSocketAdapter.output.pullDrivers()

      if $order?
        webSocket.send $webSocketAdapter.input.getOrder()
        $map.booking.driver.options.visible = true

    onClose : (message, webSocket) ->
      if message.code is 3000
        $user.logout()
        document.location.href = "#"
        webSocket.stopReconnecting()
        $error.showError "sessionExpired", "sessionexpired"


]
