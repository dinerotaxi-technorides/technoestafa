package ar.com.goliath

import java.util.Date;
import com.lucastex.grails.fileuploader.UFile
class Vehicle {
	Integer countEmployer=1
	String patente
	String marca
	String modelo
	boolean active
	Date createdDate
	Date lastModifiedDate
	Company company
	User owner
	static hasMany = [documents:UFile,taxistas:ar.com.goliath.EmployUser]
	static Vehicle findByTaxistas(User taxista){
		def c = Vehicle.createCriteria()
		def result = c.list {
		  taxistas {
			idEq(taxista.id)
		  }
		}
		if(result)
			return result[0]
		else
			return null
	}
	static mapping = {
	   documents cascade: "all-delete-orphan"
	}
	def beforeInsert = {
		createdDate = new Date()
	}
	def beforeUpdate = {
		lastModifiedDate = new Date()
		countEmployer++
	}
    static constraints = {
		createdDate(nullable:true,blank:true)
		active(nullable:true,blank:true)
		company(nullable:true,blank:true)
		owner(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		patente (nullable:false,blank:false,minSize:5)
		marca (nullable:false,blank:false,minSize:3)
		modelo (nullable:false,blank:false)
		countEmployer (nullable:false,blank:false)
    }
	String toString(){
		return patente
	}
}
