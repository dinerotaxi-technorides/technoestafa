package com.api

import ar.com.imported.Destination

import grails.converters.JSON
import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.commons.*
import ar.com.goliath.*
import ar.com.imported.Location

class GeocoderService {

	static transactional = false
	static scope = "singleton"
	/**
	 * @deprecated
	 * @param query
	 * @return
	 */
	def queryForJSON(String query) {
		def config = ConfigurationHolder.config
		String configUrlJSON = config.googleapi.url.json
		String configPeru= config.googleapi.peru
		def addressWithNumber=query.split(",")[0];
		def address=addressWithNumber.replaceAll("\\d*\$", "");
		def numberStreet=addressWithNumber.replaceAll("[^0-9]+", "");
		configPeru=configPeru.replaceAll("#NUMBER#", numberStreet.toString())
		configPeru=configPeru.replaceAll("#STREET#", address)

		def configPeruJson = new JsonSlurper().parseText(configPeru)

		def urlJSON = new URL(configUrlJSON + removeSpaces(query))
		def geoCodeResultJSON = new JsonSlurper().parseText(urlJSON.getText())
		def jsonMap = [:]
		def emptyList = []
		def cities=EnabledCities.findAllByEnabled(true)
		geoCodeResultJSON.results.each{
			for (EnabledCities cit :cities){
				if(it.toString().contains(cit.admin1Code)  ){
					try{
						if (it.types[0]!=null && it.types[0].toString().contains("street_address")){
							emptyList.add (it)

						}else if (it.types[0]!=null && it.toString().contains("Perú")){
							if(emptyList.isEmpty()){
								emptyList.add (configPeruJson)
							}
						}
					}catch (Exception e) {
						log.error e
					}
					emptyList.add (it)
					break;
				}
			}

		}
		jsonMap.places=emptyList
		return jsonMap
	}
	def queryForJSONUTF(def query) {
		def config = ConfigurationHolder.config
		String configUrlJSON = config.googleapi.url.json

		String configPeru= config.googleapi.generic
		def addressWithNumber=query.split(",")[0];
		def address=addressWithNumber.split("[^a-zA-z.\\s]")[0]
		def city=query.split(",")[1];
		def numberStreet=addressWithNumber.replaceAll(address, "");
		configPeru=configPeru.replaceAll("#NUMBER#", numberStreet.toString())
		configPeru=configPeru.replaceAll("#STREET#", address)

		def urlJSON = new URL(configUrlJSON + removeSpaces(query))
		def geoCodeResultJSON = new JsonSlurper().parseText(urlJSON.getText())
		def jsonMap = [:]
		def emptyList = []
		def cities=EnabledCities.findAllByEnabled(true)
		geoCodeResultJSON.results.each{
			for (EnabledCities cit :cities){
				if(it.toString().contains(cit.admin1Code)  ){
					String resultet=it.toString()
					try{
						if (it.types[0]!=null && it.types[0].toString().contains("street_address")){
							emptyList.add (it)
						}
					}catch (Exception e) {
						log.error e
					}
					break;
				}
			}

		}
		if(emptyList.isEmpty()){
//			emptyList=cloudMadeSearch(query)
			def citie1s=EnabledCities.findByEnabled(true)
			def cit=citie1s.each{
				if(it.admin1Code.contains(city)){
					return it;
				}
			}
			try{

					def ffx=configPeru
					ffx=ffx.replaceAll("#CITY#",cit.admin1Code)
					ffx=ffx.replaceAll("#COUNTRY#",cit.country)
					ffx=ffx.replaceAll("#SCOUNTRY#",cit.countryCode)
					ffx=ffx.replaceAll("#LNG#","-34.5627767697085")
					ffx=ffx.replaceAll("#LAT#","-34.5627767697085")
					def configPeruJson = new JsonSlurper().parseText(ffx)
					emptyList.add (configPeruJson)
			}catch (Exception e) {
				log.error e
			}
		}
		jsonMap.places=emptyList
		return jsonMap
	}
	def cloudMadeSearch(def query) {
		def config = ConfigurationHolder.config
		String configUrlJSON = config.cloudmade.url.json

		String configGeneric= config.googleapi.generic
		def addressWithNumber=query.split(",")[0];
		def address=addressWithNumber.replaceAll("\\d*\$", "");
		def numberStreet=addressWithNumber.replaceAll("[^0-9]+", "");
//		configGeneric=configGeneric.replaceAll("#NUMBER#", numberStreet.toString())
//		configGeneric=configGeneric.replaceAll("#STREET#", address)

		def urlJSON = new URL(configUrlJSON + removeSpaces(query))
		def geoCodeResultJSON = new JsonSlurper().parseText(urlJSON.getText())
		def jsonMap = [:]
		def emptyList = []
		def cities=EnabledCities.findAllByEnabled(true)
		geoCodeResultJSON.features.each{
			for (EnabledCities cit :cities){
				if(it.toString().contains(cit.admin1Code)  ){
					String resultet=it.toString()
					try{
						log.error it

//						def ffx=configPeru.clone()
//						ffx=ffx.replaceAll("#CITY#",cit.admin1Code)
//						ffx=ffx.replaceAll("#COUNTRY#",cit.country)
//						ffx=ffx.replaceAll("#SCOUNTRY#",cit.countryCode)
//						ffx=ffx.replaceAll("#LNG#",1)
//						ffx=ffx.replaceAll("#LAT#",2)
//						def configPeruJson = new JsonSlurper().parseText(ffx)
//						emptyList.add (configPeruJson)
					}catch (Exception e) {
						log.error e
					}
					break;
				}
			}

		}
		return emptyList
	}







