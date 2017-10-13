/* 
** Copyright 2011 3BaysOver.com
*/

package com

import grails.converters.*

class LookupTagLib {
	
  def userService
  def lookupService

  def lookupList = { attrs ->
      Lookupable lookupable = attrs.remove('lookupable')
      String realm = attrs.remove('realm')
      String facet = attrs.remove('facet')
      
      if(!lookupable){
          lookupable = userService.currentUser()
      }
      def list = lookupService.getValueList(realm, lookupable)

      out << "<dd>"
      list.eachWithIndex() { item, i ->
        def link = g.createLink(controller:'search', action:'search', params:['q':"+${facet?facet:realm}:${item.name}"])
        out << "<a href='${link}'>"
        out << item.name
        out << "</a>"
        if(i < list.size() - 1){
          out << ", "
        }
      }
      out << "</dd>"
  }
  
  def tagsList = { attrs ->
      org.grails.taggable.Taggable taggable = attrs.remove('taggable')
      
      if(!taggable){
          taggable = userService.currentUser()
      }
      def list = taggable.getTags()

      out << "<dd>"
      list.eachWithIndex() { item, i ->
        def link = g.createLink(controller:'search', action:'search', params:['q':'+tags:'+item])  
        out << "<a href='${link}'>"
        out << item
        out << "</a>"
        if(i < list.size() - 1){
          out << ", "
        }
      }
      out << "</dd>"
  }
  
  def lookupULList = { attrs ->
      Lookupable lookupable = attrs.remove('lookupable')
      String empty = attrs.remove('empty')
      String realm = attrs.remove('realm')
      
      if(!lookupable){
          lookupable = userService.currentUser()
      }
      def list = lookupService.getValueList(realm, lookupable)

      list.eachWithIndex() { item, i ->
        out << "<li>"
        out << item.name
        out << "</li>"
      }
      
      if(list.size==0){
        out << "<li class='" + empty + "'>"
        out << empty
        out << "</li>"      
      }
  }
  
  def lookupListJson = { attrs ->
      Lookupable lookupable = attrs.remove('lookupable')
      String realm = attrs.remove('realm')
      
      if(!lookupable){
          lookupable = userService.currentUser()
      }
      def res = lookupService.getValueList(realm, lookupable) as JSON
      out << res.toString().encodeAsHTML()
  }  
}

