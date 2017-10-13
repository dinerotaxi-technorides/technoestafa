technoridesApp.factory '$paginator', ($log) ->
  $paginator =
    page : 0
    pages : []
    model : null
    get : (page, searchField, searchString) ->
      if $paginator.model?
        if $paginator.model.get?
          $paginator.model.get page, searchField, searchString, $paginator.model.currentOrderField, $paginator.model.currentOrder
        else
          $log.warn "get() method is undefined"
      else
        $log.warn "Model is undefined"
