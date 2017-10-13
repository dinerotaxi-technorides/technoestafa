
package ar.com.goliath
import ar.com.notification.*
import com.sun.org.apache.xalan.internal.xsltc.compiler.Import;

import java.util.SortedSet;

import ar.com.imported.*
import ar.com.goliath.User
class AditionalInformation {
	Date createdDate
	Date lastModifiedDate
	String creditCard
	String code
	String month
	String year
	String cardName
	User user
	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }
	static constraints = {
		creditCard nullable:false,blank:false
		code nullable:false,blank:false
		month nullable:false,blank:false
		year nullable:false,blank:false
		cardName nullable:false,blank:false
		user nullable:false,blank:false
		createdDate nullable:true,blank:true
		createdDate nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
	}
}
