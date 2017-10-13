technoridesApp.factory '$autocomplete.adapter', ($api, $settings, $user, $map, $http) ->
  $url     = $settings[$settings.environment].api
  $adapter =
    autocompletePassengers : (params) ->
      $api.get(
        data     :
          token  : $user.token
          type   : params.type
          term   : params.query
        code     : 100
        codeName : "status"
        url      : "#{$url}technoRidesUsersApi/jq_get_user_by"
        done     : (response) ->
          params.done response.rows
      )

    autocompleteFavorites : (params) ->
      $api.get(
        data      :
          token   : $user.token
          user_id : params.user
          max     : 3
        code      : 100
        codeName  : "status"
        url       : "#{$url}technoRidesOperationsApi/jq_operation_history_by_user"
        done      : (response) ->
          params.done response.result
      )

    autocompleteAddress : (params) ->
      #Pasamanos a $map
      params.user = $user
      $map.geolocalize(params)

    geolocate : (params) ->
      unless params.address?
        return

      address = "#{params.address} #{$user.country}"

      bDist  = 0.001
      latMax = $user.latitude + bDist
      latMin = $user.latitude - bDist
      lngMax = $user.longitude + bDist
      lngMin = $user.longitude - bDist
      $map.geolocalize
        address: address
        done: params.done
        user : $user
