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
class MiPanelTaxistaController {
	def springSecurityService
	def placeService
	def MiPanelTaxistaService
	def index = {
		def principal = springSecurityService.principal
		def userInstance = EmployUser.findByUsername(principal.username)
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[operationInstanceList:MiPanelTaxistaService.getAll(params,userInstance) 
			,operationInstanceTotal:MiPanelTaxistaService.getAllCount(params,userInstance) ]
	}
	def calendar = {
	}
	def data = {
		def principal = springSecurityService.principal
		def userInstance = EmployUser.findByUsername(principal.username)
		[usr:userInstance]
	}
	def cancelOrder={
		def principal = springSecurityService.principal
		def usr = RealUser.findByUsername(principal.username)
		def operationInstance = Operation.get(params.id)
		if (operationInstance.user==usr){
		
			if (operationInstance) {
				try {
					//operationInstance.delete(flush: true)
						Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
						[cClass: OperationHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED])
					flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'OperationPending.label', default: 'OperationPending'), params.id])}"
					redirect(action: "index")
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'OperationPending.label', default: 'OperationPending'), params.id])}"
					redirect(action: "index")
				}
			}
			else {
				flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'OperationPending.label', default: 'OperationPending'), params.id])}"
				redirect(action: "index")
			}
		}
	}
	def deleteAll() {
		def principal = springSecurityService.principal
		def usr = RealUser.findByUsername(principal.username)
		def c = Operation.createCriteria()
		def opL=c.list([offset:params.offset,max:params.max]){
			and{
				eq ('user',usr)
				eq('enabled',true)
			}
		}
		opL.each {
			it.setEnabled(false);
			it.save(flush:true);
		}
		flash.message = message(code: 'default.deleted.elements', args: [message(code: 'operation.history.label', default: 'OperationHistory'), params])
		redirect action:index

	}
	def deleteAllFavorites() {
		def principal = springSecurityService.principal
		def usr = RealUser.findByUsername(principal.username)
		placeService.deleteFavorites(usr)
		flash.message = message(code: 'default.deleted.elements', args: [message(code: 'operation.history.label', default: 'OperationHistory'), params])
		redirect(controller: "miPanel", action: "clients")
	}
	def deleteFavorite() {
		def principal = springSecurityService.principal
		def usr = RealUser.findByUsername(principal.username)
		if(params?.favorite){
			placeService.deleteFavorite(Long.valueOf(params?.favorite))
			flash.message = message(code: 'default.deleted.elements', args: [message(code: 'operation.history.label', default: 'OperationHistory'), params])
		}else{
			flash.error = message(code: 'default.deleted.elements', args: [message(code: 'operation.history.label', default: 'OperationHistory'), params])
		}
		redirect(controller: "miPanel", action: "clients")

	}
	def delete() {
		def principal = springSecurityService.principal
		def usr = RealUser.findByUsername(principal.username)
		params.deleteChecked.each {
			def operationHistoryInstance = Operation.get(it)
			if (operationHistoryInstance.user==usr){
				operationHistoryInstance.setEnabled(false);
				operationHistoryInstance.save(flush:true);
			}
		}
		flash.message = message(code: 'default.deleted.elements', args: [message(code: 'operation.history.label', default: 'OperationHistory'), params])
		redirect action:index

	}
	def saveModification={
		def principal = springSecurityService.principal
		def usr = EmployUser.findByUsername(principal.username)
		def userInstance=EmployUser.get(usr.id)
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
	def newFavorites = {NewFavoriteClient command ->
		def principal = springSecurityService.principal
		def userInstance = RealUser.findByUsername(principal.username)
		
		if (command.hasErrors()) {
			command.errors.allErrors.each {
				log.error it
				}
			flash.error="Por favor corrija Los valores puestos en "
			redirect(controller: "miPanel", action: "clients")
			return
		}
		
		try{
			String place1=null
			place1=command.values[0];
			placeService.createFavorite(userInstance,place1,command.piso,command.departamento,command.name)
		}catch (Exception e){
		
			flash.error="Error Al crear y procesar su pedido , Intentelo Nuevamente"
			render  (view:"/miPanel/favorites" ,model:[command:command])
			return
		}
		redirect(controller: "miPanel", action: "clients")
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
class NewFavoriteClient {
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
