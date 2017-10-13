package com.promotions

import java.util.Date;

import com.UserDevice;

class Promotions {
	static constraints = {
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		dev(nullable:true,blank:true)
		setting(nullable:false,blank:false)
	}
	SettingsPromotions setting
	UserDevice dev
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }
}
