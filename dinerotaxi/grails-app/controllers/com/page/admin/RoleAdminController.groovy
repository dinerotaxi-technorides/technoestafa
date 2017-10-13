package com.page.admin
import  ar.com.goliath.*
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import grails.converters.JSON
import ar.com.goliath.*
import ar.com.operation.OFStatus
import ar.com.operation.OnlineRadioTaxi
import ar.com.operation.TRANSACTIONSTATUS
import  ar.com.notification.ConfigurationApp
import org.codehaus.groovy.grails.commons.*
import org.json.JSONArray;
class RoleAdminController {
	def roleService
	def grailsUrlMappingsHolder
	def index = {

		[role:Role.list()]
	}
	def updateRequestMap = {

		def role = params['id']
		def roleSelected = Role.get(role)
		def requestMap
		def requestss
		if(roleSelected){
			requestMap=Requestmap.findAllByConfigAttribute(roleSelected?.authority)
			requestss=getGrailsApplication().controllerClasses.each{ controllerClass ->

				boolean res=false;
				for(Requestmap requestmapdto:requestMap){
					if(requestmapdto.url.contains(controllerClass.logicalPropertyName))
						res=true;
				}
				if(!res){
					"/"+controllerClass.logicalPropertyName+"/**"
				}
			}
		}


		render(template:'requestmap', model:[requestMaps: requestMap,requestss:requestss])
	}
	def updateAll={
		def json = request.JSON
		def roleSelected = Role.get(json.role)
		
		def config = ConfigurationHolder.config
		
		config.countries.each{
			log.error it
		}
		if(roleSelected){
			roleService.cleanUrlsForRole(roleSelected)
			roleService.roleUpdater(roleSelected,json.urls,"")
			config.countries.each{
				roleService.roleUpdater(roleSelected,json.urls,it)
			}
			render([success: true,message: "OK"] as JSON)
		}else{
			render([error: true,message: "NO SE ENCONTRO EL ROL"] as JSON)
		}
	}
}