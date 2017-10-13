package com

import ar.com.goliath.*
import ar.com.operation.*
class TripPanelService {
	def dataSource
	boolean transactional = true
	def sessionFactory
	def notificationService
	def getAll( params) {

		def now = Date.parse("yyyy-MM-dd", "2009-09-15")
		def c = OperationPending.createCriteria()
		def results = c.list([offset:params.offset,max:params.max]){
			and{
				isNull('intermediario')
				isNull('taxista')
				eq('status', TRANSACTIONSTATUS.PENDING)
			}
		}


		return results
	}
	def getAllCount( params) {
		def c = OperationPending.createCriteria()
		def results = c.get() {
			and{
				isNull('intermediario')
				isNull('taxista')
				eq('status', TRANSACTIONSTATUS.PENDING)
			}

			projections{ count("id") }
		}
		return results
	}

	def setTaxi(userInstance,oper,taxista,intermediario,supervisorRole,operatorRole){
		String message=""
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operatorRole) ){
			if(oper && taxista){
				if(taxista instanceof EmployUser){
					if( taxista.typeEmploy==TypeEmployer.TAXISTA && taxista.status==UStatus.DONE && !taxista.accountLocked ){
						oper.taxista=taxista
						oper.intermediario=intermediario
						oper.company=intermediario.employee
						oper.status=TRANSACTIONSTATUS.INTRANSACTION
						oper.save(flush:true)


						def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.INTRANSACTION)
						trackOperation.operation=oper
						trackOperation.taxista=taxista
						trackOperation.save(flush:true)
						//notificationService.notificateOnTripTaxiSelect(oper,userInstance,false)
						message = "Se transfirio el taxi correctamente"
						message = "OK"
					}else{
						message= " no es taxista"
					}
				}else{
					message =" No tiene operadores debe agregar un operador"
				}
			}else{
				message= " no se encuentra taxista"
			}
		}else{
			message ="El usuario No puede modificar el registro"
		}
		return message
	}
	def setTaxiByRadioTaxi(userInstance,oper,taxista,intermediario,supervisorRole,operatorRole,timeTravel){

		String message=""
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operatorRole) ){
			if(oper && taxista){
				if(taxista instanceof EmployUser){
					if( taxista.typeEmploy==TypeEmployer.TAXISTA && taxista.status==UStatus.DONE && !taxista.accountLocked ){
						OperationPending.findAllByTaxista(taxista).each{
							notificationService.notificateOnTripFinish(it,it.user,true)
						}
						OperationCompanyPending.findAllByTaxista(taxista).each{
							notificationService.notificateOnTripFinish(it,it.user,true)
						}
						Operation.executeUpdate("update OperationPending b set b.status=:status ,b.class=:cClass " +
								"where b.taxista.id=:id",
								[status: TRANSACTIONSTATUS.COMPLETED,cClass: OperationHistory.name, id: taxista.id])
						Operation.executeUpdate("update OperationCompanyPending b set b.status=:status ,b.class=:cClass " +
								"where b.taxista.id=:id",
								[status: TRANSACTIONSTATUS.COMPLETED,cClass: OperationCompanyHistory.name, id: taxista.id])
						oper.taxista=taxista
						println "ac1aa"
						println intermediario
						oper.intermediario=intermediario
						oper.company=intermediario.employee
						oper.status=TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI
						oper.timeTravel=timeTravel
						if(!oper.save(flush:true)){
							oper.errors.each{ log.error it }
						}

						def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI)
						trackOperation.operation=oper
						trackOperation.taxista=taxista
						trackOperation.timeTravel=timeTravel
						trackOperation.save(flush:true)

						notificationService.notificateOnTripRadioTaxiSelect(oper,oper.user,false)
						message = "Se transfirio el taxi correctamente"
						message = "OK"
					}else{
						message= " no es taxista"
					}
				}else{
					message =" No tiene operadores debe agregar un operador"
				}
			}else{
				message= " no se encuentra taxista"
			}
		}else{
			message ="El usuario No puede modificar el registro"
		}
		return message
	}
	def setAmountByRadioTaxiApi(userInstance,oper,supervisorRole,operatorRole,amount){
		String message=""
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operatorRole) ){
			if(oper ){
				oper.amount=amount
				if(!oper.save(flush:true)){
					oper.errors.each{ log.error it }
				}
				def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.SETAMOUNT)
				trackOperation.operation=oper
				trackOperation.save(flush:true)
				message = "100"
			}else{
				message= "212"
			}
		}else{
			message ="213"
		}
		return message
	}
	def setTaxiByRadioTaxiApi(userInstance,oper,taxista,intermediario,supervisorRole,operatorRole,timeTravel){

		String message=""
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operatorRole) ){
			if(oper && taxista){
				if(taxista instanceof EmployUser){
					if( taxista.typeEmploy==TypeEmployer.TAXISTA && taxista.status==UStatus.DONE && !taxista.accountLocked ){
						OperationPending.findAllByTaxista(taxista).each{
							notificationService.notificateOnTripFinish(it,it.user,true)
						}
						OperationCompanyPending.findAllByTaxista(taxista).each{
							notificationService.notificateOnTripFinish(it,it.user,true)
						}
						Operation.executeUpdate("update OperationPending b set b.status=:status ,b.class=:cClass " +
								"where b.taxista.id=:id",
								[status: TRANSACTIONSTATUS.COMPLETED,cClass: OperationHistory.name, id: taxista.id])
						Operation.executeUpdate("update OperationCompanyPending b set b.status=:status ,b.class=:cClass " +
								"where b.taxista.id=:id",
								[status: TRANSACTIONSTATUS.COMPLETED,cClass: OperationCompanyHistory.name, id: taxista.id])
						oper.taxista=taxista
						oper.intermediario=intermediario
						oper.company=intermediario.employee
						oper.status=TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI
						oper.timeTravel=timeTravel

						if(!oper.save(flush:true)){
							oper.errors.each{ log.error it }
						}

						def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI)
						trackOperation.operation=oper
						trackOperation.taxista=taxista
						trackOperation.timeTravel=timeTravel
						trackOperation.save(flush:true)

						notificationService.notificateOnTripTaxiSelect(oper,oper.user,false)
						message = "100"
					}else{
						message= "210"
					}
				}else{
					message ="211"
				}
			}else{
				message= "212"
			}
		}else{
			message ="213"
		}
		return message
	}
	def reAsignTaxiByRadioTaxiApi(userInstance,oper,taxista,intermediario,supervisorRole,operatorRol,timeTravele){

		String message=""
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operatorRol) ){
			if(oper && taxista){
				if(taxista instanceof EmployUser){
					if( taxista.typeEmploy==TypeEmployer.TAXISTA && taxista.status==UStatus.DONE && !taxista.accountLocked ){
						OperationPending.findAllByTaxista(taxista).each{
							notificationService.notificateOnTripFinish(it,it.user,true)
						}
						OperationCompanyPending.findAllByTaxista(taxista).each{
							notificationService.notificateOnTripFinish(it,it.user,true)
						}
						oper.taxista=taxista
						oper.intermediario=intermediario
						oper.company=intermediario.employee
						oper.status=TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI
						oper.timeTravel=timeTravele
						oper.save(flush:true)

						def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.REASIGNTRIP)
						trackOperation.operation=oper
						trackOperation.taxista=taxista
						trackOperation.timeTravel=timeTravele
						trackOperation.save(flush:true)

						notificationService.notificateOnReAsignTripRadioTaxiSelect(oper,oper.user,false)
						message = "100"
					}else{
						message= "210"
					}
				}else{
					message ="211"
				}
			}else{
				message= "212"
			}
		}else{
			message ="213"
		}
		return message
	}
	def reAsignTaxiByRadioTaxi(userInstance,oper,taxista,intermediario,supervisorRole,operatorRol,timeTravele){

		String message=""
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operatorRol) ){
			if(oper && taxista){
				if(taxista instanceof EmployUser){
					if( taxista.typeEmploy==TypeEmployer.TAXISTA && taxista.status==UStatus.DONE && !taxista.accountLocked ){
						OperationPending.findAllByTaxista(taxista).each{
							notificationService.notificateOnTripFinish(it,it.user,true)
						}
						OperationCompanyPending.findAllByTaxista(taxista).each{
							notificationService.notificateOnTripFinish(it,it.user,true)
						}
						oper.taxista=taxista
						oper.intermediario=intermediario
						oper.company=intermediario.employee
						oper.status=TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI
						oper.timeTravel=timeTravele
						oper.save(flush:true)
						def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.REASIGNTRIP)
						trackOperation.operation=oper
						trackOperation.taxista=taxista
						trackOperation.timeTravel=timeTravele
						trackOperation.save(flush:true)
						notificationService.notificateOnTripRejectRadioTaxiSelect(oper,oper.user,false)
						message = "Se transfirio el taxi correctamente"
						message = "OK"
					}else{
						message= " no es taxista"
					}
				}else{
					message =" No tiene operadores debe agregar un operador"
				}
			}else{
				message= " no se encuentra taxista"
			}
		}else{
			message ="El usuario No puede modificar el registro"
		}
		return message
	}
}