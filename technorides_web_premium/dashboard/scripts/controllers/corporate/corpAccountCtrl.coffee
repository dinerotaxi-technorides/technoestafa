technoridesApp.controller 'corpAccountCtrl' , ($scope, $corporate, $routeParams) ->
  $scope.corporate = $corporate
  $corporate.companies.getCompany($routeParams.corpid)
