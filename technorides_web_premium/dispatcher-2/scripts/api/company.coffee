technoridesApp.factory 'company.adapter',($api, $user, $settings) ->
  $url     = $settings[$settings.environment].api
  adapter =
    getConfig : (params) ->
      $api.get(
        data     :
          token  : $user.token
        code     : 100
        codeName : "status"
        url      : "#{$url}technoRidesConfigurationAppApi/jq_config"
        done     : (response) ->
          adapted =
            operations        :
              distanceType    : response.distanceType
              autorecieve     :
                distance      : response.distanceSearchTrip * 1000
                relaunch      : response.percentageSearchRatio
              scheduled       :
                executiontime : response.timeDelayTrip
            parking           :
              enabled         : response.parking
              distance        :
                driver        : response.parkingDistanceDriver
                passenger     : response.parkingDistanceTrip
            zones             :
              enabled         : response.hasZoneActive
            relaunchDistance  : (response.distanceSearchTrip * 1000) * response.percentageSearchRatio

          params.done(adapted)
        fail : (response) ->
          if response.status is 411
            $user.logout()
        )
    getScheduledConfig : (params) ->
      $api.get(
        data     :
          token : $user.token
        codeName : "status"
        code     : 100
        url      : "#{$url}technoRidesDelayOperationsApi/delay_operation_config_list"
        done     : (response) ->
          adapted = []
          for row in response.rows
            adapted.push
              name : "#{row.name} [#{row.timeDelayExecution} min]"
              time : row.timeDelayExecution
              id   : row.id
          params.done(adapted)
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.done []
      )
