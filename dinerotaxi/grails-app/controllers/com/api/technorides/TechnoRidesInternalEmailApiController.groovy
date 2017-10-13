package com.api.technorides

import ar.com.goliath.MailQueue
import ar.com.goliath.PersistToken
import ar.com.goliath.User
class TechnoRidesInternalEmailApiController{
	def technoRidesEmailService
	def addExcept(list) {
		list <<'get'<< 'send_mail'<<'generic_email'// << 'list' << 'show'
	}
	def get={
		render "asd"
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
}
