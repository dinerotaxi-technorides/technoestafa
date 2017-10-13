technoridesApp.controller 'corporateCtrl' , ($scope, $corporate, $paginator, $company) ->
  $scope.corporate = $corporate
  $corporate.companies.company = {}

  $scope.paginator = $paginator
  $scope.paginator.model = $corporate.companies
  $scope.paginator.model.get 1
