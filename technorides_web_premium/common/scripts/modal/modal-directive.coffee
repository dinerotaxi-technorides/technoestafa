technoridesApp.directive 'modal', ($modal) ->
  restrict: 'A'
  scope: true
  link: (scope, element, attrs) ->
    element.on 'click', (event) ->
      $modal.open
        title: attrs.modalTitle
        temp : attrs.modal
        size : attrs.modalSize
        close: attrs.modalClose

      $modal.apply()