	private String removeSpaces(String query) {
		query.replaceAll(" ", "+")
	}
    // http://where.yahooapis.com/geocode?line1=100+Market+St.&line2=San+Francisco,+CA&appid=Ka2Zpz6k
    def geocode (Location loc){
        def base = "http://where.yahooapis.com/geocode?"
        def appid = "appid=Ka2Zpz6k"
        def flags = "flags=X"

        def qs = []
        if(loc.line1) qs << "line1=" + URLEncoder.encode(loc.line1)
        if(loc.line2) qs << "line2=" + URLEncoder.encode(loc.line2)
        if(loc.line3) qs << "line3=" + URLEncoder.encode(loc.line3)
        if(loc.line4) qs << "line4=" + URLEncoder.encode(loc.line4)
        qs << flags
        qs << appid
        def url = new URL(base + qs.join("&"))

        def connection = url.openConnection()

        def dest
        if(connection.responseCode == 200){
            def resultset = new XmlSlurper().parseText(connection.content.text)
            assert resultset.Result.size() >= 1
            dest = new Location()
            dest.lat = resultset.Result[0].latitude.toDouble()
            dest.lng = resultset.Result[0].longitude.toDouble()
            dest.radius = resultset.Result[0].radius.toDouble()
            dest.north =  resultset.Result[0].boundingbox.north.toDouble()
            dest.south =  resultset.Result[0].boundingbox.south.toDouble()
            dest.east =  resultset.Result[0].boundingbox.east.toDouble()
            dest.west =  resultset.Result[0].boundingbox.west.toDouble()
            dest.name = resultset.Result[0].name as String
            dest.city = resultset.Result[0].city as String
            dest.county = resultset.Result[0].county as String
            dest.state = resultset.Result[0].state as String
            dest.country = resultset.Result[0].country as String
            dest.countrycode = resultset.Result[0].countrycode as String
            dest.woeid = resultset.Result[0].woeid.toInteger()
            dest.woetype = resultset.Result[0].woetype.toInteger()
            dest.line1 = resultset.Result[0].line1 as String
            dest.line2 = resultset.Result[0].line2 as String
            dest.line3 = resultset.Result[0].line3 as String
            dest.line4 = resultset.Result[0].line4 as String
        }
        else{
            log.error("Geocode FAILED")
            log.error(url)
            log.error(connection.responseCode)
            log.error(connection.responseMessage)
        }

        return dest
    }

    def geocode (String country, String city){
        def base = "http://where.yahooapis.com/geocode?"
        def appid = "appid=Ka2Zpz6k"
        def flags = "flags=X"

        def qs = []
        qs << "country=" + URLEncoder.encode(country)
        qs << "city=" + URLEncoder.encode(city)
        qs << flags
        qs << appid
        def url = new URL(base + qs.join("&"))

        def connection = url.openConnection()

        def dest
        if(connection.responseCode == 200){
            def resultset = new XmlSlurper().parseText(connection.content.text)
            assert resultset.Result.size() >= 1
            dest = new Location()
            dest.lat = resultset.Result[0].latitude.toDouble()
            dest.lng = resultset.Result[0].longitude.toDouble()
            dest.radius = resultset.Result[0].radius.toDouble()
            dest.north =  resultset.Result[0].boundingbox.north.toDouble()
            dest.south =  resultset.Result[0].boundingbox.south.toDouble()
            dest.east =  resultset.Result[0].boundingbox.east.toDouble()
            dest.west =  resultset.Result[0].boundingbox.west.toDouble()
            dest.name = resultset.Result[0].name as String
            dest.city = resultset.Result[0].city as String
            dest.county = resultset.Result[0].county as String
            dest.state = resultset.Result[0].state as String
            dest.country = resultset.Result[0].country as String
            dest.countrycode = resultset.Result[0].countrycode as String
            dest.woeid = resultset.Result[0].woeid.toInteger()
            dest.woetype = resultset.Result[0].woetype.toInteger()
            dest.line1 = resultset.Result[0].line1 as String
            dest.line2 = resultset.Result[0].line2 as String
            dest.line3 = resultset.Result[0].line3 as String
            dest.line4 = resultset.Result[0].line4 as String
        }
        else{
            log.error("Geocode FAILED")
            log.error(url)
            log.error(connection.responseCode)
            log.error(connection.responseMessage)
        }

        return dest
    }

