package ar.com.goliath.payment

import ar.com.goliath.User

class BillingPayment {
	Double amount
	UserPayment paymentMode
	String status
	String responseJson
	Boolean sendEmail
	Date paymentDate
	Boolean visible
	Date createdDate
	Date lastModifiedDate
	
	def beforeInsert = {  createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }
	
	static mapping = { 
		visible default: true
	 }
    static constraints = {
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
		status nullable:true,blank:true
		
    }
}