package com.api
import grails.converters.JSON

import javax.servlet.*
import javax.servlet.http.*

import org.codehaus.groovy.grails.commons.*
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils

import ar.com.favorites.*
import ar.com.goliath.*
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.DelayOperation
import ar.com.operation.Operation
import ar.com.operation.OperationCompanyHistory
import ar.com.operation.OperationCompanyPending
import ar.com.operation.OperationHistory
import ar.com.operation.OperationPending
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.TrackOperation

import com.*
class TripApiController {
	def exportService
	def springSecurityService
	def placeService
	def placeCompanyAccountEmployeeService
	def userService
	def emailService
	def notificationService
	def utilsApiService
	def geocoderService

	def createTrip={
		render(contentType: 'text/json',encoding:"UTF-8") { status=11 message="deprecated" }
	}

	def createTripGeo={
		render(contentType: 'text/json',encoding:"UTF-8") { status=11 message="deprecated" }
	}

	def createTripWithResponse={
		render(contentType: 'text/json',encoding:"UTF-8") { status=11 message="deprecated" }
	}

	def createTripWithOtherTrip={
		render(contentType: 'text/json',encoding:"UTF-8") { status=11 message="deprecated" }
  }

	def createTripWithFavorite={
		render(contentType: 'text/json',encoding:"UTF-8") { status=11 message="deprecated" }
	}

