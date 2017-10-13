technoridesApp.controller 'driverReceiptCtrl' , ($scope, $routeParams, $drivers, $location) ->
  $scope.drivers = $drivers
  if not $drivers.driver.id
    $drivers.getDriver($routeParams.id, $drivers.receipts.getReceipts)
  else
    $drivers.receipts.getReceipts()
