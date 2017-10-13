package com.api.technorides

import grails.converters.JSON

import java.text.DateFormat

import uk.co.desirableobjects.sendgrid.SendGridEmail
import uk.co.desirableobjects.sendgrid.SendGridEmailBuilder
import ar.com.favorites.TemporalFavorites
import ar.com.goliath.Company
import ar.com.goliath.EmailBuilder
import ar.com.goliath.EmployUser
import ar.com.goliath.MailQueue
import ar.com.goliath.TechnoRidesMailQueue
import ar.com.goliath.User
import ar.com.goliath.Vehicle
import ar.com.goliath.corporate.Corporate
import ar.com.goliath.corporate.CostCenter
import ar.com.operation.DelayOperation
import ar.com.operation.Operation
import ar.com.operation.OperationCharges
import ar.com.operation.Options
import ar.com.operation.TYPE_CHARGE
import ar.com.operation.CreditCardInformation

class TechnoRidesEmailService {
	def sendGridService
	def utilsApiService
	boolean onMessage( operation,name) {
		//Thread.currentThread().sleep(0.1*1000)
		//def mail = MailQueue.get(msg.id)
		def emailBuilder= EmailBuilder.findByNameAndUserAndLang(name,operation?.user?.rtaxi,operation?.company?.lang?:'es')
		if(!emailBuilder?.name){
			emailBuilder= EmailBuilder.findByNameAndLang(name,operation?.company?.lang?:'es')
		}
		if(!emailBuilder?.name){
			emailBuilder= EmailBuilder.findByName(name)
		}
		if(!emailBuilder?.name){
			return false;
		}

		def mail = new TechnoRidesMailQueue(to:operation?.user, from:operation?.user?.rtaxi, emailBuilder:emailBuilder )
		return mail.save(flush:true);
	}
	def sendMail(operation){
		sendGridService.sendMail {
			from operation?.user?.rtaxi?.email
			to operation?.user?.email
			subject operation?.user?.rtaxi?.companyName+' Gracias por usar nuestro nuevo servicio'
			body 'Este es el nuevo servicio que ofrecemos para nuestros clientes'
		}
	}
	def sendReport(rtaxi,args,report){
		def email_p = rtaxi.mailContacto?:'support@technorides.com'
		print args?.email
		if(args?.email){
			email_p=args.email
		}
		print email_p
		SendGridEmail email = new SendGridEmailBuilder()
				.from("report@technorides.com")
				.to(email_p)
				.subject("Report").withText("Report Attached").addAttachment(report).build()
		sendGridService.send(email)
	}
	def sendInternalReport(report){
		SendGridEmail email = new SendGridEmailBuilder()
				.from("report@technorides.com")
				.to("support@technorides.com")
				.subject("Report").withText("Report Attached").addAttachment(report).build()
		sendGridService.send(email)
	}
	public boolean buildEmailForgotPassword( Long  userId,Long  rtaxiId,String password){
		def user=User.get(userId)
		def rtaxi=Company.get(rtaxiId)
		def bodyName='email.forgot.password'
		def emailHtml=EmailBuilder.findByNameAndUserAndIsEnabled(bodyName,rtaxi,true)
		boolean isCompletedByRTaxi=true
		if(!emailHtml?.name){
			isCompletedByRTaxi=false
			emailHtml=EmailBuilder.findByNameAndLangAndIsEnabled(bodyName,rtaxi?.lang?:'es',true)
		}
		if(!emailHtml?.name){
			log.error "Cant Send Mail we dont find HTML"
			return false;
		}
		def mailQueue=new TechnoRidesMailQueue(from:rtaxi,to:user,emailBuilder:emailHtml)

		def newBody=emailHtml.body
		def newSubject=emailHtml.subject
		newBody=newBody.replaceAll("#PASSWORD#",password)
		if(!isCompletedByRTaxi){
			newSubject=newSubject.replaceAll("#COMPANYNAME#", rtaxi.companyName)

			newBody=newBody.replaceAll("#FIRSTNAME#",user?.firstName)

			newBody=newBody.replaceAll("#COMPANYNAME#", rtaxi?.companyName)
			DateFormat df =  DateFormat.getDateInstance();
			DateFormat df4 = DateFormat.getDateInstance(DateFormat.FULL);
			newBody=newBody.replaceAll("#EMAIL#", rtaxi?.email)
			newBody=newBody.replaceAll("#USEREMAIL#",  user?.email)

			newBody=newBody.replaceAll("#ANDROID#", rtaxi?.wlconfig?.androidUrl)
			newBody=newBody.replaceAll("#IOS#", rtaxi?.wlconfig?.iosUrl)
		}
		mailQueue.body=newBody
		mailQueue.subject=newSubject
		mailQueue.from=rtaxi
		mailQueue.to=user
		return mailQueue.save()
	}
	def getEmailBuilder( params,rtaxi) {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def customers = EmailBuilder.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('user', rtaxi)
			if(params.searchOper.equals("eq") ){
				if(  params.searchField.equals("name") && !params.searchString.isEmpty()){
					ilike("name", params.searchString+"%")
				}
				if(  params.searchField.equals("subject") && !params.searchString.isEmpty()){
					ilike("subject", params.searchString+"%")
				}
			}
			eq('isEnabled',true)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [
					it.name,
					it.subject,
					'',
					it.isEnabled
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	//sendEmail(rtaxi.companyName,rtaxi.email,operation?.user?.firstName,operation?.user?.email,newSubject,newBody)
	void sendEmail(fromName,fromN,toName,toN,subjectN,bodyN){
		SendGridEmail email = new SendGridEmailBuilder()
				.from(fromName,fromN)
				.to(toName,toN)
				.subject(subjectN).withHtml(bodyN).build()
		sendGridService.send(email)
	}

	//sendEmail(rtaxi.companyName,rtaxi.email,operation?.user?.firstName,operation?.user?.email,newSubject,newBody)
	void sendEmail(to,body){
		SendGridEmail email = new SendGridEmailBuilder()
				.from("rrhh@technorides.com")
				.to(to)
				.subject("test").withHtml(body).build()
		sendGridService.send(email)
	}
	//sendEmail(rtaxi.companyName,rtaxi.email,operation?.user?.firstName,operation?.user?.email,newSubject,newBody)
	void sendEmail(from,to,subject,body){
		SendGridEmail email = new SendGridEmailBuilder()
				.from(from)
				.to(to)
				.subject(subject).withHtml(body).build()
		sendGridService.send(email)
	}

	public boolean buildBug( String message,String subject){

		def mailQueue=new MailQueue(from:"no-replay@technorides.com",to:"support@technorides.com")
		mailQueue.body=message
		mailQueue.subject=subject
		return mailQueue.save()
	}

	public boolean buildEmailCreateUser( Long  userId,Long  rtaxiId, String url){
		def user=User.get(userId)
		def rtaxi=recoverCompany(rtaxiId)

		Date d = new Date()
		def bodyName='email.create.new.user'

		def map = [
			"#DATE#":utilsApiService.generateFormatedAddressToClient(d,rtaxi),
			"#URL#": url,
			"#USEREMAIL#":  user?.email,
			"#USERNAME#":user?.firstName,
		]
		map.putAll(templateFooter(rtaxi))
		return buildMail(bodyName, rtaxi, user, map)
	}
	public boolean buildEmailCreateTripWithPhone( Long  opId,Long  rtaxiId, Boolean newUser){
		def operation=recoverOperation(opId)
		def rtaxi=recoverCompany(rtaxiId)

		def bodyName=newUser?'email.create.phone.new.user':'email.create.new.user'

		def map = templateOperation(operation)
		return buildMail(bodyName, rtaxi, operation?.user, map)
	}
	public boolean buildDelayEmailCreateTripWithPhone( Long  opId,Long  rtaxiId, Boolean newUser){
		def operation=recoverOperation(opId)
		def rtaxi=recoverCompany(rtaxiId)

		def bodyName=newUser?'email.create.delay.phone.new.user':'email.create.delay.phone'
		def map = templateOperation(operation)
		return buildMail(bodyName, rtaxi, operation?.user, map)
	}
	// new emails-----
	public boolean emailOperationGeneric( Long  opId, String bodyName){
		def operation=recoverOperation(opId)
		def rtaxi=recoverCompany(operation.company.id)

		def map = templateOperation(operation)
		return buildMail(bodyName, rtaxi, operation?.user, map)
	}

	public boolean emailSuccessPayment(Long opId, Long ccId, String orderId, String bodyName){
		def CARDS_TYPE = ['americanexpress','carnet','dinersclub','mastercard','visa']

    def operation=recoverOperation(opId)
		def card = recoverCCInformation(ccId)
		def rtaxi = recoverCompany(operation.company.id)
    //Defaul card image if this doesn`t exist in the collection
		def cardType = CARDS_TYPE.contains(card.cardType.toLowerCase()) ? card.cardType.toLowerCase() : 'default'

		def map = [
		  "#NAME#": operation.user.firstName + " " + operation.user.lastName,
		  "#TRANSACTION_DATE#": operation.createdDate.format('EEEE dd, MMMM'),
			"#TRIP_DATE#": operation.createdDate.format("dd 'de' MMMM 'de' YYYY, hh:mm a"),
			"#OPERATION_ID#": operation.id,
			"#AMOUNT#": operation.amount,
			"#CARD_NUMBER#": card.cardNumber,
			"#ORDER_ID#": orderId,
			"#CARD_PROVIDER#": cardType
		]

		return buildMail(bodyName, rtaxi, operation.user, map)
	}

	public Map templateOperation(Operation operation){
		def tripTime = operation?.lastModifiedDate- operation?.createdDate
		def map =  [
			"#DATE_ORDER#":utilsApiService.generateFormatedAddressToClient(operation?.createdDate,operation.company),
			"#DATE_FINISH#":utilsApiService.generateFormatedAddressToClient(operation?.lastModifiedDate,operation.company),
			"#DEVICE#":operation?.dev.toString()?:"WEB",
			"#TRIPTIME#":tripTime?:"00:10",
			"#TOTAL#":operation?.amount?:"0",
			"#CREDITCARD#":operation?.paymentReference?:"0",
			"#OPERATIONSTARS#":operation?.stars?:"",
			"#APROXCOST#":""

			]
		map.putAll(templatePlaceFrom(operation?.favorites))
		map.putAll(templateUser(operation?.user))
		map.putAll(templateCompany(operation?.company))
		map.putAll(templateOptions(operation?.options))
		map.putAll(templateFareCalculator(operation))
		if(operation?.taxista){
			map.putAll(templateDriver(operation?.taxista))
			map.putAll(templateCarByDriver(operation?.taxista))

		}
		if(operation?.favorites?.placeTo?.street)
			map.putAll(templatePlaceTo(operation?.favorites))
		if(operation?.costCenter)
			map.putAll(templateCostCenter(operation?.costCenter))
		if(operation?.corporate)
			map.putAll(templateCorporate(operation?.corporate))
		return map
	}
	public Map templateDelayOperation(DelayOperation operation){
		def tripTime = operation?.lastModifiedDate- operation?.createdDate
		def map =  [
			"#DATE_ORDER#":utilsApiService.generateFormatedAddressToClient(operation?.createdDate,operation.company),
			"#DATE_FINISH#":utilsApiService.generateFormatedAddressToClient(operation?.lastModifiedDate,operation.company),
			"#SCHEDULED_DATE#":utilsApiService.generateFormatedAddressToClient(operation?.executionTime,operation.company),
			"#DEVICE#":operation?.dev.toString()?:"WEB",
			"#TRIPTIME#":tripTime?:"00:10",
			"#TOTAL#":operation?.amount?:"0",
			"#CREDITCARD#":operation?.paymentReference?:"0",
			"#APROXCOST#":""

			]
		map.putAll(templatePlaceFrom(operation?.favorites))
		map.putAll(templateUser(operation?.user))
		map.putAll(templateCompany(operation?.company))
		map.putAll(templateOptions(operation?.options))
		map.putAll(templateFareCalculator(operation))
		if(operation?.taxista){
			map.putAll(templateDriver(operation?.taxista))
			map.putAll(templateCarByDriver(operation?.taxista))

		}
		if(operation?.favorites?.placeTo?.street)
			map.putAll(templatePlaceTo(operation?.favorites))
		if(operation?.costCenter)
			map.putAll(templateCostCenter(operation?.costCenter))
		if(operation?.corporate)
			map.putAll(templateCorporate(operation?.corporate))
		return map
	}
	public Map templateFareCalculator(Operation operation){
		def time         = 0
		def distance     = 0
		def initialCost  = 0
		def waitingTime  = 0
		def subTotal     = 0
		def fees         = []

		def charges = OperationCharges.findAllByOperation(operation)
		for(charge in charges){
			subTotal +=charge.charge
			if(charge.type_charge == TYPE_CHARGE.TIME){
				time +=charge.charge
			}else if(charge.type_charge == TYPE_CHARGE.DISTANCE){
				distance +=charge.charge

			}else if(charge.type_charge == TYPE_CHARGE.WAIT){
				waitingTime +=charge.charge

			}else if(charge.type_charge == TYPE_CHARGE.INITIAL_COST){
				initialCost +=charge.charge

			}else if(charge.type_charge == TYPE_CHARGE.ADDITIONAL){
				fees.push "${charge.name}:${charge.charge}"

			}
		}

		return [
			"#TIME_PRICE#":time?:"",
			"#DISTANCE_PRICE#":distance?:"",
			"#WAITING_TIME_PRICE#":waitingTime?:"",
			"##BASEFARE##":initialCost?:"",
			"#SUBTOTAL#":subTotal?:"",
			"#FEES#":fees.join(" ")?:"",
			]


	}
	public Map templateFooter(Company rtaxi){
		return [
			"#PASSWORD#": rtaxi?.wlconfig?.app?:'YOURCOMPANY' +"2014",
			"#EMAIL#": rtaxi?.email?:"",
			"#APP#": rtaxi?.wlconfig?.app?:'YOURCOMPANY',
			"#COMPANYNAME#": rtaxi.companyName?:"",
			"#COMPANYEMAIL#": rtaxi.mailContacto?:"",
			"#ANDROID#": rtaxi?.wlconfig?.androidUrl?:"",
			"#IOS#": rtaxi?.wlconfig?.iosUrl?:"",
			"#BOOKINGWEBURL#": rtaxi?.wlconfig?.pageCompanyWeb?:'',
			"#COMPANYLOGO#": rtaxi?.wlconfig?.pageCompanyLogo?:'',
			"#PHONENUMBER#": rtaxi?.phone?:""
			]
	}
	public Map templateCorporate(Corporate corporate){

		return [
  			"#CORPORATENAME#":corporate?.name?:"",
  			"#DISCOUNT#":corporate?.discount?:"",
  			"#CORPORATEPHONE#":corporate?.phone?:"",
  			"#CORPORATELEGALADDRESS#":corporate?.legalAddress?:"",
  			"#CORPORATECUIT#":corporate?.cuit?:"",
			"#CORPORATEIMG#":""
			]
	}
	public Map templateCostCenter(CostCenter costcenter){

		return [
			"#COSTCENTER#":costcenter?.name?:"",
			"#COSTCENTERPHONE#":costcenter?.phone?:"",
			"#COSTCENTERLEGALADDRESS#":costcenter?.legalAddress?:""
			]
	}
	public Map templateOptions(Options options){

		return [
			"#OPTIONMESSAGING#":options.messaging,
			"#OPTIONPET#":options.pet,
			"#OPTIONAIR#":options.airConditioning,
			"#OPTIONSMOKER#":options.smoker,
			"#OPTIONSPECIALASSISTANT#":options.specialAssistant,
			"#OPTIONLUGGAGE#":options.luggage,
			"#OPTIONAIRPORT#":options.airport,
			"#OPTIONVIP#":options.vip,
			"#OPTIONINVOICE#":options.invoice,
			]
	}
	public Map templatePlaceFrom(TemporalFavorites favorites){
		return [
			"#PLACEFROMLAT#": String.valueOf(favorites?.placeFrom?.lat)?:"",
			"#PLACEFROMLNG#": String.valueOf(favorites?.placeFrom?.lng)?:"",
			"#PLACEFROM#":favorites?.placeFrom?.street+' '+favorites?.placeFrom?.streetNumber,
			]
	}
	public Map templatePlaceTo(TemporalFavorites favorites){
		return [
			"#PLACETOLAT#": String.valueOf(favorites?.placeTo?.lat)?:"",
			"#PLACETOLNG#": String.valueOf(favorites?.placeTo?.lng)?:"",
			"##PLACETO##":favorites?.placeTo?.street+' '+favorites?.placeTo?.streetNumber,
			]
	}
	public Map templateDriver(EmployUser user){
		return [
			"#DRIVERNAME#": user.firstName?:"",
			"#DRIVER_USERNAME#": user.lastName?:"",
			"#DRIVERPHONE#": user.phone?:"",
			"#DRIVEREMAIL#": user.email?:"",
			"#DRIVERIMG#": "https://dinerotaxi.com/taxiApi/displayDriverLogoByEmail?email=${user.email}",
			]
	}
	public Map templateCarByDriver(User driver){
		def vehicle = Vehicle.findByTaxistas(driver)
		return [
			"#CARPICTURE#": "",
			"#CARMODEL#": vehicle.modelo?:"",
			"#PLATE#": vehicle.patente?:""
			]
	}
	public Map templateUser(User user){
		return [
			"#NAME#": user.firstName?:"",
			"#USERLASTNAME#": user.lastName?:"",
			"#USERPHONE#": user.phone?:"",
			"#USEREMAIL#": user.email?:"",
			"#USERNAME_CHARGED#":user.firstName?:""
			]
	}
	public Map templateCompany(Company rtaxi){
		return [
			"#DEFAULTPASSWORD#": rtaxi?.wlconfig?.app?:'YOURCOMPANY' +"2014",
			"#COMPANYEMAIL#": rtaxi?.email?:"",
			"#COMPANYAPP#": rtaxi?.wlconfig?.app?:'YOURCOMPANY',
			"#COMPANYNAME#": rtaxi.companyName?:"",
			"#COMPANYPHONE#": rtaxi?.phone?:"",
			"#ANDROID#": rtaxi?.wlconfig?.androidUrl?:"",
			"#IOS#": rtaxi?.wlconfig?.iosUrl?:"",
			"#BOOKINGWEBURL#": rtaxi?.wlconfig?.pageCompanyWeb?:'',
			"#COMPANYLOGO#": rtaxi?.wlconfig?.pageCompanyLogo?:''
			]
	}
	public buildMail(String bodyName,Company rtaxi,User emailTo,Map map){
		def emailHtml=EmailBuilder.findByNameAndUserAndIsEnabled(bodyName,rtaxi,true)

		boolean isCompletedByRTaxi=true
		if(!emailHtml?.name){
			isCompletedByRTaxi=false
			emailHtml=EmailBuilder.findByNameAndLangAndIsEnabled(bodyName,rtaxi?.lang?:'es',true)
		}
		if(!emailHtml?.name){
			log.error "Cant Send Mail we dont find HTML"
			return false;
		}

		def newBody=emailHtml.body
		def newSubject=emailHtml.subject
		if(!isCompletedByRTaxi){
			newSubject = dictToReplace(newSubject, map)
			newBody    = dictToReplace(newBody, map)
		}
		def mailQueue=new TechnoRidesMailQueue(from:rtaxi,to:emailTo,emailBuilder:emailHtml)

		mailQueue.body=newBody
		mailQueue.subject=newSubject
		mailQueue.from=rtaxi
		mailQueue.to=emailTo
		if(!mailQueue.save()){
			mailQueue.errors.each{
				print it
			}
		}
	}

	private String dictToReplace(String html, Map dict){
		for ( e in dict ) {
			html = html.replaceAll(String.valueOf(e.key), String.valueOf(e.value))
		}
		return html
	}

	private Operation recoverOperation( Long  opId){
		return Operation.get(opId)
	}

	private Company recoverCompany(Long rtaxiId){
		return Company.get(rtaxiId)
	}

	private CreditCardInformation recoverCCInformation(Long ccId){
		return CreditCardInformation.get(ccId)
	}
}
