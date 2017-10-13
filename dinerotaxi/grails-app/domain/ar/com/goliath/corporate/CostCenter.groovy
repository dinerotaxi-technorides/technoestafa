package ar.com.goliath.corporate

import java.util.Date;

import ar.com.goliath.User;

class CostCenter {
	String name
	String phone
	String legalAddress
	Integer invoicePeriod = 1
	Corporate corporate
	User rtaxi
	boolean visible
	static mapping = {
		invoicePeriod defaultValue: 1
		visible defaultValue: true
	}
	static constraints = {
		corporate nullable:false,blank:false
		rtaxi     nullable:false,blank:false
		name nullable:true,blank:true, unique:'corporate'
		phone nullable:true,blank:true
		legalAddress nullable:true,blank:true,maxLength:10000
		
	}
}
