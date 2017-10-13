technoridesApp.controller 'clientsCtrl', ($scope, $settings, $clients, $user, $cities, $configs, $paginator ) ->

  link = $settings[$settings.environment].api

  $scope.clients = $clients
  $scope.cities = $cities
  $scope.cities.getSelectableCities()
  $scope.configs = $configs
  $scope.configs.getWlconfigs()
  $paginator.model = $clients
  $paginator. get 1
  $scope.Date = new Date()
  # $scope.initForm = () ->
  #     $scope.clients.client.lang          = "es"
  #     $scope.clients.client.cars          = 1
  #     $scope.clients.client.intervalPoolingTrip = 20
  #     $scope.clients.client.intervalPoolingTripInTransaction = 20
  #     $scope.clients.client.latitude      = "0"
  #     $scope.clients.client.longitude     = "0"
  #     $scope.clients.client.cuit          = "0"
  #     $scope.clients.client.price         = "1"
  #     $scope.clients.client.agree         = false
  #     $scope.clients.client.enabled       = false
  #     $scope.clients.client.accountLocked = false
  #     $scope.clients.client.isTestUser    = false
