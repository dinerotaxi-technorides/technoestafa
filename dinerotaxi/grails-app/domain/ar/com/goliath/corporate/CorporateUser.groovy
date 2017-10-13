
package ar.com.goliath.corporate
import ar.com.goliath.TypeEmployer
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.imported.*

import com.Device
import com.UserDevice
class CorporateUser extends User implements Serializable {
   UStatus status=UStatus.DONE
   TypeEmployer typeEmploy =TypeEmployer.COMPANYEMPLOYEE
   CostCenter costCenter
   boolean agree
   boolean politics
   UStatus validated=UStatus.DONE
	 UserDevice usrDevice

   static hasMany = [devices:Device]

   static mapping = {
		 devices cascade: "all-delete-orphan"
   }
	 def beforeInsert = {
		 createdDate = new Date()
	 }
	 def beforeUpdate = {
		 lastModifiedDate = new Date()
	 }

	 static constraints = {
		username blank: false, unique:'rtaxi'
		password blank: false
		email blank: false,nullable:false,email:true
		firstName nullable:false,blank:false
		usrDevice nullable:true,blank:true
		validated nullable:true,blank:true
		costCenter nullable:true,blank:true
		lastName nullable:false,blank:false
		phone nullable:false,blank:false
		phone1 nullable:true,blank:true
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
	 }
}
