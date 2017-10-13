package com

import ar.com.goliath.*
class SpamUser {
	
	Spam spam
	User user;
	Date createdDate;
	def beforeInsert = { createdDate = new Date() }
	static constraints = {
		createdDate(nullable:true,blank:true)
	}
}