package com.api.technorides

import grails.converters.JSON
import ar.com.favorites.TemporalFavorites
import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.Place
import ar.com.goliath.RealUser
import ar.com.operation.DelayOperation
import ar.com.operation.DelayOperationConfigTime
import ar.com.operation.Options
import ar.com.operation.TRANSACTIONSTATUS

class TechnoRidesDelayOperationService {
	static transactional = true
	def utilsApiService
	def notificationService

	def createFavoriteAndOperation( businessModel, user, addressFrom, addressTo, optionsJSON, comments, device,executionTime,isCompanyAccount,paymentReference,driverNumber,ip,createdByOperator=true,amount=0,timeDelayExecution=null, middleMan = null) {
		def name=addressFrom?.street+" "+addressFrom?.number
		def placeFromString=utilsApiService.generateAddress(addressFrom)
		def o = JSON.parse(placeFromString)
		def pl = new Place(o)
		def pl1 = null
		pl.json = placeFromString
		if(!pl.save(flush:true)){
			pl.errors.each{ println it }
			throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem placeFrom")
		}
		def fav=null
		if(addressTo!=null && !addressTo.equals("") && addressTo?.lat){
			def placeToString=utilsApiService.generateAddress(addressTo)
			def o1 = JSON.parse(placeToString)
			pl1 = new Place(o1)
			pl1.json = placeToString
			if(!pl1.save(flush:true)){
				pl.delete()
				throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem placeTo")
			}
			fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,
			placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
		}else{
			fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:null,user:user)
		}
		if(!fav.save(flush:true)){
			pl.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem Favorites")
		}
		def options=new Options(optionsJSON)
		if(!options.save(flush:true)){
			pl.delete()
			fav.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem Options")
		}
		def oper=new DelayOperation(user:user,favorites:fav,isTestUser:user.isTestUser)
		oper.businessModel=businessModel
		oper.options=options
		oper.isTestUser=user.isTestUser
		oper.dev=device.dev
		oper.company=user?.rtaxi
		oper.executionTime=utilsApiService.generateFormatedAddressToServer( executionTime,user.rtaxi)
		oper.isCompanyAccount=isCompanyAccount
		oper.createdByOperator = createdByOperator
		oper.paymentReference=paymentReference
		oper.intermediario = middleMan
		
		if(!(user instanceof RealUser)){
			if(user?.costCenter?.corporate?.id){
				oper.corporate=user?.costCenter?.corporate
				oper.costCenter=user.costCenter
	
			}
			
		}
		
