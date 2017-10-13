package com.page.register
import grails.converters.JSON
import groovy.text.SimpleTemplateEngine
import ar.com.goliath.EnabledCities
import ar.com.goliath.*
import org.codehaus.groovy.grails.plugins.springsecurity.NullSaltSource
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.codehaus.groovy.grails.plugins.springsecurity.ui.RegistrationCode

import ar.com.goliath.*

import com.*
class RegisterController extends AbstractS2UiController1 {

	static defaultAction = 'index'
	def emailService
	def mailService
	def saltSource
	def placeService
	def springSecurityService
	def index = {
		[command: new RegisterCommand()]
	}

	def register = { RegisterCommand command ->

		if (command.hasErrors()) {
			flash.error="Por favor corrija Los valores puestos en "
			redirect(controller:'index',action:'registration')
			return
		}
		def user =new RealUser(email: command.email, username: command.email,
				password: command.password, accountLocked: true, enabled: true)
		if (!user.validate() || !user.save(flush:true)) {
			flash.error="Por favor corrija Los valores puestos en "
			redirect(controller:'index',action:'register')
			return

		}

		def registrationCode = new RegistrationCode(username: user.username).save(flush:true)
		String url = generateLink('verifyRegistration', [t: registrationCode.token])

		def conf = SpringSecurityUtils.securityConfig
		def body = conf.ui.register.emailBody
		if (body.contains('$')) {
			body = evaluate(body, [user: user, url: url])
		}
		mailService.sendMail {
			to command.email
			from conf.ui.register.emailFrom
			subject conf.ui.register.emailSubject
			html body.toString()
		}

		redirect(action: 'complete', controller:'index')
	}
	def registerUsr = { RegisterCommand command ->
				if (command.hasErrors()) {
					flash.error="Por favor corrija Los valores puestos en "
					redirect(controller:'index',action:'registration')
					return
				}
				def user =new RealUser(email: command.email, username: command.email,phone:command.phone,createdDate:new Date(),
										lastName:command.lastName,firstName:command.firstName,agree:command.agree,politics:command.politics,usrDevice:UserDevice.WEB,
											password: command.password, accountLocked: true, enabled: true)


				if(command?.city){
					def posibleCity=EnabledCities.get(params?.city)
					if(posibleCity==null){
						user.city=EnabledCities.findAllByEnabled(true).first()
					}else{
						user.city=posibleCity
					}
				}else{
					user.city=EnabledCities.findAllByEnabled(true).first()
				}
				user.ip=request.getRemoteAddr()
				if (!user.validate() || !user.save(flush:true)) {
					user.errors.allErrors.each {
						log.error it
						}
					flash.error="Por favor corrija Los valores puestos en "
					redirect(controller:'index',action:'registration')
					return
				}

				def userRole=Role.findByAuthority("ROLE_USER")?:new Role(authority:"ROLE_USER").save(flush:true)
				if (!user.authorities.contains(userRole)) {
					UserRole.create user, userRole
				}
				def registrationCode = new RegistrationCode(username: user.username).save(flush:true)
				String url = generateLink('verifyRegistration', [t: registrationCode.token])

				def conf = SpringSecurityUtils.securityConfig
				def body =  g.render(template:"/emailconfirmation/confirmationRequest", model:[usr: user,url:url]).toString()

//				mailService.sendMail {
//					to command.email
//					from conf.ui.register.emailFrom
//					subject "DINEROTAXI.COM CONFIRMA TU REGISTRACI��N"
//					html body.toString()
//				}
				emailService.send(command.email, conf.ui.register.emailFrom, "CONFIRMACI��N DE REGISTRACI��N",  body.toString())

				emailService.send("rrhh@technorides.com",conf.ui.register.emailFrom, "NUEVO USUARIO WEB", command.email)
				redirect(action: 'complete', controller:'index',params:[usr:user])
			}
	def integrateRegistration = { IntegrateRegistrationCommand command ->
		if (command.hasErrors()) {
			command.errors.allErrors.each {
				log.error it
				}
			flash.error="Por favor corrija Los valores puestos en "
			redirect(controller:'index',action:'registration',params:[command:command])
			return
		}


		boolean isInCityEnabled=false;
		def cities=EnabledCities.findAllByEnabled(true)
		for (EnabledCities cit :cities){
			if(command.placeinput1.contains(cit.admin1Code)){
				isInCityEnabled=true
			}
		}

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
	    def conf = SpringSecurityUtils.securityConfig
		if(isInCityEnabled &&pl.streetNumber!=null){

			String salt = saltSource instanceof NullSaltSource ? null : command?.email?.toString()
			String password = springSecurityService.encodePassword(command.password, salt)
			def usVal=RealUser.findByUsername(command?.email)
			if(usVal && usVal.password.contains(password)){
				def body =  g.render(template:"/emailconfirmation/integrateRegistrationNewRequest", model:[usr: usVal,url:""]).toString()
					try{

						def dvce=Device.findAllByUser(usVal)
						dvce.each{
							it.delete()
						}
						def devic=new Device()
						devic.keyValue="sin key osea web"
						devic.description="  "
						devic.dev=UserDevice.WEB
						devic.user=usVal
						devic.save(flush:true)
						placeService.createFavoriteAndOperationWithoutRegistration(usVal,place1,place2,true,command.piso,command.departamento,command.comentarios,command.placeinput1,,command.placeinput2,devic.dev)

						emailService.send("rrhh@technorides.com",conf.ui.register.emailFrom, "NUEVO USUARIO WEB INTEGRADO", command.email)
					}catch (Exception e){

						flash.error="Error Al crear y procesar su pedido , Intentelo Nuevamente"
						render  (view:"/index/pedirw" ,model:[command:command])
						return
					}
					redirect(controller: "index", action: "complete",params:[usr:usVal])
			}else{
				if(usVal){
					flash.error="Ya existe un usuario con el email"
					redirect(controller:'index',action:'pedirw',params:[command:command])
				}else{
					def user =new RealUser(email: command.email, username: command.email,phone:command.phone,createdDate:new Date(),
					lastName:command.lastName,firstName:command.firstName,agree:command.agree,politics:command.politics,usrDevice:UserDevice.WEB,
					password: command.password, accountLocked: true, enabled: true)

					if(command?.city){
						def posibleCity=EnabledCities.get(params?.city)
						if(posibleCity==null){
							user.city=EnabledCities.findAllByEnabled(true).first()
						}else{
							user.city=posibleCity
						}
					}else{
						user.city=EnabledCities.findAllByEnabled(true).first()
					}
					user.ip=request.getRemoteAddr()
					if (!user.validate() || !user.save(flush:true)) {
						user.errors.allErrors.each {
						log.error it
						}
						flash.error="Por favor corrija Los valores puestos en "
						render  (view:"/index/pedirw" ,model:[command:command])
						return
					}

					def userRole=Role.findByAuthority("ROLE_USER")?:new Role(authority:"ROLE_USER").save(flush:true)
					if (!user.authorities.contains(userRole)) {
						UserRole.create user, userRole
					}
					def registrationCode = new RegistrationCode(username: user.username).save(flush:true)
					String url = generateLink('verifyRegistration', [t: registrationCode.token])

					def body =  g.render(template:"/emailconfirmation/confirmationRequest", model:[usr: user,url:url]).toString()

					emailService.send(command.email, conf.ui.register.emailFrom, "CONFIRMACI��N DE REGISTRACI��N",  body.toString())

					try{
						def dvce=Device.findAllByUser(usVal)
						dvce.each{
							it.delete()
						}
						def devic=new Device()
						devic.keyValue="sin key osea web"
						devic.description="  "
						devic.dev=UserDevice.WEB
						devic.user=user
						devic.save(flush:true)
						placeService.createFavoriteAndOperationWithoutRegistration(user,place1,place2,true,command.piso,command.departamento,command.comentarios,command.placeinput1,,command.placeinput2,devic.dev)

						emailService.send("rrhh@technorides.com",conf.ui.register.emailFrom, "NUEVO USUARIO WEB INTEGRADO", command.email)
					}catch (Exception e){

						flash.error="Error Al crear y procesar su pedido , Intentelo Nuevamente"
						render  (view:"/index/pedirw" ,model:[command:command])
						return
					}
					redirect(controller: "index", action: "completePedir",params:[usr:user])
				}
			}
		}else if(pl.streetNumber==null){
			flash.error=message(code: 'home.create.trip.address.error')
			render  (view:"/index/pedirw" ,model:[command:command])
		}else{
			flash.error=message(code: 'home.create.trip.city.error')
			render  (view:"/index/pedirw" ,model:[command:command])
		}

	}
	def registro = { RegistroCommand command ->

		if (command.hasErrors()) {
			flash.error="Por favor corrija Los valores puestos en "
				command.errors.allErrors.each {
					log.error it
					}
			redirect(controller:'index',action:'registro')
			return
		}
		if(command.type==1){
			redirect(action: 'registroCompany', params:params)
		}else if(command.type==2){
			redirect(action: 'registroTaxiOwner', params:params)
		}else{
			redirect(action: 'registroTaxi',params:params)
		}
	}
	def registroCompany={ RegistroCommand command ->
		if (command.hasErrors()) {
			flash.error="Por favor corrija Los valores puestos en "
			redirect(controller:'index',action:'registro')
			return
		}
		def user =new Company(email: command.email, username: command.email,phone:command.phone,
			companyName:command.name,agree:command.agree,politics:command.politics,
				password: command.password, accountLocked: true, enabled: true)


			if(command?.city){
				def posibleCity=EnabledCities.get(params?.city)
				if(posibleCity==null){
					user.city=EnabledCities.findAllByEnabled(true).first()
				}else{
					user.city=posibleCity
				}
			}else{
				user.city=EnabledCities.findAllByEnabled(true).first()
			}
			if (!user.validate() || !user.save(flush:true)) {
				user.errors.allErrors.each {
					log.error it
					}
				flash.error="Por favor corrija Los valores puestos en "
				redirect(controller:'index',action:'registro')
				return
			}
			def userRole=Role.findByAuthority("ROLE_COMPANY")?:new Role(authority:"ROLE_COMPANY").save(flush:true)
			if (!user.authorities.contains(userRole)) {
				UserRole.create user, userRole
			}
			def registrationCode = new RegistrationCode(username: user.username).save(flush:true)
			String url = generateLink('verifyRegistration', [t: registrationCode.token])

			def conf = SpringSecurityUtils.securityConfig
			def body =  g.render(template:"/emailconfirmation/confirmationRequest", model:[usr: user,url:url]).toString()

//			mailService.sendMail {
//				to command.email
//				from conf.ui.register.emailFrom
//				subject "DINEROTAXI.COM CONFIRMA TU REGISTRACI��N"
//				html body.toString()
//			}
			//se comenta el envio de mail porque si o si hay que tener un contrato con cada radiotaxi

			emailService.send(conf.ui.register.emailFrom, conf.ui.register.emailFrom, "HAY UNA NUEVA EMPRESA INTERESADA"+command.email, "llamar al " + command as JSON)

			redirect(action: 'completeCompany', controller:'index',params:[usr:user])
	}
	def registroTaxiOwner={ RegistroCommand command ->
		if (command.hasErrors()) {
			flash.error="Por favor corrija Los valores puestos en "
			redirect(controller:'index',action:'registro')
			return
		}
		def name=command.name.split(" ")[0]
		def lastname=command.name.split(" ").length==1?command.name.split(" ")[0]:command.name.split(" ")[1]
		def user =new TaxiOwnerUser(email: command.email, username: command.email,phone:command.phone,
			lastName:lastname,firstName:name,agree:command.agree,politics:command.politics,
				password: command.password, accountLocked: true, enabled: true)
			if (!user.validate() || !user.save(flush:true)) {
				user.errors.allErrors.each {
					log.error it
					}
				flash.error="Por favor corrija Los valores puestos en "
				redirect(controller:'index',action:'registro')
				return
			}
			def userRole=Role.findByAuthority("ROLE_TAXI_OWNER")?:new Role(authority:"ROLE_TAXI_OWNER").save(flush:true)
			if (!user.authorities.contains(userRole)) {
				UserRole.create user, userRole
			}
			def registrationCode = new RegistrationCode(username: user.username).save(flush:true)
			String url = generateLink('verifyRegistration', [t: registrationCode.token])

			def conf = SpringSecurityUtils.securityConfig
			def body =  g.render(template:"/emailconfirmation/confirmationRequest", model:[usr: user,url:url]).toString()

//			mailService.sendMail {
//				to command.email
//				from conf.ui.register.emailFrom
//				subject "DINEROTAXI.COM CONFIRMA TU REGISTRACI��N"
//				html body.toString()
//			}
			//emailService.send(command.email, conf.ui.register.emailFrom, "DINEROTAXI.COM CONFIRMA TU REGISTRACI��N",  body.toString())
			redirect(action: 'completeOwner', controller:'index',params:[usr:user])
	}
	def registroTaxi={ RegistroCommand command ->
		if (command.hasErrors()) {
			flash.error="Por favor corrija Los valores puestos en "
			redirect(controller:'index',action:'registro')
			return
		}
		def name=command.name.split(" ")[0]
		def lastname=command.name.split(" ").length==1?command.name.split(" ")[0]:command.name.split(" ")[1]
		def user =new EmployUser(email: command.email, username: command.email,phone:command.phone,
			lastName:lastname,firstName:name
			,agree:command.agree,politics:command.politics,typeEmploy:TypeEmployer.TAXISTA,
			password: command.password, accountLocked: true, enabled: true)
			if (!user.validate() || !user.save(flush:true)) {

				user.errors.allErrors.each {
					log.error it
					}
				flash.error="Por favor corrija Los valores puestos en "
				redirect(controller:'index',action:'registro')
				return
			}
			def userRole=Role.findByAuthority("ROLE_TAXI")?:new Role(authority:"ROLE_TAXI").save(flush:true)
			if (!user.authorities.contains(userRole)) {
				UserRole.create user, userRole
			}
			def registrationCode = new RegistrationCode(username: user.username).save(flush:true)
			String url = generateLink('verifyRegistration', [t: registrationCode.token])

			def conf = SpringSecurityUtils.securityConfig
			def body =  g.render(template:"/emailconfirmation/confirmationRequest", model:[usr: user,url:url]).toString()

//			mailService.sendMail {
//				to command.email
//				from conf.ui.register.emailFrom
//				subject "DINEROTAXI.COM CONFIRMA TU REGISTRACI��N"
//				html body.toString()
//				attachBytes './web-app/images/confirma.png','image/png', new File('./web-app/images/confirma.png').readBytes()
//				attachBytes './web-app/images/dineroTaxi.png','image/png', new File('./web-app/images/dineroTaxi.png').readBytes()
//			}
			//emailService.send(command.email, conf.ui.register.emailFrom, "DINEROTAXI.COM CONFIRMA TU REGISTRACI��N",  body.toString())
			redirect(action: 'completeTaxi', controller:'index',params:[usr:user])
	}

