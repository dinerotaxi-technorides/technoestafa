technoridesApp.filter('filterOperationsByStatus', ->

  (operations, status) ->
    result = []

    angular.forEach operations, (operation, id) ->
      result.push operation if operation.status == status and (not operation.shown == true)
    result
)
