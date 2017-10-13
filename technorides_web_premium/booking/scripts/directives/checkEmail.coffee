technoridesApp.directive 'checkemail', ['$http','$settings','$company',($http, $settings, $company) ->

  $apiLink = $settings[$settings.environment].api

  require: 'ngModel'
  link   : (scope, elem, attrs, ctrl) ->
    elem.on 'blur',  (evt) ->
          scope.spinner = true

          if !!@.value  and ctrl.$valid
            console.log('checking email is available...')
            $http.get($apiLink + "usersApi/isAvailable?", params:{"email": @.value,"rtaxi": $company.companyMail } )

            .success (response) =>
              if response.status is 100
                console.log("valid email")
                scope.spinner = false
              else
                scope.error.showError("register", "emailUsed")
                @.value = ""
                scope.spinner = false

            .error (response) =>
                scope.error.showError("register", "connectError")
                scope.spinner = false
]