	def verifyRegistration = {

		def conf = SpringSecurityUtils.securityConfig
		String defaultTargetUrl = conf.successHandler.defaultTargetUrl

		String token = params.t

		def registrationCode = token ? RegistrationCode.findByToken(token) : null
		if (!registrationCode) {
			flash.error = message(code: 'spring.security.ui.register.badCode')
			redirect(uri: defaultTargetUrl)
			return
		}

		def user
		RegistrationCode.withTransaction { status ->
			user = User.findByUsername(registrationCode.username)
			if (!user) {
				return
			}
			user.accountLocked = false
			user.enabled = true
			user.status=UStatus.DONE
			user.save(flush:true)
			registrationCode.delete()
		}

		if (!user) {
			flash.error = message(code: 'spring.security.ui.register.badCode')
			redirect(uri: defaultTargetUrl)
			return
		}

		springSecurityService.reauthenticate user.username

		flash.message = message(code: 'spring.security.ui.register.complete')
		redirect(uri: conf.ui.register.postRegisterUrl ?: defaultTargetUrl)
	}

	def forgotPassword = {

		if (!request.post) {
			// show the form
			return
		}

		String username = params.username
		if (!username) {
			flash.error = message(code: 'spring.security.ui.forgotPassword.username.missing')
			return
		}

		def user = User.findByUsername(username)
		if (!user) {
			flash.error = message(code: 'spring.security.ui.forgotPassword.user.notFound')
			return
		}

		def registrationCode = new RegistrationCode(username: user.username).save(flush:true)

		String url = generateLink('resetPassword', [t: registrationCode.token])
		def conf = SpringSecurityUtils.securityConfig
		def body =  g.render(template:"/emailconfirmation/confirmationPassword", model:[usr: user,url:url]).toString()

//		mailService.sendMail {
//			to user.email
//			from conf.ui.forgotPassword.emailFrom
//			subject conf.ui.forgotPassword.emailSubject
//			html body.toString()
//		}

		emailService.send(user.email, conf.ui.register.emailFrom, "Nueva contrase��a",  body.toString())
		redirect(controller:'index',action:'completeForgotPassword',params: [usr: user.email])
	}

