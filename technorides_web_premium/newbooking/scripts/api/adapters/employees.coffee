technoridesApp.factory 'employees.api', ($api, $location, $settings, $user) ->
  $url     = $settings[$settings.environment].api
  $adapter =
    get : (params) ->
      $api.get
        url : "#{$url}technoRidesCorporateUserApi/jq_corporate_user_list"
        data :
          sord    : params.order
          sidx    : "firstName,lastName"
          search  : params.search
          filter  : params.filter
          id_cost : $user.costCenter
          token   : $user.token
        code : 100
        codeName : "status"
        done : (response) ->
          adapted =
            list : []
            page  : response.page
            pages : response.total
          for row in response.rows
            adapted.list.push
              email    : row.cell[0]
              name     : row.cell[2]
              lastName : row.cell[3]
              phone    : row.cell[4]
              admin    : row.cell[5]
              enabled  : row.cell[6]
              id       : row.id
              superAdmin: row.cell[7]
          params.done adapted

        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.fail()

    activate : (params) ->
      $api.get
        data :
          user_id : params.id
          token : $user.token
        url : "#{$url}technoRidesCorporateUserApi/jq_corporate_user_activate"
        codeName: "status"
        code : 100
        done : ->

        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.fail()

    getOperations : (params) ->
      $api.get
        data :
          token: $user.token
          page: params.page
          searchField: "user_id"
          searchString: params.id
          searchOper: "eq"
        url : "#{$url}technoRidesOperationsApi/jq_company_operation_history"
        code : 100
        codeName : "status"
        done : (response) ->
          adapted =
            list : []
            page : response.page
            pages: response.total
          for row in response.rows
            adapted.list.push(
              id           : row.cell[0]
              date         : new Date(row.cell[1])
              name         : row.cell[2]
              lastName     : row.cell[3]
              driver :
                email      : row.cell[4]
              phone        : row.cell[5]
              address  :
                from:
                  street : row.cell[6]
                  coords :
                    lat : row.cell[14]
                    lng : row.cell[15]
                to:
                  street:   row.cell[9]
                  coords :
                    lat : row.cell[10]
                    lng : row.cell[11]
                comments : row.cell[12]
                calification : row.cell[13]
                status : row.cell[10]
              ammount      : row.cell[11]
              device       : row.cell[16]
              operator     : row.cell[17]
              options :
                courier : row.cell[18]
                pet     : row.cell[19]
                airConditioning : row.cell[20]
                smoker : row.cell[21]
                specialAssistance : row.cell[22]
                luggage : row.cell[23]
                airport :  row.cell[24]
                vip     : row.cell[25]
                invoice : row.cell[26]
            )
          params.done adapted
        fail : ->
          if response.status is 411
            $user.logout()
          else
            params.fail()
    edit : (params) ->
      $api.get
        code : "OK"
        codeName : "state"
        url : "#{$url}technoRidesCorporateUserApi/jq_admin_corporate_user_edit"
        data :
          id_cost            : $user.costCenter
          token              : $user.token
          username           : params.employee.email
          password           : params.employee.password
          firstName          : params.employee.name
          lastName           : params.employee.lastName
          phone              : params.employee.phone
          agree              : "on"
          admin              : if params.employee.admin then "on" else "off"
          oper               : "edit"
          corporateSuperUser : if params.employee.superAdmin then "on" else "off"
          id                 : params.employee.id
        done : () ->
          params.done()
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.fail()

    add : (params) ->
      $api.get
        url : "#{$url}technoRidesCorporateUserApi/jq_admin_corporate_user_edit"
        code : "OK"
        codeName : "state"
        data :
          id_cost  : $user.costCenter
          token    : $user.token
          username : params.employee.email
          password : params.employee.password
          firstName: params.employee.name
          lastName : params.employee.lastname
          phone    : params.employee.phone
          agree    : "on"
          admin    : if params.employee.admin then "on" else "off"
          corporateSuperUser : "off"
          oper     : "add"
          id       : "_empty"
        done : ->
          params.done()
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.fail()

    getMetrics : (params) ->
      $api.get
        url : "#{$url}/technoRidesCorporateUserApi/user_corporate_metrics"
        data:
          token: $user.token
          user_id: params.id
        done : (response) ->
          adapted =
            operations: response.user_metrics.opertions
            amount: response.user_metrics.amount

          params.done adapted

        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.fail()
