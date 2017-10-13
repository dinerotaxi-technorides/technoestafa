technoridesApp.factory '$webSocketAdapter', ($webSocket, $settings, $user) ->
  $socketHost = $settings[$settings.environment].websocket
  $webSocketAdapter =
  # TODO MSGS ICON IMAGES
    close : ->
      code: 3000
      reason:"User Disconnected"


    debug : $settings[$settings.environment].debug


    makeSocketUrl : ->
      host   = $socketHost + "passenger"
      params = "?rtaxi=" + $user.rtaxi + "&id=" + $user.id + "&token=" + $user.token
      address        = host + params

    input:
      pullDrivers : (message) ->
        console.log message

      pullInTransaction  : (message) ->
        console.log message


    output:
      sendSms : (sms, id) ->
        action        : "passenger/sendSms"
        SMS_code      : sms
        opid          : id
        token         : $user.token

      getOperation : ->
        action : "getOperation"
        op_id  : null
        token  : $user.token
        id     : $user.id
        email  : $user.email

      pullDrivers : ->
        action : "PullDrivers"
        id     : $user.id
        rtaxi  : $user.rtaxi
        token  : $user.token
        email  : $user.email

      ping: ->
        action: "Ping"
        id    : $user.id
        rtaxi : $user.rtaxi
        token : $user.token
        email : $user.email

      cancelOperation: (id) ->
        action   : "CancelTrip"
        id       : $user.id
        rtaxi    : $user.rtaxi
        opid     : id
        status   : "CANCELED"
        email    : $user.email
        token    : $user.token


      confirmationMessage : (json) ->
        action: "messenger/ReadMessage"
        message_id: json.message_id
