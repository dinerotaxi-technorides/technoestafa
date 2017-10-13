technoridesApp.factory '$operations', ($api, $apiAdapter) ->
  $operations = 
    list : []
    page : 0
    pages : []
    totalPages : 0
    operation : {}
    getOperations : (cost, search, page) ->
      if cost
        $api.send "getCorpOperations", {id:cost, search:search, page:page}, (response) ->
          adapted = $apiAdapter.input.getCorpOperations response
          $operations.list = adapted.list
          $operations.page = adapted.page
          $operations.totalPages = adapted.totalPages
          $operations.pages = $operations.setTotalPages(adapted.page, adapted.totalPages)
      else
    setTotalPages : (page, totalPages) ->
      min = page - 5
      max = page + 5
      
      min = 1 if min < 1
      
      max = totalPages if max > totalPages
      
      max = 1 if max < 1

      _.range(min, max + 1)
    getScheduledOps : (search, page) ->
    
    viewMore : (operation) ->
      $operations.operation = operation
      $(".view-more-op").modal("show")
      false