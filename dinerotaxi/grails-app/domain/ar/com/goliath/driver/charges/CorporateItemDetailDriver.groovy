package ar.com.goliath.driver.charges

import java.util.Date;

import ar.com.goliath.User
import ar.com.operation.Operation

class CorporateItemDetailDriver {
	Operation operation
	User rtaxi
	User driver
	//1 % 2 flat_fee
	Integer discountType
	Double discount
	Date chargesDate
	Date paidDate
	Date createdDate
	String status
	Double subTotal
	Double adjustment
	Double total
	def beforeInsert = {
		createdDate = new Date()
		subTotal    = total
	}
	static constraints = {
		status     nullable:false,blank:false
		operation     nullable:false,blank:false
		rtaxi         nullable:false,blank:false
		driver        nullable:false,blank:false
		discountType nullable:true,blank:true
		discount   nullable:true,blank:true,maxLength:10000
		adjustment nullable:true,blank:true
		paidDate   nullable:true,blank:true
		createdDate   nullable:true,blank:true
		subTotal   nullable:true,blank:true
		total     nullable:false,blank:false
		
	}
}