package ar.com.goliath.corporate.billing

import java.util.Date;

import ar.com.goliath.User

class TermConfig {
	String name
	Integer days
	User rtaxi
	Date createdDate
	Date lastModifiedDate
	static constraints = {
		rtaxi nullable:false,blank:false
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
