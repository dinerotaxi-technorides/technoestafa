/* 
 * Copyright 2011 Matias Baglieri
 */
package ar.com.imported

class StringAttribute_i18n {
    
    String lang = "en"
    String value

    static constraints = {
        value (nullable:false, maxSize:5000)
    }

    static belongsTo = [ stringAttribute : StringAttribute ]
}
