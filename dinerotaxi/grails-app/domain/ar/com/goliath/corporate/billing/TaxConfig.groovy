package ar.com.goliath.corporate.billing

import java.util.Date;

import ar.com.goliath.User

class TaxConfig {
	String name
	//1 % 
	Double charge
	User rtaxi
	boolean isCompound = false
	Date createdDate
	Date lastModifiedDate
	static constraints = {
		rtaxi nullable:false,blank:false
		name nullable:false,blank:false
		charge nullable:false,blank:false
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
	}
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	
	def beforeUpdate = { lastModifiedDate = new Date() }
}
