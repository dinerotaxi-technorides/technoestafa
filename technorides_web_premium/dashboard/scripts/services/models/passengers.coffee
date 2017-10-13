technoridesApp.factory '$passengers', ($api, $apiAdapter, $location, $user) ->
  $passengers =
    list : []
    page : 0
    pages : []
    searchFields: [
      "username",
      "lastName",
      "phone"
    ]
    passenger : {}

    get : (page, search , filter) ->
      $api.send "getPassengers", {page:page,search:search,filter:filter} , (response) ->
        adapted = $apiAdapter.input.getPassengers response
        $passengers.list = adapted.list
        $passengers.page = adapted.page
        $passengers.pages = $passengers.setTotalPages adapted.page, adapted.pages


    add : (modal) ->
      if modal
        $api.send "editPassenger", {oper: "add", passenger: $passengers.passenger}, (response) ->
          if response.status is 411
            $user.logout()
          else
            $passengers.get()
            $(".add-passenger").modal("hide")
            $passengers.passenger = {}
      else
        $passengers.passenger = {}
        $(".add-passenger").modal("show")
        false
    edit : (modal, passenger) ->
      if modal
        $api.send "editPassenger", {oper:"edit", passenger: $passengers.passenger}, (response) ->
          if response.status is 411
            $user.logout()
          else
            $(".edit-passenger").modal("hide")
            $passengers.get()
            $passengers.passenger = {}
      else
        $(".edit-passenger").modal("show")
        $passengers.passenger = passenger
    setTotalPages : (page, totalPages) ->
      min = page - 5
      max = page + 5

      min = 1 if min < 1

      max = totalPages if max > totalPages

      max = 1 if max < 1

      _.range(min, max + 1)
