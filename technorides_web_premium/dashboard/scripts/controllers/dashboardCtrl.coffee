technoridesApp.controller 'dashboardCtrl' , ($scope, $user, $window, $api, $apiAdapter, $apiHandler, $settings, $feedback, $grid, $rootScope,
  $location, $company, $map, $timeout, $interval, $message, $sce, $translate, $cookieStore, $versionDetector, $corporate, $http, $templateCache, $inbox, $drivers, $employees,$route, $modal) ->

  $scope.modal = $modal
  # Used by common
  $map.chooseProvider("mapbox")

  $scope.editcompanyview = false
  $templateCache.removeAll();
  $scope.settings = $settings
  $scope.newInvoice = false
  $scope.NewCompanyStep = 1
  $scope.newCompany =
    size : "small"

  $scope.languageDateFormat = ""
  $scope.tinymceOptions =
    menubar  : false
    statusbar: false
    plugins  : [
      "advlist autolink lists link image charmap print preview anchor"
      "searchreplace visualblocks code fullscreen"
      "insertdatetime media contextmenu paste"
    ]
    toolbar: [
      "undo redo | styleselect | link image"
    ]
    handle_event_callback: (e) ->

  $interval(->
    $api.send "validateToken"
  ,
    $settings[$settings.environment].intervals.validateToken
  ,
    0
  ,
    false
  )

  $api.setAdapter($apiAdapter)
  $api.setHandler($apiHandler)
  $scope.drivers = $drivers
  $scope.employees = $employees
  $scope.user = $user
  # FIXME

  $scope.corporate = $corporate
  $user.loadFromCookies()
  $scope.company = $company
  $scope.feedback = $feedback
  $scope.company = $company
  $scope.grid = $grid
  $scope.grid.lang = $sce.trustAsResourceUrl "//cdn.jsdelivr.net/jqgrid/4.6.0/i18n/grid.locale-#{$user.lang}.js"

  $scope.timezones = []
  $scope.timezoneDic = {}
  i = 1
  $scope.timezones.push(
    value: null
    name : "--"
    tz : null
    selected : true
  )
  while i < 13
    timezone = "0#{i}00".slice(-4)

    $scope.timezoneDic["Etc/GMT+#{i}"] = "+#{timezone}"
    $scope.timezoneDic["Etc/GMT-#{i}"] = "-#{timezone}"

    $scope.timezones.push(
      value: "Etc/GMT-#{i}"
      name : "Etc/GMT+#{i}"
      tz   : "+#{timezone}"
      selected : false
    )
    $scope.timezones.push(
      value: "Etc/GMT+#{i}"
      name : "Etc/GMT-#{i}"
      tz   : "-#{timezone}"
      selected : false
    )
    i++

  $interval(->
    if $company.config.timeZone?
      stat = $scope.timezoneDic[$company.config.timeZoneStatic]
      if stat?
        $scope.selectedTime = moment(new Date()).zone(stat).format("hh:mm:ss")
      $scope.serverDate = moment(new Date()).zone("-0300").format("hh:mm:ss")
      if $company.config.timeZone.tz?
        $scope.selectedTimezone = moment(new Date()).zone($company.config.timeZone.tz).format("hh:mm:ss")
  ,
    1000
  )

  $scope.editDriver = {}
  $scope.error = $message.error
  $scope.success = $message.success
  $scope.warning = $message.warning
  $rootScope.$watch(
    ->
      $location.path()
    (path) ->
      $scope.loadAllGrids()
    )

  $scope.setLangDateFormat = (lang)  ->
    unless lang is "es" then $scope.languageDateFormat    = 'MM/dd/yyyy'
    else
      $scope.languageDateFormat = 'dd/MM/yyyy'


  # Set language
  if $cookieStore.get("lang")?
    $scope.lang = $cookieStore.get("lang")
    $scope.setLangDateFormat($scope.lang)
  else
    $scope.lang = $user.lang
    $scope.setLangDateFormat($user.lang)

  # Language supported?
  $scope.lang = "en" unless $.inArray $scope.lang, ["en", "es", "fr"]

  $translate.use($scope.lang)

  $scope.changeLanguage = (lang) ->
    $translate.use(lang)
    $cookieStore.remove("lang")
    $cookieStore.put("lang", lang)
    $scope.setLangDateFormat(lang)
    $scope.lang = lang
    $route.reload()

  $scope.getHistory = (page, s) ->
    if not s.search?
      s.search = ""
    $scope.historyLoader = true
    if s.date?.start? and s.date?.end?
      date = s.date
    else
      date =
        start : null
        end   : null
    $api.send 'getHistory', {page: page, search: s, date: date}, ->
      $scope.historyLoader = false


  $scope.getOperationFlow = (id) ->
    $api.newApiSend 'getOperationFlow', {id: id}, ->
      $corporate.history.id = id
      $(".showOphistory").modal("show")
      $timeout ->
        $('a[data-toggle=popover]').popover()
      ,
        1000
      ,
        true


  $scope.fixFaresGridWidth = ->
    $timeout ->
      # FIXME Fixing width bug
      $("#zone").setGridWidth($("#zone").parent().parent().parent().parent().parent().width(), true)
    ,
      1
    ,
      true

  $scope.confTab = 1
  $scope.loadAllGrids = (subTab) ->
    switch $location.path()
      when "/history"
        $scope.getHistory($scope.grid.page, {date:{start : null,end: null}})


      when "/employees/drivers"
        $drivers.getDrivers(1, "")

      when "/employees/operators"
        $employees.getEmployees(false,1,"")
        $employees.getTypes()

      when "/profile"
        $api.send "getCompanyData"

      when "/configuration/scheduled"
        $scope.getScheduledConfig()

      when "/reports"
        $grid.show "reports"

  $scope.refreshConfig = ->
    $api.send "getCompanyConfiguration", {}, ->
      $api.send "getCompanyData"

  #check if configuration is on, else bring it on
  if not $corporate.config?
    $scope.refreshConfig()

  $scope.logout = ->
    $user.logout()

  # Logged? or Company?
  if !$user.isLogged or $user.role isnt "company"
    $scope.logout()

  $scope.getScheduledConfig = ->
    $api.send "getScheduledConfig", {}, (response) ->
      $scope.scheduledPresets = $apiAdapter.input.getScheduledConfig response

  $scope.deleteScheduledPreset = (id) ->
    $api.send "deleteScheduledPreset", id, ->
      $scope.getScheduledConfig()

  $scope.addScheduledPreset = (preset, modal) ->
    if modal
      $api.send "addScheduledPreset", preset, ->
        $(".add-scheduled-preset").modal("hide")
        $scope.getScheduledConfig()
    else
      $(".add-scheduled-preset").modal("show")
      false


  $scope.editCompany = (company) ->
    $api.send "editCompanyData", company

  $scope.changeFareType = () ->
    switch Number $company.config.fares.type
      when 0
        $company.config.zones.enabled = false
        $company.config.fares.fareCalculator = false
      when 1
        $company.config.zones.enabled = true
        $company.config.fares.fareCalculator = false
      when 2
        $company.config.zones.enabled = false
        $company.config.fares.fareCalculator = true

  $scope.showLocation = ->
    $(".location-map").modal("show")

    return false

  $scope.editPassword = (password) ->
    if password.news is password.repeat
      $api.send "changePassword", password.news


  $scope.driver = {}
  $scope.addDriver = ->
    $scope.driver = {}
    $(".add-driver").modal("show")
    return false

  $scope.searchFare = (id) ->
    $grid.show "zonePricing", id

  $scope.addNewDriver = (driver) ->
    console.log driver
    $api.send "addNewDriver", driver, ->
      $drivers.getDrivers($drivers.page, $scope.search)
    $(".add-driver").modal("hide")
    return false

  $scope.delDriver = (id) ->
    $(".delete-driver").modal("show")
    $scope.toDelete = id

  $scope.deleteDriver = (id) ->
    $(".delete-driver").modal("hide")
    $api.send "deleteDriver", id, ->
       $drivers.getDrivers($drivers.page, $scope.search)

