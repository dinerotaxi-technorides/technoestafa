technoridesApp.factory '$error', ['$http','$translate',($http, $translate) ->

  $error =
    hasError  : false
    getQuotes : (num) ->
      # get quotes on the json file
      $http.get("/common/json/error-quotes.json")

      .success ($quotes) ->
        $error.quote  = $quotes[num].quote
        $error.author = $quotes[num].author


    showError : (action, status) ->
      # Make hash for translate
      $codeTitle = action+status+"Title"
      $codeText  = action+status+"Text"
      $error.hasError = true

      $translate($codeTitle).then((title) =>
        $error.title = title
      )

      $translate($codeText).then((text) =>
        $error.text = text
      )

      $error.getQuotes(Math.floor(Math.random()*3)+1)


    closeError : ->
      $error.hasError = false


]
