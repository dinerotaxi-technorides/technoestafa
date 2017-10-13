package ar.com.goliath.driver.charges

import ar.com.goliath.EmployUser

class PrePaidDriverPayment {
	Double amount
	Double amountUnused
	EmployUser driver
	String status
	Date paymentDate
	String paymentMode
	String reference
	String notes
	static constraints = {
		amount     nullable:false,blank:false
		paymentDate   nullable:true,blank:true
		paymentMode     nullable:false,blank:false
		reference  nullable:true,blank:true
		notes  nullable:true,blank:true
		
	}
}