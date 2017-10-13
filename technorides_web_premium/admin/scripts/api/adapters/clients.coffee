technoridesApp.factory "clients.api", ($settings, $api, $user, $filter) ->

    $apiUrl    = $settings[$settings.environment].api
    $newApiUrl = $settings[$settings.environment].newApi

    api =
      get: (params) ->
        $api.get(
          data      : params.data
          url       : "#{$apiUrl}technoRidesAdminApi/jq_b2b_customer"
          done      : (response) ->
            adapted =
              list : []
              page : response.page
              pages : _.range response.total
            for row in response.rows
              adapted.list.push
                createdDate   : row.cell[0]
                username : row.cell[1]
                password: ""
                phone: row.cell[3]
                companyName: row.cell[4]
                lang: row.cell[5]
                mailContacto: row.cell[6]
                cars: row.cell[7]
                intervalPoolingTrip: row.cell[8]
                intervalPoolingTripInTransaction: row.cell[9]
                latitude: row.cell[10]
                longitude: row.cell[11]
                cuit: row.cell[12]
                price: row.cell[13]
                agree: row.cell[14]
                enabled: row.cell[15]
                accountLocked: row.cell[16]
                isTestUser: row.cell[17]
                city: row.cell[18]
                cityName: row.cell[18]
                wlconfig: row.cell[19]
                wlconfigName: row.cell[19]
                id: row.id

            params.done adapted
          fail      : (response) ->
            params.fail response

        )


      edit : (params) ->
        $api.get
          url : "#{$apiUrl}technoRidesAdminApi/jq_edit_b2b_customer"
          code : "OK"
          codeName : "state"
          data :
            token         : $user.token
            oper          : params.oper
            createdDate   : if params.client.createdDate? then $filter('date')(new Date(params.client.createdDate),'dd/MM/yyyy')
            username      : params.client.username
            password      : params.client.password
            phone         : params.client.phone
            companyName   : params.client.companyName
            lang          : params.client.lang
            mailContacto  : params.client.mailContacto
            cars          : params.client.cars
            intervalPoolingTrip:  params.client.intervalPoolingTrip
            intervalPoolingTripInTransaction: params.client.intervalPoolingTripInTransaction
            latitude      : params.client.latitude
            longitude     : params.client.longitude
            cuit          : params.client.cuit
            price         : params.client.price
            agree         : params.client.agree
            enabled       : params.client.enabled
            accountLocked : params.client.accountLocked
            isTestUser    : params.client.isTestUser
            city          : params.client.city
            wlconfig      : params.client.id
            id            : params.client.id?=null
          done: (response) ->
            params.done()
          fail: (response) ->
