package ar.com.goliath.payment

import ar.com.goliath.User

class UserPayment {
	User user
	String type
	String status
	String paramsJson
	Boolean visible
	Boolean enable
	Date createdDate
	Date lastModifiedDate
	
	def beforeInsert = {  createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }
	
	static mapping = { 
		visible default: true
		enable default: true
	 }
    static constraints = {
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
		user nullable:false
		type nullable:true,blank:true
		status nullable:true,blank:true
		paramsJson nullable:true,blank:true
		
    }
}