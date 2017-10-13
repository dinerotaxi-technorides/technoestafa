technoridesApp.controller 'driverHistoryReceiptCtrl' , ($scope, $routeParams, $drivers, $location) ->
  $scope.drivers = $drivers
  if not $drivers.driver.id
    $drivers.getDriver($routeParams.id, $drivers.receipts.getHistoryReceipts)
  else
    $drivers.receipts.getHistoryReceipts()