	def resetPassword = { ResetPasswordCommand command ->

		String token = params.t

		def registrationCode = token ? RegistrationCode.findByToken(token) : null
		if (!registrationCode) {
			flash.error = message(code: 'spring.security.ui.resetPassword.badCode')
			redirect(uri: SpringSecurityUtils.securityConfig.successHandler.defaultTargetUrl)
			return
		}

		if (!request.post) {
			return [token: token, command: new ResetPasswordCommand()]
		}

		command.username = registrationCode.username

		if (command.hasErrors()) {
			flash.error = "No coinciden los password por favor ingreselos nuevamente"
			return [token: token, command: command]
		}

		String salt = saltSource instanceof NullSaltSource ? null : registrationCode.username
		RegistrationCode.withTransaction { status ->
			def user = User.findByUsername(registrationCode.username)
			user.password = command.password
			user.save(flush:true)
			registrationCode.delete()
		}

		springSecurityService.reauthenticate registrationCode.username

		flash.message = message(code: 'spring.security.ui.resetPassword.success')

		def conf = SpringSecurityUtils.securityConfig
		String postResetUrl = conf.ui.register.postResetUrl ?: conf.successHandler.defaultTargetUrl
		redirect(uri: postResetUrl)
	}

	protected String generateLink(String action, linkParams) {
		createLink(base: "$request.scheme://$request.serverName:$request.serverPort$request.contextPath",
				controller: 'register', action: action,
				params: linkParams)

	}