    // http://where.yahooapis.com/geocode?q=2+rue+de+fribourg,+geneva,+ch&appid=Ka2Zpz6k
    def geocode (String q){
        def base = "http://where.yahooapis.com/geocode?"
        def appid = "appid=Ka2Zpz6k"
        def flags = "flags=X"

        def qs = []
        qs << "q=" + URLEncoder.encode(q)
        qs << flags
        qs << appid
        def url = new URL(base + qs.join("&"))

        def connection = url.openConnection()

        def dest
        if(connection.responseCode == 200){
            def resultset = new XmlSlurper().parseText(connection.content.text)
            assert resultset.Result.size() >= 1
            dest = new Location()
            dest.lat = resultset.Result[0].latitude.toDouble()
            dest.lng = resultset.Result[0].longitude.toDouble()
            dest.radius = resultset.Result[0].radius.toDouble()
            dest.north =  resultset.Result[0].boundingbox.north.toDouble()
            dest.south =  resultset.Result[0].boundingbox.south.toDouble()
            dest.east =  resultset.Result[0].boundingbox.east.toDouble()
            dest.west =  resultset.Result[0].boundingbox.west.toDouble()
            dest.name = resultset.Result[0].name as String
            dest.city = resultset.Result[0].city as String
            dest.county = resultset.Result[0].county as String
            dest.state = resultset.Result[0].state as String
            dest.country = resultset.Result[0].country as String
            dest.countrycode = resultset.Result[0].countrycode as String
            dest.woeid = resultset.Result[0].woeid.toInteger()
            dest.woetype = resultset.Result[0].woetype.toInteger()
            dest.line1 = resultset.Result[0].line1 as String
            dest.line2 = resultset.Result[0].line2 as String
            dest.line3 = resultset.Result[0].line3 as String
            dest.line4 = resultset.Result[0].line4 as String
        }
        else{
            log.error("Geocode FAILED")
            log.error(url)
            log.error(connection.responseCode)
            log.error(connection.responseMessage)
        }

        return dest
    }



    // <place yahoo:uri="http://where.yahooapis.com/v1/place/2347089" xml:lang="en-gb">
    //   <woeid>2347089</woeid>
    //   <placeTypeName code="8">Canton</placeTypeName>
    //   <name>Canton of Geneva</name>
    // </place>

    def geoparent (String woeid){
        // http://where.yahooapis.com/v1/place/12593124/parent?&appid=A.LyjUnV34FSAwZsPYWUBhmQBP25VNzj4V13MIkmcLXLZSgn4C9ozPVQr7tRxK3Nrhu46g--
        def base = "http://where.yahooapis.com/v1/place/"
        def appid = "appid=A.LyjUnV34FSAwZsPYWUBhmQBP25VNzj4V13MIkmcLXLZSgn4C9ozPVQr7tRxK3Nrhu46g--"
        def url = new URL(base + URLEncoder.encode(woeid) + "/parent?" + appid)

        def connection = url.openConnection()

        def result = [:]
        if(connection.responseCode == 200){
            def place = new XmlSlurper().parseText(connection.content.text)
            result.name = place.name as String
            result.type = place.placeTypeName as String
            result.woeid = place.woeid as String
        }
        else{
            log.error("Geocode FAILED")
            log.error(url)
            log.error(connection.responseCode)
            log.error(connection.responseMessage)
        }

        return result
    }


