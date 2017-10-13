technoridesApp.controller 'loginCtrl' ,['$scope','$api','$apiHandler','$apiAdapter','$user','$window', '$settings','$cookieStore','$translate',($scope, $api, $apiHandler, $apiAdapter, $user, $window, $settings,$cookieStore, $translate) ->
  # Used by common
  $scope.settings = $settings

  $api.setAdapter($apiAdapter)
  $api.setHandler($apiHandler)
  
  if $cookieStore.get("lang")?
    $translate.use($cookieStore.get("lang"))

  $scope.user       = $user

  $user.loadFromCookies()

  if $user.isLogged
    $user.redirectByRole()

  $scope.login = (credentials) ->
    $("#preloader").show()
    $api.send 'login', credentials
]
