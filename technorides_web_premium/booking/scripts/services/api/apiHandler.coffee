technoridesApp.factory '$apiHandler',($translate, $location ,$webSocket, $error, $company, $user,$map, $order, $apiAdapter, $window, ipCookie) ->

  $apiHandler =
    onSslCert : (response, success) ->
      $webSocket.connect()

    onLogin : (response, success) ->
      $(".spinner").hide()
      if success
        $user.login $apiAdapter.input.login(response)

        $order.getScheduledOperations()
        if $user.isCorporateAdmin
          ipCookie "rtaxi", $company.rtaxi
          $user.loginCorporateAdmin()
          $window.location = "corporate"
        else
          $location.path "/order"
          $map.booking.geolocate()
      else
        $error.showError("login", response.status)


    onForgotPassword : (response, success) ->
      $(".spinner").hide()
      if success
        $error.showError("forgotpass", "emailSended")
      else
        $error.showError("forgotpass", "emailnotSended")


    onPriceCalculator : (response, success) ->
      if success and response.amount isnt 0.0
        $order.amount = $apiAdapter.input.priceCalculator(response)


    onGetCompanyDataByDomain: (response, success) ->
      $(".spinner").hide()
      if success

        $company.getCompanyData $apiAdapter.input.getCompanyDataByDomain(response)
        $user.loadFromCookies $company.rtaxi

        if $user.isLogged
          $order.getScheduledOperations()
          $location.path '/order'
          # Loading order
          $order.loadFromCookies()
          if $user.isCorporateAdmin
            ipCookie "rtaxi", $company.rtaxi
            $user.loginCorporateAdmin()
            $window.location = "corporate"
        $translate.use response.lang
        $map.booking.markerHome.coords.latitude = response.latitude
        $map.booking.markerHome.coords.longitude = response.longitude
        $map.booking.markerHome.options.visible = true

        $map.booking.geolocate()


    onGetCompanyData : (response, success) ->
      $(".spinner").hide()
      if success
        $company.getCompanyData $apiAdapter.input.getCompanyData(response)
        $user.loadFromCookies $company.rtaxi

        if $user.isLogged
          $order.getScheduledOperations()
          $location.path '/order'
          # Loading order
          $order.loadFromCookies()
          if $user.isCorporateAdmin
            ipCookie "rtaxi", $company.rtaxi
            $user.loginCorporateAdmin()
            $window.location = "corporate"
        $translate.use response.lang
        $map.booking.markerHome.coords.latitude = response.latitude
        $map.booking.markerHome.coords.longitude = response.longitude
        $map.booking.markerHome.options.visible = true

        $map.booking.geolocate()


    onRegisterUser : (response, success) ->
      $(".spinner").hide()
      if success
        $apiHandler.onLogin(response, success)
      else
        $error.showError("register", response.status)


    onContactEmail : (response, success) ->
      $(".spinner").hide()
      if success
        $error.showError("contact", "success")
      else
        $error.showError("contact", "error")


    onCreateTrip : (response, success) ->
      $(".spinner").hide()
      if success
        $order.createTrip $apiAdapter.input.createTrip(response)
        $map.booking.markerOrig.options.icon      = "/common/assets/markers/operation_pending.png"
        $map.booking.markerOrig.options.draggable = false
        $map.booking.markerDest.options.visible   = false
      else
        $error.showError("order", response.status)


    onCreateScheduledTrip : (response, success) ->
      $(".spinner").hide()
      if success
        $error.showError("scheduledTrip", "success")
      else
        $error.showError("scheduledTrip", "error")


    onGetScheduledOperations : (response, success) ->
      $(".spinner").hide()
      $order.scheduledOperations = $apiAdapter.input.getScheduledOperations response
