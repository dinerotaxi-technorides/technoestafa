technoridesApp.factory '$webSocket', ->

  $webSocket =

    pingInterval : null

    setAdapter : (newAdapter) ->
      $webSocket.webSocketAdapter = newAdapter


    setHandler : (newHandler) ->
      $webSocket.webSocketHandler = newHandler


    connect : ->
      $webSocket.connection.url = $webSocket.webSocketAdapter.makeSocketUrl()

      if $webSocket.webSocketAdapter.debug
        console.debug $webSocket.connection.url
      $webSocket.connection.connect(0)


    close : ->
      $webSocket.connection.close $webSocket.webSocketAdapter.close()


    send : (json) ->
      message = JSON.stringify(json)
      if $webSocket.webSocketAdapter.debug
        console.log ">> #{json.action}"
        console.debug ">> #{message}"

      $webSocket.connection.send(message)


  $webSocket.connection = new ReconnectingWebSocket("")

  $webSocket.connection.onmessage = (message) ->
    json = $.parseJSON(message.data)
    if $webSocket.webSocketAdapter.debug
      console.log "<< #{json.action}"
      console.debug "<< #{JSON.stringify(json)}"

    if json.message_need_confirmation
      $webSocket.send $webSocket.webSocketAdapter.output.confirmationMessage(json)

    $webSocket.webSocketHandler.onMessage json


  $webSocket.connection.onopen = (message) ->
    console.warn "Connected"
    $("#preloader").hide()
    clearInterval($webSocket.pingInterval)

    $webSocket.webSocketHandler.onOpen(message, $webSocket)

    $webSocket.pingInterval = setInterval( ->
        $webSocket.send $webSocket.webSocketAdapter.output.ping()
      10000
    )


  $webSocket.connection.onclose = (message) ->
    $("#preloader").show()
    console.warn "Disconnected (Code: #{message.code} - Reason: #{message.reason})"
    $webSocket.webSocketHandler.onClose message, $webSocket


  $webSocket.stopReconnecting = ->
    clearInterval($webSocket.pingInterval)
    $webSocket.connection.stopReconnecting()


  $webSocket
