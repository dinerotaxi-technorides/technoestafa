package com.api.technorides

import grails.converters.JSON

import java.text.SimpleDateFormat

import ar.com.goliath.Company
import ar.com.goliath.CompanyAccount
import ar.com.goliath.CompanyAccountEmployee
import ar.com.goliath.EmployUser
import ar.com.goliath.InvestorsContact
import ar.com.goliath.RealUser
import ar.com.goliath.Role
import ar.com.goliath.TypeEmployer
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.goliath.Vehicle
import ar.com.goliath.corporate.Corporate
import ar.com.goliath.corporate.CorporateUser
import ar.com.goliath.corporate.CostCenter
import ar.com.goliath.corporate.billing.BillingEnterpriseHistory
import ar.com.goliath.corporate.billing.BillingPayments
import ar.com.goliath.corporate.billing.LateFeeConfig
import ar.com.goliath.corporate.billing.TaxConfig
import ar.com.goliath.corporate.billing.TermConfig
import ar.com.operation.Operation
import ar.com.operation.OperationCompanyHistory
import ar.com.operation.TRANSACTIONSTATUS

class TechnoRidesCorporateService {
	def springSecurityService
	def utilsApiService
	def editCorporate( params,rtaxi){
		def corporate = null
		def message   = ""
		def state     = "FAIL"
		def id        = null
		def id_cost   = null
		def discount  = 0
		if (params?.discount)
			discount = params.int('discount')
		// determine our action
		boolean is_already_created = false
		switch (params.oper) {
			case 'add':
				def c_validate = Corporate.findByNameAndRtaxi(params?.name,rtaxi)
				if(c_validate && c_validate.visible){
					message =  "corporate.user_exist.not.saved"
					return
				}else if(c_validate && !c_validate.visible){
					corporate = Corporate.get(c_validate.id)
					corporate.visible = true
					is_already_created = true
				}else{
					corporate = new Corporate()
				}

				corporate.name         = params?.name
				corporate.phone        = params?.phone
				corporate.phone1       = params?.phone1
				corporate.discount     = discount
				corporate.cuit         = params?.cuit
				corporate.legalAddress = params?.legalAddress
				corporate.rtaxi        = rtaxi

				if (! corporate.hasErrors() && corporate.save(flush:true)) {
					message = "corporate.saved"
					def cost_center = null
					if (!is_already_created){
						cost_center = new CostCenter(name:'default',rtaxi:rtaxi,corporate:corporate,visible:true).save(flush:true)

						cost_center.errors.each{
							print it
						}
					}else{
						cost_center = CostCenter.findByCorporate(corporate)
					}

					id_cost = cost_center.id

					id      = corporate.id

					state = "OK"
				} else {
					message =  "corporate.not.saved"
					corporate.errors.each{ print it }
				}
				break;
			case 'del':
				corporate = Corporate.get(params.id)
				if(corporate){
					corporate.visible=false
					corporate.save()
					message = "customer.deleted.ok"
				}else{
					message = "customer.error.not.delete"
				}
				break;
			default:
				corporate = Corporate.get(params.id)
				if (corporate && corporate.rtaxi == rtaxi) {
					// set the properties according to passed in parameters
					corporate.name     = params?.name
					corporate.phone    = params?.phone
					corporate.discount = discount
					corporate.phone1   = params?.phone1
					corporate.cuit     = params?.cuit
					corporate.legalAddress=params?.legalAddress

					if (! corporate.hasErrors() && corporate.save(flush:true)) {
						message = "corporate.modified.ok"
						id = corporate.id
						state = "OK"
					} else {
						message = "corporate.error.not.updated"
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,status:100,id:id,id_cost:id_cost]

		return jsonData as JSON
	}
	def editCostCenter( params,rtaxi){
		def cost_center = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':

				def corporate = Corporate.get(params.id)
				if (corporate && corporate.rtaxi == rtaxi) {
					cost_center = new CostCenter()

					cost_center.name  = params?.name
					cost_center.phone = params?.phone
					cost_center.legalAddress = params?.legalAddress
					cost_center.rtaxi     = rtaxi
					cost_center.corporate = corporate
					cost_center.visible = true

					if (! cost_center.hasErrors() && cost_center.save(flush:true)) {
						message = "cost.center.saved"
						id = cost_center.id
						state = "OK"
					} else {
						message =  "cost.center.not.saved"
						cost_center.errors.each{ print it }
					}
				}else{
					message =  "cost.center.not.saved.corporate_no_exist"

				}
				break;
			case 'del':
				cost_center = CostCenter.get(params.cost_id)
				if (cost_center && cost_center.rtaxi ==rtaxi) {
					// set the properties according to passed in parameters
					cost_center.visible  = false
					if (! cost_center.hasErrors() && cost_center.save(flush:true)) {

						def employeees=CorporateUser.findAllByCostCenter(cost_center)
						employeees.each{
							it.accountLocked=true
							it.save(flush:true)
						}
						message = "cost.center.deleted"
						id = cost_center.id
						state = "OK"
					} else {
						message =  "cost.center.not.saved"
						cost_center.errors.each{ print it }
					}
				}
				break;
			default:
				cost_center = CostCenter.get(params.cost_id)
				if (cost_center && cost_center.rtaxi ==rtaxi) {
					// set the properties according to passed in parameters
					cost_center.name  = params?.name
					cost_center.phone = params?.phone
					cost_center.legalAddress = params?.legalAddress
					if (! cost_center.hasErrors() && cost_center.save(flush:true)) {
						message = "cost.center.saved"
						id = cost_center.id
						state = "OK"
					} else {
						message =  "cost.center.not.saved"
						cost_center.errors.each{ print it }
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,status:100,id:id]

		return jsonData as JSON
	}
	def editRecordPayment( params,rtaxi){

		def billingHistory = BillingEnterpriseHistory.get(params.billing_id)
		def payments = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':

				payments = new BillingPayments()
				payments.bankCharges = params?.double('bankCharges')
				payments.amount = params?.double('amount')
				payments.taxDeducted =  params?.taxDeducted
				payments.paymentDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(params?.paymentDate)
				payments.paymentMode  = params?.paymentMode
				payments.reference  = params?.reference
				payments.notes  = params?.notes?:''
				payments.sendEmail     = params?.sendEmail
				if (! payments.hasErrors() && payments.save(flush:true)) {
					billingHistory.addToPayments(payments)
					billingHistory.total -= payments.amount
					if(billingHistory.total >0){
						billingHistory.status = 'PARTIALLY_PAID'
					}else{
						billingHistory.status = 'PAID'
					}
					billingHistory.save()
					message = "payments.saved"
					id = payments.id
					state = "OK"
				} else {
					message =  "payments.not.saved"
					payments.errors.each{ print it }
				}
				break;
			case 'del':

				payments = BillingPayments.get(params.payment_id)
				if(payments){

					billingHistory.total += payments.amount
					if(billingHistory.total <0){
						billingHistory.status = 'PARTIALLY_PAID'
					}else{
						billingHistory.status = 'PENDING'
					}
					billingHistory.removeFromPayments(payments)
					billingHistory.save()
					payments.delete()
				}
//				customer = EmployUser.get(params.id)
//				if(customer){
//					customer.visible=false
//					customer.enabled=false
//					customer.accountLocked=true
//					customer.save()
//					message = "customer.deleted.ok"
//				}else{
//					message = "customer.error.not.delete"
//				}
				message = "payment.deleted.ok"
				state = "OK"
				break;
			default:

				break;
		}

		def jsonData = [message:message,state:state,status:100,id:id]

		return jsonData as JSON
	}

	def editLateConfigFee( params,rtaxi){
		def late_fee = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':

				late_fee = new LateFeeConfig()

				late_fee.name  = params?.name
				late_fee.charge = params?.double('charge')
				late_fee.frequency = params?.int('frequency')
				late_fee.typeCharge = params?.int('typeCharge')
				late_fee.rtaxi     = rtaxi

				if (! late_fee.hasErrors() && late_fee.save(flush:true)) {
					message = "late.fee.saved"
					id = late_fee.id
					state = "OK"
				} else {
					message =  "late.fee.not.saved"
					late_fee.errors.each{ print it }
				}
				break;
			case 'del':
				late_fee = LateFeeConfig.get(params.late_fee_id)
				if (late_fee && late_fee.rtaxi == rtaxi) {
					id = late_fee.id
					message = "late.fee.deleted"
					state = "OK"
					late_fee.delete()
				}
				break;

			default:
				late_fee = LateFeeConfig.get(params.late_fee_id)
				if (late_fee && late_fee.rtaxi == rtaxi) {
					// set the properties according to passed in parameters
					late_fee.name  = params?.name
					late_fee.charge = params?.double('charge')
					late_fee.frequency = params?.int('frequency')
					late_fee.typeCharge = params?.int('typeCharge')
					if (! late_fee.hasErrors() && late_fee.save(flush:true)) {
						message = "late.fee.saved"
						id = late_fee.id
						state = "OK"
					} else {
						message =  "late.fee.not.saved"
						late_fee.errors.each{ print it }
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,status:100,id:id]

		return jsonData as JSON
	}

	def editTaxConfig( params,rtaxi){
        def tax = null
        def message = ""
        def state = "FAIL"
        def id
        // determine our action
        switch (params.oper) {
            case 'add':

				tax = new TaxConfig()

				tax.name  = params?.name
				tax.charge = params?.double('charge')
				tax.rtaxi     = rtaxi

				if (! tax.hasErrors() && tax.save(flush:true)) {
				    message = "tax.saved"
					id = tax.id
					state = "OK"
				} else {
				    message =  "tax.not.saved"
				    tax.errors.each{ print it }
				}
				break;
			case 'del':
				tax = TaxConfig.get(params.tax_id)
				if (tax && tax.rtaxi == rtaxi) {
					id = tax.id
					message = "tax.deleted"
					state = "OK"
					tax.delete()
				}
				break;
            default:
                tax = TaxConfig.get(params.tax_id)
                if (tax && tax.rtaxi == rtaxi) {
                    // set the properties according to passed in parameters
                    tax.name  = params?.name
                    tax.charge = params?.double('charge')
                    if (! tax.hasErrors() && tax.save(flush:true)) {
                        message = "tax.saved"
                        id = tax.id
                        state = "OK"
                    } else {
                        message =  "late.fee.not.saved"
                        tax.errors.each{ print it }
                    }
                }
                break;
        }

        def jsonData = [message:message,state:state,status:100,id:id]

        return jsonData as JSON
    }

	def editTermsConfig( params,rtaxi){
		def tax = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':

				tax = new TermConfig()

				tax.name  = params?.name
				tax.days = params?.int('days')
				tax.rtaxi     = rtaxi

				if (! tax.hasErrors() && tax.save(flush:true)) {
					message = "tax.saved"
					id = tax.id
					state = "OK"
				} else {
					message =  "tax.not.saved"
					tax.errors.each{ print it }
				}
				break;
			case 'del':
				tax = TermConfig.get(params.term_id)
				if (tax && tax.rtaxi == rtaxi) {
					id = tax.id
					message = "tax.deleted"
					state = "OK"
					tax.delete()
				}else{
					message = "tax.can.not.deleted"
					state = "FAIL"

				}
				break;
			default:
				tax = TermConfig.get(params.term_id)
				if (tax && tax.rtaxi == rtaxi) {
					// set the properties according to passed in parameters
					tax.name  = params?.name
					tax.days = params?.int('days')
					if (! tax.hasErrors() && tax.save(flush:true)) {
						message = "tax.saved"
						id = tax.id
						state = "OK"
					} else {
						message =  "late.fee.not.saved"
						tax.errors.each{ print it }
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,status:100,id:id]

		return jsonData as JSON
	}



	def getCorporateEmplyee( params,rtaxi) {

		def sortIndex   = params.sidx ?: 'id'
		def sortOrder   = params.sord ?: 'desc'
		def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
		def currentPage = params?.page? Integer.valueOf(params.page) : 1

		def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def usersCriterea = CorporateUser.createCriteria()

		def customers = CorporateUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi', rtaxi)
			if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
				ilike("username", params.searchString+"%")
			}
			if(  params.searchField.equals("firstName") && !params.searchString.isEmpty()){
				ilike("firstName", params.searchString+"%")
			}
			if(  params.searchField.equals("lastName") && !params.searchString.isEmpty()){
				ilike("lastName", params.searchString+"%")
			}
			if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
				ilike("phone", params.searchString+"%")
			}

			order(sortIndex, sortOrder)
		}

		def totalRows     = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.typeEmploy.toString(),
					it.enabled,
					it.admin
				], id: it.id]
		}

		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]

		return jsonData as JSON
	}

	def createOrEditCorporate( params,rtaxi,boolean is_taxi_company, usr){
		def customer = null
		def message = ""
		def state = "FAIL"
		def id   = null
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findByUsernameAndRtaxi(params?.username,rtaxi)
				def costCenter = CostCenter.get(params?.id_cost)
				if(user?.username){
					message = "user.exist"
				}else if(!costCenter || costCenter.rtaxi != rtaxi){
					message = "user.cost_error"
				}else{
					customer = new CorporateUser()
					def employeeRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")
					customer.status=UStatus.DONE
					customer.createdDate=new Date()
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.password=params?.password
					customer.firstName=params?.firstName
					customer.lastName=params?.lastName
					customer.agree = params.agree.contains("off")?false:true
					customer.admin = params.admin.contains("off")?false:true
					customer.corporateSuperUser = params.corporateSuperUser.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					customer.rtaxi=rtaxi
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.lang=rtaxi.lang
					customer.city=rtaxi.city
					customer.costCenter = costCenter
					if (! customer.hasErrors() && customer.save(flush:true)) {
						if (!customer.authorities.contains(employeeRole)) {
							UserRole.create customer, employeeRole
						}
						utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
						message = "customer.added"
						state = "OK"
						id    = customer.id
					} else {
						message = "error.not.save"
						customer.errors.each {
							print it
						}
					}
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = CorporateUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					if(params?.password)
						customer.password=params?.password
					customer.firstName=params?.firstName
					customer.lastName=params?.lastName
					customer.agree = params.agree.contains("off")?false:true
					if(customer.corporateSuperUser || is_taxi_company || usr.corporateSuperUser)
						customer.corporateSuperUser = params.corporateSuperUser.contains("off")?false:true
					if(customer.admin || customer.corporateSuperUser || is_taxi_company  || usr.admin)
						customer.admin = params.admin.contains("off")?false:true

					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "customer.modified.ok"
						id = customer.id
						state = "OK"
					} else {
						customer.errors.each {
							print it
						}
						message = "customer.error.not.updated"
					}
				}else{

					message = "customer.doesnt.exist"
				}
				break;
		}

		def jsonData = [message:message,state:state,id:id]

		return jsonData as JSON
	}










	def getPosibleInvestor(params) {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1

		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = InvestorsContact.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(  params.searchField.equals("email") && !params.searchString.isEmpty()){
				ilike("email", params.searchString+"%")
			}
			if(  params.searchField.equals("firstName") && !params.searchString.isEmpty()){
				ilike("firstName", params.searchString+"%")
			}
			if(  params.searchField.equals("lastName") && !params.searchString.isEmpty()){
				ilike("lastName", params.searchString+"%")
			}
			if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
				ilike("phone", params.searchString+"%")
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [
					it.email,
					it.firstName,
					it.lastName,
					it.phone,
					it.country,
					it.startupInvestor,
					it.status,
					it.rangeInvest,
					it.companyPosition,
					it.companyName,
					it.profileType,
					it.linkedinUrl,
					it.facebookUrl,
					it.plataformUrl,
					it.website
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	def getInvestorCounters() {
		def customers = RealUser.count()
		def operations = Operation.last()
		def jsonData= [operations: operations.id,customers:customers,status:100]
		return jsonData as JSON
	}
	def getMonitorCounters(rtaxi) {
		def customers = RealUser.countByRtaxi(rtaxi)
		def operations = Operation.countByCompany(rtaxi)
		def jsonData= [operations: operations,customers:customers,status:100]
		return jsonData as JSON
	}
	def getUserByEmail( email,rtaxi) {

		def customers      = RealUser.findAllByEmailIlikeAndRtaxi("${email}%",rtaxi)
		def customers_corp = CorporateUser.findAllByEmailIlikeAndRtaxi("${email}%",rtaxi)
		def jsonCells = customers.collect {
			[is_cc:false,phone: it?.phone,email:it?.email,first_name:it?.firstName,last_name:it?.lastName,user_id:it?.id,value:it?.phone+" - "+it?.firstName+" "+it?.lastName]
		}
		def jsonCells_cc = customers_corp.collect {
			[is_cc:true,phone: it?.phone,email:it?.email,first_name:it?.firstName,last_name:it?.lastName,user_id:it?.id,value:it?.phone+" - "+it?.firstName+" "+it?.lastName]
		}
		jsonCells.addAll(jsonCells_cc)

		return jsonCells
	}
	def getUserByPhone( phone,rtaxi) {

		def customers =RealUser.findAllByPhoneIlikeAndRtaxi("${phone}%",rtaxi)
		def customers_corp =CompanyAccountEmployee.findAllByPhoneIlikeAndRtaxi("${phone}%",rtaxi)
		def jsonCells = customers.collect {
			[is_cc:false,phone: it?.phone,email:it?.email,first_name:it?.firstName,last_name:it?.lastName,user_id:it?.id,value:it?.phone+" - "+it?.firstName+" "+it?.lastName]
		}
		def jsonCells_cc = customers_corp.collect {
			[is_cc:true,phone: it?.phone,email:it?.email,first_name:it?.firstName,last_name:it?.lastName,user_id:it?.id,value:it?.phone+" - "+it?.firstName+" "+it?.lastName]
		}
		jsonCells.addAll(jsonCells_cc)

		return jsonCells
	}
	def getUsers( params,rtaxi) {

		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1

		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def usersCriterea=User.createCriteria()

		def customers = RealUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi', rtaxi)
			if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
				ilike("username", params.searchString+"%")
			}
			if(  params.searchField.equals("firstName") && !params.searchString.isEmpty()){
				ilike("firstName", params.searchString+"%")
			}
			if(  params.searchField.equals("lastName") && !params.searchString.isEmpty()){
				ilike("lastName", params.searchString+"%")
			}
			if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
				ilike("phone", params.searchString+"%")
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [
					utilsApiService.generateFormatedAddressToClient(it.createdDate,it),
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.enabled
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	def getCorporativeAccount( params,rtaxi) {

		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1

		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def usersCriterea=User.createCriteria()

		def customers = CompanyAccount.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi', rtaxi)
			if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
				ilike("username", params.searchString+"%")
			}
			if(  params.searchField.equals("companyName") && !params.searchString.isEmpty()){
				ilike("companyName", params.searchString+"%")
			}
			if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
				ilike("phone", params.searchString+"%")
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [
					it.companyName,
					it.username,
					"****",
					it.phone,
					it.enabled
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	def getCorporativeAccountUsers( params,rtaxi) {

		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1

		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def usersCriterea=User.createCriteria()

		def customers = CorporateUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi', rtaxi)
			if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
				ilike("username", params.searchString+"%")
			}
			if(  params.searchField.equals("firstName") && !params.searchString.isEmpty()){
				ilike("firstName", params.searchString+"%")
			}
			if(  params.searchField.equals("firstName") && !params.searchString.isEmpty()){
				ilike("lastName", params.searchString+"%")
			}
			if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
				ilike("phone", params.searchString+"%")
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [
					it.employee.companyName,
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.countTripsCompleted,
					it.agree
				], employeeId:it.employee.id ,id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}

	def getAllVehiclesByCompany( params,rtaxi) {


		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'


		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = Vehicle.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('company', rtaxi)
			if(  params.searchField.equals("patente") && !params.searchString.isEmpty()){
				ilike("patente", params.searchString+"%")
			}
			if(  params.searchField.equals("marca") && !params.searchString.isEmpty()){
				ilike("marca", params.searchString+"%")
			}
			if(  params.searchField.equals("modelo") && !params.searchString.isEmpty()){
				ilike("modelo", params.searchString+"%")
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [
					it.patente,
					it.marca,
					it.modelo,
					it.active
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}

	def createOrEditCorporateAccount( params,rtaxi){
		def customer = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findByUsernameAndRtaxi(params?.username,rtaxi)
				if(user?.username){
					message = "company.exist"
				}else{
					customer = new CompanyAccount()
					def companyRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT")
					customer.companyName = params?.companyName
					customer.status=UStatus.DONE
					customer.createdDate=new Date()
					customer.cuit = params?.cuit
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.password=params?.password
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					customer.rtaxi=rtaxi
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.lang=rtaxi.lang
					customer.city=rtaxi.city
					if (! customer.hasErrors() && customer.save(flush:true)) {
						if (!customer.authorities.contains(companyRole)) {
							UserRole.create customer, companyRole
						}
						utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
						message = "customer.added"
						state = "OK"
					} else {
						message = "error.not.save"
						customer.errors.each {
							print it
						}
					}
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = CompanyAccount.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.companyName = params?.companyName
					customer.cuit = params?.cuit
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.password=params?.password
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "customer.modified.ok"
						id = customer.id
						state = "OK"
					} else {
						message = "customer.error.not.updated"
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,id:id]

		return jsonData as JSON
	}

	def createOrEditCorporateAccountUser( params,rtaxi){
		def customer = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action

		switch (params.oper) {
			case 'add':
			// add instruction sent
			// add instruction sent
				def intermediario = CompanyAccount.get(params.empresa)
				def uuuu=User.findByUsernameAndRtaxi(params.username+"@"+intermediario.email.split("@")[1],rtaxi)
				if(uuuu?.email){
					message = "usuario existente"
				}else{
					customer = new CorporateUser()
					def employeeRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")
					customer.status=UStatus.DONE
					customer.createdDate=new Date()
					customer.validated=UStatus.DONE
					customer.rtaxi=rtaxi
					customer.username=params.username.split("@")[0]+"@"+intermediario.email.split("@")[1]
					customer.email=params.username.split("@")[0]+"@"+intermediario.email.split("@")[1]
					customer.password=params.password
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.phone=params.phone
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					customer.rtaxi=rtaxi
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.lang=rtaxi.lang
					customer.city=rtaxi.city
					customer.typeEmploy=TypeEmployer.COMPANYEMPLOYEE
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Customer  Added"
						UserRole.create customer, employeeRole
						utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
						state = "OK"
					} else {
						customer.errors.each{ print it }
						message = "Could Not Save User"
					}

				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = CorporateUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.firstName = params?.firstName
					customer.lastName = params?.lastName
					customer.phone = params?.phone
					customer.password=params.password
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Customer  ${customer.firstName} ${customer.lastName} Updated"
						id = customer.id
						state = "OK"
					} else {
						message = "Could Not Update Customer"
					}
				}
				break;
		}


		def jsonData = [message:message,state:state,id:id]

		return jsonData as JSON
	}
	def createOrEditUser( params,rtaxi){
		def customer = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findByUsernameAndRtaxi(params?.username,rtaxi)
				if(user?.username){
					message = "company.exist"
				}else{
					customer = new RealUser()
					def companyRole=Role.findByAuthority("ROLE_USER")

					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.status=UStatus.DONE
					customer.createdDate=new Date()
					customer.validated=UStatus.DONE
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.password=params?.password
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					customer.rtaxi=rtaxi
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.lang=rtaxi.lang
					customer.city=rtaxi.city
					if (! customer.hasErrors() && customer.save(flush:true)) {
						if (!customer.authorities.contains(companyRole)) {
							UserRole.create customer, companyRole
						}
						utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
						message = "customer.added"
						state = "OK"
					} else {
						message = "error.not.save"
					}
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = RealUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.phone = params?.phone
					//					customer.username=params?.username
					//					customer.email=params?.username
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.password=params?.password
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "customer.modified.ok"
						id = customer.id
						state = "OK"
					} else {
						message = "customer.error.not.updated"
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,id:id]

		return jsonData as JSON
	}
	def createOrEditEmployUserDriver( params,rtaxi){
		def customer = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findByUsernameAndRtaxi(params?.username+"@"+rtaxi.email.split("@")[1],rtaxi)
				if(user?.username){
					message = "company.exist"
				}else{
					customer = new EmployUser()
					def companyRole=Role.findByAuthority("ROLE_TAXI")
					customer.phone = params?.phone
					customer.username=params?.username.split("@")[0]+"@"+rtaxi.email.split("@")[1]
					customer.email=params?.username.split("@")[0]+"@"+rtaxi.email.split("@")[1]
					customer.password=params?.password
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.typeEmploy=TypeEmployer.TAXISTA
					customer.status=UStatus.DONE
					customer.createdDate=new Date()
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					customer.rtaxi=rtaxi
					customer.employee=rtaxi
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.lang=rtaxi.lang
					customer.city=rtaxi.city
					if (! customer.hasErrors() && customer.save(flush:true)) {

						if(params?.patente){
							def ve=Vehicle.findByPatente(params?.patente)
							if(ve){
								ve.addToTaxistas(customer)
							}
						}
						if (!customer.authorities.contains(companyRole)) {
							UserRole.create customer, companyRole
						}
						utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
						message = "customer.added"
						state = "OK"
					} else {
						customer.errors.each{ println it }
						message = "error.not.save"
					}
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = EmployUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.companyName = params?.companyName
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.password=params?.password
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					if(params?.patente){
						def vere=Vehicle.findByTaxistas(customer)
						if(vere){
							vere.removeFromTaxistas(customer)
						}
						def ve=Vehicle.findByPatente(params?.patente)
						if(ve){
							ve.addToTaxistas(customer)
						}
					}
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "customer.modified.ok"
						id = customer.id
						state = "OK"
					} else {
						customer.errors.each { println it }
						message = "customer.error.not.updated"
					}
				}else{
					message = "customer.doesnt.exist"
				}
				break;
		}

		def jsonData = [message:message,state:state,id:id]

		return jsonData as JSON
	}
	def createDriverProfile( params,rtaxi){
		def customer = null
		def message = ""
		def state = "FAIL"
		def code=200
		def id
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findByUsernameAndRtaxi(params?.username+"@"+rtaxi.email.split("@")[1],rtaxi)
				def vehicle=null
				def employUser = EmployUser.get(user?.id)
				if(employUser?.username && employUser?.visible){
					message = "company.exist"
					code=400
				}else{
					if(employUser?.username){
						customer =  EmployUser.get(user?.id)
						vehicle = Vehicle.findByTaxistas(customer)
						if(!vehicle)
							vehicle = new Vehicle()
					}else{
						customer = new EmployUser()
						vehicle = new Vehicle()
					}
					def companyRole=Role.findByAuthority("ROLE_TAXI")
					customer.phone = params?.phone
					customer.username=params?.username.split("@")[0]+"@"+rtaxi.email.split("@")[1]
					customer.email=params?.username.split("@")[0]+"@"+rtaxi.email.split("@")[1]
					customer.password=params?.password
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.typeEmploy=TypeEmployer.TAXISTA
					customer.status=UStatus.DONE
					customer.createdDate=new Date()
					customer.agree=true
					customer.enabled =true
					customer.accountLocked= false
					customer.politics=true
					customer.visible=true
					customer.cuit=params?.cuit?:''
					customer.licenceNumber=params?.licenceNumber?:''
					if(params?.licenceEndDate){
						customer.licenceEndDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params?.licenceEndDate)
					}
					customer.rtaxi=rtaxi
					customer.employee=rtaxi
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.lang=rtaxi.lang
					customer.city=rtaxi.city
					vehicle.patente=params?.patente
					vehicle.createdDate=new Date()
					vehicle.marca = params?.marca
					vehicle.modelo = params?.modelo
					vehicle.active=true
					vehicle.company=rtaxi
					if (! customer.hasErrors() || ! vehicle.hasErrors()  ) {
						if(!vehicle.save(flush:true) || !customer.save(flush:true)){
							vehicle.errors.each{
								print it
							}
							customer.errors.each{
								print it
							}
							code=406
							message = "vehicle.cant-add"
						}else{
							vehicle.addToTaxistas(customer)
							if (!customer.authorities.contains(companyRole)) {
								UserRole.create customer, companyRole
							}
							utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
							message = "customer.added"
							state = "OK"
						}
					} else {
						customer.errors.each{ println it }
						message = "error.not.save"
					}
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = EmployUser.get(params.id)
				def vere=Vehicle.findByTaxistas(customer)
				if(!customer){
					message = "driver.not.exist"
					code=400
				}else if (customer) {
					// set the properties according to passed in parameters
					customer.companyName = params?.companyName
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.cuit=params?.cuit?:''
					customer.licenceNumber=params?.licenceNumber?:''
					if(params?.licenceEndDate){
						customer.licenceEndDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params?.licenceEndDate)
					}
					if(params?.password)
						customer.password=params?.password
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					if(params?.enabled){
						customer.enabled =params.enabled.contains("false")?false:true
						customer.accountLocked =params.enabled.contains("false")?true:false
					}
					if(params?.patente){
						if(vere){
							vere.patente=params?.patente
							vere.createdDate=new Date()
							vere.marca = params?.marca
							vere.modelo = params?.modelo
							vere.active=true
							vere.save()
						}else{
							def vehicle = new Vehicle()
							vehicle.patente=params?.patente
							vehicle.createdDate=new Date()
							vehicle.marca = params?.marca
							vehicle.modelo = params?.modelo
							vehicle.active=true
							vehicle.company=rtaxi
							vehicle.save(flush:true)
							vehicle.addToTaxistas(customer)
						}

					}
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "customer.modified.ok"
						id = customer.id
						state = "OK"
					} else {
						customer.errors.each { println it }
						code=402
						message = "customer.error.not.updated"
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,id:id,code:code,status:100]

		return jsonData as JSON
	}







	def createOrEditInvestorsContact( params){

		def customer = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =InvestorsContact.findByEmail(params?.email.toString())
				if(user?.email){
					message = "company.exist"
				}else{
					customer = new InvestorsContact()
					customer.email = params?.email
					customer.firstName=params?.firstName
					customer.lastName=params?.lastName
					customer.phone=params?.phone
					customer.country=params.country
					customer.startupInvestor=params.startupInvestor
					customer.status=params.status
					customer.rangeInvest=params.rangeInvest
					customer.companyPosition=params.companyPosition
					customer.companyName=params.companyName
					customer.profileType=params.profileType
					customer.linkedinUrl=params.linkedinUrl
					customer.facebookUrl=params.facebookUrl
					customer.plataformUrl=params.plataformUrl
					customer.website=params.website
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "customer.added"
						state = "OK"
					} else {
						customer.errors.each{ println it }
						message = "error.not.save"
					}
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = InvestorsContact.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.email = params?.email
					customer.firstName=params?.firstName
					customer.lastName=params?.lastName
					customer.phone=params?.phone
					customer.country=params.country
					customer.startupInvestor=params.startupInvestor
					customer.status=params.status
					customer.rangeInvest=params.rangeInvest
					customer.companyPosition=params.companyPosition
					customer.companyName=params.companyName
					customer.profileType=params.profileType
					customer.linkedinUrl=params.linkedinUrl
					customer.facebookUrl=params.facebookUrl
					customer.plataformUrl=params.plataformUrl
					customer.website=params.website
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "customer.modified.ok"
						id = customer.id
						state = "OK"
					} else {
						customer.errors.each { println it }
						message = "customer.error.not.updated"
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,id:id,status:100]

		return jsonData as JSON
	}


	def getAllCompanyAccount( user) {
		def customers = CompanyAccount.createCriteria().list() { eq('rtaxi',user) }
		return customers
	}
	def createOrEditEmployUserOperator( params,rtaxi){
		def customer = null
		def message = ""
		def state = "FAIL"
		def id=null
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findByUsernameAndRtaxi(params?.username+"@"+rtaxi.email.split("@")[1],rtaxi)

				def employUser = EmployUser.get(user?.id)
				if(employUser?.username && employUser?.visible){
					message = "company.exist"
					code=400
				}else{
					def companyRole=null
					if(employUser?.username){
						customer =  EmployUser.get(user?.id)
					}else{
						customer = new EmployUser()
					}
					if(TypeEmployer.OPERADOR.toString().equals(params?.typeEmploy)){
						companyRole=Role.findByAuthority("ROLE_OPERATOR")
						customer.typeEmploy=TypeEmployer.OPERADOR
					}else if(TypeEmployer.MONITOR.toString().equals(params?.typeEmploy)){
						companyRole=Role.findByAuthority("ROLE_MONITOR")
						customer.typeEmploy=TypeEmployer.MONITOR
					}else{
						companyRole=Role.findByAuthority("ROLE_TELEPHONIST")
						customer.typeEmploy=TypeEmployer.TELEFONISTA
					}
					customer.visible=true
					customer.phone = params?.phone
					customer.username=params?.username+"@"+rtaxi.email.split("@")[1]
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.email=params?.username+"@"+rtaxi.email.split("@")[1]
					customer.password=params?.password
					customer.status=UStatus.DONE
					customer.createdDate=new Date()
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked=!customer.agree
					customer.politics=customer.agree
					customer.rtaxi=rtaxi
					customer.employee=rtaxi
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.lang=rtaxi.lang
					customer.city=rtaxi.city
					if (! customer.hasErrors() && customer.save(flush:true)) {
						UserRole.findAllByUser(customer).each { it.delete(flush:true) }
						if (!customer.authorities.contains(companyRole)) {
							UserRole.create customer, companyRole
						}
						utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
						println "se salvoooo"
						message = "customer.added"
						state = "OK"
					} else {
						customer.errors.each{ println it }
						message = "error.not.save"
					}
				}
				break;

			case 'del':
				customer = EmployUser.get(params.id)
				if(customer){
					customer.visible=false
					customer.enabled=false
					customer.accountLocked=true
					customer.save()
					message = "customer.deleted.ok"
				}else{
					message = "customer.error.not.delete"
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = EmployUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.phone = params?.phone
					customer.username=params?.username
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.email=params?.username
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.password=params?.password
					customer.agree= params.agree.contains("off")?false:true
					customer.enabled =customer.agree
					customer.accountLocked= !customer.agree
					customer.politics=customer.agree
					def companyRole=null
					if(TypeEmployer.OPERADOR.toString().equals(params?.typeEmploy)){
						companyRole=Role.findByAuthority("ROLE_OPERATOR")
						customer.typeEmploy=TypeEmployer.OPERADOR
					}else if(TypeEmployer.MONITOR.toString().equals(params?.typeEmploy)){
						companyRole=Role.findByAuthority("ROLE_MONITOR")
						customer.typeEmploy=TypeEmployer.MONITOR
					}else{
						companyRole=Role.findByAuthority("ROLE_TELEPHONIST")
						customer.typeEmploy=TypeEmployer.TELEFONISTA
					}
					if (! customer.hasErrors() && customer.save(flush:true)) {
						UserRole.findAllByUser(customer).each { it.delete(flush:true) }
						UserRole.create customer, companyRole
						utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
						message = "customer.modified.ok"
						id = customer.id
						state = "OK"
					} else {
						message = "customer.error.not.updated"
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,status:100,id:id]

		return jsonData as JSON
	}
	def getOperationCompanyHistory( params,rtaxi) {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = Integer.valueOf(params.rows)?:10
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		if(params.sidx.equals("auto")){
			sortIndex ="taxista"
		}
		def costCenter = CostCenter.get(params.cost_id)
		def customers = OperationCompanyHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('company',rtaxi)
			eq('costCenter',costCenter)
			user{
				if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
					ilike("username", params.searchString+"%")
				}
				if(  params.searchField.equals("firstName") && !params.searchString.isEmpty()){
					ilike("firstName", params.searchString+"%")
				}
				if(  params.searchField.equals("lastName") && !params.searchString.isEmpty()){

				}
				if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
					ilike("phone", params.searchString+"%")
				}
			}
			if( params?.filter && params.filter.equals("canceled")){

				or{
					eq('status',TRANSACTIONSTATUS.CANCELED)
					eq('status',TRANSACTIONSTATUS.CANCELED_EMP)
					eq('status',TRANSACTIONSTATUS.CANCELED_DRIVER)
				}
			}
			if( params?.filter && params.filter.equals("completed")){
				or{
					eq('status',TRANSACTIONSTATUS.CALIFICATED)
					eq('status',TRANSACTIONSTATUS.SETAMOUNT)
					eq('status',TRANSACTIONSTATUS.COMPLETED)
				}

			}

			if(  params?.search && !params.search.isEmpty()){

				or{

					user{
						ilike("username", params.search+"%")
						ilike("firstName", params.search+"%")
						ilike("phone", params.search+"%")
						ilike("email", params.search+"%")
					}
					taxista{
						ilike("username", params.search+"%")
						ilike("firstName", params.search+"%")
						ilike("phone", params.search+"%")
						ilike("email", params.search+"%")

					}

				}
			}
			// set the order and direction
			for (sortI in sortIndex.split (",")) {
				order(sortI, sortOrder)

			}
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			def piso = it.favorites?.placeFromPso?:''
			def depto= it?.favorites?.placeFromDto?:''
			def driver =it?.taxista?.username?it?.taxista?.username.split('@')[0]:''
			def compania=it?.user?.rtaxi?.companyName?:'DineroTaxi'
			def placeTo=""
			def placeFromLat = it.favorites?.placeFrom?.lat
			def placeFromLng = it.favorites?.placeFrom?.lng
			def placeToLat = it.favorites?.placeTo?.lat?:""
			def placeToLng = it.favorites?.placeTo?.lng?:""
            def placeFrom = it.favorites?.placeFrom?.street
			placeFrom += it.favorites?.placeFrom?.streetNumber?:""
			placeFrom += " " + piso + " " + depto
			placeFrom = placeFrom.replaceAll("null", "")

		    def messaging = it.options?.messaging?:false
		    def pet = it.options?.pet?:false
		    def airConditioning = it.options?.airConditioning?:false
		    def smoker = it.options?.smoker?:false
		    def specialAssistant = it.options?.specialAssistant?:false
		    def luggage = it.options?.luggage?:false
		    def airport = it.options?.airport?:false
		    def vip = it.options?.vip?:false
		    def invoice = it.options?.invoice?:false
			def intermediario =it?.intermediario?.username?it?.intermediario?.username:''
			if(it.favorites?.placeTo?.street){
				placeTo += it.favorites?.placeTo?.street?:""
				placeTo += " "
				placeTo += it.favorites?.placeTo?.streetNumber?:""
			}
			[cell: [
					it.id,
					utilsApiService.generateFormatedAddressToClient(it.createdDate,rtaxi),
					it.user.firstName,
					it.user.lastName,
					driver,
					it.user.phone,
					placeFrom,
					placeFromLat,
					placeFromLng,
					placeTo,
					placeToLat,
					placeToLng,
					it.favorites.comments,
					it.stars,
					it.status.toString(),
					it.amount,
					it.dev.toString(),
					intermediario,
					messaging,
				    pet,
				    airConditioning,
				    smoker,
				    specialAssistant,
				    luggage,
				    airport,
				    vip,
				    invoice

				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	def getMetricsByCorporate(Corporate corporate){
		def billing_total = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('corporate',corporate)
					eq('visible',true)
				}
				ne('status','PAID')
			}

			projections {
				sum('total')
			}
		}

		billing_total = billing_total[0]?:0
		def billing_sub_total = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('corporate',corporate)
					eq('visible',true)

				}
				ne('status','PAID')
			}

			projections {
				sum('subTotal')
			}
		}
		billing_sub_total = billing_sub_total[0]?:0

		def c_user_count = CorporateUser.createCriteria().list() {
			and{
				costCenter{
					eq('corporate',corporate)
					eq('visible',true)

				}
			}

			projections {
				count "id",'mycount'
			}
		}
		c_user_count = c_user_count[0]?:0
		return [
			'not_paid':billing_total,
			'paid':billing_sub_total-billing_total,
			'users':c_user_count
		]

	}
	def getMetricsByUserCorporate(CorporateUser user){
		def cal1=Calendar.getInstance();
		def dateFrom=Calendar.getInstance();
		dateFrom.set(Calendar.MINUTE, 0);
		dateFrom.set(Calendar.SECOND, 0);
		dateFrom.set(Calendar.HOUR_OF_DAY, 0);
		dateFrom.set(Calendar.DAY_OF_MONTH, 1);
		def operationCharges = OperationCompanyHistory.createCriteria().list() {
			and{
				eq('user',user)
				between("createdDate",dateFrom.getTime(),cal1.getTime())

			}
		}
		def charges = 0
		def operations = 0
		if (operationCharges != null && operationCharges.amount != null){
			charges = operationCharges.amount.sum()?:0
			operations = operationCharges.size()
		}
		return [
			'opertions':operations,
			'amount':charges
		]
	}
	def getMetricsByCostCenter(CostCenter costCenter){
		def billing_total = BillingEnterpriseHistory.createCriteria().list() {
			and{
				eq('costCenter',costCenter)

				or{
					eq('status','PENDING')
					eq('status','OVERDUE')
					eq('status','PARTIALLY_PAID')

				}
			}

			projections {
				sum('total')
			}
		}

		billing_total = billing_total[0]?:0
		def billing_sub_total = BillingEnterpriseHistory.createCriteria().list() {
			and{
				eq('costCenter',costCenter)
				or{
					eq('status','PENDING')
					eq('status','OVERDUE')
					eq('status','PARTIALLY_PAID')

				}
			}

			projections {
				sum('subTotal')
			}
		}
		billing_sub_total = billing_sub_total[0]?:0

		def c_user_count = CorporateUser.createCriteria().list() {
			and{
				eq('costCenter',costCenter)
			}

			projections {
				count "id",'mycount'
			}
		}
		c_user_count = c_user_count[0]?:0
		return [
			'not_paid':billing_total,
			'paid':billing_sub_total-billing_total,
			'users':c_user_count
		]

	}
	def generateReport( params,rtaxi,CostCenter center) {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'

		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

		Date dateFrom = sf.parse(params?.dateFrom + ' 00:00:00')
		Date dateTo = sf.parse(params?.dateTo + ' 23:59:59')

		if(params.sidx.equals("auto")){
			sortIndex ="taxista"
		}
		def customers = OperationCompanyHistory.createCriteria().list() {
			and{
				eq('company',rtaxi)
				between("createdDate", dateFrom , dateTo)
				eq('costCenter',center)
			}
			order(sortIndex, sortOrder)
		}
		File file =null;
		file=new File("report.csv");
		if(!file.exists()) {
			file.createNewFile();
		}

		FileWriter report = new FileWriter(file);
		if('es' == rtaxi?.lang?:'es'){
			report.write(UtilsApiService.translateES("id,date,firstName,lastName,driver,phone,AddressFrom,AddressTo,comments,stars,status,amount")+"\n")
		}else{
			report.write("id,date,firstName,lastName,driver,phone,AddressFrom,AddressTo,comments,stars,status,amount"+"\n")
		}

		for (oper in customers) {
			def createDate = utilsApiService.generateFormatedAddressToClient(oper.createdDate,oper.user)

			//Check the createDate interval using country time zone and excludes it
			if (sf.parse(createDate).compareTo(dateFrom) != -1){
				def piso = oper.favorites?.placeFromPso?:''
				def depto= oper?.favorites?.placeFromDto?:''
				def driver =oper?.taxista?.username?oper?.taxista?.username.split('@')[0]:''
				def compania=oper?.user?.rtaxi?.companyName?:'DineroTaxi'
				def placeTo=""
				def placeFrom = oper.favorites?.placeFrom?.street+" "+oper.favorites?.placeFrom?.streetNumber+" "+piso+" "+ depto
				placeFrom = placeFrom.replaceAll(",", " ")
				def firstName = oper.user.firstName?oper.user.firstName.replaceAll(",", " "):""
				def lastName = oper.user.lastName?oper.user.lastName.replaceAll(",", " "):""
				if(oper.favorites?.placeTo?.street){
					placeTo = oper.favorites?.placeTo?.street+" "+oper.favorites?.placeTo?.streetNumber
					placeTo = placeTo.replaceAll(",", " ")
				}
				def comments = oper.favorites.comments
				//Removes (,) comma in order to avoid words shifting
				if (comments != null){comments=comments.replaceAll(",", " ")}
				def data = "${oper.id},${createDate},${firstName},${lastName},${driver},${oper.user.phone},${placeFrom},${placeTo},${comments},${oper.stars},${oper.status.toString()},${oper.amount}"
				report.write(data+"\n")
			}
		}
		report.flush();
		report.close();
		return file
	}
}
