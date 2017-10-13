package ar.com.operation

import java.util.Date;

import ar.com.goliath.EmployUser;
import ar.com.goliath.User
class TripQueueCandidate {
	
	double lat
	double lng
	
	Operation operation
	EmployUser driver 
	Integer timeToDestination
	Double distance 
	
	Date createdDate
	Date lastModifiedDate
	
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	String status
	def beforeUpdate = { lastModifiedDate = new Date() }
	
	
	static constraints = {
		
		operation(nullable: false);
		driver(nullable: false);
	}
	static mapping = {
		lat default:0
		lng default:0
		timeToDestination default:0
		distance default:0
	}
}