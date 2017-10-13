package com.page
import grails.converters.JSON
import ar.com.goliath.*
import ar.com.operation.OFStatus
import ar.com.operation.OnlineRadioTaxi
import ar.com.operation.TRANSACTIONSTATUS
class RadioTaxiCompanyAccountController {
	def springSecurityService
	def placeService
	def radioTaxiUserService

	static allowedMethods = [getPendingTrips:'GET',edit:'POST']

	/**
	 * Get All CC for company CC
	 */
	def jq_online_company_account_list = {
		def sortIndex = params.sidx ?: 'countTrips'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def principal = springSecurityService.currentUser

		def customers=radioTaxiUserService.getAllCompanyAccount( maxRows,rowOffset,sortIndex,sortOrder,principal)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {

			[cell: [it.username,
					"****",
					it.phone,
					it.companyName,
					it.cuit,
					it.agree,
					it.accountLocked
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}

	/**
	 * Get All user for company CC
	 */
	def jq_online_company_account_user_list = {
		def sortIndex = params.sidx ?: 'lastName'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def principal = springSecurityService.currentUser

		def customers=radioTaxiUserService.getAllCompanyAccountEmployee( maxRows,rowOffset,sortIndex,sortOrder,principal)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [it.employee.companyName,
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.countTripsCompleted,
					it.agree,
					it.accountLocked
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_online_user_company_list = {
		def sortIndex = params.sidx ?: 'lastName'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def principal = springSecurityService.currentUser

		def customers=radioTaxiUserService.getAllRealUserCompany( maxRows,rowOffset,sortIndex,sortOrder,principal)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.countTripsCompleted,
					it.agree,
					it.accountLocked
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}

	/**
	 * Edit Company Account CC
	 */
	def jq_edit_company_account_user = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		def principal = springSecurityService.currentUser
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
			// add instruction sent
			intermediario = CompanyAccount.get(params.empresa)
			def uuuu=User.findByUsername(params.username+"@"+intermediario.email.split("@")[1])
			if(uuuu?.email){
				message = "usuario existente"
			}else{
				customer = new CompanyAccountEmployee()
				def employeeRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")
				def userInstance = User.findByUsername(principal.username)
				customer.employee=intermediario
				customer.status=UStatus.DONE
				customer.createdDate=new Date()
				customer.validated=UStatus.DONE
				customer.rtaxi=userInstance
				customer.username=params.username+"@"+intermediario.email.split("@")[1]
				customer.email=params.username+"@"+intermediario.email.split("@")[1]
				customer.password=params.password
				customer.firstName=params.firstName
				customer.lastName=params.lastName
				customer.phone=params.phone
				customer.agree=params.agree
				customer.enabled = params.agree
				customer.politics=params.agree
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
					customer.password=params.password
					customer.enabled =params.agree
					customer.agree= params.agree
					customer.accountLocked= params.accountLocked
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

		def response = [message:message,state:state,id:id]

		render response as JSON
	}


	def jq_edit_company_account = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		def principal = springSecurityService.currentUser
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findAllByUsername(params?.username)
				if(user?.username){
					message = "La compania ya existe!"
				}else{
					customer = new CompanyAccount()
					def companyRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT")
					customer.companyName = params?.companyName
					customer.cuit = params?.cuit
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.password=params?.password
					customer.enabled = params.agree.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.accountLocked= params.accountLocked.contains("off")?false:true
					customer.politics=customer.agree
					customer.rtaxi=principal
					if (! customer.hasErrors() && customer.save(flush:true)) {
						if (!customer.authorities.contains(companyRole)) {
							UserRole.create customer, companyRole
						}
						message = "Customer  ${customer.username} Added"
						state = "OK"
					} else {
						message = "Could Not Save User"
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
					customer.enabled =params.agree.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.accountLocked= params.accountLocked.contains("off")?false:true
					customer.politics=customer.agree
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Usuario  ${customer.username}  Modificado exitosamente"
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

	def jq_get_company_account={
		def principal = springSecurityService.currentUser
		def customers=radioTaxiUserService.getAllCompanyAccount(principal)
		StringBuffer buf = new StringBuffer("<select id='companyAccount' name='companyAccount'>")
		buf.append("<option value=''></option>")
		def l=customers.each{

			buf.append("<option value='${it.id}'").append(it.companyName).append('>')
			 buf.append(it.companyName)
			 buf.append("</option>")
		}
		 buf.append("</select>")

		 render buf.toString()
	}
}
