package com

import java.util.Date;

class Category {
	static hasMany = [product:Product]
	String name
	String description
	Boolean active
	
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = {
		createdDate = new Date()
	}
	def beforeUpdate = {
		lastModifiedDate = new Date()
	}
    static constraints = {
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		name (nullable:false,blank:false,minSize:5)
		description (nullable:false,blank:false,minSize:5)
    }
	String toString(){
		return name
	}
}
