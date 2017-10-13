technoridesApp.factory '$radio',['$timeout',($timeout) ->

  $radio =
    status   : ""
    sender   : ""
    active   : false
    messages : []

    play     : (id) ->
      $("#recive").get(0).play()

      unless @active
        @active = true

        $timeout(->
          newSound = new Audio("data:audio/mp3;base64,#{$radio.messages[id].bytes}")
          newSound.play()
          $radio.messages[id].played = true

          if $radio.messages[id].marker?
            $radio.messages[id].marker.options.animation = google.maps.Animation.BOUNCE

          newSound.onended = ->
            $radio.active = false
            # Driver marker animation end
            if $radio.messages[id].marker?
              $radio.messages[id].marker.options.animation = null


        , 500)

      

]
