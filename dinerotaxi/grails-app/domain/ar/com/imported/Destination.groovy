package ar.com.imported

import java.util.SortedSet;

class Destination implements Comparable {
	static searchable = true
	
	String name
	String introduction
	String knownFor
	String capital
	String currency
	String area
	String population
	String language
	String religion
	String electricity
	String callingCode
	String timezone
	String climate
	String bestTimeToVisit
	String gettingThere
	String gettingAround
	String costs
	String healthAndSafety
	String visas

	Location location
	
	static constraints = {
		name (nullable:false, maxSize:32)
		
		introduction (nullable:true, maxSize:1000)
		knownFor (nullable:true, maxSize:32)
		capital (nullable:true, maxSize:32)
		currency (nullable:true, maxSize:32)
		area (nullable:true, maxSize:32)
		population (nullable:true, maxSize:32)
		language (nullable:true, maxSize:32)
		religion (nullable:true, maxSize:32)
		electricity (nullable:true, maxSize:32)
		callingCode (nullable:true, maxSize:32)
		timezone (nullable:true, maxSize:32)
		climate (nullable:true, maxSize:32)
		bestTimeToVisit (nullable:true, maxSize:32)
		gettingThere (nullable:true, maxSize:32)
		gettingAround (nullable:true, maxSize:32)
		costs (nullable:true, maxSize:32)
		healthAndSafety (nullable:true, maxSize:32)
		visas (nullable:true, maxSize:32)
	}
	
	int compareTo(obj) {
		id.compareTo(obj.id)
	}
}
