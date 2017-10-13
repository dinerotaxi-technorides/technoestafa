technoridesApp.factory '$apiAdapter',($settings, $user, $map, $company, $filter, $cookieStore, $timeout, $parkings, $zones) ->

  $apiLink    = $settings[$settings.environment].api
  $newApiLink = $settings[$settings.environment].newApi

  $apiAdapter =
    isSuccessStatus : (key, status) ->
      $codes =
        success                 :
          exportDaily           : 200
          exportMonthly          : 200
          exportDriver          : 200
          DriverOpExport        : 200
          getSquareParkings     : 100
          sendEmail             : 100
          getCompanyData        : 200
          editCompanyData       : 200
          changePassword        : 200
          addNewDriver          : 100
          deleteDriver          : 100
          editDriver            : 100
          getParkings           : 100
          getZones              : 100
          updateZone            : 100
          editZone              : 100
          editZoneName          : 100
          getCorpStats          : 100
          getUniqueCostCenter   : 100
          getCostCenterList     : 100
          editCorpAccount       : 100
          getHistory            : 100
          getOperationFlow      : 100
          getCostCenterAdmins   : 100
          getInvoices           : 100
          getDriverEmail        : 100
          getPassengerEmail     : 100
          getEnterpriseEmail    : 100
          showInvoice           : 100
          getSingleDriver       : 200
          deleteTerm            : 100
          deleteTax             : 100
          deleteLateFee         : 100
          getScheduledHistory   : 100
          getDriverLogs         : 100
          disconectDriverFromSocket: 200
          createNewInvoice      : 100
          getDriverBilling      : 200
          payDriverPartialy     : 200
          chargeDriverPartialy  : 200
          chargeInvoiceTotal    : 200
          payReceiptsTotal      : 200
          ballanceDriverAccount : 200
          validatePolygon       : 200
      $codes.success[key] == status

    url :
      editParkingName        : "#{$apiLink}technoRidesParkingApi/jq_edit_parking"
      getZonePricing         : "#{$apiLink}technoRidesZoneApi/jq_zone_pricing"
      editZonePricing        : "#{$apiLink}technoRidesZoneApi/jq_edit_zone_pricing"
      exportDaily            : "#{$apiLink}technoRidesReportApi/export_jq_report_tx_day"
      exportMonthly          : "#{$apiLink}technoRidesReportApi/export_jq_report_tx_month"
      exportDriver           : "#{$apiLink}technoRidesReportApi/export_jq_report_tx"
      DriverOpExport         : "#{$apiLink}technoRidesReportApi/export_company_operation_history"
      updateSquareParking    : "#{$apiLink}technoRidesParkingApi/jq_edit_parking"
      deleteSquareParking    : "#{$apiLink}technoRidesParkingApi/jq_edit_parking"
      newSquareParking       : "#{$apiLink}technoRidesParkingApi/jq_edit_parking"
      getSquareParkings      : "#{$apiLink}technoRidesParkingApi/jq_parking"
      editPassenger          : "#{$apiLink}technoRidesUsersApi/jq_user_edit"
      getPassengers          : "#{$apiLink}technoRidesUsersApi/jq_users"
      ballanceDriverAccount  : "#{$apiLink}technoRidesDriverCorporateApi/balance_account"
      payReceiptsTotal       : "#{$apiLink}technoRidesDriverCorporateApi/pay_receipts"
      chargeInvoiceTotal     : "#{$apiLink}technoRidesDriverCorporateApi/charge_invoices"
      chargeDriverPartialy   : "#{$apiLink}technoRidesDriverCorporateApi/charge_invoices_partialy"
      payDriverPartialy      : "#{$apiLink}technoRidesDriverCorporateApi/pay_receipts_partialy"
      getDriverBilling       : "#{$apiLink}technoRidesDriverCorporateApi/dashboard"
      exportCorpEmployees    : "#{$apiLink}technoRidesCorporateOperationsApi/generate_report"
      getDriverLogs          : "#{$newApiLink}driver_connection"
      getDriverInvoices      : "#{$apiLink}technoRidesDriverCorporateApi/invoice_list"
      getDriverReceipts      : "#{$apiLink}technoRidesDriverCorporateApi/receive_list"
      getDriverHistoryInvoices: "#{$apiLink}technoRidesDriverCorporateApi/invoice_history_list"
      getDriverHistoryReceipts: "#{$apiLink}technoRidesDriverCorporateApi/receive_history_list"
      sendMessageToOperators : "#{$newApiLink}operator/notification"
      getCorpOperations      : "#{$apiLink}technoRidesCorporateOperationsApi/jq_company_operation_history"
      employeesType          : "#{$apiLink}technoRidesUsersApi/jq_get_type"
      listEmployees          : "#{$apiLink}technoRidesUsersApi/jq_employ_users"
      deleteEmployee         : "#{$apiLink}technoRidesUsersApi/jq_user_edit"
      editEmployee           : "#{$apiLink}technoRidesUsersApi/jq_user_edit"
      addEmployee            : "#{$apiLink}technoRidesUsersApi/jq_user_edit"
      listCorpEmployees      : "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_list"
      getCorpEmployee        : "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_list"
      editCorpEmployee       : "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_edit"
      addCorpEmployee        : "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_edit"
      sendEmail              : "#{$apiLink}technoRidesEmailApi/send_mail?"
      getDrivers             : "#{$apiLink}technoRidesUsersApi/jq_employ_users_driver"
      getSingleDriver        : "#{$apiLink}technoRidesUsersApi/get_driver"
      getCompanyData         : "#{$apiLink}technoRidesUsersApi/jq_get_information_company"
      driverImage            : "#{$apiLink}taxiApi/displayDriverLogoByEmail?email="
      editCompanyData        : "#{$apiLink}technoRidesUsersApi/jq_edit_information_company"
      changePassword         : "#{$apiLink}technoRidesUsersApi/jq_edit_information_company"
      addNewDriver           : "#{$apiLink}technoRidesUsersApi/jq_driver_profile"
      deleteDriver           : "#{$apiLink}technoRidesUsersApi/jq_employ_users_del"
      editDriver             : "#{$apiLink}technoRidesUsersApi/jq_driver_profile"
      getReports             : "#{$apiLink}technoRidesReportApi/jq_report_tx"
      getMonthlyReports      : "#{$apiLink}technoRidesReportApi/jq_report_tx_month"
      getDailyReports        : "#{$apiLink}technoRidesReportApi/jq_report_tx_day"
      getDriverReports       : "#{$apiLink}technoRidesReportApi/jq_report_driver_ammount"
      getDriverMonthlyReport : "#{$apiLink}technoRidesReportApi/jq_report_driver_ammount"
      getDriversReports      : "#{$apiLink}technoRidesReportApi/jq_report_tx"
      driverUpdateTime       : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      getCompanyConfiguration: "#{$apiLink}technoRidesConfigurationAppApi/jq_config"
      getScheduledConfig     : "#{$apiLink}technoRidesDelayOperationsApi/delay_operation_config_list"
      addScheduledPreset     : "#{$apiLink}technoRidesDelayOperationsApi/delay_operation_config_edit"
      deleteScheduledPreset  : "#{$apiLink}technoRidesDelayOperationsApi/delay_operation_config_edit"
      configTimezone         : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      editZonesSettings      : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      operationsConfig       : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      editScheduledConfig    : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      emailConfig            : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      driverPaymentsConfig   : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      companyFaresConfig     : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      companyWebConfig       : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      editParkingSettings    : "#{$apiLink}technoRidesConfigurationAppApi/jq_edit_config"
      getParkings            : "#{$apiLink}technoRidesParkingApi/jq_parking"
      updateParking          : "#{$apiLink}technoRidesParkingApi/jq_edit_parking"
      deleteParking          : "#{$apiLink}technoRidesParkingApi/jq_edit_parking"
      newParking             : "#{$apiLink}technoRidesParkingApi/jq_edit_parking"
      getZones               : "#{$apiLink}technoRidesZoneApi/jq_zone"
      updateZone             : "#{$apiLink}technoRidesZoneApi/jq_edit_zone"
      deleteZone             : "#{$apiLink}technoRidesZoneApi/jq_edit_zone"
      editZoneName           : "#{$apiLink}technoRidesZoneApi/jq_edit_zone"
      editZone               : "#{$apiLink}technoRidesZoneApi/jq_edit_zone"
      newZone                : "#{$apiLink}technoRidesZoneApi/jq_edit_zone"
      validateToken          : "#{$apiLink}technoRidesOperationsApi/jq_company_operation_history?_search=false&nd=1418153285632&rows=1&page=1&sidx=id&sord=asc"
      changeDriverImage      : "#{$apiLink}taxiApi/uploadPhotoCropped"
      changeCompanyImage     : "#{$apiLink}technoRidesCorporateUserApi/upload_logo_croped"
      corpImg                : "#{$apiLink}technoRidesCorporateUserApi/display_logo"
      getCorpAccounts        : "#{$apiLink}technoRidesCorporateUserApi/corporate_list"
      getSingleCorpAccount   : "#{$apiLink}technoRidesCorporateUserApi/corporate_view_list"
      deleteCompany          : "#{$apiLink}technoRidesCorporateUserApi/corporate_edit"
      getCorpStats           : "#{$apiLink}technoRidesCorporateUserApi/dashboard"
      addNewCorpAccount      : "#{$apiLink}technoRidesCorporateUserApi/corporate_edit"
      editCorpAccount        : "#{$apiLink}technoRidesCorporateUserApi/corporate_edit"
      createNewCorpUser      : "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_edit"
      getUniqueCostCenter    : "#{$apiLink}technoRidesCorporateUserApi/cost_center_list"
      EditCorporateUserList  : "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_edit"
      newCorpUserCostCenter  : "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_edit"
      newCostCenter          : "#{$apiLink}technoRidesCorporateUserApi/cost_center_edit/"
      getCostCenterList      : "#{$apiLink}technoRidesCorporateUserApi/cost_center_list"
      deleteCostCenter       : "#{$apiLink}technoRidesCorporateUserApi/cost_center_edit"

      getHistory             : "#{$apiLink}technoRidesOperationsApi/jq_company_operation_history"
      getScheduledHistory    : "#{$apiLink}technoRidesOperationsApi/jq_company_schedule_operation_history"
      corpEmployeeHistory    : "#{$apiLink}technoRidesOperationsApi/jq_company_operation_history"
      getOperationFlow       : "#{$newApiLink}operations/logs/"
      exportOpHistory        : "#{$apiLink}technoRidesOperationsApi/generate_report"
      addlateFee             : "#{$apiLink}technoRidesInvoiceApi/late_fee_config_edit"
      deleteLateFee          : "#{$apiLink}technoRidesInvoiceApi/late_fee_config_edit"
      listLateFee            : "#{$apiLink}technoRidesInvoiceApi/late_fee_config_list"
      addTax                 : "#{$apiLink}technoRidesInvoiceApi/tax_config_edit"
      deleteTax              : "#{$apiLink}technoRidesInvoiceApi/tax_config_edit"
      listTaxes              : "#{$apiLink}technoRidesInvoiceApi/tax_config_list"
      listTerms              : "#{$apiLink}technoRidesInvoiceApi/term_config_list"
      addTerm                : "#{$apiLink}technoRidesInvoiceApi/term_config_edit"
      deleteTerm             : "#{$apiLink}technoRidesInvoiceApi/term_config_edit"
      getOperationsOn        : "#{$apiLink}technoRidesOperationsApi/get_operation_for_invoice_cost"
      getCostCenterAdmins    : "#{$apiLink}technoRidesInvoiceApi/cost_center_emails"

      getInvoices            : "#{$apiLink}technoRidesInvoiceApi/invoice_list"
      deleteInvoice          : "#{$apiLink}technoRidesInvoiceApi/delete_invoice"
      showInvoice            : "#{$apiLink}technoRidesInvoiceApi/get_invoice"
      createNewInvoice       : "#{$apiLink}technoRidesInvoiceApi/generate_invoice"
      editInvoice            : "#{$apiLink}technoRidesInvoiceApi/edit_invoice"
      checkEmail             : "#{$apiLink}usersApi/isAvailable"
      editCorporateCompany   : "#{$apiLink}technoRidesCorporateUserApi/corporate_edit"
      recordInvoicePayment   : "#{$apiLink}technoRidesInvoiceApi/record_payment"
      deleteInvoicePayment   : "#{$apiLink}technoRidesInvoiceApi/record_payment"
      reloadZones            : "#{$newApiLink}zones/"
      listInboxMessages      : "#{$apiLink}inboxApi/inbox"
      getStarEmail           : "#{$apiLink}inboxApi/star_list"
      getDeletedEmail        : "#{$apiLink}inboxApi/trash_list"
      starEmail              : "#{$apiLink}inboxApi/star"
      deleteEmail            : "#{$apiLink}inboxApi/trash"
      markAsReadedEmail      : "#{$apiLink}inboxApi/markReaded"
      getDriverHistory       : "#{$apiLink}technoRidesOperationsApi/jq_company_operation_history"
      activateDriver            : "#{$apiLink}technoRidesUsersApi/jq_driver_activate"
      activateEmployee          : "#{$apiLink}technoRidesCorporateUserApi/jq_corporate_user_activate"
      disconectDriverFromSocket : "#{$newApiLink}disconnect_driver/d303be78d55dfdf8df06031a76cd9065/"
      validatePolygon           : "#{$newApiLink}validate_polygon"
    # ---> Input
    # input:
    input:
      editParkingName : ->
      getZonePricing: (response) ->
        adapted =
          list : []
          page : response.page
          pages : response.total

        for row in response.rows
          adapted.list.push
            id       : row.id
            date     : new Date row.date
            amount   : row.amount
            zoneFrom : row.zoneFrom
            zoneTo   : row.zoneTo
        adapted
      getPassengers : (response) ->
        adapted =
          list : []
          page : response.page
          pages : response.total
        for row in response.rows
          adapted.list.push
            id       : row.id
            created  : new Date row.cell[0]
            email    : row.cell[1]
            name     : row.cell[3]
            lastName : row.cell[4]
            phone    : row.cell[5]
            active   : row.cell[6]
        adapted
      getDriverBilling : (response) ->
        totalOwns : response.totalOwns
        totalOwned : response.totalOwned

      getDriverLogs : (response) ->
        events = []
        for event in response.events
          if event.status?
            events.push(
              date : new Date event.updated_at
              location :
                latitude : event.location[1]
                longitude: event.location[0]
              status : event.status.toLowerCase()
            )
        events
      getOperationsForDriver: (response) ->
        adapted =
          operations : []
          subtotal   : 0
        for row in response.result
          adapted.operations.push(
            userId     : row.userId
            amount     : row.amount
            quantity   : row.count
            firstName  : row.firstName
            lastName   : row.lastName
            opId       : row.operationId
            opDate     : row.date
          )
          adapted.subtotal += row.amount
        adapted

      getDriverInvoice : (response) ->
        if response.invoice?
          response = response.invoice
          result   =
            id          : response.id
            payments    : []
            status      : response.status
            number      : response.number
            amount      : response.total
            company     :
              name      : response.companyName
            date        : new Date(response.billingDate)
            dueDate     : new Date(response.dueDate)
            operations  : []
            total       : response.total
            subtotal    : response.subTotal
            balanceDue  : response.total + response.adjustment
            adjustments : response.adjustment
            comments    : response.comments?=""
          if response.company?
            result.company =
              image     : response.company.image
              address   : response.company.address
              city      : response.company.city
              country   : response.company.country

          if response.payments?
            for payment in response.payments
              result.payments.push(
                date        : new Date(payment.paymentDate)
                mode        : payment.paymentMode
                type        : payment.type
                bankCharges : payment.bankCharges
                amount      : payment.amount
                tax         : payment.taxDeducted
                sendEmail   : payment.sendEmail
                id          : payment.id_paymnet
              )

          if response.operations?
            total = 0
            for detail in response.operations
              discountType = ""
              amount       = detail.amount
              if(detail.discountType == 1)
                discountType = "%"
                amount       = amount * ((100 - detail.discount) / 100)

              if(detail.discountType == 2)
                discountType = "$"
                amount       = amount - detail.discount

              if detail.taxId isnt 0
                amount += (detail.taxCharge * amount)/100

              total += amount
              result.operations.push(
                firstName    : detail.firstName?=""
                lastName     : detail.lastName?=""
                quantity     : detail.quantity
                amount       : detail.amount
                discount     : detail.discount
                discountType : discountType
                tax          :
                  value : detail.taxId
                  name  : detail.taxValue
                  charge: detail.taxCharge
                amount       : detail.amount
                opDate       : detail.opDate
                opId         : detail.opId
                userId       : detail.userId
              )

        else

          result = false

        result

      sendMessageToOperators : ->

      getDriverInvoices : (response) ->
        adapted =
          list : []
          totalPages : response.total
          page : response.page
        if response.rows?.length > 0
          for row in response.rows
            adapted.list.push(
              id        : row.id
              amount    : row.cell[0]
              comments  : row.cell[1]
              typeCharge: row.cell[2]
              recive    : row.cell[3]
              date      : new Date row.cell[4]
              pay       : false
            )
        adapted

      getDriverReceipts : (response) ->
        adapted =
          list : []
          totalPages : response.total
          page : response.page
        if response.rows?.length > 0
          for row in response.rows
            adapted.list.push(
              id      : row.id
              company : row.cell[2]
              from    : row.cell[8]
              to      : row.cell[9]
              costCenter : row.cell[0]
              amount  : row.cell[3]
              device : row.cell[6]
              date    : new Date(row.cell[7])
              status  : row.cell[5]
              pay     : false
            )
        adapted

      getDriverHistoryInvoices : (response) ->
        adapted =
          list : []
          totalPages : response.total
          page : response.page
        if response.rows?.length > 0
          for row in response.rows
            adapted.list.push(
              id        : row.id
              amount    : row.cell[0]
              comments  : row.cell[1]
              typeCharge: row.cell[2]
              recive    : row.cell[3]
              date      : new Date row.cell[4]
              pay       : false
            )
        adapted

      getDriverHistoryReceipts : (response) ->
        adapted =
          list : []
          totalPages : response.total
          page : response.page
        if response.rows?.length > 0
          for row in response.rows
            adapted.list.push(
              id      : row.id
              company : row.cell[2]
              from    : row.cell[8]
              to      : row.cell[9]
              costCenter : row.cell[0]
              amount  : row.cell[3]
              device : row.cell[6]
              date    : new Date(row.cell[7])
              status  : row.cell[5]
              pay     : false
            )
        adapted

      getCorpOperations : (response) ->
        adapted =
          list : []
          page : response.page
          totalPages: response.total
        for row in response.rows
          adapted.list.push(
            id           : row.cell[0]
            date         : new Date(row.cell[1])
            name         : row.cell[2]
            lastName     : row.cell[3]
            driver :
              email      : row.cell[4]
            phone        : row.cell[5]
            address  :
              from:
                street : row.cell[6]
                coords :
                  lat : row.cell[7]
                  lng : row.cell[8]
              to:
                street:   row.cell[9]
                coords :
                  lat : row.cell[10]
                  lng : row.cell[11]
              comments : row.cell[12]
              calification : row.cell[13]
              status : row.cell[14]
            ammount      : row.cell[15]
            device       : row.cell[16]
            operator     : row.cell[17]
            options :
              courier : row.cell[18]
              pet     : row.cell[19]
              airConditioning : row.cell[20]
              smoker : row.cell[21]
              specialAssistance : row.cell[22]
              luggage : row.cell[23]
              airport :  row.cell[24]
              vip     : row.cell[25]
              invoice : row.cell[26]
          )
        adapted

      corpEmployeeHistory : (response) ->
        adapted =
          history : []
          page : response.page+1
          pages : response.total
        for row in response.rows
          adapted.history.push(
            id                  : row.cell[0]
            date                : new Date(row.cell[1])
            firstName           : row.cell[2]
            lastName            : row.cell[3]
            driver              : row.cell[4]
            phone               : row.cell[5]
            origin              :
              address           : row.cell[6]
              latitude          : row.cell[14]
              longitude         : row.cell[15]
            destination         : row.cell[7]
            comments            : row.cell[8]
            stars               : row.cell[9]
            status              : row.cell[10]
            amount              : row.cell[11]
            isFrecuent          : row.cell[12]
            device              : row.cell[13]
            options             :
              messaging         : row.cell[16]
              pet               : row.cell[17]
              airConditioner    : row.cell[18]
              smoker            : row.cell[19]
              specialAssistance : row.cell[20]
              luggage           : row.cell[21]
              airport           : row.cell[22]
              vip               : row.cell[23]
              invoice           : row.cell[24]
          )
        adapted
      getCorpEmployee : (response) ->
        adapted =
          id         : response.rows[0].id
          user       : response.rows[0].cell[0]
          name       : response.rows[0].cell[2]
          lastname   : response.rows[0].cell[3]
          phone      : response.rows[0].cell[4]
          admin      : response.rows[0].cell[5]
          enabled    : response.rows[0].cell[6]
          superAdmin : response.rows[0].cell[7]

      listCorpEmployees : (response) ->
        adapted =
          list : []
          page : response.page
          pages : response.total
        for user in response.rows
          adapted.list.push(
            id  : user.id
            user : user.cell[0]
            name : user.cell[2]
            lastName: user.cell[3]
            phone : user.cell[4]
            enabled : user.cell[6]
            admin : user.cell[5]
            superUser : user.cell[7]
          )
        adapted
      listEmployees : (response) ->
        adapted =
          employees : []
          page      : response.page
          pages     : response.total

        for row in response.rows
          adapted.employees.push
            username  : /[^@]*/.exec(row.cell[0])[0]
            host      : $user.host
            firstName : row.cell[2]
            lastName  : row.cell[3]
            phone     : row.cell[4]
            typeEmploy:
              value: row.cell[5]
            agree     : row.cell[6]
            id        : row.id
        adapted

      employeesType : (response) ->
        adapted = []
        for element in $(response).children()
          adapted.push
            value: $(element).val()
        adapted

      getDriverHistory : (response) ->
        history =
          totalPages       : response.total
          page             : response.page
          operations       : []
        for row in response.rows
          history.operations.push(
            id    : row.id
            date  : row.cell[1]
            amount: row.cell[11]
            status: row.cell[10]
            corporate : row.cell[25]
            firstName           : row.cell[2]
            lastName            : row.cell[3]
            driver              : row.cell[4]
            phone               : row.cell[5]
            origin              :
              address           : row.cell[6]
              lat               : row.cell[14]
              lng               : row.cell[15]
            destination         : row.cell[7]
            comments            : row.cell[8]
            stars               : row.cell[9]
            isFrequent          : row.cell[12]
            device              : row.cell[13]
            options             :
              messaging         : row.cell[16]
              pet               : row.cell[17]
              airConditioner    : row.cell[18]
              smoker            : row.cell[19]
              specialAssistance : row.cell[20]
              luggage           : row.cell[21]
              airport           : row.cell[22]
              vip               : row.cell[23]
              invoice           : row.cell[24]
            operator            : row.cell[26]

          )

        history

      listInboxMessages : (response) ->
        mails = []
        if response.rows
          for mail in response.rows
            splittedBody = mail.body.replace(/<p>|<\/p>/g, "\n").split("\n")
            body = ""
            for line in splittedBody
              body += "<p>#{line}</p>"

            mails.push(
              id      : mail.id
              body    : body
              from    : mail.from
              star    : mail.hasStar
              id      : mail.id
              date    : mail.lastUpdated
              subject : mail.subject
              readed  : mail.wasReaded
            )

        mails

      getSingleDriver : (response) ->
        dateDivided = response.licence_end_date.split("/")
        dateFormated = "#{dateDivided[1]}-#{dateDivided[0]}-#{dateDivided[2]}"
        reg = new RegExp ("[^@]*")
        number    : reg.exec(response.email)[0]
        id        : response.id
        email     : response.email
        firstName : response.first_name
        lastName  : response.last_name
        phone     : response.phone
        enabled   : !response.enabled
        isVip     : response.isVip
        isCorporate: response.isCorporate
        isRegular : response.isRegular
        vehicle   :
          brand : response.marca
          model : response.modelo
          plate : response.patente
        cuit      : response.cuit
        licence   :
          number     : response.licence_number
          expiration : new Date(dateFormated)

      checkEmail : (response) ->


      getInvoices : (response) ->
        adapted =
          list : []
          totalPages : response.total
          page : response.page
        if response.rows?.length > 0
          for row in response.rows
            adapted.list.push(
              id      : row.id
              amount  : row.cell[2]
              balance : row.cell[3]
              date    : new Date(row.cell[0])
              number  : row.cell[1]
              status  : row.cell[4]
              dueDate : new Date row.cell[5]
            )
        adapted


      showInvoice : (response, corporate) ->
        if response.status
          response = response.invoice
          termin = {}
          latef = {}

          if response.termId
            for term,key in corporate.terms.list
              if term.value is response.termId
                termin = term
          else
            termin = corporate.terms.list[0]

          if response.lateFeeId
            for late, key in corporate.lateFees.list
              if late.value is response.lateFeeId
                latef = late
          else
            latef = corporate.lateFees.list[0]
          result   =
            id          : response.id
            payments    : []
            totalPayments: 0
            status      : response.status
            number      : response.number
            amount      : response.total
            company     :
              name      : response.companyName
            date        : new Date(response.billingDate)
            term        : termin
            lateFee     : latef
            dueDate     : new Date(response.dueDate)
            operations  : []
            total       : response.total
            subtotal    : response.subTotal
            discount    : response.discount?=0
            discountPercentage    : response.discountPercentage?=0
            balanceDue  : response.total
            adjustments : response.adjustment
            comments    : response.comments?=""
          if response.company?
            result.company =
              image     : response.company.image
              address   : response.company.address
              city      : response.company.city
              country   : response.company.country

          if response.payments?
            for payment in response.payments
              result.payments.push(
                date        : new Date(payment.paymentDate)
                mode        : payment.paymentMode
                type        : payment.type
                bankCharges : payment.bankCharges
                amount      : payment.amount
                tax         : payment.taxDeducted
                sendEmail   : payment.sendEmail
                id          : payment.id_paymnet
                reference   : payment.reference
                comments    : payment.notes
              )
              result.totalPayments += parseInt payment.amount
              result.total = response.total + result.totalPayments

          if response.operations?
            total = 0
            for detail in response.operations
              discountType = ""
              amount       =  detail.amount
              if(detail.discountType == 1)
                discountType = "%"
                amount       = amount * ((100 - detail.discount) / 100)

              if(detail.discountType == 2)
                discountType = "$"
                amount       = amount - detail.discount

              if not detail.taxId?
                detail.taxId = 0

              if detail.taxId isnt 0
                amount += (detail.taxCharge * amount)/100

              total += amount
              result.operations.push(
                firstName    : detail.firstName?=""
                lastName     : detail.lastName?=""
                quantity     : detail.quantity
                amount       : detail.amount
                discount     : detail.discount
                discountType : discountType
                tax          :
                  value : detail.taxId
                  name  : detail.taxValue
                  charge: detail.taxCharge
                amount       : detail.amount
                opDate       : detail.opDate
                opId         : detail.opId
                userId       : detail.userId
              )
            # result.subtotal = total
        else

          result = false

        result

      getCostCenterAdmins : (response) ->
        responseArray = []
        for user in response
          responseArray.push(
            mail : user.email
            id   : user.id
          )
        responseArray

      getOperationsOn : (response, corporate) ->
        adapted =
          operations : []
          subtotal   : 0
        for row in response.result
          adapted.operations.push(
            userId     : row.userId
            amount     : row.amount
            quantity   : row.count
            firstName  : row.firstName
            lastName   : row.lastName
            opId       : row.operationId
            opDate     : row.date
            tax        : corporate.taxes.list[0]
          )
          adapted.subtotal += row.amount
        adapted


      listTerms : (response) ->
        responseArray = []
        responseArray.push(
          name: "None"
          value: 0
        )

        for row in response.rows
          responseArray.push(
            name  : row.name
            value : row.id
            days  : row.days
            )
        responseArray.push(
          name  : "+ Add New Term" #we must translate this TODO
          value : "+ Add New Term"
        )
        responseArray.push(
          name  : "Delete Term"
          value : "Delete Term"
        )
        responseArray

      listTaxes : (response) ->
        responseArray = []

        responseArray.push(
          name: "None"
          value: 0
        )
        for row in response.rows
          responseArray.push(
            name : "#{row.name} [#{row.charge}%]"
            value : row.id
            charge: row.charge
            isCompound : row.isCompound
          )
        responseArray.push(
          name  : "+ Add new Tax" #we must translate this TODO
          value : "+ Add new Tax"
        )
        responseArray.push(
          name  : "Delete Tax"
          value : "Delete Tax"
        )
        responseArray

      listLateFee: (response) ->
        responseArray = []
        responseArray.push(
          name: "None"
          value: 0
        )
        for row in response.rows
          lateType = ""
          newCharge = 0
          switch row.type
            when 1
              lateType = "% Per annum"
              newCharge = row.charge
            when 2
              lateType = "Flat"
              newCharge = "$#{row.charge}"

          frequencyType = ""
          switch row.frequency
            when 1
              frequencyType = "Every Day" #TODO TRANSLATE
            when 2
              frequencyType = "Every Week" #TODO TRANSLATE
            when 3
              frequencyType = "Every fortnight" #TODO TRANSLATE
            when 4
              frequencyType = "Every month" #TODO TRANSLATE

          responseArray.push(
            name  : "#{row.name} [#{newCharge} #{lateType}, #{frequencyType}]"
            value : row.id
            charge: row.charge
            type  : row.type
            frequency: row.frequency
          )
        responseArray.push(
          name : "+ Add Late Fee" #we must translate this TODO
          value : "+ Add Late Fee"
          )
        responseArray.push(
          name: "Delete Late Fee"
          value : "Delete Late Fee"
          )

        responseArray

      getCostCenterList : (response) ->
        adapted =
          list : {}
          length : 0
          page : response.page
          pages : response.total

        for value,key in response.rows
          adapted.length++
          adapted.list[value.id] =
            name : value.cell[0]
            id   : value.id
            statics : value.metrics
        adapted

      getUniqueCostCenter : (response) ->
        if response.records isnt 0
          name : response.rows[0].cell[0]
          id   : response.rows[0].id
          settings :response.settings
        else
          false

      addNewCorpAccount : (response) ->
        $cookieStore.put "newCompanyId", response.id
        $cookieStore.put "defaultCostCenter", response.id_cost

      getCompanyConfiguration : (response) ->
        $company.config =
          timeZone :
            value : null
            name  : "Select Timezone"
            tz    : null
          timeZoneStatic : response.timeZone
          driver :
            update_delay : response.intervalPoolingTrip
            mobilePayment : response.hasDriverPayment
            driverDispatcher : response.hasDriverDispatcherFunction
            payments :
              enabled : response.hasDriverPayment
              type    : response.driverPayment
              time    : response.driverTypePayment
              amount  : response.driverAmountPayment
              driverCorporateCharge :response.driverCorporateCharge
            options :
              callDriver : response.hadUserNumber
              addressFrom: response.newOpshowAddressFrom
              addressTo : response.newOpshowAddressTo
              corporate : response.newOpshowCorporate
              options : response.newOpshowOptions
              driversProfileEditable : response.driversProfileEditable
              user :
                name : response.newOpshowUserName
                phone : response.newOpshowUserPhone
              comments : response.newOpComment
          operations :
            useAdminCode : response.useAdminCode
            adminCode    : response.admin1Code
            autorecieve :
              distance         : response.distanceSearchTrip
              relaunch         : response.percentageSearchRatio*100
              drivers_quantity : response.driverSearchTrip
            scheduled :
              executiontime : response.timeDelayTrip
            endlessDispatch  : response.endlessDispatch
            operatorCancelationReason :response.operatorCancelationReason
          fares :
            base : response.costRutePerKmMin
            distanceType : if response.distanceType? then response.distanceType else 'KM'
            km   : if response.distanceType is 'MI' then Math.round((response.costRutePerKm * 1.609) *100) /100 else response.costRutePerKm
            currency : response.currency
            type : response.costRute
            isPrePaidActive: response.isPrePaidActive
            fareCalculator : response.isFareCalculatorActive
            isChatEnabled: response.isChatEnabled
            calculator :
              initialCost : response.fareInitialCost#double
              km          : response.fareCostPerKm#double
              timePerDistance   :  response.fareConfigActivateTimePerDistance#int
              initialTimeSecWait: response.fareConfigTimeInitialSecWait#int
              timeSecWait       : response.fareConfigTimeSecWait#int
              timeWaitPerSecond : response.fareCostTimeWaitPerXSeg#double
              totalTimePerSecWait : if response.fareConfigTimeSecWait+response.fareCostTimeWaitPerXSeg is 0 then 100 else response.fareConfigTimeSecWait+response.fareCostTimeWaitPerXSeg
          web :
            title         : response.pageTitle
            url           : response.pageUrl
            about         :
              title : response.pageCompanyTitle
              text  : response.pageCompanyDescription
            phone_booking : response.phone
            phone_admin   : response.phone1
            address       : response.pageCompanyStreet
            state         : response.pageCompanyState
            zip           : response.pageCompanyZipCode
            facebook      : response.pageCompanyFacebook
            twitter       : response.pageCompanyTwitter
            linkedin      : response.pageCompanyLinkedin
          parking :
            enabled : response.parking
            square : response.parkingPolygon
            distance :
              driver : response.parkingDistanceDriver
              passenger : response.parkingDistanceTrip
          zones :
            enabled : response.hasZoneActive
          destination :
            required : response.hasRequiredZone
          email :
            ios   : response.iosUrl
            android : response.androidUrl
            logoUrl : response.pageCompanyLogo
            webUrl  : response.pageCompanyWeb
          # -- Other data returned by this resource --
          # costRute: 0
          # hasMobilePayment: true
          # id: 16887
          # mobileCurrency: ""
          # status: 100
          # pageCompanyLogo
          # pageCompanyWeb
          # currency

      getParkings : (response) ->
        #for parking in $map.dashboard.pmap.parkings
          #$map.dashboard.pmap.parkings.pop()
        for key, value of $parkings.list
          delete $parkings.list[key]

        for parking in response.rows
          $parkings.list[parking.id] =
            id        : parking.id
            name      : parking.name
            latitude  : parking.lat
            longitude : parking.lng

      updateParking : ->
      deleteDriver : ->
      editDriver : ->
      changePassword :  ->
      editCompanyData :  ->



      getScheduledConfig : (response) ->
        adapted = []
        for row in response.rows
          adapted.push
            name : row.name
            time : row.timeDelayExecution
            id   : row.id

        adapted
      getCompanyData : (response) ->
        contactName : response.contact_name
        email       : response.contact_mail
        phone       : response.phone_company
        celphone    : response.celular_phone
        name        : response.company_name
        price       : response.price
        cuit        : response.cuit
        latitude    : response.lat
        longitude   : response.lng
        location    : "#{response.lat}, #{response.lng}"

      addNewDriver : ->

      getScheduledHistory : (response) ->
        rows = []
        for row in response.rows
          row    = row.cell

          # Converting 1200 to 12,00
          amount = "#{row[11]}"
          amount = parseFloat(amount)
          amount = 0 if isNaN(amount)
          rows.push(
            id                  : row[0]
            date                : new Date(row[1])
            firstName           : row[2]
            lastName            : row[3]
            driver              : row[4]
            phone               : row[5]
            origin              :
              address           : row[6]
              latitude          : row[14]
              longitude         : row[15]
            destination         : row[7]
            comments            : row[8]
            stars               : row[9]
            status              : row[10]
            amount              : amount
            isFrecuent          : row[12]
            device              : row[13]
            options             :
              messaging         : row[16]
              pet               : row[17]
              airConditioner    : row[18]
              smoker            : row[19]
              specialAssistance : row[20]
              luggage           : row[21]
              airport           : row[22]
              vip               : row[23]
              invoice           : row[24]
            operator            : row[25]
            operationId         : row[26]
          )
        result =
          rows  : rows
          page  : response.page
          pages : response.total

      getHistory : (response) ->
        rows = []
        for row in response.rows
          logOperation = row.log_operation
          # Converting 1200 to 12,00
          amount = "#{row[11]}"
          amount = parseFloat(amount)
          amount = 0 if isNaN(amount)
          rows.push(
            id                  : row.cell[0]
            date                : new Date(row.cell[1])
            firstName           : row.cell[2]
            lastName            : row.cell[3]
            driver              : row.cell[4]
            phone               : row.cell[5]
            origin              :
              address           : row.cell[6]
              latitude          : row.cell[14]
              longitude         : row.cell[15]
            destination         : row.cell[7]
            comments            : row.cell[8]
            stars               : row.cell[9]
            status              : row.cell[10]
            amount              : row.cell[11]
            isFrecuent          : row.cell[12]
            device              : row.cell[13]
            options             :
              messaging         : row.cell[16]
              pet               : row.cell[17]
              airConditioner    : row.cell[18]
              smoker            : row.cell[19]
              specialAssistance : row.cell[20]
              luggage           : row.cell[21]
              airport           : row.cell[22]
              vip               : row.cell[23]
              invoice           : row.cell[24]
            operator            : row.cell[26]
            reason              : logOperation[0]?.reason
            log_operation:
                for action in logOperation
                  code         : action.code
                  createdDate  : action.createdDate
                  status       :
                    enumType   : action.status.enumType
                    name       : action.status.name
                    stateImg :  "IC_#{action.status.name}"
                  user         :
                    email      : action.user.email
                    first_name : action.user.first_name
                    last_name  : action.user.last_name
                    user_id    : action.user.user_id
                  reason       : action.reason
            )

        result =
          rows  : rows
          page  : response.page
          pages : response.total


      getOperationFlow : (response) ->
        result =
          if !response.reason? and (response.events? and response.events.length > 0)
            lastStep = response.events[response.events.length - 1]
            startDate : response.events[0].created_at
            endDate   : lastStep.created_at
            flow      : []
            operation : response.operation
          else
            flow      : []

        if response.events?
          for event in response.events
            if event.step.text isnt "C_"
              result.flow.push(
                created_at  : new Date(event.created_at)
                text        : event.step?.text
                img         : "IC_#{event.tooltip?.img.substring(2)}"
                tooltip     : event.tooltip?.text
                tooltip_img : event.step?.img
              )

        result


      getDrivers: (gridAttributes) ->
        result =
          drivers : []
          pages: gridAttributes.total
          page : gridAttributes.page
        for key, value of gridAttributes.rows
          result.drivers.push
            number   : value.cell[0].replace(/@.+/, "")
            image    : "#{$apiAdapter.url.driverImage}#{value.cell[0]}&cache=#{(new Date()).getTime()}"
            email    : value.cell[0]
            password : ""
            firstName: value.cell[2]
            lastName : value.cell[3]
            telephone: value.cell[4]
            enabled  : value.cell[6]
            car      :
              brand: value.cell[7]
              model: value.cell[8]
              plate: value.cell[9]
            license:
              number    : value.cell[11]
              expiration: value.cell[12]
            cuit : value.cell[10]
            isCorporate:value.cell[11]
            isVip:  value.cell[12]
            isRegular:value.cell[13]
            id : value.id
        result

      getReports: (response) ->
         response.rows


      getDailyReports: (response) ->
        list: response.rows

      getMonthlyReports: (response) ->
        list: response.rows

      getDriversReports: (response) ->
        list: response.rows



      getDriverReports: (response) ->
        response.rows

      getDriverMonthlyReport: (response) ->
        response.rows


      newParking : ->

      getZones : (response) ->
        for key, value of $zones.list
          delete $zones.list[key]

        count = 0
        for zone, index in response.result
          # Coordinates
          count++
          coords = zone.coordinates.split("|")
          coordinates = []

          for cord in coords
            latlng = cord.split(",")
            cod = L.latLng parseFloat(latlng[0]), parseFloat(latlng[1])
            coordinates.push(cod)

          # Polygon
          unless coordinates.length is 0
            # Zone
            $zones.list[zone.id] =
              polygon : L.polygon(coordinates, {draggable: true, noClip: true, smoothFactor: 2.0, zoneId: zone.id, name : zone.name})
              id      : zone.id
              name    : zone.name
              path    : coordinates

        $company.zones.pages = count/3
      getSingleCorpAccount : (response) ->
        if response.records isnt 0
          numberDate = new Date()
          id        : response.rows[0].id
          name      : response.rows[0].cell.name
          cuit      : response.rows[0].cell.cuit
          phone     : response.rows[0].cell.phone
          discount  : response.rows[0].cell.discount
          address   : response.rows[0].cell.legalAddress
          image     : "#{$apiAdapter.url.corpImg}?token=#{$user.token}&id=#{response.rows[0].id}&cache=#{numberDate.getTime()}"
          settings  : response.rows[0].cell.settings
        else
          false

      getCorpAccounts: (response) ->
        numberDate = new Date()
        result =
          list       : {}
          pages      : response.total
          page       : response.page

        for key, value of response.rows
          result.list[value.id] =
            id        : value.id
            name      : value.cell.name
            cuit      : value.cell.cuit
            phone     : value.cell.phone
            address   : value.cell.legalAddress
            image     : "#{$apiAdapter.url.corpImg}?token=#{$user.token}&id=#{value.id}&cache=#{numberDate.getTime()}"
            settings  : value.metrics
        result

      getCorpStats: (response) ->
        stats =
          accounts : response.accounts
          anual    : response.anual
          monthly  : response.monthly
          payments : response.payments

      recordInvoicePayment : (response) ->



    output:
      editParkingName : (data) ->
        if data.isPolygon
          polygonOut = []
          polygonIn  = []
          for coord in data.coordsOut
            polygonOut.push
              lat : coord[1]
              lng : coord[0]
          for coord in data.coordsIn
            polygonIn.push
              lat : coord[1]
              lng : coord[0]

        coordinatesIn  : if data.isPolygon then new Array polygonIn else undefined
        coordinatesOut : if data.isPolygon then new Array polygonOut else undefined
        isPolygon      : data.isPolygon
        lat            : data.lat
        lng            : data.lng
        token          : $user.token
        oper           : "edit"
        id             : data.id
        name           : data.name

      editZonePricing : (data) ->
        oper   : data.oper
        amount : data.zone.amount
        id     : data.zone.id
        token  : $user.token

      getZonePricing: (data) ->
        token   : $user.token
        id      : ""
        rows    : 13
        page    : data.page
        sidx    : data.sidx?= 'amount'
        sord    : data.sord?= "desc"
        searchString: data.search?= ''
        searchOper : "eq"
        searchField: data.f#zoneFrom ? zoneTo


      deleteSquareParking : (id) ->
        id : id
        token: $user.token
        oper : "del"
        isPolygon : true

      newSquareParking : (data) ->
        polygon = []
        for coord in data.coords
          polygon.push
            lat : coord[1]
            lng : coord[0]
        oper  : "add"
        coordinatesIn  : new Array polygon
        coordinatesOut : new Array polygon
        isPolygon      : true
        latitude       : 0
        longitude      : 0
        name           : data.name
        token          : $user.token

      updateSquareParking : (parking) ->
        coordsOut = parking.polygonOut.toGeoJSON().geometry.coordinates[0]
        coordsIn  = parking.polygonIn.toGeoJSON().geometry.coordinates[0]
        polygonOut = []
        polygonIn = []
        for coord in coordsOut
          polygonOut.push
            lat : coord[1]
            lng : coord[0]
        for coord in coordsIn
          polygonIn.push
            lat : coord[1]
            lng : coord[0]

        coordinatesIn  : new Array polygonIn
        coordinatesOut : new Array polygonOut
        isPolygon      : true
        latitude       : 0
        longitude      : 0
        token          : $user.token
        oper           : "edit"
        id             : parking.id

      getSquareParkings : (data) ->
        token: $user.token
        isPolygon : true

      getPassengers  : (data) ->
        token        : $user.token
        page         : data.page?=1
        searchString : data.search?=""
        searchField  : data.filter?=""

      editPassenger : (data) ->
        username : data.passenger.email
        password : data.passenger.password
        firstName: data.passenger.name
        lastName : data.passenger.lastName
        phone    : data.passenger.phone
        agree    : if data.passenger.active then "on" else "off"
        oper     : data.oper
        id       : data.passenger.id?="_empty"
        type     : "USER"
        token    : $user.token

      ballanceDriverAccount: (id) ->
        token : $user.token
        driver_id : id

      chargeInvoiceTotal : (id) ->
        token     : $user.token
        driver_id : id

      payReceiptsTotal : (id) ->
        token : $user.token
        driver_id : id

      chargeDriverPartialy : (data) ->
        token : $user.token
        driver_id  : data.id
        invoices : new Array data.invoices.join ','

      payDriverPartialy : (data) ->
        token     : $user.token
        driver_id : data.id
        operations: new Array data.ops.join ','

      getDriverBilling  : (id) ->
        driver_id : id
        token : $user.token

      getDriverLogs : (driver) ->
        "/#{driver.id}/#{driver.page}?token=#{$user.token}"

      deleteScheduledPreset : (id) ->
        token: $user.token
        delay_config_id: id
        oper: "del"

      addScheduledPreset : (preset) ->
        name  : preset.name
        timeDelayExecution : preset.time
        token : $user.token
        oper : "add"


      getDriverInvoice : (data) ->
        token      : $user.token
        billing_id : data.invoice

      sendMessageToOperators : (message) ->
        user : "admin"
        password : "QOu6QjruPi0Zo4VM"
        message : message
        token : $user.token

      getDriverReceipts : (id) ->
        driver_id  : id
        token      : $user.token


      getDriverInvoices : (id) ->
        driver_id    : id
        token        : $user.token


      getDriverHistoryReceipts : (id) ->
        driver_id  : id
        token      : $user.token


      getDriverHistoryInvoices : (id) ->
        driver_id    : id
        token        : $user.token

      getCorpOperations : (data) ->
        token : $user.token
        cost_id : data.id
        rows: 20
        page: data.page
        sord: "desc"

      getCorpEmployee : (data) ->
        searchField : "id"
        searchString : data.id
        token : $user.token
        id_cost : data.cost

      employeesType : ->
        token : $user.token

      editCorpEmployee: (data) ->
        id_cost            : data.cost
        token              : $user.token
        username           : data.employ.user
        password           : data.employ.password
        firstName          : data.employ.name
        lastName           : data.employ.lastname
        phone              : data.employ.phone
        agree              : "on"
        admin              : if data.employ.admin then "on" else "off"
        oper               : "edit"
        id                 : data.employ.id
        corporateSuperUser : if data.employ.superAdmin then "on" else "off"

      addCorpEmployee: (data) ->
        id_cost            : data.cost
        token              : $user.token
        username           : data.employ.user.toLowerCase()
        password           : data.employ.password
        firstName          : data.employ.name
        lastName           : data.employ.lastname
        phone              : data.employ.phone
        agree              : "on"
        admin              : if data.employ.admin then "on" else "off"
        oper               : "add"
        id                 : "_empty"
        corporateSuperUser : if data.employ.superAdmin then "on" else "off"

      listCorpEmployees : (data) ->
        id_cost : data.id
        page    : data.page
        token   : $user.token

      listEmployees: (data)  ->
        typeEmploy   : "OPERADOR"
        token        : $user.token
        rows         : 11
        page         : data.page
        sidx         : "firstName"
        sord         : "desc"
        searchString : data.search?=""
        searchField  : "username"
        searchOper   : "like"

      deleteEmployee : (id) ->
        type  : "EMPLOYUSEROPERATOR"
        token : $user.token
        oper  : "del"
        id    : id

      editEmployee : (employ) ->
        type        : "EMPLOYUSEROPERATOR"
        token       : $user.token
        username    : employ.username
        password    : employ.password
        firstName   : employ.firstName
        lastName    : employ.lastName
        phone       : employ.phone
        typeEmploy  : employ.typeEmploy.value
        agree       : employ.agree?=false
        oper        : "edit"
        id          : employ.id

      addEmployee : (employ) ->
        type      : "EMPLOYUSEROPERATOR"
        token     : $user.token
        username  : employ.user.replace(/@.+/g, "").toLowerCase()
        #  + "@" + $user.host
        password  : employ.password
        firstName : employ.firstName
        lastName  : employ.lastName
        phone     : employ.phone
        typeEmploy: employ.role.value
        agree     : if employ.active then "on" else "off"
        oper      :"add"

      disconectDriverFromSocket: (id) ->
        "#{id}/3000/3000&token=#{$user.token}"

      activateDriver   : (id) ->
        token    : $user.token
        driver_id: id

      activateEmployee: (id) ->
        user_id : id
        token   : $user.token

      getDriverHistory : (info) ->
        token        : $user.token
        page         : info.page
        rows         : 12
        searchField  : "driver"
        searchString : info.id
        searchOper   : "eq"

      deleteCostCenter : (data) ->
        cost_id : data.cost
        id : data.company
        oper : "del"
        token : $user.token

      newCostCenter : (user) ->
        id            : user.companyId
        oper          : "add"
        name          : user.name
        phone         : user.phone
        legalAddress  : user.address
        token         : $user.token

      deleteTax : (id) ->
        tax_id : id
        oper: "del"
        token: $user.token

      deleteTerm     : (id) ->
        term_id: id
        oper: "del"
        token : $user.token

      deleteLateFee  : (id) ->
        late_fee_id : id
        oper        : "del"
        token       : $user.token

      getStarEmail   : (tab) ->
        token : $user.token
        status : tab

      getDeletedEmail  : (tab) ->
        token : $user.token
        status : tab

      markAsReadedEmail : (id) ->
        inbox_id : id
        token    : $user.token

      deleteEmail : (id) ->
        token    : $user.token
        inbox_id : id

      starEmail : (id) ->
        inbox_id  : id
        token     : $user.token

      getDriverEmail : ->
        token : $user.token
        status : "DRIVER"

      getPassengerEmail : ->
        token : $user.token
        status : "PASSENGER"

      getEnterpriseEmail : ->
        token : $user.token
        status : "ENTERPRISE"

      listInboxMessages : (tab) ->
        token : $user.token
        status : tab
      getSingleDriver : (id) ->
        token     : $user.token
        driver_id : id

      reloadZones : ->
        "#{$user.id}?token=#{$user.token}"

      deleteInvoicePayment : (data) ->
        token       : $user.token
        billing_id  : data.invoiceid
        payment_id  : data.id
        oper        : "del"

      recordInvoicePayment : (payment) ->
        billing_id  : payment.invoiceid
        bankCharges : payment.bankCharges?=0
        amount      : payment.amount
        taxDeducted : payment.taxDeducted?=false
        paymentDate : $filter('date')(new Date(payment.date),'yyyy-MM-dd')
        paymentMode : payment.mode
        reference   : payment.reference
        notes       : payment.notes
        oper        : "add"
        sendEmail   : payment.thankYouNote?=false
        token       : $user.token

      editCorporateCompany : (company) ->
        id           : company.id
        token        : $user.token
        oper         : "edit"
        phone        : company.phone
        cuit         : company.cuit
        name         : company.name
        legalAddress : company.address
        discount: company.discount

      checkEmail : (email) ->
        email : email
        rtaxi : $user.email



      editInvoice: (invoice) ->
        invoice.invoiceId    = invoice.id
        invoice.billingDate  = $filter('date')(new Date(invoice.date),'yyyy-MM-dd')
        invoice.discount     = if invoice.discountPercentage? then (invoice.discountPercentage * invoice.subTotal)/100 else invoice.discount = 0
        invoice.discountPercentage ?= 0
        invoice.subTotal     = invoice.subTotal
        invoice.adjustments   = invoice.adjustments?= 0
        invoice.total        = (invoice.subTotal + invoice.adjustments) - invoice.discount
        convEmails           = []
        invoice.ops          = []
        for op in invoice.operations
          invoice.ops.push(
            amount       : op.amount
            discount     : op.discount
            discountType : op.discountType
            firstName    : op.firstName
            lastName     : op.lastName
            opId         : op.opId
            opDate       : $filter('date')( new Date(op.opDate),'yyyy-MM-dd')
            quantity     : op.quantity
            taxId        : op.tax.value
            userId       : op.userId
          )
        invoice.operations = invoice.ops

        for key, value of invoice.emailIds
          convEmails.push(value)

        invoice.emailIds = convEmails
        invoice.lateFeeId  = invoice.lateFee.value
        invoice.termId     = invoice.term.value
        # delete invoice.term
        # delete invoice.lateFee
        # delete invoice.adjustments
        # delete invoice.details
        # delete invoice.company
        # delete invoice.propertis
        # delete invoice.log
        # delete invoice.date
        # delete invoice.id

        token   : $user.token
        invoice : invoice

      createNewInvoice : (data) ->
        invoice   = data.invoice
        corporate = data.corporate
        invoice.costCenterId  = corporate.companies.costCenters.costCenter.id
        invoice.subTotal      = invoice.subTotal
        invoice.discount     = if invoice.discountPercentage? then (invoice.discountPercentage * invoice.subTotal)/100 else invoice.discount = 0
        invoice.discountPercentage ?= 0
        invoice.billingDate   = $filter('date')(new Date(invoice.billingDate),'yyyy-MM-dd')
        invoice.adjustments   ?= 0
        invoice.total         = (invoice.subTotal + invoice.adjustments) - invoice.discount
        convOperations        = []
        convEmails            = []

        # Adapting the angular format to arrays
        for key,value of invoice.operations
          convOperations.push(
            amount       : value.amount
            discount     : value.discount
            discountType : Number value.discountType
            firstName    : value.firstName?=""
            lastName     : value.lastName?=""
            opDate       : $filter('date')( new Date(value.opDate),'yyyy-MM-dd')
            opId         : value.opId
            quantity     : value.quantity
            taxId        : value.tax.value?=0
            taxValue     : value.tax.charge
            userId       : value.userId
          )
        for key, value of invoice.emailIds
          convEmails.push(value)

        invoice.emailIds   = convEmails
        invoice.operations = convOperations
        invoice.lateFeeId = invoice.lateFee.value
        invoice.termId = invoice.term.value

        # delete invoice.lateFee
        # delete invoice.term
        invoice : invoice
        token   : $user.token


      getInvoices : (data) ->
        cost_id   : data.id
        token     : $user.token
        page      : data.page
        sord      : data.sort
        sidx      : data.order
        search    : ""
        filter    : data.filter?=""

      deleteInvoice: (id) ->
        token : $user.token
        invoice_id : id
      showInvoice  : (id) ->
        token      : $user.token
        billing_id : id

      getCostCenterAdmins : (id) ->
        cost_id : id
        token : $user.token

      getOperationsOn : (date) ->
        token    : $user.token
        cost_id : date.costCenter
        dateFrom : $filter('date')( new Date(date.fromDate), 'yyyy-MM-dd')
        dateTo  : $filter('date')( new Date(date.toDate), 'yyyy-MM-dd')

      addTerm : (term) ->
        token: $user.token
        name : term.name
        days : term.days
        oper : "add"

      listTerms : ->
        token : $user.token

      listTaxes : ->
        token : $user.token

      addTax : (tax) ->
        oper     : "add"
        token    : $user.token
        name     : tax.name
        charge   : tax.rate
        compound : tax.compound

      listLateFee: ->
        token: $user.token

      addlateFee : (fee) ->
        oper       : "add"
        token      : $user.token
        name       : fee.name
        charge     : fee.charge
        typeCharge : fee.percentage
        frequency  : fee.frequency

      exportDaily  :(period)  ->
        token    : $user.token
        fromDate : $filter('date')( new Date(period.fromDate), 'dd/MM/yyyy' )
        toDate   : $filter('date')( new Date(period.toDate), 'dd/MM/yyyy' )

      exportMonthly :(period) ->
        token    : $user.token
        fromDate : $filter('date')( new Date(period.fromDate), 'dd/MM/yyyy' )
        toDate   : $filter('date')( new Date(period.toDate), 'dd/MM/yyyy' )

      exportDriver : (period)->
        token    : $user.token
        fromDate : $filter('date')( new Date(period.fromDate), 'dd/MM/yyyy' )
        toDate   : $filter('date')( new Date(period.toDate), 'dd/MM/yyyy' )


      DriverOpExport : (data)->
        token    : $user.token
        searchDateFrom : $filter('date')( new Date(data.fromDate), 'dd/MM/yyyy' )
        searchDateTo   : $filter('date')( new Date(data.toDate), 'dd/MM/yyyy' )
        searchString : data.driverId
        rows: 999
        searchField: "driver_id"



      exportOpHistory : (date) ->
        token    : $user.token
        dateFrom : $filter('date')( new Date(date.fromDate), 'yyyy-MM-dd' )
        dateTo   : $filter('date')( new Date(date.toDate), 'yyyy-MM-dd' )
        email    : date.email

      exportCorpEmployees : (data) ->
        token    : $user.token
        dateFrom : $filter('date')( new Date(data.ex.fromDate), 'yyyy-MM-dd' )
        dateTo   : $filter('date')( new Date(data.ex.toDate), 'yyyy-MM-dd' )
        email    : data.ex.email
        cost_id  : data.costCenter


      getCostCenterList : (data) ->
        corporate_id : data.id
        page         : data.page?=1
        token        : $user.token
        searchField  : "name"
        searchString : data.searchString
        searchOper   :  "like"

      newCorpUserCostCenter: (user) ->
        token            : $user.token
        phone            : user.phone
        username         : user.email
        password         : user.password
        firstName        : user.name
        lastName         : user.lastName
        agree            : "true"
        admin            : "true"
        id_cost          : user.costCenter
        cost_center_name : user.costCenterName
        oper             : "add"

      getCorporateUserList : (id) ->
        id_cost : id
        token   : $user.token

      getUniqueCostCenter : (data) ->
        searchString : data.name
        corporate_id : data.id
        token        : $user.token
        searchField  : "id"
        searchOper   : "eq"
        cost_center_id: data.name

      createNewCorpUser : (user) ->
        token     : $user.token
        phone     : user.phone
        username  : user.email
        password  : user.password
        corporateSuperUser : "on"
        firstName : user.name
        lastName  : user.lastName
        agree     : "on"
        admin     : "on"
        id_cost   : user.costCenter
        oper      : "add"
        id        : "_empty"



      editCorpAccount : (company) ->
        token        : $user.token
        name         : company.name
        phone        : company.phone
        cuit         : company.cuit
        legalAddress : company.legalAddress
        id           : company.id
        oper         : "edit"

      addNewCorpAccount: (company) ->
        token       : $user.token
        name        : company.name
        phone       : company.phone
        cuit        : company.cuit
        legalAddress: company.legalAddress
        oper        : "add"
        discount: company.discount

      getCorpStats: ->
        token : $user.token

      deleteCompany : (id) ->
        token : $user.token
        id    : id
        oper  : "del"

      getSingleCorpAccount : (name) ->
        token        : $user.token
        page         : 1
        rows         : 10000
        searchField  : "id"
        searchString : name?=" "
        searchOper   : "eq"
        corporate_id : name?=""

      getCorpAccounts: (data) ->
        token        : $user.token
        page         : data.page
        rows         : 10
        searchField  : "name"
        searchString : data.search?=""
        searchOper   : "like"
        corporate_id : data.search?=""


      addNewDriver : (driver) ->
        # format date
        if driver.expiration?
          expdate = $filter('date')( new Date(driver.expiration), 'dd/MM/yyyy' )
        else
          expdate = ""
        token          : $user.token
        username       : driver.id
        password       : driver.password
        firstName      : driver.name
        lastName       : driver.lastname
        phone          : driver.phone
        patente        : driver.plate
        marca          : driver.brand
        modelo         : driver.model
        cuit           : driver.cuit
        licenceNumber  : driver.licence
        licenceEndDate : expdate
        isVip          :  driver.isVip
        isCorporate    :  driver.isCorporate
        isRegular      :  driver.isRegular
        oper           : "add"

      changePassword : (pass) ->
        token    : $user.token
        password : pass

      editDriver : (driver) ->

        if driver.licence.expiration?
          expdate = $filter('date')( new Date(driver.licence.expiration), 'dd/MM/yyyy' )
        else
          expdate = ""

        token          : $user.token
        id             : driver.id
        username       : driver.email
        isVip          : driver.isVip
        isCorporate    : driver.isCorporate
        isRegular      : driver.isRegular
        password       : driver.password
        firstName      : driver.firstName
        lastName       : driver.lastName
        phone          : driver.phone
        patente        : driver.vehicle.plate
        marca          : driver.vehicle.model
        modelo         : driver.vehicle.brand
        cuit           : driver.cuit
        licenceNumber  : driver.licence.number
        licenceEndDate : expdate
        #username       : driver.number

      editCompanyData : (company) ->
        token         : $user.token
        contact_name  : company.contactName
        celular_phone : company.celphone
        company_name  : company.name
        cuit          : company.cuit
        phone_company : company.phone
        lat           : $company.latitude
        lng           : $company.longitude

      sendEmail: (emailAttributes) ->
        emailAttributes

      getHistory : (gridAttributes) ->
        token          : $user.token
        page           : gridAttributes.page
        rows           : 12
        searchField    : gridAttributes.search.searchBy
        searchString   : gridAttributes.search.search
        searchOper     : "eq"
        searchDateFrom : if gridAttributes.date.start? then $filter('date')(new Date(gridAttributes.date.start),'dd/MM/yyyy')
        searchDateTo   : if gridAttributes.date.end? then $filter('date')(new Date(gridAttributes.date.end),'dd/MM/yyyy')


      getScheduledHistory : (attrs) ->
        token        : $user.token
        page         : attrs.page
        rows         : 12
        searchField  : attrs.search.searchBy
        searchString : attrs.search.search
        searchOper   : "eq"
        searchDateFrom : if attrs.date?.start? then $filter('date')(new Date(attrs.date.start),'dd/MM/yyyy')
        searchDateTo   : if attrs.date?.end? then $filter('date')(new Date(attrs.date.end),'dd/MM/yyyy')

      corpEmployeeHistory : (data) ->
        token  : $user.token
        page   : data.page-1
        searchField: "user_id"
        searchString : data.id
        searchOper   : "eq"

      getOperationFlow : (flowAttributes) ->
        "#{flowAttributes.id}?token=#{$user.token}"

      getDrivers: (gridAttributes) ->
        gridAttributes.searchString = "" unless gridAttributes.searchString?

        token: $user.token
        page : gridAttributes.page
        rows : 12
        searchField  : gridAttributes.searchField
        searchString : gridAttributes.searchString
        searchOper   : "eq"

      getCompanyData : ->
        token : $user.token

      deleteDriver : (id) ->
        token : $user.token
        id : id

      getReports: (gridAttributes) ->
        token: $user.token

      getDailyReports: (data) ->
        token: $user.token

      getMonthlyReports: (data) ->
        token: $user.token

      getDriversReports: (data) ->
        token: $user.token

      getDriverReports: (driverId) ->
        token    : $user.token
        driver_id: driverId

      getDriverMonthlyReport: (driverId) ->
        token    : $user.token
        driver_id: driverId
        month    : 1

      getCompanyConfiguration : ->
        token : $user.token

      configTimezone : (time) ->
        id                  : $user.id
        token               : $user.token
        timeZone            : time.value

      driverUpdateTime : (driver) ->
        id                  : $user.id
        token               : $user.token
        intervalPoolingTrip : driver.update_delay
        hasDriverPayment    : driver.mobilePayment
        newOpshowAddressFrom: driver.options.addressFrom
        newOpshowAddressTo  : driver.options.addressTo
        newOpshowCorporate  : driver.options.corporate
        newOpshowOptions    : driver.options.options
        newOpshowUserName   : driver.options.user.name
        newOpshowUserPhone  : driver.options.user.phone
        hadUserNumber       : driver.options.callDriver
        newOpComment        : driver.options.comments
        hasDriverDispatcherFunction : driver.driverDispatcher
        driversProfileEditable      : driver.options.driversProfileEditable
      getScheduledConfig : ->
        token : $user.token

      editScheduledConfig : (scheduled) ->
        timeDelayTrip : parseFloat scheduled.executiontime
        id            : $user.id
        token         : $user.token

      operationsConfig : (operations) ->
        id                    : $user.id
        token                 : $user.token
        percentageSearchRatio : operations.autorecieve.relaunch / 100
        distanceSearchTrip    : parseFloat operations.autorecieve.distance
        driverSearchTrip      : parseFloat operations.autorecieve.drivers_quantity
        endlessDispatch       : operations.endlessDispatch
        useAdminCode          : operations.useAdminCode
        #hadUserNumber         : operations.callPassenger
        admin1Code             : operations.adminCode
        operatorCancelationReason:operations.operatorCancelationReason

      driverPaymentsConfig : (payments) ->
        id                  : $user.id
        token               : $user.token
        hasMobilePayment    : true
        hasDriverPayment    : payments.enabled
        driverPayment       : payments.type
        driverTypePayment   : payments.time
        driverAmountPayment : payments.amount
        driverCorporateCharge: payments.driverCorporateCharge

      companyFaresConfig : (settings) ->
        id                                : $user.id
        token                             : $user.token
        costRutePerKm                     : if settings.fares.distanceType is "MI" then Math.round((settings.fares.km / 1.609) * 100) / 100  else settings.fares.km
        costRutePerKmMin                  : settings.fares.base
        hasZoneActive                     : settings.zones.enabled
        hasRequiredZone                   : settings.destination
        currency                          : settings.fares.currency
        costRute                          : Number settings.fares.type
        distanceType                      : settings.fares.distanceType

        fareInitialCost                   : settings.fares.calculator.initialCost
        fareCostPerKm                     : settings.fares.calculator.km
        fareConfigActivateTimePerDistance : settings.fares.calculator.timePerDistance
        fareConfigTimeInitialSecWait      : settings.fares.calculator.initialTimeSecWait
        fareConfigTimeSecWait             : settings.fares.calculator.timeSecWait
        fareCostTimeWaitPerXSeg           : settings.fares.calculator.timeWaitPerSecond
        isFareCalculatorActive            : settings.fares.fareCalculator

      emailConfig : (email) ->
        pageCompanyLogo : email.logoUrl
        id              : $user.id
        pageCompanyWeb  : email.webUrl
        token           : $user.token
        androidUrl      : email.android
        iosUrl          : email.ios

      companyWebConfig : (web) ->
        id                      : $user.id
        token                   : $user.token
        pageTitle               : web.title
        pageUrl                 : web.url
        pageCompanyTitle        : web.about.title
        pageCompanyDescription  : web.about.text
        pageCompanyStreet       : web.address
        pageCompanyZipCode      : web.zip
        pageCompanyState        : web.state
        pageCompanyLinkedin     : web.linkedin
        pageCompanyFacebook     : web.facebook
        pageCompanyTwitter      : web.twitter
        phone                   : web.phone_booking
        phone1                  : web.phone_admin

      editParkingSettings : (parking) ->
        id                     : $user.id
        token                  : $user.token
        parking                : parking.enabled
        parkingDistanceDriver  : parking.distance.driver
        parkingDistanceTrip    : parking.distance.passenger
        parkingPolygon         : parking.square

      getParkings : ->
        token : $user.token
        isPolygon: false

      updateParking : (marker) ->
        token: $user.token
        oper : "update"
        id   : marker.id
        lat  : marker.lat
        lng  : marker.lng
        name : marker.name
        isPolygon: false

      deleteParking : (parkingId) ->
        token: $user.token
        oper : "del"
        id   : parkingId
        isPolygon: false

      newParking : (parking) ->
        token : $user.token
        oper  : "add"
        lat   : parking.coords.lat
        lng   : parking.coords.lng
        name  : parking.name
        isPolygon: false

      getZones : ->
        token : $user.token

      validatePolygon : (polygon) ->
        path = polygon.toGeoJSON()

        coordinates = ""
        for coordinate, index in path.geometry.coordinates[0]
          coordinates += "|" unless index is 0
          coordinates += "#{coordinate[0]},#{coordinate[1]}"

        polygon : coordinates
        token : $user.token
      updateZone: (polygon) ->
        coordinates = ""
        path = polygon.toGeoJSON()
        for coordinate, index in path.geometry.coordinates[0]
          coordinates += "|" unless index is 0
          lat = "#{coordinate[0]}"
          lat.replace(",",".")
          lng = "#{coordinate[1]}"
          lng.replace(",",".")
          coordinates += "#{lng},#{lat}"

        token       : $user.token
        oper        : "update"
        id          : polygon.options.zoneId
        name        : polygon.options.name
        coordinates : coordinates

      deleteZone: (id) ->
        token : $user.token
        oper  : "del"
        id    : id
      editZoneName: (zone) ->
        coordinates = ""
        path = zone.polygon.toGeoJSON()
        for coordinate, index in path.geometry.coordinates[0]
          coordinates += "|" unless index is 0
          lat = "#{coordinate[0]}"
          lat.replace(",",".")
          lng = "#{coordinate[1]}"
          lng.replace(",",".")
          coordinates += "#{lng},#{lat}"
        token : $user.token
        oper  : "update"
        name  : zone.name
        coordinates: coordinates
        id         : zone.id
      newZone : (data) ->
        coordinates = ""
        path = data.polygon.toGeoJSON()
        for coordinate, index in path.geometry.coordinates[0]
          coordinates += "|" unless index is 0
          lat = "#{coordinate[0]}"
          lat.replace(",",".")
          lng = "#{coordinate[1]}"
          lng.replace(",",".")
          coordinates += "#{lng},#{lat}"

        token : $user.token
        oper  : "add"
        name  : data.zoneName
        coordinates: coordinates

      validateToken: () ->
        token: $user.token
