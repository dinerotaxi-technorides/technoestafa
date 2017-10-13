package com.api.technorides

import ar.com.goliath.EmployUser
import ar.com.goliath.driver.charges.BillingDriverPayment
import ar.com.goliath.driver.charges.ChargesDriverHistory
import ar.com.goliath.driver.charges.CorporateItemDetailDriver

class TechnoRidesDriverInvoiceService {
	//la empresa cobra por el servicio de radiotaxi
	def chargeInvoices(def driver_id, def usr, def rtaxi){
		def driver = EmployUser.get(driver_id)
		if(!usr || !driver || driver.rtaxi != rtaxi){
			return 411
		}
		def customers = ChargesDriverHistory.createCriteria().list() {
			eq('driver',driver)
			ne('status','PAID')
			gt('total',0d)
		}
		customers.each {
			def billingPayment = new BillingDriverPayment()
			billingPayment.amount = it.total
			billingPayment.paymentDate =  new Date()
			billingPayment.paymentMode = 1
			billingPayment.sendEmail   = false
			if(!billingPayment.save()){
				billingPayment.errors.each {
					print it
				}
			}else{
				billingPayment.errors.each {
					print it
				}
				def hi = ChargesDriverHistory.get(it.id)
				print it
				hi.refresh()
				hi.total = 0
				hi.status = 'PAID'
				hi.addToPayments(billingPayment)
				if(!hi.save()){
					hi.errors.each {
						print it
					}
				}
			}
			
		}
		return 200
	}
	//La empresa paga por las cc
	def payRecipents(def driver_id, def usr, def rtaxi){
		def driver = EmployUser.get(driver_id)
		if(!usr || !driver || driver.rtaxi != rtaxi){
			return 411
		}
		def customers = CorporateItemDetailDriver.createCriteria().list() {
			eq('driver',driver)
			ne('status','PAID')
		}
		customers.each {
			print it
			it.total = 0
			it.status = 'PAID'
			it.save()
		}
		return 200
	}
	def driverPay(def driver_id, def usr, def rtaxi){
		def driver = EmployUser.get(driver_id)
		if(!usr || !driver || driver.rtaxi != rtaxi){
			return 411
		}
		
		def owned = CorporateItemDetailDriver.findAllByDriverAndStatusNotEqual(driver,'PAID')
		def owns  = ChargesDriverHistory.findAllByDriverAndStatusNotEqual(driver,'PAID')
		def total_owned = owned?owned.total.sum():0d
		def total_owns  = owns?owns.total.sum():0d
		if(total_owned<total_owns){
			return 403
		}
		def stat = chargeInvoices(driver_id,usr,rtaxi)
		if(stat!=200){
			return stat
		}
		
		def customers = CorporateItemDetailDriver.createCriteria().list() {
			eq('driver',driver)
			ne('status','PAID')
			order("id", "asc")
		}
		
		customers.each {
			print owns
			print it.total
			if(it.total >total_owns){
				it.total = it.total-total_owns
				it.status = 'OVERDUE'
				it.save()
				return
				
			}else if(it.total< total_owns){
				owns = total_owns -it.total
				it.total = 0
				it.status = 'PAID'
				it.save()
			}else{
				it.total = 0
				it.status = 'PAID'
				it.save()
				return
			}
			print it
		}
		return 200
		
	}
}
