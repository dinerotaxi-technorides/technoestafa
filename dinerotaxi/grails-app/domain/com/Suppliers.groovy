package com

class Suppliers {
	String companyName
	String firstContact
	String contactName
	String contactTitle
	String address1
	String address2
	String city
	String state
	Integer postalCode
	String country
	String phone
	String fax
	String email
	String paymentMethods
	String notes
	Boolean discountAvaible
	String currentOrder
	Byte  [] logo
	
    static constraints = {
    }
	
	String toString(){
		return companyName +" | "+firstContact
	}
}
