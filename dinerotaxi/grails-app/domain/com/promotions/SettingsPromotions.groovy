package com.promotions

import java.util.Date;

class SettingsPromotions {
	static constraints = {
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		name(nullable:true,blank:true)
		codeQr(nullable:true,blank:true)
		discount(nullable:true,blank:true)
		startDate(nullable:true,blank:true)
		finishDate(nullable:true,blank:true)
	}
	String name
	String codeQr
	Double discount
	Date startDate
	Date finishDate
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }
}
