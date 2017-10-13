package com

import java.util.Date;
import com.Catalog
class Product {
	static belongsTo = [Catalog]   
	static hasMany = [catalog:Catalog]
	Category category
	String name
	String description
	Integer quantityPerUnit
	Double unitPrice
	Double discount
	Integer unitStock
	Boolean productAvailable
	Boolean discountAvailble
	Integer ranking
	String note
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
		catalog(nullable:true,blank:true)
		name (nullable:false,blank:false,minSize:5)
		description (nullable:false,blank:false,minSize:5)
		quantityPerUnit(nullable:false,blank:false,min:1)
		unitPrice(nullable:false,blank:false)
		discount(nullable:true,blank:true)
		unitStock(nullable:true,blank:true)
		ranking(nullable:true,blank:true)
    }
	String toString(){
		return name
	}
}
