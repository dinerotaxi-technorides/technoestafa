
package ar.com.goliath
import ar.com.goliath.business.UserBusinessModel
import ar.com.imported.*
import ar.com.notification.*
class Company extends User {
	String mailContacto
	String cuit
	String price
	String pageUrl
	String limitDrivers
	PLANSTATUS statusPlan
	Integer appVersion
	boolean agree
	boolean politics

	Boolean admin = false
	ConfigurationApp wlconfig
	UStatus status=UStatus.WITHOUTFINISHREGISTRATION


	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }

	static constraints = {
		username blank: false, unique: true
		password blank: false
		email blank: false,nullable:false,email:true
		firstName nullable:true,blank:true
		lastName nullable:true,blank:true
		limitDrivers nullable:true,blank:true
		statusPlan nullable:true,blank:true
		mailContacto nullable:true,blank:true
		appVersion nullable:true,blank:true
		pageUrl nullable:true,blank:true
		cuit nullable:true,blank:true
		phone nullable:false,blank:false
		phone1 nullable:true,blank:true
		price nullable:true,blank:true
		createdDate nullable:true,blank:true
		wlconfig nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
		latitude nullable:true,blank:true
		longitude nullable:true,blank:true
	}

	static mapping = {
		wlconfig ignoreNotFound:true
	 }

}


public enum PLANSTATUS{
	BASIC,ADVANCE,PREMIUM
}
