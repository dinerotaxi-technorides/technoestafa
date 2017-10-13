package ar.com.notification

import java.math.BigDecimal;
import java.util.Date;

import ar.com.goliath.User
class ZonePricing {
	User user
	Zone zoneFrom
	Zone zoneTo
	BigDecimal amount=0d
	Date createdDate
	Date lastModifiedDate
	static constraints = {
		zoneFrom(nullable:false,blank:false)
		zoneTo(nullable:false,blank:false)
		amount(nullable:false,blank:false)
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
	}
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	
	def beforeUpdate = { lastModifiedDate = new Date() }
}
