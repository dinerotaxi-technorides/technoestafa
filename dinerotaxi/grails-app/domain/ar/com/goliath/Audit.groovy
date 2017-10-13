package ar.com.goliath
import java.util.Date;

import ar.com.goliath.Place
import ar.com.goliath.RealUser
import com.Product
class Audit  {
	String ip
	String page
	String jsonParams
	String email
	Date createdDate
	def beforeInsert = {
		createdDate = new Date()
	}
	static constraints = {
		ip (nullable:false, maxSize:255)
		email (nullable:true,blank:true, maxSize:255)
		page (nullable:true, maxSize:255)
		createdDate (nullable:true)
		jsonParams (nullable:true,size:0..65535)
	}
}