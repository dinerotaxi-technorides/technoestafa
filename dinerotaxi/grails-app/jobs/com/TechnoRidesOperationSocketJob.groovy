package com
import grails.converters.JSON
import groovyx.net.http.RESTClient

import org.codehaus.groovy.grails.commons.ConfigurationHolder

import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.Operation
import ar.com.operation.TRANSACTIONSTATUS

import com.*
class TechnoRidesOperationSocketJob {
	def timeout = 1000*3 // execute job once in 1 hour
	def technoRidesEmailService
	def operationApiService
	def execute() {
		int countError=0
		def config = ConfigurationHolder.config
		String run_job= config.run_job
		if(config.run_job && config.restCreateTrip){
			println "TechnoRidesOperationSocketJob"
			Operation.withTransaction {
				def op=Operation.createCriteria()
				Calendar dateTo = Calendar.getInstance();
				dateTo.add(Calendar.MINUTE, 10);
				Calendar dateFrom = Calendar.getInstance();
				dateFrom.add(Calendar.MINUTE, -110);
				def results = op.list() {
					and{
						between('createdDate',dateFrom.getTime(),dateTo.getTime())
						eq('status',TRANSACTIONSTATUS.PENDING)
						eq('sendToSocket',false)
						eq('isDelayOperation',false)
					}
				}
				results.each{Operation delay->
					delay.lock()
					print "DISPATCHING OPERATION SOCKET"
					println delay as JSON
					boolean canSendToSocket = operationApiService.sendToSocket(delay)

					delay.sendToSocket=canSendToSocket
					delay.save(flush:true)
					if(!canSendToSocket){
						countError++;
					}
				}
			}
			if(countError>0)
				technoRidesEmailService.buildBug("ERROR SOCKET DONT WORK","TechnoRidesOperationSocketJob:"+countError)
		}
	}
}
