package com.api
import static grails.async.Promises.*
import static groovyx.net.http.ContentType.URLENC

import javax.servlet.*
import javax.servlet.http.*

import org.codehaus.groovy.grails.commons.*

import ar.com.favorites.*
import ar.com.goliath.*
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.*

import com.*
import com.api.utils.*
class OperationSocketApiController {
	def springSecurityService
	def utilsApiService
	def operationApiService
	/**
	 * params {userId} {id}
	 * optional {driverId}
	 */
	def assigned={
		try{
			def usr=User.get(params?.userId)
			if(usr){
				def id=params?.id
				def operationInstance = Operation.get(params.id)
				if(operationInstance){
					if (operationInstance.user==usr||operationInstance.taxista==usr||operationInstance.intermediario==usr||operationInstance.company==usr){
						try {
							if(usr instanceof EmployUser && usr.typeEmploy==TypeEmployer.TAXISTA){
								operationInstance.taxista=usr
							}else{
								def driver=User.get(params?.driverId)
								operationInstance.taxista=driver
							}
							operationInstance.status=TRANSACTIONSTATUS.ASSIGNEDTAXI
							operationInstance.save(flush:true)
							render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
						}
						catch (org.springframework.dao.DataIntegrityViolationException e) {
							render(contentType: 'text/json',encoding:"UTF-8") { status=123 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	/**
	 * params {userId} {id}
	 * optional {driverId}
	 */
	def inTransaction={
		try{
			def usr=User.get(params?.userId)
			if(usr){
				def id=params?.id
				def operationInstance = Operation.get(params.id)
				if(operationInstance){
					if (operationInstance.user==usr||operationInstance.taxista==usr||operationInstance.intermediario==usr||operationInstance.company==usr){
						try {
							operationInstance.status=TRANSACTIONSTATUS.INTRANSACTION
							operationInstance.save(flush:true)
							render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
						}
						catch (org.springframework.dao.DataIntegrityViolationException e) {
							render(contentType: 'text/json',encoding:"UTF-8") { status=123 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	/**
	 * params {userId} {id}
	 */
	def cancel={
		try{
			def usr=User.get(params?.userId)
			if(usr){
				def id=params?.id
				def operationInstance = Operation.get(params.id)
				if(operationInstance){
					if (operationInstance.user==usr||operationInstance.taxista==usr||operationInstance.intermediario==usr||operationInstance.company==usr){
						try {
							if(operationInstance.user==usr){
								operationInstance.status=TRANSACTIONSTATUS.CANCELED
							}else{
								operationInstance.status=TRANSACTIONSTATUS.CANCELED_EMP
							}
							operationInstance.save(flush:true)

							if(usr instanceof CorporateUser){
								Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
										[cClass: OperationCompanyHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED])
							}else{
								Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
										[cClass: OperationHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED])
							}

							def trackOperation=new TrackOperation()
							trackOperation.status=operationInstance.status
							trackOperation.operation=operationInstance
							trackOperation.save(flush:true)
							render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
						}
						catch (org.springframework.dao.DataIntegrityViolationException e) {
							render(contentType: 'text/json',encoding:"UTF-8") { status=123 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}
		
	/**
	 * params {userId} {id}
	 */
	def finish={
		try{
			def usr=User.get(params?.userId)
			if(usr){
				def id=params?.id
				def operationInstance = Operation.get(params.id)
				if(operationInstance){
					if (operationInstance.user==usr||operationInstance.taxista==usr||operationInstance.intermediario==usr||operationInstance.company==usr){
						try {
							if(operationInstance?.isCompanyAccount){
								Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
										[cClass: OperationCompanyHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.COMPLETED])
							}else{
								Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
										[cClass: OperationHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.COMPLETED])
							}
							def trackOperation=new TrackOperation()
							trackOperation.status=operationInstance.status
							trackOperation.operation=operationInstance
							trackOperation.save(flush:true)
							render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
						}
						catch (org.springframework.dao.DataIntegrityViolationException e) {
							render(contentType: 'text/json',encoding:"UTF-8") { status=123 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
		
	}
	
}

