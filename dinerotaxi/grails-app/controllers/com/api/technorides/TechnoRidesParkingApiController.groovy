package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.operation.Operation
import ar.com.operation.Parking
class TechnoRidesParkingApiController extends TechnoRidesValidateApiController {
	def technoRidesOperationService
	def utilsApiService
	def operationApiService
	def sendGridService
	def technoRidesEmailService
	def springDineroTaxiService
	def springSecurityService
	def rememberMeServices

	def addExcept(list) {
		list <<'get'//'index' << 'list' << 'show'
	}
	def get={
		Operation.list().each{
			it.company=it.user.rtaxi
			it.save(flush:true)
		}
		render "asd"
	}
	def jq_parking = {
		println "jq_parking"
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def is_polygon = false
			def techno=null
			if(params.isPolygon !=null ){
				techno= Parking.findAllByUserAndIsPolygon( rtaxi,params?.isPolygon)
				
			}else{
				techno= Parking.findAllByUserAndIsPolygon( rtaxi,false)
			
			}
			def jsonCells = techno.collect {
				[lat:it.lat,
				 lng:it.lng,
				 name:it.name, 
				 isPolygon:it.isPolygon,
				 coordinatesIn:it.coordinatesIn,
				 coordinatesOut:it.coordinatesOut,
				 id: it.id]
			}
			def result = [rows:jsonCells,status:100]
			render result as JSON
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") {
				status=11
			}
		}
	}
	def jq_edit_parking  = {
		print "jq_edit_parking"
		def parking = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id_op = null
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		
		boolean is_not_polygon = params?.isPolygon != null && params.boolean('isPolygon') ==false 
		
		if(is_not_polygon){
			params.lat = params?.double('lat')
			params.lng  = params?.double('lng')
		}else{
			params.lat = 0d
			params.lng = 0d
		}
		
		// determine our action
		switch (params.oper) {
			case 'add':
				boolean is_valid_to_add = false
				if(!isValidToAdd(params)){
					render(contentType:'text/json',encoding:"UTF-8") {
						status=12
					}
					return;
				}
				parking = new Parking(params)
				parking.user = rtaxi
				if (! parking.hasErrors() && parking.save(flush:true)) {
					id_op = parking.id
					message = "Parkings Added"
					state = "OK"
				} else {
					message = "Could Not Save Parkings"
					parking.errors.each{
						print it
					}
				}
	
				break;
			case 'del':
				// check Spam exists
				parking = Parking.get(params.id)
				if (parking && parking.user == rtaxi) {
					// delete Spam
					id_op = parking.id
					parking.delete()
					message = "Parking  ${parking.id}  Deleted"
					state = "OK"
				}
				break;
			default:
				// default edit action
				// first retrieve the parking by its ID
				
				if(!isValidToAdd(params)){
					render(contentType:'text/json',encoding:"UTF-8") {
						status=12
					}
					return;
				}
				parking = Parking.get(params.id)
				if (parking  && parking.user == rtaxi) {
					id_op = parking.id
					parking.properties = params
					parking.user = rtaxi
					if (! parking.hasErrors() && parking.save(flush:true)) {
						message = "parking Updated"
						state = "OK"
					} else {
						message = "Could Not Update  "
						parking.errors.each{
							print it
						}
					}
				}
				break;
		}

		def response = [message:message,state:state,id:id_op]

		render response as JSON
	}
	def isValidToAdd(def params){
		
		boolean is_not_polygon = params?.isPolygon != null && params.boolean('isPolygon') ==false
		boolean validate_coord_in =true;
		boolean validate_coord_out = true;
			
		if(is_not_polygon && validateLatLng( params.lat,params.lng) ){
			return true
		}else if(!is_not_polygon){
			def coordinatesIn = JSON.parse(params.coordinatesIn)
			def coordinatesOut = JSON.parse(params.coordinatesOut)
			for (cordinate in coordinatesIn){
				if(!validateLatLng(cordinate['lat'],cordinate['lng'])){
					validate_coord_in = false
				}
			}
			for (cordinate in coordinatesOut){
				if(!validateLatLng(cordinate['lat'],cordinate['lng'])){
					validate_coord_out = false
				}
			}
			
		} 
		if(validate_coord_in && validate_coord_out){
			return true
		}
		return false
	}
	def validateLatLng(lat,lng){
		if(lat >= -90 && lat <=90 && lng >= -180 && lng <=180 ){
			return true
		}
		return false
	}

}

