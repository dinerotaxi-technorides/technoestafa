package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.notification.Zone
import ar.com.notification.ZonePricing
class TechnoRidesZoneApiController extends TechnoRidesValidateApiController {
	def technoRidesZoneService

	def addExcept(list) {
		list <<'get'
	}
	def get={
		render "asd"
	}
	def jq_zone = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesZoneService.getZone(params, rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_zone_pricing = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesZoneService.getZonePricing(params, rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_edit_zone  = {
		def zone = null
		def intermediario =null
		def message = ""
		def state = "FAIL"
		def id = null
		def tok=PersistToken.findByToken(request.JSON.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		// determine our action
		switch (request.JSON.oper) {
			case 'add':
				zone = new Zone(request.JSON)
				zone.user = rtaxi
				if (! zone.hasErrors() && zone.save(flush:true)) {
					def techno= technoRidesZoneService.generateZonePricing( rtaxi,zone)
					message = "Zone Added"
					state = "OK"
				} else {
					message = "Could Not Save Expenses"
				}

				break;
			case 'del':
				// check Spam exists
				zone = Zone.get(request.JSON.id)
				if (zone && zone.user == rtaxi) {
					ZonePricing.findAllByZoneFrom(zone).each{
						it.delete()
					}
					ZonePricing.findAllByZoneTo(zone).each{
						it.delete()
					}
					// delete Spam
					zone.delete()
					message = "Zone  ${zone.id}  Deleted"
					state = "OK"
				}
				break;
			default:
				// default edit action
				// first retrieve the zone by its ID
				zone = Zone.get(request.JSON.id)
				if (zone  && zone.user == rtaxi) {
					zone.properties = request.JSON
					zone.user = rtaxi
					if (! zone.hasErrors() && zone.save(flush:true)) {
						message = "zone Updated"
						id = zone.id
						state = "OK"
					} else {
						message = "Could Not Update  "
					}
				}
				break;
		}
		def response = [message:message,state:state,id:id]

		render response as JSON
	}
	def jq_edit_zone_pricing = {
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {


			default:
			// default edit action
			// first retrieve the customer by its ID
				def zone = ZonePricing.get(params.id)
				if (zone) {
					zone.amount = params.double('amount')

					if (! zone.hasErrors() && zone.save(flush:true)) {
						message = "Zone  ${zone.user}  Updated"
						id = zone.id
						state = "OK"
					} else {
						message = "Could Not Update Zone"
					}
				}
				break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	}
}
