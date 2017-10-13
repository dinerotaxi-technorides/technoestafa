package ar.com.goliath.corporate.billing

import ar.com.operation.Operation

class ItemDetailEnterprise {
	String name
	Integer quantity = 1
	Operation operation
	//1 % 2 flat_fee
	Integer discountType
	Double discount
	
	Double amount
	static mapping = {
		taxCharge cascade:"all,delete-orphan"
	}
	//1 day 2 week 3 fortnight 4 month
	TaxCharges taxCharge
	static constraints = {
		name nullable:false,blank:false
		quantity     nullable:false,blank:false
		operation     nullable:false,blank:false
		discountType nullable:true,blank:true
		discount   nullable:true,blank:true,maxLength:10000
		amount     nullable:false,blank:false
		taxCharge  nullable:true,blank:true
		
	}
}