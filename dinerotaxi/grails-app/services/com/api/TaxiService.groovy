package com.api

import grails.converters.*
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import ar.com.goliath.*
import ar.com.operation.*

class TaxiService {
    static transactional = false
	/**
	 * Recibe un usuario Taxista y busca viajes disponibles para el
	 * @param usr
	 * @return devuelve una lista de pedidos para asignar.
	 */
	def getDisponibleTrips(usr,lat,lng,state){
		def onlineTaxi=OnlineDriver.findByDriver(usr)
		onlineTaxi.lock()
		try{
			if(!onlineTaxi){
				def newOnlineTaxi=new OnlineDriver(lat:lat,lng:lng,driver:usr,company:usr?.employee).save(flush:true)
			}else{
				if(lat!=null){
					if(!onlineTaxi.isAttached()){
						onlineTaxi.attach()
					}
					if(state!=null ){
						onlineTaxi.status=state
					}else{
						onlineTaxi.status=FStatus.ONLINE
					}
					onlineTaxi.lat=lat
					onlineTaxi.lng=lng
					onlineTaxi.lastModifiedDate = new Date()
					onlineTaxi.save(flush:true)
				}
			}
		}catch(org.springframework.dao.OptimisticLockingFailureException e) {
			log.error "PRISMATIC LOCKING TAXISERVICE ${onlineTaxi.driver.email}"
		}
		def el1=null
		def operaioncrit=Operation.createCriteria()
		def operations = operaioncrit.list() {
			and{
				isNull('taxista')
				eq('company',usr.employee )
				eq('isTestUser', false)
				eq('isTestUser', false)
				or{
					eq('status',TRANSACTIONSTATUS.PENDING)
					eq('status',TRANSACTIONSTATUS.ASSIGNEDRADIOTAXI)
				}
			}
		}
		for(Operation opPendiente:operations){
			boolean opInBlackList=false
			for(User u:opPendiente.blackListUsers){
				if(u.id==usr.id){
					opInBlackList= true
				}
			}

			if (!opInBlackList) {
				el1= opPendiente
			}
		}
		return el1
	}
	def getStatusTrip(usr,idOperation,lat,lng){
		def  oper=Operation.get(idOperation)
		try {
			def onlineTaxi=OnlineDriver.findByDriver(usr, [lock: true])
			if(!onlineTaxi){
				def newOnlineTaxi=new OnlineDriver(lat:lat,lng:lng,driver:usr,company:usr?.employee).save(flush:true)
			}else{
				if(lat!=null){
					
					if(!onlineTaxi.isAttached()){
						onlineTaxi.attach()
					}
					switch (oper?.status){
						case TRANSACTIONSTATUS.CANCELED:
							onlineTaxi.status=FStatus.ONLINE
						case TRANSACTIONSTATUS.CANCELED_EMP:
							onlineTaxi.status=FStatus.ONLINE
						case TRANSACTIONSTATUS.CANCELED_DRIVER:
							onlineTaxi.status=FStatus.ONLINE
						case TRANSACTIONSTATUS.CALIFICATED:
							onlineTaxi.status=FStatus.ONLINE
						case TRANSACTIONSTATUS.REJECTTRIP:
							onlineTaxi.status=FStatus.ONLINE
						case TRANSACTIONSTATUS.TIMEOUTTRIP:
							onlineTaxi.status=FStatus.ONLINE
						case TRANSACTIONSTATUS.CANCELTIMETRIP:
							onlineTaxi.status=FStatus.ONLINE
						case TRANSACTIONSTATUS.CANCELOFFLINERTAXI:
							onlineTaxi.status=FStatus.ONLINE
						case TRANSACTIONSTATUS.SETAMOUNT:
							onlineTaxi.status=FStatus.ONLINE
					}
					onlineTaxi.lat=lat
					onlineTaxi.lng=lng
					onlineTaxi.lastModifiedDate = new Date()
					onlineTaxi.save(flush:true)
				}
			}
		}
		catch(org.springframework.dao.OptimisticLockingFailureException e) {
			log.error "PRISMATIC LOCKING TAXISERVICE ${onlineTaxi.driver.email}"
		}finally{

			return oper
		}
	}
}

