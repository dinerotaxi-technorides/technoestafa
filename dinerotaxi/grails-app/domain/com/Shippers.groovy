package com

class Shippers {
	String name
	String phone
	String phone1
	String phone2
	Float x 
	Float y
	
	Boolean active
	
    static constraints = {
		
		name(nullable:false,blank:false,maxSize:50)
		phone(nullable:false,blank:false,maxSize:50)
		phone1(nullable:true,blank:true)
		phone2(nullable:true,blank:true)
		x(nullable:false,blank:false)
		y(nullable:false,blank:false)
		
    }
	
	String toString(){
		return name
	}
}
