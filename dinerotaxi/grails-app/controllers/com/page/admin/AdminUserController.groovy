package com.page.admin
import grails.converters.JSON
import uk.co.desirableobjects.sendgrid.SendGridEmail
import uk.co.desirableobjects.sendgrid.SendGridEmailBuilder
import ar.com.goliath.*
import ar.com.goliath.corporate.CorporateUser
import ar.com.notification.ConfigurationApp
import ar.com.operation.OFStatus
import ar.com.operation.OnlineRadioTaxi
import ar.com.operation.Parking
class AdminUserController {
	def springSecurityService
	def placeService
	def adminUserService
	def sendGridService
	static allowedMethods = [getPendingTrips:'GET',edit:'POST']

	def index = {
	}
	def companyAccount = {
	}
	def usuarios = {
	}
	def online = {
	}
	// return JSON list of customers
	def jq_customer_list = {
		def sortIndex = params.sidx ?: 'lastName'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows


		def customers=adminUserService.getAll( maxRows,rowOffset,sortIndex,sortOrder,params)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.typeEmploy.name().toString(),
					it.agree,
					it.enabled,
					it.accountLocked,
					it.isTestUser,
					it?.city?it?.city?.name:''
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_online_company_account_user_list = {
		def sortIndex = params.sidx ?: 'lastName'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows


		def customers=adminUserService.getAllCompanyAccountEmployee( maxRows,rowOffset,sortIndex,sortOrder)

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
					it.typeEmploy.name().toString(),
					it.agree,
					it.enabled,
					it.accountLocked,
					it.isTestUser,
					it.ip,
					it?.rtaxi?it?.rtaxi?.companyName:''
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	// return JSON list of empresas
	def jq_customer_company_list = {
		def sortIndex = params.sidx ?: 'lastName'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		
		def customers=adminUserService.getAllCompanyUser( maxRows,rowOffset,sortIndex,sortOrder,params)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			def counter=EmployUser.countByEmployee(it)
			[cell: [it?.createdDate?new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.createdDate):'', 
					it?.username,
					"****",
					it?.phone,
					it?.companyName,
					it?.lang,
					it?.mailContacto,
					counter,
					it?.wlconfig?.intervalPoolingTrip?:20,
					it?.wlconfig?.intervalPoolingTripInTransaction?:20,
					it?.latitude,
					it?.longitude,
					it?.cuit,
					it?.price,
					it?.agree,
					it?.enabled,
					it?.accountLocked,
					it?.isTestUser,
					it?.city?.name?:'',
					it?.wlconfig?.app?:''
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	// return JSON list of empresas
	def jq_online_company_list = {
		def sortIndex = params.sidx ?: 'countTrips'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows


		def customers=adminUserService.getAllOnlineCompanyUser( maxRows,rowOffset,sortIndex,sortOrder)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {

			[cell: [
					it.id,
					it.company.companyName,
					it.company.phone,
					it.status.toString(),
					it.isTestUser,
					it.company.appVersion.toString(),
					it.countTaxi,
					it.countTrips,
					it.tripFail,
					it.countRejectTrip,
					it.countTimeOut
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_online_company_account_list = {
		def sortIndex = params.sidx ?: 'countTrips'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows


		def customers=adminUserService.getAllCompanyAccount( maxRows,rowOffset,sortIndex,sortOrder)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {

			[cell: [
					it.username,
					"****",
					it.phone,
					it.companyName,
					it.cuit,
					it.agree,
					it.enabled,
					it.accountLocked,
					it.isTestUser,
					it.ip,
					it?.city?it?.city?.name:'',
					it?.rtaxi?it?.rtaxi?.companyName:''
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
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
	def jq_get_wlconfig={

		StringBuffer buf = new StringBuffer("<select id='user.wlconfig' name='user.wlconfig'>")

		buf.append("<option value=''").append("").append('>')
		buf.append("none")
		buf.append("</option>")
		def l=ConfigurationApp.list().collect{

			buf.append("<option value='${it.id}'").append(it.app).append('>')
			buf.append(it.app)
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_city={

		StringBuffer buf = new StringBuffer("<select id='user.city' name='user.city'>")

		def l=EnabledCities.findAllByEnabled(true).collect{

			buf.append("<option value='${it.id}'").append(it.name).append('>')
			buf.append(it.name)
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_status={

		StringBuffer buf = new StringBuffer("<select id='user.status' name='user.status'>")

		def l=UStatus.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_radiotaxi_status={

		StringBuffer buf = new StringBuffer("<select id='status' name='status'>")

		def l=OFStatus.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_company_radiotaxi_status={

		StringBuffer buf = new StringBuffer("<select id='status' name='status'>")

		def l=OnlineRadioTaxi.list().collect{

			buf.append("<option value='${it.id}'").append(it.company.companyName).append('>')
			buf.append(it.company.companyName)
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_company_box={

		StringBuffer buf = new StringBuffer("<select id='user' name='user'>")

		def l=Company.findAllByEnabled(true).collect{

			buf.append("<option value='${it.id}'").append(it.companyName).append('>')
			buf.append(it.companyName)
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_edit_online_company_list = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			case 'add':


			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = OnlineRadioTaxi.get(Long.valueOf(params.id))
				if (customer) {
					// set the properties according to passed in parameters
					customer.status = params?.status
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Customer  ${customer.countTaxi} ${customer.status} Updated"
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
	def jq_edit_customer = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id=null

		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				customer = new EmployUser(params)
				def companyRole=Role.findByAuthority("ROLE_COMPANY")
				def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
				def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
				def taxiRol1e=Role.findByAuthority("ROLE_TAXI_OWNER")
				def userInstance = springSecurityService.currentUser

				if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
					intermediario = EmployUser.findByUsername(principal.username)
					customer.employee=intermediario.employee
				}else if ( userInstance.authorities.contains(companyRole) ){
					intermediario = Company.findByUsername(principal.username)
					customer.employee=intermediario
				}
				customer.status=UStatus.DONE
				customer.username=customer.username+"@"+intermediario.email.split("@")[1]
				customer.email=customer.username
				customer.politics=customer.agree
				if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "Customer  ${customer.firstName} ${customer.lastName} Added"
					id = customer.id
					if(customer.typeEmploy==TypeEmployer.OPERADOR){
						UserRole.create customer, operadorRole
					}else if(customer.typeEmploy==TypeEmployer.CORDINADOR){
						UserRole.create customer, supervisorRole
					} else if(customer.typeEmploy==TypeEmployer.TELEFONISTA){
						UserRole.create customer, operadorRole
					} else if(customer.typeEmploy==TypeEmployer.TAXISTA){
						UserRole.create customer, taxiRol1e
					}
					state = "OK"
				} else {
					message = "Could Not Save User"
				}

				break;

			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = EmployUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					if(!params?.password.equals("****")){
						customer.password=params?.password
					}
					customer.firstName = params?.firstName
					customer.lastName = params?.lastName
					customer.phone = params?.phone
					customer.typeEmploy=params?.typeEmploy
					customer.username=params?.username
					customer.email=params?.username
					customer.enabled = params.enabled.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.accountLocked= params.accountLocked.contains("off")?false:true
					customer.isTestUser= params.isTestUser.contains("off")?false:true
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

		log.error "${response}"
		render response as JSON
	}
	def jq_edit_company_account_user = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = CorporateUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					if(!params?.password.equals("****")){
						customer.password=params?.password
					}
					customer.firstName = params?.firstName
					customer.lastName = params?.lastName
					customer.phone = params?.phone
					customer.enabled = params.enabled.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.accountLocked= params.accountLocked.contains("off")?false:true
					customer.isTestUser= params.isTestUser.contains("off")?false:true
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
	def jq_edit_real_user = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {

			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = RealUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					if(!params?.password.equals("****")){
						customer.password=params?.password
					}
					customer.firstName = params?.firstName
					customer.lastName = params?.lastName
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.status=params?.status
					customer.enabled = params.enabled.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.isFrequent= params.isFrequent.contains("off")?false:true
					customer.accountLocked= params.accountLocked.contains("off")?false:true
					customer.politics=customer.agree
					customer.lang=customer.lang
					customer.isTestUser= params.isTestUser.contains("off")?false:true
					def city =EnabledCities.get(params.city)
					customer.city=city
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
	def jq_real_user_list = {
		def sortIndex = params.sidx ?: 'lastName'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows


		def customers=adminUserService.getAllRealUser( maxRows,rowOffset,sortIndex,sortOrder)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [
					it.createdDate,
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.status.name().toString(),
					it.agree,
					it.enabled,
					it.accountLocked,
					it.isTestUser
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_real_user_serching_list = {

		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
		boolean hasDateBetween=org.apache.commons.lang.StringUtils.countMatches(params.filters,"createdDate")==2
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		java.text.SimpleDateFormat fm= new java.text.SimpleDateFormat("dd/MM/yyyy")
		def createdDateF
		def createdDateT
		def customers = RealUser.createCriteria().list(max:maxRows, offset:rowOffset) {

			if(params?.filters){
				def o = JSON.parse(params.filters);
				o.rules.each{
					if(it.op.equals("eq")){
						if(it.field.equals("createdDate") && !it.data.isEmpty()){
							def f=fm.parse(it.data)
							between(it.field,f,f+1)

						}
						if(it.field.equals("username") && !it.data.isEmpty()){
							def data=it.data
							ilike("username", data)
						}
					}else{
						if(hasDateBetween){
							if(	it.op.equals("lt") && it.field.equals("createdDate") && !it.data.isEmpty()){
								createdDateT=fm.parse(it.data)
							}else if(!it.op.equals("lt") && it.field.equals("createdDate") && !it.data.isEmpty()){
								createdDateF=fm.parse(it.data)
							}
						}
					}
				}
			}

			if(hasDateBetween){
				between("createdDate",createdDateF,createdDateT)
			}

			// set the order and direction
			order(sortIndex, sortOrder)
		}

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [
					it?.createdDate?new java.text.SimpleDateFormat("dd/MM HH:mm").format(it.createdDate):'',
					it?.rtaxi?true:false,
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.countTripsCompleted,
					it.isFrequent,
					it.status.name().toString(),
					it.agree,
					it.enabled,
					it.accountLocked,
					it.isTestUser,
					it.ip,
					it?.rtaxi?it?.rtaxi?.companyName:'',
					it?.lang?it?.lang:'',
					it?.city?it?.city?.name:''
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_investor_serching_list = {

		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def customers = adminUserService.getAllInvestor( maxRows,rowOffset,sortIndex,sortOrder,params)

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [
					it?.createdDate?new java.text.SimpleDateFormat("dd/MM HH:mm").format(it.createdDate):'',
					it.username,
					"****",
					it.firstName,
					it.lastName,
					it.phone,
					it.agree
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	
	def jq_edit_company_customer = {
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				params.latitude=params.float('latitude')
				params.longitude=params.float('longitude')
				params.email =params?.username
				params.enabled=params.enabled.contains("off")?false:true
				params.isTestUser=params.isTestUser.contains("off")?false:true
				params.accountLocked=params.accountLocked.contains("off")?false:true
				params.agree=params.agree.contains("off")?false:true
				
				params.createdDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.createdDate)
				customer = Company.findByUsername(params?.username) ?: new Company(params)
				customer.politics=true
				def city =EnabledCities.get(params.city)
				if(customer.city!=city){
					customer.city=city
				}
				
				def wlconfig =ConfigurationApp.get(params.wlconfig)
				
				if(wlconfig){
					customer.wlconfig=wlconfig
				}else{
					def wlConfigdefault=ConfigurationApp.first()
					def wlConfignew = new ConfigurationApp(app:params?.companyName.toString(),mailSecret:wlConfigdefault.mailSecret ,
					mailFrom:wlConfigdefault.mailFrom ,	androidAccountType:wlConfigdefault.androidAccountType ,	androidEmail:wlConfigdefault.androidEmail ,
					androidPass:wlConfigdefault.androidPass ,		androidToken:wlConfigdefault.androidToken ,
					appleIp:wlConfigdefault.appleIp , applePort:wlConfigdefault.applePort , appleCertificatePath:wlConfigdefault.appleCertificatePath ,
					applePassword:wlConfigdefault.applePassword  ,isEnable:true,mailkey: wlConfigdefault.mailkey )
					wlConfignew.save()
					wlConfignew.errors.each{ println it }
					
					customer.wlconfig=wlConfignew
						
				}
				
				def companyRole=Role.findByAuthority("ROLE_COMPANY")
				if (! customer.hasErrors() && customer.save()) {
					if (!customer.authorities.contains(companyRole)) {
						UserRole.create customer, companyRole
					}
					
					def emailHtml=EmailBuilder.findByNameAndIsEnabled("email.company.new",true)
					
					
					def newBody=emailHtml.body
					def newSubject=emailHtml.subject
					
					newBody=newBody.replaceAll("#EMAIL#",  customer.username)
					newBody=newBody.replaceAll("#PASS#",  params?.password)
					newBody=newBody.replaceAll("#COMPANYNAME#",  customer.companyName)
					SendGridEmail email = new SendGridEmailBuilder()
					.from("no-replay@technorides.com")
					.to(customer.mailContacto.toString())
					.subject(newSubject.toString()).withHtml(newBody.toString()).build()
					sendGridService.send(email)
					
					message = "Customer  ${customer.username} Added"
					state = "OK"
				} else {
					customer.errors.each{
						println it
					}
					message = "Could Not Save User"
				}

				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = Company.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					def lat=params.float('latitude')
					def lng=params.float('longitude')
					customer.createdDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.createdDate)
					customer.latitude= lat
					customer.longitude=lng
					customer.companyName = params?.companyName
					customer.cuit = params?.cuit
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.price=params?.price
					customer.mailContacto=params?.mailContacto
					if(!params?.password.equals("****")){
						customer.password=params?.password
					}
					customer.enabled = params.enabled.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.accountLocked= params.accountLocked.contains("off")?false:true
					customer.politics=customer.agree
					customer.isTestUser= params.isTestUser.contains("off")?false:true
					customer.lang = params?.lang
					def city =EnabledCities.get(params.city)
					if(customer.city!=city){
						customer.city=city
						def employeees=EmployUser.findAllByEmployee(customer)
						employeees.each{
							it.city=city
							it.save(flush:true)
						}
					}

					def wlconfig =ConfigurationApp.get(params.wlconfig)
					if(wlconfig){
						customer.wlconfig=wlconfig
					}else{
						customer.wlconfig=null
					}



					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Customer  ${customer.username}  Updated"
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
	def jq_edit_investor={
		def customer = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				customer = InvestorUser.findByUsername(params?.username) ?: new InvestorUser(	createdDate :new Date(),
				username: params?.username,email:params?.username,phone: params?.phone ,firstName: params?.firstName,lastName: params?.lastName,
				agree:params.agree.contains("off")?false:true,politics:params.agree.contains("off")?false:true,
				password: params?.password,status:UStatus.DONE,
				enabled: params.agree.contains("off")?false:true,
				accountLocked:params.agree.contains("off")?true:false,rtaxi:null).save(failOnError: true,flush:true)
				def companyRole=Role.findByAuthority("ROLE_INVESTOR")
				if (! customer.hasErrors() && customer.save(flush:true)) {
					if (!customer.authorities.contains(companyRole)) {
						UserRole.create customer, companyRole
					}
					message = "Customer  ${customer.username} Added"
					state = "OK"
				} else {
					message = "Could Not Save User"
				}

				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = InvestorUser.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					customer.phone = params?.phone
					customer.firstName=params?.firstName
					customer.lastName=params?.lastName
					customer.username=params?.username
					customer.email=params?.username
					if(!params?.password.equals("****")){
						customer.password=params?.password
					}
					customer.createdDate =new Date()
					customer.lastModifiedDate =new Date()
					customer.enabled = params.agree.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.accountLocked=params.agree.contains("off")?true:false
					customer.politics=customer.agree

					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Customer  ${customer.username}  Updated"
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

					def city =EnabledCities.get(params.city)
					if(customer.city!=city){
						customer.city=city
					}
					customer.companyName = params?.companyName
					customer.cuit = params?.cuit
					customer.phone = params?.phone
					customer.username=params?.username
					customer.email=params?.username
					customer.password=params?.password
					customer.enabled = params.enabled.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.accountLocked= params.accountLocked.contains("off")?false:true
					customer.politics=customer.agree
					customer.isTestUser= params.isTestUser.contains("off")?false:true
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
					def city =EnabledCities.get(params.city)
					if(customer.city!=city){
						customer.city=city
					}
					if(!params?.password.equals("****")){
						customer.password=params?.password
					}
					customer.enabled = params.enabled.contains("off")?false:true
					customer.agree= params.agree.contains("off")?false:true
					customer.accountLocked= params.accountLocked.contains("off")?false:true
					customer.politics=customer.agree
					customer.isTestUser= params.isTestUser.contains("off")?false:true
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "Customer  ${customer.username}  Updated"
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
	
	def jq_parking = {
		def sortIndex = params.sidx ?: 'countTrips'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows


		def parkings=adminUserService.getAllParking( maxRows,rowOffset,sortIndex,sortOrder)

		def totalRows = parkings.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = parkings.collect {

			[cell: [it.user.companyName,
					it.name,
					it.lat,
					it.lng
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_edit_parking  = {
		def parking = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			case 'add':
				params.lat = params?.double('lat')
				params.lng  = params?.double('lng')
				parking = new Parking(params)
				if (! parking.hasErrors() && parking.save(flush:true)) {
					
					message = "Expenses Added"
					state = "OK"
				} else {
					message = "Could Not Save Expenses"
				}

				break;
			case 'del':
				// check Spam exists
					parking = Parking.get(params.id)
					if (parking) {
						// delete Spam
						parking.delete()
						message = "Parking  ${parking.id}  Deleted"
						state = "OK"
					}
					break;
			default:
			// default edit action
			// first retrieve the parking by its ID
				parking = Parking.get(params.id)
				if (parking) {
					
					params.lat = params?.double('lat')
					params.lng  = params?.double('lng')
					parking.properties = params
					if (! parking.hasErrors() && parking.save(flush:true)) {
						message = "parking Updated"
						id = parking.id
						state = "OK"
					} else {
						message = "Could Not Update  "
					}
				}
				break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	}
}