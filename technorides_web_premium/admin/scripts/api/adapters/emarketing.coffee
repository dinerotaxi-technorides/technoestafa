technoridesApp.factory 'marketing.api', ($user, $settings, $api) ->
  $url = $settings[$settings.environment].api
  $adapter =
    get: (params) ->
      $api.get
        url : "#{$url}technoRidesAdminApi/jq_email_config_list"
        data :
          token   : $user.token
          rows    : 15
          page    : params.data.page?=1
          sidx    : "name"
          sord    : "asc"
          searchField:  params.data.searchField
          searchString: params.data.searchString
        done: (response) ->
          if response.rows?
            adapted =
              list : []
              page : response.page
              pages : _.range response.total
            for row in response.rows
              adapted.list.push
                name    : row.cell[0]
                subject : row.cell[1]
                body    : row.cell[2]
                lang    : row.cell[3]
                user    : row.cell[4]
                enabled : row.cell[5]
                id      : row.id
            params.done(adapted)
          else
            params.fail(response)
        fail: (response) ->

    preview : (params) ->
      $api.get
        url : "#{$url}technoRidesAdminApi/jq_email_config_get"
        data :
          token    : $user.token
          id_email : params.id
        code : 100
        codeName : "status"
        done : (response) ->
          params.done response.body
        fail : ->

    edit : (params) ->
      $api.postJson
        url : "#{$url}technoRidesAdminApi/jq_email_config_edit"
        code : "OK"
        codeName : "state"
        data :
            token     : $user.token
            oper      : params.oper
            name      : params.email.name
            lang      : params.email.lang
            subject   : params.email.subject
            isEnabled : params.email.enabled
            id        : params.email.id?=null
            body      : params.email.body



        done: (response) ->
          params.done()
        fail: (response) ->
