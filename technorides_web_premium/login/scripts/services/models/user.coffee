technoridesApp.factory '$user', ['ipCookie','$window',(ipCookie, $window) ->

  $user =
    isLogged : false
    attributes : [
        "token"
        "lang"
        "latitude"
        "longitude"
        "country"
        "timeZone"
        "adminCode"
        "useAdminCode"
        "countryCode"
        "id"
        "firstName"
        "lastName"
        "company"
        "rtaxi"
        "role"
        "isLogged"
        "email"
        "host"
        "destinationRequired"
        "digitalRadio"
        "operatorDispatchMultipleTrips"
        "operatorSuggestDestination"
        "blockMultipleTrips"
        "showBusinessModel"
        "businessModel"
        "isFareCalculatorActive"
        "isPrePaidActive"
        "operatorCancelationReason"
        "chatEnabled"
        "isFromBooking"
      ]

    logout : ->
      isFromBooking = $user.isFromBooking
      rtaxi = $user.rtaxi
      for key in $user.attributes
        ipCookie.remove "admin_user_#{key}", path: "/"
        $user[key] = ""
      $user.isLogged = false
      if isFromBooking
        $window.location = "/newbooking/#/rtaxi/#{rtaxi}"
      else
        $window.location = "/login"

    login : (response) ->
      for key, value of response
        $user[key] = value
      $user.saveToCookies()


    saveToCookies : ->
      for key in $user.attributes
        ipCookie "admin_user_#{key}", $user[key], path: "/"


    loadFromCookies : ->
      for key in $user.attributes
        $user[key] = ipCookie "admin_user_#{key}"


    redirectByRole : ->
      switch $user.role
        when "operator"
          $window.location = "/dispatcher-2"
        when "monitor"
          $window.location = "/dispatcher-2"
        when "calltaker"
          $window.location = "/dispatcher-2"
        when "company"
          $window.location = "/dashboard"
        when "admin"
          $window.location = "/admin"

]
