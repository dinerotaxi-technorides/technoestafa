technoridesApp.factory '$apiAdapter',['$settings','$company','$map', '$filter', '$user', '$order',($settings, $company, $map, $filter, $user, $order) ->

  # Api and new api urls
  $apiLink    = $settings[$settings.environment].api
  $newApiLink = $settings[$settings.environment].newApi
  $auth       = $settings[$settings.environment].websocket.replace "wss", "https"
  # known succes codes

  # api resuources
  $apiAdapter =

    url :
      forgotPassword         : "#{$apiLink}usersApi/forgotPasswordChangePass?"
      registerUser           : "#{$apiLink}usersApi/createUserMinimal?"
      login                  : "#{$apiLink}usersApi/login?"
      priceCalculator        : "#{$newApiLink}costCalculator/"
      getCompanyData         : "#{$apiLink}configApi/jq_config?"
      getCompanyDataByDomain : "#{$apiLink}configApi/jq_config?"
      contactEmail           : "#{$apiLink}technoRidesEmailApi/send_mail?"
      createTrip             : "#{$apiLink}operationApi/createTrip?"
      createScheduledTrip    : "#{$apiLink}operationApi/programmedTrip?"
      getScheduledOperations : "#{$apiLink}operationApi/delay_operations"
      deleteScheduledOp      : "#{$apiLink}operationApi/cancelProgrammedTrip"
      sslCert                : $auth

    isSuccessStatus : (key, status) ->
     $codes =
      success:
        login                  : 100
        getCompanyData         : 100
        getCompanyDataByDomain : 100
        registerUser           : 100
        forgotPassword         : 100
        createTrip             : 100
        createScheduledTrip    : 100
        contactEmail           : 100
        priceCalculator        : 200
     $codes.success[key] == status


    # --INPUT-->
    input :
      getScheduledOperations : (response) ->
        data = {}
        data.operations = {}
        data.size = 0
        for op in response.result
          data.size++
          data.operations[op.id] =
            comments    : op.comments
            country     : op.country
            countryCode : op.country_code
            department  : op.department
            floor       : op.floor
            id          : op.id
            lat         : op.lat
            lng         : op.lng
            locaity     : op.locality
            street      : op.street
            number      : op.street_number
            date        : op.execution_time

        data

      getCompanyData : (response) ->
        isConfigurationRetrieved : true
        companyName              : response.companyName
        contactMail              : response.mailContacto
        companyMail              : response.username
        phone                    : response.phone
        phone1                   : response.phone1
        lang                     : response.lang
        lat                      : response.latitude
        lng                      : response.longitude
        street                   : response.pageCompanyStreet
        city                     : response.pageCompanyState
        zipCode                  : response.pageCompanyZipCode
        country                  : response.country
        countryCode              : response.countryCode
        linkedin                 : response.pageCompanyLinkedin
        facebook                 : response.pageCompanyFacebook
        twitter                  : response.pageCompanyTwitter
        rtaxi                    : response.id
        iosApp                   : response.iosUrl
        androidApp               : response.androidUrl
        status                   : response.status
        imgUrl                   : $settings.imgUrl
        aboutTitle               : response.pageCompanyTitle
        aboutText                : response.pageCompanyDescription
        apiDomain                : response.pageUrl
        pageTitle                : response.pageTitle


      getCompanyDataByDomain : (response) ->
        isConfigurationRetrieved : true
        companyName : response.companyName
        contactMail : response.mailContacto
        companyMail : response.username
        phone       : response.phone
        phone1      : response.phone1
        lang        : response.lang
        lat         : response.latitude
        lng         : response.longitude
        street      : response.pageCompanyStreet
        city        : response.pageCompanyState
        zipCode     : response.pageCompanyZipCode
        country     : response.country
        countryCode : response.countryCode
        linkedin    : response.pageCompanyLinkedin
        facebook    : response.pageCompanyFacebook
        twitter     : response.pageCompanyTwitter
        rtaxi       : response.id
        iosApp      : response.iosUrl
        androidApp  : response.androidUrl
        status      : response.status
        imgUrl      : $settings.imgUrl
        aboutTitle  : response.pageCompanyTitle
        aboutText   : response.pageCompanyDescription
        apiDomain   : response.pageUrl
        pageTitle   : response.pageTitle


      priceCalculator : (response)->
        response.amount


      login : (response) ->
        isLogged         : true
        token            : response.token
        id               : response.id
        rtaxi            : response.rtaxiId
        firstName        : response.firstName
        lastName         : response.lastName
        phone            : response.phone
        email            : response.email
        isCorporate      : response.is_cc
        isCorporateAdmin : response.is_cc_admin
        costCenter       : response.cost_id
        lang             : response.lang
      createTrip : (response) ->
        id     : response.opId
        status : "pending"


    # <--OUTPUT--
    output:
      sslCert : ->

      deleteScheduledOp : (id) ->
        id    : id
        token : $user.token


      getScheduledOperations : ->
        token : $user.token


      login : (credentials) ->
        json:
          email     : credentials.user
          password  : credentials.password
          rtaxi     : $company.companyMail


      getCompanyData : (rtaxi) ->
        id : rtaxi


      getCompanyDataByDomain : (domain) ->
        domain : domain


      registerUser : (credentials) ->
        json :
          email    : credentials.email
          password : credentials.password
          phone    : credentials.phone
          name     : credentials.name
          lastName : credentials.surname
          rtaxi    : $company.companyMail


      contactEmail : (credentials) ->
        from    : credentials.from
        to      : $company.contactMail
        subject : credentials.subject
        message : credentials.name+"\n"+credentials.phone+"\n"+credentials.message


      priceCalculator : ->
        url = "#{encodeURIComponent($user.token)}/#{encodeURIComponent($map.booking.markerOrig.coords.latitude)},#{encodeURIComponent($map.booking.markerOrig.coords.longitude)}/#{+encodeURIComponent($map.booking.markerDest.coords.latitude)},#{encodeURIComponent($map.booking.markerDest.coords.longitude)}"


      forgotPassword : (mail) ->
        email: mail
        rtaxi: $company.companyMail


      createTrip : (data) ->
        data.destination = {} unless data.destination?
        amount             : $order.amount
        token              : $user.token
        device             :
          userType         : "WEB"
          deviceKey        : navigator.userAgent

        comments           : data.others?.observations
        addressFrom        :
          country          : $company.country
          ccode            : $company.countryCode
          city             : data.origin.city
          street           : data.origin.street
          number           : data.origin.number
          floor            : data.origin.floor
          apartment        : data.origin.department
          lat              : $map.booking.markerOrig.coords.latitude.toString()
          lng              : $map.booking.markerOrig.coords.longitude.toString()
        addressTo          :
          country          : $company.country
          ccode            : $company.countryCode
          city             : data.destination.city
          street           : data.destination.street
          number           : data.destination.number
          floor            : data.destination.floor
          apartment        : data.destination.department
          lat              : $map.booking.markerDest.coords.latitude.toString()
          lng              : $map.booking.markerDest.coords.longitude.toString()
        options            :
          messaging        : false
          pet              : false
          airConditioning  : false
          smoker           : false
          specialAssistant : false
          luggage          : false
          vip              : false
          airport          : false
          invoice          : false


      createScheduledTrip : (data) ->
        data.destination = {} unless data.destination?
        type               : "email"
        is_web_user        : true
        token              : $user.token
        device             :
          userType         : "WEB"
          deviceKey        : navigator.userAgent
        comments           : data.others.observations
        user               :
          email            : $user.email
          phone            : $user.phone
          first_name       : $user.firstName
          last_name        : $user.lastName
        addressFrom        :
          country          : $company.country
          ccode            : $company.countryCode
          city             : data.origin.city
          street           : data.origin.street
          number           : data.origin.number
          floor            : data.origin.floor
          apartment        : data.origin.department
          lat              : $map.booking.markerOrig.coords.latitude.toString()
          lng              : $map.booking.markerOrig.coords.longitude.toString()
        addressTo          :
          country          : $company.country
          ccode            : $company.countryCode
          city             : data.destination.city
          street           : data.destination.street
          number           : data.destination.number
          floor            : data.destination.floor
          apartment        : data.destination.department
          lat              : $map.booking.markerDest.coords.latitude.toString()
          lng              : $map.booking.markerDest.coords.longitude.toString()
        options            :
          messaging        : false
          pet              : false
          airConditioning  : false
          smoker           : false
          specialAssistant : false
          luggage          : false
          vip              : false
          airport          : false
          invoice          : false
        executionTime      : $filter('date')(data.others.date,'yyyy-MM-dd HH:mm:ss')


]
