technoridesApp.factory '$main.adapter', ($api, $settings, $user) ->
  $url  = $settings[$settings.environment].api
  $url2 = $settings[$settings.environment].newApi
  $auth = $settings[$settings.environment].websocket.replace "wss", "https"

  $adapter =
    sslCert : (params) ->
      $api.get({
        code         : 100
        codeName     : "status"
        data         : {}
        url          : $auth
        done         : (response) ->
          params.done()
        fail : (response) ->
          params.done()
      })
