package ar.com.goliath

class EnabledCities {

  String name
  String country
  String admin1Code
  String locality
  String timeZone
  String countryCode
	Float northEastLatBound
	Float northEastLngBound
	Float southWestLatBound
	Float southWestLngBound
	boolean enabled

  static constraints = {
		name (nullable:false, maxSize:200)
		country (nullable:true, maxSize:200)
		admin1Code (nullable:true, maxSize:200)
		locality (nullable:true, maxSize:200)
		countryCode(nullable:false, maxSize:3)
		timeZone(nullable:true)
		northEastLatBound(nullable:true)
		northEastLngBound(nullable:true)
		southWestLatBound(nullable:true)
		southWestLngBound(nullable:true)
    }
}
