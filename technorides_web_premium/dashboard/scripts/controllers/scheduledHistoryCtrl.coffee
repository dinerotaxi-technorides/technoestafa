technoridesApp.controller 'scheduledHistoryCtrl' , ($scope, $api) ->
  $scope.historyLoader = true
  $api.send 'getScheduledHistory', {page: 0, search: "", date: ""}, ->
    $scope.historyLoader = false

  $scope.getScheduledHistory = (page, s) ->
    if not s.search?
      s.search = ""
    if s.date?.start? and s.date?.end?
      date = s.date
    $scope.historyLoader = true
    $api.send 'getScheduledHistory', {page: page, search: s, date: date}, ->
      $scope.historyLoader = false
