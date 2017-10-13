technoridesApp.controller 'costCenterCtrl' , ($scope, $corporate, $routeParams, $location, $employees, $operations) ->
  $scope.operations = $operations
  $scope.corporate = $corporate
  $scope.employees = $employees
  #if company is not set, lets bring it on(and as a callback we take the cost center as well), else we search specific costcenter
  if not $corporate.companies.company.id?
    $corporate.companies.getCompany $routeParams.corpid, $routeParams.costid
  else
    $corporate.companies.costCenters.getSingleCostCenter($routeParams.costid)

  #check if is newInvoice
  end = $location.path().slice(-3)
  
  if end is "new"
    $corporate.companies.costCenters.invoices.setNewInvoice()
  