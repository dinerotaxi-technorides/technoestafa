technoridesApp.controller 'dailyReportsCtrl' , ($scope, $paginator, $dailyReports, $api) ->


  $scope.dailyReports = $dailyReports
  $scope.paginator = $paginator

  $paginator.model = $dailyReports

  $dailyReports.getRemote()

  $scope.modalExportDaily = ->
    $(".exportDailyReport").modal("show")
    false
  $scope.exportDailyReport = (period) ->
    $api.send "exportDaily", period
    $(".exportDailyReport").modal("hide")
    false
