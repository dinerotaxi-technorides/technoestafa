package com

import java.util.Date;

class OrderDetails {
	static belongsTo = [ Orders, Catalog ]
	static hasMany = [catalog:com.Catalog ]
	Orders orders
	Product product
	Double price
	Integer quantity
	Boolean discount
	Date shipDate
	Date bilDate
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = {
		createdDate = new Date()
	}
	def beforeUpdate = {
		lastModifiedDate = new Date()
	}
    static constraints = {
		orders(nullable:true,blank:true)
		catalog(nullable:true,blank:true)
		shipDate(nullable:true,blank:true)
		bilDate(nullable:true,blank:true)
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		price(nullable:true,blank:true)
		quantity(nullable:true,blank:true)
    }
	
	String toString(){
		return product.name
	}
}