    // http://where.yahooapis.com/geocode?woeid=782538&appid=Ka2Zpz6k&flags=X
    def getPlace (String woeid){
        def base = "http://where.yahooapis.com/geocode?"
        def appid = "appid=Ka2Zpz6k"
        def flags = "flags=X"

        def qs = []
        qs << "woeid=" + URLEncoder.encode(woeid)
        qs << flags
        qs << appid
        def url = new URL(base + qs.join("&"))

        def connection = url.openConnection()

        def dest
        if(connection.responseCode == 200){
            def resultset = new XmlSlurper().parseText(connection.content.text)
            assert resultset.Result.size() == 1
            dest = new Destination()
            dest.lat = resultset.Result[0].latitude.toDouble()
            dest.lng = resultset.Result[0].longitude.toDouble()
            dest.radius = resultset.Result[0].radius.toDouble()
            dest.name = resultset.Result[0].name as String
            dest.city = resultset.Result[0].city as String
            dest.county = resultset.Result[0].county as String
            dest.state = resultset.Result[0].city as String
            dest.country = resultset.Result[0].country as String
            dest.woeid = resultset.Result[0].woeid.toInteger()
            dest.woetype = resultset.Result[0].woetype.toInteger()
        }
        else{
            log.error("Geocode FAILED")
            log.error(url)
            log.error(connection.responseCode)
            log.error(connection.responseMessage)
        }

        return dest
    }

    def autocomplete (String query){
        // http://where.yahooapis.com/v1/places$and(.q(denmark),.type(7,12));count=5?appid=A.LyjUnV34FSAwZsPYWUBhmQBP25VNzj4V13MIkmcLXLZSgn4C9ozPVQr7tRxK3Nrhu46g--
        def base = "http://where.yahooapis.com/v1/places"
        def appid = "appid=A.LyjUnV34FSAwZsPYWUBhmQBP25VNzj4V13MIkmcLXLZSgn4C9ozPVQr7tRxK3Nrhu46g--"
        def url = new URL(base + "\$and(.q(" + URLEncoder.encode(query) + "),.type(7,12));count=5?" + appid)

        def connection = url.openConnection()

        def results = []
        if(connection.responseCode == 200){
            def places = new XmlSlurper().parseText(connection.content.text)

            places.place.eachWithIndex{place, index->
                def result = [:]
                def value = [place.admin2.toString(), place.admin1.toString(), place.country.toString()]
                result.label = place.woeid as String
                value.each { val ->
                    if (!val.isEmpty()) {
                        if(result.value){
                            result.value = result.value + ", " + val
                        }
                        else {
                            result.value = val
                        }
                    }
                }
                results.add(result)
            }
        }
        else{
            log.error("Geocode FAILED")
            log.error(url)
            log.error(connection.responseCode)
            log.error(connection.responseMessage)
        }

        return results
    }

    def geochildren (String woeid){
        // http://where.yahooapis.com/v1/place/12593124/children?&appid=A.LyjUnV34FSAwZsPYWUBhmQBP25VNzj4V13MIkmcLXLZSgn4C9ozPVQr7tRxK3Nrhu46g--
        def base = "http://where.yahooapis.com/v1/place/"
        def appid = "appid=A.LyjUnV34FSAwZsPYWUBhmQBP25VNzj4V13MIkmcLXLZSgn4C9ozPVQr7tRxK3Nrhu46g--"
        def url = new URL(base + URLEncoder.encode(woeid) + "/children?" + appid)

        def connection = url.openConnection()

        def result = [:]
        if(connection.responseCode == 200){
            def places = new XmlSlurper().parseText(connection.content.text)
            assert places.place.size() >= 1
            result.type = places.place[0].placeTypeName as String
            result.name = places.place[0].name as String
            result.woeid = places.place[0].woeid as String
        }
        else{
            log.error("Geocode FAILED")
            log.error(url)
            log.error(connection.responseCode)
            log.error(connection.responseMessage)
        }

        return result
    }

    // http://ws.geonames.org/search?name_equals=den&fcode=airp&style=full
    def geocodeAirport(String iata) {
        def base = "http://ws.geonames.org/search?"
        def qs = []
        qs << "name_equals=" + URLEncoder.encode(iata)
        qs << "fcode=airp"
        qs << "style=full"
        def url = new URL(base + qs.join("&"))
        def connection = url.openConnection()

        def result = [:]
        if(connection.responseCode == 200){
            def xml = connection.content.text
            def geonames = new XmlSlurper().parseText(xml)
            result.name = geonames.geoname.name as String
            result.lat = geonames.geoname.lat as String
            result.lng = geonames.geoname.lng as String
            result.state = geonames.geoname.adminCode1 as String
            result.country = geonames.geoname.countryCode as String
        }
        else{
            log.error("GeocoderService.geocodeAirport FAILED")
            log.error(url)
            log.error(connection.responseCode)
            log.error(connection.responseMessage)
        }
        return result
    }
}
