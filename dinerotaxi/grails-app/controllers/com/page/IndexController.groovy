package com.page

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import grails.converters.JSON

import org.codehaus.groovy.grails.commons.*

import ar.com.goliath.*

import com.UserDevice
import com.promotions.Promotions
import com.promotions.SettingsPromotions
class IndexController {
	def springSecurityService
	def emailService
	def grailsUrlMappingsHolder
	def userAgentIdentService
	def grailsApplication
	def inicio = {
		session["country"]=params?.country
		def us=springSecurityService.currentUser
		def userRole=Role.findByAuthority("ROLE_USER")
		def adminRole=Role.findByAuthority("ROLE_ADMIN")
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def taxiRole=Role.findByAuthority("ROLE_TAXI")
		def taxiRoleOwner=Role.findByAuthority("ROLE_TAXI_OWNER")
		def companyAccountRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT")
		def companyAccountEmployeeRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")
		if(us){
			if (us.authorities.contains(userRole)) {
				redirect controller:"home"
			}else
			if (us.authorities.contains(taxiRoleOwner)) {
				redirect controller:"homeOwner"
			}else
			if (us.authorities.contains(taxiRole)) {
				redirect controller:"homeTaxista"
			}else
			if (us.authorities.contains(companyRole) ||us.authorities.contains(supervisorRole)||us.authorities.contains(operadorRole)) {
				redirect controller:"tripPanel"
			}else
			if (us.authorities.contains(adminRole)) {
				redirect controller:"adminUser"
			}else if (us.authorities.contains(companyAccountRole)){
				redirect controller:"miPanelCompanyAccount"
			}else if (us.authorities.contains(companyAccountEmployeeRole)){
				redirect controller:"miPanelCompanyAccountEmployee"
			}
		}
	}
	def countries={
		def us=springSecurityService.currentUser
		def userRole=Role.findByAuthority("ROLE_USER")
		def adminRole=Role.findByAuthority("ROLE_ADMIN")
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def taxiRole=Role.findByAuthority("ROLE_TAXI")
		def taxiRoleOwner=Role.findByAuthority("ROLE_TAXI_OWNER")
		def companyAccountRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT")
		def companyAccountEmployeeRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")
		if(us){
			if (us.authorities.contains(userRole)) {
				redirect (controller:"home", params:[country:params?.country?:'ar'])
			}else
			if (us.authorities.contains(taxiRoleOwner)) {
				redirect controller:"homeOwner",params:[country:params?.country?:'ar']
			}else
			if (us.authorities.contains(taxiRole)) {
				redirect controller:"homeTaxista",params:[country:params?.country?:'ar']
			}else
			if (us.authorities.contains(companyRole) ||us.authorities.contains(supervisorRole)||us.authorities.contains(operadorRole)) {
				redirect controller:"tripPanel",params:[country:params?.country?:'ar']
			}else
			if (us.authorities.contains(adminRole)) {
				redirect controller:"adminUser",params:[country:params?.country?:'ar']
			}else if (us.authorities.contains(companyAccountRole)){
				redirect controller:"miPanelCompanyAccount",params:[country:params?.country?:'ar']
			}else if (us.authorities.contains(companyAccountEmployeeRole)){
				redirect controller:"miPanelCompanyAccountEmployee",params:[country:params?.country?:'ar']
			}
		}
//		def country = session["country"]
//		if(country){
//			redirect controller:"index",action:"inicio",params:[country:country]
//		}
	}
	def customerService={
	}
	def ganadorOpenapp={
	}
	def error={
	}
	def registration = {
	}
	def complete = {
		def usr= User.findByUsernameAndRtaxiIsNull(params?.usr)
		[ usr:usr]
	}
	def completeForgotPassword = {
		def usr= User.findByUsernameAndRtaxiIsNull(params?.usr)
		[ usr:usr]
	}
	def completePedir = {
		[usr: User.findByUsernameAndRtaxiIsNull(params?.usr)]
	}
	def completeCompany = {
		[usr: User.findByUsernameAndRtaxiIsNull(params?.usr)]
	}
	def completeOwner = {
		[usr: User.findByUsernameAndRtaxiIsNull(params?.usr)]
	}
	def completeTaxi = {
		[usr: User.findByUsernameAndRtaxiIsNull(params?.usr)]
	}
	def nosotros = {
	}
	def pedir={
	}
	def pedirw={
	}
	def movil={

		def usrDevice=null
		def os = userAgentIdentService.getUserAgent().operatingSystem
		if( userAgentIdentService.isAndroid()){
			usrDevice=UserDevice.ANDROID
			redirect(url:grailsApplication.config.app.android)
		}else if(userAgentIdentService.isiOsDevice() ||userAgentIdentService.isiPad()){
			usrDevice=UserDevice.IPHONE
			redirect(url:grailsApplication.config.app.ios)
		}else if(userAgentIdentService.isBlackberry() ){
			usrDevice=UserDevice.BB
			redirect(url:grailsApplication.config.app.blackberry)
		}else{
			usrDevice=UserDevice.WEB
			render(view: "download")
		}
	}
	def sms={
	}
	def fb={
	}
	def login={
	}
	def comoFunciona={
	}
	def termsAndConditions={
	}
	def politic={
	}
	def contact={
	}
	def saveContact={
		def contact = new Contact(params)
		if (!contact.save(flush: true)) {
			render(view: "contact", model: [contact: contact])
			flash.error="Debe completar todos los campos para enviar la consulta"
			return
		}
		def conf = SpringSecurityUtils.securityConfig
		String emailHml="${params as JSON}"
		emailService.send("rrhh@technorides.com",conf.ui.register.emailFrom, "CONSULTA WEB",emailHml)

		flash.message="Se ha enviado la consulta correctamente, en breves momentos se contactara una persona de <b>soporte al cliente</b>."
		redirect(action: "contactShow")
	}
	def contactShow={
	}
	def download={

		def os = userAgentIdentService.getUserAgent().operatingSystem
		if( userAgentIdentService.isAndroid()){
			redirect(url:grailsApplication.config.app.android)
		}else if(userAgentIdentService.isiOsDevice() ||userAgentIdentService.isiPad()){
			redirect(url:grailsApplication.config.app.ios)
		}else if(userAgentIdentService.isBlackberry() ){
			redirect(url:grailsApplication.config.app.blackberry)
		}else{
			return;
		}
	}
	def descarga={
		def settingsPromotions = SettingsPromotions.createCriteria().list() {

			maxResults( 1 )

			// first name case insensitive where the field begins with the search term
			if (params.bannerId)
				eq('name',params.bannerId )

			// last name case insensitive where the field begins with the search term
			if (params.codeQr)
				eq('codeQr',params.codeQr )
			if (params.qrCode)
				eq('codeQr',params.qrCode )
		}
		def set=null
		if(settingsPromotions){
			set=settingsPromotions.get(0)
		}
		def usrDevice=null
		def os = userAgentIdentService.getUserAgent().operatingSystem
		if( userAgentIdentService.isAndroid()){
			usrDevice=UserDevice.ANDROID
			def promo=new Promotions(dev:usrDevice,setting:set).save(flush:true)
			redirect(url:grailsApplication.config.app.android)
		}else if(userAgentIdentService.isiOsDevice() ||userAgentIdentService.isiPad()){
			usrDevice=UserDevice.IPHONE
			def promo=new Promotions(dev:usrDevice,setting:set)
			if(!promo.save(flush:true)){
			}
			redirect(url:grailsApplication.config.app.ios)
		}else if(userAgentIdentService.isBlackberry() ){
			usrDevice=UserDevice.BB
			def promo=new Promotions(dev:usrDevice,setting:set).save(flush:true)
			redirect(url:grailsApplication.config.app.blackberry)
		}else{
			usrDevice=UserDevice.WEB
			def promo=new Promotions(dev:usrDevice,setting:set).save(flush:true)
			render(view: "download")
		}
	}
	def downloadTaxista={
		redirect(action: "descarga")
	}
	def queEs={
		redirect(action: "registro")
	}
	def beneficios={
		redirect(action: "registro")
	}
	def comoFuncionaTaxista={
		redirect(action: "registro")
	}
	def registro={
	}
}
