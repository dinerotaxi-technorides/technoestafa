package ar.com.operation

import java.util.Date;

import ar.com.goliath.User
class CreditCardInformation {

	User user
	boolean enabled=true
	String cardToken
	String cardType
	String cardNumber
	String cardHolder
	String cvc
	String expirationDate

	Date createdDate=new Date()
	
	static constraints = {
		user(nullable:false,blank:false)
		enabled(nullable:false,blank:false)
		cardToken(nullable:false,blank:false)
		cardType(nullable:false,blank:false)
		cardNumber(nullable:false,blank:false)
		cardHolder(nullable:false,blank:false)
		cvc(nullable:false,blank:false)
		expirationDate(nullable:false,blank:false)
		createdDate(nullable:false,blank:false)
	}

	def beforeInsert() {
		createdDate = new Date()
	}
}
