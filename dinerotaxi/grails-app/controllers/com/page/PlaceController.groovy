package com.page
import ar.com.goliath.Place
import grails.converters.*
import org.codehaus.groovy.grails.web.json.*; // package containing JSONObject, JSONArray,...

class PlaceController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def springSecurityService
    def placeService

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [placeInstanceList: Place.list(params), placeInstanceTotal: Place.count()]
    }

    def create = {
        def placeInstance = new Place()
        placeInstance.properties = params
        return [placeInstance: placeInstance]
    }
    
    def deleteAjax = { PlaceCommand place ->
        place.deletePlace();
        render {status: 'success'}
    }
    
    def saveAjax = { PlaceCommand place ->
        place.savePlace();
        render place as JSON
    }

    def show = {
        def placeInstance = Place.get(params.id)
        if (!placeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'place.label', default: 'Place'), params.id])}"
            redirect(action: "list")
        }
        else {
            [placeInstance: placeInstance]
        }
    }

    def edit = {
        def placeInstance = Place.get(params.id)
        if (!placeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'place.label', default: 'Place'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [placeInstance: placeInstance]
        }
    }

    def update = {
        if (placeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (placeInstance.version > version) {
                    
                    placeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'place.label', default: 'Place')] as Object[], "Another user has updated this Place while you were editing")
                    render(view: "edit", model: [placeInstance: placeInstance])
                    return
                }
            }
            placeInstance.properties = params
            if (!placeInstance.hasErrors() && placeInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'place.label', default: 'Place'), placeInstance.id])}"
                redirect(action: "show", id: placeInstance.id)
            }
            else {
                render(view: "edit", model: [placeInstance: placeInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'place.label', default: 'Place'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def placeInstance = Place.get(params.id)
        if (placeInstance) {
            try {
                placeInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'place.label', default: 'Place'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'place.label', default: 'Place'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'place.label', default: 'Place'), params.id])}"
            redirect(action: "list")
        }
    }
    
    def editmodal = { PlaceCommand command -> 
		 def user = springSecurityService.currentUser

        if(request.method == 'GET') {
            def list = []
            if(user){
              user.places.each{
                 def map = [:]
                 map.id = it.json
                 map.name = it.name
                 list.add(map)
              }
              command.list = list as JSON
            }
            render (template:"editplacemodal", model:[command: command])
        }
        if(request.method == 'POST') {            
            if(!command.hasErrors()) {
                placeService.updatePlaces(user, command.values)
                //command.update(user)
                render template:"list", model:[command: user]
            }
            else {
                render (status: 202, template:"addproductmodal", model:[command: command])
            }            
        }
    }    
	def editmodal1 = { PlaceCommand command ->
		def user = springSecurityService.currentUser

		if(request.method == 'GET') {
			def list = []
			
			if(user){
			  user.places.each{
				 def map = [:]
				 map.id = it.json
				 map.name = it.name
				 list.add(map)
			  }
			  command.list = list as JSON
			}
			render (template:"editplacemodal", model:[command: command])
		}
		if(request.method == 'POST') {
			if(!command.hasErrors()) {
				placeService.updatePlaces(user, command.values)
				//command.update(user)
				render template:"list", model:[command: user]
			}
			else {
				render (status: 202, template:"addproductmodal", model:[command: command])
			}
		}
	}
}

public class PlaceCommand {
    String term
    String list
    List values = []
    
    static constraints = {
    }    
}

public class PlaceCommandxx {
    String id
    
    String lang = "en"
    String name

    String country
    String countryCode

    String admin1Code
    String admin2Code
    String admin3Code

    String locality
    String street

    String lat
    String lng
	
    String northEastLatBound
    String northEastLngBound
    String southWestLatBound
    String southWestLngBound
	
    String postalCode
    String streetNumber

    String locationType
    String type

    static constraints = {
        lang (nullable:false, maxSize:10)
        name (nullable:false, maxSize:200)

        country (nullable:true, maxSize:200)
        countryCode (nullable:true, maxSize:2)

        admin1Code (nullable:true, maxSize:200)
        admin2Code (nullable:true, maxSize:200)
        admin3Code (nullable:true, maxSize:200)

        locality (nullable:true, maxSize:200)
        street (nullable:true, maxSize:200)	

        lat (nullable:true)
        lng (nullable:true)

        northEastLatBound (nullable:true)
        northEastLngBound (nullable:true)
        southWestLatBound (nullable:true)
        southWestLngBound (nullable:true)		

        postalCode (nullable:true, maxSize:10)
        streetNumber (nullable:true, maxSize:10)

        locationType (nullable:true, maxSize:20)
        type (nullable:true, maxSize:20)
    }
	
    Place savePlace() {
        def place = new Place(lat:lat, lng:lng,
              northEastLatBound:northEastLatBound, northEastLngBound:northEastLngBound, 
              southWestLatBound:southWestLatBound, southWestLngBound:southWestLngBound, 
              postalCode:postalCode, streetNumber:streetNumber,
              locationType:locationType, type:type, name:name, country:country, street:street)
        place.save(flush:true)
        id = place.id;
        return place
    }	
    
    Place deletePlace() {
        if(id){
            def pl = Place.get(id)
            if(pl){
                pl.delete()
            }
        }
    }
}

