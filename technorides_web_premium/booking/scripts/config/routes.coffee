technoridesApp.config ['$routeProvider', ($routeProvider) ->

  $routeProvider
    .when '/',
      templateUrl : 'views/login.html'
      activetab   : 'login'
    
    .when '/operations',
      templateUrl : 'views/operations.html'
      activetab   : 'operations'
    
    .when '/order',
      templateUrl : 'views/order.html'
      activetab   : 'order'

    .when '/login',
      templateUrl : 'views/login.html'
      activetab   : 'login'

    .when '/forgot-password',
      templateUrl : 'views/forgot-password.html'
      activetab   : ''

    .when '/register',
      templateUrl : 'views/register.html'
      activetab   : 'register'

    .when '/contact',
      templateUrl : 'views/contact.html'
      activetab   : 'contact'

    .otherwise
      redirectTo  : '/'
]

.run ['$rootScope', '$location', '$cookieStore',($rootScope, $location, $cookieStore) ->

  $rootScope.$watch ->
      $location.path()
    (path) ->
      $rootScope.activetab = path
]
