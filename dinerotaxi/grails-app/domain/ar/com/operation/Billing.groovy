package ar.com.operation

import ar.com.goliath.User
class Billing {
	
	User user
	boolean hadpaid=false
	BigDecimal amount
	String comments
	String recive
	Date billingDate
	static constraints = {
		comments(nullable:true,blank:true)
		recive(nullable:true,blank:true)
	}
}
