technoridesApp.factory "api.cities", ($settings, $api, $user) ->

    $apiUrl    = $settings[$settings.environment].api
    $newApiUrl = $settings[$settings.environment].newApi

    api =
      get : (params) ->
        # FIXME: code debería ser 200 y codeName "status"
        $api.get(
          data      : params.data
          url       : "#{$apiUrl}technoRidesAdminApi/jq_enabled_cities_list"
          done      : (response) ->
            adapted =
              list : []
              page : response.page
              pages : _.range response.total
            for row in response.rows
              adapted.list.push
                id   : row.id
                name : row.cell[0]
                country: row.cell[1]
                admin1Code: row.cell[2]
                locality: row.cell[3]
                countryCode: row.cell[4]
                timeZone: row.cell[5]
                northEastLatBound: row.cell[6]
                northEastLngBound: row.cell[7]
                southWestLatBound: row.cell[8]
                southWestLngBound: row.cell[9]
                enabled: row.cell[10]

            params.done adapted
          fail      : (response) ->
            params.fail response

        )

      getSelectableCities : ->
        $api.get(
          data:
            token: $user.token
            rows: 99999
            page: 0
            sidx: "name"
          done : (response) ->
            $cities.list = response.list
          fail : (response) ->
            if response.status is 411
              $user.logout()
        )


      edit : (params) ->
        $api.get
          url : "#{$apiUrl}technoRidesAdminApi/jq_enabled_cities_edit"
          code : "OK"
          codeName : "state"
          data :
            token : $user.token
            oper  : params.oper
            name  : params.city.name
            country  : params.city.Country
            admin1Code : params.city.admin1Code
            locality   : params.city.locality
            countryCode :params.city.countryCode
            timeZone: params.city.timeZone
            northEastLatBound: params.city.northEastLatBound
            northEastLngBound: params.city.northEastLngBound
            southWestLatBound: params.city.southWestLatBound
            southWestLngBound: params.city.southWestLngBound
            enabled : params.city.enabled
            id : params.city.id?=null
          done: (response) ->
            params.done()
          fail: (response) ->
