import ar.com.goliath.*
import ar.com.goliath.api.*

import com.*
class BootStrap {
	def apiClientConnectionService
	def springSecurityService
	def geocoderService
	def userService
	def roleService
	def connectionService
	def lookupService
	def cloudFilesService
	def grailsApplication
	def eventLogService
	def pictureService
	def init = { servletContext ->
		//		String.metaClass.toHtml = {
		//			->
		//			delegate.encodeAsHTML().replace('\r\n', '<br/>')
		//		}
		//
		//		grailsApplication.domainClasses.each { domainClass ->
		//			// define addPicture() method for domain classes that implements Picturable
		//			if(Picturable.class.isAssignableFrom(domainClass.clazz)) {
		//				domainClass.clazz.metaClass {
		//					addPicture { poster, InputStream stream, String filename ->
		//						if(delegate.id == null) throw new PictureException("You must save the entity [${delegate}] before calling addPicture")
		//						return pictureService.addPicture(delegate, poster, stream, filename)
		//					}
		//
		//					addAvatar { poster, InputStream stream, String filename ->
		//						if(delegate.id == null) throw new PictureException("You must save the entity [${delegate}] before calling addAvatar")
		//						return pictureService.addAvatar(delegate, poster, stream, filename)
		//					}
		//
		//					getPictures = {
		//						->
		//						def instance = delegate
		//						if(instance.id != null) {
		//							PictureLink.withCriteria {
		//								projections { property "picture" }
		//								eq "pictureRef", instance.id
		//								eq 'type', GrailsNameUtils.getPropertyName(instance.class)
		//								cache true
		//							}
		//						} else {
		//							return Collections.EMPTY_LIST
		//						}
		//					}
		//
		//					getThumbnail { ImageSize size ->
		//						pictureService.getThumbnail(delegate, size)
		//					}
		//
		//					getTotalPictures = {
		//						->
		//						pictureService.getTotalPictures(delegate)
		//					}
		//
		//					removePicture { Picture pic ->
		//						cloudFilesService.deletePicture(pic)
		//						PictureLink.findAllByPicture(pic)*.delete()
		//						pic.delete(flush:true) // cascades deletes to links
		//					}
		//
		//					removePicture { Long id ->
		//						def pic = Picture.get(id)
		//						if(pic) removePicture(pic)
		//					}
		//				}
		//			}
		//
		//
		//
		//			// define addLookup() method for domain classes that implements Lookupable
		//			if(Lookupable.class.isAssignableFrom(domainClass.clazz)) {
		//				domainClass.clazz.metaClass {
		//					addLookupValue { String code, String realm ->
		//						if(delegate.id == null) throw new PictureException("You must save the entity [${delegate}] before calling addLookupValue")
		//						def link = null
		//						def lookup = Lookup.findByRealm(realm)
		//						def value = LookupValue.findByLookupAndCode(lookup, code)
		//						if (value) {
		//							link = new LookupLink(value: value, ref:delegate.id, type:GrailsNameUtils.getPropertyName(delegate.class)).save(flush:true)
		//						
		//						}
		//						else{
		//							
		//						}
		//						return link
		//					}
		//
		//					getLookupValues = { String realm ->
		//						def instance = delegate
		//						def lookupitem = Lookup.findByRealm(realm)
		//						if(instance.id != null) {
		//							LookupLink.withCriteria{
		//								projections {
		//									value {
		//										property "code"
		//										property "value"
		//									}
		//								}
		//								and {
		//									value { eq "lookup", lookupitem }
		//									eq "ref", instance.id
		//									eq "type", GrailsNameUtils.getPropertyName(instance.class)
		//								}
		//								cache true
		//							}
		//						} else {
		//							return Collections.EMPTY_LIST
		//						}
		//					}
		//
		//					deleteLookupValues = { String realm ->
		//						def instance = delegate
		//						def lookupitem = Lookup.findByRealm(realm)
		//						if(instance.id != null) {
		//							LookupLink.withCriteria{
		//								and {
		//									value { eq "lookup", lookupitem }
		//									eq "ref", instance.id
		//									eq "type", GrailsNameUtils.getPropertyName(instance.class)
		//								}
		//								cache true
		//							}*.delete()
		//						}
		//					}
		//				}
		//			}
		//		}
//		log.error "Connected to API: "
//		try{
//			apiClientConnectionService.init()
//		
//		}catch(Exception e){
//			log.error e.getMessage()
//			log.error "cant Connect to API: "
//			
//		}
		def userRole=Role.findByAuthority("ROLE_USER")?:new Role(authority:"ROLE_USER").save(flush:true)
		def companyRole=Role.findByAuthority("ROLE_COMPANY")?:new Role(authority:"ROLE_COMPANY").save(flush:true)
		def investorRole=Role.findByAuthority("ROLE_INVESTOR")?:new Role(authority:"ROLE_INVESTOR").save(flush:true)
		def companyAccountRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT")?:new Role(authority:"ROLE_COMPANY_ACCOUNT").save(flush:true)
		def companyAccountEmployeeRole=Role.findByAuthority("ROLE_COMPANY_ACCOUNT_EMPLOYEE")?:new Role(authority:"ROLE_COMPANY_ACCOUNT_EMPLOYEE").save(flush:true)
		
		def monitorRole=Role.findByAuthority("ROLE_MONITOR")?:new Role(authority:"ROLE_MONITOR").save(flush:true)
		
		
		def employrRole=Role.findByAuthority("ROLE_EMPLOY")?:new Role(authority:"ROLE_EMPLOY").save(flush:true)
		def taxiRole=Role.findByAuthority("ROLE_TAXI")?:new Role(authority:"ROLE_TAXI").save(flush:true)
		def taxiRol1e=Role.findByAuthority("ROLE_TAXI_OWNER")?:new Role(authority:"ROLE_TAXI_OWNER").save(flush:true)
		def adminRole=Role.findByAuthority("ROLE_ADMIN")?:new Role(authority:"ROLE_ADMIN").save(flush:true)
		def userRole1=Role.findByAuthority("ROLE_FACEBOOK")?:new Role(authority:"ROLE_FACEBOOK").save(flush:true)
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')?:new Role(authority:"ROLE_SUPERVISOR").save(flush:true)
		def operatorRole=Role.findByAuthority('ROLE_OPERATOR')?:new Role(authority:"ROLE_OPERATOR").save(flush:true)
		def telephonistRole=Role.findByAuthority('ROLE_TELEPHONIST')?:new Role(authority:"ROLE_TELEPHONIST").save(flush:true)
		def request7=Requestmap.findByUrl('/miPanelCompanyAccountEmployee/**')?: new Requestmap(url:'/miPanelCompanyAccountEmployee/**', configAttribute: 'ROLE_COMPANY_ACCOUNT_EMPLOYEE').save(flush:true)
		def request71=Requestmap.findByUrl('/homeCompanyAccountEmployee/**')?: new Requestmap(url:'/homeCompanyAccountEmployee/**', configAttribute: 'ROLE_COMPANY_ACCOUNT_EMPLOYEE').save(flush:true)
		def request72=Requestmap.findByUrl('/miPanelCompanyAccount/**')?: new Requestmap(url:'/miPanelCompanyAccount/**', configAttribute: 'ROLE_COMPANY_ACCOUNT').save(flush:true)
		def request73=Requestmap.findByUrl('/homeCompanyAccount/**')?: new Requestmap(url:'/homeCompanyAccount/**', configAttribute: 'ROLE_COMPANY_ACCOUNT').save(flush:true)
		
		
		//		def request1=Requestmap.findByUrl('/js/**')?:new Requestmap(url:'/js/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY').save(flush:true)
		//		def request3=Requestmap.findByUrl('/css/**')?:new Requestmap(url:'/css/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY').save(flush:true)
		//		def request4=Requestmap.findByUrl('/images/**')?:   new Requestmap(url:'/images/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY').save(flush:true)
		//		def request5=Requestmap.findByUrl('/login/**')?: new Requestmap(url:'/login/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY').save(flush:true)
		//		def request6=Requestmap.findByUrl('/logout/**')?: new Requestmap(url:'/logout/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY').save(flush:true)
		//		def request2=Requestmap.findByUrl('/*')?: new Requestmap(url:'/*', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY').save(flush:true)
		//		def request7=Requestmap.findByUrl('/profile/**')?: new Requestmap(url:'/profile/**', configAttribute: 'ROLE_USER').save(flush:true)
		//		def request8=Requestmap.findByUrl('/admin/**')?: new Requestmap(url:'/admin/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request9=Requestmap.findByUrl('/admin/user/**')?:new Requestmap(url:'/admin/user/**', configAttribute: 'ROLE_SUPERVISOR').save(flush:true)
		//		def request11=Requestmap.findByUrl('/home/**')?: new Requestmap(url:'/home/**', configAttribute: 'ROLE_USER').save(flush:true)
		//		def request12=Requestmap.findByUrl('/pedir/**')?: new Requestmap(url:'/pedir/**', configAttribute: 'ROLE_USER').save(flush:true)
		//		def request13=Requestmap.findByUrl('/favoritos/**')?: new Requestmap(url:'/favoritos/**', configAttribute: 'ROLE_USER').save(flush:true)
		//		def request132=Requestmap.findByUrl('/miPanel/**')?: new Requestmap(url:'/miPanel/**', configAttribute: 'ROLE_USER').save(flush:true)
		//		def request14=Requestmap.findByUrl('/user/**')?: new Requestmap(url:'/user/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request145=Requestmap.findByUrl('/role/**')?: new Requestmap(url:'/role/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request146=Requestmap.findByUrl('/requestmap/**')?: new Requestmap(url:'/requestmap/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request146ss=Requestmap.findByUrl('/tripPanelAdmin/**')?: new Requestmap(url:'/tripPanelAdmin/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request146s1ss=Requestmap.findByUrl('/homeAdmin/**')?: new Requestmap(url:'/homeAdmin/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request146s1s=Requestmap.findByUrl('/miPanelAdmin/**')?: new Requestmap(url:'/miPanelAdmin/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request146s12s=Requestmap.findByUrl('/supportAdmin/**')?: new Requestmap(url:'/supportAdmin/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def reques2t146s12s=Requestmap.findByUrl('/configurationApp/**')?: new Requestmap(url:'/configurationApp/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def reques2t146s1222s=Requestmap.findByUrl('/adminUser/**')?: new Requestmap(url:'/adminUser/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//
		//		def request147=Requestmap.findByUrl('/persistentLogin/**')?: new Requestmap(url:'/persistentLogin/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request148=Requestmap.findByUrl('/securityInfo/**')?: new Requestmap(url:'/securityInfo/**', configAttribute: 'ROLE_ADMIN').save(flush:true)
		//		def request1481=Requestmap.findByUrl('/homeCompany/**')?: new Requestmap(url:'/homeCompany/**', configAttribute: 'ROLE_COMPANY,ROLE_EMPLOY,ROLE_SUPERVISOR,ROLE_OPERATOR').save(flush:true)
		//		def request148122=Requestmap.findByUrl('/miPanelCompany/**')?: new Requestmap(url:'/miPanelCompany/**', configAttribute: 'ROLE_COMPANY,ROLE_EMPLOY,ROLE_SUPERVISOR,ROLE_OPERATOR').save(flush:true)
		//
		//		def request14812=Requestmap.findByUrl('/tripPanel/**')?: new Requestmap(url:'/tripPanel/**', configAttribute: 'ROLE_COMPANY,ROLE_EMPLOY,ROLE_SUPERVISOR').save(flush:true)
		//		def request148121=Requestmap.findByUrl('/employAdmin/**')?: new Requestmap(url:'/employAdmin/**', configAttribute: 'ROLE_COMPANY,ROLE_EMPLOY,ROLE_SUPERVISOR').save(flush:true)
		//
		//
		//		def request149=Requestmap.findByUrl('/miPanelTaxista/**')?: new Requestmap(url:'/miPanelTaxista/**', configAttribute: 'ROLE_TAXI').save(flush:true)
		//		def request150=Requestmap.findByUrl('/homeTaxista/**')?: new Requestmap(url:'/miPanelTaxista/**', configAttribute: 'ROLE_TAXI').save(flush:true)
		//		def request1322=Requestmap.findByUrl('/api/**')?: new Requestmap(url:'/api/**', configAttribute: 'ROLE_USER').save(flush:true)
		def ENV_NAME = "GRAILS_PROP"

		//		def confApp=ConfigurationApp.findByApp('DINEROTAXI')?:new ConfigurationApp(app:'DINEROTAXI', mailkey:'AKIAIMG666E3JLF5H2AA', mailSecret:'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',
		//				mailFrom:'rrhh@dinerotaxi.com'	, androidAccountType:'HOSTED_OR_GOOGLE'		, androidEmail:'rrhhh@dinerotaxi.com'		, androidPass:'2gB>=G22Ba'	, androidSource:'et-ap-1'
		//				, androidToken:'1'		, appleIp:'gateway.push.apple.com'		, applePort:2195
		//				, appleCertificatePath:System.getProperty(ENV_NAME)+'/apns.p12', applePassword:'2gB>=G22Ba',isEnabled:true).save(flush:true)
		//		def adminUser = User.findByUsername('admin@dinerotaxi.com') ?: new User(
		//				username: 'admin@dinerotaxi.com',email:'admin@dinerotaxi.com',firstName:'Matias',lastName:'Baglieri',
		//				password: 'Dtaxi$31s',
		//				enabled: true).save(failOnError: true)
		//		if (!adminUser.authorities.contains(adminRole)) {
		//			UserRole.create adminUser, adminRole
		//		}
		//
		//		def usuario = RealUser.findByUsername('user@dinerotaxi.com') ?: new RealUser(
		//						username: 'user@dinerotaxi.com',email:'user@dinerotaxi.com',firstName:'Matias',lastName:'Baglieri',phone:"1564640019" ,agree:true,politics:true,
		//						password: 'asdasd',status:UStatus.DONE,
		//						enabled: true).save(failOnError: true)
		//
		//		if (!usuario.authorities.contains(userRole)) {
		//			UserRole.create usuario, userRole
		//		}


		//		def empresaTaxi = Company.findByUsername('radio@dinerotaxi.com') ?: new Company(
		//				username: 'radio@dinerotaxi.com',email:'radio@dinerotaxi.com',phone:"1564640019" ,agree:true,politics:true,
		//				password: 'asdasd',status:UStatus.DONE,companyName:'DineroTaxi',cuit:"20-30978051-6",
		//				enabled: true).save(failOnError: true)
		//
		//
		//		if (!empresaTaxi.authorities.contains(companyRole)) {
		//			UserRole.create empresaTaxi, companyRole
		//		}
		//		def taxistaTaxi = EmployUser.findByUsername('taxista@dinerotaxi.com') ?: new EmployUser(
		//				username: 'taxista@dinerotaxi.com',email:'taxista@dinerotaxi.com',phone:"1564640019" ,agree:true,politics:true,
		//				password: 'asdasd',status:UStatus.DONE,lastName:"pedro",firstName:"taxi",typeEmploy:TypeEmployer.TAXISTA,
		//				enabled: true).save(failOnError: true)
		//
		def ve=Vehicle.findByPatente("------")?:new Vehicle(patente:"------",marca:"------",
		modelo:"------",active:true).save(flush:true)
		//		if (!taxistaTaxi.authorities.contains(taxiRole)) {
		//			if(ve){
		//				ve.addToTaxistas(taxistaTaxi)
		//			}
		//			UserRole.create taxistaTaxi, taxiRole
		//		}
		//		if (!taxistaTaxi.authorities.contains(taxiRole)) {
		//			UserRole.create taxistaTaxi, taxiRol1e
		//		}
		//
		//		def operadorDineroTaxi = EmployUser.findByUsername('operador@dinerotaxi.com') ?: new EmployUser(
		//				username: 'operador@dinerotaxi.com',email:'operador@dinerotaxi.com',phone:"1564640019" ,agree:true,politics:true,
		//				password: 'asdasd',status:UStatus.DONE,lastName:"pedro",firstName:"caputo",typeEmploy:TypeEmployer.OPERADOR,employee:empresaTaxi,
		//				enabled: true).save(failOnError: true)
		//
		//
		//
		//		if (!operadorDineroTaxi.authorities.contains(operatorRole)) {
		//			UserRole.create operadorDineroTaxi, operatorRole
		//		}
		//		if (!operadorDineroTaxi.authorities.contains(employrRole)) {
		//			UserRole.create operadorDineroTaxi, employrRole
		//		}
		//
		//
//		def empresaTaxi1 = Company.findByUsername('info@radiotaxiluz.com.ar') ?: new Company(
//				username: 'info@radiotaxiluz.com.ar',email:'info@radiotaxiluz.com.ar',phone:"4444-4444" ,agree:true,politics:true,
//				password: 'Luz1013',status:UStatus.DONE,companyName:'RadioTaxi Luz',cuit:"20-111111111-6",
//				enabled: true).save(failOnError: true)
//
//
//		if (!empresaTaxi1.authorities.contains(companyRole)) {
//			UserRole.create empresaTaxi1, companyRole
//		}
//
//		def operadorTuTaxi = EmployUser.findByUsername('operador@radiotaxiluz.com.ar') ?: new EmployUser(
//				username: 'operador@radiotaxiluz.com.ar',email:'operador@radiotaxiluz.com.ar',phone:"1564640019" ,agree:true,politics:true,
//				password: 'Luz1013',status:UStatus.DONE,lastName:"pedro",firstName:"caputo",typeEmploy:TypeEmployer.OPERADOR,employee:empresaTaxi1,
//				enabled: true).save(failOnError: true)
//
//
//
//		if (!operadorTuTaxi.authorities.contains(operatorRole)) {
//			UserRole.create operadorTuTaxi, operatorRole
//		}
//		if (!operadorTuTaxi.authorities.contains(employrRole)) {
//			UserRole.create operadorTuTaxi, employrRole
//		}
//
//		for(int i=1;i<1000;i++){
//			def genericTax = EmployUser.findByUsername(i+'@radiotaxiluz.com.ar') ?: new EmployUser(
//					username: i+'@radiotaxiluz.com.ar',email:i+'@radiotaxiluz.com.ar',phone:"----" ,agree:true,politics:true,
//					password: 'sssdasssd@!a',status:UStatus.DONE,lastName:"-----",firstName:"-----",typeEmploy:TypeEmployer.TAXISTA,employee:empresaTaxi1,
//					enabled: true).save(failOnError: true)
//
//
//			if (!genericTax.authorities.contains(taxiRole)) {
//				if(ve){
//					ve.addToTaxistas(genericTax)
//				}
//				UserRole.create genericTax, taxiRole
//			}
//			if (!genericTax.authorities.contains(taxiRole)) {
//				UserRole.create genericTax, taxiRol1e
//			}
//		}

		//		def empresaTaxi1 = Company.findByUsername('info@dinerotaxitest.com') ?: new Company(
		//				username: 'info@dinerotaxitest.com',email:'info@dinerotaxitest.com',phone:"4444-4444" ,agree:true,politics:true,isTestUser:true,
		//				password: 'dtaxi123A',status:UStatus.DONE,companyName:'DineroTaxi Test',cuit:"20-111111111-6",
		//				enabled: true).save(failOnError: true)
		//
		//
		//		if (!empresaTaxi1.authorities.contains(companyRole)) {
		//			UserRole.create empresaTaxi1, companyRole
		//		}
		//
		//		def operadorTuTaxi = EmployUser.findByUsername('operador@dinerotaxitest.com') ?: new EmployUser(
		//				username: 'operador@dinerotaxitest.com',email:'operador@dinerotaxitest.com',phone:"1564640019" ,agree:true,politics:true,isTestUser:true,
		//				password: 'asda12312sd',status:UStatus.DONE,lastName:"pedro",firstName:"caputo",typeEmploy:TypeEmployer.OPERADOR,employee:empresaTaxi1,
		//				enabled: true).save(failOnError: true)
		//
		//
		//
		//		if (!operadorTuTaxi.authorities.contains(operatorRole)) {
		//			UserRole.create operadorTuTaxi, operatorRole
		//		}
		//		if (!operadorTuTaxi.authorities.contains(employrRole)) {
		//			UserRole.create operadorTuTaxi, employrRole
		//		}
		//
		//		for(int i=1;i<1000;i++){
		//			def genericTax = EmployUser.findByUsername(i+'@dinerotaxitest.com') ?: new EmployUser(
		//					username: i+'@dinerotaxitest.com',email:i+'@dinerotaxitest.com',phone:"----" ,agree:true,politics:true,isTestUser:true,
		//					password: 'sssdasd@!a',status:UStatus.DONE,lastName:"-----",firstName:"-----",typeEmploy:TypeEmployer.TAXISTA,employee:empresaTaxi1,
		//					enabled: true).save(failOnError: true)
		//
		//
		//			if (!genericTax.authorities.contains(taxiRole)) {
		//				if(ve){
		//					ve.addToTaxistas(genericTax)
		//				}
		//				UserRole.create genericTax, taxiRole
		//			}
		//			if (!genericTax.authorities.contains(taxiRole)) {
		//				UserRole.create genericTax, taxiRol1e
		//			}
		//		}
		//		def empresaTaxi1 = Company.findByUsername('info@dinerotaxitest1.com') ?: new Company(
		//				username: 'info@dinerotaxitest1.com',email:'info@dinerotaxitest1.com',phone:"4444-4444" ,agree:true,politics:true,isTestUser:true,
		//				password: 'dtaxi123A',status:UStatus.DONE,companyName:'DineroTaxi1',cuit:"20-111111111-6",
		//				enabled: true).save(failOnError: true)
		//
		//
		//		if (!empresaTaxi1.authorities.contains(companyRole)) {
		//			UserRole.create empresaTaxi1, companyRole
		//		}
		//
		//		def operadorTuTaxi = EmployUser.findByUsername('operador@dinerotaxitest1.com') ?: new EmployUser(
		//				username: 'operador@dinerotaxitest1.com',email:'operador@dinerotaxitest1.com',phone:"1564640019" ,agree:true,politics:true,isTestUser:true,
		//				password: 'asda12312sd',status:UStatus.DONE,lastName:"pedro",firstName:"caputo",typeEmploy:TypeEmployer.OPERADOR,employee:empresaTaxi1,
		//				enabled: true).save(failOnError: true)
		//
		//
		//
		//		if (!operadorTuTaxi.authorities.contains(operatorRole)) {
		//			UserRole.create operadorTuTaxi, operatorRole
		//		}
		//		if (!operadorTuTaxi.authorities.contains(employrRole)) {
		//			UserRole.create operadorTuTaxi, employrRole
		//		}
		//
		//		for(int i=1;i<1000;i++){
		//			def genericTax = EmployUser.findByUsername(i+'@dinerotaxitest1.com') ?: new EmployUser(
		//					username: i+'@dinerotaxitest1.com',email:i+'@dinerotaxitest1.com',phone:"----" ,agree:true,politics:true,isTestUser:true,
		//					password: 'sssdasd@!a',status:UStatus.DONE,lastName:"-----",firstName:"-----",typeEmploy:TypeEmployer.TAXISTA,employee:empresaTaxi1,
		//					enabled: true).save(failOnError: true)
		//
		//
		//			if (!genericTax.authorities.contains(taxiRole)) {
		//				if(ve){
		//					ve.addToTaxistas(genericTax)
		//				}
		//				UserRole.create genericTax, taxiRole
		//			}
		//			if (!genericTax.authorities.contains(taxiRole)) {
		//				UserRole.create genericTax, taxiRol1e
		//			}
		//		}
		//		def empresaTaxi2 = Company.findByUsername('info@radiotaxibuenviaje.com.ar') ?: new Company(
		//				username: 'info@radiotaxibuenviaje.com.ar',email:'info@radiotaxibuenviaje.com.ar',phone:"4444-4444" ,agree:true,politics:true,
		//				password: 'BuenViaje22012',status:UStatus.DONE,companyName:'RadioTaxi BuenVIaje',cuit:"20-111111111-6",
		//				enabled: true).save(failOnError: true)
		//
		//
		//		if (!empresaTaxi2.authorities.contains(companyRole)) {
		//			UserRole.create empresaTaxi2, companyRole
		//		}
		//
		//		def operadorTuTaxi1 = EmployUser.findByUsername('operador@radiotaxibuenviaje.com.ar') ?: new EmployUser(
		//				username: 'operador@radiotaxibuenviaje.com.ar',email:'operador@radiotaxibuenviaje.com.ar',phone:"1564640019" ,agree:true,politics:true,
		//				password: 'asda1222312sd',status:UStatus.DONE,lastName:"pedro",firstName:"caputo",typeEmploy:TypeEmployer.OPERADOR,employee:empresaTaxi2,
		//				enabled: true).save(failOnError: true)
		//
		//
		//
		//		if (!operadorTuTaxi1.authorities.contains(operatorRole)) {
		//			UserRole.create operadorTuTaxi1, operatorRole
		//		}
		//		if (!operadorTuTaxi1.authorities.contains(employrRole)) {
		//			UserRole.create operadorTuTaxi1, employrRole
		//		}
		//
		//		for(int i=1;i<1210;i++){
		//			def genericTax1 = EmployUser.findByUsername(i+'@radiotaxibuenviaje.com.ar') ?: new EmployUser(
		//					username: i+'@radiotaxibuenviaje.com.ar',email:i+'@radiotaxibuenviaje.com.ar',phone:"----" ,agree:true,politics:true,
		//					password: 'sssdasasdd@!a',status:UStatus.DONE,lastName:"-----",firstName:"-----",typeEmploy:TypeEmployer.TAXISTA,employee:empresaTaxi2,
		//					enabled: true).save(failOnError: true)
		//
		//
		//			if (!genericTax1.authorities.contains(taxiRole)) {
		//				if(ve){
		//					ve.addToTaxistas(genericTax1)
		//				}
		//				UserRole.create genericTax1, taxiRole
		//			}
		//			if (!genericTax1.authorities.contains(taxiRole)) {
		//				UserRole.create genericTax1, taxiRol1e
		//			}
		//		}


		//		def testEmpresaTaxi2 = Company.findByUsername('info@radiotest.com.ar') ?: new Company(
		//				username: 'info@radiotest.com.ar',email:'info@radiotest.com.ar',phone:"4444-4444" ,agree:true,politics:true,
		//				password: 'testradio123',status:UStatus.DONE,companyName:'RadioTaxi Test',cuit:"20-111111111-6",
		//				enabled: true).save(failOnError: true)
		//
		//
		//		if (!testEmpresaTaxi2.authorities.contains(companyRole)) {
		//			UserRole.create testEmpresaTaxi2, companyRole
		//		}
		//
		//		def testOperadorTuTaxi1 = EmployUser.findByUsername('operador@radiotest.com.ar') ?: new EmployUser(
		//				username: 'operador@radiotest.com.ar',email:'operador@radiotest.com.ar',phone:"1564640019" ,agree:true,politics:true,
		//				password: 'asda1222312sd',status:UStatus.DONE,lastName:"pedro",firstName:"caputo",typeEmploy:TypeEmployer.OPERADOR,employee:testEmpresaTaxi2,
		//				enabled: true).save(failOnError: true)
		//
		//
		//
		//		if (!operadorTuTaxi1.authorities.contains(operatorRole)) {
		//			UserRole.create testOperadorTuTaxi1, operatorRole
		//		}
		//		if (!operadorTuTaxi1.authorities.contains(employrRole)) {
		//			UserRole.create testOperadorTuTaxi1, employrRole
		//		}
		//
		//		for(int i=1;i<50;i++){
		//			def genericTestTax1 = EmployUser.findByUsername(i+'@radiotest.com.ar') ?: new EmployUser(
		//					username: i+'@radiotest.com.ar',email:i+'@radiotest.com.ar',phone:"----" ,agree:true,politics:true,
		//					password: 'sssdasasdd@!a',status:UStatus.DONE,lastName:"-----",firstName:"-----",typeEmploy:TypeEmployer.TAXISTA,employee:testEmpresaTaxi2,
		//					enabled: true).save(failOnError: true)
		//
		//
		//			if (!genericTestTax1.authorities.contains(taxiRole)) {
		//				if(ve){
		//					ve.addToTaxistas(genericTestTax1)
		//				}
		//				UserRole.create genericTestTax1, taxiRole
		//			}
		//			if (!genericTestTax1.authorities.contains(taxiRole)) {
		//				UserRole.create genericTestTax1, taxiRol1e
		//			}
		//		}











		//urlmaping userlogued
		def request1323=Requestmap.findByUrl('/pedir_taxi')?: new Requestmap(url:'/pedir_taxi', configAttribute: 'ROLE_USER').save(flush:true)
		def request99=Requestmap.findByUrl('/mi_cuenta')?: new Requestmap(url:'/mi_cuenta', configAttribute: 'ROLE_USER').save(flush:true)
		def request98=Requestmap.findByUrl('/mis_favoritos')?: new Requestmap(url:'/mis_favoritos', configAttribute: 'ROLE_USER').save(flush:true)
		def request97=Requestmap.findByUrl('/mis_viajes_programados')?: new Requestmap(url:'/mis_viajes_programados', configAttribute: 'ROLE_USER').save(flush:true)
		def request96=Requestmap.findByUrl('/mis_datos_personales')?: new Requestmap(url:'/mis_datos_personales', configAttribute: 'ROLE_USER').save(flush:true)
		
		
		
		
		def request961=Requestmap.findByUrl('/console')?: new Requestmap(url:'/console', configAttribute: 'ROLE_ADMIN').save(flush:true)
		def request962=Requestmap.findByUrl('/role')?: new Requestmap(url:'/role', configAttribute: 'ROLE_ADMIN').save(flush:true)
		def request963=Requestmap.findByUrl('/requestmap')?: new Requestmap(url:'/requestmap', configAttribute: 'ROLE_ADMIN').save(flush:true)
		def request964=Requestmap.findByUrl('/user')?: new Requestmap(url:'/user', configAttribute: 'ROLE_ADMIN').save(flush:true)
		def request965=Requestmap.findByUrl('/persistentLogin')?: new Requestmap(url:'/persistentLogin', configAttribute: 'ROLE_ADMIN').save(flush:true)
		def request966=Requestmap.findByUrl('/registrationCode')?: new Requestmap(url:'/registrationCode', configAttribute: 'ROLE_ADMIN').save(flush:true)
		def request967=Requestmap.findByUrl('/securityinfo')?: new Requestmap(url:'/securityinfo', configAttribute: 'ROLE_ADMIN').save(flush:true)
		



		//fin url userlogued





		//basicData()
		def enabledCities = EnabledCities.findByName('CAPITALFEDERAL')?:new EnabledCities(
				name:'CAPITALFEDERAL',
				country:'Argentina',
				admin1Code:'Ciudad Aut��noma de Buenos Aires',
				locality:'Buenos Aires',
				countryCode:'AR',
				northEastLatBound:-34.5627767697085,
				northEastLngBound:-58.4751826697085,
				southWestLatBound:-34.5654747302915,
				southWestLngBound:-58.4772444802915,enabled:true
				).save(flush:true)
		def enabledCities1 = EnabledCities.findByName('CAPITALFEDERALEN')?:new EnabledCities(
				name:'CAPITALFEDERALEN',
				country:'Argentina',
				admin1Code:'Autonomous City of Buenos Aires',
				locality:'Buenos Aires',
				countryCode:'AR',
				northEastLatBound:-34.5627767697085,
				northEastLngBound:-58.4751826697085,
				southWestLatBound:-34.5654747302915,
				southWestLngBound:-58.4772444802915,enabled:true
				).save(flush:true)
//		def useeers=User.findAllByCityIsNull()
//		useeers.each {
//			it.city=enabledCities
//			it.lang='es'
//			it.save(flush:true)
//		}
		

	}
	def destroy = {
	}
	void basicData() {

		lookupService.createLookupType('property.type')
		lookupService.createLookupValue('property.type',0,'Hotel')
		lookupService.createLookupValue('property.type',1,'Bed and breakfast')
		lookupService.createLookupValue('property.type',2,'Cabin')
		lookupService.createLookupValue('property.type',3,'Ranch/Estancia')
		lookupService.createLookupValue('property.type',4,'Hostel')
		lookupService.createLookupValue('property.type',5,'Villa')
		lookupService.createLookupValue('property.type',6,'Serviced apartment')
		lookupService.createLookupValue('property.type',7,'Castle')
		lookupService.createLookupValue('property.type',8,'Boat')

		lookupService.createLookupType('money.currency')
		lookupService.createLookupValue('money.currency',0,'EUR')
		lookupService.createLookupValue('money.currency',1,'USD')
		lookupService.createLookupValue('money.currency',2,'GBP')

		lookupService.createLookupType('company.type')
		lookupService.createLookupValue('company.type', 0, 'Agent')

		lookupService.createLookupType('company.speciality')
		lookupService.createLookupValue('company.speciality',0,'TAXI')

		lookupService.createLookupType('user.language')
		lookupService.createLookupValue('user.language',0,'Abkhazian')
		lookupService.createLookupValue('user.language',1,'Avestan')
		lookupService.createLookupValue('user.language',2,'Afrikaans')
		lookupService.createLookupValue('user.language',3,'Akan')
		lookupService.createLookupValue('user.language',4,'Amharic')
		lookupService.createLookupValue('user.language',5,'Aragonese')
		lookupService.createLookupValue('user.language',6,'Arabic')
		lookupService.createLookupValue('user.language',7,'Assamese')
		lookupService.createLookupValue('user.language',8,'Avaric')
		lookupService.createLookupValue('user.language',9,'Aymara')
		lookupService.createLookupValue('user.language',10,'Azerbaijani')
		lookupService.createLookupValue('user.language',11,'Bashkir')
		lookupService.createLookupValue('user.language',12,'Belarusian')
		lookupService.createLookupValue('user.language',13,'Bulgarian')
		lookupService.createLookupValue('user.language',14,'Bihari languages')
		lookupService.createLookupValue('user.language',15,'Bislama')
		lookupService.createLookupValue('user.language',16,'Bambara')
		lookupService.createLookupValue('user.language',17,'Bengali')
		lookupService.createLookupValue('user.language',18,'Tibetan')
		lookupService.createLookupValue('user.language',19,'Breton')
		lookupService.createLookupValue('user.language',20,'Bosnian')
		lookupService.createLookupValue('user.language',21,'Catalan')
		lookupService.createLookupValue('user.language',22,'Chechen')
		lookupService.createLookupValue('user.language',23,'Chamorro')
		lookupService.createLookupValue('user.language',24,'Corsican')
		lookupService.createLookupValue('user.language',25,'Cree')
		lookupService.createLookupValue('user.language',26,'Czech')
		lookupService.createLookupValue('user.language',27,'Church Slavic')
		lookupService.createLookupValue('user.language',28,'Chuvash')
		lookupService.createLookupValue('user.language',29,'Welsh')
		lookupService.createLookupValue('user.language',30,'Danish')
		lookupService.createLookupValue('user.language',31,'German')
		lookupService.createLookupValue('user.language',32,'Dhivehi')
		lookupService.createLookupValue('user.language',33,'Dzongkha')
		lookupService.createLookupValue('user.language',34,'Ewe')
		lookupService.createLookupValue('user.language',35,'Modern Greek (1453-)')
		lookupService.createLookupValue('user.language',36,'English')
		lookupService.createLookupValue('user.language',37,'Esperanto')
		lookupService.createLookupValue('user.language',38,'Spanish')
		lookupService.createLookupValue('user.language',39,'Estonian')
		lookupService.createLookupValue('user.language',40,'Basque')
		lookupService.createLookupValue('user.language',41,'Persian')
		lookupService.createLookupValue('user.language',42,'Fulah')
		lookupService.createLookupValue('user.language',43,'Finnish')
		lookupService.createLookupValue('user.language',44,'Fijian')
		lookupService.createLookupValue('user.language',45,'Faroese')
		lookupService.createLookupValue('user.language',46,'French')
		lookupService.createLookupValue('user.language',47,'Western Frisian')
		lookupService.createLookupValue('user.language',48,'Irish')
		lookupService.createLookupValue('user.language',49,'Scottish Gaelic')
		lookupService.createLookupValue('user.language',50,'Galician')
		lookupService.createLookupValue('user.language',51,'Guarani')
		lookupService.createLookupValue('user.language',52,'Gujarati')
		lookupService.createLookupValue('user.language',53,'Manx')
		lookupService.createLookupValue('user.language',54,'Hausa')
		lookupService.createLookupValue('user.language',55,'Hebrew')
		lookupService.createLookupValue('user.language',56,'Hindi')
		lookupService.createLookupValue('user.language',57,'Hiri Motu')
		lookupService.createLookupValue('user.language',58,'Croatian')
		lookupService.createLookupValue('user.language',59,'Haitian')
		lookupService.createLookupValue('user.language',60,'Hungarian')
		lookupService.createLookupValue('user.language',61,'Armenian')
		lookupService.createLookupValue('user.language',62,'Herero')
		lookupService.createLookupValue('user.language',63,'Interlingua (International Auxiliary Language Association)')
		lookupService.createLookupValue('user.language',64,'Indonesian')
		lookupService.createLookupValue('user.language',65,'Interlingue')
		lookupService.createLookupValue('user.language',66,'Igbo')
		lookupService.createLookupValue('user.language',67,'Sichuan Yi')
		lookupService.createLookupValue('user.language',68,'Inupiaq')
		lookupService.createLookupValue('user.language',69,'Ido')
		lookupService.createLookupValue('user.language',70,'Icelandic')
		lookupService.createLookupValue('user.language',71,'Italian')
		lookupService.createLookupValue('user.language',72,'Inuktitut')
	}
}
