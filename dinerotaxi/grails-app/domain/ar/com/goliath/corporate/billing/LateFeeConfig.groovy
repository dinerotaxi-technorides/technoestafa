package ar.com.goliath.corporate.billing

import java.util.Date;

import ar.com.goliath.User

class LateFeeConfig {
	User rtaxi
	String name
	Double charge
	//1 day 2 week 3 fortnight 4 month
	Integer frequency
	//1 % 2 flat_fee
	Integer typeCharge
	Date createdDate
	Date lastModifiedDate
	static constraints = {
		rtaxi nullable:false,blank:false
		name nullable:false,blank:false
		charge nullable:false,blank:false
		name nullable:false,blank:false
		frequency nullable:false,blank:false
		typeCharge nullable:false,blank:false
		
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
	}
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	
	def beforeUpdate = { lastModifiedDate = new Date() }
}