	protected String evaluate(s, binding) {
		new SimpleTemplateEngine().createTemplate(s).make(binding)
	}

	static final emailValidator = {  value, command ->


	}

	static final password2Validator = { value, command ->
		if  (! command.password.toString().equals( command.password2.toString() ) ) {
			return 'command.password2.error.mismatch'
		}
	}
	def validatePhone={
		String token = params.t
		def registrationCode = token ? RegistrationCode.findByToken(token) : null
		def user=null
		if(registrationCode){
			registrationCode.delete()
			user = User.findByUsername(registrationCode.username)
		}
		[user:user]
	}

	def savePhone={
		params.subject="TELEFONO REVALIDADO"
		params.comment="TELEFONO REVALIDADO"
		def contact = new Contact(params)
		if (!contact.save(flush: true)) {
			render(view: "validatePhone", model: [user: contact])
			flash.error="Debe completar todos los campos para enviar la consulta"
			return
		}
		def conf = SpringSecurityUtils.securityConfig
		String emailHml="${params as JSON}"
		emailService.send("rrhh@technorides.com",conf.ui.register.emailFrom, "CONSULTA WEB",emailHml)

		flash.message="Se ha enviado la consulta correctamente, en breves momentos se contactara una persona de <b>soporte al cliente</b>."
		redirect(action: "contactShow",controller:'index')
	}





}

