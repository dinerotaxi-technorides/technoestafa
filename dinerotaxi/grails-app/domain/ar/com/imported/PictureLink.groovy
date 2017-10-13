/* 
 * Copyright 2011 Matias Baglieri
 */
package ar.com.imported

class PictureLink {

	static belongsTo = [picture:Picture]
	
	Long pictureRef
	String type
	
	static constraints = {
		pictureRef min:0L
		type blank:false
	}

	static mapping = {
		cache true
	}
}
