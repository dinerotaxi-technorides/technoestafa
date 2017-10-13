technoridesApp.factory '$radio',($timeout, $interval, $settings, $window, $webSocket, $webSocketAdapter, $user, $chat) ->

  $interval ->
      $radio.microphoneDisabled = $window.navigator.microphoneDisabled
    ,
      500
    ,
      0
    ,
      true

  $radio =
    status   : ""
    sender   : ""
    active   : false
    messages : []
    microphoneDisabled : ""
    recording : false
    intervals : {}
    encoding : false


    stopRecording : ->
      unless $radio.microphoneDisabled
        if $radio.recording
          console.warn "Stopped Recording..."
          navigator.recorder.stop()
          navigator.recorder.exportWAV (blob) ->
            # TODO
          $radio.recording = false
          $radio.encoding  = true

    record : ->
      unless $radio.microphoneDisabled
        unless $radio.recording or $radio.encoding
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
          $timeout.cancel $radio.intervals.radioAutoStop

          # Starts a new timer
          $radio.intervals.radioAutoStop = $timeout ->
            if $radio.recording
              $radio.stopRecording()
          ,
            $settings.intervals.maxRadioMessageLength
          ,
            true

          $("#send").get(0).play()
          $timeout(->
            console.warn "Recording..."
            navigator.recorder.clear()
            navigator.recorder.record($radio.send)
          ,
          500
          )
          $radio.recording = true

    play     : (message) ->
      if message
        $("#recive").get(0).play()

        unless $radio.active
          $radio.active = true

          $timeout(->
            newSound = new Audio("data:audio/mpeg;base64,#{message.bytes}")
            newSound.play()
            $radio.sender = message.sender_name

            newSound.onended = ->
              $radio.active = false


          , 500)

    send : (sound) ->
      if $user.chatEnabled
        $webSocket.send $webSocketAdapter.output.sendChat(sound.substr(22, sound.length),"",0,0)
      else
        $webSocket.send $webSocketAdapter.output.soundMessage(sound)

      navigator.recorder.clear()
      $radio.encoding = false

    stopRecording : ->
      unless $radio.microphoneDisabled
        if $radio.recording
          console.warn "Stopped Recording..."
          navigator.recorder.stop()
          navigator.recorder.exportWAV (blob) ->
            # TODO
          $radio.recording = false
          $radio.encoding  = true

    record :  ->
      unless $radio.microphoneDisabled
        unless $radio.recording or $radio.encoding
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
          $timeout.cancel $radio.intervals.radioAutoStop

          # Starts a new timer
          $radio.intervals.radioAutoStop = $timeout ->
            if $radio.recording
              $radio.stopRecording()
          ,
            $settings.intervals.maxRadioMessageLength
          ,
            true

          $("#send").get(0).play()
          $timeout(->
            console.warn "Recording..."
            navigator.recorder.clear()
            navigator.recorder.record($radio.send)
          ,
          500
          )
          $radio.recording = true

    play     : (message) ->
      if message
        $("#recive").get(0).play()

        unless $radio.active
          $radio.active = true

          $timeout(->
            newSound = new Audio("data:audio/mpeg;base64,#{message.bytes}")
            newSound.play()
            $radio.sender = message.sender_name

            newSound.onended = ->
              $radio.active = false


          , 500)

    driverRecord : (id) ->
      unless $radio.microphoneDisabled
        unless $radio.radiotodriver.recording or $radio.radiotodriver.encoding
          # Changing image
          $radio.radiotodriver.id = id
          image = new Image()
          image.src = "/dispatcher/assets/radio/radio_btn.png"
          $("img#radioRecording").attr("src", image.src)
          $timeout ->
            image = new Image()
            image.src = "/dispatcher/assets/radio/radio_btn_recording.gif"
            $("img#radioDriverRecording").attr("src", image.src)
          ,
            100
          ,
            true

          # Stops current timer
          $timeout.cancel $radio.intervals.radioAutoStop

          # Starts a new timer
          $radio.radiotodriver.intervals.radioAutoStop = $timeout ->
            if $radio.radiotodriver.recording
              $radio.radiotodriver.stopRecording()
          ,
            $settings.intervals.maxRadioMessageLength
          ,
            true

          $("#send").get(0).play()
          $timeout(->
            console.warn "Recording to driver..."
            navigator.recorder.clear()
            navigator.recorder.record($radio.radiotodriver.send)
          ,
          500
          )
          $radio.radiotodriver.recording = true
    radiotodriver :
      status             : ""
      sender             : ""
      active             : false
      recording          : false
      encoding           : false
      intervals          : {}
      id                 : ""
      stopRecording : ->
        unless $radio.microphoneDisabled
          if $radio.radiotodriver.recording
            console.warn "Stopped Recording..."
            navigator.recorder.stop()
            navigator.recorder.exportWAV (blob) ->
              # TODO
            $radio.radiotodriver.recording = false
            $radio.radiotodriver.encoding  = true

      play     : (message) ->
        if message
          $("#recive").get(0).play()

          unless $radio.radiotodriver.active
            $radio.radiotodriver.active = true

            $timeout(->
              newSound = new Audio("data:audio/mpeg;base64,#{message.bytes}")
              newSound.play()
              $radio.radiotodriver.sender = message.sender_name

              newSound.onended = ->
                $radio.radiotodriver.active = false


            , 500)

      send : (sound) ->
        $radio.radiotodriver.encoding = false
        if $user.chatEnabled
          $chat.saveMessage
            senderId     : $user.id
            message      : sound.substr(22, sound.length)
            senderName   : "Me"
            createdAt    : new Date()
            type         : 1
            messageType  : 0
            audio       :
              object    : new Audio("data:audio/mp3;base64,#{sound.substr(22, sound.length)}")
              listened  : false

              play: ->
                @.object.play()
                @.listened = true
                @.object.onended = ->
                  adapted.audio.listened = false

              stop: ->
                this.object.pause()
                this.listened = false

          $webSocket.send $webSocketAdapter.output.sendChat(sound.substr(22, sound.length),$radio.radiotodriver.id,1,0)
        else
          $webSocket.send $webSocketAdapter.output.soundMessage(sound, $radio.radiotodriver.id)
        navigator.recorder.clear()


      stopRecording : ->
        unless $radio.microphoneDisabled
          if $radio.radiotodriver.recording
            console.warn "Stopped Recording..."
            navigator.recorder.stop()
            navigator.recorder.exportWAV (blob) ->
              # TODO
            $radio.radiotodriver.recording = false
            $radio.radiotodriver.encoding  = true

      record : ->
        unless $radio.microphoneDisabled
          unless $radio.radiotodriver.recording or $radio.radiotodriver.encoding
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
            $timeout.cancel $radio.radiotodriver.intervals.radioAutoStop

            # Starts a new timer
            $radio.radiotodriver.intervals.radioAutoStop = $timeout ->
              if $radio.recording
                $radio.stopRecording()
            ,
              $settings.intervals.maxRadioMessageLength
            ,
              true

            $("#send").get(0).play()
            $timeout(->
              console.warn "Recording..."
              navigator.recorder.clear()
              navigator.recorder.record($radio.send)
            ,
            500
            )
            $radio.radiotodriver.recording = true

      play     : (message) ->
        if message
          $("#recive").get(0).play()

          unless $radio.radiotodriver.active or $radio.active
            $radio.radiotodriver.active = true

            $timeout(->
              newSound = new Audio("data:audio/mpeg;base64,#{message.bytes}")
              newSound.play()
              $radio.radiotodriver.sender = message.sender_name

              newSound.onended = ->
                $radio.radiotodriver.active = false


            , 500)
