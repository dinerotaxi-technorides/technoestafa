technoridesApp.controller 'inboxCtrl' , ($scope, $inbox, $routeParams, $paginator ) ->
  $scope.inbox = $inbox
  $inbox.getMessages()
  $scope.paginator = $paginator
  $paginator.model = $inbox

  
