package ar.com.goliath

class EmailBuilder {
    User user
	String name
    String lang='es'
    String subject
    String body
	static hasMany = [paramsBuilder: EmailParamsBuilder]
	boolean isEnabled=true
	
    Date dateCreated
    Date lastUpdated
    
    static mapping = {
		body type: 'text'
    }
    
    static constraints = {
        lang (nullable:false, maxSize:255)
		user(nullable:true)
        subject (nullable:false, maxSize:255)
        name (nullable:false, maxSize:255)
        body (nullable:false)
    }
}

