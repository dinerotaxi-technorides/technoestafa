package com;

import java.util.Date

import ar.com.goliath.EmployUser;
import ar.com.operation.Operation


class Calification {
	Integer stars;
	Operation operation
	EmployUser taxista
	String comments
	
	Date createdDate
	Date lastModifiedDate
	
	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }

	static constraints = {
		stars(nullable:false,blank:false)
		operation(nullable:false,blank:false)
		taxista(nullable:true,blank:true)
		comments(nullable:true,blank:true)
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
	}
}