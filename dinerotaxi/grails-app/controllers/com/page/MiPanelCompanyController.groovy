package com.page
import java.util.List;

import com.api.PlaceService;

import ar.com.goliath.*
import ar.com.operation.Operation
import ar.com.operation.OperationPending;
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.OperationHistory
import grails.converters.JSON
import ar.com.favorites.Favorites
class MiPanelCompanyController {
	def springSecurityService
	def placeService
	def miPanelCompanyService
	def index = {
		
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def intermediario=null
		def company=null
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			 intermediario = EmployUser.findByUsername(principal.username)
			 company=intermediario.employee
		}else if ( userInstance.authorities.contains(companyRole) ){
			 intermediario = User.findByUsername(principal.username)
			 company=intermediario
		}
		
		
		
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[operationInstanceList:miPanelCompanyService.getAll(params,company) 
			,operationInstanceTotal:miPanelCompanyService.getAllCount(params,company) ]
	}
	def data = {
		def principal = springSecurityService.principal
		def userInstance = Company.findByUsername(principal.username)
		[usr:userInstance]
	}
	def saveModification={
		def principal = springSecurityService.principal
		def usr = Company.findByUsername(principal.username)
		def userInstance=Company.get(usr.id)
		if(userInstance) {
			if(params.version) {
				def version = params.version.toLong()
				if(userInstance.version > version) {
					render view:'data', model:[usr:userInstance]
					return
				}
			}
			userInstance.properties = params
			if(!userInstance.hasErrors() && userInstance.save(flush:true)) {
				flash.message = "Se han realizado los cambios con exito"

				redirect action:'data', id:userInstance.id
			}
			else {
				render view:'data', model:[usr:userInstance]
			}
		}
		else {
			flash.message = "No se encuentra el usuario"
			redirect action:'data'
		}
	}
	def clients = {
		def principal = springSecurityService.principal
		def userInstance = RealUser.findByUsername(principal.username)
		def c = Favorites.createCriteria()
		def c1 = Favorites.createCriteria()
		def opL=c.list([offset:params.offset,max:params.max]){
			and{
				eq ('user',userInstance)
				eq('enabled',true)
			}
		}
		def opLC=c1.get(){
				eq ('user',userInstance)
				eq('enabled',true)
				projections{
					countDistinct("id")
				}
		}
		[operationInstanceList:opL, operationInstanceTotal: opLC]
	}
}
class NewFavoriteClient1 {
	String placeinput1
	String departamento
	String piso
	String name
	String term
	String list
	List values = []
	static constraints = {
		name blank: false, minSize: 2, maxSize: 99
		placeinput1  blank: false, minSize: 3, maxSize: 99
	}
}
