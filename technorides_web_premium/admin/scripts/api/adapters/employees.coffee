technoridesApp.factory "employees.api", ($settings, $api, $user) ->

    $apiUrl    = $settings[$settings.environment].api
    $newApiUrl = $settings[$settings.environment].newApi

    api =
      get: (params) ->
        $api.get(
          data      : params.data
          url       : "#{$apiUrl}technoRidesAdminApi/jq_employee_list"
          done      : (response) ->
            adapted =
              list : []
              page : response.page
              pages : _.range response.total
            for row in response.rows
              adapted.list.push
                username    : row.cell[0]
                password    : row.cell[1]
                firstName   : row.cell[2]
                lastName    : row.cell[3]
                phone       : row.cell[4]
                typeEmploy  : row.cell[5]
                agree       : row.cell[6]
                enabled     : row.cell[7]
                accountLocked : row.cell[8]
                isTestUser  : row.cell[9]
                city        : row.cell[10]
                id          : row.id

            params.done adapted
          fail      : (response) ->
            params.fail response
        )

      edit : (params) ->
        $api.get
          url : "#{$apiUrl}technoRidesAdminApi/jq_edit_customer"
          code : "OK"
          codeName : "state"
          data :
            token : $user.token
            oper  : params.oper
            username    : params.worker.username
            password    : params.worker.password
            firstName   :params.worker.firstName
            lastName    :params.worker.lastName
            phone       :params.worker.phone
            typeEmploy  :params.worker.typeEmploy
            agree       :params.worker.agree
            enabled     :params.worker.enabled
            accountLocked :params.worker.accountLocked
            isTestUser  :params.worker.isTestUser
            city        : params.worker.city
            id          :params.worker.id?=null
          done: (response) ->
            params.done()
          fail: (response) ->
