package ar.com.favorites
import com.Product
class Favorites extends TemporalFavorites {
	
	def beforeInsert = {
		createdDate = new Date()
		enabled=true
	}
	def beforeUpdate = {
		lastModifiedDate = new Date()
	}
	
	static constraints = {
		createdDate(nullable:true,blank:true)
		placeFrom(nullable:false,blank:false)
		placeTo(nullable:true,blank:true)
		placeFromPso(nullable:true,blank:true)
		placeFromDto(nullable:true,blank:true)
		comments(nullable:true,blank:true)
		user(nullable:false,blank:false)
	}
	
}