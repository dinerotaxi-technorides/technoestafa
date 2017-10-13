technoridesApp.controller 'driverProfileCtrl' , ($scope, $drivers, $routeParams, $api, $user, $map) ->
  $scope.drivers = $drivers
  $drivers.getDriver($routeParams.id)
  if $map.provider.map
    #destroy
    $map.remove()
  $map.initialize "pmap_canvas",
    latitude  : $user.latitude
    longitude : $user.longitude
    zoom      : 14
    mapTypeId : "mapbox.streets"

  $scope.$on "driverChanged", ->
    $scope.$apply ->
      $scope.drivers = $drivers

  $scope.modalExportDriver = ->
    $(".exportHistory").modal("show")
    false

  $scope.DriverOpExport = (data, driver) ->
    data.driverId = driver.id
    $api.send "DriverOpExport" ,  data
    $(".exportHistory").modal("hide")
    false

  $scope.modalOperationDriver = (data)->
    $scope.driverOp = data
    $(".operationLogDriver").modal("show")
    false

  $scope.getLogs = () ->
    # $map.map._onResize();
    $drivers.getLogs(0);
