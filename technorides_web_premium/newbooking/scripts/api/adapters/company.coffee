technoridesApp.factory 'company.api', ($api, $location, $settings, $filter) ->
  $url     = $settings[$settings.environment].api

  $adapter =
    getInfo : (params) ->
      console.log(params)
      console.log( "<<<<<<")
      $api.get(
        data :
          subdomain : "gotrans"
        url : "#{$url}configApi/jq_config"
        code : 100
        codeName : "status"
        done : (response) ->
          adapted =
            adminCode     : response.admin1Code
            android       : response.androidUrl
            name          : response.companyName
            country       : response.country
            countryCode   : response.countryCode
            currency      : response.currency
            rtaxi         : response.id
            imgUrl        : $settings.imgUrl
            ios           : response.iosUrl
            lang          : response.lang
            lat           : response.latitude
            lng           : response.longitude
            email         : response.mailContacto
            description   : response.pageCompanyDescription
            facebook      : response.pageCompanyFacebook
            linkedin      : response.pageCompanyLinkedin
            logo          : response.pageCompanyLogo
            state         : response.pageCompanyState
            street        : response.pageCompanyStreet
            title         : response.pageCompanyTitle
            twitter       : response.pageCompanyTwitter
            web           : response.pageCompanyWeb
            zipCode       : response.pageCompanyZipCode
            pageTitle     : response.pageTitle
            pageUrl       : response.pageUrl
            phone         : response.phone
            bookingPhone  : response.phone1
            timeZone      : response.timeZone
            adminMail     : response.username
            zoho          : response.zoho
            businessModel : response.businessModel
          params.done(adapted)
        fail : (response) ->

      )
    getStats : (params) ->
      $api.get
        data :
          token : params.token
          corporate_id: params.corporate_id
        url  : "#{$url}technoRidesCorporateUserApi/dashboard_user_admin_corporate"
        done : (response) ->
          adapted = {}
          adapted.payments = response.payments
          adapted.operations = response.operations
          adapted.operationsByShift = []
          adapted.expensesByMonth = []
          for key, value of response.operations_by_time
            adapted.operationsByShift.push
              label : $filter('translate')("corporate.dashboard.#{response.operations_by_time[key].label}")
              value : response.operations_by_time[key].value
          for key, value of response.expenses_by_month
            adapted.expensesByMonth.push
              y : $filter('translate')("corporate.dashboard.months.#{key}")
              b : response.expenses_by_month[key]

          params.done adapted
        fail : (response) ->
