package ar.com.goliath

import ar.com.goliath.business.BusinessModel
import ar.com.goliath.business.UserBusinessModel

class User {
	Date createdDate
	Date lastModifiedDate
	transient springSecurityService
	String username
	String password
	boolean enabled
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	boolean isTestUser=false
	boolean isProfileEditable=true
	boolean isFrequent = false
  Boolean admin = false
  Boolean corporateSuperUser = false
	String email
	String firstName
	String lastName
	String companyName
	String phone
	String phone1
	String ip
	Integer countTripsCompleted=0
	User rtaxi=null
	String lang = 'es'
	EnabledCities city
	Float latitude
	Float longitude
	static constraints = {

		//photo(maxSize: 102400) // 100Kb
		rtaxi nullable:true,blank:true
		lang nullable:true,blank:true
		city nullable:true,blank:true
		username blank: false, unique:true
		password blank: false
		email blank: false,nullable:false,email:true
		firstName nullable:true,blank:true
		lastName nullable:true,blank:true
		ip nullable:true,blank:true
		companyName nullable:true,blank:true
		phone nullable:true,blank:true
		phone1 nullable:true,blank:true
		latitude(nullable:true,blank:true)
		longitude(nullable:true,blank:true)
	}

	static mapping = {
		password column: '`password`'
		admin default: false
		corporateSuperUser default: false
		isProfileEditable default: true
	 }

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this).collect { it.role } as Set
	}
	Set<BusinessModel> getBusinessModel() {
		UserBusinessModel.findAllByUser(this).collect { it.businessModel } as Set
	}
	String toString(){
		return username
	}

	def beforeInsert() {
		createdDate = new Date()
		encodePassword()
	}

	def beforeUpdate() {
		lastModifiedDate = new Date()
		if (isDirty('password')) {
			encodePassword()
		}
	}
	protected void encodePassword() {
		password = springSecurityService.encodePassword(password)
	}
}
