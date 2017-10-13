technoridesApp.controller 'driverHistoryInvoiceCtrl' , ($scope, $routeParams, $drivers, $location) ->
  $scope.drivers = $drivers
  if not $drivers.driver.id
    $drivers.getDriver($routeParams.id, $drivers.invoices.getHistoryInvoices)
  else
     $drivers.invoices.getHistoryInvoices()
