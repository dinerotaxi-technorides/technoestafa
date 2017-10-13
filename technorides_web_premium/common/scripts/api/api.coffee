technoridesApp.factory '$api', ($http, $injector, $window, $settings) ->

  # Should inject $user?
  if $injector.has "$user"
    $user = $injector.get "$user"
  $debug = $settings[$settings.environment].debug
  $apiLink = $settings[$settings.environment].api
  $api =

    setAdapter : (newAdapter) ->
      $api.apiAdapter = newAdapter


    setHandler : (newHandler) ->
      $api.apiHandler = newHandler


    send : (method, data, callback) ->
      $(".spinner").show()
      methodCapitalized = method.charAt(0).toUpperCase() + method.slice(1)
      handlerName       = "on#{methodCapitalized}"
      handlerDefined    = $api.apiHandler[handlerName]?
      if $debug
        console.debug $api.apiAdapter.url[method]
        console.debug $api.apiAdapter.output[method](data)
      $http.get($api.apiAdapter.url[method], params: $api.apiAdapter.output[method](data))
      .success (response) ->
        if handlerDefined
          $api.apiHandler[handlerName](response, $api.apiAdapter.isSuccessStatus(method, response.status))
        else
          #
          if response.status is 100
            if $api.apiHandler.defaultSuccess?
              $api.apiHandler.defaultSuccess()
          else
            if $api.apiHandler.defaultError?
              $api.apiHandler.defaultError()

        if callback?
          callback(response)

      .error (response) ->
        # 411 error? (token expired)
        if $user? and response?.status is 411
          console.warn "Session expired"
          $user.logout()
          $window.location = "/login"

          return
        if response.status is 500
          mail =
            from   : "no-reply@technorides.com"
            to     : "mati@technorides.com"
            subject: "WEB ERROR | Status 500"
            message: "<p>recurso: #{$api.apiAdapter.url[method]}<br>parametros:#{JSON.stringify($api.apiAdapter.output[method](data))}</p>"
          $http.get("#{$apiLink}technoRidesEmailApi/send_mail" , params: mail)
        if handlerDefined
          $api.apiHandler[handlerName](response, false)


    priceCalculator : (method, data, callback) ->
      methodCapitalized = method.charAt(0).toUpperCase() + method.slice(1)
      handlerName       = "on#{methodCapitalized}"
      handlerDefined    = $api.apiHandler[handlerName]?

      $http.get("#{$api.apiAdapter.url.priceCalculator}#{$api.apiAdapter.output.priceCalculator()}")
      .success (response) ->
        if handlerDefined
          $api.apiHandler[handlerName](response, $api.apiAdapter.isSuccessStatus('priceCalculator',response.status))
        if callback?
          callback(response)

      .error (response) ->
        # 411 error? (token expired)
        if $user? and response.status is 411
          console.warn "Session expired"
          $user.logout()
          $window.location = "/login"

          return
        if response.status is 500
          mail =
            from   : "no-reply@technorides.com"
            to     : "mati@technorides.com"
            subject: "WEB ERROR | Status 500"
            message: "<p>recurso: #{$api.apiAdapter.url[method]}<br>parametros:#{JSON.stringify($api.apiAdapter.output[method](data))}</p>"
          $http.get("#{$apiLink}technoRidesEmailApi/send_mail" , params: mail)
        if handlerDefined
          $api.apiHandler[handlerName](response, false)


    newApiSend : (method, data, callback) ->
      methodCapitalized = method.charAt(0).toUpperCase() + method.slice(1)
      handlerName       = "on#{methodCapitalized}"
      handlerDefined    = $api.apiHandler[handlerName]?
      if $debug
        console.debug $api.apiAdapter.url[method]
        console.debug $api.apiAdapter.output[method](data)
      $http.get("#{$api.apiAdapter.url[method]}#{$api.apiAdapter.output[method](data)}")
      .success (response) ->
        if handlerDefined
          $api.apiHandler[handlerName]($api.apiAdapter.input[method](response), $api.apiAdapter.isSuccessStatus(method,response.status))
        if callback?
          callback(response)

      .error (response) ->
        # 411 error? (token expired)
        if $user? and response.status is 411
          console.warn "Session expired"
          $user.logout()
          $window.location = "/login"

          return
        if response.status is 500
          mail =
            from   : "no-reply@technorides.com"
            to     : "mati@technorides.com"
            subject: "WEB ERROR | Status 500"
            message: "<p>recurso: #{$api.apiAdapter.url[method]}<br>parametros:#{JSON.stringify($api.apiAdapter.output[method](data))}</p>"
          $http.get("#{$apiLink}technoRidesEmailApi/send_mail" , params: mail)
        if handlerDefined
          $api.apiHandler[handlerName](response, false)


    post : (method, data, callback) ->

      methodCapitalized = method.charAt(0).toUpperCase() + method.slice(1)
      handlerName       = "on#{methodCapitalized}"
      handlerDefined    = $api.apiHandler[handlerName]?
      if $debug
        console.debug $api.apiAdapter.url[method]


      $http.post($api.apiAdapter.url[method], $api.apiAdapter.output[method](data), headers: {"Content-Type": "application/json"})
      .success (response) ->
        if handlerDefined
          adaptedResponse      = {}
          adaptedSuccessStatus = 200

          if $api.apiAdapter.input[method]?
            adaptedResponse = $api.apiAdapter.input[method](response)

          if $api.apiAdapter.isSuccessStatus?
            success = $api.apiAdapter.isSuccessStatus(method,response.status)
          else
            success = false

          $api.apiHandler[handlerName](adaptedResponse, success)
        if callback?
          callback(response)

      .error (response) ->
        # 411 error? (token expired)
        if $user? and response.status is 411
          console.warn "Session expired"
          $user.logout()
          $window.location = "/login"

          return
        if response.status is 500
          mail =
            from   : "no-reply@technorides.com"
            to     : "mati@technorides.com"
            subject: "WEB ERROR | Status 500"
            message: "<p>recurso: #{$api.apiAdapter.url[method]}<br>parametros:#{JSON.stringify($api.apiAdapter.output[method](data))}</p>"
          $http.get("#{$apiLink}technoRidesEmailApi/send_mail" , params: mail)

        if handlerDefined
          $api.apiHandler[handlerName](response, false)

    postJson : (method, data, callback) ->

      methodCapitalized = method.charAt(0).toUpperCase() + method.slice(1)
      handlerName       = "on#{methodCapitalized}"
      handlerDefined    = $api.apiHandler[handlerName]?
      if $debug
        console.debug $api.apiAdapter.url[method]


      $http.post($api.apiAdapter.url[method], $api.apiAdapter.output[method](data), headers: {"Content-Type": "application/json"})
      .success (response) ->
        if handlerDefined
          adaptedResponse      = {}
          adaptedSuccessStatus = 200

          if $api.apiAdapter.input[method]?
            adaptedResponse = $api.apiAdapter.input[method](response)

          if $api.apiAdapter.isSuccessStatus?
            success = $api.apiAdapter.isSuccessStatus(method,response.status)
          else
            success = false

          $api.apiHandler[handlerName](adaptedResponse, success)
        if callback?
          callback(response)

      .error (response) ->
        # 411 error? (token expired)
        if $user? and response.status is 411
          console.warn "Session expired"
          $user.logout()
          $window.location = "/login"

          return
        if response.status is 500
          mail =
            from   : "no-reply@technorides.com"
            to     : "mati@technorides.com"
            subject: "WEB ERROR | Status 500"
            message: "<p>recurso: #{$api.apiAdapter.url[method]}<br>parametros:#{JSON.stringify($api.apiAdapter.output[method](data))}</p>"
          $http.get("#{$apiLink}technoRidesEmailApi/send_mail" , params: mail)

        if handlerDefined
          $api.apiHandler[handlerName](response, false)
