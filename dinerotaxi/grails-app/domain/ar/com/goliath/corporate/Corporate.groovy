package ar.com.goliath.corporate

import java.util.Date;

import ar.com.goliath.User;

class Corporate {
	byte[] logotype
	String name
	String phone
	String phone1
	String cuit
	String legalAddress
	Integer discount
	User rtaxi=null
	boolean visible = true
//    static belongsTo = [costCenter:CostCenter]
	static constraints = {
		logotype(nullable:true, maxSize:10737418) // max of 4GB file for example
		name nullable:false,blank:false, unique:'rtaxi'
		phone nullable:false,blank:false
		phone1 nullable:true,blank:true
		cuit nullable:false,blank:false
		legalAddress nullable:false,blank:false
		rtaxi nullable:false,blank:false
	}
	
	static mapping = {
		visible defaultValue: false
	}
}
