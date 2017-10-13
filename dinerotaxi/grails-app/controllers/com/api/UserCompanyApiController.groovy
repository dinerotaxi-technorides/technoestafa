package com.api

import groovy.json.JsonSlurper

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.codehaus.groovy.grails.plugins.springsecurity.ui.RegistrationCode
import org.springframework.security.core.Authentication

import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.Role
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.goliath.api.JsonToken

import com.UserDevice
class UserCompanyApiController {
	def exportService
	def springDineroTaxiService
	def rememberMeServices
	def userService
	def emailService
	def notificationService
	def employAdminService
	def springSecurityService
	def login = {
		try{
			def u =new JsonToken();
			def usr;
			def rtaxi;
			def usrUnknow;
			Long radiotaxi=null;
			if(params?.email){
				log.debug "Tiene mail buscando Usuario"
				usrUnknow=User.find("from User as b where b.username=:username and b.password=:password",
						[username: params.email,password:springSecurityService.encodePassword(params.password)])

				if(usrUnknow){
					log.debug "Buscando Permisos"
					def companyRole=Role.findByAuthority("ROLE_COMPANY")
					def operadorRole=Role.findByAuthority('ROLE_OPERATOR')

					String respuesta=""
					log.debug "asignando COmpany"
					if(usrUnknow.authorities.contains(companyRole) ){
						log.debug "es company"
						rtaxi=Company.get(usrUnknow.id)
						def usrInterm=EmployUser.findByEmployeeAndTypeEmploy(usrUnknow,ar.com.goliath.TypeEmployer.OPERADOR)
						if (usrInterm){
							usr=usrInterm
						}
					}else if (usrUnknow.authorities.contains(operadorRole)){
						log.debug "!es company"
						usr=User.get(usrUnknow.id)
						rtaxi=Company.get(usrUnknow.rtaxi.id)
					}
					log.debug "Tengo usuario y rtaxi"
					if(usr.enabled){
						if(!usr.accountExpired){
							if(!usr.accountLocked){
								if(!usr.passwordExpired){
									if (usr.authorities.contains(operadorRole)  ) {

										radiotaxi=rtaxi?.id

										def pers=PersistToken.findAllByUsernameAndRtaxi(usr.username,radiotaxi).each{ it.delete() }
										springDineroTaxiService.reauthenticate (usr.username ,usr.password,rtaxi)
										Authentication auth=springDineroTaxiService.getAuthentication()
										request.setAttribute("rtaxi",radiotaxi)
										rememberMeServices.loginSuccess(request, response, auth);
										def tok=null
										if(rtaxi==null){
											tok=PersistToken.find("from PersistToken as b where b.username=:username and b.rtaxi is null",
													[username: usr.email])
										}else{
											tok=PersistToken.find("from PersistToken as b where b.username=:username and b.rtaxi=:rtaxi",
													[username: usr.email,rtaxi:radiotaxi])
										}
										log.error tok
										if(tok){
											if(tok.token.contains("+")){
												tok.token=tok.token.replaceAll("\\+", "w")
												tok.save(flush:true)
											}
											u.token=tok.token
										}

										u.status=100
									}else{
										u.status=103
									}
								}else{
									u.status=116
								}
							}else{
								u.status=107
							}
						}else{
							u.status=106
						}
					}else{
						u.status=105
					}
				}else{
					u.status=104
				}
			}else{
				u.status=113
			}

			render(contentType:'text/json',encoding:"UTF-8") {
				id=usr?.id
				rtaxiId=radiotaxi
				token=u.token
				lat=usr?.city?.northEastLatBound?:""
				lng=usr?.city?.northEastLngBound?:""
				firstName=usr?.firstName
				lastName=usr?.lastName
				status=u?.status
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=111 }
		}
	}
	def logout = {
		try{
			def u =new JsonToken();
			def jtString=params?.token

			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				def companyRole=Role.findByAuthority("ROLE_COMPANY")
				if (usr.authorities.contains(companyRole)   ) {
					usr=Company.findByUsername(prin.username)
				}else{
					usr=EmployUser.findByUsername(prin.username)
				}
				session.invalidate()
				u.status=100
			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok?.username){
					PersistToken.findAllByUsername(tok?.username).each{ it.delete() }
				}
				u.status=100
			}

			if (!u?.status) {
				u.status=122
			}

			render(contentType:'text/json',encoding:"UTF-8") { status=u.status }
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def dumpDatabase={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr=Company.findByUsername(prin.username)
			}
			def tok=null
			if(params?.token)
				tok=PersistToken.findByToken(params?.token)

			if(tok || springSecurityService.isLoggedIn()){

				usr=usr!=null?usr:Company.findByUsername(tok.username)
				if(usr){
					def customers = employAdminService.getUsers(usr)
					if(customers){
						String cust= customers as grails.converters.JSON
						render(contentType:'text/json',encoding:"UTF-8") {
							status=100
							listUsers=customers
						}
					}else{

						render(contentType:'text/json',encoding:"UTF-8") { status=10 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
}
