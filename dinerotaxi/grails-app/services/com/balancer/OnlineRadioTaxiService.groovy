package com.balancer
import ar.com.goliath.EmployUser
import ar.com.goliath.TypeEmployer
import ar.com.operation.*
class OnlineRadioTaxiService {

	boolean transactional = true

	def getRadioTaxi(rtaxi){
		def onlineRtaxi=OnlineRadioTaxi.findByCompany(rtaxi)
		if(onlineRtaxi!=null){
			switch( onlineRtaxi.status){
				case OFStatus.OFFLINE:
					def onlineTaxis=OnlineDriver.countByCompanyAndStatus(onlineRtaxi.company,FStatus.ONLINE)
					if(onlineTaxis>0){
						onlineRtaxi.status=OFStatus.ONLINE
						onlineRtaxi.save(flush:true)
					}
				break;
			}
		}else{
			def countTaxi=EmployUser.countByEmployeeAndTypeEmploy(rtaxi,TypeEmployer.TAXISTA)
			def operatorTaxi=EmployUser.findByEmployeeAndTypeEmploy(rtaxi,TypeEmployer.OPERADOR)
			def onlineRtaxis=new OnlineRadioTaxi(status:OFStatus.ONLINE,company:rtaxi,position:0l,penality:0l,countTaxi:countTaxi,countTrips:1,tripSucess:0l,
				tripCalification:0l,tripFail:0l,timeEffort:0l,countRejectTrip:0l,operator:operatorTaxi,isTestUser:false).save(flash:true)
			onlineRtaxi=onlineRtaxis;
		}
		return onlineRtaxi
		
	}
}
