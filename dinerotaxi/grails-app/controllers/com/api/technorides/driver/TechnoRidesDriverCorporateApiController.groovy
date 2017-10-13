
package com.api.technorides.driver

import grails.converters.JSON
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.goliath.driver.charges.BillingDriverPayment
import ar.com.goliath.driver.charges.ChargesDriverHistory
import ar.com.goliath.driver.charges.CorporateItemDetailDriver

import com.api.technorides.corporate.TechnoRidesValidateCorporateApiController
class TechnoRidesDriverCorporateApiController extends TechnoRidesValidateCorporateApiController {
	def springSecurityService
	def technoRidesDriverInvoiceService
	def utilsApiService
	def addExcept(list) {
		list <<'get'
	}
	def get={ render "asd" }
	static allowedMethods = [generate_invoice:'POST']
	//operations=[]
	def pay_receipts_partialy = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def driver = EmployUser.get(params?.driver_id)
		if(!usr || !driver || driver.rtaxi != rtaxi){
			render(contentType:'text/json',encoding:"UTF-8") { status=411 }
			return
		}
		try {
			def opers = params.operations.split(',').collect{
				Long.valueOf(it)
			}
			print opers
			def customers = CorporateItemDetailDriver.createCriteria().list() {
				eq('driver',driver)
				// set the order and direction
				'in'("id",opers)
			}
			customers.each { 
				print it
				it.total = 0
				it.status = 'PAID'
				it.save()
			}
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=400 }
		}
		
	}
	//invoices=[]
	def charge_invoices_partialy = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def driver = EmployUser.get(params?.driver_id)
		if(!usr || !driver || driver.rtaxi != rtaxi){
			render(contentType:'text/json',encoding:"UTF-8") { status=411 }
			return
		}
		try {
			def opers = params.invoices.split(',').collect{
				Long.valueOf(it)
			}
			print opers
			def customers = ChargesDriverHistory.createCriteria().list() {
				eq('driver',driver)
				gt('total',0d)
				// set the order and direction
				'in'("id",opers)
			}
			customers.each { 
				print it
				def billingPayment = new BillingDriverPayment()
				billingPayment.amount = it.total
				billingPayment.paymentDate =  new Date()
				billingPayment.paymentMode = 1
				billingPayment.sendEmail   = false
				billingPayment.save()
				
				it.total = 0
				it.status = 'PAID'
				it.addToPayments(billingPayment)
				it.save()
			}
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=400 }
		}
		render(contentType:'text/json',encoding:"UTF-8") { status=200 }
	}
	//la empresa cobra por el servicio de radiotaxi
	def charge_invoices = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def stat = technoRidesDriverInvoiceService.chargeInvoices(params?.driver_id, usr, rtaxi)
		render(contentType:'text/json',encoding:"UTF-8") { status=stat }
		
	}
	//La empresa paga por las cc
	def pay_receipts = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def stat = technoRidesDriverInvoiceService.payRecipents(params?.driver_id, usr, rtaxi)
		render(contentType:'text/json',encoding:"UTF-8") { status=stat }
		
	}
	def balance_account = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def stat = technoRidesDriverInvoiceService.chargeInvoices(params?.driver_id, usr, rtaxi)
		
		stat = technoRidesDriverInvoiceService.payRecipents(params?.driver_id, usr, rtaxi)
		render(contentType:'text/json',encoding:"UTF-8") { status=stat }
	}
	def dashboard = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def driver = EmployUser.get(params?.driver_id)
		if(!usr || !driver || driver.rtaxi != rtaxi){
			render(contentType:'text/json',encoding:"UTF-8") { status=411 }
			return
		}
		
		def owned = CorporateItemDetailDriver.findAllByDriverAndStatusNotEqual(driver,'PAID')
		def owns  = ChargesDriverHistory.findAllByDriverAndStatusNotEqual(driver,'PAID')
		def total_owned = owned?owned.total.sum():0d
		def total_owns  = owns?owns.total.sum():0d
		render(contentType:'text/json',encoding:"UTF-8") { 
			status=200
			totalOwns=total_owns.toInteger()
			totalOwned=total_owned.toInteger()
		}
	}
	def show_invoice = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def driver = EmployUser.get(params?.driver_id)
		if(!usr || !driver || driver.rtaxi != rtaxi){
			render(contentType:'text/json',encoding:"UTF-8") { status=411 }
			return
		}
		render(contentType:'text/json',encoding:"UTF-8") { status=200 }
	}
	def invoice_history_list = {
		print params
		try{
	
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def driver = EmployUser.get(params?.driver_id)
			if(!usr || !driver || driver.rtaxi != rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") { status=411 }
				return
			}
			def sortIndex = params.sidx ?: 'id'
			def sortOrder  = params.sord ?: 'desc'
			def maxRows = params?.rows?Integer.valueOf(params.rows):10
			def currentPage =params?.page? Integer.valueOf(params.page):1
	
			def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
			
			def customers = ChargesDriverHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq('driver',driver)
				eq('status','PAID')
				
				// set the order and direction
				for (sortI in sortIndex.split (",")) {
					order(sortI, sortOrder)
	
				}
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				[cell: [
						it.subTotal,
						it.invoiceId,
						rtaxi?.wlconfig?.driverPayment,
						it.customerNotes,
						utilsApiService.generateFormatedAddressToClient(it.chargesDate,rtaxi)
					], id: it.id]
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def invoice_list = {
		print params
		try{
	
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def driver = EmployUser.get(params?.driver_id)
			if(!usr || !driver || driver.rtaxi != rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") { status=411 }
				return
			}
			def sortIndex = params.sidx ?: 'id'
			def sortOrder  = params.sord ?: 'desc'
			def maxRows = params?.rows?Integer.valueOf(params.rows):10
			def currentPage =params?.page? Integer.valueOf(params.page):1
	
			def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
			
			def customers = ChargesDriverHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq('driver',driver)
				ne('status','PAID')
				
				// set the order and direction
				for (sortI in sortIndex.split (",")) {
					order(sortI, sortOrder)
	
				}
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				[cell: [
						it.total,
						it.invoiceId,
						rtaxi?.wlconfig?.driverPayment,
						it.customerNotes,
						utilsApiService.generateFormatedAddressToClient(it.chargesDate,rtaxi)
					], id: it.id]
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def receive_list = {
		try{

			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def driver = EmployUser.get(params?.driver_id)
			if(!usr || !driver || driver.rtaxi != rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") { status=411 }
				return
			}
			def sortIndex = params.sidx ?: 'id'
			def sortOrder  = params.sord ?: 'desc'
			def maxRows = params?.rows?Integer.valueOf(params.rows):10
			def currentPage =params?.page? Integer.valueOf(params.page):1

			def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
			print params
			def customers = CorporateItemDetailDriver.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq('driver',driver)
				// set the order and direction
				or{
					eq("status",'PENDING')
					eq("status",'OVERDUE')
				}
				// set the order and direction
				for (sortI in sortIndex.split (",")) {
					order(sortI, sortOrder)

				}
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				[cell: [
						it.operation.costCenter?.name?:"",
						it.operation.costCenter?.phone?:"",
						it.operation.costCenter?.corporate?.name?:"",
						it.total,
						it.operation.stars,
						it.status.toString(),
						it.operation.dev.toString(),
						utilsApiService.generateFormatedAddressToClient(it.createdDate,rtaxi),
						it?.operation?.favorites?.placeFrom?.street,
						it?.operation?.favorites?.placeTo?.street?:''
					], id: it.id]
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}

	def receive_history_list = {
		try{

			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def driver = EmployUser.get(params?.driver_id)
			if(!usr || !driver || driver.rtaxi != rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") { status=411 }
				return
			}
			def sortIndex = params.sidx ?: 'id'
			def sortOrder  = params.sord ?: 'desc'
			def maxRows = params?.rows?Integer.valueOf(params.rows):10
			def currentPage =params?.page? Integer.valueOf(params.page):1

			def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
			print params
			def customers = CorporateItemDetailDriver.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq('driver',driver)
				// set the order and direction
				eq("status",'PAID')
				
				// set the order and direction
				for (sortI in sortIndex.split (",")) {
					order(sortI, sortOrder)

				}
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				[cell: [
						it.operation.costCenter?.name?:"",
						it.operation.costCenter?.phone?:"",
						it.operation.costCenter?.corporate?.name?:"",
						it.subTotal,
						it.operation.stars,
						it.status.toString(),
						it.operation.dev.toString(),
						utilsApiService.generateFormatedAddressToClient(it.createdDate,rtaxi),
						it?.operation?.favorites?.placeFrom?.street,
						it?.operation?.favorites?.placeTo?.street?:''
					], id: it.id]
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
}

