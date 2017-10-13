technoridesApp.factory '$drivers', ($api, $apiAdapter, $location, $user, $timeout, $rootScope, $map) ->
  $drivers =
    driver   : {}
    history  : {}
    list     : []
    pages    : []
    lastPage : 0
    page     : 0
    logs     : []
    tab      : 2

    focusDriver : (coords, status) ->
      options =
        position  : L.latLng coords.latitude, coords.longitude
        icon      : "/common/assets/markers/driver_#{status}.png"
        doCluster : false
        visible   : true
        draggable : false

      $map.addOrUpdateMarker "driver", $drivers.driver.id , options
      $map.setCenter(L.latLng coords.latitude, coords.longitude)


    getDrivers : (page, search, field) ->
      $api.send 'getDrivers', {page: page, searchString: search, searchField: field}, (response) ->
        adapted           = $apiAdapter.input.getDrivers response
        $drivers.list     = adapted.drivers
        $drivers.page     = adapted.page
        $drivers.lastPage = adapted.pages
        $drivers.pages    = $drivers.setTotalPages(adapted.page, adapted.pages)

    getDriver : (id , callback) ->
      $api.send "getSingleDriver", id ,(response) ->
        $drivers.setDriver $apiAdapter.input.getSingleDriver(response)

        $drivers.getHistory(1,'')
        $drivers.getBilling()
        if callback?
          callback()
    setDriver : (response) ->
      # if driver not exist redirect to employees list
      if not response.id
        $drivers.driver = false
        $location.path "/employees"
      else
        $drivers.driver = response
        $drivers.driver.image = "#{$apiAdapter.url.driverImage}#{$drivers.driver.email}&cache=#{(new Date()).getTime()}"

    editImage : (modal) ->
      if not modal
        $(".edit-driver-image").modal("show")
        false
      else
        data = new FormData()
        data.append "employ_id", $drivers.driver.id
        data.append "token", $user.token

        reader = new FileReader()

        reader.onload = (event) ->
          data.append "image", event.target.result.split(",")[1]
          $.ajax(
            url        : $apiAdapter.url.changeDriverImage
            type       : "post"
            dataType   : "json"
            data       : data
            contentType: false
            processData: false
          ).done (data) ->
            $drivers.getDriver $drivers.driver.id
            numberDate = new Date()
            $("#driverimg").attr("src", "#{$drivers.driver.image}&cache=#{numberDate.getTime()}")
            $(".edit-driver-image").modal("hide")
            false
        reader.readAsDataURL $("#driver_image")[0].files[0]

    previewImage : ->
      reader = new FileReader()

      reader.onload = (event) ->
        $("#driver_image_preview").attr "src", event.target.result

      reader.readAsDataURL $("#driver_image")[0].files[0]

    editDriver : (modal) ->
      if not modal
        if $drivers.driver.licence.expiration?
          $drivers.driver.licence.expiration = new Date($drivers.driver.licence.expiration)
        else
          $drivers.driver.licence.expiration = new Date()

        $(".edit-driver").modal("show")
        false
      else
        $api.send "editDriver", $drivers.driver, ->
          $(".edit-driver").modal("hide")

          $drivers.getDriver($drivers.driver.id)

    activateDriver : ->
      $api.send "activateDriver",$drivers.driver.id, (response) ->
        $drivers.driver.enabled = response.enabled
        if $drivers.driver.enabled
          $drivers.driver.blockLoader = true
          $api.newApiSend "disconectDriverFromSocket", $drivers.driver.id, ->
            $timeout ->
              $drivers.driver.blockLoader = false
            ,
              5000
            ,
              true

    #### DRIVER PROFILE METHODS
    getLogs : (page) ->
      $api.newApiSend "getDriverLogs", {id:$drivers.driver.id, page: page}, (response) ->
        $drivers.logs = $apiAdapter.input.getDriverLogs response

    getHistory : (page, search) ->
      if not search?
        search = ""
      $api.send "getDriverHistory", {id:$drivers.driver.email, search:search, page:page}, (response) ->
        $drivers.history = $apiAdapter.input.getDriverHistory response
        $drivers.history.pages = []
        $drivers.history.pages = $drivers.setTotalPages response.page, response.total

    setTotalPages : (page, totalPages) ->
      min = page - 5
      max = page + 5

      min = 1 if min < 1

      max = totalPages if max > totalPages

      max = 1 if max < 1

      _.range(min, max + 1)


    ballanceAccount : (modal) ->
      if modal
        $api.send "ballanceDriverAccount", $drivers.driver.id, (response)->
          if $apiAdapter.isSuccessStatus "ballanceDriverAccount", response.status
            $(".ballance-account").modal("hide")
            $drivers.getBilling()
      else
        $(".ballance-account").modal("show")
        false
    #RECEIPTS
    receipts :
      payPartialy : ->
        receipts = []
        for receipt in $drivers.receipts.list
          if receipt.pay
            receipts.push receipt.id
        $api.send "payDriverPartialy", {ops:receipts, id: $drivers.driver.id}, (response) ->
          if $apiAdapter.isSuccessStatus "payDriverPartialy", response.status
            $location.path "employees/driver/#{$drivers.driver.id}"
            $drivers.tab = 3
            $drivers.getBilling()
          else
            alert "error"
      total : 0
      calculatePartialPayment : ->
        total = 0
        for receipt in $drivers.receipts.list
          if receipt.pay
            total += receipt.amount
        $drivers.receipts.total = total

      payTotal : (modal) ->
        if modal
          $api.send "payReceiptsTotal", $drivers.driver.id, (response)->
            if $apiAdapter.isSuccessStatus "payReceiptsTotal", response.status
              $(".pay-total").modal("hide")
              $drivers.getBilling()
        else
          $(".pay-total").modal("show")
          false
      getReceipts : () ->
        $api.send "getDriverReceipts", $drivers.driver.id , (response) ->
          adapted = $apiAdapter.input.getDriverReceipts response
          $drivers.receipts.list = adapted.list
          #$drivers.receipts.page = adapted.page
          #$drivers.receipts.totalPages = adapted.totalPages
          #$drivers.receipts.pages = $drivers.setTotalPages adapted.page, adapted.totalPages

      getHistoryReceipts : () ->
        $api.send "getDriverHistoryReceipts", $drivers.driver.id , (response) ->
          adapted = $apiAdapter.input.getDriverHistoryReceipts response
          $drivers.receipts.list = adapted.list

      list : []
      page : 0
      totalPages: 0
      pages : []
    getBilling : ->
      $api.send "getDriverBilling", $drivers.driver.id, (response) ->
        adapted = $apiAdapter.input.getDriverBilling response
        $drivers.driver.billing = adapted
        if not $rootScope.$$phase
          $drivers.apply()
    #### INVOICES
    invoices :
      chargePartialy : ->
        invoices = []
        for invoice in $drivers.invoices.list
          if invoice.pay
            invoices.push invoice.id
        $api.send "chargeDriverPartialy", {id: $drivers.driver.id, invoices: invoices}, (response) ->
          if $apiAdapter.isSuccessStatus "chargeDriverPartialy", response.status
            $location.path "employees/driver/#{$drivers.driver.id}"
            $drivers.tab = 3
            $drivers.getBilling()

          else
            alert "error"

      total : 0
      calculatePartialCharge : ->
        total = 0
        for invoice in $drivers.invoices.list
          if invoice.pay
            total += invoice.amount
        $drivers.invoices.total = total

      chargeTotal : (modal) ->
        if modal
          $api.send "chargeInvoiceTotal", $drivers.driver.id, ->
            $(".charge-total").modal("hide")
            $drivers.getBilling()
        else
          $(".charge-total").modal("show")
          false
      getInvoices : () ->
        $api.send "getDriverInvoices", $drivers.driver.id , (response) ->
          adapted = $apiAdapter.input.getDriverInvoices response
          $drivers.invoices.list = adapted.list
          $drivers.invoices.page = adapted.page
          $drivers.invoices.totalPages = adapted.totalPages
          $drivers.invoices.pages = $drivers.setTotalPages adapted.page, adapted.totalPages

      getHistoryInvoices : () ->
        $api.send "getDriverHistoryInvoices", $drivers.driver.id , (response) ->
          adapted = $apiAdapter.input.getDriverHistoryInvoices response
          $drivers.invoices.list = adapted.list
          $drivers.invoices.page = adapted.page
          $drivers.invoices.totalPages = adapted.totalPages
          $drivers.invoices.pages = $drivers.setTotalPages adapted.page, adapted.totalPages


      list : []
      page : 0
      totalPages: 0
      pages : []
      invoice : {}


      get : (invoice, driver) ->
        $api.send "getDriverInvoice", {invoice:invoice, driver:driver}, (response) ->
          $drivers.invoices.invoice = $apiAdapter.input.getDriverInvoice response
          if not $drivers.invoices.invoice
            $location.path "employees/driver/#{$drivers.driver.id}"

    apply : ->
      $rootScope.$broadcast "driverChanged"
