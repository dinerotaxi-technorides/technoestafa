package ar.com.goliath

class Place_i18n {

    String lang = "es"
    String name

    String country
    String countryCode

    String admin1Code
    String admin2Code
    String admin3Code

    String locality
    String street

    static constraints = {
      lang (nullable:false, maxSize:10)
      name (nullable:false, maxSize:200)
        
      country (nullable:true, maxSize:200)
      countryCode (nullable:true, maxSize:3)
	    
	    admin1Code (nullable:true, maxSize:200)
	    admin2Code (nullable:true, maxSize:200)
	    admin3Code (nullable:true, maxSize:200)

	    locality (nullable:true, maxSize:200)
	    street (nullable:true, maxSize:200)
    }
    
    static belongsTo = [ place : Place ]
}

