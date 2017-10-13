package com.page
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils

import ar.com.goliath.*

import com.*
class HomeController {
	def springSecurityService
	def placeService
	def emailService
	def index = {
		redirect action:'pedir'
	}

	def pedir_ahora = {
	}
	def pedir = {
	}
	def save={Pedir1Command command ->
		def user=springSecurityService.currentUser
		if (command.hasErrors()) {
			command.errors.allErrors.each {
				log.error it
				}
			flash.error=message(code: 'home.create.trip.form.error')
			render  (view:"/home/pedir" ,model:[command:command])
			return
		}
		def cities=EnabledCities.findAllByEnabled(true)

		boolean isInCityEnabled=false;
		for (EnabledCities cit :cities){
			if(command.placeinput1.contains(cit.admin1Code)){
				isInCityEnabled=true
			}
		}
		if(isInCityEnabled){
			try{
				String place1=null
				String place2=null

				if( command.values[0] instanceof String){
					place1=command.values[0];
				}else{
					def lp=command.values[0];
					place1=lp[0]
					place2=lp[1]
				}

				def o = grails.converters.JSON.parse(place1)
				def pl = new Place(o)
				pl.json = place1
				if(pl.streetNumber!=null  ){
					def dvce=Device.findAllByUser(user)
					dvce.each{
						it.delete()
					}

					def devic=new Device()
					devic.keyValue="sin key osea web"
					devic.description="  "
					devic.dev=UserDevice.WEB
					devic.user=user
					devic.save(flush:true)
					placeService.createFavoriteAndOperation(user,place1,place2,true,command.piso,command.departamento,command.comentarios,command.placeinput1,,command.placeinput2,devic.dev)

					def conf = SpringSecurityUtils.securityConfig
					if(!user?.isTestUser){
						emailService.send("rrhh@technorides.com",conf.ui.register.emailFrom, "NUEVO VIAJE ${devic.dev}", user.email)
					}
				}else{
					flash.error=message(code: 'home.create.trip.address.error')
					redirect(controller: "home", action: "pedir")
					return
				}


			}catch (Exception e){

				flash.error=message(code: 'home.create.trip.exception.error')
				redirect(controller: "home", action: "pedir",model:[command:command])
				return
			}
			redirect(controller: "home", action: "complete")
		}else{
			flash.error=message(code: 'home.create.trip.city.error')

			redirect(controller: "home", action: "pedir")

		}

	}
	def comoFunciona={

//		Facebook facebook = new FacebookTemplate(token.accessToken)
//		FacebookProfile fbProfile = facebook.userOperations().userProfile
//		String email = fbProfile.getEmail()

	}
	def nosotros = {
	}
	def complete={

	}
	def download={

	}
	def contact={

	}
	def termsAndConditions={

	}
	def saveContact={
		def contact = new Contact(params)

		def us=springSecurityService.currentUser
		us.attach()
		if(us instanceof FacebookUser){
			contact.email=us.user.email
			contact.firstName=us.user.firstName
			contact.lastName=us.user.lastName
			contact.phone=us.user.phone
		}else{
			contact.email=us.email
			contact.firstName=us.firstName
			contact.lastName=us.lastName
			contact.phone=us.phone

		}
		if (!contact.save(flush: true)) {
			render(view: "contact", model: [contact: contact])
			flash.error="Debe completar todos los campos para enviar la consulta"
			return
		}
		flash.message="Se ha enviado la consulta correctamente, en breves momentos se contactara una persona de soporte."
		redirect(action: "contactShow")
	}
	def contactShow={

	}
}
class Pedir1Command {
	String placeinput1
	String departamento
	String piso
	String comentarios
	String placeinput2
	String term
	String list
	List values = []
	static constraints = {
		placeinput1  blank: false, minSize: 3, maxSize: 99
	}
}
