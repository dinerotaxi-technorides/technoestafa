package com
import org.codehaus.groovy.grails.commons.ConfigurationHolder

import uk.co.desirableobjects.sendgrid.SendGridEmail
import uk.co.desirableobjects.sendgrid.SendGridEmailBuilder
import ar.com.goliath.Company
import ar.com.goliath.TechnoRidesMailQueue
import ar.com.goliath.User
import ar.com.operation.TRANSACTIONSTATUS

import com.*
class TechnoRidesEmailMarketingJob {
	def timeout = 1000*60 // execute job once in 1 hour
	def sendGridService

	def execute() {

//			log.error "execute:TechnoRidesEmailMarketingJob"
			// execute task

		def config = ConfigurationHolder.config
		String run_job= config.run_job
		if(config.run_job){
			def results = TechnoRidesMailQueue.findAllByStatus(TRANSACTIONSTATUS.PENDING)

			results.each{TechnoRidesMailQueue mailQueue->
				def rtaxi=Company.get(mailQueue.from.id)
				def usr=User.get(mailQueue.to.id)
				def firstName=usr?.firstName?:''
				SendGridEmail email = new SendGridEmailBuilder()
				.from(rtaxi?.companyName,mailQueue.from?.email)
				.to(firstName,mailQueue.to?.email)
				.subject(mailQueue.subject).withHtml(mailQueue.body).build()
				try{
					sendGridService.send(email)
					mailQueue.status = TRANSACTIONSTATUS.COMPLETED
					mailQueue.save(flush:true);
				}catch (Exception e){
					print e
					mailQueue.status = TRANSACTIONSTATUS.COMPLETED
					mailQueue.save(flush:true);

				}
			}

		}


	}
}
