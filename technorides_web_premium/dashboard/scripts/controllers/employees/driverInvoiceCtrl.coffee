technoridesApp.controller 'driverInvoiceCtrl' , ($scope, $routeParams, $drivers, $location) ->
  $scope.drivers = $drivers
  if not $drivers.driver.id
    $drivers.getDriver($routeParams.id, $drivers.invoices.getInvoices)
  else
     $drivers.invoices.getInvoices()
