package ar.com.favorites
import java.util.Date;

import ar.com.goliath.Place
import ar.com.goliath.User
import com.Product
class TemporalFavorites  {
	User user
	String name
	Place placeFrom
	Place placeTo
	String placeFromPso
	String placeFromDto
	String placeToFloor
	String placeToApartment
	String comments
	boolean enabled
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = {
		createdDate = new Date()
		name=placeFrom.i18n.street+" "+placeFrom.streetNumber
		enabled=true
		if (comments != null){comments=comments.replaceAll("\\n", " ")}
	}
	def beforeUpdate = {
		lastModifiedDate = new Date()
		if (comments != null){comments=comments.replaceAll("\\n", " ")}
	}
	static constraints = {
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		placeFrom(nullable:false,blank:false)
		placeTo(nullable:true,blank:true)
		placeFromPso(nullable:true,blank:true)
		placeFromDto(nullable:true,blank:true)
		placeToFloor(nullable:true,blank:true)
		placeToApartment(nullable:true,blank:true)
		comments(nullable:true,blank:true)
		user(nullable:false,blank:false)
	}
}
