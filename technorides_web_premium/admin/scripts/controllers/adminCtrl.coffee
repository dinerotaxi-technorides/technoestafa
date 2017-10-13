technoridesApp.controller 'adminCtrl', ($scope, $user, $route, $modal, $settings, $paginator, $timeout) ->
  $scope.paginator = $paginator
  $scope.modal = $modal
  $scope.user = $user
  $user.loadFromCookies()
  $scope.route = $route
  $scope.settings = $settings
  if not $user.isLogged
    $window.location = "/login"

  $scope.$on 'modalApply', ->
    $scope.$apply ->
      $scope.modal = $modal


  $scope.initTooltips = ->
    $timeout(
      ->
        $("i[title]").tooltip()
        false
      ,
        300
      ,
        true
    )
