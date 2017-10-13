package ar.com.goliath

import ar.com.operation.TRANSACTIONSTATUS;

class TechnoRidesMailQueue {
    
    User to
    User from
	EmailBuilder emailBuilder
    String body
    String subject
    Date dateCreated
    Date lastUpdated
	TRANSACTIONSTATUS status=TRANSACTIONSTATUS.PENDING
    
   
    static mapping = {
		body type: 'text'
    }
    
    
    static constraints = {
        to (nullable:false, maxSize:255)
        from (nullable:false, maxSize:255)
        emailBuilder (nullable:false)
    }
}


