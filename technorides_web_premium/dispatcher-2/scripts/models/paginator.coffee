technoridesApp.factory '$paginator', () ->
  $paginator =
    pages : []
    rows  : 3
    size  : 5
    page  : 1
    total : 0
    updatePaginator : (page, total) ->
      @.page = page
      @.pages = []
      pagesTotal = parseInt Math.ceil total / @.rows
      @.total = pagesTotal
      minPage = page - @.size
      maxPage = page + @.size

      # First pages
      if minPage < 0
        maxPage = maxPage - minPage

      # Last pages
      if maxPage > pagesTotal
        minPage = pagesTotal - @.size * 2

      for i in [page..minPage] by -1
        @.pages.push i if i > 0

      for i in [page + 1..maxPage] by 1
        @.pages.push i if i <= pagesTotal

      @.pages.sort (a, b) -> a - b
