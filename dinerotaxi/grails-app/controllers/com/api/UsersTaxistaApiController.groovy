package com.api


import grails.converters.JSON

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.codehaus.groovy.grails.plugins.springsecurity.ui.RegistrationCode
import org.springframework.security.core.Authentication

import sun.misc.BASE64Decoder
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.Profile
import ar.com.goliath.Role
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.goliath.Vehicle
import ar.com.goliath.api.JsonToken
import ar.com.operation.OperationAdditionalConfig

import com.Device
import com.UserDevice
class UsersTaxistaApiController {
	def exportService
	def springSecurityService
	def springDineroTaxiService
	def rememberMeServices
	def userService
	def emailService
	def login = {
		try{
			def u =new JsonToken();
			if(!params?.json){
				response.setStatus(409)
				render(contentType: 'text/json',encoding:"UTF-8") { status=409 }
				return
			}
			def jtString=params?.json
			def pojo = JSON.parse(jtString)
			def usr =null
			def idUsr=""
			def rtaxiUser
			def role=[]
			def companyName=""
			if(!pojo?.email){
				response.setStatus(410)
				render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
				return
			}
			def rtaxi=pojo?.rtaxi? ar.com.goliath.Company.findByUsername(pojo?.rtaxi):null
			if(rtaxi!=null){
				usr=EmployUser.find("from User as b where b.username=:username and b.password=:password and rtaxi=:rtaxi",
						[username: pojo.email,password:springSecurityService.encodePassword(pojo.password),rtaxi:rtaxi])
			}else{
				usr=EmployUser.find("from User as b where b.username=:username and b.password=:password and rtaxi is null",
						[username: pojo.email,password:springSecurityService.encodePassword(pojo.password)])
			}
			if(rtaxi){
				rtaxiUser= rtaxi
				companyName=rtaxiUser?.companyName
			}else{
				companyName=usr?.companyName
			}
			def userRole=Role.findByAuthority("ROLE_TAXI")
			def userCCRole=Role.findByAuthority("ROLE_TAXI_OWNER")
			  //def usr=User.findByUsernameAndPasswordAndRtaxi(pojo.email,springSecurityService.encodePassword(pojo.password),rtaxi)
			if(!usr){
//				response.setStatus(411)
				render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
				return

			}
			if(!usr.enabled){
//				response.setStatus(412)
				render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
				return
			}
			if(usr.accountExpired){
//				response.setStatus(413)
				render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
				return
			}
			if(usr.accountLocked){
//				response.setStatus(414)
				render(contentType: 'text/json',encoding:"UTF-8") { status=414}
				return
			}
			if(usr.passwordExpired){
//				response.setStatus(415)
				render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
				return
			}
			if (!usr.authorities.contains(userRole)&&!usr.authorities.contains(userCCRole)){
				render(contentType: 'text/json',encoding:"UTF-8") { status=416}
				return
			}
			role=UserRole.findAllByUser(usr).collect{ it.role.authority }
			Long radiotaxi=rtaxiUser?.id
			def pers=PersistToken.findAllByUsernameAndRtaxi(usr.username,radiotaxi).each{ it.delete() }
			springDineroTaxiService.reauthenticate (usr.username ,usr.password,rtaxiUser)
			Authentication auth=springDineroTaxiService.getAuthentication()
			request.setAttribute("rtaxi",radiotaxi)
			rememberMeServices.loginSuccess(request, response, auth);
			def tok=null
			if(rtaxiUser==null){
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
			def ve=Vehicle.findByTaxistas(usr)
			def intervalPoolingTrip=rtaxiUser?.wlconfig?.intervalPoolingTrip?:20
			def intervalPoolingTripInTransaction=rtaxiUser?.wlconfig?.intervalPoolingTripInTransaction?:20
			def radio=rtaxiUser?.wlconfig?.digitalRadio?:false

			intervalPoolingTrip=intervalPoolingTrip*1000
			intervalPoolingTripInTransaction=intervalPoolingTripInTransaction*1000
			def hasDriverPayment=false
			if (rtaxiUser?.wlconfig?.driverPayment==1|| rtaxiUser?.wlconfig?.hasDriverPayment){
				hasDriverPayment=true
			}
			def latitude=0
			def longitude=0
			if(usr?.rtaxi && usr?.rtaxi?.latitude ){
				latitude=usr.rtaxi.latitude
				longitude=usr.rtaxi.longitude
			}else{
				latitude=usr?.city?.northEastLatBound
				longitude=usr?.city?.northEastLngBound
			}
			def hasMobilePayment=false
			if (rtaxi?.wlconfig?.hasMobilePayment){
				hasMobilePayment=true
			}
			def ispaypal=false
			if (rtaxi?.wlconfig?.paypal){
				ispaypal=true
			}
			def useAdminCode=false
			if (rtaxi?.wlconfig?.useAdminCode){
				useAdminCode=true
			}
			def driversProfileEditable=false
			if (rtaxi?.wlconfig?.driversProfileEditable){
				driversProfileEditable=true
			}
			def hasZoneActive=false
			if (rtaxi?.wlconfig?.hasZoneActive){
				hasZoneActive=true
			}
			def driver_cancelation_reason=false
			if (rtaxi?.wlconfig?.driverCancellationReason){
				driver_cancelation_reason=true
			}
			def isChatEnabled = false
			if (rtaxi?.wlconfig?.isChatEnabled){
				isChatEnabled=true
			}
			def packageCompany = 'BASIC'
			if (rtaxi?.wlconfig?.packageCompany){
				packageCompany=rtaxi?.wlconfig?.packageCompany
			}
			def driverQuota = 10
			if (rtaxi?.wlconfig?.driverQuota){
				driverQuota=rtaxi?.wlconfig?.driverQuota
			}
			def merchant_id=''
			if (rtaxi?.wlconfig?.merchantId){
				merchant_id =  rtaxi?.wlconfig?.merchantId
			}
			def mobileCurrency='USD'
			if (rtaxi?.wlconfig?.currency){
				mobileCurrency =  rtaxi?.wlconfig?.currency
			}

			def additional_l = OperationAdditionalConfig.findAllByRtaxi(rtaxi)
			def additionals_list = additional_l.collect(){
				it.name
			}
			def business_model = usr.businessModel.collect(){
				it.name
			}
			println tok.token
			render(contentType:'text/json',encoding:"UTF-8") {
				driver_quota   = driverQuota
				package_company= packageCompany
				token=tok.token
				status=100
				lang=usr?.lang?:''
				lat=latitude
				lng=longitude
				companyPhone=rtaxiUser?.phone
				country=usr?.city?.country?:''
				adminCode=usr?.city?.admin1Code?:''
				use_admin_code=useAdminCode
				countryCode=usr?.city?.countryCode?:''
				id=usr?.id
				firstName=usr?.firstName
				lastName=usr?.lastName
				phone=usr?.phone?:""
				plate=ve?.patente?:""
				brandCompany=ve?.marca?:""
				model=ve?.modelo?:""
				rtaxiId=rtaxiUser?.id
				poolingTrip=intervalPoolingTrip
				driverCancellationReason = driver_cancelation_reason
				poolingTripInTransaction=intervalPoolingTripInTransaction
				hadPaymentRequired=hasDriverPayment
				hadUserNumber=rtaxiUser?.wlconfig?.hadUserNumber
				has_mobile_payment=hasMobilePayment
				paypal=ispaypal
				has_required_zone=hasZoneActive
				is_chat_enabled = isChatEnabled
				digitalRadio=radio
				currency =  mobileCurrency
				newOpshowAddressFrom=rtaxiUser.wlconfig?.newOpshowAddressFrom
				newOpshowAddressTo=rtaxiUser.wlconfig?.newOpshowAddressTo
				newOpshowCorporate=rtaxiUser.wlconfig?.newOpshowCorporate
				newOpshowUserName=rtaxiUser.wlconfig?.newOpshowUserName
				newOpshowOptions=rtaxiUser.wlconfig?.newOpshowOptions
				newOpshowUserPhone=rtaxiUser.wlconfig?.newOpshowUserPhone
				newOpComment=rtaxiUser.wlconfig?.newOpComment

				isProfileEditable = driversProfileEditable

				isQueueTripActivated=rtaxiUser.wlconfig?.isQueueTripActivated
				disputeTimeTrip=rtaxiUser.wlconfig?.disputeTimeTrip
				driverShowScheduleTrips = rtaxiUser.wlconfig?.driverShowScheduleTrips
				hasDriverDispatcherFunction=rtaxiUser.wlconfig?.hasDriverDispatcherFunction
				isFareCalculatorActive=rtaxiUser.wlconfig?.isFareCalculatorActive
				creditCardEnable      =rtaxi.wlconfig?.creditCardEnable
				isPrePaidActive=rtaxiUser.wlconfig?.isPrePaidActive
				isCorporate=usr?.isCorporate
				isMessaging=usr?.isMessaging
				isPet=usr?.isPet
				isAirConditioning=usr?.isAirConditioning
				isSmoker=usr?.isSmoker
				isSpecialAssistant=usr?.isSpecialAssistant
				isLuggage=usr?.isLuggage
				isAirport=usr?.isAirport
				isVip=usr?.isVip
				isInvoice=usr?.isInvoice
				isRegular=usr?.isRegular
				isLuggage=usr?.isLuggage
				fareInitialCost=rtaxiUser.wlconfig?.fareInitialCost
				fareCostPerKm=rtaxiUser.wlconfig?.fareCostPerKm
				fareConfigActivateTimePerDistance=rtaxiUser.wlconfig?.fareConfigActivateTimePerDistance
				fareConfigGracePeriodMeters=rtaxiUser.wlconfig?.fareConfigGracePeriodMeters
				fareConfigGraceTime=rtaxiUser.wlconfig?.fareConfigGraceTime
				fareConfigTimeSecWait=rtaxiUser.wlconfig?.fareConfigTimeSecWait
				fareConfigTimeInitialSecWait=rtaxiUser.wlconfig?.fareConfigTimeInitialSecWait
				fareCostTimeWaitPerXSeg=rtaxiUser.wlconfig?.fareCostTimeWaitPerXSeg
				fareCostTimeInitialSecWait=rtaxiUser.wlconfig?.fareCostTimeInitialSecWait
				distanceType=rtaxiUser.wlconfig?.distanceType
				googleApiKey=rtaxiUser.wlconfig.googleApiKey
				additionals= additionals_list
				businessModel = business_model
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
				def prin= springSecurityService.principal
				usr=EmployUser.findByUsername(prin.username)
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
			log.error params as JSON
			def json=new JsonToken();
			if(params?.email && !params?.email.equals("") ){
				def usr = null
				if(params?.rtaxi){
					usr=User.findByUsernameAndRtaxi(params?.email,params?.rtaxi?User.findByUsername(params?.rtaxi):null)
				}else{
					usr=User.findByUsernameAndRtaxiIsNull(params?.email)
				}
				if(usr){
					json.status=109
				}else{
					json.status=100
				}
			}else if(!params?.email){
				json.status=108

			}else if(params?.email.equals("")){
				json.status=108

			}
			render(contentType:'text/json',encoding:"UTF-8") { status=json.status }

		}catch (Exception e){
			log.error e.getMessage()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def addDevice={DeviceCommand cmd->
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
				def prin= springSecurityService.principal
				usr=EmployUser.findByUsername(prin.username)

			}
			def tok=null
			if(params?.token)
				tok=PersistToken.findByToken(params?.token)

			if(tok || springSecurityService.isLoggedIn()){

				usr=usr!=null?usr:EmployUser.findByUsername(tok.username)
				if(usr){
					def c = Device.createCriteria()
					def opL=c.list(){
						and{ eq ('user',usr) }
					}
					if(opL){

						render(contentType:'text/json',encoding:"UTF-8") { status=100 }
					}else{

						render(contentType:'text/json',encoding:"UTF-8") { status=10 }

					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	//	 def getDevices={
	//		try{
	//		def usr=null
	//		if (springSecurityService.isLoggedIn()){
	//			def prin= springSecurityService.principal
	//			usr=EmployUser.findByUsername(prin.username)
	//
	//		}
	//		def tok=null
	//		if(params?.token)
	//			tok=PersistToken.findByToken(params?.token)
	//
	//		 if(tok || springSecurityService.isLoggedIn()){
	//
	//			 usr=usr!=null?usr:EmployUser.findByUsername(tok.username)
	//			if(usr){
	//				def c = Device.createCriteria()
	//				def opL=c.list(){
	//					and{
	//						eq ('user',usr)
	//					}
	//				}
	//				def ids= opL.collect {
	//					it.id
	//				}
	//				render(contentType:'text/json',encoding:"UTF-8") {
	//					status=100
	//					id=ids.join(",")
	//
	//				}
	//			}else{
	//			   render(contentType:'text/json',encoding:"UTF-8") {
	//				   status=2
	//			   }
	//			}
	//		}else{
	//			render(contentType:'text/json',encoding:"UTF-8") {
	//				status=1
	//
	//			}
	//		 }
	//		}catch (Exception e){
	//			log.error e.printStackTrace()
	//			render(contentType:'text/json',encoding:"UTF-8") {
	//				status=1
	//
	//			}
	//		}
	//	 }
	def changePassword={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr=EmployUser.findByUsername(prin.username)

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
					def current=params?.current?:""
					def newPass=params?.newPass?:""
					if(newPass.size()>5 && usr.password.equals(springSecurityService.encodePassword(current))){
						usr.password=newPass
						usr.save(flush:true)
						render(contentType:'text/json',encoding:"UTF-8") { status=100 }
					}else{
						if(newPass.size()<5){
							render(contentType:'text/json',encoding:"UTF-8") { status=3 }
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=4 }
						}

					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
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
			}
			print params
			if(!usr){
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
			}
			def firstName = params?.firstName
			def lastName  = params?.lastName
			def phone     = params?.phone

			if( firstName && lastName && phone ){
				usr.firstName = firstName
				usr.lastName  = lastName
				usr.phone     = phone
				usr.save(flush:true)
				def ve1 = Vehicle.findByTaxistas(usr)
				if(!ve1){
					ve1 =new Vehicle()
				}

				ve1.marca=params.marca
				ve1.patente=params.patente
				ve1.modelo=params.modelo
				ve1.active=true
				if(!ve1.save(flush:true)){
					render(contentType:'text/json',encoding:"UTF-8") { status=19 }
				}else{
					ve1.addToTaxistas(usr)
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }
				}

				render(contentType:'text/json',encoding:"UTF-8") { status=100 }
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=5 }

			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def getSettings={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr=EmployUser.findByUsername(prin.username)

			}
			def tok=null
			if(params?.token)
				tok=PersistToken.findByToken(params?.token)

			if(tok || springSecurityService.isLoggedIn()){

				usr=usr!=null?usr:EmployUser.findByUsername(tok.username)
				if(usr){

					def v=Vehicle.findByTaxistas(usr)
					render(contentType:'text/json',encoding:"UTF-8") {
						status=100
						firstName=usr.firstName
						lastName=usr.lastName
						phone=usr.phone
						email=usr.email
						marca=v.marca
						patente=v.patente
						modelo=v.modelo
					}

				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def forgotPassword = {

		String username = params.email
		if (!username) {
			render(contentType:'text/json',encoding:"UTF-8") { status=14 }
			return
		}

		def user = User.findByUsername(username)
		if (!user) {
			render(contentType:'text/json',encoding:"UTF-8") { status=15 }
			return
		}

		def registrationCode = new RegistrationCode(username: user.username).save(flush:true)

		String url = generateLink('resetPassword', [t: registrationCode.token])
		def conf = SpringSecurityUtils.securityConfig
		def body =  g.render(template:"/emailconfirmation/confirmationPassword", model:[usr: user,url:url]).toString()


		emailService.send(user.email, conf.ui.register.emailFrom, "Nueva contraseña de DINEROTAXI.COM",  body.toString())
		render(contentType:'text/json',encoding:"UTF-8") { status=100 }
	}

	protected String generateLink(String action, linkParams) {
		createLink(base: "$request.scheme://$request.serverName:$request.serverPort$request.contextPath",
		controller: 'register', action: action,
		params: linkParams)

	}

	def version = {
		print params
		Double vers=new Double(1.6)
		def stat=1
		if(params?.device){
			if(UserDevice.IPHONE.toString().equals(params?.device)){
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
					version_code=357
					status=100
					content="Version 3.5.9 <p>Bug Fixing:</p>" }
				return;
			}
		}
		render(contentType:'text/json',encoding:"UTF-8") { status=stat }
	}
	def displayDriverLogo = {
		def usr=User.get(params?.id)
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
	}

	def displayDriverLogoByEmail = {
		def usr=User.findByEmail(params?.email)
		if(!usr){
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
	}
	def uploadDriverPhoto={
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

			def adminRole=Role.findByAuthority("ROLE_ADMIN")
			if (!usr.authorities.contains(adminRole)){
				response.setStatus(416)
				render(contentType: 'text/json',encoding:"UTF-8") { status=416}
				return false
			}
			def driver=EmployUser.findByEmail(params?.email)
			if(driver){
				def prof=Profile.findByUsr(driver)?:new Profile(usr:driver)
				prof.filePayload=((byte[]) decodeToImage(params.image))
				prof.save()
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

	def uploadPhotoCropped={
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
			def driver=EmployUser.get(params?.employ_id)
			if(usr && driver){
				def prof=Profile.findByUsr(driver)?:new Profile(usr:driver)
				prof.filePayload=((byte[]) decodeToImage(params.image))
				prof.save()
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
				prof.save()
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
}
class DeviceCommand {
	String token
	String keyValue;
	String description;
	UserDevice dev
	static constraints = {
		keyValue blank: false,nullable:false
		description blank: true,nullable:true
	}
}
