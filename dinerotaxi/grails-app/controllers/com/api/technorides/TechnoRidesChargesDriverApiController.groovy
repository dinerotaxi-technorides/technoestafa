package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.operation.ChargesDriver
class TechnoRidesChargesDriverApiController extends TechnoRidesValidateApiController {
	def technoRidesOperationService
	def utilsApiService
	def operationApiService
	def sendGridService
	def technoRidesEmailService
	def springDineroTaxiService
	def springSecurityService
	def rememberMeServices

	def addExcept(list) {
		list <<'get'//'index' << 'list' << 'show'
	}
	def get={
		render "asd"
	}
	def jq_charges = {
		println "jq_charges"
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def driver= EmployUser.get(params?.driver_id)
			if(!driver || driver.rtaxi!=rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") {
					status=411
				}
				return
			}
			def sortIndex = params.sidx ?: 'id'
			def sortOrder  = params.sord ?: 'desc'
			def maxRows = params?.rows?Integer.valueOf(params.rows):10
			def currentPage =params?.page? Integer.valueOf(params.page):1
			def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
			def customers = ChargesDriver.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq('user', driver)
				if(  params.searchField.equals("description") && !params.searchString.isEmpty()){
					ilike("description", params.searchString+"%")
				}
				
				if(  params.searchField.equals("driverPayment") && !params.searchString.isEmpty()){
					ilike("driverPayment", params.searchString+"%")
				}
				
				// set the order and direction
				order(sortIndex, sortOrder)
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				[cell: [
						it.description,
						it.amount,
						it.driverPayment,
						it?.expirationDate? new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.expirationDate):""
					], id: it.id]
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
			render jsonData as JSON
			return
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") {
				status=11
			}
		}
	}
	def jq_edit_charges  = {
		def charges = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		def driver= EmployUser.get(params?.driver_id)
		if(!driver || driver.rtaxi!=rtaxi){
			render(contentType:'text/json',encoding:"UTF-8") {
				status=411
			}
			return
		}
		
		if(params?.expirationDate){
			def expirationDate =new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.expirationDate)
			if (expirationDate<new Date()){
				render(contentType:'text/json',encoding:"UTF-8") {
					status=420
					message="Error: Expiration Date must be in the future. "
					state=state
				}
				return
			}
		}
		// determine our action
		switch (params.oper) {
			case 'add':
				params.amount = params?.double('amount')
				if(params?.expirationDate){
					params.expirationDate=new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.expirationDate)
				}
				charges = new ChargesDriver(params)
				charges.user = driver
				if (! charges.hasErrors() && charges.save(flush:true)) {
	
					message = "ChargesDriver Added"
					state = "OK"
					id=charges.id
				} else {
					message = "Could Not Save ChargesDriver"
				}
	
				break;
			case 'del':
				// check Spam exists
				charges = ChargesDriver.get(params.id)
				if (charges && charges.user == driver) {
					// delete Spam
					charges.enabled=false
					charges.save()
					message = "ChargesDriver  ${charges.id}  Deleted"
					state = "OK"
				}
				break;
			default:
				// default edit action
				// first retrieve the charges by its ID
				charges = ChargesDriver.get(params.id)
	
				
				params.amount = params?.double('amount')
				if(params?.expirationDate){
					params.expirationDate=new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.expirationDate)
				}
				charges.properties = params
				charges.user = driver
				if (! charges.hasErrors() && charges.save(flush:true)) {
					message = "charges Updated"
					id = charges.id
					state = "OK"
				} else {
					message = "Could Not Update  "
				}
				break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	}

}

