
package ar.com.goliath
import ar.com.imported.*

import com.UserDevice
class InvestorUser extends User  {
	boolean agree
	boolean politics
	UStatus status=UStatus.WITHOUTFINISHREGISTRATION
	UStatus validated=UStatus.DONE
	UserDevice usrDevice
	int countLogin=0
	def beforeInsert = {
		createdDate = new Date()
		 }
	def beforeUpdate = { lastModifiedDate = new Date() }

	static constraints = {
		rtaxi nullable:true,blank:true
		username blank: false,unique:'rtaxi'
		password blank: false
		email blank: false,nullable:false,email:true
		firstName nullable:true,blank:true
		lastName nullable:true,blank:true
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
		phone nullable:false,blank:false
		phone1 nullable:true,blank:true
		validated nullable:true,blank:true
		usrDevice nullable:true,blank:true
		ip nullable:true,blank:true
	}
}
