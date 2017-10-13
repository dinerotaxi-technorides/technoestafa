package ar.com.goliath

import org.springframework.context.i18n.LocaleContextHolder as LCH
import grails.converters.*
import org.codehaus.groovy.grails.web.json.*; // package containing JSONObject, JSONArray,...

class Place {
    String lang = 'en'

    static transients = [
      'lang',
      'name',
      'country',
      'countryCode',
      'admin1Code',
      'admin2Code',
      'admin3Code',
      'locality',
      'street'
    ]

    void setName(String name) {
      loc().name = name
    }
    String getName() {
      loc().name
    }
    void setCountry(String name) {
      loc().country = name
    }
    String getCountry() {
      loc().country
    }
    void setCountryCode(String name) {
      loc().countryCode = name
    }
    String getCountryCode() {
      loc().countryCode
    }
    void setAdmin1Code(String name) {
      loc().admin1Code = name
    }
    String getAdmin1Code() {
      loc().admin1Code
    }
    void setAdmin2Code(String name) {
      loc().admin2Code = name
    }
    String getAdmin2Code() {
      loc().admin2Code
    }
    void setAdmin3Code(String name) {
      loc().admin3Code = name
    }
    String getAdmin3Code() {
      loc().admin3Code
    }
    void setLocality(String name) {
      loc().locality = name
    }
    String getLocality() {
      loc().locality
    }
    void setStreet(String name) {
      loc().street = name
    }
    String getStreet() {
      loc().street
    }
    
    double lat
    double lng
	
    double northEastLatBound
    double northEastLngBound
    double southWestLatBound
    double southWestLngBound

    String countryCode
    String postalCode
    String streetNumber

    String locationType
    String type
    
    String json

    static hasMany = [ i18n : Place_i18n ]
    
    def loc() {
      def result = i18n.find { item -> item.lang == lang }
      if(!result){
        // Create new localization if not found
        result = new Place_i18n(lang: lang)
        this.addToI18n(result)
      }
      return result
    }    
    
    String countryCity() {
      if(country && locality){
        return "${locality}, ${country}" 
      }
      else{
        return country
      }
    }
    
    static constraints = {

        lat (nullable:true)
        lng (nullable:true)

        northEastLatBound (nullable:true)
        northEastLngBound (nullable:true)
        southWestLatBound (nullable:true)
        southWestLngBound (nullable:true)		

        countryCode (nullable:true, maxSize:20)
        postalCode (nullable:true, maxSize:10)
        streetNumber (nullable:true, maxSize:150)

        locationType (nullable:true, maxSize:20)
        type (nullable:true, maxSize:50)
        json (nullable:false, maxSize:2000)
    }
}

