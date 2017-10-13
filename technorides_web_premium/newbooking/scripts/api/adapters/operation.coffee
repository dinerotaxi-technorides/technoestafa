technoridesApp.factory 'operation.api', ($api, $location, $settings, $user, $company, $filter) ->
  $url     = $settings[$settings.environment].api
  $newApi  = $settings[$settings.environment].newApi
  $adapter =

    create : (params) ->
      adapted =
        amount             : params.operation.estimatedPrice
        token              : $user.token
        device             :
          userType         : "WEB"
          deviceKey        : navigator.userAgent
        comments           : params.operation.comments
        addressFrom        :
          number           : ""
          country          : $company.info.country
          ccode            : $company.info.countryCode
          city             : $company.info.adminCode
          street           : params.operation.origin.address
          floor            : params.operation.origin.floor?=""
          apartment        : params.operation.origin.apartment?=""
          lat              : params.operation.origin.coords.latitude.toString()
          lng              : params.operation.origin.coords.longitude.toString()
        addressTo          :
          number           : ""
          country          : $company.info.country
          ccode            : $company.info.countryCode
          city             : $company.info.adminCode
          street           : params.operation.destination.address?=""
          floor            : params.operation.destination.floor?=""
          apartment        : params.operation.destination.apartment?=""
          lat              : params.operation.origin.coords.latitude.toString()
          lng              : params.operation.origin.coords.longitude.toString()
        options            :
          messaging        : params.operation.options.courier
          pet              : params.operation.options.pet
          airConditioning  : params.operation.options.airConditioning
          smoker           : params.operation.options.smoker
          specialAssistant : params.operation.options.specialAsistance
          luggage          : params.operation.options.lugage
          vip              : params.operation.options.vip
          airport          : params.operation.options.airport
          invoice          : params.operation.options.invoice


      $api.get({
        code     : 100
        codeName : "status"
        data     : adapted
        url      : "#{$url}operationApi/createTrip"
        done     : (response) ->
          params.done(response)
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.fail()
      })


    createScheduled : (params) ->
      adapted =
        amount             : ""
        token              : $user.token
        device             :
          userType         : "WEB"
          deviceKey        : navigator.userAgent
        comments           : params.operation.comments
        addressFrom        :
          number           : ""
          country          : $company.info.country
          ccode            : $company.info.countryCode
          city             : $company.info.adminCode
          street           : params.operation.origin.address
          floor            : params.operation.origin.floor?=""
          apartment        : params.operation.origin.apartment?=""
          lat              : params.operation.origin.coords.latitude.toString()
          lng              : params.operation.origin.coords.longitude.toString()
        addressTo          :
          number           : ""
          country          : $company.info.country
          ccode            : $company.info.countryCode
          city             : $company.info.adminCode
          street           : params.operation.destination.address?=""
          floor            : params.operation.destination.floor?=""
          apartment        : params.operation.destination.apartment?=""
          lat              : params.operation.origin.coords.latitude.toString()
          lng              : params.operation.origin.coords.longitude.toString()
        options            :
          messaging        : params.operation.options.courier
          pet              : params.operation.options.pet
          airConditioning  : params.operation.options.airConditioning
          smoker           : params.operation.options.smoker
          specialAssistant : params.operation.options.specialAsistance
          luggage          : params.operation.options.lugage
          vip              : params.operation.options.vip
          airport          : params.operation.options.airport
          invoice          : params.operation.options.invoice
        executionTime      : $filter('date') params.operation.date,'yyyy-MM-dd HH:mm:ss a'


      $api.get({
        code     : 100
        codeName : "status"
        data     :
          adapted
        url      : "#{$url}operationApi/programmedTrip?"
        done     : (response) ->
          params.done(response)
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.fail()
      })

    getScheduled: (params) ->

      $api.get(
        url : "#{$url}operationApi/delay_operations"
        data :
          token: $user.token
        done : (response) ->
          adapted = []
          for row in response.result
            adapted.push
              adminCode   : row.admin_1_code
              comments    : row.comments
              country     : row.country
              countryCode : row.country_code
              department  : row.department
              date        : new Date(row.execution_time)
              floor       : row.floor
              id          : row.id
              latitude    : row.lat
              longitude   : row.lng
              locality    : row.locality
              street      : row.street
              number      : row.street_number
              placeTo        :
                admin1Code   : row.placeTo.admin1Code
                appartment   : row.placeTo.appartment
                country      : row.placeTo.country
                floor        : row.placeTo.floor
                lat          : row.placeTo.lat
                lng          : row.placeTo.lng
                locality     : row.placeTo.locality
                street       : row.placeTo.street
                streetNumber : row.placeTo.streetNumber
          params.done(adapted)
        fail : (response) ->
          if response.status is 411
            $user.logout()
      )

    getHistory : (params) ->
      $api.get
        url : "#{$url}tripApi/getListTrips/"
        data:
          token: $user.token
        code : 100
        codeName : "status"
        done : (response) ->
          adapted = []
          ids = []
          for op in response.history
            adapted.push
              date    : new Date op.createdDate
              options : op.options
              address :
                from :
                  floor     : op.placeFrom.floor
                  street    : op.placeFrom.street
                  apartment : op.placeFrom.appartment
                  country   : op.placeFrom.country
                  lat       : op.placeFrom.lat
                  lng       : op.placeFrom.lng
                  locality  : op.placeFrom.locality
                to   :
                  street    : op.placeTo.street
                  apartment : op.placeTo.appartment
                  country   : op.placeTo.country
                  lat       : op.placeTo.lat
                  lng       : op.placeTo.lng
                  locality  : op.placeTo.locality
              status : op.status.toLowerCase()
              id      : op.id
              comments : op.comments

          params.done(adapted)
        fail : (response) ->
          if response.status is 1
            $user.logout()

    cancelScheduled : (params) ->
      $api.get
        url : "#{$url}operationApi/cancelProgrammedTrip"
        data:
          token : $user.token
          id : params.id
        code: 100
        codeName: "status"
        done : () ->
          params.done()
        fail : (response) ->
          if response.status is 411
            $user.logout()

    exportHistory : (params) ->
      if not params.id?
        params.id = $user.costCenter
      $api.get
        url : "#{$url}technoRidesCorporateOperationsApi/generate_report"
        data :
          token    : $user.token
          dateFrom : $filter('date')( params.data.startDate, 'yyyy-MM-dd' )
          dateTo   : $filter('date')( params.data.endDate, 'yyyy-MM-dd' )
          email    : params.data.email
          cost_id  : params.id
        code: 100
        codeName: "status"
        done: ->
        fail: ->
    calculatePrice : (params) ->
      param = "#{encodeURIComponent($user.token)}/#{params.from.latitude},#{params.from.longitude}/#{params.to.latitude},#{params.to.longitude}"
      $api.get
        url: "#{$newApi}costCalculator/#{param}"
        code: 200
        codeName  : "status"
        done : (response) ->
          params.done(response.json.amount)
        fail : () ->
          if response.status is 411
            $user.logout()
          else
            params.fail()
