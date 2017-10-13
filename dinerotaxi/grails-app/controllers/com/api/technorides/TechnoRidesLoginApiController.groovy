package com.api.technorides

import grails.converters.JSON
import groovy.json.JsonSlurper

import org.springframework.security.core.Authentication

import ar.com.goliath.PersistToken
import ar.com.goliath.Role
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.goliath.api.JsonToken
class TechnoRidesLoginApiController {
	def exportService
	def springDineroTaxiService
	def springSecurityService
	def rememberMeServices
	def userService
	def emailService
	def notificationService
	def userAgentIdentService
	def utilsApiService
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
			usr=User.findByUsernameAndPassword(pojo.email,springSecurityService.encodePassword(pojo.password))
			def companyPojo = null
			if(usr?.rtaxi){
				rtaxiUser= ar.com.goliath.Company.get(usr.rtaxi.id)
				companyName=rtaxiUser?.companyName
				companyPojo = ar.com.goliath.Company.get(usr.rtaxi.id)
			}else{
				companyName=usr?.companyName
				companyPojo = ar.com.goliath.Company.get(usr.id)
			}

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
			if (utilsApiService.checkUserPermisson(usr)){
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
			def lat=0
			def lng=0
			def isRequiredZone=false
			def useAdminCode = false
			def isFareCalculatorActive = false
			def creditCardEnable       = false
			def radio=companyPojo?.wlconfig?.digitalRadio?:false

			def isChatEnabled = false
			if (companyPojo?.wlconfig?.isChatEnabled){
				isChatEnabled=true
			}
			def packageCompany = 'BASIC'
			if (companyPojo?.wlconfig?.packageCompany){
				packageCompany=companyPojo?.wlconfig?.packageCompany
			}
			def driverQuota = 10
			if (companyPojo?.wlconfig?.driverQuota){
				driverQuota=companyPojo?.wlconfig?.driverQuota
			}
			if (companyPojo?.wlconfig?.useAdminCode){
				useAdminCode=true
			}
			if (companyPojo?.wlconfig?.hasRequiredZone){
				isRequiredZone=true
			}
			if (companyPojo?.wlconfig?.isFareCalculatorActive){
				isFareCalculatorActive=true
			}
			if (companyPojo?.wlconfig?.creditCardEnable){
				creditCardEnable=true
			}

			def mapKey = 'AIzaSyDETwlXKIG-v6rZeV_7uWbuWdpB3IThysI'
			if (companyPojo?.wlconfig?.mapKey){
				mapKey=companyPojo?.wlconfig?.mapKey
			}

			def adminCode = companyPojo?.city?.admin1Code?:''
			def countryI   = companyPojo?.city?.country?:''
			def timeZone   = companyPojo?.city?.timeZone?:''
			def countryCode   = companyPojo?.city?.countryCode?:''

			def operator_multiple_trips = (companyPojo?.wlconfig?.operatorDispatchMultipleTrips &&
				companyPojo.wlconfig.operatorDispatchMultipleTrips)
			def operator_suggest_destination = (companyPojo?.wlconfig?.operatorDispatchMultipleTrips &&
				companyPojo.wlconfig.operatorDispatchMultipleTrips)
			def operator_cancelation_reason = (companyPojo?.wlconfig?.operatorCancelationReason)
			def block_multiple_trips = (companyPojo?.wlconfig?.operatorDispatchMultipleTrips &&
				companyPojo.wlconfig.operatorDispatchMultipleTrips)

			if(usr?.rtaxi && usr?.rtaxi?.latitude ){
				lat=usr?.rtaxi?.latitude
				lng=usr?.rtaxi?.longitude
			}else{
				lat=usr?.latitude?:0
				lng=usr?.longitude?:0
			}
			def business_model = []
			if(companyPojo?.businessModel){
				business_model = companyPojo.businessModel.collect(){
					it.name
				}
			}
			def is_pre_paid = false
			if(companyPojo?.wlconfig?.isPrePaidActive)
				is_pre_paid = true
			def show_business_model = business_model.size >1
			def host_name = pojo.email.split("@")[1]
			render(contentType:'text/json',encoding:"UTF-8") {
				email=pojo.email
				host=host_name
				token=tok.token
				package_company=packageCompany
				driver_quota   =driverQuota
				status=100
				lang=usr?.lang?:''
				latitude=lat
				longitude=lng
				country=countryI
				time_zone=timeZone
				admin_code=adminCode
				country_code=countryCode
				id=usr?.id
				is_required_zone=isRequiredZone
				use_admin_code = useAdminCode
				first_name=usr?.firstName
				last_name=usr?.lastName
				company=companyName
				rtaxi=rtaxiUser?.id
				roles= role.join(",")
				digitalRadio=radio
				map_key = mapKey
				operatorDispatchMultipleTrips =operator_multiple_trips
				is_chat_enabled = isChatEnabled
				is_fare_calculator_enabled = isFareCalculatorActive
				credit_card_enable = creditCardEnable
				operatorSuggestDestination =operator_suggest_destination
				operatorCancelationReason  =operator_cancelation_reason
				blockMultipleTrips =block_multiple_trips
				businessModel = business_model
				showBusinessModel = show_business_model
				isPrePaidActive=is_pre_paid
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def getTokenInfo = {
		def tok=null
		if(params?.token){
			tok=PersistToken.findByToken(params?.token)

		}
		if(tok){
			render(contentType:'text/json',encoding:"UTF-8") { status=100 }
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=101 }
		}


	}
	def getCompanyInfo = {
		try{

			def usr =null
			def idUsr=""
			def rtaxiUser
			def role=[]
			def companyName=""
			if(params?.email){
				usr=ar.com.goliath.Company.findByUsername(params?.email)
			}else{
				usr=ar.com.goliath.Company.get(params?.rtaxi)

			}
			if(usr?.rtaxi){
				rtaxiUser= ar.com.goliath.Company.get(usr.rtaxi.id)
				companyName=rtaxiUser?.companyName
			}else{
				companyName=usr?.companyName
			}

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
			render(contentType:'text/json',encoding:"UTF-8") {
				status=100
				lang=usr?.lang?:''
				latitude=usr?.latitude
				longitude=usr?.longitude
				country=usr?.city?.country?:''
				admin_code=usr?.city?.admin1Code?:''
				country_code=usr?.city?.countryCode?:''
				rtaxi=usr?.id
				company=companyName
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
}
