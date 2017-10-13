technoridesApp.controller 'invoiceCtrl', ($scope, $routeParams, $corporate, $user) ->
  $scope.corporate = $corporate
  $scope.user = $user
  #if company is not set, lets bring it on(and as a callback we take the cost center as well), else we search specific costcenter
  if not $corporate.companies.company.id?
    $corporate.getInvoiceConfig(->
      $corporate.companies.getCompany($routeParams.corpid, $routeParams.costid, $routeParams.invid)
    )
  else
    $corporate.getInvoiceConfig( ->
      $corporate.companies.costCenters.getSingleCostCenter($routeParams.costid, $routeParams.invid)
    )
  $scope.calculateDiscount = ->
     $corporate.companies.costCenters.invoices.invoice.discount = ($corporate.companies.costCenters.invoices.invoice.discountPercentage * $corporate.companies.costCenters.invoices.invoice.subtotal) / 100
