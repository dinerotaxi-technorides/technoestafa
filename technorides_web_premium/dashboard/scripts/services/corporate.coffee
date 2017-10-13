technoridesApp.factory '$corporate', ($api, $apiAdapter, $location, $translate, $route, $filter, $paginator) ->
  $corporate =
    #TODO REMOVE OPERATION FLOWS TO OTHER SERVICE
    history: {}

    lateFees  :
      list    : []
      add     : (feed, modal) ->
        if modal
          $(".addLateFee").modal("hide")
          $api.send "addlateFee", feed, ->
            $corporate.getInvoiceConfig()
        else
          if feed.value is "+ Add Late Fee"
            $(".addLateFee").modal("show")
            $corporate.companies.costCenters.invoices.invoice.lateFee = $corporate.lateFees.list[0]
          else if feed.value is "Delete Late Fee"
            $(".delete-latefee").modal("show")
            $corporate.companies.costCenters.invoices.invoice.lateFee = $corporate.lateFees.list[0]
      delete  : (id) ->
        $api.send "deleteLateFee", id, ->
          $corporate.getInvoiceConfig()
        $(".delete-latefee").modal("hide")
        false

    terms   :
      list  : []
      add   : (term, modal) ->
        if modal
          $(".add-term").modal("hide")
          $api.send "addTerm", term, ->
            $corporate.getInvoiceConfig()
        else
          if term.value is "+ Add New Term"
            $(".add-term").modal("show")
            $corporate.companies.costCenters.invoices.invoice.term = $corporate.terms.list[0]


          else if term.value is "Delete Term"
            $(".delete-term").modal("show")
            $corporate.companies.costCenters.invoices.invoice.term = $corporate.terms.list[0]

          else
            if term.value is "None"
              $corporate.companies.costCenters.invoices.invoice.dueDate = null
            else
              $corporate.companies.costCenters.invoices.invoice.date.setHours(0,0,0,0)
              $corporate.companies.costCenters.invoices.invoice.dueDate = moment($corporate.companies.costCenters.invoices.invoice.date).add(term.days,"days").toDate()
      delete: (id) ->
        $api.send "deleteTerm", id, ->
          $corporate.getInvoiceConfig()
          $(".delete-term").modal("hide")

    taxes   :
      list  : []
      add   : (tax, index ,modal) ->
        if modal
          $(".addTax").modal("hide")
          $api.send "addTax", tax, ->
            $corporate.getInvoiceConfig()
        else
          if tax.value is "+ Add new Tax" and index isnt undefined
            $(".addTax").modal("show")
            $corporate.companies.costCenters.invoices.invoice.operations[index].tax = $corporate.taxes.list[0]
          else if tax.value is "Delete Tax"
            $(".delete-tax").modal("show")
            $corporate.companies.costCenters.invoices.invoice.operations[index].tax = $corporate.taxes.list[0]
      delete: (id) ->
        $api.send "deleteTax", id, ->
          $corporate.getInvoiceConfig()
          $(".delete-tax").modal("hide")

    getInvoiceConfig : (callback) ->
      $api.send "listTaxes", {} , (response) ->
        $corporate.taxes.list = $apiAdapter.input.listTaxes response
        $api.send "listTerms", {}, (response) ->
          $corporate.terms.list = $apiAdapter.input.listTerms response
          $api.send "listLateFee", {}, (response) ->
            $corporate.lateFees.list = $apiAdapter.input.listLateFee response
            $api.send "getCostCenterAdmins", $corporate.companies.costCenters.costCenter.id, (response) ->
              $corporate.companies.costCenters.admins = $apiAdapter.input.getCostCenterAdmins response
              if callback?
                callback()

    setTotalPages : (page, totalPages) ->
      min = page - 5
      max = page + 5

      min = 1 if min < 1

      max = totalPages if max > totalPages

      max = 1 if max < 1

      _.range(min, max + 1)

    #NEW MODEL
    stats     : {}

    drawStats : ->

      $translate(['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']).then (translations) ->
        translations.Enero
        $("svg").remove()
        Morris.Bar
          element: 'graphic'
          data: [
            { months: translations.Enero, revenue: $corporate.stats.monthly[0] }
            { months: translations.Febrero,  revenue: $corporate.stats.monthly[1] }
            { months: translations.Marzo,  revenue: $corporate.stats.monthly[2] }
            { months: translations.Abril,  revenue: $corporate.stats.monthly[3] }
            { months: translations.Mayo,  revenue: $corporate.stats.monthly[4] }
            { months: translations.Junio,  revenue: $corporate.stats.monthly[5] }
            { months: translations.Julio,  revenue: $corporate.stats.monthly[6] }
            { months: translations.Agosto,  revenue: $corporate.stats.monthly[7] }
            { months: translations.Septiembre,  revenue: $corporate.stats.monthly[8] }
            { months: translations.Octubre,  revenue: $corporate.stats.monthly[9] }
            { months: translations.Noviembre,  revenue: $corporate.stats.monthly[10] }
            { months: translations.Diciembre,  revenue: $corporate.stats.monthly[11] }
          ]
          xkey: 'months'
          ykeys: [ 'revenue' ]
          hideHover: 'always'
          resize: true
          labels: [
            'Months'
            'Revenue'
            ]

    companies :
      company : {}
      list    : {}
      previewImage : ->
        reader = new FileReader()

        reader.onload = (event) ->
          $("#company-image-preview").attr "src", event.target.result

        reader.readAsDataURL $("#company-file-image")[0].files[0]

      uploadImage : (token) ->
        data = new FormData()
        data.append "id", $corporate.companies.company.id
        data.append "token", token

        reader = new FileReader()

        reader.onload = (event) ->
          data.append "image", event.target.result.split(",")[1]
          $.ajax(
            url        : $apiAdapter.url.changeCompanyImage
            type       : "post"
            dataType   : "json"
            data       : data
            contentType: false
            processData: false
          ).done (data) ->
            $corporate.companies.getCompany($corporate.companies.company.id)

        reader.readAsDataURL $("#company-file-image")[0].files[0]
        $(".edit-company-image").modal("hide")

        false

      # Used by $paginator (adapter)
      get : (page, search) ->
        $corporate.companies.getCompanies page, search

      getCompanies : (page, search) ->
        $api.send "getCorpAccounts", {page: page, search: search}, (response) ->
          res = $apiAdapter.input.getCorpAccounts response
          $corporate.companies.list = res.list

          #get stats
          $api.send "getCorpStats", {}, (response) ->
            $corporate.stats = $apiAdapter.input.getCorpStats response
            $corporate.drawStats()

      getCompany : (name, costId, invoice) ->
        $api.send "getSingleCorpAccount",name, (response) ->
          if $apiAdapter.input.getSingleCorpAccount response
            $corporate.companies.company = $apiAdapter.input.getSingleCorpAccount response
            if costId?
              if invoice?
                $corporate.companies.costCenters.getSingleCostCenter(costId, invoice)
              else
                $corporate.companies.costCenters.getSingleCostCenter(costId)
            else
              $corporate.companies.costCenters.getCostCenters $corporate.companies.company.id
          else
            $location.path "corporate"

      costCenters:
        addCostCenter : (user) ->
          user.companyId = $corporate.companies.company.id
          $(".add-costCenter").modal("hide")
          $api.send "newCostCenter", user, ->
            $corporate.companies.costCenters.getCostCenters $corporate.companies.company.id

        deleteCostCenter : (id, modal) ->
          if modal
            $api.send "deleteCostCenter", {cost:$corporate.companies.costCenters.costCenter.id, company: $corporate.companies.company.id}, ->
              $(".del-costCenter").modal("hide")
              $corporate.companies.costCenters.costCenter = {}
              $corporate.companies.costCenters.getCostCenters $corporate.companies.company.id
              $route.reload()
          else
             $(".del-costCenter").modal("show")
             $corporate.companies.costCenters.costCenter.id = id

        getCostCenters : (id, page, searchString) ->
          if page?
            ++page
          $api.send "getCostCenterList", {id: id, page: page, searchString: searchString}, (response) ->
            resp = $apiAdapter.input.getCostCenterList response
            $corporate.companies.costCenters.list = resp.list
            $corporate.companies.costCenters.page  = --resp.page
            $corporate.companies.costCenters.pages = _.range resp.pages


        getSingleCostCenter : (name, invoice) ->
          $api.send "getUniqueCostCenter", {id:$corporate.companies.company.id, name: name}, (response) ->
            if $apiAdapter.input.getUniqueCostCenter response
              $corporate.companies.costCenters.costCenter = $apiAdapter.input.getUniqueCostCenter response
              if invoice?
                $corporate.companies.costCenters.invoices.getInvoice(invoice)
              else
                $corporate.companies.costCenters.invoices.getInvoices(1, 'id')
                $corporate.getInvoiceConfig()
            else
              $location.path "corporate/#{$corporate.companies.company.id}"

        list : {}
        page : 1
        pages : []
        costCenter : {}
        admins : {}
        invoices:
          deleteOperation : (id) ->
            for op, key in $corporate.companies.costCenters.invoices.invoice.operations
              if op.opId is id
                # Remove element in the array acording its position
                if key is 0
                  # first element
                  $corporate.companies.costCenters.invoices.invoice.operations.shift()
                else if key is $corporate.companies.costCenters.invoices.invoice.operations.length
                  # last element
                  $corporate.companies.costCenters.invoices.invoice.operations.pop()
                else
                  # malcom in the middle
                  $corporate.companies.costCenters.invoices.invoice.operations.splice(key, key++)
                # Recalculate invoice
                $corporate.companies.costCenters.invoices.recalculateInvoiceTotal($corporate.companies.costCenters.invoices.invoice.operations)
          delete : (invoice, modal) ->
            if modal
              $api.send "deleteInvoice", $corporate.companies.costCenters.invoices.invoice.id, ->
                $corporate.companies.costCenters.invoices.getInvoices(1, 'id')
                $(".del-invoice").modal("hide")
            else
              $(".del-invoice").modal("show")
              $corporate.companies.costCenters.invoices.invoice = invoice
          getInvoices : (page, orderBy, filterBy) ->
            if orderBy? and orderBy isnt ""
              orderBy = orderBy.split("-")
              order = orderBy[0]
              sort = orderBy[1]

            $api.send "getInvoices", {id:$corporate.companies.costCenters.costCenter.id, order:order, sort: sort, filter: filterBy, page: page}, (response) ->
              adapted = $apiAdapter.input.getInvoices response
              $corporate.companies.costCenters.invoices.list = adapted.list
              $corporate.companies.costCenters.invoices.page = adapted.page
              $corporate.companies.costCenters.invoices.totalPages = adapted.totalPages
              $corporate.companies.costCenters.invoices.pages = $corporate.setTotalPages(adapted.page, adapted.totalPages)

          getInvoice : (id) ->
            $api.send "showInvoice", id, (response) ->
              adapted = $apiAdapter.input.showInvoice response, $corporate
              if not adapted
                $location.path "corporate/#{$corporate.companies.company.id}/#{$corporate.companies.costCenters.costCenter.id}"
              else
                $corporate.companies.costCenters.invoices.invoice = adapted

          editInvoice : ->
            $api.post "editInvoice", $corporate.companies.costCenters.invoices.invoice, (response) ->
              delete $corporate.companies.costCenters.invoices.invoice.lateFee
              delete $corporate.companies.costCenters.invoices.invoice.term
              delete $corporate.companies.costCenters.invoices.invoice.adjustments
              delete $corporate.companies.costCenters.invoices.invoice.discount
              delete $corporate.companies.costCenters.invoices.invoice.discountPercentage
              delete $corporate.companies.costCenters.invoices.invoice.details
              delete $corporate.companies.costCenters.invoices.invoice.company
              delete $corporate.companies.costCenters.invoices.invoice.propertis
              delete $corporate.companies.costCenters.invoices.invoice.log
              delete $corporate.companies.costCenters.invoices.invoice.date
              delete $corporate.companies.costCenters.invoices.invoice.id
              $location.path("corporate/#{$corporate.companies.company.id}/#{$corporate.companies.costCenters.costCenter.id}")


          recalculateInvoiceTotal : (operations) ->
            totalInvoiceAmount = 0

            for key, op of operations
              currentOpAmount = op.amount

              # Tax %
              if op.tax.value and op.tax.value isnt 0
                currentOpAmount += (op.tax.charge * op.amount) / 100

              # Discount?
              if op.discount
                # Discount %
                if Number(op.discountType) is 1
                  currentOpAmount -= (op.discount * op.amount) / 100
                # Discount cash
                else
                  currentOpAmount -= op.discount

              totalInvoiceAmount += Number currentOpAmount
            $corporate.companies.costCenters.invoices.invoice.subTotal = totalInvoiceAmount

          createInvoice : () ->
            $api.post "createNewInvoice", {invoice: $corporate.companies.costCenters.invoices.invoice, corporate: $corporate}, (response) ->
              delete $corporate.companies.costCenters.invoices.invoice.lateFee
              delete $corporate.companies.costCenters.invoices.invoice.term

              if response.status is 100
                $location.path("corporate/#{$corporate.companies.company.id}/#{$corporate.companies.costCenters.costCenter.id}")
              else
                $corporate.companies.costCenters.invoices.setNewInvoice()

          setNewInvoice : ->
            $corporate.companies.costCenters.invoices.invoice = {}
            $corporate.companies.costCenters.invoices.invoice.term =
              value : 0
              name : "None"
            $corporate.companies.costCenters.invoices.invoice.lateFee =
              value : 0
              name : "None"
            $corporate.companies.costCenters.invoices.invoice.billingDate = new Date()

          choosePeriod : (period, modal, costCenter) ->
            period.costCenter = costCenter
            if modal
              $(".changebillingPeriod").modal("show")
              false
            else
              $("#op-loader").show()
              $(".changebillingPeriod").modal("hide")
              $api.send "getOperationsOn", period, (response) ->
                adapted = $apiAdapter.input.getOperationsOn response, $corporate
                $corporate.companies.costCenters.invoices.invoice.subTotal = adapted.subtotal
                $corporate.companies.costCenters.invoices.invoice.operations = adapted.operations
                $("#op-loader").hide()
                false

          recordPayment : (payment, modal) ->
            if modal
              payment.invoiceid = $corporate.companies.costCenters.invoices.invoice.id
              $api.send "recordInvoicePayment", payment, (response) ->
                $corporate.companies.costCenters.invoices.getInvoice($corporate.companies.costCenters.invoices.invoice.id)
                $(".recordPayment").modal("hide")
                false
            else
              $(".recordPayment").modal("show")
              false

          deletePayment : (id, modal) ->
            if modal
              $api.send "deleteInvoicePayment", {id:$corporate.companies.costCenters.invoices.payments.payment.id, invoiceid: $corporate.companies.costCenters.invoices.invoice.id}, ->
                $corporate.companies.costCenters.invoices.getInvoice($corporate.companies.costCenters.invoices.invoice.id)
                $(".delete-payment").modal("hide")
                false
            else
              $corporate.companies.costCenters.invoices.payments.payment.id = id
              $(".delete-payment").modal("show")
              false

          totalPages : {}
          page    : {}
          pages   : []
          list    : {}
          invoice : {}
          invoiceOperations : []
          payments :
            payment : {}
