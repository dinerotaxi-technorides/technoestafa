package com.api.technorides.corporate

import uk.co.desirableobjects.sendgrid.SendGridEmail
import uk.co.desirableobjects.sendgrid.SendGridEmailBuilder
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.goliath.corporate.CostCenter
import ar.com.operation.Operation
class TechnoRidesCorporateOperationsApiController extends TechnoRidesValidateCorporateApiController {
	def technoRidesCorporateService
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
	def jq_company_operation_history = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def techno= technoRidesCorporateService.getOperationCompanyHistory(params, rtaxi)
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

			def cost_center = CostCenter.get(params.cost_id)
			if(!cost_center){
				render(contentType:'text/json',encoding:"UTF-8") { status=401 }
				return
			}
			def techno= technoRidesCorporateService.generateReport(params, rtaxi, cost_center)
			def email_p = rtaxi.mailContacto?:'support@technorides.com'
			if (params?.email)
				email_p=params.email
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
}
