package ar.com.operation;

import java.util.Date;

import ar.com.goliath.User;

class DelayOperationConfigTime {
	User rtaxi
	String name
	Integer timeDelayExecution
	
	Date createdDate
	Date lastModifiedDate
	static constraints = {
		rtaxi nullable:false,blank:false
		
		name nullable:false,blank:false
		timeDelayExecution nullable:false,blank:false
		
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
	}
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	
	def beforeUpdate = { lastModifiedDate = new Date() }
}
