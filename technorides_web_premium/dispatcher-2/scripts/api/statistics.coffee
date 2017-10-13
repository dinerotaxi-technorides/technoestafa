technoridesApp.factory '$statistics.adapter', ($api, $settings, $user ) ->
  $apiLink    = $settings[$settings.environment].api
  $newApiLink = $settings[$settings.environment].newApi
  adapter =
    getPassengers : (params) ->
      $api.get
        data :
          token : $user.token
          start_date: (
            new Date(
              (new Date()).setDate((new Date()).getDate() - $settings[$settings.environment].statistics.days)
            )
          ).toISOString()
          end_date  : (new Date()).toISOString()
        code     : 100
        codeName : "status"
        url      : "#{$newApiLink}passengers/amount"

        done : (response) ->
          params.done response.amount
        fail : (response) ->
    getCounters : (params) ->
      $api.get
        data:
          token : $user.token
        code     : 100
        codeName : "status"
        url      : "#{$apiLink}technoRidesUsersApi/jq_monitor_counter"
        done     : (response) ->
          params.done response
        fail     : (response) ->
          if response.status is 411
            $user.logout()
    getOperationsByStatus : (params) ->
      $api.get
        data :
          token     : $user.token
          start_date: (
            new Date(
              (new Date()).setDate((new Date()).getDate() - $settings[$settings.environment].statistics.days)
            )
          ).toISOString()
          end_date  : (new Date()).toISOString()
        codeName : "status"
        code     : 100
        url      : "#{$newApiLink}operations/status"
        done : (response) ->
          json =
            finished     : parseInt(response.operations["FINISHED"])
            canceled     : parseInt(response.operations["CANCELED"])
            inTransaction: parseInt(response.operations["IN_TRANSACTION"])

          json.total = json.finished + json.canceled + json.inTransaction

          params.done json
        fail : (response) ->
          if response.status is 411
            $user.logout()
    getOperationsByDevice : (params) ->
      $api.get
        data :
          token     : $user.token
          start_date: (
            new Date(
              (new Date()).setDate((new Date()).getDate() - $settings[$settings.environment].statistics.days)
              )
            ).toISOString()
          end_date: (new Date()).toISOString()
        code : 100
        codeName: "status"
        url: "#{$newApiLink}operations/devices"
        done : (response) ->
          json =
            web    : parseInt(response.operations["WEB"])
            android: parseInt(response.operations["ANDROID"])
            others : parseInt(response.operations["OTHER"] + 1)

          params.done json
        fail : (response) ->
          if response.status is 411
            $user.logout()
    getOperationsByDate   : (params) ->
      $api.get
        data:
          token : $user.token
        code     : 100
        codeName : "status"
        url      : "#{$newApiLink}operations/weeklyDigest"
        done     : (response) ->
          params.done response
        fail     : (response) ->
          if response.status is 411
            $user.logout()
    getOperationsEarnings : (params) ->
      $api.get
        data:
          token : $user.token
          start_date: (
            new Date(
              (new Date()).setDate((new Date()).getDate() - $settings[$settings.environment].statistics.days)
            )
          ).toISOString()
          end_date  : (new Date()).toISOString()
        code : 100
        codeName : "status"
        url:"#{$newApiLink}operations/earnings"
        done : (response) ->
          params.done response
        fail : (response) ->
          if response.status is 411
            $user.logout()
