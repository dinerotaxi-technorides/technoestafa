/* 
 * Copyright 2011 Matias Baglieri
 */
package ar.com.imported

class StringAttributeLink {
    
    static belongsTo = [value:StringAttribute]
    
    Long ref
    String type

    static constraints = {
        value nullable:false
        ref min:0L
        type blank:false
    }

    static mapping = {
        cache true
    }
}
