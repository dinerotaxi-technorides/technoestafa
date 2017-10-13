/* Copyright 2011 3BaysOver
 */
package com

import ar.com.goliath.Place
import ar.com.goliath.RealUser
import grails.converters.*

class PlaceTagLib {
	def springSecurityService
	static namespace = "place"
	
  def destinationList = { attrs ->
    def comp = attrs.remove('comp')
    
    if(!comp){
        comp = springSecurityService.currentUser
    }
    def list = comp.places

    out << "<dd>"
    list.eachWithIndex() { item, i ->
      out << place.address(place:item)
      if(i < list.size() - 1){
        out << "<br/>"
      }
    } 
    out << "</dd>"
  }
  
  def address = { attrs ->
    Place place = attrs.remove('place')
    if(!place){
        out << ""
        return
    }
    switch(place.type){
      case "locality":
      case "point_of_interest":
//        def link_text = solrService.createSearchLink("text", place.name)
			def link_text =""
        out << "<a href='${link_text}'>${place.name}</a>"
        break
      case "street_address":
        if(place.country){
//          def link_country = solrService.createSearchLink("country", place.country)
			def link_country =""
          out << "<a href='${link_country}'>${place.country}</a>"
        }
        if(place.locality){
//          def link_city = solrService.createSearchLink("city", place.locality)
			def link_city =""
          out << ", <a href='${link_city}'>${place.locality}</a>"    
        }
        break
      default:
//        def link_text = solrService.createSearchLink("text", place.name)
			def link_text =""
        out << "<a href='${link_text}'>${place.name}</a>"
        break
    }
  }
  
  def destinationListJson = { attrs ->
    def comp = attrs.remove('comp')
    if(!comp){
        comp =springSecurityService.currentUser
    }
    def list = []
    comp.places.each{
       def map = [:]
       map.id = it.json
       map.name = it.name
       list.add(map)
    }
    def res = list as JSON
    out << res.toString().encodeAsHTML()
  }    
  
  
  def destinationList1 = { attrs ->
	  def comp = attrs.remove('comp')

	  if(!comp){
		  comp = springSecurityService.currentUser
	  }
	  def list = comp.places

	  
	  list.eachWithIndex() { item, i ->
		  out << "<div>"
		  out << place.address1(place:item)
		  if(i < list.size() - 1){
			  out << "<br/>"
		  }
		  
		  out << "</div>"
	  }
  }
  def address1 = { attrs ->
	  Place place = attrs.remove('place')
	  if(!place){
		  out << ""
		  return
	  }
	  switch(place.type){
		  case "locality":
		  case "point_of_interest":
		  //        def link_text = solrService.createSearchLink("text", place.name)
			  def link_text =""
			  out << "<a href='${link_text}'>${place.name}</a>"
			  break
		  case "street_address":
			  if(place.name){
				  def link_city =place.name.split(",")
				  def l1=link_city[0] + "," + link_city[2]
				  String a=  '"onClick=confirmDelete("'+l1+'",'+place.id+');"'
//				  def bar = "' onClick='confirmDelete(\"xss\")'"
				  def bar = "' onmouseover='alert(\"xss\")'"
				  out << "<a href=\"#\" onClick=\"confirmPedir('${l1}',${place.id});\">${l1.encodeAsHTML()}</a>"

				   //<<bar.encodeAsHTML()<<'>'+l1.encodeAsHTML()+' </a>'
			  }else{
				  if(place.country){
					  //          def link_country = solrService.createSearchLink("country", place.country)
					  def link_country =place.country

					  out << "<a href='${link_country}'>${place.country}</a>"
				  }
				  if(place.locality){
					  //          def link_city = solrService.createSearchLink("city", place.locality)
					  def link_city =place.locality
					  out << ", <a href='${link_city}'>${place.locality}</a>"
				  }
			  }
			  break
		  default:
		  //        def link_text = solrService.createSearchLink("text", place.name)
			  def link_text =place.name
			  out << "<a href='${link_text}'>${place.name}</a>"
			  break
	  }
  }
  def destinationListJson1 = { attrs ->
	  def comp = attrs.remove('comp')
	  if(!comp){
		  comp =springSecurityService.currentUser
	  }
	  def list = []
	  comp.places.each{
		 def map = [:]
		 map.id = it.json
		 map.name = it.name
		 list.add(map)
	  }
	  def res = list as JSON
	  out << res.toString().encodeAsHTML()
	}
}

