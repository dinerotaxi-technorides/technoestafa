technoridesApp.factory '$webSocketAdapter',['$settings','$user','$company','$order','$map',($settings, $user,$company,$order,$map)->

  $socketHost = $settings[$settings.environment].websocket

  $webSocketAdapter =

    close : ->
      code: 3000
      reason:"User Disconnected"


    debug : $settings[$settings.environment].debug

    makeSocketUrl : ->
      host   =  $socketHost + "passenger"
      params = "?rtaxi=" + $company.rtaxi + "&id=" + $user.id + "&token=" + $user.token
      address        = host + params


    output :
      confirmationMessage : (json) ->
        action            : "messenger/ReadMessage"
        message_id        : json.message_id


      cancelTrip : ->
        action   : "CancelTrip"
        id       : $user.id
        rtaxi    : $company.rtaxi
        opid     : $order.id
        status   : "CANCELED"
        email    : $user.email
        token    : $user.token


      pullDrivers : ->
        action    : "PullDrivers"
        id        : $user.id
        rtaxi     : $company.rtaxi
        token     : $user.token
        email     : $user.email


      ping     : ->
        action : "Ping"
        id     : $user.id
        rtaxi  : $company.rtaxi
        token  : $user.token
        email  : $user.email
        lat    : $map.booking.markerOrig.coords.latitude
        lng    : $map.booking.markerOrig.coords.longitude


      fakeAceptTrip  : (message) ->
        action       : "driver/AcceptTrip"
        driver       : message.driver.id
        driverNumber : message.driver.number
        firstName    : message.driver.firstName
        lastName     : message.driver.lastName
        brandCompany : message.driver.brandCompany
        model        : message.driver.model
        plate        : message.driver.plate
        email        : message.driver.email


    input :
      pullInTransaction  : (message) ->
        coords:
          latitude  : message.lat
          longitude : message.lng

      getOrder : ->
        action : "getOperation"
        op_id  : $order.id
        token  : $user.token
        id     : $user.id
        email  : $user.email


      acceptTrip : (message) ->
        id       : message.driver
        number   : message.driverNumber
        email    : message.email
        firstName: message.firstName
        lastName : message.lastName
        carBrand : message.brandCompany
        carModel : message.model
        carPlate : message.plate


      getOperation : (message) ->
        opId       : message.id
        lat        : message.lat
        lng        : message.lng
        user_id    : $user.id
        token      : $user.token
        email      : $user.email
        status     : message.status.toLocaleLowerCase()


      pullDrivers : (message) ->
        for driver in message.drivers
          if driver?
            driverStatus = driver.status.toLocaleLowerCase()
            driverStatus = "intravel" if driverStatus != "online" && driverStatus != "offline" && driverStatus != "disconnected"
            $map.booking.drivers.push(
              latitude       : driver.lat
              longitude      : driver.lng
              id             : driver.id
              options        :
                icon         : "/common/assets/markers/driver_#{driverStatus}.png"
                labelAnchor  : "10 39"
                labelContent : ""
                labelClass   : "labelMarker"
             )


]
