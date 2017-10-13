package ar.com.goliath.driver.charges

import ar.com.goliath.User
import ar.com.operation.Operation
class ChargesDriverHistory {
	
	String status="PENDING"
	String invoiceId
	User rtaxi
	User driver
    static hasMany = [items: ItemDetailDriver,payments: BillingDriverPayment]
	
	Date chargesDate
	Date dueDate
	Date createdDate
	
	String customerNotes
	
	Double subTotal
	Double adjustment
	Double total
	
	static mapping = {
		items cascade:"all,delete-orphan"
		payments cascade:"all,delete-orphan"
	}
	def beforeInsert = {
		createdDate = new Date()
	}
	static constraints = {
		status(nullable:false,blank:false)
		rtaxi(nullable:false,blank:false)
		driver(nullable:false,blank:false)
		invoiceId(nullable:false,blank:false)
		
		chargesDate(nullable:false,blank:false)
		dueDate(nullable:false,blank:false)
		createdDate(nullable:true,blank:true)
		customerNotes(nullable:true,blank:true,maxLength:20000)
		
		subTotal(nullable:false,blank:false)
		adjustment(nullable:true,blank:true)
		total(nullable:false,blank:false)
		
	}
}
