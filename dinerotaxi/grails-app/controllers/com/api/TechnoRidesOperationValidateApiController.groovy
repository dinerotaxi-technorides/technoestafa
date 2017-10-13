package com.api

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.Role
import ar.com.goliath.User
abstract class TechnoRidesOperationValidateApiController {
	def beforeInterceptor = [action:this.&checkUser,except:[]]

	TechnoRidesOperationValidateApiController()  {
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

		
		
		println usr
		if(!usr?.email){
			render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			return
		}
		
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false

		}
		if(!usr.enabled){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		if(usr.accountExpired){
			render(contentType: 'text/json',encoding:"UTF-8") { status=413 }
			return false
		}
		if(usr.accountLocked){
			render(contentType: 'text/json',encoding:"UTF-8") { status=414}
			return false
		}
		if(usr.passwordExpired){
			render(contentType: 'text/json',encoding:"UTF-8") { status=415 }
			return false
		}
		
	}
	abstract def addExcept(list)
}

