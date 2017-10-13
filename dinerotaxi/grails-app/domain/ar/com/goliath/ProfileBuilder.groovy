package ar.com.goliath

class ProfileBuilder {
    
    String name
    String value
    
    static constraints = {
        name (nullable:false, maxSize:255)
        value (nullable:false, maxSize:2000)
    }
}

