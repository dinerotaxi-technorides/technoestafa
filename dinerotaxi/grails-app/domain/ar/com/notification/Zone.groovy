package ar.com.notification

import java.util.Date;

import ar.com.goliath.User
class Zone {
	
	User user
	String name
	String coordinates
	Date createdDate
	Date lastModifiedDate
	static constraints = {
		name(nullable:false,blank:false)
		user(nullable:false,blank:false)
		coordinates(nullable:false,blank:false, maxSize:65000)
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
	}
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	
	def beforeUpdate = { lastModifiedDate = new Date() }
}
