package com
import org.codehaus.groovy.grails.commons.ConfigurationHolder

import com.*
class SpamJob {
	def timeout = 1000*60 // execute job once in 1 hour
	def notificationService
	
	def execute() {
		
		def config = ConfigurationHolder.config
		String run_job= config.run_job
		if(config.run_job){
			Spam.withTransaction {
				log.debug "execute:spamJob"
				// execute task
				def op = Spam.createCriteria()
				def results = op.list() {
					and{ eq('hadRuning',false) }
				}
				results.each{Spam spam->
	
					if(spam.dev==UserDevice.ANDROID ||spam.dev==UserDevice.IPHONE ){
						def ddev=Device.findAllByDev(spam.dev)
						ddev.each{Device dev->
	
							notificationService.notificateSpam(spam.msj,dev)
							def spamu=new SpamUser(user:dev.user,spam:spam)
							spamu.save(flus:true)
						}
						spam.hadRuning=true
						spam.save(flush:true)
					}else{
	
					}
	
				}
			}
		}
	}
}
