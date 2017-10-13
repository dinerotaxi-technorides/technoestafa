technoridesApp.factory 'corporate.api', ($api, $location, $settings, $user, $translate, $company) ->
  $url     = $settings[$settings.environment].api
  $adapter =

    getCostCenter : (params) ->
      $api.get
        data :
          corporate_id  : $user.company
          cost_center_id: params.id
          searchField   : "id"
          searchOper    : "eq"
          searchString  : params.id
          token         : $user.token
        url : "#{$url}technoRidesCorporateUserApi/cost_center_list"
        code : 100
        codeName : "status"
        done : (response) ->
          response = response.rows[0]
          adapted =
            id      : response.id
            name    : response.cell[0]
            phone   : response.cell[1]
            address : response.cell[2]
            metrics : response.metrics
          params.done adapted
        fail : (response) ->
          if response.status is 411
            $user.logout()

    addCostCenter : (params) ->
      $api.get
        url            : "#{$url}technoRidesCorporateUserApi/cost_center_edit/"
        data           :
          id           : $user.company
          legalAddress : params.costCenter.address
          name         : params.costCenter.name
          oper         : "add"
          phone        : params.costCenter.phone
          token        : $user.token
        code           : 100
        codeName       : "status"
        done : ->
          params.done()
        fail : ->
          params.fail response


    editCostCenter : (params) ->
      $api.get
        url            : "#{$url}technoRidesCorporateUserApi/cost_center_edit/"
        data           :
          id           : $user.company
          cost_id      : params.costCenter.id
          token        : $user.token
          legalAddress : params.costCenter.address
          name         : params.costCenter.name
          phone        : params.costCenter.phone
          oper         : "edit"
        code           : 100
        codeName       : "status"
        done : ->
          params.done()
        fail : ->
          params.fail response

    getCostCenters : (params) ->
      $api.get
        url : "#{$url}technoRidesCorporateUserApi/cost_center_list"
        data :
          page         : params.page
          corporate_id : $user.company
          token        : $user.token
        code : 100
        codeName : "status"
        done : (response) ->
          adapted =
            list : []
            page : response.page
            pages : _.range response.total
          for row in response.rows
            adapted.list.push
              id   : row.id
              name : row.cell[0]
              phone   :  row.cell[1]
              legalAddress : row.cell[2]
              metrics : row.metrics
          params.done adapted

        fail : (response) ->
          if response.status is 411
            $user.logout()

    getInvoices : (params) ->
      $api.get
        url     : "#{$url}technoRidesInvoiceApi/invoice_list"
        code     : 100
        codeName : "status"
        data:
          cost_id   : $user.costCenter
          page      : params.page
          sord      : params.sort
          token     : $user.token
          sidx      : params.order
          search    : params.search
          filter    : params.filter
        done : (response) ->
          adapted =
            list : []
            pages : response.total
            page : response.page
          for row in  response.rows
            adapted.list.push
              id      : row.id
              amount  : row.cell[2]
              balance : row.cell[3]
              date    : new Date(row.cell[0])
              number  : row.cell[1]
              status  : row.cell[4]
              dueDate : new Date row.cell[5]
          params.done(adapted)
        fail : ->

    getOperations : (params) ->
      $api.get
        url : "#{$url}technoRidesCorporateOperationsApi/jq_company_operation_history"
        code: 100
        codeName : "status"
        data :
          sidx    : params.order
          filter  : params.filter
          search  : params.search
          cost_id: $user.costCenter
          page   : params.page
          rows   : 20
          sord   : params.sort
          token  : $user.token
        done : (response) ->
          adapted =
            list : []
            page : response.page
            pages: response.total
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
          params.done adapted

        fail : (response) ->

    viewInvoice : (params) ->
      $api.get
        url : "#{$url}technoRidesInvoiceApi/get_invoice"
        code : 100
        codeName: "status"
        data:
          billing_id : params.id
          token : $user.token
        done : (response) ->
          payments = []
          totalPaid = 0
          for pay in response.invoice.payments
            payments.push
              amount      : pay.amount
              BankCharges : pay.bankCharges
              id          : pay.id_paymnet
              notes       : pay.notes
              date        : new Date pay.paymentDate
              mode        : pay.paymentMode
              reference   : pay.reference
              sendEmail   : pay.sendEmail
              taxDeducted : pay.taxDeducted
            totalPaid += pay.amount
          adapted =
            adjustment  : response.invoice.adjustment
            billingDate : response.invoice.billingDate
            comments    : response.invoice.comments
            dueDate     : response.invoice.dueDate
            sendedTo    : response.invoice.emailsTo
            number      : response.invoice.number
            operations  : response.invoice.operations
            status      : response.invoice.status
            subTotal    : response.invoice.subTotal
            total       : response.invoice.total
            lateFee     : response.invoice.lateFeeId
            term        : response.invoice.termId
            payments    : payments
            totalPaid   : totalPaid
          params.done(adapted)
        fail : ->
          params.fail()

    getTaxes : (params) ->

      $api.get
        url: "#{$url}technoRidesInvoiceApi/tax_config_list"
        code: 100
        codeName : "status"
        data :
            token : $user.token
        done : (response) ->
          adapted = {}
          for row in response.rows
            adapted[row.id] = row
          params.done adapted
        fail : (response) ->

    getLateFees : (params) ->
      $api.get
        url : "#{$url}technoRidesInvoiceApi/late_fee_config_list"
        code : 100
        codeName: "status"
        data:
          token : $user.token
        done : (response) ->
          adapted = {}
          for row in response.rows
            adapted[row.id] = row
          params.done adapted
        fail : (response) ->

    getTerms : (params) ->
      $api.get
        url : "#{$url}technoRidesInvoiceApi/term_config_list"
        data:
          token : $user.token
        code : 100
        codeName: "status"
        done : (response) ->
          adapted = {}
          for row in response.rows
            adapted[row.id] = row
          params.done adapted
        fail : (response) ->

    getCompanyInfo : (params) ->
      $api.get
        url :"#{$url}technoRidesCorporateUserApi/corporate_view_list"
        data:
          corporate_id : $user.company
          page         :1
          rows         :10000
          searchField  : "id"
          searchOper   : "eq"
          searchString : $user.company
          token        : $user.token
        code: 100
        codeName : "status"
        done : (response) ->
          adapted = response.rows[0].cell
          params.done adapted
        fail : (response) ->

    pay : (params) ->
      $api.get
        data      :
          from    : $user.email
          to      : $company.info?.adminMail
          subject : "Corporate | new payment report"
          status  : "ENTERPRISE"
          message : "<p>Reference : #{params.payment.reference}</p>
                     <p>Amount : #{params.payment.amount}</p>
                     <p>Method : #{params.payment.method}</p>
                     <p>Comments: #{params.payment.comments}</p>"

        code      : 200
        codeName  : "status"
        url       : "#{$url}inboxApi/send_email"
        done      : (response) ->
          params.done()
        fail  : (response) ->

    edit : (params) ->
      $api.get
        data :
          cuit         : params.corp.cuit
          id           : $user.company
          legalAddress : params.corp.legalAddress
          name         : params.corp.name
          oper         : "edit"
          phone        : params.corp.phone
          token        : $user.token
        code : 100
        codeName : "status"
        url : "#{$url}technoRidesCorporateUserApi/corporate_edit"
        done : (response) ->
          params.done()
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            params.fail()
