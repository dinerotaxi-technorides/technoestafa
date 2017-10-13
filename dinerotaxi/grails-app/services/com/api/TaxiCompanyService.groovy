package com.api
import ar.com.operation.*
import grails.converters.*
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import ar.com.goliath.EmployUser
import ar.com.goliath.TypeEmployer
import ar.com.operation.OFStatus
import ar.com.operation.OnlineRadioTaxi
import ar.com.operation.OperationPending
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.OperationCompanyPending
import ar.com.operation.TrackOnlineRadioTaxi

class TaxiCompanyService {
	def mailService
	static transactional = true
	/**
	 * Recibe un usuario EmployUser y setea online el radiotaxi
	 * @param usr
	 * @return devuelve una lista de pedidos para asignar.
	 */
	def getPendingTrips(usr){

		def onlineRtaxi=OnlineRadioTaxi.findByCompany(usr.employee)
		if(onlineRtaxi){
			log.debug "---------------ONLINERTAXI--------------------------"
			log.debug onlineRtaxi as JSON
			log.debug "---------------ONLINERTAXI--------------------------"
			if(onlineRtaxi.status==OFStatus.OFFLINE){
				onlineRtaxi.status=OFStatus.ONLINE
				onlineRtaxi.isTestUser=usr.isTestUser
				def d1=new Date()
				d1.setMinutes(d1.minutes-15)
				if(onlineRtaxi.lastModifiedDate<d1){
					log.debug "ENTRNADO A ONLINE RADIOTAXI"
					def conf = SpringSecurityUtils.securityConfig
					String emailHml="RADIOTAXI ONLINE ${onlineRtaxi.company.companyName} ${onlineRtaxi.company.phone}"

					mailService.sendMail {
						to "fedemdq@gmail.com","matiasbaglieri@gmail.com"
						from conf.ui.register.emailFrom
						subject emailHml
						html emailHml
					}
				}
				TrackOnlineRadioTaxi track=new TrackOnlineRadioTaxi(status:OFStatus.ONLINE,onlineRTaxi:onlineRtaxi).save(flush:true)
				onlineRtaxi.save(flush:true)
			}else{
				onlineRtaxi.lastModifiedDate= new Date()
				onlineRtaxi.save(flush:true)
			}
		}else{
			def countTaxi=EmployUser.countByEmployeeAndTypeEmploy(usr.employee,TypeEmployer.TAXISTA)
			log.debug "count Taxis: ${countTaxi}"
			def onlineRtaxis=new OnlineRadioTaxi(status:OFStatus.ONLINE,company:usr.employee,position:0l,penality:0l,countTaxi:countTaxi,countTrips:1,tripSucess:0l,
			tripCalification:0l,tripFail:0l,timeEffort:0l,countRejectTrip:0l,operator:usr,isTestUser:usr.isTestUser)
			if(!onlineRtaxis.save(flush:true)){
			}
			TrackOnlineRadioTaxi track=new TrackOnlineRadioTaxi(status:OFStatus.ONLINE,onlineRTaxi:onlineRtaxis).save(flush:true)
		}

		def customers = OperationPending.createCriteria().list() {
			and{
				eq('intermediario',usr)
				eq('status', TRANSACTIONSTATUS.ASSIGNEDRADIOTAXI)
				eq('isTestUser', usr.isTestUser)
			}
		}
		def jsonCells = customers.collect {
			[createdDate:new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(it.createdDate),
				firstName: it?.user?.firstName,
				lastName: it?.user?.lastName,
				phone: it?.user?.phone,
				placeFrom: it.favorites?.placeFrom?.name,
				placeFromPso: it.favorites.placeFromPso,
				placeFromDto: it.favorites.placeFromDto,
				comments: it.favorites.comments,
				isCompanyAccount:false,
				isFrequent:it?.user?.isFrequent,
				lat:it.favorites?.placeFrom?.lat,
				lng:it.favorites?.placeFrom?.lng,
				isWhiteLabel:it?.user?.rtaxi?true:false,
				id: it.id

			]
		}
		def customersCompany = OperationCompanyPending.createCriteria().list() {
			and{
				eq('intermediario',usr)
				eq('status', TRANSACTIONSTATUS.ASSIGNEDRADIOTAXI)
				eq('isTestUser', usr.isTestUser)
			}
		}
		def jsonCells1 = customersCompany.collect {
			[createdDate:new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(it.createdDate),
				firstName: it?.user?.firstName,
				lastName: it?.user?.lastName,
				phone: it?.user?.phone,
				placeFrom: it.favorites?.placeFrom?.name,
				placeFromPso: it.favorites.placeFromPso,
				placeFromDto: it.favorites.placeFromDto,
				comments: it.favorites.comments,
				isCompanyAccount:true,
				isFrequent:true,
				isWhiteLabel:it?.user?.rtaxi?true:false,
				id: it.id

			]
		}
		jsonCells1.addAll jsonCells
		return jsonCells1
	}
	def getTrips(usr){

		def onlineRtaxi=OnlineRadioTaxi.findByCompany(usr.employee)
		if(onlineRtaxi){
			if(onlineRtaxi.status==OFStatus.OFFLINE){
				onlineRtaxi.status=OFStatus.ONLINE
				onlineRtaxi.isTestUser=usr.isTestUser
				TrackOnlineRadioTaxi track=new TrackOnlineRadioTaxi(status:OFStatus.ONLINE,onlineRTaxi:onlineRtaxi).save(flush:true)
				onlineRtaxi.save(flush:true)
			}else{
				onlineRtaxi.lastModifiedDate= new Date()
				onlineRtaxi.save(flush:true)
			}
		}else{
			def countTaxi=EmployUser.countByEmployeeAndTypeEmploy(usr.employee,TypeEmployer.TAXISTA)
			def onlineRtaxis=new OnlineRadioTaxi(status:OFStatus.ONLINE,company:usr.employee,position:0l,penality:0l,countTaxi:countTaxi,countTrips:1,tripSucess:0l,
			tripCalification:0l,tripFail:0l,timeEffort:0l,countRejectTrip:0l,operator:usr,isTestUser:usr.isTestUser)
			if(!onlineRtaxis.save(flush:true)){
			}
			TrackOnlineRadioTaxi track=new TrackOnlineRadioTaxi(status:OFStatus.ONLINE,onlineRTaxi:onlineRtaxis).save(flush:true)
		}

		def customers = OperationPending.createCriteria().list() {
			and{
				eq('intermediario',usr)
				eq('status', TRANSACTIONSTATUS.ASSIGNEDRADIOTAXI)
				eq('isTestUser', usr.isTestUser)
			}
		}
		def jsonCells = customers.collect {
			[createdDate:new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(it.createdDate),
				firstName: it?.user?.firstName,
				lastName: it?.user?.lastName,
				userPhone: it?.user?.phone,
				placeFrom: it.favorites?.placeFrom?.name,
				placeFromFloor: it.favorites.placeFromPso,
				placeFromAparment: it.favorites.placeFromDto,
				placeFromLat:it.favorites?.placeFrom?.lat,
				placeFromLng:it.favorites?.placeFrom?.lng,
				placeTo: it.favorites?.placeTo?.name,
				placeToFloor: it.favorites.placeToFloor,
				placeToAparment: it.favorites.placeToApartment,
				placeToLat:it.favorites?.placeTo?.lat,
				placeToLng:it.favorites?.placeTo?.lng,
				messaging:it.options?.messaging?:false,
				pet:it.options?.pet?:false,
				airConditioning:it.options?.airConditioning?:false,
				smoker:it.options?.smoker?:false,
				specialAssistant:it.options?.specialAssistant?:false,
				luggage:it.options?.luggage?:false,
				comments: it.favorites.comments,
				isCompanyAccount:false,
				isFrequent:it?.user?.isFrequent,
				isWhiteLabel:it?.user?.rtaxi?true:false,
				id: it.id

			]
		}
		def customersCompany = OperationCompanyPending.createCriteria().list() {
			and{
				eq('intermediario',usr)
				eq('status', TRANSACTIONSTATUS.ASSIGNEDRADIOTAXI)
				eq('isTestUser', usr.isTestUser)
			}
		}
		def jsonCells1 = customersCompany.collect {
			[createdDate:new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(it.createdDate),
				firstName: it?.user?.firstName,
				lastName: it?.user?.lastName,
				phone: it?.user?.phone,
				placeFrom: it.favorites?.placeFrom?.name,
				placeFromPso: it.favorites.placeFromPso,
				placeFromDto: it.favorites.placeFromDto,
				comments: it.favorites.comments,
				isCompanyAccount:true,
				isFrequent:true,
				isWhiteLabel:it?.user?.rtaxi?true:false,
				id: it.id

			]
		}
		jsonCells1.addAll jsonCells
		return jsonCells1
	}
	def getTaxiList(userInstance){

		def taxis=OnlineDriver.findAllByCompany(userInstance)
		def jsonCells = taxis.collect {
			[
				number: it?.driver?.email.split("@")[0],
				lat: it?.lat?:0,
				lng:it?.lng?:0,
				status:it?.status.toString(),
				lastModifiedDate:it?.lastModifiedDate?.format('dd/MM/yyyy hh:mm:ss'),
				id: it.id
			]
		}

		return jsonCells
	}
}
