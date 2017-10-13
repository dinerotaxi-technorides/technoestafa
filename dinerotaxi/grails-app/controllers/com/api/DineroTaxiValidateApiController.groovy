package com.api

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.Role
import ar.com.goliath.User
abstract class DineroTaxiValidateApiController {
	def beforeInterceptor = [action:this.&checkUser,except:[]]

	DineroTaxiValidateApiController()  {
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
		def usr=null
		if(params?.token){
			def tok=PersistToken.findByToken(params?.token)
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
		def userRole=Role.findByAuthority("ROLE_USER")
		def ccRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")
		println usr.authorities
		if (!usr.authorities.contains(userRole)&&!usr.authorities.contains(ccRole)){
			response.setStatus(416)
			render(contentType: 'text/json',encoding:"UTF-8") { status=416}
			return false
		}
	}
	abstract def addExcept(list)
}

