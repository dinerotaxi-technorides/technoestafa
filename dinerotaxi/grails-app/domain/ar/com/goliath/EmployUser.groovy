package ar.com.goliath
import java.util.Set;

import ar.com.imported.*
import ar.com.operation.Options
class EmployUser extends User implements Serializable {
   User employee
   UStatus status=UStatus.WITHOUTFINISHREGISTRATION
   TypeEmployer typeEmploy
   Boolean agree
   Boolean politics
   Boolean visible=true
   Boolean admin = false
   String cuit
   String licenceNumber
   Date licenceEndDate
	 Boolean isCorporate=true
	 Boolean isMessaging=true
	 Boolean isPet = true;
	 Boolean isAirConditioning = true;
	 Boolean isSmoker = true;
	 Boolean isSpecialAssistant = true;
	 Boolean isLuggage = true;
	 Boolean isAirport = true;
	 Boolean isVip = true;
	 Boolean isInvoice = true;
	 Boolean isRegular=true

	def beforeInsert = {
		createdDate = new Date()
	}
	def beforeUpdate = {
		lastModifiedDate = new Date()
	}
	static hasMany = [profileVariables: ProfileBuilder]

	static mapping = {
		isCorporate default: true
		isMessaging default: true
		isPet default: true
		isAirConditioning default: true
		isSmoker default: true
		isSpecialAssistant default: true
		isLuggage default: true
		isAirport default: true
		isVip default: true
		isInvoice default: true
		isRegular default: true

	 }


	static constraints = {
		isCorporate nullable:true, defaultValue: true
		isMessaging nullable:true, defaultValue: true
		isPet nullable:true, defaultValue: true
		isAirConditioning nullable:true, defaultValue: true
		isSmoker nullable:true, defaultValue: true
		isSpecialAssistant nullable:true, defaultValue: true
		isLuggage nullable:true, defaultValue: true
		isAirport nullable:true, defaultValue: true
		isVip nullable:true, defaultValue: true
		isInvoice nullable:true, defaultValue: true
		isRegular nullable:true, defaultValue: true
		licenceNumber nullable:true,blank:true
		licenceEndDate nullable:true,blank:true
		cuit nullable:true,blank:true
		username blank: false, unique: true
		password blank: false
		email blank: false,nullable:false,email:true
		firstName nullable:true,blank:true
		lastName nullable:true,blank:true
		phone nullable:false,blank:false
		phone1 nullable:true,blank:true
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
		employee nullable:true,blank:true
		latitude(nullable:true,blank:true)
		longitude(nullable:true,blank:true)
	}
}

public enum TypeEmployer{
	TAXISTA,OPERADOR,CORDINADOR,TELEFONISTA,COMPANYEMPLOYEE,MONITOR
	//DRIVER,OPERATOR,SUPERVISOR,TELEPHONIST,COMPANYEMPLOYEE
}
