package com

import org.codehaus.groovy.grails.commons.ConfigurationHolder

import ar.com.goliath.*
import ar.com.operation.*
class SetHistoryOperationTripJob {
	def timeout =1000*60*24 // execute job once in 15 min
	def notificationService
	def execute() {
		
		def config = ConfigurationHolder.config
		if(config.run_job){
			Operation.withTransaction {
				def op=OperationPending.createCriteria()
				def d=new Date()
				d.setMinutes(d.minutes-1000)
				def results = op.list() {
					and{
						le('createdDate',d)
						or{
							eq('status',TRANSACTIONSTATUS.CANCELED_EMP)
							eq('status',TRANSACTIONSTATUS.COMPLETED)
							eq('status',TRANSACTIONSTATUS.CALIFICATED)
						}
					}
				}
				results.each{Operation oper->
					Operation.executeUpdate("update Operation b set b.class=:cClass where b.id=:oldTitle",
							[cClass: OperationHistory.name, oldTitle: oper.id])
				}
				def op1=OperationCompanyPending.createCriteria()
				def results1 = op1.list() {
					and{
						le('createdDate',d)
						or{
							eq('status',TRANSACTIONSTATUS.CANCELED_EMP)
							eq('status',TRANSACTIONSTATUS.COMPLETED)
							eq('status',TRANSACTIONSTATUS.CALIFICATED)
						}
					}
				}
				results1.each{Operation oper->
					Operation.executeUpdate("update Operation b set b.class=:cClass where b.id=:oldTitle",
							[cClass: OperationCompanyHistory.name, oldTitle: oper.id])
				}
	
			}
	
		}
		

	}
}
