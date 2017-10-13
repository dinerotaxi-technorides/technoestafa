package com.api.technorides

import grails.converters.JSON
import uk.co.desirableobjects.sendgrid.SendGridEmail
import uk.co.desirableobjects.sendgrid.SendGridEmailBuilder
import ar.com.goliath.Company
import ar.com.goliath.EmailBuilder
import ar.com.goliath.EmployUser
import ar.com.goliath.EnabledCities
import ar.com.goliath.PersistToken
import ar.com.goliath.RealUser
import ar.com.goliath.Role
import ar.com.goliath.TypeEmployer
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.notification.ConfigurationApp
import ar.com.goliath.payment.PaypalMerchant
class TechnoRidesAdminApiController extends TechnoRidesAdminValidateApiController {
	def adminUserService
	def sendGridService
	def utilsApiService
	def technoRidesReportService
	static allowedMethods = [jq_email_config_edit:'POST']
	def addExcept(list) {
		list <<'get'
	}
	def get={
    render "asd"
  }
	def jq_employee_list = {
		try{
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
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
	def jq_edit_customer = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def customer = null
			def intermediario =null
			def message = ""
			def state = "FAIL"
			def id=null

			// determine our action
			switch (params.oper) {

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
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
	def jq_real_user_serching_list = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

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
				if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
					ilike("username", params.searchString+"%")
				}
				if(  params.searchField.equals("lastName") && !params.searchString.isEmpty()){
					ilike("lastName", params.searchString+"%")
				}

				if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
					ilike("phone", params.searchString+"%")
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
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
	def jq_edit_real_user = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

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
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
	def jq_b2b_customer = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

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
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
	def jq_edit_b2b_customer = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def customer = null
			def intermediario =null
			def message = ""
			def state = "FAIL"
			def id = null

			if(params?.enabled){
				params.enabled=params.enabled.contains("false")?false:true
			}else{
				params.enabled=false
			}
			if(params?.isTestUser){
				params.isTestUser=params.isTestUser.contains("false")?false:true
			}else{
				params.isTestUser=false
			}
			if(params?.accountLocked){
				params.accountLocked=params.accountLocked.contains("false")?false:true
			}else{
				params.accountLocked=true
			}
			if(params?.agree){
				params.agree=params.agree.contains("false")?false:true
			}else{
				params.agree=false
			}
			// determine our action
			switch (params.oper) {
				case 'add':
				// add instruction sent
					params.latitude=params.float('latitude')
					params.longitude=params.float('longitude')
					params.email =params?.username

					params.createdDate = new Date()
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
						applePassword:wlConfigdefault.applePassword  ,isEnable:true,mailkey: wlConfigdefault.mailkey ,distanceType:'KM',googleApiKey:'AIzaSyDVz_ywjT3iiX-xsEIy7z2s8YqseVxTYms')
						wlConfignew.mapKey = "AIzaSyDETwlXKIG-v6rZeV_7uWbuWdpB3IThysI"
						wlConfignew.subdomain = "xxx.xx"
						wlConfignew.save()
						wlConfignew.errors.each{ println it }

						customer.wlconfig=wlConfignew

					}

					def companyRole=Role.findByAuthority("ROLE_COMPANY")
					if (! customer.hasErrors() && customer.save()) {
						if (!customer.authorities.contains(companyRole)) {
							UserRole.create customer, companyRole
						}

						utilsApiService.setBusinessModel(customer, params.businessModel)
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
					def response = [message:message,state:state,id:id]

					render response as JSON
					break;

				case 'block':
					def company =Company.get(params.id)
					if(!company){
						def response = [message:message,state:state,id:id]
						render response as JSON
						break;
					}
					company.accountLocked = true

					if (! company.hasErrors() && company.save()) {

						technoRidesReportService.blockCompanyUsers(Long.valueOf(company.id))
						message = "Customer  ${company.username} Modified"
						state = "OK"
					} else {
						company.errors.each{
							println it
						}
						message = "Could Not Save User"
					}
					def response = [message:message,state:state,id:id]
					render response as JSON
					break;
				case 'unblock':
					def company =Company.get(params.id)
					if(!company){
						def response = [message:message,state:state,id:id]
						render response as JSON
						break;
					}
					company.accountLocked = false
					company.enabled  = true
					company.agree    = true
					company.politics = true
					if (! company.hasErrors() && company.save()) {

						technoRidesReportService.unblock(Long.valueOf(company.id))
						message = "Customer  ${company.username} Modified"
						state = "OK"
					} else {
						company.errors.each{
							println it
						}
						message = "Could Not Save User"
					}
					def response = [message:message,state:state,id:id]
					render response as JSON
					break;
				default:
				// default edit action
				// first retrieve the customer by its ID
					customer = Company.get(params.id)
					if (customer) {
						// set the properties according to passed in parameters
						def lat=params.float('latitude')
						def lng=params.float('longitude')
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
						customer.enabled = params.enabled
						customer.agree= params.agree
						customer.accountLocked= params.accountLocked
						customer.politics=customer.agree
						customer.isTestUser= params.isTestUser
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
						if (! customer.hasErrors() && customer.save(flush:true)) {
							message = "Customer  ${customer.username}  Updated"
							id = customer.id
							state = "OK"
						} else {
							message = "Could Not Update Customer"
						}
					}
					def response = [message:message,state:state,id:id]

					render response as JSON
					break;
			}

		}catch (Exception e){
			e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

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

	def jq_enabled_cities_list = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def sortIndex = params.sidx ?: 'createdDate'
			def sortOrder  = params.sord ?: 'asc'

			def maxRows = Integer.valueOf(params.rows)
			def currentPage = params.page?Integer.valueOf(params.page) : 1
			def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

			def customers = EnabledCities.createCriteria().list(max:maxRows, offset:rowOffset) {
				// set the order and direction

				if(  params.searchField.equals("name") && !params.searchString.isEmpty()){
					ilike("name", params.searchString+"%")
				}
				if(  params.searchField.equals("country") && !params.searchString.isEmpty()){
					ilike("country", params.searchString+"%")
				}
				if(  params.searchField.equals("timeZone") && !params.searchString.isEmpty()){
					ilike("timeZone", params.searchString+"%")
				}
				if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
					ilike("phone", params.searchString+"%")
				}
				order(sortIndex, sortOrder)
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				[cell: [
						it.name,
						it.country,
						it.admin1Code,
						it.locality,
						it.countryCode,
						it.timeZone,
						it.northEastLatBound,
						it.northEastLngBound,
						it.southWestLatBound,
						it.southWestLngBound,
						it.enabled,
					], id: it.id]
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
	def jq_enabled_cities_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def customer = null
			def message = ""
			def state = "FAIL"
			def id

			// determine our action
			switch (params.oper) {
				case 'add':
				// add instruction sent
					customer = new EnabledCities(params)
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "ConfigurationApp  ${customer.name}  Added"
						id = customer.id
						state = "OK"
					} else {
						message = "Could Not Save Customer"
					}

					break;
				case 'del':
				// check customer exists
					customer = EnabledCities.get(params.id)
					if (customer) {
						// delete customer
						customer.delete()
						message = "ConfigurationApp   ${customer.name} Deleted"
						state = "OK"
					}
					break;
				default:
				// default edit action
				// first retrieve the customer by its ID
					customer = EnabledCities.get(params.id)
					if (customer) {
						// set the properties according to passed in parameters
						def northEastLatBound=params.float('northEastLatBound')
						def northEastLngBound=params.float('northEastLngBound')
						def southWestLatBound= params.float('southWestLatBound')
						def southWestLngBound=params.float('southWestLngBound')
						params.northEastLatBound=0
						params.northEastLngBound=0
						params.southWestLatBound= 0
						params.southWestLngBound=0
						customer.properties = params
						customer.northEastLatBound=northEastLatBound
						customer.northEastLngBound=northEastLngBound
						customer.southWestLatBound= southWestLatBound
						customer.southWestLngBound=southWestLngBound
						if (! customer.hasErrors() && customer.save(flush:true)) {
							message = "ConfigurationApp   ${customer.name} Updated"
							id = customer.id
							state = "OK"
						} else {
							message = "Could Not Update Customer"
							customer.errors.each{
								log.error it
							}
						}
					}
					break;
			}

