package com.api.technorides

import grails.converters.JSON
import uk.co.desirableobjects.sendgrid.SendGridEmail
import uk.co.desirableobjects.sendgrid.SendGridEmailBuilder
import ar.com.goliath.Company
import ar.com.goliath.MailQueue
import ar.com.goliath.PersistToken
import ar.com.goliath.RealUser
import ar.com.goliath.Role
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.goliath.business.BusinessModel
import ar.com.goliath.corporate.CostCenter
import ar.com.operation.BUSINESSMODEL
import ar.com.operation.Operation
import com.Device

class TechnoRidesOperationsApiController extends TechnoRidesValidateApiController {
	def technoRidesOperationService
	def utilsApiService
	def operationApiService
	def sendGridService
	def technoRidesEmailService
	def springDineroTaxiService
	def springSecurityService
	def rememberMeServices

	def addExcept(list) {
		list <<'get'<< 'create_web_trip'<< 'send_contact_mail'//'index' << 'list' << 'show'
	}
	def get={
		Operation.list().each{
			it.company=it.user.rtaxi
			it.save(flush:true)
		}
		render "asd"
	}
	def jq_company_operation_history={
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesOperationService.getOperationCompanyHistory(params, rtaxi)
			render techno
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_company_schedule_operation_history = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesOperationService.getOperationCompanyScheduleHistory(params, rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def generate_report = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesOperationService.generateReport(params, rtaxi)
			def email_p = rtaxi.mailContacto?:'support@technorides.com'
			if(params?.email){
				email_p=params.email
			}
			SendGridEmail email = new SendGridEmailBuilder()
					.from("report@technorides.com")
					.to(email_p)
					.subject("Report").withText("Report Attached").addAttachment(techno).build()
			sendGridService.send(email)
			render(contentType:'text/json',encoding:"UTF-8") { status=100 }
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def get_operation_for_invoice = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesOperationService.getOperationForInvoice(params, rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def get_operation_for_invoice_cost = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def cost_center = CostCenter.get(params.cost_id)
			if(!cost_center || cost_center.rtaxi!=rtaxi){
				render(contentType:'text/json',encoding:"UTF-8") { status=401 }
				return
			}
			def techno= technoRidesOperationService.getOperationForInvoiceCost(params, rtaxi,cost_center)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}


	def jq_operation_history_by_user = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def realUser=User.get(params?.user_id)
			if(realUser){
				def techno= technoRidesOperationService.getOperationsHistoryByUser(params, realUser)
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
	def send_contact_mail={
		def company=Company.get(params?.rtaxi)
		if(!company){
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
			return;
		}
		if(company?.mailContacto){
			render(contentType:'text/json',encoding:"UTF-8") { status=12 }
			return;
		}
		def mail=new MailQueue()
		mail.from=params?.from
		mail.to=company.mailContacto
		mail.subject=params?.subject
		mail.body=params?.body
		if(!mail.save()){
			render(contentType:'text/json',encoding:"UTF-8") { status=13 }
			return;
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
			return;
		}
	}

	def create_trip={
		def state="FAIL"
		def message=""
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def usrJson=JSON.parse(params?.user)
			def optionsJson=JSON.parse(params?.options)
			def addressFrom=JSON.parse(params?.addressFrom)
			def addressTo=JSON.parse(params?.addressTo)
			def device=JSON.parse(params?.device)
			def customer=User.findByUsernameAndRtaxi(usrJson.email,rtaxi)
			Boolean newUser=false;
			if(customer?.email){
				message="Usuario Existente "

				customer.firstName = usrJson.first_name
				customer.lastName  = usrJson.last_name
				customer.phone     = usrJson.phone
				customer.save()
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
				def bs=BusinessModel.findByName("GENERIC")
				if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "Usuario nuevo agregado "
					UserRole.create customer, employeeRole
					utilsApiService.setBusinessModelByRtaxi(customer, rtaxi)
					state = "OK"
				} else {
					customer.errors.each {
						println it
					}
					message = "No se puede guardar el usuario"
				}

			}

			def businessModel = utilsApiService.getBusiness(customer)
			if(params?.businessModel){
				def business=  BUSINESSMODEL.valueOf(params?.businessModel)
				if(business){
					businessModel = business
				}

			}

			Device.findAllByUser(customer).each{ it.delete() }
			def devic=utilsApiService.setDevice(device?.userType , device?.deviceKey,customer)

			def count_trip = params.count_trip?Integer.valueOf(params.count_trip) : 1
			def operation = null
			def op_list = []

			if(!newUser){
				operation = operationApiService.checkOperation(customer)
				if (operation){
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						opId=operation[0].id?:0
						countTrips = params.count_trip
						opList = operation
						messages=message
						error="Activated Option only one trip per customer!!"
					}
					return
				}
			}

			while (count_trip>=1) {
				operation = createTrip(businessModel,usr,customer,addressFrom,addressTo,optionsJson,devic,params,false)
				op_list.add(operation.id)
				count_trip -= 1
			}

			message+="new.op.added"
			render(contentType: 'text/json',encoding:"UTF-8") {
				status=100
				opId=operation.id?:0
				countTrips = params.count_trip
				opList = op_list
				messages=message
			}
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def create_trip_anonymous={
		def state="FAIL"
		def message=""
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?Company.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def addressFrom=JSON.parse(params?.addressFrom)
			def customer=User.findByUsernameAndRtaxi('anonymous@me.com',rtaxi)
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
				customer.username='anonymous@me.com'
				customer.email='anonymous@me.com'
				customer.password=rtaxi?.wlconfig?.app?:'YOURCOMPANY' +"2014"
				customer.firstName='anonymous'
				customer.lastName='anonymous'
				customer.phone='anonymous'
				customer.agree=true
				customer.enabled = true
				customer.politics=true
				customer.city=rtaxi.city
				customer.lang=rtaxi.lang
				def employeeRole=Role.findByAuthority("ROLE_USER")
				if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "Usuario nuevo agregado "
					UserRole.create customer, employeeRole
					state = "OK"
				} else {
					customer.errors.each {
						println it
					}
					message = "No se puede guardar el usuario"
				}

			}
			def id_driver = usr.email.split("@")[0]
			params.comments = "Viaje creado por:${usr.firstName} ${usr.lastName} ID: ${id_driver}"


			def businessModel = utilsApiService.getBusiness(customer)
			if(params?.businessModel){
				def business=  BUSINESSMODEL.valueOf(params?.businessModel)
				if(business){
					businessModel = business
				}

			}

			Device.findAllByUser(customer).each{ it.delete() }
			def devic=utilsApiService.setDevice(null , null,customer)

			def count_trip = params.count_trip?Integer.valueOf(params.count_trip) : 1
			def operation = null
			def op_list = []

			operation = createTrip(businessModel, usr,customer,addressFrom,null,null,devic,params,true)
			op_list.add(operation.id)

			message+="new.op.added"
			render(contentType: 'text/json',encoding:"UTF-8") {
				status=100
				opId=operation.id?:0
				countTrips = params.count_trip
				opList = op_list
				messages=message
			}
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def createTrip(def businessModel, def usr,def customer,def addressFrom,def addressTo,def optionsJson,def devic,def args,boolean sendJob){
		boolean postOper = false
		def operation=null
		if(customer instanceof RealUser){
			print "init Operation"
			operation=technoRidesOperationService.createFavoriteAndOperation(businessModel,usr,customer,addressFrom,addressTo,optionsJson,devic,params)
			print "FINISH"
		}else{
			print"init OperationCC"
			operation=technoRidesOperationService.createOperationCC(businessModel,usr,customer,addressFrom,addressTo,optionsJson,devic,params)
			print "FINISH"
		}
		operation.sendToSocket=postOper
		operation.save(flush:true)
		return operation
	}
}
