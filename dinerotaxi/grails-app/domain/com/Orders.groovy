package com

import ar.com.goliath.User;
import com.Device
import com.OrderDetails
import com.Payment
class Orders {
	static hasMany = [orderDetails:OrderDetails]
	User user
	Device device
	Payment paymentMethod
	Shippers shipper
	Double total
	String errLoc
	String errMsg
	Boolean deleted
	Date orderDate
	Date shipDate
	Date salesTax
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
		shipper(nullable:true,blank:true)
		orderDate(nullable:true,blank:true)
		shipDate(nullable:true,blank:true)
		salesTax(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		errLoc(nullable:true,blank:true)
		errMsg(nullable:true,blank:true)
		total(nullable:true,blank:true)
		user(nullable:true,blank:true)
		paymentMethod(nullable:true,blank:true)
    }
}
