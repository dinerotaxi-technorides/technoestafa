technoridesApp.factory '$apiHandler',['$translate', '$location', '$apiAdapter','$user','$map','$error','$webSocket','$statistics','$company','$cookieStore','$price',($translate, $location, $apiAdapter, $user, $map, $error, $webSocket, $statistics,$company, $cookieStore, $price) ->

  $apiHandler =
    onSslCert : (response, success) ->
      $webSocket.connect()

    onLogin : (response, success) ->
      if success
        $user.login $apiAdapter.input.login response

        $map.dispatcher.center =
          latitude  : $user.latitude
          longitude : $user.longitude

        $map.dispatcher.markerHome.coords.latitude  = $user.latitude
        $map.dispatcher.markerHome.coords.longitude = $user.longitude

        $map.dispatcher.markerHome.options          =
          labelContent : "#{$user.company}"
          labelClass: 'maplabelhome'
          labelAnchor: "10 0"
          labelInBackground: false
          optimized: false
          draggable: false

        $webSocket.connect()
        $translate.use($user.lang)
      else
        $error.showError({title:'Error ',text:'Usuario o contraseña incorrectos'})


    onGetCounters: (response, success) ->
      response = $apiAdapter.input.getCounters response

      $statistics.data.operations.total = response.operations
      $statistics.data.passengers.total = response.passengers

      $statistics.menu.others.draw()


    onGetScheduledTrips : (response, success)  ->
      $apiAdapter.input.getScheduledTrips response


    onGetOperationsByStatus : (response, success) ->
      if response.status is 411
        $user.logout()
      else
        $statistics.data.operations.byStatus = $apiAdapter.input.getOperationsByStatus response

        total = $statistics.data.operations.byStatus.finished + $statistics.data.operations.byStatus.canceled + $statistics.data.operations.byStatus.inTransaction

        $statistics.data.operations.byStatus.percents =
          finished     : ($statistics.data.operations.byStatus.finished * 100) / total
          canceled     : ($statistics.data.operations.byStatus.canceled * 100) / total
          inTransaction: ($statistics.data.operations.byStatus.inTransaction * 100) / total

        $statistics.grid.operations.byStatus.draw()


    onGetOperationsByDevice : (response, success) ->
      if response.status is 411
        $user.logout()
      else
        $statistics.data.operations.byDevice = $apiAdapter.input.getOperationsByDevice response
        $statistics.grid.operations.byDevice.draw()


    onGetOperationsByDate : (response, success) ->
      if response.status is 411
        $user.logout()
      else
        $statistics.data.operations.byDate = $apiAdapter.input.getOperationsByDate response
        $statistics.grid.operations.byDate.draw()


    onGetOperationsEarnings : (response, success) ->
      if response.status is 411
        $user.logout()
      else
        $statistics.data.operations.earnings = $apiAdapter.input.getOperationsEarnings response
        $statistics.grid.operations.earnings.draw()


    onGetPassengers : (response, success) ->
      if response.status is 411
        $user.logout()
      else
        $statistics.data.others.passengers = $apiAdapter.input.getPassengers response
        $statistics.grid.others.passengers.draw()


    onCancelScheduledOperation : (response, success) ->
      $company.operations[response.opId].status = "canceled"
      $company.operations[response.opId].shown  = false


    onAssignScheduledOperation : (response, success) ->


    onCreateOperation : (response, success) ->
      $("#preloader").hide()
      $(".spinner").hide()

    onCreateScheduledOperation : (response, success) ->


    onUpdateSugestions : (response, success) ->
      if success
        $apiAdapter.input.updateSugestions response


    onUpdateFavoritesOrigin : (response, success) ->
      if success
        $apiAdapter.input.updateFavoritesOrigin response


    onSendEmail : (response, success) ->


    onGetParkings: (response, success) ->
      if success
        $apiAdapter.input.getParkings(response)
        if $cookieStore.get("options-parkings")?
          if $cookieStore.get("options-parkings")
            $map.dispatcher.toggleMarkers("parkings")

    onGetParkingPositions : (response, success) ->
      if response.status is 411
        $user.logout()
    onGetZones : (response, success) ->
      $apiAdapter.input.getZones(response)
      if $cookieStore.get("options-zones")?
        if $cookieStore.get("options-zones")
          $map.dispatcher.toggleMarkers("zones")


    onGetCompanyConfiguration : (response, success) ->
      $apiAdapter.input.getCompanyConfiguration response


    onOperationFlow : (response, success) ->

    onPriceCalculator : (response, success) ->
      $price.object = $apiAdapter.input.priceCalculator response

]
