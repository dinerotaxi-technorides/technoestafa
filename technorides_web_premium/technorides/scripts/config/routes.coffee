technoridesApp.config [->
]


.run ['$rootScope', '$location', '$cookieStore',($rootScope, $location, $cookieStore) ->

  $rootScope.$watch ->
      $location.path()
    (path) ->
      $rootScope.activetab = path


]
