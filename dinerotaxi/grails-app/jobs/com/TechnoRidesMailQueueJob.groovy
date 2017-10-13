package com
import java.text.SimpleDateFormat

import org.codehaus.groovy.grails.commons.ConfigurationHolder

import uk.co.desirableobjects.sendgrid.SendGridEmail
import uk.co.desirableobjects.sendgrid.SendGridEmailBuilder
import ar.com.goliath.MailQueue
import ar.com.goliath.MailQueueStatus

import com.*
class TechnoRidesMailQueueJob {
	def timeout = 1000*60 // execute job once in 1 hour
	def sendGridService
	
	def execute() {
		
		def config = ConfigurationHolder.config
		String run_job= config.run_job
		if(config.run_job){
			def op=MailQueue.createCriteria()
			Calendar dateTo = Calendar.getInstance();
			Calendar dateFrom = Calendar.getInstance();
			dateFrom.add(Calendar.MINUTE, -10);
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			def results = op.list() {
				and{
					between('dateCreated',dateFrom.getTime(),dateTo.getTime())
					or{
						eq('status', MailQueueStatus.FAILED)
						eq('status', MailQueueStatus.PENDING)
					}
				}
			}
			results.each{MailQueue queue->
				queue.lock()
				try{
					SendGridEmail email = new SendGridEmailBuilder()
					.from(queue.from)
					.to(queue.to)
					.subject(queue.subject).withHtml(queue.body).build()
					sendGridService.send(email)
					queue.status=MailQueueStatus.SENT
					queue.save(flush:true)
				}catch (Exception e){
					queue.status=MailQueueStatus.FAILED
					queue.save(flush:true)
				
				}
			}
		}
	}
}
