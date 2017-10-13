package com.page.admin
import grails.converters.JSON
import ar.com.goliath.*
import ar.com.notification.ConfigurationApp
import ar.com.operation.Billing
import ar.com.operation.EXPENSES_COMPANY
import ar.com.operation.EXPENSES_CURRENCY
import ar.com.operation.EXPENSES_TYPE_CREDIT
import ar.com.operation.EXPENSES_TYPE_TAX
import ar.com.operation.Expenses
class IncomeAndExcomeController {
	def springSecurityService
	def placeService
	def adminUserService
	def sendGridService
	static allowedMethods = [getPendingTrips:'GET',edit:'POST']

	def index = {

	}
	
	def jq_get_expenses_type_tax={

		StringBuffer buf = new StringBuffer("<select id='typeTax' name='typeTax'>")

		def l=EXPENSES_TYPE_TAX.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_expenses_type_credit={

		StringBuffer buf = new StringBuffer("<select id='typeCredit' name='typeCredit'>")
		def l=EXPENSES_TYPE_CREDIT.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_expenses_company={

		StringBuffer buf = new StringBuffer("<select id='company' name='company'>")

		def l=EXPENSES_COMPANY.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_expenses_currency={

		StringBuffer buf = new StringBuffer("<select id='currency' name='currency'>")
		def l=EXPENSES_CURRENCY.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_type={

		StringBuffer buf = new StringBuffer("<select id='user.typeEmploy' name='user.typeEmploy'>")

		def l=TypeEmployer.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	
	// return JSON list of empresas
	def jq_expenses_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		
		def customers=adminUserService.getAllExpenses( maxRows,rowOffset,sortIndex,sortOrder,params)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
		[cell: [       it?.createdDate?new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.createdDate):''
				    ,it?.receiptNumber
				    ,it?.supplier
				    ,it?.concept
				    ,it?.typeCuit
				    ,it?.base
				    ,it?.base1 
				    ,it?.base2 
				    ,it?.base3
				    ,it?.tax
				    ,it?.tax1
				    ,it?.tax2
				    ,it?.tax3
				    ,it?.base8
				    ,it?.base9
				    ,it?.base10
				    ,it?.base11
				    ,it?.comments
				    ,it?.total
				    ,it?.typeCredit
				    ,it?.currency 
				    ,it?.typeTax
				    ,it?.company
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}

	// return JSON list of empresas
	def jq_expenses_credit_card_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		
		def customers=adminUserService.getAllExpensesCreditCard( maxRows,rowOffset,sortIndex,sortOrder,params)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
		[cell: [       it?.createdDate?new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.createdDate):''
				    ,it?.receiptNumber
				    ,it?.supplier
				    ,it?.concept
				    ,it?.typeCuit
				    ,it?.base
				    ,it?.exchanges
				    ,it?.base1 
				    ,it?.creditCardNumber
				    ,it?.comments
				    ,it?.total
				    ,it?.typeCredit
				    ,it?.currency 
				    ,it?.typeTax
				    ,it?.company
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	// return JSON list of empresas
	def jq_billing_list = {
		def sortIndex = params.sidx ?: 'billingDate'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		
		def customers=adminUserService.getAllBilling( maxRows,rowOffset,sortIndex,sortOrder,params)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [it?.billingDate?new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.billingDate):'',
					it?.user?.companyName,
					it?.recive,
					it?.comments,
					it?.amount,
					it?.hadpaid
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_edit_excome  = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
			 	params.createdDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.createdDate)
			    params.base = params?.double('base')
			    params.base1  = params?.double('base1')
			    params.base2  = params?.double('base2')
			    params.base3 = params?.double('base3')
			    params.tax = params?.double('tax')
			    params.tax1 = params?.double('tax1')
			    params.tax2 = params?.double('tax2')
			    params.tax3 = params?.double('tax3')
			    params.base8 = params?.double('base8')
			    params.base9 = params?.double('base9')
			    params.base10 = params?.double('base10')
			    params.base11 = params?.double('base11')
				params.enabled = true
				params.isAuthomatic = true
				params.hadpaid =true
				params.fixed = true

				customer = new Expenses(params)
				println customer as JSON
				if (! customer.hasErrors() && customer.save(flush:true)) {
					
					message = "Expenses Added"
					state = "OK"
				} else {
					message = "Could Not Save Expenses"
				}

				break;
			case 'del':
				// check Spam exists
					customer = Expenses.get(params.id)
					if (customer) {
						// delete Spam
						customer.delete()
						message = "Expenses  ${customer.id}  Deleted"
						state = "OK"
					}
					break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = Expenses.get(params.id)
				if (customer) {
					
				 	params.createdDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.createdDate)
				    params.base = params?.double('base')
				    params.base1  = params?.double('base1')
				    params.base2  = params?.double('base2')
				    params.base3 = params?.double('base3')
				    params.tax = params?.double('tax')
				    params.tax1 = params?.double('tax1')
				    params.tax2 = params?.double('tax2')
				    params.tax3 = params?.double('tax3')
				    params.base8 = params?.double('base8')
				    params.base9 = params?.double('base9')
				    params.base10 = params?.double('base10')
				    params.base11 = params?.double('base11')
					customer.properties = params
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Customer Updated"
						id = customer.id
						state = "OK"
					} else {
						message = "Could Not Update Customer"
					}
				}
				break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	}
	def jq_edit_billing = {
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			default:
			// default edit action
			// first retrieve the customer by its ID
				def billing = Billing.get(params.id)
				if (billing) {
					billing.billingDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.billingDate)
					billing.hadpaid = params.hadpaid.contains("off")?false:true
					billing.amount = params.double('amount')
					billing.comments = params.comments
					billing.recive = params.recive
					
					if (! billing.hasErrors() && billing.save(flush:true)) {
						message = "Billing  ${billing.user.companyName}  Updated"
						id = billing.id
						state = "OK"
					} else {
						message = "Could Not Update Customer"
					}
				}
				break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	}
	
}