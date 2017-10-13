package ar.com.goliath

class InvestorsContact  {
	String typeInvestment
	String email
	String city
	String firstName
	String lastName
	String title
	String userId
	String state_code
	String investorStateCode
	String description
	String countryCode
	String link
	String investorCity
	String investorType
	String investorCodeCountry
	String postalCode
	String fundingTypes
	String maxInvestment
	String minInvestment
	String companyName
	String profileKeyStartupCO
	String investorPostalCode
	String phone
	String country
	String status
	String linkedinUrl
	String facebookUrl
	String plataformUrl
	String website
	String json
	Date createdDate

	Date lastModifiedDate
	def beforeInsert() {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	def beforeUpdate (){
		lastModifiedDate = new Date()
	}
	
	static mapping = {
		version false
		json type: 'text'
	}
	static constraints = {
		email  nullable:true,blank:true, unique:true
		city  nullable:true,size:0..65535,blank:true
		typeInvestment  nullable:true,size:0..65535,blank:true
		firstName  nullable:true,size:0..65535,blank:true
		lastName  nullable:true,size:0..65535,blank:true
		title  nullable:true,size:0..65535,blank:true
		userId  nullable:true,size:0..65535,blank:true
		state_code  nullable:true,size:0..65535,blank:true
		investorStateCode  nullable:true,size:0..65535,blank:true
		description  nullable:true,size:0..65535,blank:true
		countryCode  nullable:true,size:0..65535,blank:true
		link  nullable:true,size:0..65535,blank:true
		investorCity  nullable:true,size:0..65535,blank:true
		investorType  nullable:true,size:0..65535,blank:true
		investorCodeCountry  nullable:true,size:0..65535,blank:true
		postalCode  nullable:true,size:0..65535,blank:true
		fundingTypes  nullable:true,size:0..65535,blank:true
		maxInvestment  nullable:true,size:0..65535,blank:true
		minInvestment  nullable:true,size:0..65535,blank:true
		companyName  nullable:true,size:0..65535,blank:true
		profileKeyStartupCO  nullable:true,size:0..65535,blank:true
		investorPostalCode  nullable:true,size:0..65535,blank:true
		phone  nullable:true,size:0..65535,blank:true
		country  nullable:true,size:0..65535,blank:true
		status  nullable:true,size:0..65535,blank:true
		linkedinUrl  nullable:true,size:0..65535,blank:true
		facebookUrl  nullable:true,size:0..65535,blank:true
		plataformUrl  nullable:true,size:0..65535,blank:true
		website  nullable:true,size:0..65535,blank:true
		json  nullable:true,blank:true
		lastModifiedDate nullable:true,blank:true
		createdDate nullable:true,blank:true
	}
}