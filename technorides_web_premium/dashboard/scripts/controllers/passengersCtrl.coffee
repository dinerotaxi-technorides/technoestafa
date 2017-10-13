technoridesApp.controller 'passengersCtrl' , ($scope, $routeParams, $passengers) ->
  $scope.passengers = $passengers
  $passengers.get()
