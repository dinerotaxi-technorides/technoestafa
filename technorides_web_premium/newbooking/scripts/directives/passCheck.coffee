technoridesApp.directive 'pwCheck', [ ->
    require: 'ngModel'
    restrict: 'A'
    link: (scope, elem, attrs, ctrl) ->
      scope.$watch attrs.ngModel, (value) ->
        if attrs.pwCheck is value 
          ctrl.$setValidity "correct", true
        else
          ctrl.$setValidity "correct", false
]