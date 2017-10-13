
package com.api.technorides.corporate

import grails.converters.JSON
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.goliath.corporate.CorporateUser
import ar.com.goliath.corporate.CostCenter
import ar.com.goliath.corporate.billing.BillingEnterpriseHistory
import ar.com.goliath.corporate.billing.BillingPayments
import ar.com.goliath.corporate.billing.ItemDetailEnterprise
import ar.com.goliath.corporate.billing.LateFeeCharges
import ar.com.goliath.corporate.billing.LateFeeConfig
import ar.com.goliath.corporate.billing.TaxCharges
import ar.com.goliath.corporate.billing.TaxConfig
import ar.com.goliath.corporate.billing.TermCharges
import ar.com.goliath.corporate.billing.TermConfig
import ar.com.operation.Operation
class TechnoRidesInvoiceApiController extends TechnoRidesValidateCorporateApiController {
	def springSecurityService
	def technoRidesCorporateService
	def utilsApiService
	def addExcept(list) {
		list <<'get'
	}
	def get={
		render "asd"
	}
	static allowedMethods = [generate_invoice:'POST']
	def generate_invoice={
		try{

			def message = ""
			def state   = "FAIL"
	//		print request.JSON.invoice.toString()
			def costCenter = CostCenter.get(request.JSON.invoice.costCenterId)
			def billing = new BillingEnterpriseHistory()
			billing.costCenter = costCenter
			billing.invoiceId = request.JSON.invoice.number
			billing.subTotal = request.JSON.invoice.subTotal
			billing.adjustment = request.JSON.invoice.adjustment
			billing.total = request.JSON.invoice.total
			print request.JSON.invoice
			if(request.JSON.invoice.discount !=null){
				billing.total -=request.JSON.invoice.discount
				billing.discount =request.JSON.invoice.discount
				billing.discountPercentage =request.JSON.invoice.discountPercentage
			}else{
				billing.discount =0d
				billing.discountPercentage =0d
			
			}
			billing.customerNotes =request.JSON.invoice.comments
			billing.billingDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(request.JSON.invoice.billingDate)
			billing.dueDate     = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(request.JSON.invoice.billingDate)
			if (request.JSON.invoice.draft)
				billing.status = "DRAFT"
			def late_fee_charge = null
			if(request.JSON.invoice.lateFeeId){
				def lateFeeCfg = LateFeeConfig.get(request.JSON.invoice.lateFeeId)
				if (lateFeeCfg){
					late_fee_charge = new LateFeeCharges()
					late_fee_charge.properties = lateFeeCfg.properties
					late_fee_charge.config = lateFeeCfg
					late_fee_charge.save()
				}
				
				billing.lateFee =late_fee_charge
			}
			
			def term = null
			if(request.JSON.invoice.termId){
				def termCfg = TermConfig.get(request.JSON.invoice.termId)
				if (termCfg){
					term = new TermCharges()
					term.properties = termCfg.properties
					term.config = termCfg
					term.save()
				}
				billing.termCharges =term
				
			}
			
			for (operation in request.JSON.invoice.operations){
				def op = Operation.get(operation.opId)
				def tax = TaxConfig.get(operation.taxId)
				def tax_charge = null
				if (tax){
					tax_charge = new TaxCharges()
					tax_charge.properties = tax.properties
					tax_charge.config = tax
					tax_charge.save()
				}
				
				def item =new  ItemDetailEnterprise(operation)
				item.name = "IN-" + op.user.firstName + "-" + op.user.lastName 
				item.taxCharge = tax_charge
				item.operation = op
				if(!item.save()){
					item.errors.each(){
						print it
					}
				}
				billing.addToItems(item)
	//			print operation
			}
			for (emails in request.JSON.invoice.emailIds){
				def usr = User.get(emails)
				billing.addToEmailTo(usr)
				print emails
			}
		
			if(!billing.save()){
				billing.errors.each(){
					print it
				}
			}
			render(contentType:'text/json',encoding:"UTF-8") { status=100 }
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def delete_invoice = {
		def message = ""
		def state   = "FAIL"
		//		print request.JSON.invoice.toString()
		def billing = BillingEnterpriseHistory.get(params?.invoice_id)
		if(!billing){
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
			return;
		}
			
		if(billing.status != 'PENDING'){
			render(contentType:'text/json',encoding:"UTF-8") { status=12 }
			return;
		}
		if(billing.delete(flush:true)){
			
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
			return;
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=400 }
			return;
		}
		
	}
	def edit_invoice={
		try{
			
			def message = ""
			def state   = "FAIL"
	//		print request.JSON.invoice.toString()
			def billing = BillingEnterpriseHistory.get(request.JSON.invoice.invoiceId)
			billing.invoiceId = request.JSON.invoice.number
			billing.subTotal = request.JSON.invoice.subTotal
			billing.adjustment = request.JSON.invoice.adjustment
			print request.JSON.invoice.invoiceId
			print request.JSON.invoice.discount
			if(request.JSON.invoice.discount !=null){
				billing.total +=billing.discount
				billing.discount =request.JSON.invoice.discount
				billing.discountPercentage =request.JSON.invoice.discountPercentage
				billing.total -=billing.discount
			}else{
				billing.discount =0d
				billing.discountPercentage =0d
			
			}
			billing.total = request.JSON.invoice.total
			if(request.JSON.invoice?.status)
				billing.status = request.JSON.invoice.status
				
			for (payment in billing.payments) {
				billing.total -=payment.amount
				
			}
			billing.customerNotes =request.JSON.invoice.comments
			billing.billingDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(request.JSON.invoice.billingDate)
			billing.dueDate     = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(request.JSON.invoice.billingDate)
			if(request.JSON.invoice.lateFeeId){
				
				def lateFeeCfg = LateFeeConfig.get(request.JSON.invoice.lateFeeId)
				def late_fee_charge = null
				if (lateFeeCfg && !billing?.lateFee?.id){
					print "nuevo late_fee"
					late_fee_charge = new LateFeeCharges()
					late_fee_charge.properties = lateFeeCfg.properties
					late_fee_charge.config = lateFeeCfg
					late_fee_charge.save()
					billing.lateFee =late_fee_charge
				}else if(lateFeeCfg && billing?.lateFee?.id && billing?.lateFee?.id !=lateFeeCfg.id){
					print "cambiando el viejo late_fee"
					billing.lateFee.properties = lateFeeCfg.properties
					billing.lateFee.config = lateFeeCfg
					billing.lateFee.save()
				}else if(!lateFeeCfg){
					print "borrando el viejo late_fee"
					if(billing?.lateFee)
						billing.lateFee.delete()
						billing.lateFee = null
				}
			}
			if(request.JSON.invoice.termId){
				def termCfg = TermConfig.get(request.JSON.invoice.termId)
				def term = null
				if (termCfg && !billing?.termCharges?.id){
					print "nuevo term"
					term = new TermCharges()
					term.properties = termCfg.properties
					term.config = termCfg
					term.save()
					billing.termCharges =term
				}else if(termCfg && billing?.termCharges?.id && billing?.termCharges?.id !=termCfg.id){
					print "cambiando el viejo term"
					billing.termCharges.name = termCfg.properties
					billing.termCharges.config = termCfg
					billing.termCharges.save()
				}else if(!termCfg){
					print "borrando el viejo term"
					if(billing?.termCharges)
						billing.termCharges.delete()
						billing.termCharges = null
				}
				
			}
			def items = []
			billing.items.clear()
			print billing.items
			for (operation in request.JSON.invoice.operations){
				print operation
				def op = Operation.get(operation.opId)
				def tax = TaxConfig.get(operation.taxId)
				def tax_charge = null
				if (tax){
					tax_charge = new TaxCharges()
					tax_charge.properties = tax.properties
					tax_charge.config = tax
					tax_charge.save()
				}
				
				def item =new  ItemDetailEnterprise(operation)
				item.name = "IN-" + op.user.firstName + "-" + op.user.lastName
				item.taxCharge = tax_charge
				item.operation = op
				if(!item.save()){
					item.errors.each(){
						print it
					}
				}
				billing.addToItems(item)
	//			print operation
			}
			for (emails in request.JSON.invoice.emailIds){
				def usr = User.get(emails)
				billing.addToEmailTo(usr)
			}
		
			if(!billing.save()){
				billing.errors.each(){
					print it
				}
			}
			render(contentType:'text/json',encoding:"UTF-8") { status=100 }
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def record_payment_list = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def billingHistory = BillingEnterpriseHistory.get(params.billing_id)
			def jsonCells = billingHistory.payments.collect {
				[
					bankCharges:it.bankCharges,
					amount:it.amount,
					taxDeducted:it.taxDeducted,
					paymentDate:it.paymentDate,
					paymentMode:it.paymentMode,
					reference:it.reference,
					notes:it.notes,
					sendEmail:it.sendEmail,
					id: it.id]
			}
			def jsonData= [rows: jsonCells,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def record_payment = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			
			def customers=technoRidesCorporateService.editRecordPayment( params, rtaxi)
			render customers.toString()
			return
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def late_fee_config_list = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def customers = LateFeeConfig.createCriteria().list() {
				eq('rtaxi',rtaxi)
			}
			def jsonCells = customers.collect {
				[
					name:it.name,
					charge:it.charge,
					type:it.typeCharge,
					frequency:it.frequency,
					id: it.id]
			}
			def jsonData= [rows: jsonCells,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def cost_center_emails = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def costCenter = CostCenter.get(params?.cost_id)
			if(!costCenter || costCenter.rtaxi != rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") { status=11 }
				
			}else{
				def customers = CorporateUser.createCriteria().list() {
					eq('costCenter',costCenter)
					eq('admin',true)
				}
				def jsonCells = customers.collect {
					[id:it.id,email:it.username]
				}
				render jsonCells as JSON
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
		
	}
	def invoice_list = {
		try{
			
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def costCenter = CostCenter.get(params?.cost_id)
			if(!costCenter || costCenter.rtaxi != rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") { status=11 }
				
			}else{
				def sortIndex = params.sidx ?: 'id'
				def sortOrder  = params.sord ?: 'desc'
				def maxRows = params?.rows?Integer.valueOf(params.rows):10
				def currentPage =params?.page? Integer.valueOf(params.page):1
		
				def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		
				def customers = BillingEnterpriseHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
	//				if(  params.searchField.equals("name") && !params.searchString.isEmpty()){
	//					ilike("name", params.searchString+"%")
	//				}
					eq('costCenter',costCenter)
					// set the order and direction
					if(params?.filter){
						eq("status",params.filter)
					}
					if( params?.search && !params.search.isEmpty()){
						
						or{
							ilike("invoiceId", params.search+"%")
							ilike("customerNotes", params.search+"%")
							
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
					[cell: [
							it.billingDate,
							it.invoiceId,
							it.subTotal,
							it.total,
							it.status,
							utilsApiService.generateFormatedAddressToClient(it.dueDate,rtaxi)
						], id: it.id]
				}
				def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
				render jsonData as JSON
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
		
	}
	def get_invoice = {
		try{
			
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			if(!params?.billing_id){
				render(contentType:'text/json',encoding:"UTF-8") { status=401 }
				return
			}
			def billing = BillingEnterpriseHistory.get(params?.billing_id)
			if(!billing || billing.costCenter.rtaxi != rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") { status=402 }
				
			}else{
				
				def jsonData= [invoice: generateInvoiceToJson(billing),status:100]
				render jsonData as JSON
			}
		}catch (Exception e){
			log.error e.stackTrace
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
		
	}
	def generateInvoiceToJson(BillingEnterpriseHistory billing ){
		def jsonBuilder = new groovy.json.JsonBuilder()
		def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd")
		def payments_u = []
		def operations_u = []
		def emails_u = []
		def late_fee_id    = billing.lateFee?.config?.id?:null
		def late_fee_name  = billing.lateFee?.name?:null
		def term_id        = billing.termCharges?.config?.id?:null
		def term_name      = billing.termCharges?.name?:null
		for (item in billing.items){
			def tax = null 
			def tax_id = null 
			def tax_charge = null 
			if (item.taxCharge?.config){
				tax = item.taxCharge?.name?:""
				tax_charge = item.taxCharge.charge?:""
				tax_id = item.taxCharge.config.id?:""
			}
			def op_build = jsonBuilder{
				amount item.amount?:""
				discountType item.discountType?:""
				discount item.discount?:""
				firstName item.operation.user.firstName?:""
				lastName item.operation.user.lastName?:""
				opDate item.operation.createdDate?:""
				opId item.operation.id?:""
				quantity item.quantity?:""
				taxId tax_id
				taxValue tax
				taxCharge tax_charge
				userId item.operation.user.id?:""
			}
			operations_u.add(op_build)
		}
		for (payment in billing.payments){
			def op_build = jsonBuilder{
				bankCharges payment.bankCharges?:""
				amount payment.amount?:""
				taxDeducted payment.taxDeducted?:""
				paymentDate payment.paymentDate?:""
				paymentMode payment.paymentMode?:""
				reference payment.reference?:""
				notes payment.notes?:""
				sendEmail payment.sendEmail?:""
				id_paymnet payment.id?:""
			}
			payments_u.add(op_build)
		}
		
		for (user_d in billing.emailTo){
			
			def us_build = jsonBuilder{
				user_id user_d.id?:""
				email   user_d.email?:""
			}
			emails_u.add(us_build)
		}
		def operationBuilder = jsonBuilder{
			id billing.id?:""
			status    billing.status?:""
			comments  billing.customerNotes?:""
			companyName billing.costCenter.rtaxi.companyName?:""
			lateFeeId late_fee_id
			lateFeeName late_fee_name
			termId    term_id
			termName  term_name
			billingDate sdf.format(billing.billingDate)
			dueDate sdf.format(billing.billingDate)
			discount billing.discount?:0
			discountPercentage billing.discountPercentage?:0
			subTotal billing.subTotal
			adjustment billing.adjustment
			total billing.total
			number billing.invoiceId
			costCenterId billing.costCenter.id
			operations operations_u
			payments payments_u
			emailsTo emails_u
			
		}
		return operationBuilder

	}
	def late_fee_config_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			
			def customers=technoRidesCorporateService.editLateConfigFee( params, rtaxi)
			render customers.toString()
			return
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def tax_config_list = {
		try{
			
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def customers = TaxConfig.createCriteria().list() {
				eq('rtaxi',rtaxi)
			}
			def jsonCells = customers.collect {
				[
					name:it.name,
					charge:it.charge,
					isCompound:it.isCompound,
					id: it.id]
			}
			def jsonData= [rows: jsonCells,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	
	def tax_config_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			
			def customers=technoRidesCorporateService.editTaxConfig( params, rtaxi)
			render customers.toString()
			return
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	
	def term_config_list = {
		try{
			
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def customers = TermConfig.createCriteria().list() {
				eq('rtaxi',rtaxi)
			}
			def jsonCells = customers.collect {
				[
					name:it.name,
					days:it.days,
					id: it.id]
			}
			def jsonData= [rows: jsonCells,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	
	def term_config_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			print params
			def rtaxi=searchRtaxi(usr)
			
			def customers=technoRidesCorporateService.editTermsConfig( params, rtaxi)
			render customers.toString()
			return
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	
}

