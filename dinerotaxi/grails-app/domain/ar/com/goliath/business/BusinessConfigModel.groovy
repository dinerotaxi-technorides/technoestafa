package ar.com.goliath.business

class BusinessConfigModel {
    static belongsTo = [model:BusinessModel]
	static hasMany = [groupConfig: BusinessModelConfigGroup]
	static mapping = {
		groupConfig cascade:"all,delete-orphan"
		groupConfig lazy: false
	}
		 
}
