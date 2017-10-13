package com.api.technorides

import ar.com.goliath.MailQueue
import ar.com.goliath.PersistToken
import ar.com.goliath.User
class TechnoRidesEmailApiController extends TechnoRidesValidateApiController {
	def technoRidesEmailService
	def addExcept(list) {
		list <<'get'<< 'send_mail'<<'generic_email' << 'payment_email'// << 'list' << 'show'
	}
	def get={
		render "asd"
	}
	def send_mail = {
		def mailQueue=new MailQueue(from:params?.from,to:params?.to)
		mailQueue.body=params?.message
		mailQueue.subject=params?.subject
		if(mailQueue.save()){
			render(contentType:'text/json',encoding:"UTF-8") { status=100 }
			return
		}

		render(contentType:'text/json',encoding:"UTF-8") { status=11 }
	}
	def generic_email = {
		try {

			technoRidesEmailService.emailOperationGeneric(params.long('opId'), params?.template)
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}

	def payment_email = {
		try {

			technoRidesEmailService.emailSuccessPayment(params.long('opId'), params.long('ccId'), params?.orderId, params?.template)
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def get_emails_api = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno=technoRidesEmailService.getEmailBuilder(params,rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_get_company_account={
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def customers=technoRidesEmailService.getEmailBuilder(rtaxi)
			StringBuffer buf = new StringBuffer("<select id='companyAccount' name='companyAccount'>")
			buf.append("<option value=''></option>")
			def l=customers.each{
				buf.append("<option value='${it.id}'").append(it.companyName).append('>')
				 buf.append(it.companyName)
				 buf.append("</option>")
			}
			 buf.append("</select>")
			 render buf.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}

	}
}
