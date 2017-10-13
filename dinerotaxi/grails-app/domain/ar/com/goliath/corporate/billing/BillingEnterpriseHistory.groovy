package ar.com.goliath.corporate.billing

import ar.com.goliath.User
import ar.com.goliath.corporate.CostCenter
class BillingEnterpriseHistory {
	
	CostCenter costCenter
	String status="PENDING"
	String invoiceId
	
	LateFeeCharges lateFee
	TermCharges termCharges
    static hasMany = [items: ItemDetailEnterprise,payments: BillingPayments,emailTo: User]
	
	Date billingDate
	Date dueDate
	
	Date createdDate
	
	String customerNotes
	
	Double subTotal
	Double adjustment
	Double total
	Double discount
	Double discountPercentage
	
	static mapping = {
		items cascade:"all,delete-orphan"
		discount default: 0d
		discountPorcentage default: 0d
	}
	def beforeInsert = {
		createdDate = new Date()
	}
	static constraints = {
		costCenter(nullable:false,blank:false)
		status(nullable:false,blank:false)
		invoiceId(nullable:false,blank:false)
		
		billingDate(nullable:false,blank:false)
		dueDate(nullable:false,blank:false)
		createdDate(nullable:true,blank:true)
		lateFee(nullable:true,blank:true)
		termCharges(nullable:true,blank:true)
		emailTo(nullable:true,blank:true,email:true)
		customerNotes(nullable:true,blank:true,maxLength:20000)
		
		subTotal(nullable:false,blank:false)
		adjustment(nullable:true,blank:true)
		total(nullable:false,blank:false)
		
	}
}
