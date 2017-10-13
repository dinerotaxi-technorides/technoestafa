technoridesApp.controller 'signupCtrl' ,($scope, $user, $company, $settings, $location, $modal, $facebook, $window) ->
  $scope.user = $user
  $scope.company = $company
  $scope.settings = $settings
  $scope.modal = $modal
  $scope.forgotPassword = false
  $scope.facebook = $facebook
  # i.e.: /rtaxi/16887 (iframe) get rtaxi by iframe
  path = $location.path()
  unless $company.info?
    $company.rtaxi = path.split("/")[2] if (/\/rtaxi\/.+/g).test(path)
    $location.path "/"
    $company.getInfo()
  $user.cookie.load($company.rtaxi)
  if $user.isLogged
    if $user.corporateAdmin
      $location.path "/corporate"
    else
      $location.path "/booking"
  #initializing facebook API
  FB.init
    appId: '1377421255911919',#App id from company config
    status: true,
    cookie: true,
    xfbml: true,
    version: 'v2.3'
  $scope.forgotToggle = () ->
    $scope.forgotPassword = !$scope.forgotPassword
