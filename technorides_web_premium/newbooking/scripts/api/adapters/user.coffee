technoridesApp.factory "api.user", ($settings, $api, $company, $filter, ipCookie, $window) ->

  $apiUrl    = $settings[$settings.environment].api
  $newApiUrl = $settings[$settings.environment].newApi

  api =
    login : (params) ->
      data =
        json :
          email    : params.data.email.toLowerCase()
          password : params.data.password
          rtaxi    : $company.info.adminMail
      $api.get({
        url: "#{$apiUrl}technoRidesBookingLoginApi"
        data: data
        code: 100
        codeName: "status"
        done: (response) ->
          response.roles = response.roles

          if response.roles is "ROLE_USER" or response.roles is "ROLE_COMPANY_ACCOUNT_EMPLOYEE"
            adapted =
              city          : response.admin_code
              companyPhone  : response.companyPhone
              company       : response.corporate_id
              costCenter    : response.cost_id
              country       : response.country
              countryCode   : response.country_code
              email         : response.email
              name          : response.first_name
              googleApiKey  : response.googleApiKey
              mobilePayment : response.has_mobile_payment
              id            : response.id
              corporate     : response.is_cc
              corporateAdmin: response.is_cc_admin
              superUser     : response.is_cc_super_admin
              requiredZone  : response.is_required_zone
              lang          : response.lang
              lastName      : response.last_name
              latitude      : response.latitude
              longitude     : response.longitude
              phone         : response.phone
              role          : response.roles
              rtaxi         : response.rtaxiId
              timeZone      : response.time_zone
              token         : response.token
              isLogged      : true
            params.done(adapted)
          else
            switch response.roles
              when 'ROLE_OPERATOR'
                role = "operator"
              when 'ROLE_MONITOR'
                role = "monitor"
              when 'ROLE_TELEPHONIST'
                role = "calltaker"
              when 'ROLE_COMPANY', 'ROLE_COMPANY_ACCOUNT'
                role = "company"
              when 'ROLE_ADMIN'
                role = "admin"

          adapted =
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
            rtaxi               : response.rtaxiId
            email               : response.email
            host                : response.host
            role                : role
            destinationRequired : response.is_required_zone
            isLogged            : true
            digitalRadio        : response.digitalRadio
            operatorDispatchMultipleTrips    : response.operatorDispatchMultipleTrips
            operatorSuggestDestination : response.operatorSuggestDestination
            blockMultipleTrips   : response.blockMultipleTrips
            showBusinessModel    : response.showBusinessModel
            businessModel        : response.businessModel
            isFareCalculatorActive: response.is_fare_calculator_enabled
            operatorCancelationReason: response.operatorCancelationReason
            isPrePaidActive: response.isPrePaidActive
          for key, item of adapted
            ipCookie "admin_user_#{key}", item, path: "/"
          #This is for changing user logout
          ipCookie "admin_user_isFromBooking", true, path: "/"

          console.warn "redirecting..."
          #redirect depending on role
          switch role
            when "operator"
              $window.location = "/dispatcher-2"
            when "monitor"
              $window.location = "/dispatcher-2"
            when "calltaker"
              $window.location = "/dispatcher-2"
            when "company"
              $window.location = "/dashboard"
            when "admin"
              #Try to login to our admin...I dont thikn so
              params.fail({status: "badboy"})

          #EMULATE BAD LOGIN
        fail: (response) ->
          params.fail(response)
      })

    getFavorites : (params) ->
      $api.get(
        data      :
          token   : params.token
          user_id : params.id
          max     : 3
        code      : 100
        codeName  : "status"
        url       : "#{$apiUrl}technoRidesOperationsApi/jq_operation_history_by_user"
        done      : (response) ->
          params.done response.result
        fail : (response) ->
          params.fail(response)

      )

    sendEmail : (params) ->
      $api.get
        data      :
          from    : params.email.email
          to      : $company.info?.adminMail
          subject : "Booking | #{params.email.subject}"
          message : "<p>From : #{params.email.name}</p><p>Phone : #{params.email.phone}</p><p>#{params.email.body}</p>"
        code      : 200
        codeName  : "status"
        url       : "#{$apiUrl}inboxApi/send_email"
        done      : (response) ->
          params.done()
        fail : (response) ->
          params.fail(response)

    contact : (params) ->
      $api.get
        data :
          from    : params.email.email
          to      : $company.info?.adminMail
          subject : "WEB contact | #{params.email.subject}"
          message : "<p>From : #{params.email.email}</p><p>Phone: #{params.email.phone}</p><br><p>#{params.email.body}</p>"
          status : params.email.userType?="PASSENGER"
        code     : 200
        codeName : "status"
        url      : "#{$apiUrl}inboxApi/send_email"
        done : ->
          params.done()
        fail : ->
          params.fail()

    registerEnterprise : (params) ->
      $api.get
        data      :
          from    : params.email.email
          to      : $company.info?.adminMail
          subject : $filter('translate')("signup.mailEnterprise.subject")
          message : "<p>From : #{params.email.name}</p><p>Phone : #{params.email.phone}</p><p>#{params.email.body}</p>"
          status  : "ENTERPRISE"
        code      : 200
        codeName  : "status"
        url       : "#{$apiUrl}inboxApi/send_email"
        done      : (response) ->
          params.done()
        fail : (response) ->
          params.fail(response)

    registerDriver : (params) ->
      $api.get
        data      :
          from    : params.email.email
          to      : $company.info?.adminMail
          subject : $filter('translate')("signup.mailDriver.subject")
          message : "<p>From : #{params.email.name} #{params.email.lastName}</p><p>Phone : #{params.email.phone}</p>"
          status  : "DRIVER"
        code      : 200
        codeName  : "status"
        url       : "#{$apiUrl}inboxApi/send_email"
        done      : (response) ->
          params.done()
        fail : (response) ->
          params.fail(response)

    signUp : (params) ->
      $api.get
        url : "#{$apiUrl}usersApi/createUserMinimal?"
        data :
          json:
            email    : params.user.email.toLowerCase()
            password : params.user.password
            phone    : params.user.phone
            name     : params.user.name
            lastName : params.user.lastName
            rtaxi    : $company.info?.adminMail
        code : 100
        codeName: "status"
        done : (response) ->
          adapted =
            city          : response.admin_code
            companyPhone  : response.companyPhone
            country       : response.country
            countryCode   : response.country_code
            email         : response.email
            name          : response.firstName
            mobilePayment : response.has_mobile_payment
            id            : response.id
            corporate     : response.is_cc
            requiredZone  : response.is_required_zone
            lang          : response.lang
            lastName      : response.lastName
            latitude      : response.lat
            longitude     : response.lng
            phone         : response.phone
            rtaxi         : response.rtaxiId
            timeZone      : response.time_zone
            token         : response.token
            useAdminCode  : response.useAdminCode
            isLogged      : true
          params.done(adapted)
        fail : (response) ->
          params.fail(response)
    edit : (params) ->
      $api.get
        url : "#{$apiUrl}usersApi/editSettings"
        data:
          firstName: params.user.name
          lastName : params.user.lastName
          phone    : params.user.phone
          token    : params.user.token
        code : 100
        codeName : "status"
        done : ->
          params.done()
        fail : (response) ->
          params.fail(response)

    editPassword : (params) ->
      $api.get
        url : "#{$apiUrl}usersApi/changePassword"
        data:
          token   : params.token
          current : params.pass.current
          newPass : params.pass.new
        code: 100
        codeName : "status"
        done : (response) ->
          params.done response
        fail : (response) ->
          params.fail response

    forgotPassword: (params) ->
      $api.get
        url : "#{$apiUrl}usersApi/forgotPasswordChangePass"
        data :
          email : params.email
          rtaxi: params.rtaxi
        code: 100
        codeName : "status"
        done : ->
          params.done()
        fail : (response) ->
          params.fail(response)
