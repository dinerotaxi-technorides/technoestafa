technoridesApp.factory '$operations.adapter', ($api, $settings, $user, $map, $filter) ->
  $url  = $settings[$settings.environment].api
  $url2 = $settings[$settings.environment].newApi

  $adapter =

    relaunch : (params) ->

      if typeof params.operation.options is "undefined"
        params.operation.options = {}

      adapted =
        token              : $user.token
        amount             : params.operation.amount?=null
        type               : "email"
        is_web_user        : true
        token              : $user.token
        rtaxi              : $user.rtaxi
        device             :
          userType         : "WEB"
          deviceKey        : "Sarasa"
        comments           : params.operation.comments
        user               :
          email            : params.operation.passenger.email
          phone            : params.operation.passenger.phone
          first_name       : params.operation.passenger.name
          last_name        : params.operation.passenger.lastName
        addressFrom        :
          number           : ""
          country          : $user.country
          ccode            : $user.countryCode
          city             : $user.adminCode
          street           : params.operation.address.from.street
          floor            : params.operation.address.from.flor
          apartment        : ""
          lat              : params.operation.address.from.coords.latitude.toString()
          lng              : params.operation.address.from.coords.longitude.toString()
        addressTo          :
          number           : ""
          country          : $user.country
          ccode            : $user.countryCode
          city             : $user.adminCode
          street           : params.operation.address.to.street
          floor            : params.operation.address.to.flor
          apartment        : ""
          lat              : params.operation.address.to.coords.latitude.toString()
          lng              : params.operation.address.to.coords.longitude.toString()
        options            :
          messaging        : params.operation.options.messaging
          pet              : params.operation.options.pet
          airConditioning  : params.operation.options.airConditioner
          smoker           : params.operation.options.smoker
          specialAssistant : params.operation.options.specialAssistance
          luggage          : params.operation.options.luggage
          vip              : params.operation.options.vip
          airport          : params.operation.options.airport
          invoice          : params.operation.options.invoice
        driver_number      : null
        count_trip         :  params.operation.count_trip
        businessModel      :  params.operation.businessModel

      $api.get({
        code     : 100
        codeName : "status"
        data     :
          adapted
        url      : "#{$url}technoRidesOperationsApi/create_trip"
        done     : (response) ->
          params.done()
        fail : (response) ->
          if response.status is 411
            $user.logout()
      })

    getParkings : (params) ->
      $api.get({
        code     : 100
        codeName : "status"
        data     :

          token  : $user.token
        url      : "#{$url}technoRidesParkingApi/jq_parking"
        done     : (response) ->
          params.done(response.rows)
        fail : (response) ->
          if response.status is 411
            $user.logout()
      })

    getFareCalculator:(params) ->
      $api.get({
          code     : 100
          codeName : "status"
          data     :
            token  : $user.token
          url      : "#{$url2}fare_calculator_log/#{params.id}/0"

          done     : (response) ->
            params.done response

          fail : (response) ->
            if response.status is 411
              $user.logout()
            else
              params.done response
        })

    getParkingList : (params) ->
      $api.get(
        data     : ""
        code     : 100
        codeName : "status"
        url      : "#{$url2}parking_queue/#{params.id}?token=#{$user.token}"
        done     : (response) ->
          adapted = []
          for driver in response.events
            if driver.position > 0
              adapted.push
                email    : driver.driver_email
                id       : driver.driver_id
                lastName : driver.driver_last_name
                name     : driver.driver_name
                position : driver.position
                updated  : new Date(driver.updated_at)
          params.done(adapted)
        fail     : (response) ->
          if response.status is 411
            $user.logout()
          if response.status is 400
            params.fail()
      )

    new : (params) ->
      if typeof params.operation.options is "undefined"
        params.operation.options = {}

      unless params.operation.addressTo?
        params.operation.addressTo =
          address   : ""
          number    : ""
          floor     : ""
          apartment : ""

      unless params.operation.driver?
        params.operation.driver = null

      markerOriginPosition      = $map.getMarkerPosition "newOperation", "from"
      markerDestinationPosition = $map.getMarkerPosition "newOperation", "to"

      params.operation.addressFrom.lat = markerOriginPosition.lat()
      params.operation.addressFrom.lng = markerOriginPosition.lng()

      if params.operation.addressTo.address
        params.operation.addressTo.lat = markerDestinationPosition.lat()
        params.operation.addressTo.lng = markerDestinationPosition.lng()
      else
        params.operation.addressTo.lat = 0
        params.operation.addressTo.lng = 0



      unless params.operation.user.email? && params.operation.user.email.match(/@/)
        params.operation.user.email = "#{params.operation.user.phone}@#{$user.host}"

      unless params.operation.user.name?
        params.operation.user.name = "-"

      unless params.operation.user.surname?
        params.operation.user.surname = "-"

      adapted =
        token              : $user.token
        amount             : params.operation.price?.amount?=null
        type               : "email"
        is_web_user        : true
        token              : $user.token
        rtaxi              : $user.rtaxi
        device             :
          userType         : "WEB"
          deviceKey        : "Sarasa"
        comments           : params.operation.comments
        user               :
          email            : params.operation.user.email
          phone            : params.operation.user.phone
          first_name       : params.operation.user.name
          last_name        : params.operation.user.surname
        addressFrom        :
          number           : ""
          country          : $user.country
          ccode            : $user.countryCode
          city             : $user.adminCode
          street           : params.operation.addressFrom.address
          floor            : params.operation.addressFrom.floor
          apartment        : params.operation.addressFrom.apartment
          lat              : params.operation.addressFrom.lat.toString()
          lng              : params.operation.addressFrom.lng.toString()
        addressTo          :
          number           : ""
          country          : $user.country
          ccode            : $user.countryCode
          city             : $user.adminCode
          street           : params.operation.addressTo.address
          floor            : params.operation.addressTo.floor
          apartment        : params.operation.addressTo.apartment
          lat              : params.operation.addressTo.lat.toString()
          lng              : params.operation.addressTo.lng.toString()
        options            :
          messaging        : params.operation.options.messaging
          pet              : params.operation.options.pet
          airConditioning  : params.operation.options.airConditioner
          smoker           : params.operation.options.smoker
          specialAssistant : params.operation.options.specialAssistance
          luggage          : params.operation.options.luggage
          vip              : params.operation.options.vip
          airport          : params.operation.options.airport
          invoice          : params.operation.options.invoice
        count_trip         : params.operation.count_trip
        driver_number      : params.operation.driver_number
        businessModel      : params.operation.businessModel
        timeDelayExecution : if params.operation.executiontime? then params.operation.executiontime else
          params.operation.executiontimeCustom

      url = "#{$url}technoRidesOperationsApi/create_trip"

      if params.operation.dateDay?
        if params.operation.dateDay isnt params.operation.dateHour
          params.operation.date = new Date params.operation.dateDay
          params.operation.date.setHours params.operation.dateHour.getHours()
          params.operation.date.setMinutes params.operation.dateHour.getMinutes()


      if params.operation.date?
        adapted.executionTime = $filter('date') params.operation.date,'yyyy-MM-dd HH:mm:00 a'
        url = "#{$url}technoRidesDelayOperationsApi/create_trip"

      $api.get({
        code     : 100
        codeName : "status"
        data     :
          adapted
        url      : url
        done     : (response) ->
          params.done(adapted)
        fail : (response) ->
          if response.status is 411
            $user.logout()
      })

    getScheduled : (params) ->
      $api.get({
        data:
          token : $user.token
          searchBy : params.action
          page : params.page
          rows: params.rows
          sidx : "executionTime"
          sord: "desc"
        code : true
        codeName: "result"
        url : "#{$url}technoRidesDelayOperationsApi/jq_delay_operation_by_company"
        done: (response) ->
        fail: (response) ->

          if response.status is 411
            $user.logout()
          else
            adapted =
              list : []
              page : response.page
              pages : response.total
              records : response.records
            if response.result?
              for op in response.result
                  adapted.list.push
                    id       : op.id
                    options  : op.options
                    latitude : op.lat
                    longitude: op.lng
                    device   : op.device
                    date     : new Date(op.date)
                    created  : new Date(op.date)
                    comments : op.comments
                    driver :
                      id : op.driver_number
                    address :
                      from :
                        department  : op.placeFrom.appartment
                        country     : op.placeFrom.country
                        floor       : op.placeFrom.floor
                        coords :
                          latitude : op.placeFrom.lat
                          longitude: op.placeFrom.lng
                        locality  : op.placeFrom.locality
                        street    : op.placeFrom.street
                        number    : op.placeFrom.streetNumber
                      to:
                        department  : op.placeTo.appartment
                        country     : op.placeTo.country
                        floor       : op.placeTo.floor
                        coords :
                          latitude : op.placeTo.lat
                          longitude: op.placeTo.lng
                        locality  : op.placeTo.locality
                        street    : op.placeTo.street
                        number    : op.placeTo.streetNumber
                    substatus   : op.status.name
                    status      : "scheduled"
                    passenger :
                      city      : op.user.cityName
                      company   : op.user.companyName?=""
                      email     : op.user.email
                      name      : op.user.firstName
                      id        : op.user.id
                      corporate : op.user.isCC
                      frequent  : op.user.isFrequent
                      lastName  : op.user.lastName
                      phone     : op.user.phone
                    executiontime : op.timeDelayExecution
            params.done(adapted)
      })

    cancelScheduled: (params) ->
      $api.get({
        data :
          id : params.data.id
          token : $user.token
        code : 100
        codeName: "status"
        url : "#{$url}technoRidesDelayOperationsApi/delete_trip"
        done : (response) ->
          params.done()
        fail : (response) ->
          if response.status is 411
            $user.logout()
      })

    assignScheduled : (params) ->
      $api.get({
        data :
          driver_number   : params.data.driver
          id              : params.data.id
          token           : $user.token
        code : 100
        codeName: "status"
        url : "#{$url}technoRidesDelayOperationsApi/edit_trip"
        done : (response) ->
          params.done()
        fail : (response) ->
          if response.status is 411
            $user.logout()

      })

    editScheduled : (params) ->
            
      adapted =

        executionTime : if params.operation.executiontime? then params.operation.executiontime else
        token              : $user.token
        amount             : params.operation.price?.amount?=null
        type               : "email"
        is_web_user        : true
        token              : $user.token
        rtaxi              : $user.rtaxi
        device             :
          userType         : "WEB"
          deviceKey        : "Sarasa"
        comments           : params.operation.comments
        user               :
          email            : params.operation.user.email
          phone            : params.operation.user.phone
          first_name       : params.operation.user.name
          last_name        : params.operation.user.surname
        addressFrom        :
          number           : ""
          country          : $user.country
          ccode            : $user.countryCode
          city             : $user.adminCode
          street           : params.operation.addressFrom.address
          floor            : params.operation.addressFrom.floor
          apartment        : params.operation.addressFrom.apartment
          lat              : params.operation.addressFrom.lat.toString()
          lng              : params.operation.addressFrom.lng.toString()
        addressTo          :
          number           : ""
          country          : $user.country
          ccode            : $user.countryCode
          city             : $user.adminCode
          street           : params.operation.addressTo.address
          floor            : params.operation.addressTo.floor
          apartment        : params.operation.addressTo.apartment
          lat              : params.operation.addressTo.lat.toString()
          lng              : params.operation.addressTo.lng.toString()
        options            :
          messaging        : params.operation.options.messaging
          pet              : params.operation.options.pet
          airConditioning  : params.operation.options.airConditioner
          smoker           : params.operation.options.smoker
          specialAssistant : params.operation.options.specialAssistance
          luggage          : params.operation.options.luggage
          vip              : params.operation.options.vip
          airport          : params.operation.options.airport
          invoice          : params.operation.options.invoice
        count_trip         : params.operation.count_trip
        driver_number      : params.operation.driver
        businessModel      : params.operation.businessModel
        timeDelayExecution : if params.operation.executiontime? then params.operation.executiontime else
        executionTime      : $filter('date') params.operation.date,'yyyy-MM-dd HH:mm:00 a'
        id                 : params.operation.id

      $api.get(
        data:
          adapted
        code : 100
        codeName: "status"
        url : "#{$url}technoRidesDelayOperationsApi/editTrip"
        done : ->
          params.done()
        fail : (response) ->
          if response.status is 411
            $user.logout()
      )

    calculatePrice : (params) ->
      url = "#{encodeURIComponent($user.token)}/#{params.from.latitude()},#{params.from.longitude()}/#{params.to.latitude()},#{params.to.longitude()}"

      $api.get({
        code      : 200
        codeName  : "status"
        url       : "#{$url2}costCalculator/#{url}"

        done      : (response) ->
          if not response.json.is_zone
            zoneFrom = {}
            zoneTo   = {}
            km       = response.json.km
          else
            zoneFrom = response.json.zone_from
            zoneTo   = response.json.zone_to
            km       = null

          adapted =
            amount   : response.json.amount?=undefined
            isZone   : response.json.is_zone
            km       : km
            zoneFrom : zoneFrom
            zoneTo   : zoneTo
            route    : response.json.data_json

          params.done adapted

        fail : (response) ->
          if response.status is 411
            $user.logout()
      })
