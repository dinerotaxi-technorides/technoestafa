technoridesApp.factory '$api', ($http) ->
  $api =
    get : (params) ->
      $("#preloader").fadeIn()
      $http.get params.url, params: params.data
        .success (response) ->
          $("#preloader").fadeOut()
          if params.code is response[params.codeName]
            params.done(response)
          else
            params.fail(response)
        .error (response) ->
          $("#preloader").fadeOut()
          params.fail(response)
    post : (params) ->
      $("#preloader").fadeIn()
      $http.post params.url, params.data
        .success (response) ->
          $("#preloader").fadeOut()
          if params.code is response[params.codeName]
            params.done(response)
          else
            params.fail(response)
        .error (response) ->
          $("#preloader").fadeOut()
          params.fail(response)

    postJson: (params) ->
      $("#preloader").fadeIn()
      $http.post params.url,  params.data
        .success (response) ->
          $("#preloader").fadeOut()
          if params.code is response[params.codeName]
            params.done(response)
          else
            params.fail(response)
        .error (response) ->
          $("#preloader").fadeOut()
          params.fail(response)
