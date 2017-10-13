package net.dbws.tutorials

class Customer {
    static constraints = {
      firstName(blank:false,maxSize:50)
      lastName(blank:false,maxSize:50)
      age(nullable:true)
      emailAddress(nullable:true)
      other(nullable:true)
    }
	Customer other
    String firstName
    String lastName
    Integer age
    String emailAddress
}
