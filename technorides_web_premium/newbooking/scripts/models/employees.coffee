technoridesApp.factory '$employees', [ 'employees.api','$location', '$translate', '$modal',($api, $location, $translate, $modal) ->
  $employees =
    list : []
    page : 0
    pages : []
    employee : {}
    operations :
      operation : {}
      list : []
      page : 0
      pages : []

    get : (page ,search, order, filter) ->
      $api.get
        search : search?=""
        page   : page?=1
        order  : order?=""
        filter : filter?=""
        done : (adapted) ->
          $employees.list = adapted.list
          $employees.page = adapted.page
          $employees.pages = _.range adapted.pages
        fail : ->
          $modal.open(
            temp : "views/modal/corporate/error.html"
            title : "Error"
          )

    activate : ->
      $api.activate
        id : $employees.employee.id

    getOperations : (page) ->
      $api.getOperations
        id   : $employees.employee.id
        page : page?=1
        done : (adapted) ->
          $employees.operations.list  = adapted.list
          $employees.operations.page  = adapted.page
          $employees.operations.pages = _.range adapted.pages

    setEmployee : (employee) ->
      $employees.employee = employee
      $employees.getOperations()
      $employees.getMetrics(employee.id)

    edit : () ->
      $api.edit
        employee   : $employees.employee
        done : ->
          $("#async").modal("hide")
        fail : ->
          $("#async").modal("hide")
          $modal.open(
            temp : "views/modal/corporate/error.html"
            title : "Error"
          )
    add : ->
      $api.add
        employee : $employees.employee
        done : ->
          $("#async").modal("hide")
          $employees.get()
        fail : ->
          $modal.open(
            temp : "views/modal/corporate/error.html"
            title : "Error"
          )
    unsetEmployee : ->
      $employees.employee = {}

    getMetrics : (id)->
      $api.getMetrics
        id: id
        done : (adapted) ->
          $employees.employee.metrics = adapted

        fail : ->
          $modal.open(
            temp : "views/modal/corporate/error.html"
            title : "Error"
          )

]
