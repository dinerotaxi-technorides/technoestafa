/* 
** Copyright 2011 3BaysOver.com
*/

package com

import grails.converters.*

class StringAttributeTagLib {
	
  def lookupService
  def springSecurityService
  def stringAttributeList = { attrs ->
      Lookupable ref = attrs.remove('ref')
      String type = attrs.remove('type')
      String clasz = attrs.remove('class')
      
      if(!ref){
          ref =springSecurityService.currentUser
      }
      def list = ref.getStringAttributes(type)

      if(list.size()>0){
        out << "<ul class='" + clasz + "'>"
        list.eachWithIndex() { item, i ->
          out << "<li>"
          out << item.value
          out << "</li>"
        }
        out << "</ul>"
      }
      else{
        out << "<p class='editable'>Click here to edit</p>"
      }
  }  

  def hasStringAttributes = { attrs, body ->
      Lookupable ref = attrs.remove('ref')
      String type = attrs.remove('type')
      String editable = attrs.remove('editable')

      if(editable == "editable"){
        out << body()
      }
      else{      
        def list = ref.getStringAttributes(type)
        if(list.size()>0){
          out << body()
        }
      }
  }  

}
