technoridesApp.factory '$zonePrices', ($api, $apiAdapter, $location, $user) ->
  $zonePrices =
    list : []
    page : 0
    pages : []
    searchFields: ["zonename"];
    zone : {}


    get : (page, search , filter, sord,sidx) ->


      if sord is "asc"
        $zonePrices.currentOrder = "desc"
      else if sord is "desc"
        $zonePrices.currentOrder = "asc"

      $api.send "getZonePricing", {page: page ,search: search,f: filter, sord: $zonePrices.currentOrder, sidx: sidx} , (response) ->
        adapted = $apiAdapter.input.getZonePricing response
        $zonePrices.list = adapted.list
        $zonePrices.page = adapted.page
        $zonePrices.lastPage = adapted.pages
        $zonePrices.pages = $zonePrices.setTotalPages adapted.page, adapted.pages


    edit : (modal, zone, search, filter) ->
      if modal
        $api.send "editZonePricing", {oper:"edit", zone: $zonePrices.zone}, (response) ->
          if response.status is 411
            $user.logout()
          else
            $(".edit-zonePricings").modal("hide")
            # $zonePrices.get(0,search, filter)
            $zonePrices.zone = {}
      else
        $(".edit-zonePricings").modal("show")
        $zonePrices.zone = zone

    setTotalPages : (page, totalPages) ->
      min = page - 5
      max = page + 5

      min = 1 if min < 1

      max = totalPages if max > totalPages

      max = 1 if max < 1

      _.range(min, max + 1)
