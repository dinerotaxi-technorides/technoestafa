technoridesApp.controller 'monthlyReportsCtrl' , ($scope,  $paginator,  $monthlyReports, $api) ->


  $scope.monthlyReports = $monthlyReports
  $scope.paginator = $paginator

  $paginator.model = $monthlyReports

  $monthlyReports.getRemoteMonthly()

  $scope.modalExportMonthly = ->
    $(".exportMonthlyReport").modal("show")
    false

  $scope.exportMonthlyReport = (period) ->
    $api.send "exportMonthly", period
    $(".exportMonthlyReport").modal("hide")
    false
