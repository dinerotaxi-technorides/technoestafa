technoridesApp.controller 'corporateCtrl' ,($scope,  $user, $api, $location, $apiHandler, $apiAdapter ,$rootScope, $settings, $window, ipCookie, $grid, $sce, $company, $translate) ->

  # Used by common
  $scope.settings = $settings
  $scope.settings.unstableVersion = false
  $api.setAdapter($apiAdapter)
  $api.setHandler($apiHandler)

  #get rtaxi from cookies
  $user.rtaxi = ipCookie "rtaxi"


  #bring user info from cookies
  $user.loadFromCookies $user.rtaxi
  $scope.grid =
    lang : $sce.trustAsResourceUrl "//cdn.jsdelivr.net/jqgrid/4.6.0/i18n/grid.locale-#{$user.lang}.js"
  $translate.use $user.lang
  if $user.isLogged and $user.isCorporateAdmin
    $scope.user = $user
    $api.send "getCompanyData", {}, ->
    #watch Route for load content
    $rootScope.$watch(
      ->
        $location.path()
      (path) ->
        $scope.activetab = path
        switch path
          when '/operations'
            $grid.show "corpHistory", $user.costCenter
          when '/billing'
            true
          when '/employees','/'
            $grid.show "corpUsers", $user.costCenter


      )

  else
    window.location = "https://#{$settings[$settings.environment].bookingLink}#/rtaxi/#{$user.rtaxi}"

  $scope.logout = ->
    rtaxi = ipCookie "rtaxi"
    ipCookie.remove "rtaxi"
    $user.logout()
    window.location = "https://#{$settings[$settings.environment].bookingLink}#/rtaxi/#{rtaxi}"

  $scope.changeLanguage = (lang) ->
    $user.lang = lang
    $translate.use $user.lang
    rtaxi = ipCookie "rtaxi"
    ipCookie.remove "booking_lang_#{rtaxi}"
    ipCookie "booking_lang_#{rtaxi}", $user.lang
