technoridesApp.factory '$user', (ipCookie) ->

  $user =

    isLogged        : false

    loginCorporateAdmin : ->
      
      #delete booking cookies
      ipCookie.remove "booking_token_#{$user.rtaxi}", { path: '/booking' }
      ipCookie.remove "booking_firstName_#{$user.rtaxi}",{ path: '/booking' }
      ipCookie.remove "booking_lastName_#{$user.rtaxi}",{ path: '/booking' }
      ipCookie.remove "booking_isLogged_#{$user.rtaxi}",{ path: '/booking' }
      ipCookie.remove "booking_email_#{$user.rtaxi}",{ path: '/booking' }
      ipCookie.remove "booking_phone_#{$user.rtaxi}",{ path: '/booking' }
      ipCookie.remove "booking_id_#{$user.rtaxi}",{ path: '/booking' }
      ipCookie.remove "booking_isCorporate_#{$user.rtaxi}",{ path: '/booking' }
      ipCookie.remove "booking_isCorporateAdmin#{$user.rtaxi}",{ path: '/booking' }
      ipCookie.remove "booking_costCenter_#{$user.rtaxi}", { path: '/booking' }
      ipCookie.remove "booking_lang_#{$user.rtaxi}", {path: '/booking'}

      # Set Cookies to corporate path (this will set only on that path)
      ipCookie "booking_token_#{$user.rtaxi}", $user.token, { path: '/booking/corporate'}
      ipCookie "booking_firstName_#{$user.rtaxi}", "#{$user.firstName}" , { path: '/booking/corporate'}
      ipCookie "booking_lastName_#{$user.rtaxi}", "#{$user.lastName}", { path: '/booking/corporate'}
      ipCookie "booking_isLogged_#{$user.rtaxi}", $user.isLogged, { path: '/booking/corporate'}
      ipCookie "booking_email_#{$user.rtaxi}", $user.email, { path: '/booking/corporate'}
      ipCookie "booking_phone_#{$user.rtaxi}", $user.phone, { path: '/booking/corporate'}
      ipCookie "booking_id_#{$user.rtaxi}", $user.id, { path: '/booking/corporate'}
      ipCookie "booking_isCorporate_#{$user.rtaxi}", $user.isCorporate, { path: '/booking/corporate'}
      ipCookie "booking_isCorporateAdmin#{$user.rtaxi}", $user.isCorporateAdmin, { path: '/booking/corporate'}
      ipCookie "booking_costCenter_#{$user.rtaxi}", $user.costCenter, { path: '/booking/corporate'}
      ipCookie "booking_lang_#{$user.rtaxi}", $user.lang, {path: '/booking/corporate'}

      # unset user just in case
      $user.token            = ""
      $user.firstName        = ""
      $user.lastName         = ""
      $user.email            = ""
      $user.phone            = ""
      $user.id               = ""
      $user.isCorporate      = false
      $user.isCorporateAdmin = false
      $user.isLogged         = false
      $user.costCenter       = null
      $user.lang             = ""

    loadFromCookies : (rtaxi) ->
      $user.rtaxi            = rtaxi
      $user.token            = ipCookie "booking_token_#{$user.rtaxi}"
      $user.firstName        = ipCookie "booking_firstName_#{$user.rtaxi}"
      $user.lastName         = ipCookie "booking_lastName_#{$user.rtaxi}"
      $user.email            = ipCookie "booking_email_#{$user.rtaxi}"
      $user.phone            = ipCookie "booking_phone_#{$user.rtaxi}"
      $user.isLogged         = ipCookie "booking_isLogged_#{$user.rtaxi}"
      $user.isLogged         = false unless $user.isLogged?
      $user.id               = ipCookie "booking_id_#{$user.rtaxi}"
      $user.isCorporate      = ipCookie "booking_isCorporate_#{$user.rtaxi}"
      $user.isCorporateAdmin = ipCookie "booking_isCorporateAdmin#{$user.rtaxi}"
      $user.costCenter       = ipCookie "booking_costCenter_#{$user.rtaxi}"
      $user.lang             = ipCookie "booking_lang_#{$user.rtaxi}"

    saveToCookies : ->
      ipCookie "booking_token_#{$user.rtaxi}", $user.token
      ipCookie "booking_firstName_#{$user.rtaxi}", "#{$user.firstName}"
      ipCookie "booking_lastName_#{$user.rtaxi}", "#{$user.lastName}"
      ipCookie "booking_isLogged_#{$user.rtaxi}", $user.isLogged
      ipCookie "booking_email_#{$user.rtaxi}", $user.email
      ipCookie "booking_phone_#{$user.rtaxi}", $user.phone
      ipCookie "booking_id_#{$user.rtaxi}", $user.id
      ipCookie "booking_isCorporate_#{$user.rtaxi}", $user.isCorporate
      ipCookie "booking_isCorporateAdmin#{$user.rtaxi}", $user.isCorporateAdmin
      ipCookie "booking_costCenter_#{$user.rtaxi}", $user.costCenter
      ipCookie "booking_lang_#{$user.rtaxi}", $user.lang

    logout : ->
      ipCookie.remove "booking_token_#{$user.rtaxi}"
      ipCookie.remove "booking_firstName_#{$user.rtaxi}"
      ipCookie.remove "booking_lastName_#{$user.rtaxi}"
      ipCookie.remove "booking_isLogged_#{$user.rtaxi}"
      ipCookie.remove "booking_email_#{$user.rtaxi}"
      ipCookie.remove "booking_phone_#{$user.rtaxi}"
      ipCookie.remove "booking_id_#{$user.rtaxi}"
      ipCookie.remove "booking_isCorporate_#{$user.rtaxi}"
      ipCookie.remove "booking_isCorporateAdmin#{$user.rtaxi}"
      ipCookie.remove "booking_costCenter_#{$user.rtaxi}"
      ipCookie.remove "booking_lang_#{$user.rtaxi}"
      $user.token            = ""
      $user.firstName        = ""
      $user.lastName         = ""
      $user.email            = ""
      $user.phone            = ""
      $user.id               = ""
      $user.isCorporate      = false
      $user.isCorporateAdmin = false
      $user.isLogged         = false
      $user.costCenter       = null
      $user.lang             = ""

    login : (response) -> 
      for key, value of response
        $user[key] = value

      # Save to cookies
      $user.saveToCookies()

