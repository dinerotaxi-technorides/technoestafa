package ar.com.operation

import ar.com.goliath.User
class BillingDriver {
	
	User user
	boolean hadpaid=false
	boolean visible=true
	BigDecimal amount
	String comments
	Integer typeCharge
	String recive
	Date billingDate
	static constraints = {
		comments(nullable:true,blank:true)
		typeCharge(nullable:true,blank:true)
		recive(nullable:true,blank:true)
	}
}
