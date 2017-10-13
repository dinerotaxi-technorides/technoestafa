technoridesApp.controller 'loginCtrl' ,($scope, $translate, $user, $company, $settings, $location, $map, $operation, $modal, $animate, $timeout, $filter) ->
  $scope.map = $map
  $scope.user = $user
  $translate.use "en"
  $scope.company = $company
  $scope.settings = $settings
  $scope.modal = $modal
  $scope.forgotPassword = false
  $scope.featTab = 1
  $scope.featTab2 = 1
  $scope.workTab = 1
  $scope.featSubTab = 1
  $scope.page = "home"
  $scope.email =
    userType : "PASSENGER"
  $scope.forgotToggle = () ->
    $scope.forgotPassword = !$scope.forgotPassword

  $scope.changePage = (newpage) ->
    $scope.email.userType = $filter('uppercase')(newpage)
    $scope.page = newpage
    $scope.userType = newpage
    $scope.featTab = 1
    $scope.workTab = 1
    $scope.featSubTab = 1
    $scope.featTab2 = 1
    $("html, body").animate({ scrollTop: 0 }, "slow")
    false
  $scope.changeLang = (lang) ->
    $company.info.lang = lang
    $translate.use lang

  $scope.resetForm = ->
    $scope.email.name = ""
    $scope.email.email = ""
    $scope.email.phone = ""
    $scope.email.subject = ""
    $scope.email.body = ""
    true
  $scope.changeTabSlider = (newTab) ->
    if $scope.featTab > newTab
      $scope.featTab = newTab
    else
      $scope.featTab = newTab
  # i.e.: /rtaxi/16887 (iframe) get rtaxi by iframe
  path = $location.path()
  # console.log($location)
  unless $company.info?
    # console.log($company)
    # console.log(path);
    $company.rtaxi = path.split("/")[2] if (/\/rtaxi\/.+/g).test(path)
    # console.log($company.rtaxi);
    $location.path "/"
    $company.getInfo()
    # console.log('>>>>>');
  else
    # console.log('puto mil puto2');
    $translate.use $company.info.lang
    $map.initialize "map",
      latitude  : $company.info.lat
      longitude : $company.info.lng
      zoom      : 16
      mapTypeId : "mapbox.streets"#google.maps.MapTypeId.ROADMAP

    # Marker options
    options =
      position  : L.latLng($company.info.lat, $company.info.lng)
      icon      : "/common/assets/markers/booking/home.png"
      doCluster : false
    $map.markers = {}
    # Add company marker
    $map.addMarker "company", "home", options
    $(window).resize ->
      $map.map.setCenter($company.info.lat, $company.info.lng)


  $user.cookie.load($company.rtaxi)
  if $user.isLogged
    if $user.corporateAdmin
      $location.path "/corporate"
    else
      $location.path "/booking"
