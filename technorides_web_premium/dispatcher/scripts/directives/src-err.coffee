technoridesApp.directive 'errSrc', ->
  { link: (scope, element, attrs) ->
    scope.$watch (->
      attrs['ngSrc']
    ), (value) ->
      if !value
        element.attr 'src', attrs.errSrc
    element.bind 'error', ->
      element.attr 'src', attrs.errSrc
 }
