package com.api

import grails.converters.*
import groovyx.net.http.RESTClient

import org.codehaus.groovy.grails.commons.ConfigurationHolder

import ar.com.favorites.*
import ar.com.goliath.*
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.*


class OperationApiService {

	static transactional = true
	def utilsApiService
	def notificationService
	def createFavoriteAndOperation(businessModel, user, addressFrom, addressTo, optionsJSON,device,ip,argss) {
		def comments = argss?.comments
		def paymentReference = argss?.payment_reference
		def driverNumber = argss?.driver_number
		def amount = argss?.amount
		
		def operation = Operation.createCriteria().list(max:1) {
			eq('user',user)
			or{
				eq('status', TRANSACTIONSTATUS.PENDING)
				eq('status', TRANSACTIONSTATUS.INTRANSACTION)
				eq('status', TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI)
				eq('status', TRANSACTIONSTATUS.HOLDINGUSER)
				eq('status', TRANSACTIONSTATUS.ASSIGNEDRADIOTAXI)
				eq('status', TRANSACTIONSTATUS.ASSIGNEDTAXI)
				eq('status', TRANSACTIONSTATUS.REASIGNTRIP)
			}
		}
		if (operation){
			print operation
			return operation[0]
		}
		def name=addressFrom?.street+" "+addressFrom?.number
		def placeFromString=utilsApiService.generateAddress(addressFrom)
		def o = JSON.parse(placeFromString)
		def pl = new Place(o)
		pl.json = placeFromString
		if(!pl.save(flush:true)){
			pl.errors.each{ print it }
			throw new Exception("createFavoriteAndOperation: Problem placeFrom")
		}
		def pl1 = null
		if(addressTo!=null && !addressTo.equals("")){
			def placeToString=utilsApiService.generateAddress(addressTo)
			def o1 = JSON.parse(placeToString)
			pl1 = new Place(o1)
			pl1.json = placeToString
			if(!pl1.save(flush:true)){
				pl.delete()
				throw new Exception("createFavoriteAndOperation: Problem placeTo")
			}
		}
		def fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
		//new Favorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
		if(!fav.save(flush:true)){
			pl.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("createFavoriteAndOperation: Problem Favorites")
		}
		def options=new Options(optionsJSON)
		if(!options.save(flush:true)){
			pl.delete()
			fav.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("createFavoriteAndOperation: Problem Options")
		}



		def oper=new OperationPending(user:user,favorites:fav,isTestUser:user.isTestUser)
		oper.options=options
		oper.isTestUser=user.isTestUser
		oper.dev=device.dev
		oper.sendToSocket=true
		oper.paymentReference=paymentReference
		oper.status = TRANSACTIONSTATUS.PENDING
		oper.company=user?.rtaxi
		oper.businessModel = businessModel
		try {
			if (driverNumber!=null)
				oper.driverNumber = Integer.parseInt(driverNumber)
		} catch (Exception e) {
			e.printStackTrace()
		}
		
		try {
			if (amount!=null && !amount.equals(""))
				oper.amount =Double.parseDouble(amount)
		} catch (Exception e) {
			e.printStackTrace()
		}
		if(!oper.save(flush:true)){
			fav.delete()
			pl.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("createFavoriteAndOperation: Problem Operation")
		}else{
			def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
			trackOperation.operation=oper
			trackOperation.save(flush:true)
			//notificationService.notificateOnCreateTrip(oper,user)
		}
		return oper
		
	}
	def checkOperation(User usr){
		def company = null
		company = Company.get(usr.rtaxi.id)
		print "------1----"
		print company.wlconfig.blockMultipleTrips
		print "------1----"
		
		if (!company || !company.wlconfig.blockMultipleTrips){
			return null
		}
		def operation = Operation.createCriteria().list() {
			and{
				eq('user',usr)
				ne('status',TRANSACTIONSTATUS.CANCELED)
				ne('status',TRANSACTIONSTATUS.CANCELED_EMP)
				ne('status',TRANSACTIONSTATUS.CANCELED_DRIVER)
				ne('status',TRANSACTIONSTATUS.CALIFICATED)
				ne('status',TRANSACTIONSTATUS.CANCELTIMETRIP)
				ne('status',TRANSACTIONSTATUS.COMPLETED)
			}
			
		}
		if(operation)
			return operation
		return null
	}

