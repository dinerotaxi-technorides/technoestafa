package ar.com.operation

import ar.com.goliath.Company
class OperationAdditionalConfig {
	Company rtaxi
	
	Date createdDate
	
	String name
	
	
	static mapping = {
	}
	static constraints = {
		createdDate(nullable: true);
	}
	def beforeInsert = {
		createdDate = new Date()
	}
	
}
