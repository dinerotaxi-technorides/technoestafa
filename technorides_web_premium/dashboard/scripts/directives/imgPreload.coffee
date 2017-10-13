technoridesApp.directive 'imgPreload', ($rootScope) -> 
  restrict: 'A',
  scope: 
    ngSrc: '@'
  link: (scope, element, attrs) ->
    element.on('load', ->
      element.parent().find('span').remove()
    ).on('error', ->
      attrs.$set "src" , attrs.errorImg
    )