technoridesApp.controller 'driversReportsCtrl' , ($scope, $paginator,$driversReports, $api) ->


  $scope.driversReports = $driversReports
  $scope.paginator = $paginator

  $paginator.model = $driversReports


  $driversReports.getRemoteDrivers()

  $scope.modalExportDriver = ->
    $(".exportDriverReport").modal("show")
    false

  $scope.exportDriverReport = (period) ->
    $api.send "exportDriver", period
    $(".exportDriverReport").modal("hide")
    false
