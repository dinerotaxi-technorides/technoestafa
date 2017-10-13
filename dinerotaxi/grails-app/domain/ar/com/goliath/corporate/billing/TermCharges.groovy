package ar.com.goliath.corporate.billing

import java.util.Date;

import ar.com.goliath.User

class TermCharges {
	String name
	Integer days
	Date createdDate
	Date lastModifiedDate
	TermConfig config
	static constraints = {
		name nullable:false,blank:false
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
	}
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	
	def beforeUpdate = { lastModifiedDate = new Date() }
}