			def response = [message:message,state:state,id:id]

			render response as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}

	def jq_configuration_app_list = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def sortIndex = params.sidx ?: 'createdDate'
			def sortOrder  = params.sord ?: 'asc'

			def maxRows = Integer.valueOf(params.rows)
			def currentPage = params.page?Integer.valueOf(params.page) : 1
			def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

			def customers = ConfigurationApp.createCriteria().list(max:maxRows, offset:rowOffset) {
				  // set the order and direction
				if(  params.searchField.equals("app") && !params.searchString.isEmpty()){
					ilike("app", params.searchString+"%")
				}
				order(sortIndex, sortOrder)
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)

      //Loop upon all items to resolve Paypal Merchant settings if exists
      def jsonCells = customers.collect{confg ->

				def jsonConfg = JSON.parse((confg as JSON).toString())
				if(confg.paypal) {
						def merchant = PaypalMerchant.executeQuery("FROM PaypalMerchant pp INNER JOIN pp.company usr " +
								"WHERE usr.wlconfig.id = :id",[id:confg.id])

            //Obtain the matching merchant
						if (merchant) {
							merchant = merchant[0][0]
							jsonConfg.put("paypal_caller_id", merchant.callerId)
							jsonConfg.put("paypal_caller_password", merchant.callerPassword)
							jsonConfg.put("paypal_caller_signature", merchant.callerSignature)
						}
				}

				jsonConfg
			}

			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
	def jq_configuration_app_edit={
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def customer = null
			def message = ""
			def state = "FAIL"
			def id

			if(params?.percentageSearchRatio)
				params.percentageSearchRatio = params.float('percentageSearchRatio')

			if(params?.distanceSearchTrip)
				params.distanceSearchTrip = params.float('distanceSearchTrip')
			// determine our action
			switch (params.oper) {
			  case 'add':
				// add instruction sent
				customer = new ConfigurationApp(params)
				if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "ConfigurationApp  ${customer.app}  Added"
				  id = customer.id
				  state = "OK"
				} else {
				  message = "Could Not Save Customer"
				}

				break;
			  case 'del':
				// check customer exists
				customer = ConfigurationApp.get(params.id)
				if (customer) {
				  // delete customer
	//			  customer.delete()
				  message = "ConfigurationApp   ${customer.app} Deleted"
				  state = "OK"
				}
				break;
			  default:
				// default edit action
				// first retrieve the customer by its ID
				customer = ConfigurationApp.get(params.id)
				if (customer) {
				  // set the properties according to passed in parameters
				  customer.properties = params
				  if (! customer.hasErrors() && customer.save(flush:true)) {
						if (params.paypal){
              try{
								def cia = Company.findByConfigurationApp(customer);
								def merchant = PaypalMerchant.findByCompany(cia);

                //If merchant was not previously created, this inserts new one
                if (!merchant){
									merchant = new PaypalMerchant()
								}

								merchant.company   = cia
								merchant.callerId  = params.paypal_caller_id
								merchant.callerPassword  = params.paypal_caller_password
								merchant.callerSignature = params.paypal_caller_signature

								if (! merchant.hasErrors() && merchant.save(flush:true)){
								   	print "Paypal merchant ${merchant.id} Updated successfully"
								}
							}catch (Exception e){
								log.error e.getMessage()
							}
				    }
						message = "ConfigurationApp   ${customer.app} Updated"
						id = customer.id
						state = "OK"
				  } else {
						message = "Could Not Update Customer"
						customer.errors.collect{
							print it
						}
				  }
				}
				break;
			}

			def response = [message:message,state:state,id:id]

			render response as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}

	def jq_email_config_list = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def sortIndex = params.sidx ?: 'createdDate'
			def sortOrder  = params.sord ?: 'asc'

			def maxRows = Integer.valueOf(params.rows)
			def currentPage = params.page?Integer.valueOf(params.page) : 1
			def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

			def customers = EmailBuilder.createCriteria().list(max:maxRows, offset:rowOffset) {
				  // set the order and direction
				if(  params.searchField.equals("name") && !params.searchString.isEmpty()){
					ilike("name", params.searchString+"%")
				}
				if(  params.searchField.equals("subject") && !params.searchString.isEmpty()){
					ilike("subject", params.searchString+"%")
				}
			    order(sortIndex, sortOrder)
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)

			def jsonCells = customers.collect {
				  [cell: [it.name,
						  it.subject,
						  '',
						  it.lang,
						  it.user?.companyName?:'',
						  it.isEnabled
					  ], id: it.id]
			  }
			  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
			  render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}

	def jq_email_config_get = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def customer = EmailBuilder.get(params?.id_email)
			if (customer){
				def jsonData= [subject: customer.subject,body:customer.body,status:100]
				render jsonData as JSON
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=11 }
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
	def jq_email_config_edit = {
		try{
			print params
			def tok=PersistToken.findByToken(request.JSON?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def customer = null
			def message = ""
			def state = "FAIL"
			def id=null

			  // determine our action
			  switch (request.JSON.oper) {
				case 'add':
				  // add instruction sent
				  customer = new EmailBuilder(request.JSON)
				  customer.body = java.net.URLDecoder.decode(request.JSON.body)
				  customer.subject = java.net.URLDecoder.decode(request.JSON.subject)
				  if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "EmailBuilder  ${customer.id}  Added"
					id = customer.id
					state = "OK"
				  } else {
					message = "Could Not Save Customer"
				  }

				  break;
				default:
				  // default edit action
				  // first retrieve the customer by its ID
				  customer = EmailBuilder.get(request.JSON.id)
				  if (customer) {
					// set the properties according to passed in parameters
					customer.properties = request.JSON
					customer.body = java.net.URLDecoder.decode(request.JSON.body)
					customer.subject = java.net.URLDecoder.decode(request.JSON.subject)
					if (! customer.hasErrors() && customer.save(flush:true)) {
					  message = "EmailBuilder   ${customer.id} Updated"
					  id = customer.id
					  state = "OK"
					} else {
						customer.errors.each{
							log.error it
						}
					  message = "Could Not Update EmailBuilder"
					}
				  }
				  break;
			  }

			  def response = [message:message,state:state,id:id]

			  render response as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}


	}

	def jq_email_config_edit_old = {
		def customer = null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
		  case 'add':
			// add instruction sent
			customer = new EmailBuilder(params)
			if (! customer.hasErrors() && customer.save(flush:true)) {
			  message = "EmailBuilder  ${customer.id}  Added"
			  id = customer.id
			  state = "OK"
			} else {
			  message = "Could Not Save Customer"
			}

			break;
		  default:
			// default edit action
			// first retrieve the customer by its ID
			customer = EmailBuilder.get(params.id)
			if (customer) {
			  // set the properties according to passed in parameters
			  customer.properties = params
			  if (! customer.hasErrors() && customer.save(flush:true)) {
				message = "EmailBuilder   ${customer.id} Updated"
				id = customer.id
				state = "OK"
			  } else {
				  customer.errors.each{
					  log.error it
				  }
				message = "Could Not Update EmailBuilder"
			  }
			}
			break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	  }
	def jq_email_body={
		render "asd"
	}
	def jq_email_config_list_old = {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = params.rows?Integer.valueOf(params.rows) : 20
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = EmailBuilder.createCriteria().list(max:maxRows, offset:rowOffset) {
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			  [cell: [it.name,
					  it.subject,
					  '',
					  it.lang,
					  it.user?.companyName?:'',
					  it.isEnabled
				  ], id: it.id]
		  }
		  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		  render jsonData as JSON
	}
}
