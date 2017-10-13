package com.page.admin
import grails.converters.JSON
import ar.com.goliath.*
import ar.com.operation.Operation
import ar.com.operation.TrackOperation
class TestEmailController {
	def technoRidesEmailService

	def index = {
	}
	def update={
		try{
			technoRidesEmailService.sendEmail(params?.email, params?.textArea)
			flash.message="Email Was send"
		}catch(Exception e){
			log.error e.getCause()
			flash.message="The body has broken"
		}
		render(view: "index")
	}
}
