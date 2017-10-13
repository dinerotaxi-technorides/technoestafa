package ar.com.goliath.business

class BusinessModel {

	String name
	BusinessConfigModel config
	static mapping = {
		cache true
		config lazy: false
	}
	static constraints = {
		name blank: false, unique: true
		
	}
}
