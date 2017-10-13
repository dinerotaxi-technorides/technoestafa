technoridesApp.directive 'ngUnique', ['$http', '$api',($http, $api) ->
    {
      require: 'ngModel'
      link: (scope, elem, attrs, ctrl) ->
        elem.on 'blur', (evt) ->
          scope.$apply ->
            val = elem.val()
            req = 'email': val
            $api.send "checkEmail", val, (response) ->
              if response.status is 109
                console.log "invalid"
                ctrl.$setValidity 'unique', false
              else
                console.log "valid"
                ctrl.$setValidity 'unique', true

    }
]