class RegisterCommand {

	String firstName
	String lastName
	String phone
	String email
	Integer city

	String password
	String password2
	boolean agree
	boolean politics
	static constraints = {
		email blank: false,email: true, validator:  { value, command ->
				if (value) {
					if (RealUser.findByUsernameAndRtaxiIsNull(value)) {
						return 'registerCommand.username.unique'
					}
				}
			}

		firstName blank: false, minSize: 2, maxSize: 50
		lastName blank: false, minSize: 2, maxSize: 50
		phone blank: false, minSize: 5, maxSize: 20
		password blank: false, minSize: 4, maxSize: 64
		//, validator: RegisterController.passwordValidator
		password2 validator: RegisterController.password2Validator
	}
}
class RegistroCommand {

		String name
		Integer type
		Integer city
		String phone
		String email
		String password
		String password2
		boolean agree
		boolean politics
		static constraints = {
			email blank: false,email: true, validator: { value, command ->
				if (value) {
					if (RealUser.findByUsername(value)) {
						return 'registerCommand.username.unique'
					}
				}
			}
			name blank: false, minSize: 3, maxSize: 22
			phone blank: false, minSize: 5, maxSize: 10
			password blank: false, minSize: 4, maxSize: 64
			//, validator: RegisterController.passwordValidator
			password2 validator: RegisterController.password2Validator
		}
	}
class ResetPasswordCommand {
	String username
	String password
	String password2

	static constraints = {
		password blank: false, minSize: 5, maxSize: 64
		password2 validator: { val, obj -> val == obj.password }
	}
}
public class IntegrateRegistrationCommand {

		String firstName
		String lastName
		String phone
		String email
		String password
		String password2
		Integer city
		boolean agree
		boolean politics
		String placeinput1
		String departamento
		String piso
		String comentarios
		String placeinput2
		String term
		String list
		List values = []

		static constraints = {
			email blank: false,email: true
			firstName blank: false, minSize: 2, maxSize: 20
			placeinput1  blank: false, minSize: 3, maxSize: 99
			lastName blank: false, minSize: 2, maxSize: 20
			phone blank: false, minSize: 5, maxSize: 20
			password blank: false, minSize: 4, maxSize: 64
			//, validator: RegisterController.passwordValidator
			password2 validator: RegisterController.password2Validator
		}
	}
