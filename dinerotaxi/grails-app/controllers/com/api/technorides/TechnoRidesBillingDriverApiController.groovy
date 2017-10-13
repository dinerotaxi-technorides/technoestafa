package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.operation.BillingDriver
class TechnoRidesBillingDriverApiController extends TechnoRidesValidateApiController {
	def technoRidesBillingService
	
	def addExcept(list) {
		list <<'get'
	}
	def get={
		render "asd"
	}
	def jq_billing_history = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def driver= EmployUser.get(params?.driver_id)
			def techno= technoRidesBillingService.getBillingDriverHistory(params, driver)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	
	def jq_billing_no_paid = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def driver= EmployUser.get(params?.driver_id)
			def techno= technoRidesBillingService.getBillingDriverNoPaid(params, driver)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_edit_billing = {
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			
			case 'del':
				def billing = BillingDriver.get(params.id)
				println billing
				if (billing) {
					billing.visible = false
					if (! billing.hasErrors() && billing.save(flush:true)) {
						message = "Billing  ${billing.user}  Updated"
						id = billing.id
						state = "OK"
					} else {
						message = "Could Not Update Customer"
					}
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				def billing = BillingDriver.get(params.id)
				println billing
				println params
				if (billing) {
					billing.billingDate = new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.billingDate)
					billing.hadpaid = params.hadpaid.contains("off")?false:true
					billing.amount = params.double('amount')
					billing.comments = params.comments
					billing.recive = params.recive
					
					if (! billing.hasErrors() && billing.save(flush:true)) {
						message = "Billing  ${billing.user}  Updated"
						id = billing.id
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
}

