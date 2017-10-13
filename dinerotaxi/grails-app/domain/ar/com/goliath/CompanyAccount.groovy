
package ar.com.goliath
import com.sun.org.apache.xalan.internal.xsltc.compiler.Import;

import java.util.SortedSet;

import ar.com.imported.*
import ar.com.goliath.*
class CompanyAccount extends User {
	String companyName
	String mailContacto
	String cuit
	Integer appVersion
	boolean agree
	boolean politics

	UStatus status=UStatus.WITHOUTFINISHREGISTRATION


	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }
	static constraints = {
		username blank: false, unique:'rtaxi'
		password blank: false
		email blank: false,nullable:false,email:true
		firstName nullable:true,blank:true
		lastName nullable:true,blank:true
		mailContacto nullable:true,blank:true
		appVersion nullable:true,blank:true
		cuit nullable:true,blank:true
		phone nullable:false,blank:false
		phone1 nullable:true,blank:true
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
	}
}
