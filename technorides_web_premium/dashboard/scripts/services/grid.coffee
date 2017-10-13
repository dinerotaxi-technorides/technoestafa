technoridesApp.factory '$grid',[ '$user', '$settings', '$timeout', '$api', '$translate','$sce', '$rootScope',($user,$settings, $timeout, $api, $translate, $sce, $rootScope) ->

  # Link of the api
  $apiLink  = $settings[$settings.environment].api
  $tr = {}
  $rootScope.$on '$translateChangeSuccess', ->
    $translate(['createdAt','email','password','name','lastName',
      'phone','enabled','passengers','trips',
      'date','driver','ammount','origin','destination',
      'comments','stars','status','operationsHistory','number',
      'user','id','operators','companyName','mustNotBeEmail', 'role','agree','admin']).then (translations) ->
      $tr =
        createdAt  : translations.createdAt
        email      : translations.email
        password   : translations.password
        name       : translations.name
        lastName   : translations.lastName
        phone      : translations.phone
        enabled    : translations.enabled
        passengers : translations.passengers
        trips      : translations.trips
        date       : translations.date
        driver     : translations.driver
        ammount    : translations.ammount
        origin     : translations.origin
        destination: translations.destination
        comments   : translations.comments
        stars      : translations.stars
        status     : translations.status
        operationsHistory : translations.operationsHistory
        user        : translations.user
        number      : translations.number
        id          : translations.id
        operators   : translations.operators
        companyName : translations.companyName
        mustNotBeEmail: translations.mustNotBeEmail
        role        : translations.role
        agree       : translations.agree
        admin       : translations.admin

  $grid =
    rows : {}
    page : 0
    pages: 0
    totalPages: [1]


    show : (method, params) ->
      $timeout(->
        $grid[method](params)
      ,
        300
      ,
        true
      )

    passengers : ->
      $("#passengers").GridUnload()
      $("#passengers").jqGrid
        defaultExportFilename: "passengers"
        url: "#{$apiLink}technoRidesUsersApi/jq_users?token=#{$user.token}"
        editurl: "#{$apiLink}technoRidesUsersApi/jq_user_edit?type=USER&token=#{$user.token}"
        colNames: [
          $tr.createdAt
          $tr.email
          $tr.password
          $tr.name
          $tr.lastName
          $tr.phone
          $tr.enabled
        ]
        rowNum: 13
        colModel: [
          {
            name: "created_at"
            editable: false
            search: false
            sortable: false
          }
          {
            name: "username"
            editable: true
            searchoptions:
              sopt: ["cn"]

            editrules:
              email: true
              required: true
          }
          {
            name: "password"
            search: false
            edittype: "password"
            editable: true
            editrules:
              required: true

            viewable: false
            sortable: false
            hidden: false
          }
          {
            name: "firstName"
            editable: true
            editrules:
              required: true
          }
          {
            name: "lastName"
            editable: true
            editrules:
              required: true
          }
          {
            name: "phone"
            editable: true
            editrules:

              required: true

            editoptions:
              size: 10
              manlength: 3
          }
          {
            name: "agree"
            search: false
            editable: true
            editrules:
              required: true

            edittype: "checkbox"
          }
        ]
        sortname: "firstName"
        sortorder: "desc"
        caption: $tr.passengers
        height: 500
        autowidth: true
        scrollOffset: 1
        viewrecords: true
        pager: "#pager"
        datatype: "json"

      $("#passengers").navGrid "#pager",
        add: true
        edit: true
        del: false
        search: true
        refresh: true

      $grid.addExportButton "#passengers", "#pager"

    corpHistory : (id) ->
      $("#corp-history").GridUnload()
      $("#corp-history").jqGrid
        defaultExportFilename: "Operations"
        url: "#{$apiLink}technoRidesCorporateOperationsApi/jq_company_operation_history?token=#{$user.token}&cost_id=#{id}"
        datatype: "json"
        colNames: [
          $tr.trips
          $tr.date
          $tr.name
          $tr.lastName
          $tr.email
          $tr.origin
          $tr.destination
          $tr.ammount
        ]
        colModel: [
          {
            name: "id"
            editable: false
            editrules:
              required: true
          }
          {
            width: 250
            name: "cratedDate"
            search: false
            editable: false
            editrules:
              required: true

            sortable: false
          }
          {
            name: "firstName"
            search: true
            editable: false
            editrules:
              required: true

            sortable: false
          }
          {
            name: "lastName"
            search: true
            editable: false
            editrules:
              required: true

            sortable: false
          }

          {
            name: "email"
            search: false
            editable: false
            editrules:
              required: true

            sortable: false
          }
          {
            name: "placeFrom"
            search: false
            editable: false
            editrules:
              required: true

            sortable: false
          }
          {
            name: "placeTo"
            search: false
            editable: false
            editrules:
              required: true

            sortable: false
          }
          {
            name: "amount"
            search: false
            editable: false
          }
        ]
        sortname: "id"
        sortorder: "desc"
        caption: $tr.operationsHistory
        height: 500
        autowidth: true
        scrollOffset: 1
        viewrecords: true
        pager: "#pager"

      $("#corp-history").navGrid "#pager",
        add: false
        edit: false
        del: false
        search: true
        refresh: true

      $grid.addExportButton "#corp-history", "#pager"



    driverCharges : (driverId) ->
      $(".chargesdriver").modal("show")
      $("#driver-charges").jqGrid
        url: "#{$apiLink}technoRidesChargesDriverApi/jq_charges?token=#{$user.token}&driver_id=#{driverId}"
        editurl: "#{$apiLink}technoRidesChargesDriverApi/jq_edit_charges?token=#{$user.token}&driver_id=#{driverId}"
        colNames: [
            "Description"
            "Ammount"
            "Type"
            "Expiration Date"
        ]
        rowNum: 13
        colModel:[
          {
            name: "description"
            search: true
            editable: true
          }
          {
            name: "amount"
            search: true
            editable: true
          }
          {
            name: "driverPayment"
            editable: true
            edittype: "select"
            formatter: "select"
            editoptions:
              value: "0:Monthly; 1:Biweekly; 2:Weekly; 3:Daily"
          }
          {
            name: "expirationDate"
            search: false
            editable: true
          }
        ]
        caption: "Billing driver #{driverId}"
        height: 300
        autowidth: false
        width : 868
        scrollOffset: 1
        viewrecords: true
        pager: "#pager-charges"
        datatype: "json"

      $("#driver-charges").navGrid "#pager-charges",
        add: true
        edit: true
        del: true
        search: true
        refresh: true

    unpaid : (driverId) ->
      $("#unpaid").jqGrid
        url: "#{$apiLink}technoRidesBillingDriverApi/jq_billing_no_paid?token=#{$user.token}&driver_id=#{driverId}"
        editurl: "#{$apiLink}technoRidesBillingDriverApi/jq_edit_billing?token=#{$user.token}&driver_id=#{driverId}"
        colNames: [
          "ID"
          "Date"
          "Paid"
          "Ammount"
          "Comments"
          "Recive"
        ]
        rowNum: 13
        colModel: [
          {
            name: "billing_id"
            editable: false
            hidden: true
          }
          {
            name: "billingDate"
            search: true
            editable: true
          }
          {
            name: "hadpaid"
            search: true
            editable: true
            edittype: "checkbox"
          }
          {
            name: "amount"
            editable: true
          }
          {
            name: "comments"
            search: false
            editable: true
          }
          {
            name: "recive"
            search: true
            editable: true
            edittype: "checkbox"
            hidden: true
          }
        ]
        sortname: "Date"
        sortorder: "desc"
        caption: "Billing driver #{driverId}"
        height: 300
        autowidth: false
        width : 868
        scrollOffset: 1
        viewrecords: true
        pager: "#pager-unpaid"
        datatype: "json"

      $("#unpaid").navGrid "#pager-unpaid",
        add: false
        edit: true
        del: true
        search: false
        refresh: true

    driverBilling : (driverId) ->
      $("#driver-billing").jqGrid
        url: "#{$apiLink}technoRidesBillingDriverApi/jq_billing_history?token=#{$user.token}&driver_id=#{driverId}"
        editurl: "#{$apiLink}technoRidesBillingDriverApi/jq_edit_billing?token=#{$user.token}&driver_id=#{driverId}"
        colNames: [
            "ID"
            "Date"
            "Paid"
            "Ammount"
            "Comments"
            "Recive"
        ]
        rowNum: 13
        colModel:[
          {
            name: "id"
            editable: false
            hidden: true
          }
          {
            name: "billingDate"
            search: true
            editable: true
          }
          {
            name: "hadpaid"
            search: true
            editable: true
            edittype: "checkbox"
          }
          {
            name: "amount"
            editable: true
          }
          {
            name: "comments"
            search: false
            editable: true
          }
          {
            name: "recive"
            search: true
            editable: true
            edittype: "checkbox"
            hidden: true
          }
        ]
        sortname: "Description"
        sortorder: "desc"
        caption: "Billing driver #{driverId}"
        height: 300
        autowidth: false
        width : 868
        scrollOffset: 1
        viewrecords: true
        pager: "#pager-billing"
        datatype: "json"

      $("#driver-billing").navGrid "#pager-billing",
        add: false
        edit: false
        del: true
        search: true
        refresh: true

    driverReports : (driverId) ->
      $(".report-driver").modal("show")
      $api.send "getDriverReports", driverId
      $api.send "getDriverMonthlyReport", driverId

    zonePricing : (id) ->
      if not id?
        id = ""
      $("#zone").GridUnload()
      $("#zone").jqGrid
        url: "#{$apiLink}technoRidesZoneApi/jq_zone_pricing?token=#{$user.token}&id=#{id}"
        editurl: "#{$apiLink}technoRidesZoneApi/jq_edit_zone_pricing?token=#{$user.token}"
        colNames: [
          "id"
          "date"
          "amount"
          "From"
          "To"
        ]
        rowNum: 13
        colModel: [
          {
            name: "id"
            editable: false
            viewable: false
            hidden: true
          }
          {
            name: "date"
            editable: false
            viewable: false
            hidden: true
          }
          {
            name: "amount"
            search: false
            editable: true
            editrules:
              required: true
          }
          {
            name: "zoneFrom"
            search: true
            editable: false
            viewable: false
          }
          {
            name: "zoneTo"
            search: true
            editable: false
            viewable: false
          }
        ]
        sortname: "zoneFrom"
        sortorder: "desc"
        caption: "Zones"
        height: 300
        autowidth: true
        scrollOffset: 0
        viewrecords: true
        pager: "#pager"
        datatype: "json"
        edit:
          height: 270
      $("#zone").navGrid "#pager",
        add: false
        edit: true
        del: false
        search: true
        refresh: true

    setTotalPages : ->
      min = $grid.page - 5
      max = $grid.page + 5

      min = 1 if min < 1

      max = $grid.pages if max > $grid.pages
      $grid.totalPages = _.range(min, max + 1)

    addExportButton : (jqGridId, navGridId) ->
      $(jqGridId).navButtonAdd navGridId,
        caption: ""
        buttonicon: "ui-icon-document"
        onClickButton: ->
          if $(jqGridId).jqGrid("getGridParam", "datatype") is "json"
            $grid.exportGrid jqGridId
          else
            $grid.exportLocalGrid jqGridId
        position: "last"
        title: "Export"
        cursor: "pointer"

    exportGrid : (jqGridId) ->
      $.ajax(
        url: $(jqGridId).jqGrid("getGridParam", "url")
        dataType: "json"
        data: $.extend({}, $(jqGridId).getGridParam("postData"),
          page: 1
          rows: 999999999
        )
      ).success (data) ->
        csv = "data:application/csv;charset=utf-8,"
        csv += $(jqGridId).jqGrid("getGridParam", "colNames").join(",") + "\n"
        rows = data.rows
        $.each rows, (index, value) ->
          row = value.cell.join(",")
          csv += (if index < rows.length then row + "\n" else row)

        encodedUri = encodeURI(csv)
        defaultExportFilename = $(jqGridId).jqGrid("getGridParam", "defaultExportFilename") or jqGridId.substr(1, jqGridId.length - 1)
        csvName = defaultExportFilename

        if csvName?
          link = document.createElement("a")
          link.setAttribute "href", encodedUri
          link.setAttribute "download", csvName + ".csv"
          $("body").append link
          $(link).hide()
          link.click()

    exportLocalGrid : (jqGridId) ->
      data = {rows: $(jqGridId).jqGrid("getGridParam", "data")}

      csv = "data:application/csv;charset=utf-8,"
      csv += $(jqGridId).jqGrid("getGridParam", "colNames").join(",") + "\n"
      rows = data.rows
      cols = $.map($(jqGridId).jqGrid("getGridParam", "colModel"), (v) -> v.index)
      $.each rows, (index, value) ->
        row = $.map(cols, (c) -> value[c]).join ","
        csv += (if index < rows.length then row + "\n" else row)

      encodedUri = encodeURI(csv)
      defaultExportFilename = $(jqGridId).jqGrid("getGridParam", "defaultExportFilename") or jqGridId.substr(1, jqGridId.length - 1)
      csvName = defaultExportFilename

      if csvName?
        link = document.createElement("a")
        link.setAttribute "href", encodedUri
        link.setAttribute "download", csvName + ".csv"
        $("body").append link
        $(link).hide()
        link.click()

    notAnEmailCheck : (value, field) ->

      re = /\S+@\S+\.\S+/
      [not re.test(value), "#{field} #{$tr.mustNotBeEmail}"]

    currencyFmatter: (value, options, rowObject) ->
      if value? and value isnt 0
        pre = value.toString().slice(0,-2)
        after = value.toString().slice(-2)
        if value.toString().length is 2
          pre = "00"
        if value.toString().length is 1
          pre = "00"
          after = "0#{after}"
        result = "$ #{pre},#{after}"
      else
        result = ""
      result

    emailFormater: (value, options, row) ->
      value.split("@")[0]

]
