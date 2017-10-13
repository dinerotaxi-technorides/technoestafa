technoridesApp.factory 'chat.adapter', ($api, $settings, $user, $sce) ->
  $url     = $settings[$settings.environment].newApi
  $chat =
    getChatHistory: (params)->
      $api.get(
        data:
          token       : $user.token
          page        : 0
          receiver_id : params.id
        code: 200
        codeName: "status"
        url:  "#{$url}chat/conversation"
        done: (response)->
          adapted = []
          for row in response.data
            adapted.push
              senderId     : row.sender_id
              createdAt    : row.created_at
              messageId    : row.id
              rtaxi        : row.rtaxi_id
              downloaded   : false
              sender       :
                email      : row.sender.email
                first_name : row.sender.first_name
                id         : row.sender.id
                last_name  : row.sender.last_name
                phone      : row.sender.phone
                typeUser   : row.sender.type_user
              senderName   : row.sender_name
              type         : row.type
              messageType  : row.type_message
              message      : row.bytes

          params.done(adapted)

        fail :(response) ->
          if response.status is 411
            $user.logout()

        )

    getMedia: (params)->
      $api.get(
        data     :
          token  : $user.token
          id     : params.message_id
        code     : 200
        codeName : "status"
        url      : "#{$url}chat/media/details"
        done: (response)->
          adapted =
            senderId    : response.data.sender_id
            senderName  : response.data.sender_name
            createdAt   : response.data.created_at
            messageType : response.data.type_message
            message     : response.data.bytes
            downloaded  : true
            downloading : false
            messageId   :  response.data._id

          params.done(adapted)

        fail :(response) ->
          if response.status is 411
            $user.logout()

        )

    getIrc: (params)->
      $api.get(
        data     :
          token  : $user.token
          page     : params.page
        code     : 200
        codeName : "status"
        url      : "#{$url}chat/irc"
        done: (response)->
          adapted = []
          for row in response.data
            adapted.push
              senderId     : row.sender_id
              createdAt    : row.created_at
              messageId    : row.id
              rtaxi        : row.rtaxi_id
              downloaded   : false
              sender       :
                email      : row.sender.email
                first_name : row.sender.first_name
                id         : row.sender.id
                last_name  : row.sender.last_name
                phone      : row.sender.phone
                typeUser   : row.sender.type_user
              senderName   : row.sender_name
              type         : row.type
              messageType  : row.type_message
              message      : row.bytes

          params.done(adapted)
        fail :(response) ->
          if response.status is 411
            $user.logout()

        )
