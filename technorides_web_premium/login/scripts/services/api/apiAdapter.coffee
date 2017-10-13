technoridesApp.factory '$apiAdapter',['$settings','$analytics',($settings, $analytics) ->
  # Api and new api urls
  $apiLink                = $settings[$settings.environment].api

  $apiAdapter =
    isSuccessStatus : (key, status) ->
      $codes =
        success:
          login                   : 100

      $codes.success[key] == status

    url :
      login  : "#{$apiLink}technoRidesLoginApi/login"
    input :

      login : (response) ->
        role = "default"
        console.log response.roles.split(",")[0]
        switch response.roles.split(",")[0]
          when 'ROLE_OPERATOR'
            role = "operator"
            $analytics.eventTrack("login-#{role}", {category: 'login', label: "#{role}" })
          when 'ROLE_MONITOR'
            role = "monitor"
            $analytics.eventTrack("login-#{role}", {category: 'login', label: "#{role}" })
          when 'ROLE_TELEPHONIST'
            role = "calltaker"
            $analytics.eventTrack("login-#{role}", {category: 'login', label: "#{role}" })
          when 'ROLE_COMPANY', 'ROLE_COMPANY_ACCOUNT'
            role = "company"
            $analytics.eventTrack("login-#{role}", {category: 'login', label: "#{role}" })
          when 'ROLE_ADMIN'
            role = "admin"
            $analytics.eventTrack("login-#{role}", {category: 'login', label: "#{role}" })
          else
            role = "invalid"
            $analytics.eventTrack("login-#{role}", {category: 'login', label: "#{role}" })

        token               : response.token
        lang                : response.lang
        latitude            : response.latitude
        longitude           : response.longitude
        country             : response.country
        timeZone            : response.time_zone
        adminCode           : response.admin_code
        countryCode         : response.country_code
        id                  : response.id
        firstName           : response.first_name
        lastName            : response.last_name
        company             : response.company
        rtaxi               : response.rtaxi
        email               : response.email
        host                : response.host
        role                : role
        destinationRequired : response.is_required_zone
        isLogged            : true
        isFromBooking       : response.rtaxiId
        digitalRadio        : response.digitalRadio
        operatorDispatchMultipleTrips        : response.operatorDispatchMultipleTrips
        operatorSuggestDestination : response.operatorSuggestDestination
        blockMultipleTrips   : response.blockMultipleTrips
        showBusinessModel    : response.showBusinessModel
        businessModel        : response.businessModel
        isFareCalculatorActive: response.is_fare_calculator_enabled
        operatorCancelationReason: response.operatorCancelationReason
        isPrePaidActive: response.isPrePaidActive
        chatEnabled    : response.is_chat_enabled
    output :
      login : (credentials) ->
        unless credentials?
          credentials = {}
        json :
          email : credentials.user
          password: credentials.password
]
