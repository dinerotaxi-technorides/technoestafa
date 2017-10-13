
package com

import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.joda.time.*

import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.TypeEmployer
import ar.com.goliath.driver.charges.ChargesDriverHistory
import ar.com.goliath.driver.charges.CorporateItemDetailDriver
import ar.com.goliath.driver.charges.ItemDetailDriver
import ar.com.notification.*
import ar.com.operation.*
class BillingDriverJob {
	def timeout = 1000*60*60 //cada 12 hs
	def feedService
	def notificationService
	def technoRidesBillingService
	def execute() {

		def config = ConfigurationHolder.config
		if( config.run_job){
			println "BillingDriverJob1"
			def companies  = Company.createCriteria().list() {
				eq("enabled",true)
				isNotNull("createdDate")
			}
			companies.each{Company company ->
				//Drivers Billing
				if(company?.wlconfig?.hasDriverPayment){
					print company.companyName
					try {
						technoRidesBillingService.chargeDriverPayment(company)
						    
						print company
					} catch (Exception e) {
						e.printStackTrace()
					}

				}
			}

		}

	}

}
