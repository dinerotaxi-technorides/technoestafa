
package com

import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.joda.time.*

import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.TypeEmployer
import ar.com.goliath.User
import ar.com.notification.*
import ar.com.operation.*
class BillingJob {
	def timeout = 1000*60 //cada 12 hs
	def feedService
	def notificationService
	def execute() {
		
//		def config = ConfigurationHolder.config
//		String run_job= config.run_job
//		if(run_job){
//			println "BillingJob"
//			def companies  = Company.createCriteria().list() { 
//				eq("enabled",true) 
//				isNotNull("createdDate") 
//			}
//			Calendar rightNow = Calendar.getInstance();
//			companies.each{company ->
//				def usr = User.get(company.id)
//				//Technorides Billing
//				def createdDate=Calendar.getInstance();
//				createdDate.setTime(company.createdDate);
//				int diffYear = rightNow.get(Calendar.YEAR) - createdDate.get(Calendar.YEAR);
//				int diffMonth = diffYear * 12 + rightNow.get(Calendar.MONTH) - createdDate.get(Calendar.MONTH);
//				for (int x =0 ; x<= diffMonth;x++){
//					def cal1=Calendar.getInstance();
//					cal1.setTime(company.createdDate);
//					cal1.add(Calendar.MONTH, x)
//					cal1.set(Calendar.DAY_OF_MONTH, 1)
//					def billing = Billing.findByBillingDateAndUser(cal1.getTime(),company)
//					if ( !billing){
//						billing=new Billing(user:company, amount:company.price,billingDate:cal1.getTime())
//						if(!billing.save()){
//							billing.errors.each { println company }
//						}
//					}
//				}
//				//Drivers Billing
//				if(company?.wlconfig?.hasDriverPayment){
//					
//					def cal1=Calendar.getInstance();
//					def drivers = EmployUser.findAllByEmployeeAndTypeEmploy(company,TypeEmployer.TAXISTA)
//					println "comenzando a cobrar"
//					def driverTypePayment = company?.wlconfig?.driverTypePayment
//					println isDayPayment(driverTypePayment,cal1)
//					if(company?.wlconfig?.driverPayment==0 && (isMonthPayment(driverTypePayment,cal1)
//							|| isQuarterPayment(driverTypePayment,cal1)
//							|| isWeekPayment(driverTypePayment,cal1)
//							|| isDayPayment(driverTypePayment,cal1) )){
//						print "is per driver"
//						billingDriver(company,drivers)
//					}else if (company?.wlconfig?.driverPayment==1 && (isMonthPayment(driverTypePayment,cal1)
//							|| isQuarterPayment(driverTypePayment,cal1)
//							|| isWeekPayment(driverTypePayment,cal1)
//							|| isDayPayment(driverTypePayment,cal1) )){
//						print "is per porcentaje"
//						billingDriverPerPorcentage(company,drivers)
//					}
//					chargesDriver(drivers)
//				}
//			}
//		}
//		
//	}
//	boolean isMonthPayment(def driverTypePayment,def cal1){
//		return (driverTypePayment==0 && cal1.get(Calendar.DAY_OF_MONTH)==1)
//	}
//	boolean isQuarterPayment(def driverTypePayment,def cal){
//		return (driverTypePayment==1 
//				&& cal.get(GregorianCalendar.DAY_OF_MONTH)==1
//			    && cal.get(GregorianCalendar.DAY_OF_MONTH)==15)
//	}
//	boolean isWeekPayment(def driverTypePayment,def cal){
//		return (driverTypePayment==2 && cal.get(Calendar.DAY_OF_WEEK)==1)
//	}
//	boolean isDayPayment(def driverTypePayment,def cal1){
//		return (driverTypePayment==3 )
//	}
//	boolean isChargeComputable(def charge,def cal1){
//		def driverTypePayment = charge.driverPayment
//		return (isMonthPayment(driverTypePayment,cal1)
//			|| isQuarterPayment(driverTypePayment,cal1)
//			|| isWeekPayment(driverTypePayment,cal1)
//			|| isDayPayment(driverTypePayment,cal1) )
//		 
//	}
//	def chargesDriver(def drivers){
//		println "billing driver"
//		def cal1=Calendar.getInstance();
//		cal1.set(Calendar.MINUTE, 0);
//		cal1.set(Calendar.SECOND, 0);
//		cal1.set(Calendar.HOUR_OF_DAY, 0);
//		drivers.each {driver->
//			def charges = ChargesDriver.createCriteria().list() {
//				eq("enabled", true)
//				eq("user",driver)
//			// set the order and direction
//			}
//			charges.each{charge->
//				if(isChargeComputable(charge,cal1)){
//					def billing = BillingDriver.createCriteria().list() {
//						eq("user",driver)
//						eq("billingDate",cal1.getTime())
//						eq("comments",charge.description)
//						eq("typeCharge",2)
//						maxResults(1)
//					// set the order and direction
//					}
//					if ( !billing ){
//						billing=new BillingDriver(user:driver, amount:charge.amount,comments:charge.description,billingDate:cal1.getTime(),typeCharge:2,visible:true)
//						if(!billing.save()){
//							billing.errors.each {
//								println it
//							}
//						}
//					}
//				}
//				
//			}
//			
//		}
	}
	def billingDriver(def company, def drivers){
		println "billing driver"
		drivers.each {driver->
			def cal1=Calendar.getInstance();
			cal1.set(Calendar.MINUTE, 0);
			cal1.set(Calendar.SECOND, 0);
			cal1.set(Calendar.HOUR_OF_DAY, 0);
			
			def billing = BillingDriver.findByBillingDateAndUserAndTypeCharge(cal1.getTime(),driver,1)
			if ( !billing){
				billing=new BillingDriver(user:driver, amount:company?.wlconfig.driverAmountPayment,billingDate:cal1.getTime(),typeCharge:1)
				if(!billing.save()){
					billing.errors.each {
						println it
					}
				}
			}
		}
	}
	private Calendar getDateFromPerPorcentage(def driverPayment){
		def dateFrom=Calendar.getInstance();
		if(driverPayment==0){
			dateFrom.add(Calendar.MONTH, -1)
		}else if(driverPayment==1){
			dateFrom.add(Calendar.DAY_OF_MONTH, -15)
		}else if(driverPayment==2){
			dateFrom.add(Calendar.DAY_OF_MONTH, -7)
		}else if(driverPayment==3){
			dateFrom.add(Calendar.DAY_OF_MONTH, -1)
		}
		return dateFrom
	}
	def billingDriverPerPorcentage(def company, def drivers){
		println "billing driver porcentaje"
		def cal1=Calendar.getInstance();
		cal1.set(Calendar.MINUTE, 0);
		cal1.set(Calendar.SECOND, 0);
		cal1.set(Calendar.HOUR_OF_DAY, 0);
		drivers.each {driver->
			def dateTo=Calendar.getInstance();
			def dateFrom=getDateFromPerPorcentage(company?.wlconfig?.driverPayment )
			def operationCharges = Operation.createCriteria().list() {
				eq("taxista",driver)
				between ("createdDate", dateFrom.getTime(),dateTo.getTime())
				projections { sum('amount')
				}
			// set the order and direction
			}
			def billing = BillingDriver.findByBillingDateAndUserAndTypeCharge(cal1.getTime(),driver,1)
			if ( !billing ){
				
				def amountOperation =operationCharges.get(0)!=null?(operationCharges.get(0)/100*company?.wlconfig.driverAmountPayment):0d
				billing=new BillingDriver(user:driver, amount:amountOperation,billingDate:cal1.getTime(),typeCharge:1)
				if(!billing.save()){
					billing.errors.each {
						println it
					}
				}
			}
		}
	}
}