	def createOperationCC( businessModel, user, addressFrom, addressTo, optionsJSON,device,ip,argss) {
		def comments = argss?.comments
		def paymentReference = argss?.payment_reference
		def driverNumber = argss?.driver_number
		def amount = argss?.amount
		
		def name=addressFrom?.street+" "+addressFrom?.number

		def placeFromString=utilsApiService.generateAddress(addressFrom)
		def o = JSON.parse(placeFromString)
		def pl = new Place(o)
		pl.json = placeFromString
		if(!pl.save(flush:true)){
			pl.errors.each{ print it }
			throw new Exception("createFavoriteAndOperation: Problem placeFrom")
		}
		def pl1 =  null
		if(addressTo!=null && !addressTo.equals("")){
			def placeToString=utilsApiService.generateAddress(addressTo)
			def o1 = JSON.parse(placeToString)
			pl1 = new Place(o1)
			pl1.json = placeToString
			if(!pl1.save(flush:true)){
				pl.delete()
				throw new Exception("createFavoriteAndOperation: Problem placeTo")
			}
		}
		def fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
		//new Favorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
		if(!fav.save(flush:true)){
			pl.delete()
			if(pl!=null){
				pl.delete()
			}
			throw new Exception("createFavoriteAndOperation: Problem Favorites")
		}
		def options=new Options(optionsJSON)
		if(!options.save(flush:true)){
			pl.delete()
			fav.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("createFavoriteAndOperation: Problem Options")
		}



		def oper=new OperationCompanyPending(user:user,favorites:fav,isTestUser:user.isTestUser)
		oper.options=options
		oper.isTestUser=user.isTestUser
		if(user?.costCenter?.corporate){
			oper.corporate=user?.costCenter?.corporate

		}
		oper.businessModel = businessModel
		oper.costCenter=user.costCenter
		oper.dev=device.dev
		oper.sendToSocket=true
		oper.isCompanyAccount=true
		oper.paymentReference=paymentReference
		oper.status = TRANSACTIONSTATUS.PENDING
		
		oper.company=user?.rtaxi
		if(ip)
			oper.ip = ip
		try {
			if (driverNumber!=null)
				oper.driverNumber = Integer.parseInt(driverNumber)
		} catch (Exception e) {
			e.printStackTrace()
		}
		
		try {
			if (amount!=null && !amount.isEmpty())
				oper.amount =Double.parseDouble(amount)
		} catch (Exception e) {
			e.printStackTrace()
		}
		if(!oper.save(flush:true)){
			fav.delete()
			pl.delete()
			if(pl1!=null){
				pl1.delete()
			}
			throw new Exception("createFavoriteAndOperation: Problem Operation")
		}else{
			def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
			trackOperation.operation=oper
			trackOperation.save(flush:true)
			//notificationService.notificateOnCreateTrip(oper,user)
		}
		return oper
	}
	
	
	def sendToSocket(operation, isDelay = false, createdByOperator = false){
		
		def config = ConfigurationHolder.config
		if(config.restCreateTrip){
			String socket= config.socket
			print config.socket
			def jsonBuilder = new groovy.json.JsonBuilder()
			def createdBy = "OPERATOR"
			boolean cc =operation?.user instanceof CorporateUser
			if(!createdByOperator){
				if(cc){
					createdBy = "C_PASSENGER"
				}else{
					createdBy = "PASSENGER"
				}
			}
			def userBuilder = jsonBuilder{
				id  operation?.user?.id
				firstName operation?.user?.firstName
				lastName operation?.user?.lastName
				companyName operation?.user?.companyName
				phone operation?.user?.phone
				rtaxi operation?.user?.rtaxi?.id
				lang operation?.user?.rtaxi?.lang?:'es'
				email operation?.user?.email
				//city operation?.user?.city
				cityName operation?.user?.city?.name
				cityCode operation?.user?.city?.admin1Code
				isFrequent operation?.user?.isFrequent
				isCC cc
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
			print placeFromBuilder
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
			print "-------------OPERATION AMOUNT----------------"
			print operation?.amount
			
			def operationBuilder = jsonBuilder{
				id operation.id
				status operation.status
				ip operation.ip
				log_programmed_operation isDelay
				log_created_by createdBy
				is_corporate cc
				driver_number operation?.driverNumber?:null
				amount operation?.amount?:0
				discount operation?.corporate?.discount?:0
				payment_reference operation?.paymentReference?:''
				lat operation?.favorites?.placeFrom?.lat
				lng operation?.favorites?.placeFrom?.lng
				placeFrom placeFromBuilder
				placeTo placeToBuilder
				user userBuilder
				options optionsBuilder
				businessModel operation.businessModel
				comments operation?.favorites?.comments?:""
				device operation?.dev?operation?.dev.toString():"UNDEFINED"
			}
			try{
				def node = new RESTClient( socket )
				def resp = node.post( path : 'createTrip.json',
				headers: [accept: 'application/json'],
				contentType: groovyx.net.http.ContentType.JSON,
				body : [operation:operationBuilder,is_web_user:'',is_new_user:false])
				println "-----------------------------"
				println resp?.status
				println resp
				println "-----------------------------"
				return resp?.status==200
			}catch (Exception e){
				println e
				return false
			}
		}else{
			print "CONFIGURED NOT SEND TO SOCKET TRIPS!!!"
			return false;
		}
		
	}

}

