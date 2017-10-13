technoridesApp.factory '$apiHandler',($location, $apiAdapter, $user, $grid, $company, $message, $translate, $corporate, $drivers, $error, $paginator, $dailyReports, $monthlyReports, $driversReports, $inbox, $parkings, $map) ->
  $tr = {}
  $translate(['errorDelete','reports', 'month', 'trips', 'driver', 'date','ammount','monthReports','weekReports','dayReports','biweeklyReports','dailyReports','day']).then (translations) ->
    $tr =
      errorDelete : translations.errorDelete
      reports : translations.reports
      month : translations.month
      trips : translations.trips
      driver: translations.driver
      date : translations.date
      ammount : translations.ammount
      monthReports: translations.monthReports
      weekReports : translations.weekReports
      dayReports  : translations.dayReports
      biweeklyReports : translations.biweeklyReports
      day : translations.day
  $apiHandler =


    onGetHistory : (response, success) ->
      if success
        adaptedResponse = $apiAdapter.input.getHistory response
        $grid.page      = response.page
        $grid.rows      = adaptedResponse.rows
        $grid.pages     = adaptedResponse.pages
        $grid.setTotalPages()

    onGetScheduledHistory : (response, success) ->
      if success
        # replace whit its own adapter TODO
        adaptedResponse = $apiAdapter.input.getScheduledHistory response
        $grid.page      = response.page
        $grid.rows      = adaptedResponse.rows
        $grid.pages     = adaptedResponse.pages
        $grid.setTotalPages()

    onGetOperationFlow : (response, success) ->
      if response.status is 411
        $user.logout()
      else
        $company.operationFlow = response

    onGetSingleDriver : (response, success) ->
      if success
        return $apiAdapter.input.getSingleDriver response
      else
        return false
    onGetDrivers      : (response, success) ->
      adaptedResponse = $apiAdapter.input.getDrivers response
      $grid.page  = response.page
      $grid.rows  = adaptedResponse.rows
      $grid.pages = adaptedResponse.pages
      $grid.setTotalPages()

    onGetCompanyConfiguration : (response,success) ->
      $apiAdapter.input.getCompanyConfiguration(response)


    onGetCompanyData : (response, success) ->
      $company.save $apiAdapter.input.getCompanyData(response)

    onEditCompanyData : (response, success) ->
      if success
        $message.success.show "updatedCompayDataSuccess"
        $company.location = "#{$company.latitude}, #{$company.longitude}"
      else
        $message.error.show "updatedCompanyDataError"

    onDisconectDriverFromSocket : (response , success) ->
      if response.status is 411
        $user.logout()

    onChangePassword : (response, success) ->
      if success
        $message.success.show "passwordChangedSuccess"
      else
        $message.error.show "passwordChangedError"

    onAddNewDriver : (response,success) ->
      if success
        $message.success.show "driverAddedSuccess"
      else
        if response.status is 400
          $message.error.show "driverAlreadyExists"
        else
          $message.error.show "driverAddedError"

    onReloadZones : (response, success) ->
      if response.status is 411
        $user.logout()
    onDeleteDriver : (response, success) ->
      if success
        $message.success.show "driverDeletedSuccess"
      else
        $message.error.show "driverDeletedError"


    onEditDriver : (response,success) ->
      if success
        $message.success.show "driverEditedSuccess"
      else
        $message.error.show "driverEditedError"

    onGetReports : (response, success) ->
      # IMPROVE
      $("#reports").GridUnload()
      $("#reports").jqGrid
        defaultExportFilename: $tr.reports
        data: response.rows
        datatype: "local"
        autowidth: true
        caption: $tr.reports
        scrollOffset: 1
        height: 300
        pager: "#pager"
        loadonce: true
        colNames: [
          $tr.month
          $tr.trips
          $tr.driver
        ]
        colModel: [
          {
            name : "month"
            index: "month"
          }
          {
            name : "trips"
            index: "trips"
          }
          {
            name : "email"
            index: "email"
          }
        ]

      $("#reports").navGrid "#pager",
        add: false
        edit: false
        del: false
        search: false
        refresh: false

      $grid.addExportButton "#reports", "#pager"


    onGetDailyReports :(response, success) ->
      adapted = $apiAdapter.input.getDailyReports response
      $dailyReports.remoteList = adapted.list
      $paginator.get(1)



    onGetDriversReports :(response, success) ->
      adapted = $apiAdapter.input.getDriversReports response
      $driversReports.remoteList = adapted.list
      $paginator.get(1)



    onGetMonthlyReports :(response, success) ->
      adapted = $apiAdapter.input.getMonthlyReports response
      $monthlyReports.remoteList = adapted.list
      $paginator.get(1)

    onListInboxMessages: (response, success) ->
      adapted = $apiAdapter.input.listInboxMessages response
      $inbox.remoteList = adapted.list
      $paginator.get(1)

    onGetDriverReports : (response, success) ->
      # IMPROVE

      # Daily
      $("#driver_daily_report").jqGrid
        data: response.rows
        datatype: "local"
        autowidth: false
        width : 868
        caption: $tr.dayReports
        scrollOffset: 1
        height: 300
        shrinkToFit: true
        pager: "#driver_daily_report_pager"
        colNames: [
          $tr.date
          $tr.trips
          $tr.ammount
        ]
        colModel: [
          {
            name : "date"
            index: "date"
          }
          {
            name : "trips"
            index: "trips"
          }
          {
            name : "amount"
            index: "amount"
          }
        ]

      # Weekly
      weeklyMaxDays = 7
      weeklyRows    = []
      for row in response.rows
        splittedDate = row.date.split "/"
        if Date.daysBetween(new Date(parseInt(splittedDate[2]), parseInt(splittedDate[1]) - 1, parseInt(splittedDate[0])), new Date()) - 1 < weeklyMaxDays
          weeklyRows.push row
      $("#driver_weekly_report").jqGrid
        data: weeklyRows
        datatype: "local"
        autowidth: false
        width : 868
        caption: $tr.weekReports
        scrollOffset: 1
        height: 300
        pager: "#driver_weekly_report_pager"
        colNames: [
          $tr.date
          $tr.trips
          $tr.ammount
        ]
        colModel: [
          {
            name : "date"
            index: "date"
          }
          {
            name : "trips"
            index: "trips"
          }
          {
            name : "amount"
            index: "amount"
          }
        ]


      # Biweekly
      biweeklyMaxDays = 7
      biweeklyRows    = []
      for row in response.rows
        splittedDate = row.date.split "/"
        if Date.daysBetween(new Date(parseInt(splittedDate[2]), parseInt(splittedDate[1]) - 1, parseInt(splittedDate[0])), new Date()) - 1 < biweeklyMaxDays
          biweeklyRows.push row
      $("#driver_biweekly_report").jqGrid
        data: biweeklyRows
        datatype: "local"
        autowidth: false
        width : 868
        caption: $tr.biweeklyReports
        scrollOffset: 1
        height: 300
        pager: "#driver_biweekly_report_pager"
        colNames: [
          $tr.date
          $tr.trips
          $tr.ammount
        ]
        colModel: [
          {
            name : "date"
            index: "date"
          }
          {
            name : "trips"
            index: "trips"
          }
          {
            name : "amount"
            index: "amount"
          }
        ]

    onGetDriverMonthlyReport : (response, success) ->

    onDriverUpdateTime : (response, success) ->
      $message.success.show "operationUpdateTimeSuccess"

    onOperationsConfig : (response, success) ->
      $message.success.show "operationsConfigurationSuccess"

    onAddScheduledPreset : (response, success) ->
      $message.success.show "ScheduledExecuitionPresetsSaved"

    onEditScheduledConfig : (response,success) ->
      $message.success.show "ScheduledExecuitionPresetsSaved"

    onConfigTimezone : (response, success) ->
      $message.success.show "operationsConfigurationSuccess"
    onEmailConfig : (response , success) ->
      $message.success.show "operationsConfigurationSuccess"
    onCompanyFaresConfig : (response, success) ->
      $message.success.show "faresConfigurationSaved"

    onDriverPaymentsConfig : (response, success) ->
      $message.success.show "paymentsConfigurationSuccess"

    onCompanyWebConfig : (response,success) ->
      $message.success.show "WebConfigUpdateSuccess"

    onEditParkingSettings : (response, success) ->
      $message.success.show "editParkingSettingsSuccess"

    onEditZonesSettings : (response, success) ->
      $message.success.show "editZonesSettingsSuccess"

    onGetParkings: (response, success) ->
      if success
        $apiAdapter.input.getParkings(response)

    onGetZones : (response, success) ->
      $apiAdapter.input.getZones(response)

    onGetCompanyConfiguration : (response, success) ->
      $apiAdapter.input.getCompanyConfiguration(response)

    onGetCorpAccounts : (response, success) ->
      adaptedResponse = $apiAdapter.input.getCorpAccounts response
      $grid.page  = response.page
      $grid.rows  = adaptedResponse.rows
      $grid.pages = adaptedResponse.pages
      $grid.setTotalPages()
      $corporate.statistics = adaptedResponse.statistics

    onGetCorpStats : (response, success) ->
      $apiAdapter.input.getCorpStats response

    onGetUniqueCostCenter : (response, success) ->
      $apiAdapter.input.getUniqueCostCenter response

    onGetCostCenterList : (response, success) ->
      $apiAdapter.input.getCostCenterList response

    onListLateFee : (response, success) ->
    onListTaxes : (response, success) ->
    onListTerms : (response, success) ->


    onGetCostCenterAdmins : (response, success) ->
      $apiAdapter.input.getCostCenterAdmins response

    onGetInvoices : (response, success) ->
      $corporate.history = $apiAdapter.input.getInvoices response
      $grid.page = response.page
      $grid.totalPages = response.total

    onDeleteInvoice : (response, success) ->

    onShowInvoice : (response, success) ->


    onTempativeInvoice : (response, success) ->
      $corporate.invoice.number = $apiAdapter.input.tempativeInvoice response

    onCheckEmail : (response, success) ->
      response


    defaultSuccess : ->
      #$error.showSuccess({title:"Success", text:""})

    defaultError : ->
      $error.showError({title:'Error ',text:""})

    onValidateToken : ->
    onGeDrivertHistory: ->
    onCreateNewCorpUser: ->
    onNewCorpUserCostCenter: ->
    onCreateNewInvoice : (response, success) ->
      if not success
        $message.error.show "errorInServer"

    onExportDaily: (response, success)->
      if response.status is 200 then $message.success.show "EmailReportOk"
      else $message.error.show "errorInServer"


    onExportMonthly: (response, success)->
      if response.status is 200 then $message.success.show "EmailReportOk"
      else $message.error.show "errorInServer"


    onExportDriver: (response, success)->
      if response.status is 200 then $message.success.show "EmailReportOk"
      else $message.error.show "errorInServer"

    onDriverOpExport: (response, success)->
      if response.status is 200 then $message.success.show "EmailReportOk"
      else $message.error.show "errorInServer"

    onAddEmployee: (response)->
      if response.status is 100
        $message.success.show "operatorAddedSuccess"

      else
        if response.status is 400
          $message.error.show "UserNameAlreadyExists"
        else
          $message.error.show "errorInServer"

    onEditEmployee: (response) ->
      if response.status is 100
        $message.success.show "operatorEditedSuccess"

      else
        if response.status is 400
          $message.error.show "UserNameAlreadyExists"
        else
          $message.error.show "errorInServer"



    onListEmployees : ->
    onEmployeesType : ->
    onEditCorpEmployee : ->
    onAddCorpEmployee : ->
    onSendMessageToOperators : (response, success) ->
      if response.status is 411
        $user.logout()
    onUpdateParking : ->
    onDeleteParking : ->
    onNewParking : ->
    onListInboxMessages:->
    onGetStarEmail : ->
    onGetDeletedEmail : ->
    onStarEmail : ->
    onDeleteEmail : ->
    onMarkAsReadedEmail : ->
    onGetDriverLogs : (response, success) ->
      if response.status is 411
        $user.logout()
      else
        if success
          response
        else
          []
    onGetDriverBilling : (response, success) ->
    onPayDriverPartialy : () ->
    onChargeDriverPartialy : () ->
    onPayReceiptsTotal : () ->
    onChargeInvoiceTotal : () ->
    onBallanceDriverAccount : () ->
    onEditPassenger : ->
    onGetPassengers : ->
    onDeleteSquareParking : ->
    onNewSquareParking : ->
    onUpdateSquareParking : ->
    onGetSquareParkings : (response, success) ->
      parkings = {}
      for parking in response.rows
        pathOut = []
        pathIn  = []
        for o in JSON.parse parking.coordinatesOut
          pathOut.push $map.latLng {lat:o.lat, lng:o.lng}
        for o in JSON.parse parking.coordinatesIn
          pathIn.push $map.latLng {lat:o.lat, lng:o.lng}
        parkings[parking.id] =
          polygonOut: $map.polygon(pathOut, {draggable: true, noClip: true, smoothFactor: 2.0, parkingId: parking.id, name : parking.name})
          polygonIn : $map.polygon(pathIn, {draggable: true, noClip: true, smoothFactor: 2.0, parkingId: parking.id, name : parking.name})
          id     : parking.id
          name   : parking.name
        parkings[parking.id].polygonOut.setStyle(fillColor: '#f0AD4E', color: '#f0AD4E')
        parkings[parking.id].polygonIn.setStyle(fillColor: '#009a81', color: '#009a81')
        parkings[parking.id].polygonOut.on "click", (e) ->
          $parkings.deactivateEdit()
          $parkings.activateEdit e.target.options.parkingId

        parkings[parking.id].polygonIn.on "click", (e) ->
          $parkings.deactivateEdit()
          $parkings.activateEdit e.target.options.parkingId

        parkings[parking.id].polygonOut.on "edit", (e) ->
          park = $parkings.getSingleParking e.target.options.parkingId
          $parkings.save park
        parkings[parking.id].polygonIn.on "edit", (e) ->
          park = $parkings.getSingleParking e.target.options.parkingId
          $parkings.save park

      $parkings.list = parkings
    onEditZonePricing : ->
    validatePolygon : ->
      if response.status is 400
        alert("polygon invalid")
    onEditParkingName : ->
