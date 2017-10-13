package com.page
import java.util.List;

import ar.com.goliath.*
class HomeCompanyAccountController {
	def springSecurityService
	def placeService
	def index = {
		redirect action:'comoFunciona'
	}
	def contact={
	
	}
	def termsAndConditions={
		
	}
	def saveContact={
		def contact = new Contact(params)
		if (!contact.save(flush: true)) {
			render(view: "contact", model: [contact: contact])
			return
		}
		redirect(action: "contactShow")
	}
	def contactShow={
		
	}
	def pedir = {
	}
	def comoFunciona={
		
	}
	def download={
		
	}
	def comoUsarlo={
		
	}
	def nosotros = {
	}
	def queEs = {
	}
	def beneficios = {
	}
	def ayuda = {
	}
	def complete={
		
	}
}