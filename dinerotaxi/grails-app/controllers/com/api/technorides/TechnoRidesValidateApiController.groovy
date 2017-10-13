package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.Role
import ar.com.goliath.User
abstract class TechnoRidesValidateApiController {
	def beforeInterceptor = [action:this.&checkUser,except:[]]

	TechnoRidesValidateApiController()  {
		addExcept(this.beforeInterceptor.except)
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
	def checkUser() {
		def token = null
		if ( params?.token){
			token = params?.token
		}else{
			token = request.JSON?.token
		
		}
		def usr=null
		if(token){
			def tok=PersistToken.findByToken(token)
			if(tok){
				usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			}
		}else{
			response.setStatus(410)
			render(contentType: 'text/json',encoding:"UTF-8") { status=410 }
			return false
		}

		if(!usr){
			response.setStatus(411)
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false

		}
		if(!usr.enabled){
			response.setStatus(412)
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		if(usr.accountExpired){
			response.setStatus(413)
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return false
		}
		if(usr.accountLocked){
			response.setStatus(414)
			render(contentType: 'text/json',encoding:"UTF-8") { status=414}
			return false
		}
		if(usr.passwordExpired){
			response.setStatus(415)
			render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
			return false
		}
		def adminRole=Role.findByAuthority("ROLE_ADMIN")
		def observerRole=Role.findByAuthority("ROLE_MONITOR")
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def telephonistRole=Role.findByAuthority('ROLE_TELEPHONIST')
		def investorRole=Role.findByAuthority('ROLE_INVESTOR')
		def taxiRole=Role.findByAuthority('ROLE_TAXI')
		def corporateRole=Role.findByAuthority('ROLE_COMPANY_ACCOUNT')
		def corporateUserRole=Role.findByAuthority('ROLE_COMPANY_ACCOUNT_EMPLOYEE')
		if (!usr.authorities.contains(adminRole)&&!usr.authorities.contains(operadorRole)&&
		!usr.authorities.contains(companyRole)&&!usr.authorities.contains(telephonistRole)
		&&!usr.authorities.contains(investorRole)&&!usr.authorities.contains(observerRole)
		&&!usr.authorities.contains(corporateRole)
		&&!usr.authorities.contains(corporateUserRole)
		&&!usr.authorities.contains(taxiRole)){
			response.setStatus(416)
			render(contentType: 'text/json',encoding:"UTF-8") { status=416}
			return false
		}
	}
	abstract def addExcept(list)
}