	def cancelTrip={
		try{
			def usr=null
			def tok=null

			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def id=params?.id
					def operationInstance = Operation.get(params.id)
					if(operationInstance){
						if (operationInstance.user==usr){
							try {
								operationInstance.status=TRANSACTIONSTATUS.CANCELED
								operationInstance.save(flush:true)

								if(usr instanceof CorporateUser){
									Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
											[cClass: OperationCompanyHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED])

								}else{
									Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
											[cClass: OperationHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED])
								}

								def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.CANCELED)
								trackOperation.operation=operationInstance
								trackOperation.save(flush:true)
								notificationService.notificateOnCancelTripByUserForRadioTaxi(operationInstance,usr)
								render(contentType: 'text/json',encoding:"UTF-8") {
									opId=operationInstance.id.toString()
									status=100
								}
							}
							catch (org.springframework.dao.DataIntegrityViolationException e) {
								render(contentType: 'text/json',encoding:"UTF-8") { status=123 }
							}

						}else{
							render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def geocode={
		try{
			if(params?.place){
				def source=geocoderService.queryForJSONUTF(params?.place)
				render(contentType: 'text/json',encoding:"UTF-8") {
					status=100
					place=source
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=16 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=404 }
		}
	}

	def geocodeUtf={
		try{
			if(params?.place){
				def source=geocoderService.queryForJSONUTF(params?.place)
				render(contentType: 'application/json',encoding:"UTF-8") {
					status=100
					place=source
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=16 }
			}

		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType: 'text/json',encoding:"UTF-8") { status=404 }
		}
	}

	def geocodes={
		if(params?.place){
			def source=geocoderService.queryForJSONUTF(params?.place)

			render(contentType: 'text/json',encoding:"UTF-8") {
				status=100
				place=source
			}

		}else{
			render(contentType: 'text/json',encoding:"UTF-8") { status=16 }
		}
	}

	def confirmTrip={
		try{
			def usr=null
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def id=params?.id
					def operationInstance = Operation.get(params.id)
					if(operationInstance){
						if (operationInstance.user==usr){
							if (operationInstance?.taxista) {
								try {
									if(usr instanceof CorporateUser){
										Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
												[cClass: OperationCompanyHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED])

									}else{
										Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
												[cClass: OperationHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED])
									}
									render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
								}
								catch (org.springframework.dao.DataIntegrityViolationException e) {
									render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
								}
							}else{
								render(contentType: 'text/json',encoding:"UTF-8") { status=114 }
							}
						}else{
							render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def deleteListTrip={
		try{
			def usr=null
			def tok=null

			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					if(params?.id){
						def id=params?.id.split(",")
						id.each{
							def operationInstance = Operation.get(it)
							if(operationInstance){
								if (operationInstance.user==usr){
									operationInstance.setEnabled(false);
									operationInstance.save(flush:true);
								}
							}
						}
						render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def deleteTrip={
		try{
			def usr=null
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def id=params?.id
					def operationInstance = Operation.get(params.id)
					if(operationInstance){
						if (operationInstance.user==usr){
							operationInstance.setEnabled(false);
							operationInstance.save(flush:true);
							render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
						}else{
							render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def deleteAllTrip={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def c =null
					if(usr instanceof CorporateUser){
						c = OperationCompanyHistory.createCriteria()
					}else{
						c = OperationHistory.createCriteria()
					}
					def opL=c.list([offset:params.offset,max:params.max]){
						and{
							eq('user',usr)
							eq('enabled',true)
						}
					}
					opL.each {
						it.setEnabled(false);
						it.save(flush:true);
					}
					render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getListTrip={
		try{
			def usr=null
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def c = Operation.createCriteria()
					def opL=c.list(){
						and{
							eq('user',usr)
							eq('enabled',true)
						}
					}
					def ids= opL.collect { it.id }
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						id=ids.join(",")
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getHistoryTrip={
		try{
			def usr=null
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def c=null
					if(usr instanceof CorporateUser){
						c= OperationCompanyHistory.createCriteria()
					}else{
						c= OperationHistory.createCriteria()

					}
					def opL=c.list(){
						and{
							eq('user',usr)
							eq('enabled',true)
						}
					}
					def ids= opL.collect { it.id }
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						id=ids.join(",")
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getFullPendingTrip={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def c=null
					if(usr instanceof CorporateUser){
						c= OperationCompanyPending.createCriteria()
					}else{
						c= OperationPending.createCriteria()
					}
					def opL=c.list(){
						and{
							eq ('user',usr)
							eq('enabled',true)
						}
						order("createdDate", "desc")
					}
					def listTrip=new ArrayList()
					opL.each{
						def res=new TaxiCommand()
						if(it?.intermediario){
							if(it?.taxista){
								res.nombre= it.taxista.firstName+" "+ it.taxista.lastName
								def v=Vehicle.findByTaxistas(it.taxista)
								if(v && v.patente.equals("------")){
									res.marca=v.marca
									res.patente=v.patente
									res.modelo=v.modelo
								}else{
									res.marca=""
									res.patente=""
									res.modelo=""
								}
								res.numeroMovil=it.taxista.email.split("@")[0]
							}
							def com=Company.get(it.intermediario.employee.id)
							if(com){
								res.empresa= com.companyName
								res.companyPhone=com.phone
							}
						}else if (it?.taxista){
							res.nombre= it.taxista.firstName+" "+ it.taxista.lastName
							def v=Vehicle.findByTaxistas(it.taxista)
							if(v && v.patente.equals("------")){
								res.marca=v.marca
								res.patente=v.patente
								res.modelo=v.modelo
							}else{
								res.marca=""
								res.patente=""
								res.modelo=""
							}
						}
						def tr=new com.TripCommand(it.id,it.timeTravel,it.createdDate,it.favorites?.placeFrom.street+" "+ it.favorites?.placeFrom.streetNumber,
								it.favorites?.placeFromPso?it.favorites?.placeFromPso:'',
								it.favorites?.placeFromDto?it.favorites?.placeFromDto:'',
								it.favorites?.placeTo?it.favorites?.placeTo.street+" "+ it.favorites?.placeTo.streetNumber:'',
								it.favorites?.comments?it.favorites?.comments:'',it.status.toString(),res,it.favorites instanceof Favorites?it.favorites?.name:"")
						listTrip.add(tr)
					}
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						json=listTrip
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getFullHistoryTrip={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def c=null
					if(usr instanceof CorporateUser){
						c= OperationCompanyHistory.createCriteria()
					}else{
						c= OperationHistory.createCriteria()

					}
					def opL=c.list(){
						and{
							eq ('user',usr)
							eq('enabled',true)
						}
						order("createdDate", "desc")
					}
					def listTrip=new ArrayList()
					opL.each{
						def res=new TaxiCommand()
						if(it?.intermediario){
							if(it?.taxista){
								res.nombre= it.taxista.firstName+" "+ it.taxista.lastName
								def v=Vehicle.findByTaxistas(it.taxista)
								if(v){
									res.marca=v.marca
									res.patente=v.patente
									res.modelo=v.modelo
								}
								res.numeroMovil=it.taxista.email.split("@")[0]
							}
							def com=Company.get(it.intermediario.employee.id)
							if(com){
								res.empresa= com.companyName
							}
						}else if (it?.taxista){
							res.nombre= it.taxista.firstName+" "+ it.taxista.lastName
							def v=Vehicle.findByTaxistas(it.taxista)
							if(v){
								res.marca=v.marca
								res.patente=v.patente
								res.modelo=v.modelo
							}
						}
						def tr=new com.TripCommand(it.id,it.timeTravel,it.createdDate,it.favorites?.placeFrom.street+" "+ it.favorites?.placeFrom.streetNumber,
								it.favorites?.placeFromPso?it.favorites?.placeFromPso:'',
								it.favorites?.placeFromDto?it.favorites?.placeFromDto:'',
								it.favorites?.placeTo?it.favorites?.placeTo.street+" "+ it.favorites?.placeTo.streetNumber:'',
								it.favorites?.comments?it.favorites?.comments:'',it.status.toString(),res,it.favorites instanceof Favorites?it.favorites?.name:"")
						listTrip.add(tr)
					}
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						json=listTrip

					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getListTrips={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){

					def critereaPending=null
					if(usr instanceof CorporateUser){
						critereaPending= OperationCompanyPending.createCriteria()
					}else{
						critereaPending= OperationPending.createCriteria()

					}
					def c=null
					if(usr instanceof CorporateUser){
						c= OperationCompanyHistory.createCriteria()
					}else{
						c= OperationHistory.createCriteria()

					}
					def opL=c.list(){
						and{
							eq ('user',usr)
							eq('enabled',true)
							isNotNull('createdDate')
						}
						order("createdDate", "desc")
						maxResults(10)
					}
					def historyTrips=new ArrayList()
					opL.each{ operation->
						def jsonBuilder = new groovy.json.JsonBuilder()
						def res=new TaxiCommand()
						def vehicle=null
						def company=null
						if(it?.taxista){
							vehicle=Vehicle.findByTaxistas(it.taxista)
						}
						if(it?.intermediario){
						    company=Company.get(it.intermediario.employee.id)
						}
						boolean cc =operation?.user instanceof CorporateUser
						def movil=it?.taxista?.email?it.taxista.email.split("@")[0]:''
						def name=it?.taxista?.firstName?it.taxista.firstName+' '+it?.taxista?.lastName:''
						def driverBuilder = jsonBuilder{
							brandName vehicle?.marca?:''
							carLicense vehicle?.patente?:''
							vehicleModel vehicle?.modelo?:''
							companyName  company?.companyName?:''
							companyPhone company?.phone?:''
							driverNumber movil
							driverName name
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
							lat		operation?.favorites?.placeTo?.lat
							lng		operation?.favorites?.placeTo?.lng
							appartment operation?.favorites?.placeToApartment?:''
						}

						def optionsBuilder = jsonBuilder{
							messaging operation?.options?.messaging
							pet operation?.options?.pet
							airConditioning operation?.options?.airConditioning
							smoker operation?.options?.smoker
							specialAssistant operation?.options?.specialAssistant
							luggage operation?.options?.luggage
						}

						def operationBuilder = jsonBuilder{
							id operation.id
							status operation.status.toString()
							driver_number operation?.driverNumber?:null
							payment_reference operation?.paymentReference?:''
							createdDate operation.createdDate
							placeFrom placeFromBuilder
							placeTo placeToBuilder
							driver driverBuilder
							options optionsBuilder
							comments operation?.favorites?.comments?:""
							device operation?.dev?operation?.dev.toString():"UNDEFINED"
						}

						historyTrips.add(operationBuilder)
					}
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						history=historyTrips
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getFullTrips={
		try{
			def usr=null
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){

					def critereaPending=null
					if(usr instanceof CorporateUser){
						critereaPending= OperationCompanyPending.createCriteria()
					}else{
						critereaPending= OperationPending.createCriteria()

					}
					def operationPendigsLis=critereaPending.list(){
						and{
							eq ('user',usr)
							eq('enabled',true)
							isNotNull('createdDate')
						}
						order("createdDate", "desc")
					}
					def pendingTrips=new ArrayList()
					operationPendigsLis.each{
						def res=new TaxiCommand()
						if(it?.intermediario){
							if(it?.taxista){
								res.nombre= it.taxista.firstName+" "+ it.taxista.lastName
								def v=Vehicle.findByTaxistas(it.taxista)
								if(v && v.patente.equals("------")){
									res.marca=v.marca
									res.patente=v.patente
									res.modelo=v.modelo
								}else{
									res.marca=""
									res.patente=""
									res.modelo=""
								}
								res.numeroMovil=it.taxista.email.split("@")[0]
							}
							def com=Company.get(it.intermediario.employee.id)
							if(com){
								res.empresa= com.companyName
								res.companyPhone=com.phone
							}
						}else if (it?.taxista){
							res.nombre= it.taxista.firstName+" "+ it.taxista.lastName
							def v=Vehicle.findByTaxistas(it.taxista)
							if(v && v.patente.equals("------")){
								res.marca=v.marca
								res.patente=v.patente
								res.modelo=v.modelo
							}else{
								res.marca=""
								res.patente=""
								res.modelo=""
							}
						}
						def tr=new com.TripCommand(it.id,it.timeTravel,it.createdDate,it.favorites?.placeFrom.name,
								it.favorites?.placeFromPso?it.favorites?.placeFromPso:'',
								it.favorites?.placeFromDto?it.favorites?.placeFromDto:'',
								it.favorites?.placeTo?it.favorites?.placeTo.name:'',
								it.favorites?.comments?it.favorites?.comments:'',it.status.toString(),res,it.favorites instanceof Favorites?it.favorites?.name:"")
						pendingTrips.add(tr)
					}
					def c=null
					if(usr instanceof CorporateUser){
						c= OperationCompanyHistory.createCriteria()
					}else{
						c= OperationHistory.createCriteria()

					}
					def opL=c.list(){
						and{
							eq ('user',usr)
							eq('enabled',true)
							isNotNull('createdDate')
						}
						order("createdDate", "desc")
						maxResults(10)
					}
					def historyTrips=new ArrayList()
					opL.each{
						def res=new TaxiCommand()
						if(it?.intermediario){
							if(it?.taxista){
								res.nombre= it.taxista.firstName+" "+ it.taxista.lastName
								def v=Vehicle.findByTaxistas(it.taxista)
								if(v){
									res.marca=v.marca
									res.patente=v.patente
									res.modelo=v.modelo
								}
								res.numeroMovil=it.taxista.email.split("@")[0]
							}
							def com=Company.get(it.intermediario.employee.id)
							if(com){
								res.empresa= com.companyName
								res.companyPhone=com.phone
							}
						}else if (it?.taxista){
							res.nombre= it.taxista.firstName+" "+ it.taxista.lastName
							def v=Vehicle.findByTaxistas(it.taxista)
							if(v){
								res.marca=v.marca
								res.patente=v.patente
								res.modelo=v.modelo
							}
						}
						def tr=new com.TripCommand(it.id,it.timeTravel,it.createdDate,it.favorites?.placeFrom.name,
								it.favorites?.placeFromPso?it.favorites?.placeFromPso:'',
								it.favorites?.placeFromDto?it.favorites?.placeFromDto:'',
								it.favorites?.placeTo?it.favorites?.placeTo.name:'',
								it.favorites?.comments?it.favorites?.comments:'',it.status.toString(),res,it.favorites instanceof Favorites?it.favorites?.name:"")
						historyTrips.add(tr)
					}
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						history=historyTrips
						pending=pendingTrips

					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getPendingTrip={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def c=null
					if(usr instanceof CorporateUser){
						c= OperationCompanyPending.createCriteria()
					}else{
						c= OperationPending.createCriteria()

					}
					def opL=c.list(){
						and{
							eq ('user',usr)
							eq('enabled',true)
						}
					}
					def ids= opL.collect { it.id }
					render(contentType: 'text/json',encoding:"UTF-8") {
						status=100
						id=ids.join(",")

					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getTrip={
		try{
			def usr=null

			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def id=params?.id
					def operationInstance = Operation.get(params.id)
					if(operationInstance){
						if (operationInstance.user==usr){
							render(contentType: 'text/json',encoding:"UTF-8") {
								status=100
								opid=operationInstance.id
								creationDate=operationInstance.createdDate
								placeFrom=operationInstance.favorites?.placeFrom.street+" "+ operationInstance.favorites?.placeFrom.streetNumber
								piso=operationInstance.favorites?.placeFromPso?operationInstance.favorites?.placeFromPso:''
								depto=operationInstance.favorites?.placeFromDto?operationInstance.favorites?.placeFromDto:''
								placeTo=operationInstance.favorites?.placeTo?operationInstance.favorites?.placeTo.street+" "+ operationInstance.favorites?.placeTo.streetNumber:''
								comments=operationInstance.favorites?.comments?operationInstance.favorites?.comments:''
								status=operationInstance.status
							}
						}else{
							render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def calificateTrip={
		try{
			def usr=null
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}else if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def id=params?.id
					def comen=params?.comments?:""
					if(params?.stars){
						def calif=Integer.valueOf(params?.stars)
						if(calif<=5 && calif >0){

							def operationInstance=null
							if(usr instanceof CorporateUser){
								operationInstance= OperationCompanyHistory.get(params.id)
							}else{
								operationInstance= OperationHistory.get(params.id)

							}
							if(operationInstance){
								if (operationInstance.user==usr){
									def hasCalif=Calification.findAllByOperation(operationInstance)
									if(!hasCalif){
										new Calification(stars:calif,operation:operationInstance,taxista:operationInstance.taxista,comments:comen).save(flush:true)
										operationInstance.status=TRANSACTIONSTATUS.CALIFICATED
										operationInstance.save(flush:true)

										def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.CALIFICATED)
										trackOperation.operation=operationInstance
										trackOperation.save(flush:true)

										render(contentType: 'text/json',encoding:"UTF-8") { status=100 }
									}else{
										render(contentType: 'text/json',encoding:"UTF-8") { status=129 }
									}
								}else{
									render(contentType: 'text/json',encoding:"UTF-8") { status=125 }
								}
							}else{
								render(contentType: 'text/json',encoding:"UTF-8") { status=121 }
							}
						}else{
							render(contentType: 'text/json',encoding:"UTF-8") { status=128 }
						}
					}else{
						render(contentType: 'text/json',encoding:"UTF-8") { status=127 }
					}
				}else{
					render(contentType: 'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType: 'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def getOperationHistory ={
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def sortIndex   = params.sidx ?: 'id'
		def sortOrder   = params.sord ?: 'desc'
		def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
		def currentPage = params?.page? Integer.valueOf(params.page) : 1

		def rowOffset     = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def customers = null
		def status = null

    //Cast all status into Enum and filtered in query
    if (params?.status != null){
			status = params.status.split(',').collect {it as TRANSACTIONSTATUS}
		}

		if(usr instanceof RealUser){
			customers = OperationHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
				if (status != null){
					and{
						eq('user',usr)
						'in'('status',status)
					}
				} else {
					eq('user',usr)
				}
				order(sortIndex, sortOrder)
			}
		}else{
			customers = OperationCompanyHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
				if (status != null){
					and{
						eq('user',usr)
						'in'('status',status)
					}
				} else {
					eq('user',usr)
				}
				order(sortIndex, sortOrder)
			}

		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			generateOperationJson(it)
		}

		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		render jsonData as JSON
	}

	def getOperationScheduled ={
		try {
			def tok=PersistToken.findByToken(params.token)
			if(!tok){
				render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
				return false
			}
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(!usr){
				render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
				return false
			}
			def sortIndex   = params.sidx ?: 'id'
			def sortOrder   = params.sord ?: 'desc'
			def maxRows     = params?.rows? Integer.valueOf(params.rows) : 10
			def currentPage = params?.page? Integer.valueOf(params.page) : 1
			def rowOffset   = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

			def usersCriterea = CorporateUser.createCriteria()
      def status = null;

	    //Cast all status into Enum and filtered in query
	    if (params?.status != null){
				status = params.status.split(',').collect {it as TRANSACTIONSTATUS}
			}

			def customers = DelayOperation.createCriteria().list(max:maxRows, offset:rowOffset) {
				if (status != null){
					and{
						eq('user',usr)
						'in'('status',status)
					}
				} else {
					eq('user',usr)
				}
				order(sortIndex, sortOrder)
			}
			def totalRows = customers.totalCount
			def numberOfPages = Math.ceil(totalRows / maxRows)
			def jsonCells = customers.collect {
				def pojo = generateOperationJson(it)
				pojo.executionTime = utilsApiService.generateFormatedAddressToClient(it?.executionTime,it?.user)
				return pojo
			}
			def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
			render jsonData as JSON
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=200 }
		}
	}

	def generateOperationJson(operation){
		def jsonBuilder = new groovy.json.JsonBuilder()
		boolean cc =operation?.user instanceof CorporateUser
		def userBuilder = jsonBuilder{
			id  operation?.user?.id
			firstName operation?.user?.firstName
			lastName operation?.user?.lastName
			companyName operation?.user?.companyName
			phone operation?.user?.phone
			rtaxi operation?.user?.rtaxi?.id
			lang operation?.user?.rtaxi?.lang?:'es'
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

		def vehicleBuilder = null
    if (operation?.taxista) {
			def ve=Vehicle.findByTaxistas(operation?.taxista)
			vehicleBuilder = jsonBuilder{
				brandCompany ve.marca
	      model ve.modelo
	      plate ve.patente
			}
		}

    //Only Operation model contains stars
    def stars = null
		if (operation instanceof Operation){
			stars = operation?.stars
		}
    def driverBuilder = jsonBuilder{
      firstName operation?.taxista?.firstName
			lastName operation?.taxista?.lastName
			email operation?.taxista?.email
			score stars?:''
			car vehicleBuilder?:''
		}

		def operationBuilder = jsonBuilder{
			id operation.id
			status operation.status.toString()
			driver_number operation?.driverNumber?:null
			driver driverBuilder
			payment_reference operation?.paymentReference?:''
			lat operation?.favorites?.placeFrom?.lat
			lng operation?.favorites?.placeFrom?.lng
			placeFrom placeFromBuilder
			placeTo placeToBuilder
			user userBuilder
			options optionsBuilder
			comments operation?.favorites?.comments?:''
			device operation?.dev?operation?.dev.toString():"UNDEFINED"
			amount operation?.amount
			createdDate utilsApiService.generateFormatedAddressToClient(operation?.createdDate,operation?.user)
		}
		return operationBuilder
	}
}
