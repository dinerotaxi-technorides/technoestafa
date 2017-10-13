package com

import org.codehaus.groovy.grails.commons.ConfigurationHolder

import ar.com.goliath.*
import ar.com.operation.*
class CancelTimeOnlineNotificationJob {
	def timeout = 1000*60*10 // execute job once in 10 min
	def notificationService
	
	def technoRidesReportService
	/**
	 * Cancela los pedidos encolados 
	 * @return
	 */
	def execute() {
		print "execute:CancelTimeOnlineNotificationJob"
		def config = ConfigurationHolder.config
		if(config.run_job){
			def operations=technoRidesReportService.getInconsistentOperations()
			for(oper in operations){
				if (oper[1] != null) {
					Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id= :id_op",
						[cClass: OperationCompanyHistory.name, id_op: oper[0],status:TRANSACTIONSTATUS.CANCELED])
				}else{
				
					Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:id_op",
							[cClass: OperationHistory.name, id_op: oper[0],status:TRANSACTIONSTATUS.CANCELED])
				}  
			}
				
			 
		}  
	}
}
