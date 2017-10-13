technoridesApp.controller 'staticsCtrl' , ($scope, $company, $location) ->
  $scope.company = $company
  $location.path("/history")
