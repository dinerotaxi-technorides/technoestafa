package com.api
import grails.converters.JSON
import sun.misc.BASE64Decoder
import ar.com.goliath.*
import ar.com.goliath.api.JsonToken
import ar.com.goliath.corporate.CorporateUser
import ar.com.goliath.driver.charges.ChargesDriverHistory
import ar.com.goliath.driver.charges.CorporateItemDetailDriver
import ar.com.goliath.driver.charges.PrePaidDriverPayment
import ar.com.operation.*

import com.TaxiCommand
class TaxiApiController {
	def exportService
	def springSecurityService
	def rememberMeServices
	def userService
	def notificationService
	def taxiService
	def utilsApiService
	def technoRidesDriverInvoiceService
	def technoRidesBillingService
	// the delete, save and update actions only accept POST requests
	static allowedMethods = [delete:'POST', save:'POST',post:'POST', update:'POST',isAvailable:'POST',login:'GET']


	def getMsg = {
		def tok=PersistToken.findByToken(params?.token)
		if(tok){
			def usr=User.findByUsername(tok.username)
			if(usr && usr.typeEmploy==TypeEmployer.TAXISTA){
				log.debug "taxista logueado "

				def el1=taxiService.getDisponibleTrips(usr,params.float('lat'),params.float('lng'),params?.state )
				if(el1?.id){
					def tripnb=new TaxiTripCommand(el1)
					render(contentType:'text/json',encoding:"UTF-8") {
						trip=tripnb
						status=100
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def getMsgForAceptedTrips = {
		def tok=PersistToken.findByToken(params?.token)

		if(tok){
			def usr=User.findByUsername(tok.username)
			if(usr && usr.typeEmploy==TypeEmployer.TAXISTA){
				def el1=taxiService.getStatusTrip(usr,params.long('opId') ,params.float('lat'),params.float('lng'))
				if(el1?.id){
					def tripnb=new TaxiTripCommand(el1)
					render(contentType:'text/json',encoding:"UTF-8") {
						trip=tripnb
						status=100
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }
				}
			}else{
				log.debug 104
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			log.error 1
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def acceptTravel={
		def tok=PersistToken.findByToken(params?.token)
		def json=new JsonToken();
		log.debug "taxista obteniendo mensaje"
		if(tok){
			def usr=EmployUser.findByUsername(tok.username)
			if(usr && usr.typeEmploy==TypeEmployer.TAXISTA){
				def onl=OnlineDriver.findByDriverAndStatus(usr,FStatus.ONLINE)
				if(params?.id){
					def oper=Operation.get(params?.id)
					if(oper && oper?.taxista==null){
						if(onl){
							oper.taxista=usr
							oper.status=TRANSACTIONSTATUS.ASSIGNEDTAXI
							oper.save(flush:true)
							onl.status=FStatus.OFFLINE
							onl.save(flush:true)
							notificationService.notificateOnTripTaxiSelectByTaxi(oper,oper.user,false)
							notificationService.notificateToRadioTaxiTaxiWasSelected(oper,false)
							json.status=100
						}else{
							json.status=122
						}
					}else{
						json.status=120

					}
				}else{
					json.status=119
				}
			}else{
				json.status=121
			}

		}else{
			json.status=1
		}

		render json as JSON
	}
	def inTransactionTravel={
		def tok=PersistToken.findByToken(params?.token)
		def json=new JsonToken();
		log.debug "taxista obteniendo mensaje"
		if(tok){
			def usr=EmployUser.findByUsername(tok.username)
			if(usr && usr.typeEmploy==TypeEmployer.TAXISTA){
				if(params?.id){
					def oper=Operation.get(params?.id)
					if(oper && oper?.taxista==usr){
						oper.status=TRANSACTIONSTATUS.INTRANSACTION
						oper.save(flush:true)
						notificationService.notificateOnTripTaxiSelectByTaxi(oper,oper.user,false)
						notificationService.notificateOnTripInTransactionForRadioTaxi(oper,false)
						json.status=100
					}else{
						json.status=120

					}
				}else{
					json.status=119
				}
			}else{
				json.status=121
			}

		}else{
			json.status=1
		}

		render json as JSON
	}
	def finishTravel={
		def token=params.token
		def pers=PersistToken.findByToken(token.toString())
		def json=new JsonToken();
		if(pers){
			def usr=EmployUser.findByUsernameAndStatus(pers.username,UStatus.DONE)
			def onl=OnlineDriver.findByDriver(usr)
			if(usr){
				if(params?.id){
					def oper=OperationPending.get(params?.id)
					if(oper){
						oper.status=TRANSACTIONSTATUS.COMPLETED
						oper.save(flush:true)
						if(onl){
							if(oper?.isCompanyAccount){
								Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
										[cClass: OperationCompanyHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.COMPLETED])
							}else{
								Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
										[cClass: OperationHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.COMPLETED])
							}
							onl.status=FStatus.ONLINE
							onl.save(flush:true)
							notificationService.notificateOnTripFinish(oper,oper.user,false)
							notificationService.notificateOnTripFinishForRadioTaxi(oper,false)
							json.status=100
						}else{
							json.status=122
						}
					}else{
						json.status=120

					}
				}else{
					json.status=119
				}
			}else{
				json.status=121
			}

		}else{
			json.status=1
		}
		render json as JSON
	}
	def cancelTravel={
		def token=params.token
		def pers=PersistToken.findByToken(token.toString())
		def json=new JsonToken();
		if(pers){
			def usr=EmployUser.findByUsernameAndStatus(pers.username,UStatus.DONE)
			def onl=OnlineDriver.findByDriver(usr)
			if(usr){
				if(params?.id){
					def oper=OperationPending.get(params?.id)
					if(oper){
						if(onl){
							if (!oper.blackListUsers.contains(usr)) {
								BlackListOperation.create usr, oper
							}
							onl.status=FStatus.ONLINE
							onl.save(flush:true)
							json.status=100
						}else{
							json.status=122
						}
					}else{
						json.status=120

					}
				}else{
					json.status=119
				}
			}else{
				json.status=121
			}

		}else{
			json.status=1
		}

		render json as JSON
	}
	def pullDriver={
		def onl=OnlineDriver.findByDriver(usr)
		if(onl){
			onl.lat=params.float('lat')
			onl.lng=params.float('lng')
			onl.lastModifiedDate = new Date()
			if(params?.status)
				onl.status=params?.status
			if(params?.driverCode)
				onl.driverCode=params?.driverCode
			if(params?.driverVersion)
				onl.driverVersion=params?.driverVersion
			onl.save(flush:true)
		}else{
			def newOnlineTaxi=new OnlineDriver(lat:params.float('lat'),lng:params.float('lng'),driver:usr,company:usr?.employee,status:FStatus.ONLINE).save(flush:true)
		}
		render(contentType: 'text/json',encoding:"UTF-8") { status=200}

	}
	def getInfoForTransaction={
		def usr=null
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
		def f = Operation.get(params?.id)
		if(f){
			def v = Vehicle.findByTaxistas(f.taxista)
			render(contentType:'text/json',encoding:"UTF-8") {
				status = 100
				opid   = f?.id
				state  = f?.status? f?.status.toString():""

				firstName = f?.taxista?.firstName?:""
				lastName  = f?.taxista?.lastName?:""
				email     = f?.taxista?.email?:""

				driverNumber  = f?.taxista?.email?f?.taxista?.email.split("@")[0]:""
				plate         = v?.patente?:""
				timeEstimated = f?.timeTravel?:""

				taxiLat = 0
				taxiLng = 0
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=100 }
		}
	}
	def getTaxiInformation={
		def usr=null
		if (springSecurityService.isLoggedIn()){
			def prin= springSecurityService.currentUser
			usr=RealUser.findByUsernameAndRtaxi(prin.username,prin?.rtaxi?User.get(prin.rtaxi):null)

		}
		def tok=null
		if(params?.token){
			tok=PersistToken.findByToken(params?.token)
			if(tok){
				usr=RealUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}
		}
		if(tok || springSecurityService.isLoggedIn()){
			if(usr){
				def f=Operation.get(params?.id)
				if(f){
					def res=new TaxiCommand()
					if(f?.intermediario){
						res.nombre= f.taxista.firstName+" "+ f.taxista.lastName
						def v=Vehicle.findByTaxistas(f.taxista)
						if(v){
							res.marca=v.marca
							res.patente=v.patente
							res.modelo=v.modelo
						}
						def com=Company.get(f.intermediario.employee.id)
						if(com){
							res.empresa= com.companyName
						}
						res.numeroMovil=f.taxista.email.split("@")[0]
					}else{
						res.nombre= f.taxista.firstName+" "+ f.taxista.lastName
						def v=Vehicle.findByTaxistas(f.taxista)
						if(v){
							res.marca=v.marca
							res.patente=v.patente
						}
					}
					render(contentType:'text/json',encoding:"UTF-8") {
						status=100
						datos=res
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }
				}

			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
			}
		}else{
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

				if( firstName && lastName){
					usr.firstName=firstName
					usr.lastName=lastName
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
		if( profile?.filePayload){
			response.contentType = "image/jpeg"
			response.contentLength = profile?.filePayload.length
			response.outputStream.write(profile?.filePayload)
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=4 }

		}

	}
	def checkBalance ={
		try{
			def usr=null
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}
			if(usr){
				technoRidesBillingService.processDriverPayment(Company.get(tok.rtaxi), usr)
				def balance_amount = 0
				def payments = PrePaidDriverPayment.findAllByDriverAndStatus(usr,'PAID')
				for(payment in payments)
					balance_amount = balance_amount + payment.amountUnused
				def owned = CorporateItemDetailDriver.findAllByDriverAndStatusNotEqual(usr,'PAID')
				def owns  = ChargesDriverHistory.findAllByDriverAndStatusNotEqual(usr,'PAID')
				def total_owned = owned?owned.total.sum():0d
				def total_owns  = owns?owns.total.sum():0d
				balance_amount = balance_amount + total_owned
				balance_amount = balance_amount - total_owns

				def balance_amount_p = 0
				if (balance_amount>0)
					balance_amount_p = balance_amount
				render(contentType:'text/json',encoding:"UTF-8") {
					status=200
					balance      =balance_amount
					balance_total=balance_amount
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}

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
	def getUserOperationInfo={
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}

		if(!params?.opId){
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return false
		}
		def oper=Operation.get(params?.opId)
		oper.refresh()
		if(!oper || oper.taxista!=usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=414 }
			return false
		}
		def operationJSON=generateOperationJson(oper)
		render(contentType: 'text/json',encoding:"UTF-8") {
			operation=operationJSON
			status=100
		}
		return false

	}

	def getOperationHistory ={
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def sortIndex   = params.sidx ?: 'id'
		def sortOrder   = params.sord ?: 'desc'
		def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
		def currentPage = params?.page? Integer.valueOf(params.page) : 1

		def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def usersCriterea = CorporateUser.createCriteria()

		Calendar cal = Calendar.getInstance();
		Calendar calTo = Calendar.getInstance();
		calTo.add(Calendar.DATE, 1)
		cal.add(Calendar.DATE, -15)
		def customers = Operation.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('taxista', usr)
			between('createdDate',cal.getTime(),calTo.getTime())
			order(sortIndex, sortOrder)
		}

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect { generateOperationJson(it) }
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		render jsonData as JSON
	}

	def getContactList ={
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def rtaxi=searchRtaxi(usr)
		def sortIndex   = params.sidx ?: 'id'
		def sortOrder   = params.sord ?: 'desc'
		def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
		def currentPage = params?.page? Integer.valueOf(params.page) : 0

		def rowOffset     = currentPage == 0 ? 0 : currentPage * maxRows
		def customers = EmployUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi', rtaxi)
			ne('id',usr.id)

			if( !params.searchField.isEmpty()){
				ilike("username", params.searchField+"%")
			}
			if( params?.type && !params.type.isEmpty()){
				TypeEmployer emp = TypeEmployer.valueOf(params.type)
				if(emp !=null){
					eq("typeEmploy",emp  )
				}
			}
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect { generatUserJson(it) }
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:200]
		render jsonData as JSON
	}
	def getCountPendingOperation ={
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def rtaxi=searchRtaxi(usr)

		Calendar calDelayTo = Calendar.getInstance();
		calDelayTo.set(Calendar.SECOND,-30)
		def operation_count = Operation.createCriteria().list() {
			eq('company', usr.rtaxi)
			le('createdDate',calDelayTo.getTime())
			eq('status', TRANSACTIONSTATUS.PENDING)
		}
		operation_count = operation_count.collect{ it.id }


		Calendar cal = Calendar.getInstance();
		Calendar dateTo = Calendar.getInstance();
		def find_execution_time = rtaxi?.wlconfig?.timeDelayTrip?:30
		dateTo.add(Calendar.MINUTE, find_execution_time+10);


		def delay_count = DelayOperation.createCriteria().list() {
			eq('company', usr.rtaxi)
			eq('status', TRANSACTIONSTATUS.PENDING)
			between('executionTime',cal.getTime(),dateTo.getTime())
			isNull('taxista')
		}

		delay_count = delay_count.collect{ it.id }

		def jsonData= [
			operations_count: 0,
			operations_count_last_min: 0,
			delay_counts:0,
			delay_counts_last_min:0,
			operations: operation_count,
			delay_operations:delay_count,
			status:100]
		render jsonData as JSON
	}
	def getOperationPending ={
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def sortIndex   = params.sidx ?: 'id'
		def sortOrder   = params.sord ?: 'desc'
		def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
		def currentPage = params?.page? Integer.valueOf(params.page) : 1

		def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		Calendar cal = Calendar.getInstance();
		cal.add( Calendar.SECOND, -30 );
		def customers = Operation.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('company', usr.rtaxi)
			eq('status', TRANSACTIONSTATUS.PENDING)
			lt('createdDate',cal.getTime())
			order(sortIndex, sortOrder)
		}

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect { generateOperationJson(it) }
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		render jsonData as JSON
	}
	def getOperationQueue ={
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def sortIndex   = params.sidx ?: 'status'
		def sortOrder   = params.sord ?: 'desc'
		def maxRows     = params?.rows? Integer.valueOf(params.rows) : 25
		def currentPage = params?.page? Integer.valueOf(params.page) : 1

		def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		Calendar cal = Calendar.getInstance();
		cal.add( Calendar.SECOND, -22 );
		def customers = Operation.createCriteria().list(max:maxRows, offset:rowOffset) {

			eq('company', usr.rtaxi)
			'in'('status', [TRANSACTIONSTATUS.IN_QUEUE,TRANSACTIONSTATUS.PENDING])
			lt('createdDate',cal.getTime())
			order(sortIndex, sortOrder)
		}

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect { generateOperationJsonInQueue(it) }
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		render jsonData as JSON
	}

	def getPendingOperationScheduled ={
		try {
			def tok=PersistToken.findByToken(params.token)
			if(!tok){
				render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
				return false
			}
			def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(!usr){
				render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
				return false
			}

			def rtaxi=searchRtaxi(usr)
			def sortIndex   = params.sidx ?: 'id'
			def sortOrder   = params.sord ?: 'desc'
			def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
			def currentPage = params?.page? Integer.valueOf(params.page) : 1

			def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

			def usersCriterea = CorporateUser.createCriteria()

			Calendar cal = Calendar.getInstance();
			Calendar dateTo = Calendar.getInstance();
			def find_execution_time = rtaxi?.wlconfig?.timeDelayTrip?:30
			dateTo.add(Calendar.MINUTE, find_execution_time+10);
			def customers = DelayOperation.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq('company', usr.rtaxi)
				eq('status', TRANSACTIONSTATUS.PENDING)
				isNull('taxista')
				between('executionTime',cal.getTime(),dateTo.getTime())
				order(sortIndex, sortOrder)
			}


			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				def pojo = generateDelayOperationJson(it)
				pojo.executionTime = utilsApiService.generateFormatedAddressToClient(it?.executionTime,it?.user)
				return pojo
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
			render jsonData as JSON
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=200 }
		}

	}

	def getOperationScheduled ={
		try {
			def tok=PersistToken.findByToken(params.token)
			if(!tok){
				render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
				return false
			}
			def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(!usr){
				render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
				return false
			}
			def sortIndex   = params.sidx ?: 'id'
			def sortOrder   = params.sord ?: 'desc'
			def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
			def currentPage = params?.page? Integer.valueOf(params.page) : 1

			def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

			def usersCriterea = CorporateUser.createCriteria()

			def customers = DelayOperation.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq('taxista', usr)
				eq('status',TRANSACTIONSTATUS.PENDING)
				order(sortIndex, sortOrder)
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				def pojo = generateDelayOperationJson(it)
				pojo.executionTime = utilsApiService.generateFormatedAddressToClient(it?.executionTime,it?.user)
				return pojo
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
			render jsonData as JSON
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=200 }
		}


	}

	def acceptDelayTrip = {
		try{
			def tok=PersistToken.findByToken(params.token)
			if(!tok){
				render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
				return false
			}
			def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(!usr){
				render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
				return false
			}
			def delayOperation=DelayOperation.get(params?.id)
			if(delayOperation && delayOperation.status == TRANSACTIONSTATUS.PENDING){
				try {
					delayOperation.driverNumber =Integer.valueOf(usr.email.split("@")[0])
					delayOperation.taxista =usr
					delayOperation.save()
					render(contentType:'text/json',encoding:"UTF-8") {
						status=100
						opId=delayOperation?.id
					}
				} catch (Exception e) {
					e.printStackTrace()
					render(contentType:'text/json',encoding:"UTF-8") { status=401 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=401 }
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def sendToPendingDelayTrip = {
		try{
			def tok=PersistToken.findByToken(params.token)
			if(!tok){
				render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
				return false
			}
			def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(!usr){
				render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
				return false
			}
			def delayOperation=DelayOperation.get(params?.id)
			if(delayOperation && delayOperation.status == TRANSACTIONSTATUS.PENDING){
				try {
					delayOperation.driverNumber =null
					delayOperation.taxista =null
					delayOperation.save()
					render(contentType:'text/json',encoding:"UTF-8") {
						status=100
						opId=delayOperation?.id
					}
				} catch (Exception e) {
					e.printStackTrace()
					render(contentType:'text/json',encoding:"UTF-8") { status=401 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=401 }
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def generatUserJson(EmployUser user){
		def jsonBuilder = new groovy.json.JsonBuilder()
		def typeUserReceiver = 0
		if(user.typeEmploy == user.typeEmploy.MONITOR){
			typeUserReceiver = 2
		}else if(user.typeEmploy == user.typeEmploy.TAXISTA){
			typeUserReceiver = 1
		}else if(user.typeEmploy == user.typeEmploy.TELEFONISTA){
			typeUserReceiver = 3
		}


		def userBuilder = jsonBuilder{
			id  user?.id
			first_name user?.firstName
			last_name user?.lastName
			type_user user?.typeEmploy.toString()
			phone user?.phone
			email user?.email
			type_user_receiver typeUserReceiver
		}

		return userBuilder

	}
	def generateOperationJsonInQueue(operation){
		def op = generateOperationJson(operation)
		Calendar rightNow = Calendar.getInstance();

		if(operation?.queueDate){
			op.queueDate = rightNow.getTime().getTime() - operation?.queueDate.getTime();
			if(op.queueDate<0){
				op.queueDate = 0
			}
		}else{
			op.queueDate = 0
		}
		return op
	}

	def generateOperationJson( operation){
		def jsonBuilder = new groovy.json.JsonBuilder()
		boolean cc =operation?.user instanceof CorporateUser
		def driver_id = ""
		def company_name = ""
		if(operation?.corporate?.name)
			company_name=operation?.corporate?.name
		if(operation.taxista)
			driver_id = operation.taxista.email.split("@")[0]
		def userBuilder = jsonBuilder{
			id  operation?.user?.id
			firstName operation?.user?.firstName
			lastName operation?.user?.lastName
			companyName company_name
			phone operation?.user?.phone
			rtaxi operation?.user?.rtaxi?.id
			lang operation?.user?.rtaxi?.lang?:'es'
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
			driver_assigned driver_id
			payment_reference operation?.paymentReference?:''
			lat operation?.favorites?.placeFrom?.lat
			lng operation?.favorites?.placeFrom?.lng
			placeFrom placeFromBuilder
			placeTo placeToBuilder
			user userBuilder
			options optionsBuilder
			comments operation?.favorites?.comments?:""
			device operation?.dev?operation?.dev.toString():"UNDEFINED"
			amount operation?.amount
			type cc?1:0
			createdDate utilsApiService.generateFormatedAddressToClient(operation?.createdDate,operation?.user)
		}
		return operationBuilder

	}
	def generateDelayOperationJson( operation){
		def jsonBuilder = new groovy.json.JsonBuilder()
		boolean cc =operation?.user instanceof CorporateUser
		def driver_id = ""
		def company_name = ""
		if(operation.taxista)
			driver_id = operation.taxista.email.split("@")[0]
		def userBuilder = jsonBuilder{
			id  operation?.user?.id
			firstName operation?.user?.firstName
			lastName operation?.user?.lastName
			companyName company_name
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
			driver_assigned driver_id
			payment_reference operation?.paymentReference?:''
			lat operation?.favorites?.placeFrom?.lat
			lng operation?.favorites?.placeFrom?.lng
			placeFrom placeFromBuilder
			placeTo placeToBuilder
			user userBuilder
			options optionsBuilder
			comments operation?.favorites?.comments?:""
			device operation?.dev?operation?.dev.toString():"UNDEFINED"
			amount operation?.amount
			type cc?1:0
			createdDate utilsApiService.generateFormatedAddressToClient(operation?.createdDate,operation?.user)
		}
		return operationBuilder

	}
	def chargeInvoices = {
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def sortIndex   = params.sidx ?: 'id'
		def sortOrder   = params.sord ?: 'desc'
		def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
		def currentPage = params?.page? Integer.valueOf(params.page) : 1

		def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = ChargesDriverHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('driver',usr)
			ne('status','PAID')
			gt('total',0d)
			order(sortIndex, sortOrder)
		}


		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {ChargesDriverHistory dh -> chargeInvoicesOperationJson(dh) }
		print jsonCells
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		render jsonData as JSON
	}
	def payReceipts = {

		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def sortIndex   = params.sidx ?: 'id'
		def sortOrder   = params.sord ?: 'desc'
		def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
		def currentPage = params?.page? Integer.valueOf(params.page) : 1

		def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = CorporateItemDetailDriver.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('driver',usr)
			ne('status','PAID')
			order(sortIndex, sortOrder)
		}


		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect { payRecipentsOperationJson(it) }
		print jsonCells
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		render jsonData as JSON
	}

	def balanceDriver = {
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=EmployUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}

		def owned = CorporateItemDetailDriver.findAllByDriverAndStatusNotEqual(usr,'PAID')
		def owns  = ChargesDriverHistory.findAllByDriverAndStatusNotEqual(usr,'PAID')
		def total_owned = owned?owned.total.sum():0d
		def total_owns  = owns?owns.total.sum():0d

		def jsonData = [
			status:100,
			debit:total_owns,
			credit:total_owned]
		render jsonData as JSON
	}

	def balance_account = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		print tok.rtaxi
		def rtaxi=Company.get(tok.rtaxi)
		if(rtaxi == null){
			render(contentType:'text/json',encoding:"UTF-8") { status=412 }
			return
		}
		def stat = technoRidesDriverInvoiceService.driverPay(usr.id, usr, rtaxi)
		render(contentType:'text/json',encoding:"UTF-8") { status=stat }
	}

	def chargeInvoicesOperationJson( ChargesDriverHistory item){

		def jsonBuilder = new groovy.json.JsonBuilder()
		def operationBuilder = jsonBuilder{
			id item.id
			status item.status
			invoiceId item?.invoiceId?:null
			customerNotes item?.customerNotes?:''
			subTotal item.subTotal?:0
			adjustment item.subTotal?:0
			total item.subTotal?:0
			createdDate utilsApiService.generateFormatedAddressToClient(item?.createdDate,item?.driver)
			chargesDate utilsApiService.generateFormatedAddressToClient(item?.chargesDate,item?.driver)
			dueDate    utilsApiService.generateFormatedAddressToClient(item?.dueDate,item?.driver)
		}
		return operationBuilder

	}
	def payRecipentsOperationJson( CorporateItemDetailDriver item){
		def operation = item.operation
		def jsonBuilder = new groovy.json.JsonBuilder()
		boolean cc =operation?.user instanceof CorporateUser
		def driver_id = ""
		if(operation.taxista)
			driver_id = operation.taxista.email.split("@")[0]
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
			id item.id
			status item.status
			driver_number operation?.driverNumber?:null
			driver_assigned driver_id
			payment_reference operation?.paymentReference?:''
			lat operation?.favorites?.placeFrom?.lat
			lng operation?.favorites?.placeFrom?.lng
			placeFrom placeFromBuilder
			placeTo placeToBuilder
			user userBuilder
			options optionsBuilder
			comments operation?.favorites?.comments?:""
			device operation?.dev?operation?.dev.toString():"UNDEFINED"
			amount operation?.amount
			type cc?1:0
			subTotal item.subTotal?:0
			adjustment item.subTotal?:0
			total item.total?:0
			createdDate utilsApiService.generateFormatedAddressToClient(item?.createdDate,operation?.user)
			chargesDate utilsApiService.generateFormatedAddressToClient(item?.chargesDate,operation?.user)
			paidDate    utilsApiService.generateFormatedAddressToClient(item?.paidDate,operation?.user)
		}
		return operationBuilder

	}
	def holdingUser={
		def tok=PersistToken.findByToken(params?.token)
		def company;
		if(tok){
			def usr= User.findByUsername(tok.username)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def userRole=Role.findByAuthority("ROLE_TAXI")
								def userCCRole=Role.findByAuthority("ROLE_TAXI_OWNER")
								company=Company.get(usr.employee.id)
								if (usr.authorities.contains(userRole)||usr.authorities.contains(userCCRole)) {
									def oper= Operation.get(params.id)
									if (oper && oper.company==company &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
										notificationService.notificateOnTripHoldingUser(oper, oper.user,false);

										render(contentType:'text/json',encoding:"UTF-8") { status=100 }
									}else if(oper.company!=company||(oper instanceof OperationHistory) || (oper instanceof OperationCompanyHistory)){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=133 }
									}
								}else {
									render(contentType:'text/json',encoding:"UTF-8") { status=110 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}


}
