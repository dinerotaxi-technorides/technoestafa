package ar.com.imported

import java.util.SortedSet;

class Location implements Comparable{

	String name
	String alternateNames
	
	LocationType type = LocationType.OTHER
	
	double lat
	double lng
	
	double radius	
	double north
	double south
	double east
	double west
	
	int woeid
	int woetype
	
	String postal
	String street
	String city
	String county
	String state
	String country
	String countrycode
	
	String line1
	String line2
	String line3
	String line4
	
	Destination destination
	Location parent
	
	static hasMany = [
		children: Location ]
	
//	SortedSet activities
//	SortedSet products
		
	static constraints = {
		name (nullable:false, maxSize:32)
		alternateNames (nullable:true, maxSize:100)
		
		lat (nullable:true)
		lng (nullable:true)

		radius (nullable:true)
		north (nullable:true)
		south (nullable:true)
		east (nullable:true)
		west (nullable:true)
	
		woeid (nullable:false)
		woetype (nullable:false)
	
		postal (nullable:true, maxSize:32)
		street (nullable:true, maxSize:32)
		city (nullable:true, maxSize:32)
		county (nullable:true, maxSize:32)
		state (nullable:true, maxSize:32)
		country (nullable:true, maxSize:32)
		countrycode (nullable:true, maxSize:2)

		line1 (nullable:true, maxSize:32)
		line2 (nullable:true, maxSize:32)
		line3 (nullable:true, maxSize:32)
		line4 (nullable:true, maxSize:32)
		
		destination(nullable:true)
		parent(nullable:true)
	}
	
	def beforeInsert() {
		this.validateName()
	}
	
	def beforeUpdate() {
		this.validateName()
	}
	
	void validateName() {
		if(!name || name.isEmpty()){
			if(city && !city.isEmpty()){
				name = city
			}
			else
			{
				name = country
			}
		}
	}
	
	String toString() {
		"${name}"
	}
	
	int compareTo(obj) {
		id.compareTo(obj.id)
	}
}

enum LocationType {
	HOME, WORK, PRIMARY, BILLING, OTHER
}


enum WOETYPE { TOWN(7), CANTON(8), DISTRICT(9), COUNTRY(12), SUPERNAME(19), CONTINENT(29) 
	WOETYPE(int value) { this.value = value }
    private final int value
    public int value() { return value }
}
