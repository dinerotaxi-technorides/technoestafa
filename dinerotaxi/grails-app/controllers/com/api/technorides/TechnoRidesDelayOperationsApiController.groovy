
package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.RealUser
import ar.com.goliath.Role
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.operation.BUSINESSMODEL
import ar.com.operation.DelayOperation
import ar.com.operation.DelayOperationConfigTime
import ar.com.operation.TRANSACTIONSTATUS

import com.Device
class TechnoRidesDelayOperationsApiController extends TechnoRidesValidateApiController {
	def technoRidesDelayOperationService
	def utilsApiService
	def operationApiService
	def sendGridService
	def technoRidesEmailService
	def addExcept(list) {
		list <<'get' //'index' << 'list' << 'show'
	}
	def get={
		DelayOperation.list().each{
			it.company=it.user.rtaxi
			it.save(flush:true)
		}
		render "asd"
	}
	def jq_delay_operation_by_company = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesDelayOperationService.getDelayOperationsByRtaxi(params, rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_delay_operation_by_user = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def realUser=User.get(params?.user_id)
			if(realUser){
				def techno= technoRidesDelayOperationService.getDelayOperationsByUser(params, realUser)
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
	def edit_trip = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def delayOperation=DelayOperation.get(params?.id)
			if(delayOperation){
				try {
					if (params?.driver_number){
						delayOperation.driverNumber =Integer.valueOf(params.driver_number)
						def driver_str = params.driver_number+'@'+ usr.email.split('@')[1]
						def driver_ff = EmployUser.findByUsername(driver_str)
						delayOperation.taxista =driver_ff
					}
					if (params?.execution_date)
						delayOperation.executionTime = utilsApiService.generateFormatedAddressToServer( params?.execution_date,rtaxi)
					if(params?.timeDelayExecution)
						delayOperation.executionTime = params.timeDelayExecution
						
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
	def delete_trip = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def delayOperation=DelayOperation.get(params?.id)
			if(delayOperation){
				delayOperation.status =TRANSACTIONSTATUS.CANCELED
				delayOperation.save()
				render(contentType:'text/json',encoding:"UTF-8") { 
					status=100 
					opId=params?.id
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
	def create_trip={
		def state="FAIL"
		def message=""
		try{
			def tok=PersistToken.findByToken(params?.token)
			def middleMan=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(middleMan)

			def usrJson=JSON.parse(params?.user)
			def optionsJson=JSON.parse(params?.options)
			def addressFrom=JSON.parse(params?.addressFrom)
			def addressTo=JSON.parse(params?.addressTo)
			def device=JSON.parse(params?.device)
			def customer=User.findByUsernameAndRtaxi(usrJson.email,rtaxi)
			Boolean newUser=false;
			if(customer?.email){
				message="Usuario Existente "
			}else{
				newUser=true
				customer = new RealUser()
				customer.status=UStatus.DONE
				customer.createdDate=new Date()
				customer.validated=UStatus.DONE
				customer.rtaxi=rtaxi
				customer.username=usrJson.email
				customer.email=usrJson.email
				customer.password=rtaxi?.wlconfig?.app?:'YOURCOMPANY' +"2014"
				customer.firstName=usrJson.first_name
				customer.lastName=usrJson.last_name
				customer.phone=usrJson.phone
				customer.agree=true
				customer.enabled = true
				customer.politics=true
				customer.city=rtaxi.city
				customer.lang=rtaxi.lang
				def employeeRole=Role.findByAuthority("ROLE_USER")
				if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "Usuario nuevo agregado "
					UserRole.create customer, employeeRole
					
					utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
					state = "OK"
				} else {
					message = "No se puede guardar el usuario"
				}
			}
			Device.findAllByUser(customer).each{ it.delete() }
			def devic=utilsApiService.setDevice(device?.userType , device?.deviceKey,customer)
			def operation=null
			boolean isRealAccount=customer instanceof RealUser
			def businessModel = utilsApiService.getBusiness(customer)
			if(params?.businessModel){
				def business=  BUSINESSMODEL.valueOf(params?.businessModel)
				if(business){
					businessModel = business
				}
					
			}
			log
			operation = technoRidesDelayOperationService.createFavoriteAndOperation( businessModel, customer,addressFrom,
				addressTo,optionsJson,params?.comments,devic,
				params?.executionTime,!isRealAccount,
				params?.payment_reference,params.driver_number,
				request.getRemoteAddr(), true, params?.amount, params.timeDelayExecution, middleMan)
			message+=" y operacion creada Nro${operation.id}"
			technoRidesEmailService.buildDelayEmailCreateTripWithPhone(operation.id,rtaxi.id,newUser);
			render(contentType: 'text/json',encoding:"UTF-8") {
				status=100
				opId=operation.id
				messages=message
			}
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def editTrip={
		def state="FAIL"
		def message=""
		def delayOperation=DelayOperation.get(params?.id)
		if(delayOperation){
			def tok=PersistToken.findByToken(params?.token)
			def middleMan=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(middleMan)

			def usrJson=JSON.parse(params?.user)
			def optionsJson=JSON.parse(params?.options)
			def addressFrom=JSON.parse(params?.addressFrom)
			def addressTo=JSON.parse(params?.addressTo)
			def device=JSON.parse(params?.device)
			def customer=User.findByUsernameAndRtaxi(usrJson.email,rtaxi)
			Boolean newUser=false;
			if(customer?.email){
				message="Usuario Existente "
			}else{
				newUser=true
				customer = new RealUser()
				customer.status=UStatus.DONE
				customer.createdDate=new Date()
				customer.validated=UStatus.DONE
				customer.rtaxi=rtaxi
				customer.username=usrJson.email
				customer.email=usrJson.email
				customer.password=rtaxi?.wlconfig?.app?:'YOURCOMPANY' +"2014"
				customer.firstName=usrJson.first_name
				customer.lastName=usrJson.last_name
				customer.phone=usrJson.phone
				customer.agree=true
				customer.enabled = true
				customer.politics=true
				customer.city=rtaxi.city
				customer.lang=rtaxi.lang
				def employeeRole=Role.findByAuthority("ROLE_USER")
				if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "Usuario nuevo agregado "
					UserRole.create customer, employeeRole
					
					utilsApiService.setBusinessModelByRtaxi(customer,rtaxi)
					state = "OK"
				} else {
					message = "No se puede guardar el usuario"
				}
			}
			Device.findAllByUser(customer).each{ it.delete() }
			def devic=utilsApiService.setDevice(device?.userType , device?.deviceKey,customer)
			def operation=null
			boolean isRealAccount=customer instanceof RealUser
			def businessModel = utilsApiService.getBusiness(customer)
			if(params?.businessModel){
				def business=  BUSINESSMODEL.valueOf(params?.businessModel)
				if(business){
					businessModel = business
				}
					
			}
			operation = technoRidesDelayOperationService.editTrip(delayOperation, businessModel, customer,addressFrom,
				addressTo,optionsJson,params?.comments,devic,
				params?.executionTime,!isRealAccount,
				params?.payment_reference,params.driver_number,
				request.getRemoteAddr(), true, params?.amount, params.timeDelayExecution, middleMan)
			message+=" y operacion creada Nro${operation.id}"	
			render(contentType: 'text/json',encoding:"UTF-8") {
				status=100
				opId=operation.id
				messages=message
			}
			return
			
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=401 }
		}
	}
	def delay_operation_config_list = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
	
			def rtaxi=searchRtaxi(usr)
			def customers = DelayOperationConfigTime.createCriteria().list() {
				eq('rtaxi',rtaxi)
			}
			def jsonCells = customers.collect {
				[
					name              :it.name,
					timeDelayExecution:it.timeDelayExecution,
					id: it.id]
			}
			def jsonData= [rows: jsonCells,status:100]
			render jsonData as JSON
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def delay_operation_config_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			
			def customers=technoRidesDelayOperationService.editDelayOperationConfig( params, rtaxi)
			render customers.toString()
			return
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
}

