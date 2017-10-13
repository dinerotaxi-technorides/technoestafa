package com.page
import java.util.List;

import com.api.PlaceService;

import ar.com.goliath.*
import ar.com.operation.Operation
import ar.com.operation.OperationPending;
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.OperationHistory
import grails.converters.JSON
import ar.com.favorites.Favorites
class MiPanelCompanyAccountController {
	def springSecurityService
	def placeService
	def miPanelCompanyService
	def employCompanyAccountService
	def index = {

		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[operationInstanceList:[],operationInstanceTotal:[]]
	}
	def calendar = {
	}
	def controlTrips = {
	}
	def data = {
		def principal = springSecurityService.principal
		def userInstance = CompanyAccount.findByUsername(principal.username)
		[usr:userInstance]
	}
	def saveModification={
		def principal = springSecurityService.principal
		def usr = CompanyAccount.findByUsername(principal.username)
		def userInstance=CompanyAccount.get(usr.id)
		if(userInstance) {
			if(params.version) {
				def version = params.version.toLong()
				if(userInstance.version > version) {
					render view:'data', model:[usr:userInstance]
					return
				}
			}
			userInstance.properties = params
			if(!userInstance.hasErrors() && userInstance.save(flush:true)) {
				flash.message = "Se han realizado los cambios con exito"

				redirect action:'data', id:userInstance.id
			}
			else {
				render view:'data', model:[usr:userInstance]
			}
		}
		else {
			flash.message = "No se encuentra el usuario"
			redirect action:'data'
		}
	}
	def employee = {
	}
	
	// return JSON list of customers
	def jq_operation_consulting_list = {
		def sortIndex = params.sidx ?: 'lastName'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def customers= employCompanyAccountService.searchingTrips(maxRows,rowOffset,sortIndex,sortOrder,userInstance)
		def totalRows = customers?.totalCount?:0
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def interme
		def jsonCells = customers.collect {
			[cell: [ it?.createdDate?new java.text.SimpleDateFormat("dd/MM hh:mm").format(it.createdDate):'',
					it.user.username,
					it.user.firstName+' '+it.user.lastName,
					it?.company?.companyName?it?.company?.companyName:'',
					it?.taxista?it?.taxista?.username.split('@')[0]:'',
					it?.favorites?.placeFrom?.street?it?.favorites?.placeFrom?.street+' '+it?.favorites?.placeFrom?.streetNumber:'',
					it?.amount?:'No asignado'
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	// return JSON list of customers
	def jq_customer_list = {
		def sortIndex = params.sidx ?: 'lastName'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def intermediario= CompanyAccount.findByUsername(principal.username)
		def customers=employCompanyAccountService.getAll( maxRows,rowOffset,sortIndex,sortOrder,intermediario)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [
					it.username.split("@")[0],
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.enabled
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_edit_customer = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				intermediario = CompanyAccount.findByUsername(principal.username)
				def uuuu=User.findByUsername(params.username+"@"+intermediario.email.split("@")[1])
				if(uuuu?.email){
					message = "usuario existente"
				}else if(intermediario?.rtaxi){
					message = "No se puede agregar un usuario desde aqui."
				
				
				}else{
					customer = new CompanyAccountEmployee()
					def employeeRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")
					def principal = springSecurityService.principal
					def userInstance = User.findByUsername(principal.username)
					customer.employee=intermediario
					customer.status=UStatus.DONE
					customer.createdDate=new Date()
					customer.validated=UStatus.DONE
					customer.username=params.username+"@"+intermediario.email.split("@")[1]
					customer.email=params.username+"@"+intermediario.email.split("@")[1]
					if(!params.password.equals("****")){
					}
						customer.password=params.password
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.phone=params.phone
					customer.agree=params.enabled
					customer.enabled = params.enabled
					customer.politics=params.enabled
					customer.typeEmploy=TypeEmployer.COMPANYEMPLOYEE
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Customer  Added"
						UserRole.create customer, employeeRole
						state = "OK"
					} else {
						message = "Could Not Save User22"
					}

				}
				break;

			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = CompanyAccountEmployee.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.firstName = params?.firstName
					customer.lastName = params?.lastName
					customer.phone = params?.phone
					customer.enabled = params.enabled.contains("off")?false:true
					customer.agree= params.enabled.contains("off")?false:true
					customer.politics=customer.agree
					if(!params.password.equals("****")){
						customer.password=params.password
					}
					customer.typeEmploy=TypeEmployer.COMPANYEMPLOYEE

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

		def response = [message:message,state:state,id:id]

		render response as JSON
	}
}
