technoridesApp.controller 'employeeCtrl' , ($scope, $corporate, $routeParams, $employees, $location) ->
  $scope.corporate = $corporate
  $scope.employees = $employees

  if not $corporate.companies.company.id?
    $corporate.companies.getCompany $routeParams.corpid, $routeParams.costid
  else
    $corporate.companies.costCenters.getSingleCostCenter($routeParams.costid)

  $employees.getEmployee $routeParams.costid, $routeParams.employid
  $employees.getEmployeeHistory $routeParams.employid, 1
