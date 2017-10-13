package ar.com.goliath

import java.util.Date;

class PersistToken {

	String id
	String username
	String token
	Long rtaxi
	Date lastUsed
	Date createdDate
	def beforeInsert = {
		createdDate = new Date()
	}
	static constraints = {
		username maxSize: 64
		token maxSize: 64
		id maxSize: 64
		rtaxi (nullable:true)
		createdDate (nullable:true)
	}

	static transients = ['series']

	void setSeries(String series) { id = series }
	String getSeries() { id }

	static mapping = {
		table 'persistent_logins'
		id column: 'series', generator: 'assigned'
		version false
	}
}