		try {
			if(amount!=null){
				def amount_d = Double.parseDouble(amount)
				if (amount_d > 0){
					oper.amount =Double.parseDouble(amount)
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace()
		}
		if(ip)
			oper.ip = ip
		try {
			if (driverNumber!=null){
				def rtaxiById = Company.get(user.rtaxi.id)
				oper.driverNumber =Integer.parseInt(driverNumber)
				def driver_str = driverNumber+'@'+ rtaxiById.email.split('@')[1]
				def driver_ff = EmployUser.findByUsername(driver_str)
				oper.taxista =driver_ff
			}
		} catch (Exception e) {
			e.printStackTrace()
		}
		
		if (timeDelayExecution!=null){
			try {
				oper.timeDelayExecution = Integer.parseInt(timeDelayExecution)
			} catch (Exception e) {
				e.printStackTrace()
			}
		}
		
		if(!oper.save(flush:true)){
			fav.delete()
			pl.delete()
			if(pl1!=null){
				pl1.delete()
			}
			oper.errors.each{
				print it
			}
			throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem Operation")
		}
		return oper
	}
	def editTrip(DelayOperation oper, businessModel, user, addressFrom, addressTo, optionsJSON, comments, device,executionTime,isCompanyAccount,paymentReference,driverNumber,ip,createdByOperator=true,amount=0,timeDelayExecution=null, middleMan = null) {
		def name=addressFrom?.street+" "+addressFrom?.number
		def placeFromString=utilsApiService.generateAddress(addressFrom)
		def o = JSON.parse(placeFromString)
		def pl = new Place(o)
		def pl1 = null
		pl.json = placeFromString
		if(!pl.save(flush:true)){
			pl.errors.each{ println it }
			throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem placeFrom")
		}
		def fav=null
		if(addressTo!=null && !addressTo.equals("") && addressTo?.lat){
			def placeToString=utilsApiService.generateAddress(addressTo)
			def o1 = JSON.parse(placeToString)
			pl1 = new Place(o1)
			pl1.json = placeToString
			if(!pl1.save(flush:true)){
				pl.delete()
				throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem placeTo")
			}
			fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,
			placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
		}else{
			fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:null,user:user)
		}
		if(!fav.save(flush:true)){
			pl.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem Favorites")
		}
		def options=new Options(optionsJSON)
		if(!options.save(flush:true)){
			pl.delete()
			fav.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem Options")
		}
		oper.user = user
		oper.favorites = fav
		oper.isTestUser =user.isTestUser
		oper.businessModel=businessModel
		oper.options=options
		oper.isTestUser=user.isTestUser
		oper.dev=device.dev
		oper.company=user?.rtaxi
		oper.executionTime=utilsApiService.generateFormatedAddressToServer( executionTime,user.rtaxi)
		oper.isCompanyAccount=isCompanyAccount
		oper.createdByOperator = createdByOperator
		oper.paymentReference=paymentReference
		oper.intermediario = middleMan
		
		if(!(user instanceof RealUser)){
			if(user?.costCenter?.corporate?.id){
				oper.corporate=user?.costCenter?.corporate
				oper.costCenter=user.costCenter
	
			}
			
		}
		
		try {
			if(amount!=null){
				def amount_d = Double.parseDouble(amount)
				if (amount_d > 0){
					oper.amount =Double.parseDouble(amount)
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace()
		}
		if(ip)
			oper.ip = ip
		try {
			if (driverNumber!=null){
				def rtaxiById = Company.get(user.rtaxi.id)
				oper.driverNumber =Integer.parseInt(driverNumber)
				def driver_str = driverNumber+'@'+ rtaxiById.email.split('@')[1]
				def driver_ff = EmployUser.findByUsername(driver_str)
				oper.taxista =driver_ff
			}
		} catch (Exception e) {
			e.printStackTrace()
		}
		
		if (timeDelayExecution!=null){
			try {
				oper.timeDelayExecution = Integer.parseInt(timeDelayExecution)
			} catch (Exception e) {
				e.printStackTrace()
			}
		}
		
		if(!oper.save(flush:true)){
			fav.delete()
			pl.delete()
			if(pl1!=null){
				pl1.delete()
			}
			oper.errors.each{
				print it
			}
			throw new Exception("TechnoRidesDelayOperationService:createFavoriteAndOperation: Problem Operation")
		}
		return oper
	}
	def getDelayOperationsByRtaxi( params,user) {
		Calendar cal = Calendar.getInstance();
		Calendar calTo = Calendar.getInstance();
		calTo.add(Calendar.DATE, 1)
		cal.add(Calendar.DATE, -1)
		def maxRows = Integer.valueOf(params.rows?:10)
		def currentPage = Integer.valueOf(params.page?: 1) 
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def rowOffset = currentPage  * maxRows
		def customers = DelayOperation.createCriteria().list(max:maxRows, offset:rowOffset) { 
			eq('company',user) 
			if (params.searchBy && params.searchBy.contains(TRANSACTIONSTATUS.PENDING.toString())){
				eq('status',TRANSACTIONSTATUS.PENDING)
				calTo.add(Calendar.DATE, 1)
				between('executionTime',cal.getTime(),calTo.getTime())
			}else if(params.searchBy && params.searchBy.contains(TRANSACTIONSTATUS.COMPLETED.toString())){
				eq('status',TRANSACTIONSTATUS.COMPLETED)
				calTo.add(Calendar.DATE, 1)
				cal.add(Calendar.DATE, -7)
				between('executionTime',cal.getTime(),calTo.getTime())
			}else if(params.searchBy && params.searchBy.contains(TRANSACTIONSTATUS.CANCELED.toString())){
				eq('status',TRANSACTIONSTATUS.CANCELED)
				calTo.add(Calendar.DATE, 1)
				cal.add(Calendar.DATE, -7)
				between('executionTime',cal.getTime(),calTo.getTime())
			}else {
				eq('status',TRANSACTIONSTATUS.PENDING)
			}
			
			if(  params.searchField.equals("passenger_name") && !params.searchString.isEmpty()){
				user{
					ilike("lastName", params.searchString+"%")
					
				}
			}
			if(  params.searchField.equals("passenger_username") && !params.searchString.isEmpty()){
				user{
					ilike("username", params.searchString+"%")
					
				}
			}
			if(  params.searchField.equals("driver_id") && !params.searchString.isEmpty()){
				taxista{
					eq("id", params.searchString)
					
				}
			}
			order(sortIndex, sortOrder)
		}

		def jsonCells = customers.collect {
			toSocketOperation(it)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonData= [result: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:200]
		return jsonData as JSON
	}
	
	def toSocketOperation(operation){
		def jsonBuilder = new groovy.json.JsonBuilder()
		def userBuilder = jsonBuilder{
			id  operation?.user?.id
			firstName operation?.user?.firstName
			lastName operation?.user?.lastName
			companyName operation?.user?.companyName
			email operation?.user?.email
			phone operation?.user?.phone
			rtaxi operation?.user?.rtaxi?.id
			lang operation?.user?.lang
			//city operation?.user?.city
			cityName operation?.user?.city?.name
			cityCode operation?.user?.city?.admin1Code
			isFrequent operation?.user?.isFrequent
			isCC operation.isCompanyAccount
		}
		def placeFromBuilder = jsonBuilder{
			street  operation?.favorites?.placeFrom?.street
			streetNumber  operation?.favorites?.placeFrom?.streetNumber
			country  operation?.favorites?.placeFrom?.country
			locality  operation?.favorites?.placeFrom?.locality
			admin1Code  operation?.favorites?.placeFrom?.admin1Code
			locality  operation?.favorites?.placeFrom?.locality
			floor 	operation?.favorites?.placeFromPso
			lat		operation?.favorites?.placeFrom?.lat
			lng		operation?.favorites?.placeFrom?.lng
			appartment  operation?.favorites?.placeFromDto
		}

		def placeToBuilder = jsonBuilder{
			street  operation?.favorites?.placeTo?.street?:''
			streetNumber  operation?.favorites?.placeTo?.streetNumber?:''
			country  operation?.favorites?.placeTo?.country?:''
			locality  operation?.favorites?.placeTo?.locality?:''
			admin1Code  operation?.favorites?.placeTo?.admin1Code?:''
			locality  operation?.favorites?.placeTo?.locality?:''
			floor	operation?.favorites?.placeToFloor?:''
			lat		operation?.favorites?.placeTo?.lat?:0
			lng		operation?.favorites?.placeTo?.lng?:0
			appartment operation?.favorites?.placeToApartment?:''
		}

		def optionsBuilder = jsonBuilder{
			messaging operation?.options?.messaging
			pet operation?.options?.pet
			airConditioning operation?.options?.airConditioning
			smoker operation?.options?.smoker
			specialAssistant operation?.options?.specialAssistant
			luggage operation?.options?.luggage
 			airport operation?.options?.airport
 			vip operation?.options?.vip
 			invoice operation?.options?.invoice
		}
		
		def middleMan =operation?.intermediario?.username?:''
		def operationBuilder = jsonBuilder{
			id operation.id
			date utilsApiService.generateFormatedAddressToClient(operation.executionTime,operation.user)
			status operation.status
			driver_number operation?.driverNumber?:null
			payment_reference operation?.paymentReference?:''
			lat operation?.favorites?.placeFrom?.lat
			lng operation?.favorites?.placeFrom?.lng
			placeFrom placeFromBuilder
			placeTo placeToBuilder
			user userBuilder
			options optionsBuilder
			comments operation?.favorites?.comments?:""
			device operation?.dev?operation?.dev.toString():"UNDEFINED"
			intermediario middleMan
			operation_id operation.operation?.id?:''
			timeDelayExecution operation?.timeDelayExecution?operation?.timeDelayExecution:null
		}
		return operationBuilder
	}
	
	def editDelayOperationConfig( params,rtaxi){
		def delay_config = null
		def message = ""
		def state = "FAIL"
		def id    = null
		// determine our action
		switch (params.oper) {
			case 'add':
			
				delay_config = new DelayOperationConfigTime()
						
				delay_config.name  = params?.name
				delay_config.timeDelayExecution = params?.int('timeDelayExecution')
				delay_config.rtaxi     = rtaxi
				
				if (! delay_config.hasErrors() && delay_config.save(flush:true)) {
					message = "delay_config.saved"
					id = delay_config.id
					state = "OK"
				} else {
					message =  "delay_config.not.saved"
					delay_config.errors.each{ print it }
				}
				break;
			case 'del':
				delay_config = DelayOperationConfigTime.get(params.delay_config_id)
				if (delay_config && delay_config.rtaxi == rtaxi) {
					id = delay_config.id
					message = "delay_config.deleted"
					state = "OK"
					delay_config.delete()
				}
				break;
			
		}

		def jsonData = [message:message,state:state,status:100,id:id]

		return jsonData as JSON
	}
	
	
	def getDelayOperationsByUser( params,user) {
		
		def jsonBuilder = new groovy.json.JsonBuilder()
		def customers = DelayOperation.createCriteria().list(max:10) { 
			eq('user',user) 
			eq('status',TRANSACTIONSTATUS.PENDING)
		}

		def jsonCells = customers.collect {DelayOperation operation->
			def compania=operation?.user?.rtaxi?.companyName?:'DineroTaxi'
			def piso = operation.favorites?.placeFromPso?:''
			def depto= operation?.favorites?.placeFromDto?:''
			
			
			def placeToBuilder = jsonBuilder{
				street  operation?.favorites?.placeTo?.street?:''
				streetNumber  operation?.favorites?.placeTo?.streetNumber?:''
				country  operation?.favorites?.placeTo?.country?:''
				locality  operation?.favorites?.placeTo?.locality?:''
				admin1Code  operation?.favorites?.placeTo?.admin1Code?:''
				locality  operation?.favorites?.placeTo?.locality?:''
				floor	operation?.favorites?.placeToFloor?:''
				lat		operation?.favorites?.placeTo?.lat?:0
				lng		operation?.favorites?.placeTo?.lng?:0
				appartment operation?.favorites?.placeToApartment?:''
			}
			[
				id:operation.id,
				street:operation.favorites?.placeFrom?.street,
				street_number:operation.favorites?.placeFrom?.streetNumber,
				admin_1_code:operation.favorites?.placeFrom?.admin1Code,
				locality:operation.favorites?.placeFrom?.locality,
				country:operation.favorites?.placeFrom?.country,
				country_code:operation.favorites?.placeFrom?.countryCode,
				floor:piso,
				department:depto,
				lat:operation.favorites?.placeFrom?.lat,
				lng:operation.favorites?.placeFrom?.lng,
				placeTo:placeToBuilder,
				comments:operation.favorites.comments,
				
				execution_time:utilsApiService.generateFormatedAddressToClient(operation.executionTime,operation.user)
			]
		}
		def jsonData= [result: jsonCells]
		return jsonData as JSON
	}
	
}
