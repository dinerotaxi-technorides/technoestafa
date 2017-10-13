technoridesApp.factory '$webSocketHandler', ($webSocket, $user, $window, $webSocketAdapter, $radio, $operations, $drivers, $map, $chat) ->
   $webSocketHandler =
    # Events
    #
    onMessage : (message) ->
      messageAction = message.action.replace(/.+\//, "")

      switch messageAction

        when "NewMessage"
          $chat.newChatMessage $webSocketAdapter.input.newChatMessage(message)


        when "AlertNewAudioBroadcast"
          # if its not self message save it
          if $webSocketAdapter.input.reciveAudio message
            $radio.messages.push
              message : message
              name : message.sender_name
              audio: new Audio("data:audio/mp3;base64,#{message.bytes}")
              listened : if $radio.active or $radio.radiotodriver.active then false else true
              play : ->
                $radio.play @.message
                @.listened = true



          #play message
          if not $radio.active and not $radio.radiotodriver.active
            $radio.play $webSocketAdapter.input.reciveAudio message


        when "PullTrips"
          $operations.save $webSocketAdapter.input.getOperations message

        when "newTrip"
          $operations.add $webSocketAdapter.input.newOperation message

        when "newTextNotification"
          $(".warning-modal .panel-body p").html(message.text)
          $(".warning-modal").modal("show")


        when "PullDrivers"
          adapted = []
          for driver in message.drivers
            adapted.push $webSocketAdapter.input.updateDriver driver

          $drivers.save adapted

        when "CancelTrip"
          for key,op of $operations.list
            if op.id is message.opid
              $operations.list[key].status = "canceled"
              $operations.list[key].originalStatus = message.status

          $map.removeMarker "operations", "#{message.opid}"


        when "FinishTrip"
          for key, op of $operations.list
            if op.id is message.opid
              $operations.list[key].status = "history"

          $map.removeMarker "operations", "#{message.opid}"

        when "PullingTrips", "PullInTransaction"
          $drivers.addOrUpdate $webSocketAdapter.input.updateDriver message

        when "AcceptTrip"
          for key, op of $operations.list
            if op.id is message.opid

              $operations.list[key].status = "intransaction"
              $operations.list[key].driver                = {}
              $operations.list[key].driver.id             = message.driverNumber
              $operations.list[key].assignedAt            = message.assignedAt
              $operations.list[key].estimatedTime         = message.timeEstimated * 60
              $operations.list[key].estimatedTimeOriginal = $operations.list[key].estimatedTime


              $map.updateMarker "operations", message.opid, icon : "/common/assets/markers/operation_intransaction.png"

              driver        = message.operation.driver
              driver.status = "intravel"
              $drivers.addOrUpdate driver

        when "FindingDriver"

          for key,op of $operations.list
            if message.opid is $operations.list[key].id
              $operations.list[key].driverStatus = "serching"

        when "DriverNotFound"
          for key,op of $operations.list
            if message.opid is $operations.list[key].id
              $operations.list[key].driverStatus = "Not Found"
              $operations.list[key].try = message.count

              if message.count > message.remaning
                message.remaning = 99

              $operations.list[key].trylimit = message.remaning
        when "ResendTrip"
          for key, op of $operations.list
            if message.opid is $operations.list[key].id
              $operations.list[key].status = "pending"
              $operations.list[key].driverStatus = "serching"
              $operations.list[key].driver = {}

        when "HoldingUser"
          for key, op of $operations.list
            if message.opid is $operations.list[key].id
              $operations.list[key].atDoorAt = new Date()

        when "SetAmount"
          for key, op of $operations.list
            if op.id is message.opid
              $operations.list[key].status = "history"

          $map.removeMarker "operations", message.opid

        when "InTransactionTrip"
          for key, op of $operations.list
            if op.id is message.opid
              $operations.list[key].passenger.onboard = true

          $map.removeMarker "operations", message.opid
    onOpen : (message, webSocket) ->
      $webSocket.send $webSocketAdapter.output.pullDrivers()


    onClose : (message, webSocket) ->
      if message.code is 3000
        webSocket.stopReconnecting()
        $user.logout()
