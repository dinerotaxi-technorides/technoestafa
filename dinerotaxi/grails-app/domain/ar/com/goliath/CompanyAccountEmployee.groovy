
package ar.com.goliath
import com.sun.org.apache.xalan.internal.xsltc.compiler.Import;

import java.util.Date;
import java.util.Set;
import java.util.SortedSet;

import com.UserDevice
import ar.com.imported.*
import ar.com.goliath.User
import com.Device
class CompanyAccountEmployee extends User implements Serializable {
   User employee
   UStatus status=UStatus.DONE
   TypeEmployer typeEmploy
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
		firstName nullable:true,blank:true
		usrDevice nullable:true,blank:true
		validated nullable:true,blank:true
		lastName nullable:true,blank:true
		phone nullable:false,blank:false
		phone1 nullable:true,blank:true
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
		employee nullable:true,blank:true
	}
}
