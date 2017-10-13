package ar.com.goliath

import java.util.Date;

class Profile {
	byte[] filePayload
	User usr
	static constraints = {
		filePayload(nullable:true, maxSize:173741824) // max of 4GB file for example
	}



}
