technoridesApp.factory '$chat',['chat.adapter','$webSocket','$webSocketAdapter','$filter', '$drivers', '$user', '$timeout','$sce',($api,$webSocket, $webSocketAdapter,$filter, $drivers, $user, $timeout, $sce) ->
  $chat =
    recentMessages: {}
    currentChat:
      senderId : ""
      messages : []
      senderName : ""
    downloaded: ""
    recordAudio: () ->
      navigator.recorder.clear()
      navigator.recorder.record($chat.sendAudio)

    sendAudio : (sound) ->
      $webSocket.send $webSocketAdapter.output.sendChat(sound, $chat.currentChat.senderId, 0, 0)
      message =
        senderId     : $chat.currentChat.senderId
        message      : sound
        senderName   : "Me"
        createdAt    : new Date()
        type         : 0
        type_message : 0

      $chat.saveMessage(message)
      navigator.recorder.clear()

    stopRecordAudio: () ->
      navigator.recorder.stop()
      navigator.recorder.exportWAV (blob) ->

    getChatHistory : (driver) ->
      $chat.currentChat.messages = []
      $chat.currentChat.senderId = driver.id
      $chat.currentChat.senderName = driver.name
      $api.getChatHistory(
          id:  if driver.id? then driver.id else driver
          done: (adapted) ->
            if driver?.id?
              $chat.cleanChat(driver.id)
            for key, message of adapted
              $chat.saveMessage(message)

      )

    getIrcHistory : (page) ->
      $chat.currentChat.messages = []
      $api.getIrc(
        page : page
        done: (adapted) ->
          if driver?.id?
            $chat.cleanChat(driver.id)
          for key, message of adapted
            $chat.saveMessage(message)

      )

    getMedia : (id) ->
      $api.getMedia(
        message_id: id
        done: (adapted) ->
          $chat.replaceMessage(adapted)

      )

    getMediaIrc : (id) ->
      $api.getMedia
        message_id: id
        done: (adapted) ->
          $chat.replaceMessage adapted

    saveMessage : (message) ->
      $chat.currentChat.messages.push
        message     : message.message
        date        : new Date(message.createdAt)
        messageType : message.messageType
        audio       : message.audio
        downloaded  : message.downloaded
        downloading : false
        messageId   : message.messageId
        driverImg   : $chat.getDriverImg(message.senderName)
        senderId    : message.senderId
        senderName  : message.senderName
      if message.irc
        $chat.currentChat.senderName = message.senderName
        $chat.currentChat.senderId = message.senderId

      $timeout(
        ->
          $("#scrollChat").scrollTop($("#scrollChat")[0].scrollHeight)
          $("#scrollMultiChat").scrollTop($("#scrollMultiChat")[0].scrollHeight)
        ,
         300)

      false

    sendChatIrc : (text) ->
      $webSocket.send $webSocketAdapter.output.sendChat(text, $chat.currentChat.senderId, 0, 1)

    sendChat : (text) ->
      $webSocket.send $webSocketAdapter.output.sendChat(text, $chat.currentChat.senderId, 1, 1)
      message =
        senderId     : $user.id
        message      : text
        senderName   : "Me"
        createdAt    : new Date()
        type         : 1
        messageType  : 1

      $chat.saveMessage(message)

    newChatMessage : (message) ->
      $chat.saveMessage(message)
      $chat.saveRecent(message)

    cleanChat: (id) ->
      if $chat.currentChat.senderId != ""
        $chat.currentChat.messages = []

    saveRecent: (message) ->
      unless $chat.recentMessages["#{message.senderId}"]
        $chat.recentMessages["#{message.senderId}"] =
          lastMessage : {}
          name : message.senderName
          senderId: message.senderId

      $chat.recentMessages["#{message.senderId}"] =
        lastMessage   :
          message     : message.message
          date        : new Date(message.createdAt)
          messageType : message.messageType
          audio       : message.audio
        name          : message.senderName
        senderId      : message.senderId
        driverImg   : $chat.getDriverImg(message.senderName)

    replaceMessage: (message) ->
      for key, m of $chat.currentChat.messages
        if m.messageId == message.messageId
          $chat.currentChat.messages[key].audio = message.audio
          $chat.currentChat.messages[key].downloaded = true
          $chat.currentChat.messages[key].downloading = false
          $chat.currentChat.messages[key].message = $sce.trustAsResourceUrl("data:audio/mpeg;base64,#{message.message}")
          $chat.currentChat.messages[key].senderName = message.senderName


    getDriverImg : (name) ->
      trimed = name.split(" -")
      return "#{$drivers.imgUrl}#{trimed[0]}"

    conversationWindow : (driver) ->
      @.getChatHistory driver
      $(".singleChat-window").modal("show")
      false

    conversationWindowIrc : () ->
      @.getIrcHistory(0)
      $(".multiChat-window").modal("show")

    driverDetails :(id) ->
      driver = $drivers.getDriverInfo(id)
      if driver?
        $drivers.driver = driver
      $(".show-driver").modal("show")
      false

  ]
