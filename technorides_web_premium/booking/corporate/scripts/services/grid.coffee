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
            formatter: $grid.currencyFmatter

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

    corpAccounts : ->
      $("#corp-acounts").jqGrid
        url: "#{$apiLink}technoRidesUsersApi/jq_corporative_account?token=#{$user.token}"
        editurl: "#{$apiLink}technoRidesUsersApi/jq_user_edit?type=CORPORATEACCOUNT&token=#{$user.token}"
        colNames: [
          $tr.companyName
          $tr.email
          $tr.password
          $tr.phone
          $tr.enabled
          $tr.id
        ]
        rowNum: 13
        colModel: [
          {
            name: "companyName"
            editable: true
          }
          {
            name: "username"
            editable: true
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
          {
            name: "id"
            hidden: true
          }
        ]
        sortname: "firstName"
        sortorder: "desc"
        caption: "Companies"
        height: 300
        autowidth: true
        scrollOffset: 1
        viewrecords: true
        pager: "#pager-acounts"
        datatype: "json"

      $("#corp-acounts").navGrid "#pager-acounts",
        add: true
        edit: true
        del: false
        search: true
        refresh: true

    corpUsers : (id) ->
      $("#corp-users").jqGrid
        url: "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_list?token=#{$user.token}&id_cost=#{id}"
        editurl: "#{$apiLink}technoRidesCorporateUserApi/jq_admin_corporate_user_edit?id_cost=#{id}&token=#{$user.token}"
        colNames: [
          $tr.user
          $tr.password
          $tr.name
          $tr.lastName
          $tr.phone
          $tr.agree
          $tr.admin
          "Super user"
        ]
        rowNum: 13
        colModel: [
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
          {
            name: "admin"
            search: false
            editable: true
            editrules:
              required: true

            edittype: "checkbox"
          }
          {
            name: "corporateSuperUser"
            search : false
            editable : true
            edittype: "checkbox"
            viewable: false
            hidden: true
          }
        ]
        sortname: "firstName"
        sortorder: "desc"
        caption: "Employees"
        height: 300
        autowidth: true
        scrollOffset: 1
        viewrecords: true
        pager: "#pager-users"
        datatype: "json"

      $("#corp-users").navGrid "#pager-users",
        add: true
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

]
