technoridesApp.factory '$webSocketHandler',[ '$webSocketAdapter', '$user', '$error', '$location' ,'$map','$cookieStore',( $webSocketAdapter, $user, $error, $location, $map, $cookieStore ) ->

  $webSocketHandler =
    # Events
    #
    onMessage : (message) ->
      messageAction = message.action.replace(/.+\//, "")

      switch messageAction
        when "PullDrivers"
          $webSocketAdapter.input.pullDrivers message

        when "PullTrips"
          $webSocketAdapter.input.getOperations message
          if $cookieStore.get("options-operations")?
            if !$cookieStore.get("options-operations")
              $map.dispatcher.toogleMarkers("operations")

        when "PullInTransaction"
          $webSocketAdapter.input.updateDriver message

        when "PullingTrips"
          $webSocketAdapter.input.updateDriver message

        when "newTrip"
          $webSocketAdapter.input.newOperation message

        when "CancelTrip"
          $webSocketAdapter.input.cancelOperation message

        when "AcceptTrip"
          $webSocketAdapter.input.acceptOperation message

        when "SetAmount"
          $webSocketAdapter.input.setAmount message

        when "FinishTrip"
          $webSocketAdapter.input.finishOperation message

        when "AlertNewAudioBroadcast"
          $webSocketAdapter.input.reciveAudio message

        when "newTextNotification"
          $webSocketAdapter.input.newServerMessage message

        when "expireTextNotification"
          $webSocketAdapter.input.newServerMessage message

        when "HoldingUser"
          $webSocketAdapter.input.holdingUser message
        
        when "DriverNotFound"
          $webSocketAdapter.input.driverNotFound message

        when "FindingDriver"
          $webSocketAdapter.input.findingDriver message

        when "AssignDriverNotFound"
          $webSocketAdapter.input.assignDriverNotFound message
          
    onOpen : (message, webSocket) ->
      webSocket.send $webSocketAdapter.output.pullDrivers()


    onClose : (message, webSocket) ->
      if message.code is 3000
        webSocket.stopReconnecting()
        $user.logout()
        document.location.href = "/login"


]
