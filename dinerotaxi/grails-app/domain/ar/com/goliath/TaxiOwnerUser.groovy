
package ar.com.goliath
import com.sun.org.apache.xalan.internal.xsltc.compiler.Import;

import java.util.SortedSet;

import ar.com.imported.*
import ar.com.goliath.User
import ar.com.goliath.Vehicle
class TaxiOwnerUser extends User  {
	UStatus status=UStatus.WITHOUTFINISHREGISTRATION
	boolean agree
	boolean politics
	static mapping = { vehicles cascade: "all-delete-orphan"  }
	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }

	static constraints = {
		username blank: false, unique: true
		password blank: false
		email blank: false,nullable:false,email:true
		firstName nullable:true,blank:true
		lastName nullable:true,blank:true
		phone nullable:false,blank:false
		phone1 nullable:true,blank:true
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
	}
}
public enum UStatus{
	WITHOUTFINISHREGISTRATION,DONE,CANCELED,BLOCKED,BANNED,UNTRUSTED,MINIMAL,MINIMALWITHPASS
}
