technoridesApp.factory '$employees', [ 'employees.api', '$paginator', '$sce', '$modal', '$user' ,($api, $paginator, $sce, $modal, $user) ->
  $employees =
    list : []
    searchFields: [
      "username",
      "phone"
    ]
    types : [
      "TAXISTA"
      "OPERADOR"
      "CORDINADOR"
      "TELEFONISTA"
      "COMPANYEMPLOYEE"
      "MONITOR"
    ]
    fields: [
      "username",
      "password",
      "firstName",
      "lastName",
      "phone",
      "typeEmploy",
      "agree",
      "enabled",
      "accountLocked",
      "isTestUser",
      # "city",
      # "id"
    ]

    get: (page, searchField, searchString, orderField, order) ->
      # Paginator
      if order?
        $employees.currentOrder = order
      else
        # New field
        if $employees.currentOrderField isnt orderField or $employees.currentOrder isnt "asc"
          $employees.currentOrderField = orderField?="username"
          $employees.currentOrder      = "asc"
        # Toggle (current field)
        else
          $employees.currentOrder = "desc"

      $api.get
        data:
          token        : $user.token
          rows         : 10
          page         : page
          searchField  : searchField
          searchString : searchString?=""
          sidx         : $employees.currentOrderField
          sord         : $employees.currentOrder
        done: (adapted) ->
          $employees.list = adapted.list
          $paginator.page = adapted.page
          $paginator.pages = adapted.pages
        fail : (response) ->
          if response.status is 411
            $user.logout()

    edit : (oper) ->
      $api.edit
        worker : $employees.worker
        oper : oper
        done : ->
          $modal.closeIt()
          $employees.unset()
          $employees.get(1)
        fail : ->

    set : (worker) ->
      $employees.worker = worker

    unset: ->
      $employees.worker = {}
      list: []
      worker : {}
      view :  {}
  ]
