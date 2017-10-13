technoridesApp.factory "users.api", ($settings, $api, $user) ->

    $apiUrl    = $settings[$settings.environment].api
    $newApiUrl = $settings[$settings.environment].newApi

    api =
      get: (params) ->
        $api.get(
          data      : params.data
          url       : "#{$apiUrl}technoRidesAdminApi/jq_real_user_serching_list"
          done      : (response) ->
            adapted =
              list : []
              page : response.page
              pages : _.range response.total
            for row in response.rows
              adapted.list.push
                createdDate   :row.cell[0]
                rtaxi         :row.cell[1]
                username      :row.cell[2]
                password      :""
                firstName     :row.cell[4]
                lastName      :row.cell[5]
                phone         :row.cell[6]
                countTripsCompleted:row.cell[7]
                isFrequent    :row.cell[8]
                status        :row.cell[9]
                agree         :row.cell[10]
                enabled       :row.cell[11]
                accountLocked :row.cell[12]
                isTestUser    :row.cell[13]
                ip            :row.cell[14]
                companyName   :row.cell[15]
                lang          :row.cell[16]
                city          :row.cell[17]
                id            :row.id


            params.done adapted
          fail      : (response) ->
            params.fail response

        )

      edit : (params) ->
        $api.get
          url : "#{$apiUrl}technoRidesAdminApi/jq_edit_real_user"
          code : "OK"
          codeName : "state"
          data :
            token : $user.token
            oper  : params.oper
            createdDate   :params.user.createdDate
            rtaxi         :params.user.rtaxi
            username      :params.user.username
            password      :params.user.password
            firstName     :params.user.firstName
            lastName      :params.user.lastName
            phone         :params.user.phone
            countTripsCompleted:params.user.countTripsCompleted
            isFrequent    :params.user.isFrequent
            status        :params.user.status
            agree         :params.user.agree
            enabled       :params.user.enabled
            accountLocked :params.user.accountLocked
            isTestUser    :params.user.isTestUser
            ip            :params.user.ip
            companyName   :params.user.companyName
            lang          :params.user.lang
            city          :params.user.city
            id            :params.user.id?=null
          done: (response) ->
            params.done()
          fail: (response) ->