# CONFIGURATION FUNCTIONS
  $scope.driverUpdateTime = (driver) ->
    $api.post "driverUpdateTime", driver

  $scope.editScheduledConfig = (scheduled) ->
    $api.post "editScheduledConfig", scheduled

  $scope.editOperationsConfig = (ops) ->
    $api.post "operationsConfig", ops

  $scope.driverPaymentsConfig = (payments) ->
    $api.post "driverPaymentsConfig", payments



  $scope.configEmail = (email) ->
    $api.post "emailConfig", email

  $scope.companyWebConfig = (web) ->
    $api.post "companyWebConfig", web

  $scope.editParkingSettings = (parking) ->
    $api.post "editParkingSettings", parking

  $scope.editCorporateCompany  = (company) ->
    $api.send "editCorporateCompany", company
    $scope.editcompanyview = false


  $scope.modalNewCompany = ->
    $(".add-company").modal("show")
    false

  $scope.modalChangeCompanyLogo = ->
    $(".edit-company-image").modal("show")
    false

  $scope.addNewCompany = (company) ->
    $api.send "addNewCorpAccount", company, (response)->
      $scope.newuser            = {}

      $scope.newuser.costCenter = response.id_cost
      $scope.NewCompanyStep     = 2

  $scope.createDefaultCostCenter = (user) ->
    $api.send "createNewCorpUser", user, ->
    $scope.NewCompanyStep = 4

  $scope.createCostCenter = (user) ->
    $api.send "newCorpUserCostCenter", user, ->
    $scope.NewCompanyStep = 4

  $scope.goToStep = (number) ->
    $scope.NewCompanyStep = number

  $scope.finishWizard = ->
    $(".add-company").modal("hide")
    $corporate.companies.getCompanies("")
    $scope.NewCompanyStep = 1
    $scope.newuser = {}
    $scope.newCompany = {}
    $scope.newCompany.size = 'small'

  $scope.showOpHistory = (row) ->
    $scope.row = row
    $scope.opId = row.id
    $scope.timeline = row.log_operation
    $(".showOphistory").modal("show")
    $(".showOphistory").modal("show")
    $timeout ->
      $('a[data-toggle=popover]').popover()
    ,
      1000
    ,
      true
    false

  $scope.modalExportHistory = ->
    $(".exportHistory").modal("show")
    false


  $scope.modalRecordPayment = ->
    $(".recordPayment").modal("show")
    false

  $scope.recordNewPayment = (payment) ->
    $api.send "recordInvoicePayment", payment, (response) ->
      $api.send "showInvoice", $corporate.invoice.id
      $scope.payment = {}
      if response.status is 100
        $scope.paymentRecibed = true
      else
        $scope.paymentRejected = true

  $scope.setErrorsRecordPayment = (bool, close)->
    $scope.paymentRejected = bool
    $scope.paymentRecibed = bool
    if close
      $(".recordPayment").modal("hide")
      false

  $scope.exportOperationsHistory = (date) ->
    $api.send "exportOpHistory", date
    $(".exportHistory").modal("hide")
    false


  # INITIALIZE DEFAULT SELECTORS OF NEW TRANSACTION
  # let fee modal
  $scope.invoice =
    billingDate : new Date()
  $scope.fee = {}
  $scope.fee.frequencyOptions = [
    {name: "Every day",       value: 1}
    {name: "Every week",      value: 2}
    {name: "Every fortnight",  value:3}
    {name: "Every month",     value: 4}
  ]
  $scope.fee.chargeType = [
    {name: "% Per annum", value: 1}
    {name: "Flat",       value: 2}
  ]

  $scope.showOpDetailsCurrentIds = []


  $scope.showOpDetails = (id) ->
    index = $scope.showOpDetailsCurrentIds.indexOf(id)
    unless index != -1
      $scope.showOpDetailsCurrentIds.push id
    else
      $scope.showOpDetailsCurrentIds.splice index, 1

  $scope.deleteCompany = (id) ->
    $api.send "deleteCompany", id, ->
      $(".delete-company").modal("hide")
      $corporate.companies.getCompanies("")


  $scope.modalDeleteCompany = (id) ->
    $(".delete-company").modal("show")
    $scope.todeleteCompany = id


  $scope.modalReloadZones = ->
    $(".reload-zone").modal("show")
    false

  $scope.reloadZones = ->
    $api.newApiSend "reloadZones"
    $(".reload-zone").modal("hide")
    false

  $scope.removeOpFromNewInvoiceList = (index, id, callback) ->
    for op, key in $corporate.invoiceUsersOp
      if op.opId is id
        if $corporate.invoiceUsersOp.length is 1
          $corporate.invoiceUsersOp = []
        else
          $corporate.invoiceUsersOp.splice(key,1)
    for key, op of $scope.invoice.operations
      if op.opId is id
        delete $scope.invoice.operations[key]

    $scope.recalculateInvoiceTotal($scope.invoice.operations)

  $scope.printInvoice =  ->
    printContents = $("#print-point").html()
    if navigator.userAgent.toLowerCase().indexOf('chrome') > -1
        popupWin = window.open('', '_blank', 'width=600,height=600,scrollbars=no,menubar=no,toolbar=no,location=no,status=no,titlebar=no')
        popupWin.window.focus()
        popupWin.document.write("<!DOCTYPE html><html><head><link rel='stylesheet' type='text/css' href='styles/dashboard.css' />
          <link rel='stylesheet' type='text/css' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css'/></head><body onload='window.print()'><div class='reward-body'>#{printContents}</div></html>");
        popupWin.onbeforeunload = (event) ->
            popupWin.close();
            return '.\n';

        popupWin.onabort = (event) ->
            popupWin.document.close();
            popupWin.close();

    else
        popupWin = window.open('', '_blank', 'width=800,height=600')
        popupWin.document.open()
        popupWin.document.write("<html><head><link rel='stylesheet' type='text/css' href='style.css' /></head><body onload='window.print()'>#{printContents}</html>")
        popupWin.document.close()

    popupWin.document.close()

    return true;

  $scope.modalAddCostCenter = ->
    $(".add-costCenter").modal("show")
    false

  $scope.addCostCenter = (user) ->
    user.companyId = $corporate.id
    $api.send "newCostCenter", user
    $(".add-costCenter").modal("hide")
    false
  $scope.driver = {}
  $scope.configTimezone = (time) ->
    $api.post "configTimezone", time, ->
      $scope.refreshConfig()

  $scope.showEditCorpCompany = (bool) ->
    $scope.editcompanyview = bool
