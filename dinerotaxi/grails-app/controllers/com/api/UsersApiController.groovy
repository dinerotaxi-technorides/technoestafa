package com.api

import grails.converters.JSON
import groovy.json.JsonSlurper

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.codehaus.groovy.grails.plugins.springsecurity.ui.RegistrationCode
import org.springframework.security.core.Authentication

import sun.misc.BASE64Decoder
import ar.com.goliath.Company
import ar.com.goliath.EnabledCities
import ar.com.goliath.PersistToken
import ar.com.goliath.Profile
import ar.com.goliath.RealUser
import ar.com.goliath.Role
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.goliath.api.JsonToken
import ar.com.goliath.corporate.CorporateUser

import com.Device
import com.UserDevice
class UsersApiController extends DineroTaxiValidateApiController{
	def exportService
	def springDineroTaxiService
	def springSecurityService
	def rememberMeServices
	def userService
	def emailService
	def notificationService
	def userAgentIdentService
	def technoRidesEmailService
	def utilsApiService
	def addExcept(list) {
		list <<'createUserMinimal'<< 'login'<<'isAvailable'<< 'validate'<<'checkPush'<<'confirmAmount'<<'getEnabledCities'<<'getCities'<<'forgotPasswordChangePass'<<'forgotPassword'<<'version'<<'addDevice'
	}
	def createUserMinimal = {
		try{
			def u =new JsonToken();
			def jtString = new JsonSlurper().parseText( params?.json )
			def ccs=request.JSON
			def idUsr=""
			def rtaxi=jtString?.rtaxi?Company.findByUsername(jtString?.rtaxi):null
			def rtaxiUser=User.get(rtaxi?.id)
			if(!rtaxiUser){
				throw new Exception('Rtaxi Not Found!!!')
			}
			Long radiotaxi=rtaxi?.id
			def usr = User.findByUsernameAndRtaxi(jtString.email,rtaxiUser)
			String pass=""
			if(usr){
				u.status=109
				render(contentType:'text/json',encoding:"UTF-8") {
					status=u.status
				}
				return
			}

			def dat=new Date()
			pass=jtString?.password?:"mujer"+dat.day.toString()+dat.minutes.toString()+dat.day.toString()
			RealUser pojo = new  RealUser(
				username: jtString.email,email:jtString.email,
				firstName: jtString?.name?:' ',lastName:jtString?.lastName?:' ',phone:jtString.phone ,
				agree:true,politics:true,
				accountLocked:false,
				password: jtString?.password?:pass,
				status:UStatus.MINIMAL,
				validated:UStatus.MINIMAL,createdDate:new Date(),usrDevice:UserDevice.ANDROID,
				enabled: true,ip:request.getRemoteAddr(),rtaxi:rtaxiUser);
			if(params?.city){
				def posibleCity=EnabledCities.get(params?.city)
				if(posibleCity==null){
					if(rtaxiUser){
						pojo.city=rtaxiUser.city
					}else{
						pojo.city=EnabledCities.findAllByEnabled(true).first()
					}
				}else{
					pojo.city=posibleCity
				}
			}else{
				if(rtaxiUser){
					pojo.city=rtaxiUser.city
				}else{
					pojo.city=EnabledCities.findAllByEnabled(true).first()
				}
			}
			if(params?.lang){
				pojo.lang=params?.lang
			}else{
				pojo.lang=rtaxiUser?.lang
			}
			if(!pojo.hasErrors() && pojo.save(flush:true)) {
				def userRole=Role.findByAuthority("ROLE_USER")
				if (!pojo.authorities.contains(userRole)) {
					UserRole.create pojo, userRole
				}
				utilsApiService.setBusinessModelByRtaxi(pojo,rtaxi)
				def pers=PersistToken.findAllByUsernameAndRtaxi(pojo.username,radiotaxi).each{ it.delete() }
				springDineroTaxiService.reauthenticate (pojo.username ,pojo.password,rtaxi)
				Authentication auth=springDineroTaxiService.getAuthentication()
				request.setAttribute("rtaxi",radiotaxi)
				rememberMeServices.loginSuccess(request, response, auth);
				def tok=null
				if(rtaxi==null){
					tok=PersistToken.find("from PersistToken as b where b.username=:username and b.rtaxi is null",
							[username: pojo.email])
				}else{
					tok=PersistToken.find("from PersistToken as b where b.username=:username and b.rtaxi=:rtaxi",
							[username: pojo.email,rtaxi:radiotaxi])
				}
				if(tok){
					if(tok.token.contains("+")){
						tok.token=tok.token.replaceAll("\\+", "w")
						tok.save(flush:true)
					}
					u.token=tok.token
				}
				def registrationCode = new RegistrationCode(username: pojo.username).save(flush:true)
				String url = generateLink('verifyRegistration', [t: registrationCode.token])
				def conf = SpringSecurityUtils.securityConfig
				def stringRtaxi=rtaxi?.companyName?rtaxi?.companyName:''
				try {
					technoRidesEmailService.buildEmailCreateUser(pojo?.id,rtaxi?.id,url)
				} catch (Exception e) {
					e.printStackTrace()
				}

				u.status=100
				idUsr=pojo?.id
			}else{
				u.status=101
			}

			def is_corporate_account=usr instanceof CorporateUser;
			def isRequiredZone=false
			if (rtaxi?.wlconfig?.hasRequiredZone){
				isRequiredZone=true
			}
			def hasMobilePayment=false
			if (rtaxi?.wlconfig?.hasMobilePayment){
				hasMobilePayment=true
			}
			def ispaypal=false
			if (rtaxi?.wlconfig?.paypal){
				ispaypal=true
			}
			def hadUserNumber=false
			if (rtaxi?.wlconfig?.hadUserNumber){
				hadUserNumber=true
			}
			def currency='USD'
			if (rtaxi?.wlconfig?.mobileCurrency){
				currency =  rtaxi?.wlconfig?.mobileCurrency
			}

			def googleApiKeyS=''
			if (rtaxi?.wlconfig?.googleApiKey){
				googleApiKeyS =  rtaxi?.wlconfig?.googleApiKey
			}
			def useadminCode = false
			if (rtaxi?.wlconfig?.useAdminCode){
				useadminCode=true
			}
			def adminCode = pojo?.city?.admin1Code?:''
			def countryI   = pojo?.city?.country?:''
			def timeZone   = pojo?.city?.timeZone?:''
			def countryCode   = pojo?.city?.countryCode?:''
			if (usr?.rtaxi?.city){
				adminCode  = pojo?.rtaxi?.city?.admin1Code?:''
				countryI   = pojo?.rtaxi?.city?.country?:''
				timeZone   = pojo?.rtaxi?.city?.timeZone?:''
				countryCode= pojo?.rtaxi?.city?.countryCode?:''
			}

			render(contentType:'text/json',encoding:"UTF-8") {
				googleApiKey=googleApiKeyS
				token=u.token
				status=u.status
				password=pass
				id=idUsr
				lang=rtaxi?.lang?:''
				country=countryI
				time_zone=timeZone
				admin_code=adminCode
				useAdminCode = useadminCode
				country_code=countryCode
				rtaxiId=rtaxi?.id
				lat=pojo?.city?.northEastLatBound?:0
				lng=pojo?.city?.northEastLngBound?:0
				companyPhone=pojo?.phone?:""
				currency =  currency
				has_mobile_payment=hasMobilePayment
				paypal=ispaypal
				is_cc=false
				is_required_zone=isRequiredZone
				had_driver_number=hadUserNumber
				firstName=pojo.firstName
				lastName=pojo.lastName
				isFareCalculatorActive=rtaxi.wlconfig?.isFareCalculatorActive
				creditCardEnable      =rtaxi.wlconfig?.creditCardEnable
				phone=pojo.phone
				email=pojo.email
			}
		}catch (Exception e){
			log.error e.getCause()
			log.error e.getMessage()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def login = {
		try{
			def u =new JsonToken();
			def jtString=params?.json
			def pojo = new JsonSlurper().parseText( jtString )
			def usr =null
			def idUsr=""
			def rtaxi=pojo?.rtaxi? ar.com.goliath.Company.findByUsername(pojo?.rtaxi):null

			if(rtaxi!=null){
				usr=User.find("from User as b where b.username=:username and b.password=:password and rtaxi=:rtaxi",
						[username: pojo.email,password:springSecurityService.encodePassword(pojo.password),rtaxi:rtaxi])
			}else{
				usr=User.find("from User as b where b.username=:username and b.password=:password and rtaxi is null",
						[username: pojo.email,password:springSecurityService.encodePassword(pojo.password)])
			}

			if(!usr){
				render(contentType: 'text/json',encoding:"UTF-8") { status=104 }
				return false

			}
			if(!usr.enabled){
				render(contentType: 'text/json',encoding:"UTF-8") { status=105 }
				return false
			}
			if(usr.accountExpired){
				render(contentType: 'text/json',encoding:"UTF-8") { status=106 }
				return false
			}
			if(usr.accountLocked){
				render(contentType: 'text/json',encoding:"UTF-8") { status=107}
				return false
			}
			if(usr.passwordExpired){
				render(contentType: 'text/json',encoding:"UTF-8") { status=108 }
				return false
			}


			Long radiotaxi=rtaxi?.id
			def pers=PersistToken.findAllByUsernameAndRtaxi(usr.username,radiotaxi).each{ it.delete() }

			springDineroTaxiService.reauthenticate (usr.username ,usr.password,rtaxi)
			Authentication auth=springDineroTaxiService.getAuthentication()
			request.setAttribute("rtaxi",radiotaxi)
			rememberMeServices.loginSuccess(request, response, auth);

			def tok=null

			if(rtaxi==null){
				tok=PersistToken.find("from PersistToken as b where b.username=:username and b.rtaxi is null",
						[username: pojo.email])
			}else{
				tok=PersistToken.find("from PersistToken as b where b.username=:username and b.rtaxi=:rtaxi",
						[username: pojo.email,rtaxi:radiotaxi])
			}

			if(tok){
				if(tok.token.contains("+")){
					tok.token=tok.token.replaceAll("\\+", "w")
					tok.save(flush:true)
				}
				u.token=tok.token
			}

			idUsr=usr.id
			u.status=100

			def is_corporate_account=usr instanceof CorporateUser;
			def isRequiredZone=false
			if (rtaxi?.wlconfig?.hasRequiredZone){
				isRequiredZone=true
			}
			if (rtaxi?.wlconfig?.hasRequiredKm){
				isRequiredZone=true
			}
			def hasMobilePayment=false
			if (rtaxi?.wlconfig?.hasMobilePayment){
				hasMobilePayment=true
			}
			def ispaypal=false
			if (rtaxi?.wlconfig?.paypal){
				ispaypal=true
			}
			def hadUserNumber=false
			if (rtaxi?.wlconfig?.hadUserNumber){
				hadUserNumber=true
			}
			def merchant_id=''
			def mobileCurrency='USD'
			if (rtaxi?.wlconfig?.currency){
				mobileCurrency =  rtaxi?.wlconfig?.currency
			}
			if (rtaxi?.wlconfig?.merchantId){
				merchant_id =  rtaxi?.wlconfig?.merchantId
			}
			def first_name = usr?.firstName?:''
			def last_name  = usr?.lastName?:''

			def adminCode = usr?.city?.admin1Code?:''
			def countryI   = usr?.city?.country?:''
			def timeZone   = usr?.city?.timeZone?:''
			def countryCode   = usr?.city?.countryCode?:''
			if (usr?.rtaxi?.city){
				adminCode = usr?.rtaxi?.city?.admin1Code?:''
				countryI   = usr?.rtaxi?.city?.country?:''
				timeZone   = usr?.rtaxi?.city?.timeZone?:''
				countryCode   = usr?.rtaxi?.city?.countryCode?:''
			}

			def useadminCode = false
			if (rtaxi?.wlconfig?.useAdminCode){
				useadminCode=true
			}

			def googleApiKeyS=''
			if (rtaxi?.wlconfig?.googleApiKey){
				googleApiKeyS =  rtaxi?.wlconfig?.googleApiKey
			}
			def admin = false
			def costId = pojo?.costCenter?.id
			def companyId = pojo?.costCenter?.corporate?.id
			def corporateSuperUser = false
			if (usr?.admin){
				admin = true
				corporateSuperUser = usr?.corporateSuperUser
				def c_user = CorporateUser.get(usr.id)
				costId =  c_user?.costCenter?.id
				companyId = c_user?.costCenter?.corporate?.id
			}
			def business_model = rtaxi.businessModel.collect(){
				it.name
			}
			def roles_user = rtaxi.authorities.collect(){
				it.authority
			}
			render(contentType:'text/json',encoding:"UTF-8") {
				googleApiKey=googleApiKeyS
				token=u.token
				status=u.status
				lat=usr?.city?.northEastLatBound?:0
				lng=usr?.city?.northEastLngBound?:0
				companyPhone=rtaxi?.phone?:""
				lang=rtaxi?.lang?:''
				country=countryI
				time_zone=timeZone
				admin_code=adminCode
				useAdminCode=useadminCode
				had_driver_number=hadUserNumber
				country_code=countryCode
				id=idUsr
				currency =  mobileCurrency
				isFareCalculatorActive=rtaxi.wlconfig?.isFareCalculatorActive
				creditCardEnable      =rtaxi.wlconfig?.creditCardEnable
				has_mobile_payment=hasMobilePayment
				paypal=ispaypal
				merchant_id= merchant_id
				rtaxiId=rtaxi?.id
				is_cc=is_corporate_account
				is_cc_admin = admin
				is_cc_super_admin = corporateSuperUser
				cost_id = costId
				corporate_id = companyId
				is_required_zone=isRequiredZone
				firstName=first_name
				lastName =last_name
				phone=usr.phone
				email=usr.email
				businessModel = business_model
				roles= roles_user

			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def logout = {
		try{
			def u =new JsonToken();
			def jtString=params?.token

			def usr=null
			if (springSecurityService.isLoggedIn()){

				usr = springSecurityService.currentUser
				session.invalidate()
				u.status=100
			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok?.username){
					PersistToken.findAllByUsername(tok?.username).each{ it.delete() }
				}
				u.status=100

			}

			if (!u?.status) {
				u.status=122
			}

			render(contentType:'text/json',encoding:"UTF-8") { status=u.status }
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def isAvailable={

		try{
			def json=new JsonToken();
			if(params?.email && !params?.email.equals("") && params?.rtaxi  && !params?.rtaxi.equals("")){
				def usr = null
				if(params?.rtaxi){
					usr=User.findByUsernameAndRtaxi(params?.email,params?.rtaxi?Company.findByUsername(params?.rtaxi):null)
				}else{
					usr=User.findByUsernameAndRtaxiIsNull(params?.email)
				}
				if(usr){
					json.status=109
				}else{
					json.status=100
				}
			}else {
				json.status=404

			}
			render(contentType:'text/json',encoding:"UTF-8") { status=json.status }

		}catch (Exception e){
			log.error e.getMessage()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def validate = {
		try{
			def u =new JsonToken();
			def jtString = new JsonSlurper().parseText( params?.json )
			def pojo = new PersistToken(jtString)
			def tok=PersistToken.findByToken(pojo.token)
			if(tok){
				u.status=100
			}else{
				u.status=1
			}

			render(contentType:'text/json',encoding:"UTF-8") { status=u.status }

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def addDevice1={
		if (params.deviceToken && !Device.findByKeyValue(params.deviceToken)) {
			def usr=User.findByUsername("rrhh@technorides.com")
			new Device(keyValue:params.deviceToken,description:"     ",dev:UserDevice.ANDROID,user:user).save(failOnError:true)
		}

		render(contentType:'text/json',encoding:"UTF-8") { status=100 }
	}
	def addDevice={DevicesCommand cmd->
		try{
			def json=new JsonToken();
			json.status=131
			println cmd as JSON
			if(! cmd.hasErrors()){
				def usr=null
				if (springSecurityService.isLoggedIn()){
					def prin= springSecurityService.currentUser
					usr=User.findByUsernameAndRtaxi(prin.username,prin?.rtaxi?User.get(prin.rtaxi):null)

				}
				def tok=null
				if(params?.token){
					tok=PersistToken.findByToken(params?.token)
					if(tok){
						usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
					}
				}
				if(tok || springSecurityService.isLoggedIn()){
					if(usr){
						def devesTest=Device.findAllByKeyValue(cmd.keyValue)


						def dvce=Device.findByUser(usr)

						if(dvce){
							dvce.keyValue=cmd.keyValue
							dvce.description=cmd?.description?:""
							dvce.dev=cmd.dev
							dvce.save(flush:true)
							json.status=100
						}else{
							def devic=new Device()
							devic.keyValue=cmd.keyValue
							devic.description=cmd?.description?:""
							devic.dev=cmd.dev
							devic.user=usr
							devic.save(flush:true)
							json.status=100
						}
					}else{
						json.status=110
					}
				}else{
					json.status=1
				}
			}

			render(contentType:'text/json',encoding:"UTF-8") { status=json.status }

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def checkPush={
		try{
			def usr=null

			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.currentUser
				usr=User.findByUsernameAndRtaxi(prin.username,prin?.rtaxi?User.get(prin.rtaxi):null)

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(usr){

				def c = Device.createCriteria()
				def opL=c.list(){
					and{ eq ('user',usr) }
				}
				if(opL){
					notificationService.checkPush( usr	)
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }
				}else{

					render(contentType:'text/json',encoding:"UTF-8") { status=10 }

				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}


	def confirmAmount={
		render(contentType:'text/json',encoding:"UTF-8") {
			status=100
		}
	}
	def getEnabledCities={
		try{
			def enabledcities=EnabledCities.findAllByEnabled(true)
			if(enabledcities){
				String cit=enabledcities as JSON
				render(contentType:'text/json',encoding:"UTF-8") {
					status=100
					cities=cit
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=7 }
			}
		}catch (Exception e){
			e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def getCities={
		try{
			def enabledcities=EnabledCities.findAllByEnabled(true)
			if(enabledcities){
				def toRender = enabledcities.collect { cities->
					["id": cities.id, "name":cities.name,"value":cities.admin1Code]
				}
				render(contentType:'text/json',encoding:"UTF-8") {
					status=100
					cities=toRender
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=7 }
			}
		}catch (Exception e){
			e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def changePassword={
		try{
			def usr=null
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}


			def current=params?.current?:""
			def newPass=params?.newPass?:""
			if(!usr){
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
				return;
			}
			if(newPass.size()<5){
				render(contentType:'text/json',encoding:"UTF-8") { status=3 }
				return;
			}

			usr.password=newPass
			usr.save(flush:true)

			def rtaxiUser = null
			if(usr?.rtaxi){
				rtaxiUser= ar.com.goliath.Company.get(usr.rtaxi.id)
			}
			Long radiotaxi=rtaxiUser?.id
			def pers=PersistToken.findAllByUsernameAndRtaxi(usr.username,radiotaxi).each{ it.delete() }
			springDineroTaxiService.reauthenticate (usr.username ,usr.password,rtaxiUser)
			Authentication auth=springDineroTaxiService.getAuthentication()
			request.setAttribute("rtaxi",radiotaxi)
			rememberMeServices.loginSuccess(request, response, auth);
			if(rtaxiUser==null){
				tok=PersistToken.find("from PersistToken as b where b.username=:username and b.rtaxi is null",
						[username: usr.email])
			}else{
				tok=PersistToken.find("from PersistToken as b where b.username=:username and b.rtaxi=:rtaxi",
						[username: usr.email,rtaxi:radiotaxi])
			}
			if(tok){
				if(tok.token.contains("+")){
					tok.token=tok.token.replaceAll("\\+", "w")
					tok.save(flush:true)
				}
			}
			render(contentType:'text/json',encoding:"UTF-8") {
				status=100
				token=tok.token
			}


		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def changeEmail={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}

			if(usr){
				def current=params?.email?:""
				def exist=User.findByUsername(current)
				if(!exist){
					usr.email=current
					usr.username=current
					usr.accountLocked = true
					usr.enabled = false
					usr.status=UStatus.WITHOUTFINISHREGISTRATION
					usr.save(flush:true)
					def registrationCode = new RegistrationCode(username: usr.username).save(flush:true)
					String url = generateLink('verifyRegistration', [t: registrationCode.token])

					def conf = SpringSecurityUtils.securityConfig
					def body =  g.render(template:"/emailconfirmation/confirmationRequest", model:[usr: usr,url:url]).toString()

					emailService.send(usr.email, conf.ui.register.emailFrom, "CONFIRMACI��N DE CAMBIO DE EMAIL",  body.toString())
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=6 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def editSettings={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(usr){
				def firstName=params?.firstName
				def lastName=params?.lastName
				def phone=params?.phone
				print params
				if(params?.city){
					usr.city=EnabledCities.get(params?.city)
				}else{
					def cit=usr?.rtaxi?.city?:EnabledCities.first()
					usr.city=cit
				}
				if( firstName && lastName && phone ){
					usr.firstName=firstName
					usr.lastName=lastName
					usr.phone=phone
					usr.save(flush:true)
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=5 }

				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def getSettings={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}

			if(usr){
				render(contentType:'text/json',encoding:"UTF-8") {
					status=100
					firstName=usr.firstName
					lastName=usr.lastName
					phone=usr.phone
					email=usr.email
				}

			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def forgotPasswordChangePass = {

		def usr=null;
		def rtaxi=null;
		if(params?.email && !params?.email.equals("") ){
			if(params?.rtaxi){
				rtaxi=params?.rtaxi?Company.findByUsername(params?.rtaxi):null
				usr=User.findByUsernameAndRtaxi(params?.email,params?.rtaxi?Company.findByUsername(params?.rtaxi):null)
			}else{
				usr=User.findByUsernameAndRtaxiIsNull(params?.email)
			}
			if(!usr){
				render(contentType:'text/json',encoding:"UTF-8") { status=15 }
				return
			}
		}else if(!params?.email||params?.email.equals("")){
			render(contentType:'text/json',encoding:"UTF-8") { status=108 }
			return
		}
		def dat=new Date()
		String pass="abc"+dat.day.toString()+dat.minutes.toString()+dat.day.toString()
		usr.password= pass
		usr.validated=UStatus.MINIMALWITHPASS
		usr.save(flush:true)

		technoRidesEmailService.buildEmailForgotPassword(usr.id,rtaxi.id,pass)

		render(contentType:'text/json',encoding:"UTF-8") { status=100 }
	}
	def forgotPassword = {

		String username = params.email
		if (!username) {
			render(contentType:'text/json',encoding:"UTF-8") { status=14 }
			return
		}

		def user=null;
		def rtaxi=null;
		if(params?.rtaxi){
			rtaxi=params?.rtaxi?Company.findByUsername(params?.rtaxi):null
			user = User.findByUsernameAndRtaxi(username,rtaxi)
		}else{
			user = User.findByUsername(username)
		}
		if (!user) {
			render(contentType:'text/json',encoding:"UTF-8") { status=15 }
			return
		}

		def registrationCode = new RegistrationCode(username: user.username).save(flush:true)

		String url = generateLink('resetPassword', [t: registrationCode.token])
		def conf = SpringSecurityUtils.securityConfig
		def body =  g.render(template:"/emailconfirmation/confirmationPassword", model:[usr: user,url:url]).toString()
		def header ="Nueva contraseña"
		if(rtaxi){
			body=body.replaceAll("DINEROTAXI.COM", rtaxi.email.split("@")[1].toUpperCase())
			header=header.replaceAll("DINEROTAXI.COM", rtaxi.email.split("@")[1].toUpperCase())
			body=body.replaceAll("dinerotaxi.com", rtaxi.email.split("@")[1])
			header=header.replaceAll("dinerotaxi.com", rtaxi.email.split("@")[1])
			body=body.replaceAll("dinerotaxi", rtaxi.companyName)
			header=header.replaceAll("dinerotaxi", rtaxi.companyName)
		}
		//		mailService.sendMail {
		//			to user.email
		//			from conf.ui.forgotPassword.emailFrom
		//			subject conf.ui.forgotPassword.emailSubject
		//			html body.toString()
		//		}

		emailService.send(user.email, conf.ui.register.emailFrom, header,  body.toString())
		render(contentType:'text/json',encoding:"UTF-8") { status=100 }
	}
	def version = {
		Double vers=new Double(1.6)
		def stat=1
		print params as JSON
		if(params?.device){
			if(UserDevice.BB.toString().equals(params?.device)){
				if(params?.ver){
					try{
						Double ver=Double.parseDouble(params.ver)
						if(ver.compareTo(vers)==0){
							stat=100
						}else if(ver.compareTo(vers)==1){
							stat=100
						}else if(ver.compareTo(vers)==-1){
							stat=131
						}
					}catch (NumberFormatException e){
						stat=132
					}
				}else{
					stat=133
				}
			}else if(UserDevice.IPHONE.toString().equals(params?.device)){
				if(params?.ver){
					try{
						Double ver=Double.parseDouble(params.ver)
						if(ver.compareTo(vers)==0){
							stat=100
						}else if(ver.compareTo(vers)==1){
							stat=100
						}else if(ver.compareTo(vers)==-1){
							stat=131
						}
					}catch (NumberFormatException e){
						stat=132
					}
				}else{
					stat=133
				}
			}else if(UserDevice.ANDROID.toString().equals(params?.device)){

				render(contentType:'text/json',encoding:"UTF-8") {
					status=100
					version_code=91
					content="Version 2.0 <p>New features:</p><li>Added feature A</li><li>Added feature B</li><li>Added feature C</li><li>Added feature D</li><li>Added feature E</li><li>Added feature F</li><li>Added feature G</li>"
					}
				return;
			}
		}
		render(contentType:'text/json',encoding:"UTF-8") { status=stat }
	}

	def getPhoto={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(!usr){
				response.setStatus(5)
				render(contentType:'text/json',encoding:"UTF-8") { status=5 }
				return false;
			}
			def profile=Profile.findByUsr(usr)
			if(!profile){
				render(contentType:'text/json',encoding:"UTF-8") { status=5 }
				return false;
			}
			response.contentType = "image/jpeg"
			response.contentLength = profile?.filePayload.length
			response.outputStream.write(profile?.filePayload)
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def uploadPhoto={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser
			}
			if(usr){
				def prof=Profile.findByUsr(usr)?:new Profile(usr:usr)
				prof.filePayload=((byte[]) decodeToImage(params.image))
				if(!prof.save()){
					prof.errors.each{
						print it
					}
				}
				//byte[] imageBytes = ((DataBufferByte) decodeToImage(params.image).getData().getDataBuffer()).getData();
				//usr.photo=imageBytes
				//usr.save(flush:true)
				render(contentType:'text/json',encoding:"UTF-8") { status=100 }

			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.getCause()
			log.error e.getMessage()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	public static byte[] decodeToImage(String imageString) {

		byte[] imageByte;
		try {
			BASE64Decoder decoder = new BASE64Decoder();
			imageByte = decoder.decodeBuffer(imageString);
			ByteArrayInputStream bis = new ByteArrayInputStream(imageByte);
			bis.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return imageByte;
	}
	protected String generateLink(String action, linkParams) {
		createLink(base: "$request.scheme://$request.serverName:$request.serverPort$request.contextPath",
		controller: 'register', action: action,
		params: linkParams)

	}
}
class DevicesCommand {
	String token
	String keyValue;
	String description;
	UserDevice dev
	static constraints = {
		keyValue blank: false,nullable:false
		description blank: false,nullable:false
	}
}
