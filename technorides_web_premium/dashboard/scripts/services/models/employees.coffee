technoridesApp.factory '$employees', ($api, $apiAdapter, $location) ->
  $employees =
    list     : []
    pages    : []
    page     : 0
    lastPage : 0
    types    : []
    employee : {}
    history  : []
    totalPages : 0
    checkingEmail : false

    export : (ex, costCenter, modal) ->
      if modal
        $api.send "exportCorpEmployees" , {ex: ex, costCenter: costCenter}, ->
          $(".export-employees").modal("hide")
      else
        $(".export-employees").modal("show")
        false
    getTypes : ->
      $api.send "employeesType", "", (response) ->
        $employees.types = $apiAdapter.input.employeesType response

    getEmployees : (costCenter, page, search) ->
      if costCenter
        $api.send "listCorpEmployees", {id: costCenter, page: page}, (response) ->
          adapted             = $apiAdapter.input.listCorpEmployees response
          $employees.list     = adapted.list
          $employees.page     = adapted.page
          $employees.pages    = $employees.setTotalPages(adapted.page, adapted.pages)
          $employees.employee = {}
      else
        $api.send "listEmployees", {page: page, search: search}, (response) ->
          adapted             = $apiAdapter.input.listEmployees response
          $employees.list     = adapted.employees
          $employees.page     = adapted.page
          $employees.totalPages = adapted.pages
          $employees.pages    = $employees.setTotalPages(adapted.page, adapted.pages)
          $employees.employee = {}

    getEmployee : (cost, id) ->
      $api.send "getCorpEmployee", {id: id, cost: cost}, (response) ->
        $employees.employee = $apiAdapter.input.getCorpEmployee response

    deleteEmployee : (costCenter, id, modal) ->
      if costCenter
      else
        if modal
          $api.send "deleteEmployee", $employees.employee.id, ->
            $employees.getEmployees(false, $employees.page, "")
          $(".delete-employee").modal("hide")
          false
        else
          $employees.employee.id = id
          $(".delete-employee").modal("show")
          false

    addEmployee : (costCenter, employ, modal) ->
      if modal
        if costCenter
          $api.send "addCorpEmployee", {cost: costCenter, employ: employ}, ->
            $employees.getEmployees(costCenter, $employees.page, "")
          $(".add-employee").modal("hide")
          false
        else
          $api.send "addEmployee", employ, ->
            $employees.getEmployees(false, $employees.page, "")
          $(".add-employee").modal("hide")
          false
      else
        $(".add-employee").modal("show")
        false

    getEmployeeHistory : (id, page) ->
      $api.send "corpEmployeeHistory", {id: id, page: page} , (response) ->
        adapted            = $apiAdapter.input.corpEmployeeHistory response
        $employees.history = adapted.history
        $employees.page    = adapted.page
        $employees.pages   = $employees.setTotalPages(adapted.page, adapted.pages)


    editEmployee : (costCenter, modal, employee) ->
      if modal
        if costCenter
          $api.send "editCorpEmployee", {cost: costCenter, employ: $employees.employee}, ->
            $employees.employee.password = null
          $(".edit-employee").modal("hide")
          false
        else
          $api.send "editEmployee", $employees.employee ,(response) ->
            $employees.getEmployees(false, $employees.page, "")
            $employees.employee = {}
          $(".edit-employee").modal("hide")
          false
      else
        if employee?
          $(".edit-employee").modal("show")
          $employees.employee = employee
          false

    activateEmployee : (id) ->
      $api.send "activateEmployee", id, ->

    setTotalPages : (page, totalPages) ->
      min = page - 5
      max = page + 5

      min = 1 if min < 1

      max = totalPages if max > totalPages

      max = 1 if max < 1

      _.range(min, max + 1)

    validateMail: (mail) ->
      $employees.checkingEmail = true
      $api.send "checkEmail" , mail, (response) ->
        $employees.checkingEmail = false
        if response.status is 109
          $employees.emailValid = false
        else
          $employees.emailValid = true
