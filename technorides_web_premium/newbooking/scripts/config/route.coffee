technoridesApp.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl : 'views/login.html'
      controller  : 'loginCtrl'

    .when '/booking/',
      templateUrl : 'views/booking.html'
      controller  : 'bookingCtrl'

    .when '/signup/',
      templateUrl : 'views/signup.html'
      controller  : 'signupCtrl'

    .when '/corporate',
      templateUrl : 'views/corporate.html'
      controller  : 'corporateCtrl'
]
