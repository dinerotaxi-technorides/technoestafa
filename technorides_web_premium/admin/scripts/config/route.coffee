technoridesApp.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/cities',
      templateUrl : 'views/cities.html'
      controller  : 'citiesCtrl'
      activetab   : 'cities'

    .when '/e-marketing',
      templateUrl : 'views/emarketing.html'
      controller  : 'emarketingCtrl'
      activetab   : 'emarketing'

    .when '/employees',
      templateUrl : 'views/employees.html'
      controller  : 'employeesCtrl'
      activetab   : 'employees'

    .when '/clients',
      templateUrl : 'views/clients.html'
      controller  : 'clientsCtrl'
      activetab   : 'clients'

    .when '/configuration',
      templateUrl : 'views/configs.html'
      controller  : 'configsCtrl'
      activetab   : 'config'

    .when '/users',
      templateUrl : 'views/users.html'
      controller  : 'usersCtrl'
      activetab   : 'users'

    .when '/message',
      templateUrl: 'views/message-operators.html'
      controller : 'messagesCtrl'
      activetab  : 'message'

    .otherwise
      redirectTo: '/cities'
]
