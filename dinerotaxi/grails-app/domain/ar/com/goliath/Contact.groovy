package ar.com.goliath
import java.util.Date;

import ar.com.goliath.Place
import ar.com.goliath.RealUser
import com.Product
class Contact  {
	String email
	String firstName
	String lastName
	String phone
	String subject
	String comment
	Date createdDate
	def beforeInsert = {
		createdDate = new Date()
	}
	static constraints = {
		email blank: false,nullable:false,email:true
		firstName nullable:true,blank:true
		lastName nullable:true,blank:true
		phone nullable:true,blank:true
		subject nullable:false,blank:false
		comment nullable:false,blank:false,maxSize:1500
		createdDate (nullable:true)
	}
}