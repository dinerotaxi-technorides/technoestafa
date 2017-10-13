technoridesApp.factory '$api', ($http) ->
  $api =
    get : (params) ->
      $http.get params.url, params: params.data
        .success (response) ->
          if params.code is response[params.codeName]
            params.done(response)
          else
            params.fail(response)
        .error (response) ->
          params.fail(response)
    post : ->
      $http.post params.url, params: params.data
        .success (response) ->
          if params.code is response[params.codeName]
            params.done(response)
          else
            params.fail(response)
        .error (response) ->
          params.fail(response)
