package com.page
import grails.converters.JSON
import ar.com.favorites.Favorites
import ar.com.goliath.*
import ar.com.operation.Operation
import ar.com.operation.OperationHistory
import ar.com.operation.OperationPending
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.TrackOperation

import com.UserDevice
class MiPanelController {
	def springSecurityService
	def placeService
	def onlineNotificationService
	def notificationService
	def index = {
		def userInstance = springSecurityService.currentUser
		def opPending=OperationPending.findAllWhere(user:userInstance)
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def c = OperationHistory.createCriteria()
		def c1 = OperationHistory.createCriteria()
		def opL=c.list([offset:params.offset,max:params.max]){
			and{
				eq ('user',userInstance)
				eq('enabled',true)
			}

			order("createdDate", "desc")
		}
		def opLC=c1.get(){
			eq ('user',userInstance)
			eq('enabled',true)
			projections{ countDistinct("id") }
		}
		[opPending:opPending,operationInstanceList:opL ,operationInstanceTotal:opLC]
	}
	def calendar = {
	}
	def data = {
		def userInstance = springSecurityService.currentUser
		[usr:userInstance]
	}
	def cancelOrder={
		def usr = springSecurityService.currentUser
		def operationInstance = Operation.get(params.id)
		if (operationInstance.user==usr){

			if (operationInstance) {
				try {
					operationInstance.status=TRANSACTIONSTATUS.CANCELED
					def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.CANCELED)
					trackOperation.operation=operationInstance
					trackOperation.save(flush:true)

					operationInstance.save(flush:true)

					Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
							[cClass: OperationHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED])
					notificationService.notificateOnCancelTripByUser(operationInstance,usr)
					notificationService.notificateOnCancelTripByUserForRadioTaxi(operationInstance,usr)
					flash.message =  message(code: 'mipanel.mispedidos.cancelOrder.success')
					redirect(action: "index")
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					flash.error = message(code: 'mipanel.mispedidos.cancelOrder.error')
					redirect(action: "index")
				}
			}
			else {
				flash.error = message(code: 'mipanel.mispedidos.cancelOrder.error.not.found')
				redirect(action: "index")
			}
		}
	}
	def deleteAll() {
		def usr = springSecurityService.currentUser
		def c = OperationHistory.createCriteria()
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
		flash.message = message(code: 'mipanel.mispedidos.deleteAll.success')
		redirect action:index
	}
	def deleteAllFavorites() {
		def usr = springSecurityService.currentUser
		placeService.deleteFavorites(usr)
		flash.message = message(code: 'mipanel.favorites.deleteFavorites.success')
		redirect(controller: "miPanel", action: "favorites")
	}
	def deleteFavorite() {
		def userInstance = springSecurityService.currentUser
		if(params?.favorite){
			placeService.deleteFavorite(Long.valueOf(params?.favorite))
			flash.message = message(code: 'mipanel.favorites.deleteFavorite.success')
		}else{
			flash.error = message(code: 'mipanel.favorites.deleteFavorite.error')
		}
		redirect(controller: "miPanel", action: "favorites")
	}
	def delete() {
		def usr = springSecurityService.currentUser
		if (params.deleteChecked instanceof String){
			def operationHistoryInstance = Operation.get(params.deleteChecked)
			if (operationHistoryInstance.user==usr){
				operationHistoryInstance.setEnabled(false);
				operationHistoryInstance.save(flush:true);
			}
			flash.message = message(code: 'mipanel.mispedidos.delete.success')
		}else{
			params.deleteChecked.each {
				def operationHistoryInstance = Operation.get(it)
				if (operationHistoryInstance.user==usr){
					operationHistoryInstance.setEnabled(false);
					operationHistoryInstance.save(flush:true);
				}
			}
			flash.message = message(code: 'mipanel.mispedidos.delete1.success')
		}
		redirect action:index
	}
	def saveModification={
		def userInstance = springSecurityService.currentUser
		if(userInstance) {
			if(params.version) {
				def version = params.version.toLong()
				if(userInstance.version > version) {
					flash.error = message(code: 'mipanel.midata.save.optimistick.locking')
					render view:'data', model:[usr:userInstance]
					return
				}
			}
			userInstance.properties = params
			if(!userInstance.hasErrors() && userInstance.save(flush:true)) {
				flash.message = message(code: 'mipanel.midata.save.message')

				redirect action:'data', id:userInstance.id
			}
			else {
				flash.error = message(code: 'mipanel.midata.save.error.save')
				render view:'data', model:[usr:userInstance]
			}
		}
		else {

			flash.error = message(code: 'mipanel.midata.save.error')
			redirect action:'data'
		}
	}
	def newFavorites = {NewFavorites command ->
		def userInstance = springSecurityService.currentUser

		if (command.hasErrors()) {
			command.errors.allErrors.each { log.error it }
			flash.error=message(code: 'mipanel.newFavorite.save.error')
			redirect(controller: "miPanel", action: "favorites")
			return
		}

		try{
			String place1=null
			place1=command.values[0];

			def o = grails.converters.JSON.parse(place1)
			def pl = new Place(o)
			pl.json = place1
			if(pl.streetNumber!=null  ){
				placeService.createFavorite(userInstance,place1,command.piso,command.departamento,command.name)
				flash.message=message(code: 'mipanel.newFavorite.save.success')
			}else{
				flash.error=message(code: 'home.create.trip.address.error')
			}
		}catch (Exception e){

			flash.error="Error Al crear y procesar su pedido , Intentelo Nuevamente"
			render  (view:"/miPanel/favorites" ,model:[command:command])
			return
		}
		redirect(controller: "miPanel", action: "favorites")
	}
	def jq_add_favorite={

		def message = ""
		def state = "FAIL"
		def response = [message:message,state:state,id:id]

		render response as JSON
	}
	def favorites = {
		def userInstance = springSecurityService.currentUser
		if(params?.tripfavorite){
			def fav=Favorites.get(params?.tripfavorite)

			def cities=EnabledCities.findAllByEnabled(true)

			boolean isInCityEnabled=false;
			for (EnabledCities cit :cities){
				if(fav.placeFrom.json.contains(cit.admin1Code)){
					isInCityEnabled=true
				}
			}

			if(isInCityEnabled){
				if(fav.user==userInstance){

					def oper=new OperationPending(user:userInstance,favorites:fav,dev:UserDevice.WEB,isTestUser:userInstance.isTestUser)
					
					
					if(!oper.save(flush:true)){
						flash.error=message(code: 'mipanel.favorite.trip.favorite.error')
					}else{
						def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
						trackOperation.operation=oper
						trackOperation.save(flush:true)
						notificationService.notificateOnCreateTripWithFavorite(oper,userInstance)
						flash.message=message(code: 'mipanel.favorite.trip.favorite.success')
						redirect(controller: "miPanel", action: "index")
					}
				}else{
					flash.error=message(code: 'mipanel.favorite.trip.favorite.error.not.found')
				}
			}else{
				flash.error=message(code: 'home.create.trip.city.error')
			}
		}
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
			projections{ countDistinct("id") }
		}
		render(view: "favorites", model: [operationInstanceList:opL, operationInstanceTotal: opLC])
	}
}
class NewFavorites {
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
