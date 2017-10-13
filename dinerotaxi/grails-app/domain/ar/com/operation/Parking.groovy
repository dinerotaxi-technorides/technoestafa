package ar.com.operation

import ar.com.goliath.Company
class Parking {

	Company user
	String name
	double lat =0d
	double lng=0d
	boolean isPolygon

	String coordinatesIn
	String coordinatesOut 
	
	BUSINESSMODEL businessModel = BUSINESSMODEL.GENERIC
	static constraints = {
		name(nullable:false,blank:false)
		lng(nullable:true,blank:true)
		lat(nullable:true,blank:true)
		coordinatesIn(nullable:true,blank:true, maxSize:65000)
		coordinatesOut(nullable:true,blank:true, maxSize:65000)
	}
	static mapping = {
		businessModel defaultValue: BUSINESSMODEL.GENERIC
		
		isPolygon defaultValue: false
		coordinatesIn defaultValue: ""
		coordinatesOut defaultValue: ""
		lat defaultValue: 0d
		lng defaultValue: 0d
	}
}
