technoridesApp.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl : 'views/employees.html'
    
    .when '/employees',
      templateUrl : 'views/employees.html'
    
    .when '/billing',
      templateUrl : 'views/billing'
    
    .when '/operations',
      templateUrl : 'views/operations.html'

    .otherwise  
      redirectTo: '/'
]
.run ['$rootScope', '$location', '$cookieStore',($rootScope, $location, $cookieStore) ->

  $rootScope.$watch(
    ->
      $location.path()
    (path) ->
      $rootScope.activetab = path
    )
]
