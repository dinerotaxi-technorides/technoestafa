

package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.goliath.business.BusinessConfigModel
import ar.com.goliath.business.BusinessModel
import ar.com.goliath.business.BusinessModelConfigGroup
import ar.com.goliath.business.UserBusinessModel
import ar.com.operation.OperationAdditionalConfig;
class TechnoRidesOperationAdditionalApiController extends TechnoRidesValidateApiController {
	def technoRidesOperationService
	def utilsApiService
	def operationApiService
	def sendGridService
	def technoRidesEmailService
	def springDineroTaxiService
	def springSecurityService
	def rememberMeServices
    def gsonBuilder

	def addExcept(list) {
		list <<'get'//'index' << 'list' << 'show'
	}
	def get={
		
		render(contentType:'text/json',encoding:"UTF-8") {
			status=200
		}
	}
	def get_additionals = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def additionals = OperationAdditionalConfig.findAllByRtaxi(rtaxi)
			render additionals.collect(){
				it.name
			}
		
			return
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") {
				status=11
			}
		}
	}
	def put_additional = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		if (!params?.name){
			render(contentType:'text/json',encoding:"UTF-8") {
				status=400
			}
		}
		def additionals = OperationAdditionalConfig.findByRtaxiAndName(rtaxi,params.name )
		print additionals
		if(!additionals){
			def additional = new OperationAdditionalConfig(name:params.name,rtaxi:rtaxi)
			if(!additional.save()){
				additional.errors.each{
					print it
				}
				
				render(contentType:'text/json',encoding:"UTF-8") {
					status=11
				}
			}
		}
		render(contentType:'text/json',encoding:"UTF-8") {
			status=200
		}
		
	}
	def remove_additional = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		if (!params?.name){
			render(contentType:'text/json',encoding:"UTF-8") {
				status=200
			}
		}
		def additionals = OperationAdditionalConfig.findByRtaxiAndName(rtaxi,params.name )
		if(additionals){
			additionals.delete()
			
		}
		render(contentType:'text/json',encoding:"UTF-8") {
			status=200
		}
		
	}
	
	
	
}

