technoridesApp.factory "messages.api", ($api, $user, $settings) ->

    $newApiUrl = $settings[$settings.environment].newApi

    $adapter =
      sendMessageToOperators: (params) ->
        $api.post
          url      : "#{$newApiUrl}operator/notification"
          data:
            password : "QOu6QjruPi0Zo4VM"
            message  : params.message
            token    : $user.token
            user     : "admin"
          done: (response) ->
            params.done response
          fail: (response) ->
            params.fail response
