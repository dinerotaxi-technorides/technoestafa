package ar.com.operation

import java.util.Date;

import ar.com.goliath.User
class ChargesDriver {
	
	User user
	boolean enabled=true
	BigDecimal amount
	String description
	Date expirationDate
	Integer driverPayment=0
	//0 mensual 1 quicena 2 semana 3 diario
	Date createdDate=new Date()
	
	static constraints = {
		description(nullable:true,blank:true)
		expirationDate nullable:true,blank:true
	}
	
	def beforeInsert() {
		createdDate = new Date()
	}
}
