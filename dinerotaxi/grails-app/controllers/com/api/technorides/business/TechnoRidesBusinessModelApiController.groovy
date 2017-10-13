

package com.api.technorides.business

import grails.converters.JSON
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.goliath.business.BusinessConfigModel
import ar.com.goliath.business.BusinessModel
import ar.com.goliath.business.BusinessModelConfigGroup
import ar.com.goliath.business.UserBusinessModel

import com.api.technorides.TechnoRidesValidateApiController
class TechnoRidesBusinessModelApiController extends TechnoRidesValidateApiController {
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
		
		render BusinessModel.list() as JSON
	}
	def get_business_model = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			
			render usr.businessModel.collect(){
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
	def attach_business_model = {
		def tok=PersistToken.findByToken(params?.token)
		
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		
		def bs=BusinessModel.findByName(params?.name)
		if(bs){
			
			if (!usr.businessModel.contains(bs)) {
				UserBusinessModel.create usr, bs
			}
		}
		render(contentType:'text/json',encoding:"UTF-8") {
			status=200
		}
		
	}
	def remove_business_model = {
		def tok=PersistToken.findByToken(params?.token)
		
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		
		def bs=BusinessModel.findByName(params?.name)
		if(bs){
			if (usr.businessModel.contains(bs)) {
				UserBusinessModel.remove usr, bs
			}
		}
		render(contentType:'text/json',encoding:"UTF-8") {
			status=200
		}
		
	}
	def create_business_model = {
		try{
			if(params?.name){
				def businessModelGeneric=BusinessModel.findByName(params?.name)
				if(!businessModelGeneric){
					def b = new BusinessModel(name:params?.name,config:new BusinessConfigModel())
					if(!b.save(flush:true)){
						b.errors.each {
							print it
						}
					}
				}
				
				
			}
			render(contentType:'text/json',encoding:"UTF-8") {
				status=200
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
	
	def create_config_group = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			
			if(!params?.name || !params?.business_id){
				render(contentType:'text/json',encoding:"UTF-8") {
					status=400
				}
				
			}
			def bs = BusinessModel.get(params?.business_id)
			
			if(!usr.businessModel.contains(bs)){
				render(contentType:'text/json',encoding:"UTF-8") {
					status=401
				}
			}
			boolean can_create = true
			def bsConfig = BusinessConfigModel.get(usr.businessModel.config.id)
			for(conf in bsConfig.groupConfig){
				if(conf?.name && conf.name.equals(params.name))
					can_create =false
			}
			if (can_create){
				def new_group = new BusinessModelConfigGroup(name:params.name).save()
				bsConfig.addToGroupConfig(new_group)
				bsConfig.save()
				render(contentType:'text/json',encoding:"UTF-8") {
					status=200
				}
				return
			}else{
			
				render(contentType:'text/json',encoding:"UTF-8") {
					status=402
				}
				return
				
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") {
				status=11
			}
		}
		
	}
	
	def get_config_group = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
//			render usr.businessModel as JSON
			render usr.businessModel.collect(){BusinessModel bs->
				print bs.name
				def businessModelConfigParams=bs.config
				def fb = bs.config.collect(){
					it.groupConfig
				}
				return [
					name:bs.name,
					configsParams:fb as JSON
				]
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
	
	def add_pair_config_group = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			
			if(!params?.name || !params?.business_id){
				render(contentType:'text/json',encoding:"UTF-8") {
					status=400
				}
				
			}
			def bs = BusinessModel.get(params?.business_id)
			
			if(!usr.businessModel.contains(bs)){
				render(contentType:'text/json',encoding:"UTF-8") {
					status=401
				}
			}
			boolean can_create = true
			def bsConfig = BusinessConfigModel.get(usr.businessModel.config.id)
			for(conf in bsConfig.groupConfig){
				if(conf?.name && conf.name.equals(params.name))
					conf.keyValue.put(params.key,params.val)
					conf.save()
			}
//			
			render(contentType:'text/json',encoding:"UTF-8") {
				status=200
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
	
	
}

