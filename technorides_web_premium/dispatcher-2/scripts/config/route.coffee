technoridesApp.config ['$routeProvider', ($routeProvider) ->

  $routeProvider
    .when '/',
      templateUrl : 'views/operations.html'
      controller  : 'operationsCtrl'
      activetab   : 'operations'
]
