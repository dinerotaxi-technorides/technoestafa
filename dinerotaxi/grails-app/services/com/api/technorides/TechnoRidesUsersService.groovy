package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.CompanyAccount
import ar.com.goliath.EmployUser
import ar.com.goliath.InvestorsContact
import ar.com.goliath.RealUser
import ar.com.goliath.Role
import ar.com.goliath.TypeEmployer
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.goliath.Vehicle
import ar.com.goliath.business.UserBusinessModel
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.Operation

class TechnoRidesUsersService {
	def springSecurityService
	def utilsApiService
	def getEmployUsersDriver( params,rtaxi) {

		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1
		println params
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def usersCriterea=User.createCriteria()
		def customers = EmployUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('employee', rtaxi)
			eq('visible',true)
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
			eq('typeEmploy',TypeEmployer.TAXISTA)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {

			def vere=Vehicle.findByTaxistas(it)
			[cell: [
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.typeEmploy.toString(),
					it.enabled,
					vere?.marca?:"",
					vere?.modelo?:"",
					vere?.patente?:"",
					it?.cuit?:"",
					it?.licenceNumber?:"",
					it?.licenceEndDate?new java.text.SimpleDateFormat("dd/MM/yyyy").format(it?.licenceEndDate):"",
					it.isCorporate, it.isVip, it.isRegular, it.isMessaging,
					 it.isPet, it.isAirConditioning, it.isSmoker,it.isSpecialAssistant,it.isLuggage,it.isAirport, it.isInvoice

				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	def getEmployUsers( params,rtaxi) {

		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1
		println params
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def usersCriterea=User.createCriteria()
		def customers = EmployUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('employee', rtaxi)
			eq('visible',true)
			eq('isTestUser',false)
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
			or{
				eq('typeEmploy',TypeEmployer.TELEFONISTA)
				eq('typeEmploy',TypeEmployer.OPERADOR)
				eq('typeEmploy',TypeEmployer.MONITOR)
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.typeEmploy.toString(),
					it.enabled
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	def getCompanies() {
		def customers = Company.createCriteria().list() { eq('enabled', true) }
		def jsonCells = customers.collect {
			[id: it.id,
				company_name:it.companyName,
				latitude:it.latitude,
				longitude:it.longitude
			]
		}
		def result = [rows:jsonCells,status:100]
		return result as JSON
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

		def customers =RealUser.createCriteria().list(max:5, offset:0) {
			and{
				eq('rtaxi',rtaxi)
				eq('enabled',true)
				eq('accountLocked',false)
				like('email',"${email}%")

			}
			cache true
		}
		def customers_corp =CorporateUser.createCriteria().list(max:5, offset:0) {
			and{
				eq('rtaxi',rtaxi)
				eq('enabled',true)
				eq('accountLocked',false)
				like('email',"${email}%")

			}
			cache true
		}
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
		def customers =RealUser.createCriteria().list(max:5, offset:0) {
			and{
				eq('rtaxi',rtaxi)
				eq('enabled',true)
				eq('accountLocked',false)
				like('phone',"${phone}%")

			}
			cache true
		}
		def customers_corp =CorporateUser.createCriteria().list(max:5, offset:0) {
			and{
				eq('rtaxi',rtaxi)
				eq('enabled',true)
				eq('accountLocked',false)
				like('phone',"${phone}%")
			}
			cache true
		}
		def jsonCells = customers.collect {
			[is_cc:false,phone: it?.phone,email:it?.email,first_name:it?.firstName,last_name:it?.lastName,user_id:it?.id,value:it?.phone+" - "+it?.firstName+" "+it?.lastName]
		}
		def jsonCells_cc = customers_corp.collect {
			[is_cc:true,phone: it?.phone,email:it?.email,first_name:it?.firstName,last_name:it?.lastName,user_id:it?.id,value:it?.phone+" - "+it?.firstName+" "+it?.lastName]
		}
		jsonCells.addAll(jsonCells_cc)

		return jsonCells
	}
	def getUserByLastName( lastName,rtaxi) {
		def customers =RealUser.createCriteria().list(max:5, offset:0) {
			and{
				eq('rtaxi',rtaxi)
				eq('enabled',true)
				eq('accountLocked',false)
				like('lastName',"${lastName}%")

			}
			cache true
		}
		def customers_corp =CorporateUser.createCriteria().list(max:5, offset:0) {
			and{
				eq('rtaxi',rtaxi)
				eq('enabled',true)
				eq('accountLocked',false)
				like('lastName',"${lastName}%")
			}
			cache true
		}
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
	def editVehiclesByCompany( params,rtaxi){
		def customer = null
		def message = ""
		def state = "FAIL"
		def id
		// determine our action
		switch (params.oper) {
			case 'add':
				customer = new Vehicle()
				customer.patente=params?.patente
				customer.createdDate=new Date()
				customer.marca = params?.marca
				customer.modelo = params?.modelo
				customer.active= params.active.contains("off")?false:true
				customer.company=rtaxi
				if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "Vehicle  ${customer.patente} ${customer.marca} Agregado"
					id = customer.id
					state = "OK"
				} else {
					message = "Could Not Save User"
					customer.errors.each{ print it }
				}
				break;
			default:
				customer = Vehicle.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.patente = params?.patente
					customer.marca = params?.marca
					customer.modelo = params?.modelo
					customer.active = params.active.contains("off")?false:true
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Vehicle  ${customer.patente} ${customer.marca} Editado"
						id = customer.id
						state = "OK"
					} else {
						message = "Could Not Update Customer"
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,status:100,id:id]

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
					customer.agree= true
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
					customer.agree= true
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
				print params.empresa
				print params.username
				def uuuu=User.findByUsernameAndRtaxi(params.username+"@"+intermediario.email.split("@")[1],rtaxi)
				print uuuu
				if(uuuu?.email){
					message = "usuario existente"
				}else{
					customer = new CorporateUser()
					def employeeRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")
					customer.employee=intermediario
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
					customer.agree=true
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
					if(params?.password)
						customer.password=params?.password
					customer.accountLocked =params.agree.contains("on")?false:true
					customer.enabled = !customer.accountLocked
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
		def status = 100
		def id = null
		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findByUsernameAndRtaxi(params?.username+"@"+rtaxi.email.split("@")[1],rtaxi)
				def vehicle=null
				def employUser = EmployUser.get(user?.id)
				if(employUser?.username && employUser?.visible){
					message = "company.exist"
					code    = 400
					status  = 400
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
					customer.isProfileEditable=true
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
					customer.isMessaging=true
					customer.isPet = true;
					customer.isAirConditioning = true;
					customer.isSmoker = true;
					customer.isSpecialAssistant = true;
					customer.isLuggage = true;
					customer.isAirport = true;
					customer.isVip = true;
					customer.isInvoice = true;

					if(params?.isCorporate){
						customer.isCorporate =params.isCorporate.contains("false")?false:true
					}
					if(params?.isRegular){
						customer.isRegular =params.isRegular.contains("false")?false:true
					}
					if(params?.isMessaging){
						customer.isMessaging =params.isMessaging.contains("false")?false:true
					}
					if(params?.isPet){
						customer.isPet =params.isPet.contains("false")?false:true
					}
					if(params?.isAirConditioning){
						customer.isAirConditioning =params.isAirConditioning.contains("false")?false:true
					}
					if(params?.isSmoker){
						customer.isSmoker =params.isSmoker.contains("false")?false:true
					}
					if(params?.isSpecialAssistant){
						customer.isSpecialAssistant =params.isSpecialAssistant.contains("false")?false:true
					}
					if(params?.isLuggage){
						customer.isLuggage =params.isLuggage.contains("false")?false:true
					}
					if(params?.isAirport){
						customer.isAirport =params.isAirport.contains("false")?false:true
					}
					if(params?.isVip){
						customer.isVip =params.isVip.contains("false")?false:true
					}
					if(params?.isInvoice){
						customer.isInvoice =params.isInvoice.contains("false")?false:true
					}
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
							status  = 400
							message = "vehicle.cant-add"
						}else{
							vehicle.addToTaxistas(customer)
							message = "customer.added"
							state = "OK"
						}
						if (!customer.authorities.contains(companyRole)) {
							UserRole.create customer, companyRole
						}
						if(!params.businessModel){
							params.businessModel = rtaxi.businessModel[0]
						}

						utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
					} else {
						customer.errors.each{ println it }
						message = "error.not.save"
					}
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				print params as JSON
				customer = EmployUser.get(params.id)
				def vere=Vehicle.findByTaxistas(customer)
				if(!customer){
					message = "driver.not.exist"
					code=400
					status  = 404
				}else if (customer) {
					// set the properties according to passed in parameters
					customer.companyName = params?.companyName
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.cuit=params?.cuit?:''
					customer.licenceNumber=params?.licenceNumber?:''
					if(params?.licenceEndDate){
						try{
							Date D_licence =  new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params?.licenceEndDate)
							customer.licenceEndDate =D_licence
						}catch (Exception e) {
							print e.stackTrace
						}
					}
					if(params?.password){
						customer.password=params?.password
					}
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					if(params?.isCorporate){
						customer.isCorporate =params.isCorporate.contains("false")?false:true
					}
					if(params?.isRegular){
						customer.isRegular =params.isRegular.contains("false")?false:true
					}
					if(params?.isMessaging){
						customer.isMessaging =params.isMessaging.contains("false")?false:true
					}
					if(params?.isPet){
						customer.isPet =params.isPet.contains("false")?false:true
					}
					if(params?.isAirConditioning){
						customer.isAirConditioning =params.isAirConditioning.contains("false")?false:true
					}
					if(params?.isSmoker){
						customer.isSmoker =params.isSmoker.contains("false")?false:true
					}
					if(params?.isSpecialAssistant){
						customer.isSpecialAssistant =params.isSpecialAssistant.contains("false")?false:true
					}
					if(params?.isLuggage){
						customer.isLuggage =params.isLuggage.contains("false")?false:true
					}
					if(params?.isAirport){
						customer.isAirport =params.isAirport.contains("false")?false:true
					}
					if(params?.isVip){
						customer.isVip =params.isVip.contains("false")?false:true
					}
					if(params?.isInvoice){
						customer.isInvoice =params.isInvoice.contains("false")?false:true
					}

					if(params?.enabled){
						customer.enabled =params.enabled.contains("false")?false:true
						customer.accountLocked =params.enabled.contains("false")?true:false
					}
					if(params?.is_profile_editable)
						customer.isProfileEditable =params.is_profile_editable.contains("false")?false:true
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
					if (!customer.hasErrors() && customer.save(flush:true)) {
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

		def jsonData = [message:message,state:state,id:id,code:code,status:status]

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
		def code=100
		// determine our action
		println params
		switch (params.oper) {
			case 'add':
			// add instruction sent
				def user =User.findByUsernameAndRtaxi(params?.username+"@"+rtaxi.email.split("@")[1],rtaxi)

				def employUser = EmployUser.get(user?.id)
				if(employUser?.username && employUser?.visible){
					message = "employee.exist"
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
					customer.agree= true
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
						code=401
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
					customer.username=params?.username+"@"+rtaxi.email.split("@")[1]
					customer.firstName=params.firstName
					customer.lastName=params.lastName
					customer.email=params?.username+"@"+rtaxi.email.split("@")[1]
					customer.latitude=rtaxi.latitude
					customer.longitude=rtaxi.longitude
					customer.agree = params.agree.contains("false")?false:true
					customer.enabled = params.agree.contains("false")?false:true
					if(params?.password){
						customer.password=params?.password
					}
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
						customer.errors.each{
							print it
						}
						message = "customer.error.not.updated"
					}
				}
				break;
		}

		def jsonData = [message:message,state:state,status:code,id:id]

		return jsonData as JSON
	}


}
