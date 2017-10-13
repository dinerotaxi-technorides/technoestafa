technoridesApp.factory '$apiHandler',['$translate', '$apiAdapter','$user','$error','$window',($translate, $apiAdapter, $user, $error, $window) ->
  $apiHandler = 
    onLogin : (response, success) ->
      if success
        $user.login $apiAdapter.input.login response
        $translate.use($user.lang)
        $user.redirectByRole()
      else
        $("#preloader").hide()
        $error.showError({title:'Error ',text:'Usuario o contraseña incorrectos'})
]
