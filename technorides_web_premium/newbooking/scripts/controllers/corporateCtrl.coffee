technoridesApp.controller 'corporateCtrl' ,($scope, $user, $company, $employees, $operation, $location, $webSocket, $webSocketAdapter, $webSocketHandler, $corporate, $modal, $presets, $map ) ->
  # if not corporate admin redirect to booking (this is for avoiding normal users to acces this by "accident")
  if not $user.corporateAdmin
    $location.path "/booking"
  $scope.modal   = $modal
  $scope.company = $company
  $scope.user    = $user
  $scope.presets = $presets
  $scope.operation = $operation
  $webSocket.setAdapter $webSocketAdapter
  $webSocket.setHandler $webSocketHandler
  $scope.tab = "dashboard"
  $scope.costTab = "history"
  $scope.changeTab = (newTab) ->
    $scope.tab = newTab
  $scope.changeCorpTab = (newtab) ->
    $scope.costTab = newtab
  #get company data
  $corporate.getCompanyInfo()
  $scope.corporate = $corporate
  $scope.employees = $employees

  staticsData = {}
  staticsData.token = $user.token
  staticsData.corporate = $user.company

  $company.getStatics staticsData

  $scope.changeCost = (id) ->
    $user.costCenter = id
    $corporate.operations.get()
  #broadcast from $modal
  $scope.$on 'modalApply', ->
    $scope.$apply ->
      $scope.modal = $modal

  $scope.$on 'corporateChanged', ->
    $scope.$apply ->
      $scope.corporate = $corporate
