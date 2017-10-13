technoridesApp.config ['$routeProvider', ($routeProvider) ->

  $routeProvider
    .when '/',
      templateUrl : 'views/dispatcher.html'
      activetab   : ''


    .when '/contact',
      templateUrl : 'views/contact.html'
      activetab   : 'contact'


    .when '/statistics',
      templateUrl : 'views/statistics.html'
      activetab   : ''


    .otherwise
      redirectTo: '/'


]
.run ['$rootScope', '$location', '$cookieStore',($rootScope, $location, $cookieStore) ->

  $rootScope.$watch ->
      $location.path()
    (path) ->
      $rootScope.activetab = path


]
