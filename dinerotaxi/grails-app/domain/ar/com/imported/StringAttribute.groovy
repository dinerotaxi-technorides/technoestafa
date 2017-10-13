/* 
 * Copyright 2011 Matias Baglieri
 */
package ar.com.imported

import org.springframework.context.i18n.LocaleContextHolder as LCH

class StringAttribute {
    
    String lang = 'en'
    Long type
    
    static transients = [
        'lang',
        'value'
      ]
    
    void setValue(String value) {
        loc().value = value
      }
      String getValue() {
        loc().value
      }
  
    def loc() {
      def result = i18n.find { item -> item.lang == lang }
      if(!result){
        // Create new localisation if not found
        result = new StringAttribute_i18n(lang: lang)
        this.addToI18n(result)
      }
      return result
    }
    
    static hasMany = [ links: StringAttributeLink, i18n : StringAttribute_i18n ]
    
    static constraints = {
        type(blank:false, validator: {val, obj ->
            return org.grails.plugins.lookups.Lookup.valueFor("string.attribute.type", val.toString()) != null
        })

    }

	static mapping = {
		cache true
	}
}
