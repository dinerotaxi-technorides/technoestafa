package ar.com.goliath.driver.charges

import ar.com.operation.Operation

class ItemDetailDriver {
	String name
	Integer quantity = 1
	Operation operation
	//1 % 2 flat_fee
	Integer discountType
	Double discount
	
	Double amount
	static constraints = {
		name nullable:false,blank:false
		quantity     nullable:false,blank:false
		operation     nullable:false,blank:false
		discountType nullable:true,blank:true
		discount   nullable:true,blank:true,maxLength:10000
		amount     nullable:false,blank:false
		
	}
}