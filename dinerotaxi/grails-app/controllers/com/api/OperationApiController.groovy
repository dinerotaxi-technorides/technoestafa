
package com.api

import static grails.async.Promises.*
import static groovyx.net.http.ContentType.URLENC
import grails.converters.JSON
import groovyx.net.http.RESTClient

import javax.servlet.*
import javax.servlet.http.*

import org.codehaus.groovy.grails.commons.*

import ar.com.favorites.*
import ar.com.goliath.*
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.*

import com.*
import com.api.utils.*
class OperationApiController {
	def springSecurityService
	def utilsApiService
	def operationApiService
	def notificationService
	def technoRidesDelayOperationService
	def createTrip = {
		def usr = null
		if(params?.token){
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
				return
			}
		}else{
			render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
			return
		}

		if(!usr?.email){
			render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			return
		}

		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false

		}
		if(!usr.enabled){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		if(usr.accountExpired){
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return false
		}
		if(usr.accountLocked){
			render(contentType: 'text/json',encoding:"UTF-8") { status=414}
			return false
		}
		if(usr.passwordExpired){
			render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
			return false
		}
		if(!params?.addressFrom){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return
		}

		if(!params?.options){
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return
		}
		if(!params?.device){
			render(contentType: 'text/json',encoding:"UTF-8") { status=414 }
			return
		}
		def addressFrom=JSON.parse(params?.addressFrom)
		def addressTo=null;
		if(params?.addressTo && !params?.addressTo.equals(""))
			addressTo=JSON.parse(params?.addressTo)
		def options=JSON.parse(params?.options)
		def device=JSON.parse(params?.device)
		def businessModel = utilsApiService.getBusiness(usr)
		if(params?.businessModel){
			def business=  BUSINESSMODEL.valueOf(params?.businessModel)
			if(business){
				businessModel = business
			}

		}

		try{

			Device.findAllByUser(usr).each{ it.delete() }
			def devic=utilsApiService.setDevice(device?.userType , device?.deviceKey,usr)
			def operation = null
			operation = operationApiService.checkOperation(usr)
			if (operation){
				render(contentType: 'text/json',encoding:"UTF-8") {
					status    = 100
					opId      = operation[0].id?:0
					opList    = operation
					countTrip = params.count_trip
					error     = "Activated Option only one trip per customer!!"
				}
				return
			}

			def count_trip = params.count_trip?Integer.valueOf(params.count_trip) : 1
			def op_list = []

			while (count_trip>=1) {
				operation = create_trip(businessModel,usr,addressFrom,
					addressTo,options,devic,request.getRemoteAddr(),params)
				op_list.add(operation.id)
				count_trip -= 1
			}
			response.setStatus(200)
			render(contentType: 'text/json',encoding:"UTF-8") {
				status=100
				opId=operation.id
				opList = op_list
				countTrip = params.count_trip
			}
			response.setContentType("application/json;charset=utf-8")
		}catch( Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType: 'text/json',encoding:"UTF-8") {
				status=11
				opId=1
			}
		}
	}


	def create_trip(def businessModel,def usr,def addressFrom,def addressTo,def options,def devic,def ip,def args){
		def operation = null

		if(usr instanceof RealUser){
			operation=operationApiService.createFavoriteAndOperation(businessModel,usr,addressFrom,
				addressTo,options,devic,ip,args)
		}else{
			operation=operationApiService.createOperationCC(businessModel,usr,addressFrom,
				addressTo,options,devic,request.getRemoteAddr(),args)
		}
		boolean postOper = operationApiService.sendToSocket(operation)
		log.error postOper
		operation.sendToSocket=postOper
		operation.save(flush:true)
		return operation
	}

	def createTripWithFavorite={
		try{
			def usr=null
			if(params?.token){
				def tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
					return
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
				return
			}

			if(usr){

				def operation = operationApiService.checkOperation(usr)
				if (operation){
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						opId      = operation[0].id?:0
						error     = "Activated Option only one trip per customer!!"
					}
					return
				}
				def oper1= Operation.get(params?.id)
				def fav= TemporalFavorites.get(oper1?.favorites?.id)
				if(fav){

					def dvce=Device.findAllByUser(usr)
					dvce.each{ it.delete() }

					def devic=new Device()

					if(params?.dev && params?.keyValue){
						devic.keyValue=params?.keyValue
						devic.description=""
						devic.dev=params?.dev
						devic.user=usr
						devic.save(flush:true)
					}else{
						devic.keyValue="sin key osea web"
						devic.description="  "
						devic.dev=UserDevice.WEB
						devic.user=usr
						devic.save(flush:true)
					}
					def oper=null
					if(usr instanceof CorporateUser){
						oper=new OperationCompanyPending(user:usr,favorites:fav)
						if(usr?.costCenter?.corporate){
							oper.corporate=usr?.costCenter?.corporate
						}
						oper.costCenter=usr.costCenter
						oper.isCompanyAccount=true

					}else{
						oper=new OperationPending(user:usr,favorites:fav)
						oper.isCompanyAccount=false

					}


					def businessModel = utilsApiService.getBusiness(usr)
					if(params?.businessModel){
						def business=  BUSINESSMODEL.valueOf(params?.businessModel)
						if(business){
							businessModel = business
						}

					}
					oper.businessModel  = businessModel
					oper.status = TRANSACTIONSTATUS.PENDING

					oper.options=oper1.options
					oper.isTestUser=false
					oper.company=usr?.rtaxi
					oper.dev=devic.dev
					oper.sendToSocket=false
					try {
						if (oper1.amount!=null && oper1.amount >0)
							oper.amount =oper1.amount
					} catch (Exception e) {
						e.printStackTrace()
					}
					oper.isTestUser=usr.isTestUser
					oper.dev=devic.dev
					oper.sendToSocket=true
					if(!oper.save(flush:true)){
						render(contentType: 'text/json',encoding:"UTF-8") { status=123 }
						return
					}
					boolean postOper = operationApiService.sendToSocket(oper)

					oper.sendToSocket=postOper
					oper.save(flush:true)
					log.error postOper
					response.setStatus(200)
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						opId=oper.id
					}
					response.setContentType("application/json;charset=utf-8")
				}else if(fav.placeFrom.streetNumber==null){

					render(contentType: 'text/json',encoding:"UTF-8") { status=9 }
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=8 }

				}

			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def searchRtaxi(def usr){
		//		usr.refresh()
		def rtaxi=null
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		if ( usr.authorities.contains(companyRole) ){
			rtaxi = usr
		}else {
			rtaxi = User.get(usr?.rtaxi?.id)
		}
		return rtaxi
	}
	def delay_operations = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			if(usr){
				def techno= technoRidesDelayOperationService.getDelayOperationsByUser(params, usr)
				render techno.toString()
				return
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=222 }
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def cancelProgrammedTrip={
		def usr=null
		if(params?.token){
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}
		}else{
			render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
			return
		}
		if(!params?.id){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return
		}
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return
		}
		def delay=DelayOperation.get(params?.id)
		if(!delay){
			render(contentType: 'text/json',encoding:"UTF-8") { status=404 }
			return
		}

		if(delay.user==usr){
			delay.status =TRANSACTIONSTATUS.CANCELED
			delay.save()
			render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
			return
		}else{
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return
		}

	}
	def programmedTrip={
		def usr=null
		if(params?.token){
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}
		}else{
			render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
			return
		}

		if(!params?.addressFrom){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return
		}

		if(!params?.options){
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return
		}
		if(!params?.device){
			render(contentType: 'text/json',encoding:"UTF-8") { status=414 }
			return
		}
		if(!usr?.email){
			render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			return
		}
		def addressFrom=JSON.parse(params?.addressFrom)
		def addressTo=null;
		if(params?.addressTo && !params?.addressTo.equals(""))
			addressTo=JSON.parse(params?.addressTo)
		def options=JSON.parse(params?.options)
		def device=JSON.parse(params?.device)
		try{

			Device.findAllByUser(usr).each{ it.delete() }
			def devic=utilsApiService.setDevice(device?.userType , device?.deviceKey,usr)
			def operation=null

			boolean isRealAccount=usr instanceof RealUser

			def businessModel = utilsApiService.getBusiness(usr)
			if(params?.businessModel){
				def business=  BUSINESSMODEL.valueOf(params?.businessModel)
				if(business){
					businessModel = business
				}

			}
			operation=technoRidesDelayOperationService.createFavoriteAndOperation(businessModel, usr,addressFrom,addressTo,
				options,params?.comments,devic,params?.executionTime,
				!isRealAccount,params?.payment_reference,params?.driver_number,
				request.getRemoteAddr(),false, params?.amount, params.timeDelayExecution)
			response.setStatus(200)
			render(contentType: 'text/json',encoding:"UTF-8") {
				status=100
				opId=operation.id
			}
			response.setContentType("application/json;charset=utf-8")
		}catch( Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType: 'text/json',encoding:"UTF-8") {
				status=11
				opId=1
			}
		}
	}


	def getMilles={
		def usr=null
		if(params?.token){
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}
		}else{
			response.setStatus(410)
			render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
			return false
		}

		if(!usr){
			response.setStatus(411)
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false

		}
		if(!usr.enabled){
			response.setStatus(412)
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		if(usr.accountExpired){
			response.setStatus(413)
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return false
		}
		if(usr.accountLocked){
			response.setStatus(414)
			render(contentType: 'text/json',encoding:"UTF-8") { status=414}
			return false
		}
		if(usr.passwordExpired){
			response.setStatus(415)
			render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
			return false
		}
		def operaioncrit=Operation.createCriteria()
		def operations = operaioncrit.list() {
			and{
				isNotNull('taxista')
				eq('user',usr )
				or{
					eq('status',TRANSACTIONSTATUS.CALIFICATED)
					eq('status',TRANSACTIONSTATUS.COMPLETED)
				}
			}
		}
		render(contentType: 'text/json',encoding:"UTF-8") {
			status=100
			miles=operations.size()
		}
		return false
	}

	def getBalance={
		def usr=null
		if(params?.token){
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}
		}else{
			response.setStatus(410)
			render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
			return false
		}

		if(!usr){
			response.setStatus(411)
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false

		}
		if(!usr.enabled){
			response.setStatus(412)
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		if(usr.accountExpired){
			response.setStatus(413)
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return false
		}
		if(usr.accountLocked){
			response.setStatus(414)
			render(contentType: 'text/json',encoding:"UTF-8") { status=414}
			return false
		}
		if(usr.passwordExpired){
			response.setStatus(415)
			render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
			return false
		}
		def operaioncrit=Operation.createCriteria()
		def operations = operaioncrit.get {
			and{
				eq("user",usr)
			}
			projections { sum "amount" }
		}
		render(contentType: 'text/json',encoding:"UTF-8") {
			status=100
			balance=operations
		}
		return false
	}
	def confirmAmount={
		def usr=null
		def status= 100
		if(params?.token){
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}
		}else{
			render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
			return false
		}

		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false

		}
		if(!usr.enabled){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		if(usr.accountExpired){
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return false
		}
		if(usr.accountLocked){
			render(contentType: 'text/json',encoding:"UTF-8") { status=414}
			return false
		}
		if(usr.passwordExpired){
			render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
			return false
		}
		if(!params?.confirmed){
			render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
			return false
		}


		def operationInstance = Operation.get(params.opId)
		if(operationInstance){
			if (operationInstance.user==usr){
				status=100
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
			}
		}else{
			render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
		}
		render(contentType: 'text/json',encoding:"UTF-8") {
			status=100
		}
		return false
	}
	def inTransactionTrip={
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
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def id=params?.id
					def operationInstance = Operation.get(params.id)
					if(operationInstance){
						if (operationInstance.user==usr){

							try {
								operationInstance.status=TRANSACTIONSTATUS.INTRANSACTION
								operationInstance.save(flush:true)
								notificationService.notificateOnTripInTransactionForRadioTaxi(operationInstance,false)
								render(contentType: 'text/json',encoding:"UTF-8") {
									opId=operationInstance.id.toString()
									status=100
								}
							}
							catch (org.springframework.dao.DataIntegrityViolationException e) {
								render(contentType: 'text/json',encoding:"UTF-8") { status=123 }
							}

						}else{
							render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def finishTrip={
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
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def id=params?.id
					def operationInstance = Operation.get(params.id)
					if(operationInstance){
						if (operationInstance.user==usr){

							try {
								if(operationInstance?.isCompanyAccount){
									Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
											[cClass: OperationCompanyHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.COMPLETED])
								}else{
									Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
											[cClass: OperationHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.COMPLETED])
								}

								notificationService.notificateOnTripFinishForRadioTaxi(operationInstance,false)
								render(contentType: 'text/json',encoding:"UTF-8") {
									opId=operationInstance.id.toString()
									status=100
								}
							}
							catch (org.springframework.dao.DataIntegrityViolationException e) {
								render(contentType: 'text/json',encoding:"UTF-8") { status=123 }
							}

						}else{
							render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def calificateTrip={
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
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def opId=params?.opId
					def comen=params?.comments?:""
					if(params?.rating){
						def calif=Integer.valueOf(params?.rating)
						def operationInstance= Operation.get(opId)
						if(operationInstance){
							if (operationInstance.user==usr){
								def hasCalif=Calification.findAllByOperation(operationInstance)
								if(!hasCalif){
									operationInstance.stars=calif
									operationInstance.status=TRANSACTIONSTATUS.CALIFICATED
									operationInstance.save(flush:true)

									def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.CALIFICATED)
									trackOperation.operation=operationInstance
									trackOperation.save(flush:true)

									render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
								}else{
									render(contentType: 'text/json',encoding:"UTF-8") { status=129 }
								}
							}else{
								render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
							}
						}else{
							render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
						}

					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=127 }
					}

				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def getOperationInfo={
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=RealUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}

		if(!params?.opId){
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return false
		}
		def oper=Operation.get(Long.valueOf(params?.opId))
		if(!oper || oper.user!=usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=414 }
			return false
		}
		oper.refresh()
		def operationJSON=generateOperationJson(oper)
		render(contentType: 'text/json',encoding:"UTF-8") {
			operation=operationJSON
			status=100
		}
		return false

	}
	def generateOperationJson(operation){
		def jsonBuilder = new groovy.json.JsonBuilder()
		boolean cc =operation?.user instanceof CorporateUser
		def userBuilder = jsonBuilder{
			id  operation?.user?.id
			firstName operation?.user?.firstName
			lastName operation?.user?.lastName
			companyName operation?.user?.companyName
			phone operation?.user?.phone
			rtaxi operation?.user?.rtaxi?.id
			lang operation?.user?.rtaxi?.lang?:'es'
			//city operation?.user?.city
			cityName operation?.user?.city?.name
			cityCode operation?.user?.city?.admin1Code
			isFrequent operation?.user?.isFrequent
			isCC cc
		}
		def placeFromBuilder = jsonBuilder{
			street  operation?.favorites?.placeFrom?.street
			streetNumber  operation?.favorites?.placeFrom?.streetNumber
			country  operation?.favorites?.placeFrom?.country
			locality  operation?.favorites?.placeFrom?.locality
			admin1Code  operation?.favorites?.placeFrom?.admin1Code
			locality  operation?.favorites?.placeFrom?.locality
			floor 	operation?.favorites?.placeFromPso
			lat		operation?.favorites?.placeFrom?.lat
			lng		operation?.favorites?.placeFrom?.lng
			appartment  operation?.favorites?.placeFromDto
		}

		def placeToBuilder = jsonBuilder{
			street  operation?.favorites?.placeTo?.street?:''
			streetNumber  operation?.favorites?.placeTo?.streetNumber?:''
			country  operation?.favorites?.placeTo?.country?:''
			locality  operation?.favorites?.placeTo?.locality?:''
			admin1Code  operation?.favorites?.placeTo?.admin1Code?:''
			locality  operation?.favorites?.placeTo?.locality?:''
			floor	operation?.favorites?.placeToFloor?:''
			lat		operation?.favorites?.placeTo?.lat?:0
			lng		operation?.favorites?.placeTo?.lng?:0
			appartment operation?.favorites?.placeToApartment?:''
		}

		def optionsBuilder = jsonBuilder{
			messaging operation?.options?.messaging
			pet operation?.options?.pet
			airConditioning operation?.options?.airConditioning
			smoker operation?.options?.smoker
			specialAssistant operation?.options?.specialAssistant
			luggage operation?.options?.luggage
			airport operation?.options?.airport
			vip operation?.options?.vip
			invoice operation?.options?.invoice
		}
		def operationBuilder = jsonBuilder{
			id operation.id
			status operation.status.toString()
			driver_number operation?.driverNumber?:null
			payment_reference operation?.paymentReference?:''
			lat operation?.favorites?.placeFrom?.lat
			lng operation?.favorites?.placeFrom?.lng
			placeFrom placeFromBuilder
			placeTo placeToBuilder
			user userBuilder
			options optionsBuilder
			comments operation?.favorites?.comments?:""
			device operation?.dev?operation?.dev.toString():"UNDEFINED"
			createdDate utilsApiService.generateFormatedAddressToClient(operation?.createdDate,operation?.user?.rtaxi)
		}
		return operationBuilder

	}
}
