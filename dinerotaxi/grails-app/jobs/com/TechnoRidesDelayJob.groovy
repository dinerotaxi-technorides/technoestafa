package com
import groovyx.net.http.RESTClient

import java.text.SimpleDateFormat

import org.codehaus.groovy.grails.commons.ConfigurationHolder

import ar.com.goliath.Company
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.DelayOperation
import ar.com.operation.OperationCompanyPending
import ar.com.operation.OperationPending
import ar.com.operation.TRANSACTIONSTATUS

import com.*
class TechnoRidesDelayJob {
	def timeout = 1000*10 // execute job once in 1 hour
	def technoRidesEmailService
	def operationApiService
	def execute() {

		def config = ConfigurationHolder.config
		if(config.run_job){
			println "TechnoRidesDelayJob"
			int countError=0
			DelayOperation.withTransaction {
				def op=DelayOperation.createCriteria()
				Calendar dateTo = Calendar.getInstance();
				dateTo.add(Calendar.MINUTE, 300);
				Calendar dateFrom = Calendar.getInstance();
				dateFrom.add(Calendar.MINUTE, -10);
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				def results = op.list() {
					and{
						between('executionTime',dateFrom.getTime(),dateTo.getTime())
						eq('status',TRANSACTIONSTATUS.PENDING)
					}
				}
				Calendar dateToFixed = Calendar.getInstance();
				results.each{DelayOperation delay->
					def executionTime = DateToCalendar(delay.executionTime).getTime()
					delay.lock()
					def company = Company.get(delay?.user?.rtaxi?.id)
					Date dateToCheck = null
					if(delay?.timeDelayExecution){
						dateToCheck = addMinutesToDate(delay?.timeDelayExecution, dateToFixed.getTime())
						println "-----TechnoRidesDelayJob------"
						print delay?.timeDelayExecution
						print dateToCheck
						print executionTime
						println "-----------"
					}else if (company?.wlconfig?.timeDelayTrip){
						dateToCheck = addMinutesToDate(company?.wlconfig?.timeDelayTrip, dateToFixed.getTime())
					}else{
						dateToCheck = addMinutesToDate(10, dateToFixed.getTime())
					}
					if(dateToCheck.after(executionTime)){
						if(!delay?.operation){
							def oper=null
							def user = delay.user
							def options = delay.options
							def dev = delay.dev
							def favorites = delay.favorites
							if(delay.isCompanyAccount){
								oper=new OperationCompanyPending()
							}else{
								oper=new OperationPending()
							}
							oper.user=user
							oper.favorites=favorites
							oper.isTestUser=delay.isTestUser
							oper.paymentReference=delay.paymentReference
							oper.driverNumber=delay.driverNumber
							oper.amount=delay.amount
							oper.businessModel = delay.businessModel
							oper.costCenter = delay.costCenter
							oper.corporate  = delay.corporate
							oper.dev     = dev
							oper.options = options
							oper.company = company

							oper.intermediario = delay.intermediario
							oper.isCompanyAccount  = false
							oper.isDelayOperation  = true
							oper.sendToSocket  = true
							oper.createdByOperator = delay.createdByOperator
							oper.isCompanyAccount  = delay.isCompanyAccount
							oper.ip  = delay.ip

							if(!oper.hasErrors() && oper.save(failOnError:true,insert:true,flush:true) ) {
								delay.status =TRANSACTIONSTATUS.COMPLETED
								delay.executedTime = new Date()
								delay.operation = oper
								delay.save()
								boolean sentToSocket = operationApiService.sendToSocket(oper,true,delay.createdByOperator)
								oper.sendToSocket = sentToSocket
								oper.save()
							}else{
								def errors=oper.errors.collect{
									it
								}

								oper.errors.each{
									print it
								}
								technoRidesEmailService.buildBug("ERROR CANT SAVE OPERATION"+errors,"TechnoRidesDelayJob")
							}
						}

					}
				}
			}
		}

	}
	public static Calendar DateToCalendar(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		return cal;
	  }
	private static Date addMinutesToDate(int minutes, Date beforeTime){
		final long ONE_MINUTE_IN_MILLIS = 60000;//millisecs

		long curTimeInMs = beforeTime.getTime();
		Date afterAddingMins = new Date(curTimeInMs + (minutes * ONE_MINUTE_IN_MILLIS));
		return afterAddingMins;
	}

}
