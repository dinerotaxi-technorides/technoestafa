package com.api
import ar.com.goliath.*
import org.codehaus.groovy.grails.plugins.springsecurity.ui.RegistrationCode
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import ar.com.operation.*
import ar.com.operation.OperationHistory
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.TrackOperation

import com.NotificationCommand
import com.operation.*
class TaxiCompanyApiController {
	def exportService
	def springSecurityService
	def rememberMeServices
	def userService
	def notificationService
	def tripPanelService
	def taxiCompanyService
	def emailService
	// the delete, save and update actions only accept POST requests
	static allowedMethods = [delete:'POST', save:'POST',post:'POST', update:'POST',isAvailable:'POST',login:'GET']

	def onlineNotificationService
	def getMsg = {
		def tok=PersistToken.findByToken(params?.token)
		if(tok){
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def companyRole=Role.findByAuthority("ROLE_COMPANY")
								def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
								def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
								log.debug "Radiotaxi Serching pending travel"
								if (usr.authorities.contains(companyRole)  ) {

									def userInstance=Company.get(usr.id)
									//como se logueo una compania hay que buscar a un usuario operador ya que una empresa no puede asignar taxis

									def userEmployee=EmployUser.findByEmployee(userInstance)
									if(userEmployee){
										render(contentType:'text/json',encoding:"UTF-8") {
											status=100
											taxis=taxiCompanyService.getTaxiList(userInstance)
											listOperations=taxiCompanyService.getTrips(userEmployee)
										}
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=103 }
									}

								}else if(usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole) ){
									def userInstance=EmployUser.get(usr.id)
									if(userInstance){
										render(contentType:'text/json',encoding:"UTF-8") {
											status=100
											taxis=taxiCompanyService.getTaxiList(userInstance.employee)
											listOperations=taxiCompanyService.getTrips(usr)
										}

									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=103 }
									}
								}else{
									render(contentType:'text/json',encoding:"UTF-8") { status=103 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def assignTrip={
		def tok=PersistToken.findByToken(params?.token)
		log.debug "AssignTrip-------------"
		if(tok){
			def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def companyRole=Role.findByAuthority("ROLE_COMPANY")
								def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
								def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
								def timeTravel=Long.valueOf(params?.timeEstimated)
								if (usr.authorities.contains(companyRole)  ) {
									def userInstance=Company.get(usr.id)
									def oper= params?.idTrip?Operation.get(Long.valueOf(params?.idTrip)):null
									def taxista= EmployUser.findByUsernameAndEmployee(params?.taxiNumber.trim()+"@"+usr.email.split("@")[1],userInstance)
									def usrInterm=EmployUser.findByEmployeeAndTypeEmploy(userInstance,TypeEmployer.OPERADOR)
									if (oper && oper.intermediario==usrInterm &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
										def stat=tripPanelService.setTaxiByRadioTaxiApi(usrInterm,oper,taxista,usrInterm,supervisorRole,operadorRole,timeTravel)
										render(contentType:'text/json',encoding:"UTF-8") { status=stat }
									}else if(oper.intermediario!=usrInterm ||(oper instanceof OperationHistory) || (oper instanceof OperationCompanyHistory)){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=214 }

									}
								}else if(usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole)){
									def oper= Operation.get(params?.idTrip)
									def usrInterm=EmployUser.findByUsername(tok.username)
									def taxista= EmployUser.findByUsernameAndEmployee(params?.taxiNumber+"@"+usr.email.split("@")[1],usrInterm.employee)
									if (oper && oper.intermediario==usrInterm &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
										def stat= tripPanelService.setTaxiByRadioTaxiApi(usrInterm,oper,taxista,usr,supervisorRole,operadorRole,timeTravel)
										render(contentType:'text/json',encoding:"UTF-8") { status=stat }
									}else if(oper.intermediario!=usrInterm||(oper instanceof OperationHistory) || (oper instanceof OperationCompanyHistory)){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=214 }

									}

									render(contentType:'text/json',encoding:"UTF-8") { status=100 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def setAmount={
		def tok=PersistToken.findByToken(params?.token)
		log.debug "AssignTrip-------------"
		if(tok){
			def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def companyRole=Role.findByAuthority("ROLE_COMPANY")
								def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
								def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
								def amount=Double.parseDouble(params?.amount)
								if (usr.authorities.contains(companyRole)  ) {
									def userInstance=Company.get(usr.id)
									def oper= params?.idTrip?Operation.get(Long.valueOf(params?.idTrip)):null
									def usrInterm=EmployUser.findByEmployeeAndTypeEmploy(userInstance,TypeEmployer.OPERADOR)

									if (oper && oper.intermediario==usrInterm){
										def stat=tripPanelService.setAmountByRadioTaxiApi(usrInterm,oper,supervisorRole,operadorRole,amount)
										render(contentType:'text/json',encoding:"UTF-8") { status=stat }
									}else if(oper.intermediario!=usrInterm){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=214 }

									}
								}else if(usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole)){
									def oper= Operation.get(params?.idTrip)
									def usrInterm=EmployUser.findByUsername(tok.username)
									if (oper && oper.intermediario==usrInterm ){
										def stat= tripPanelService.setAmountByRadioTaxiApi(usrInterm,oper,supervisorRole,operadorRole,amount)
										render(contentType:'text/json',encoding:"UTF-8") { status=stat }
									}else if(oper.intermediario!=usrInterm){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=214 }

									}

									render(contentType:'text/json',encoding:"UTF-8") { status=100 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def reAssignTrip={
		def tok=PersistToken.findByToken(params?.token)
		if(tok){
			def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def companyRole=Role.findByAuthority("ROLE_COMPANY")
								def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
								def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
								def timeTravel=Long.valueOf(params?.timeEstimated)
								if (usr.authorities.contains(companyRole)  ) {

									def userInstance=Company.get(usr.id)
									def oper= Operation.get(params?.idTrip)
									def taxista= EmployUser.findByUsernameAndEmployee(params?.taxiNumber.trim()+"@"+usr.email.split("@")[1],userInstance)
									def usrInterm=EmployUser.findByEmployeeAndTypeEmploy(userInstance,TypeEmployer.OPERADOR)
									//									log.debug params?.taxiNumber.trim()+"@"+usr.email.split("@")[1]
									//									log.debug userInstance
									//									log.debug oper
									//									log.debug taxista
									if (oper && oper.intermediario==usrInterm &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
										def stat= tripPanelService.reAsignTaxiByRadioTaxiApi(usrInterm,oper,taxista,usrInterm,supervisorRole,operadorRole,timeTravel)
										render(contentType:'text/json',encoding:"UTF-8") { status=stat }
									}else if(oper.intermediario!=usrInterm||(oper instanceof OperationHistory) || (oper instanceof OperationCompanyHistory)){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=214 }

									}
								}else if(usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole)){
									def oper= Operation.get(params?.idTrip)
									def usrInterm=EmployUser.findByUsername(tok.username)
									def taxista= EmployUser.findByUsernameAndEmployee(params?.taxiNumber.trim()+"@"+usr.email.split("@")[1],usrInterm.employee)

									//									log.debug params?.taxiNumber.trim()+"@"+usr.email.split("@")[1]
									//									log.debug userInstance
									//									log.debug oper
									//									log.debug taxista
									if (oper && oper.intermediario==usrInterm &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
										def stat=tripPanelService.reAsignTaxiByRadioTaxiApi(usrInterm,oper,taxista,usr,supervisorRole,operadorRole,timeTravel)
										render(contentType:'text/json',encoding:"UTF-8") { status=stat }
									}else if(oper.intermediario!=usrInterm||(oper instanceof OperationHistory) || (oper instanceof OperationCompanyHistory)){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=214 }

									}
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def rejectTrip={
		def tok=PersistToken.findByToken(params?.token)
		def company;
		if(tok){
			def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def companyRole=Role.findByAuthority("ROLE_COMPANY")
								def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
								def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
								if(usr.authorities.contains(companyRole)){
									company=Company.get(usr.id)
								}else{
									company=Company.get(usr.employee.id)
								}
								if (usr.authorities.contains(companyRole)||usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole) ) {
									params?.idTrips.split(",").each{
										def oper= Operation.get(Long.valueOf(it))
										if(oper &&oper.company==company){
											if (oper && oper.company==company &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
												def blop=new BlackListRadioTaxiOperation(operation:oper,user:company)
												def on=OnlineRadioTaxi.findByCompany(company)
												on?.countRejectTrip=on?.countRejectTrip?on.countRejectTrip+1:1
												if(blop.save(flush:true) &&	on.save(flush:true)){
													//notificationService.notificateOnTripRejectRadioTaxiSelect(oper, oper.user,false);

													def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.REJECTTRIP)
													trackOperation.operation=oper
													trackOperation.onlineRTaxi=on
													trackOperation.save(flush:true)
													oper.status=TRANSACTIONSTATUS.PENDING
													oper.company=null
													oper.taxista=null
													oper.intermediario=null
													if(!oper.save(flush:true)){
														log.error "rejectTrip:no se puede guardar Operacion"
													}
												}
											}

										}
									}
									render(contentType:'text/json',encoding:"UTF-8") { status=100 }
								}else {
									render(contentType:'text/json',encoding:"UTF-8") { status=110 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}

	}
	def cancelTripByCompany={
		//		idTrip", idTrip, "status", status,
		// �� �� ��"comment", comment, "token", sessionToken)
		def tok=PersistToken.findByToken(params?.token)
		def company;
		if(tok){
			def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def companyRole=Role.findByAuthority("ROLE_COMPANY")
								def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
								def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
								if(usr.authorities.contains(companyRole)){
									company=Company.get(usr.id)
								}else{
									company=Company.get(usr.employee.id)
								}
								if (usr.authorities.contains(companyRole)||usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole) ) {

									def oper= Operation.get(params.idTrip)
									if(oper &&oper.company==company &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
										def stats=Integer.valueOf(params?.status)
										if(stats==1 && oper?.user?.rtaxi==null ){
											def blop=new BlackListRadioTaxiOperation(operation:oper,user:company)
											def on=OnlineRadioTaxi.findByCompany(company)
											on?.countRejectTrip=on?.countRejectTrip?on.countRejectTrip+1:1
											if(blop.save(flush:true) &&	on.save(flush:true)){
												notificationService.notificateOnTripRejectRadioTaxiSelect(oper, oper.user,false);
												def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.REJECTTRIP)
												trackOperation.operation=oper
												trackOperation.onlineRTaxi=on
												trackOperation.comment=params.comment+" IDONTHAVETAXI"
												trackOperation.save(flush:true)
												oper.status=TRANSACTIONSTATUS.PENDING
												oper.company=null
												oper.taxista=null
												oper.intermediario=null
												if(!oper.save(flush:true)){
													log.error "rejectTrip:no se puede guardar Operacion"
												}
												render(contentType:'text/json',encoding:"UTF-8") { status=100 }
											}else{
												render(contentType:'text/json',encoding:"UTF-8") { status=133 }
											}
										}else if(stats==2){
											oper.status=TRANSACTIONSTATUS.CANCELED_EMP
											oper.save(flush:true)

											if(oper?.isCompanyAccount){
												Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
													[cClass: OperationCompanyHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.CANCELED])
											}else{
												Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
												[cClass: OperationHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.CANCELED])
											}
											def usuario=oper.user
											usuario.accountLocked=true
											usuario.save(flus:true)
											def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.CANCELED_EMP)
											trackOperation.operation=oper
											trackOperation.comment=params.comment+" BLOCKUSER_UNKNOW_PHONE"
											trackOperation.save(flush:true)
											notificationService.notificateOnCancelInvalidPhone(oper, oper.user, false);

											def registrationCode = new RegistrationCode(username: usuario.username).save(flush:true)

											def conf = SpringSecurityUtils.securityConfig
											String url = generateLink('validatePhone', [t:  registrationCode.token])
											def body =  g.render(template:"/emailconfirmation/invalidphone", model:[usr: usuario,url:url]).toString()

											emailService.send(usuario.email, conf.ui.register.emailFrom, "DINEROTAXI.COM SU NUMERO DE TELEFONO ES INVALIDO",  body.toString())
											def removeToken=PersistToken.findAllByUsername(usuario.username)
											removeToken.each{
												it.delete()
											}
											String emailHml="${usuario?.phone} ${usuario?.email} ${usuario?.firstName}  "
											emailService.send("rrhh@technorides.com",conf.ui.register.emailFrom, "USUARIO BLOQUEADO POR RADIOTAXI ${company.companyName}",emailHml)
										}else if(stats==1 && oper?.user?.rtaxi!=null ){
											oper.status=TRANSACTIONSTATUS.CANCELED_EMP
											oper.save(flush:true)

											if(oper?.isCompanyAccount){
												Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
													[cClass: OperationCompanyHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.CANCELED_EMP])
											}else{
												Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
													[cClass: OperationHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.CANCELED_EMP])

											}

											def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.CANCELED_EMP)
											trackOperation.operation=oper
											trackOperation.comment=params.comment+" NOVECARS"
											trackOperation.save(flush:true)
											notificationService.notificateOnTripRejectRadioTaxiSelect(oper, oper.user,false);


										}else {
											oper.status=TRANSACTIONSTATUS.CANCELED_EMP
											oper.save(flush:true)

											if(oper?.isCompanyAccount){
												Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
													[cClass: OperationCompanyHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.CANCELED_EMP])
											}else{
												Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
													[cClass: OperationHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.CANCELED_EMP])

											}

											def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.CANCELED_EMP)
											trackOperation.operation=oper
											trackOperation.comment=params.comment+" OTHER"
											trackOperation.save(flush:true)
											notificationService.notificateOnCancelOther(oper, oper.user, false);
										}

										render(contentType:'text/json',encoding:"UTF-8") { status=100 }
									}else if(oper.company!=company||(oper instanceof OperationHistory) || (oper instanceof OperationCompanyHistory)){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=100 }

									}
								}else {
									render(contentType:'text/json',encoding:"UTF-8") { status=110 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}

	}

	protected String generateLink(String action, linkParams) {
		createLink(base: "$request.scheme://$request.serverName:$request.serverPort$request.contextPath",
				controller: 'register', action: action,
				params: linkParams)

	}
	def timeoutTrip={
		def tok=PersistToken.findByToken(params?.token)
		def company;
		if(tok){
			def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def companyRole=Role.findByAuthority("ROLE_COMPANY")
								def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
								def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
								if(usr.authorities.contains(companyRole)){
									company=Company.get(usr.id)
								}else{
									company=Company.get(usr.employee.id)
								}
								if (usr.authorities.contains(companyRole)||usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole) ) {
									params?.idTrips.split(",").each{
										def oper= Operation.get(Long.valueOf(it))
										if (oper && oper.company==company &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
											if(oper instanceof OperationPending || oper instanceof OperationCompanyPending){
												log.error "timeoutTrip reasign"
												def blop=new BlackListRadioTaxiOperation(operation:oper,user:company)
												def on=OnlineRadioTaxi.findByCompany(company)
												on?.countTimeOut=on?.countTimeOut?on.countTimeOut+1:1
												if(blop.save(flush:true) &&	on.save(flush:true)){
													//notificationService.notificateOnTripTimeOutRadioTaxiSelect(oper, oper.user,false);
													oper.status=TRANSACTIONSTATUS.PENDING
													oper.company=null
													oper.taxista=null
													oper.intermediario=null

													def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.TIMEOUTTRIP)
													trackOperation.operation=oper
													trackOperation.onlineRTaxi=on
													trackOperation.save(flush:true)
													if(!oper.save(flush:true)){
														log.error "rejectTrip:no se puede guardar Operacion"
													}
												}
											}

										}
									}
									render(contentType:'text/json',encoding:"UTF-8") { status=100 }
								}else {
									render(contentType:'text/json',encoding:"UTF-8") { status=110 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}

	}
	def getAllNotificationsNotReader={
		try{
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				if(usr){
					if(usr.enabled){
						if(!usr.accountExpired){
							if(!usr.accountLocked){
								if(!usr.passwordExpired){
									def companyRole=Role.findByAuthority("ROLE_COMPANY")
									def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
									def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
									if (usr.authorities.contains(companyRole) ||usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole) ) {

										def oper=onlineNotificationService.getNotificationsNotRead(usr)
										if(oper){
											List<NotificationCommand> not=new ArrayList<NotificationCommand>();
											oper.each{
												not.add(new NotificationCommand(it))
											}
											def osfx=not
											if(params?.markRead){
												onlineNotificationService.setAllNotificationsRead(usr)
											}
											render(contentType:'text/json',encoding:"UTF-8") {
												status=100
												notifications=osfx
											}
										}else{
											render(contentType:'text/json',encoding:"UTF-8") { status=100 }
										}

									}else {


										render(contentType:'text/json',encoding:"UTF-8") { status=110 }
									}
								}else{
									render(contentType:'text/json',encoding:"UTF-8") { status=116 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=107 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=106 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=105 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=104 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}

	}
	def hasPendingNotifications={
		try{
			def tok=PersistToken.findByToken(params?.token)
			if(tok){
				def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				if(usr){
					if(usr.enabled){
						if(!usr.accountExpired){
							if(!usr.accountLocked){
								if(!usr.passwordExpired){
									def companyRole=Role.findByAuthority("ROLE_COMPANY")
									def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
									def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
									if (usr.authorities.contains(companyRole) ||usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole) ) {

										log.debug "preguntando notification ${usr}"
										def oper=onlineNotificationService.getCountNotificationsNotRead(usr)
										render(contentType:'text/json',encoding:"UTF-8") {
											status=100
											count=oper
										}

									}else {


										render(contentType:'text/json',encoding:"UTF-8") { status=110 }
									}
								}else{
									render(contentType:'text/json',encoding:"UTF-8") { status=116 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=107 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=106 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=105 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=104 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def ringUserTaxiArrived={


		def tok=PersistToken.findByToken(params?.token)
		def company;
		if(tok){
			def usr= User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(usr){
				if(usr.enabled){
					if(!usr.accountExpired){
						if(!usr.accountLocked){
							if(!usr.passwordExpired){
								def companyRole=Role.findByAuthority("ROLE_COMPANY")
								def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
								def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
								if(usr.authorities.contains(companyRole)){
									company=Company.get(usr.id)
								}else{
									company=Company.get(usr.employee.id)
								}
								if (usr.authorities.contains(companyRole)||usr.authorities.contains(supervisorRole) ||usr.authorities.contains(operadorRole) ) {
									def oper= Operation.get(params.idTrip)
									if (oper && oper.company==company &&!(oper instanceof OperationHistory) && !(oper instanceof OperationCompanyHistory)){
										notificationService.notificateOnTripHoldingUser(oper, oper.user,false);

										render(contentType:'text/json',encoding:"UTF-8") { status=100 }
									}else if(oper.company!=company||(oper instanceof OperationHistory) || (oper instanceof OperationCompanyHistory)){
										render(contentType:'text/json',encoding:"UTF-8") { status=244 }
									}else{
										render(contentType:'text/json',encoding:"UTF-8") { status=133 }
									}
								}else {
									render(contentType:'text/json',encoding:"UTF-8") { status=110 }
								}
							}else{
								render(contentType:'text/json',encoding:"UTF-8") { status=116 }
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=107 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=106 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=105 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=104 }
			}
		}else{
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
}
