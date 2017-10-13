/* Copyright 2011 3BaysOver
 */
package com
import ar.com.goliath.User
import ar.com.goliath.Place
import ar.com.goliath.RealUser
import grails.converters.*

class SpringTagLib {
	def springSecurityService
	static namespace = "sprr"


	def fullInfo = { attrs ->
		def principal = springSecurityService.principal
		if(principal instanceof ar.com.goliath.FacebookUser){
			def usr = User.findByUsername(principal.user.username)
			StringBuilder bui=new StringBuilder();
			bui.append(usr?.firstName?:"")
			bui.append(" 1")
			bui.append(usr?.lastName?:"")
			out << bui.toString().substring(0, bui.toString().length() < 13 ?bui.toString().length():13)
		}else{
			def usr = User.findByUsername(principal.username)
			StringBuilder bui=new StringBuilder();
			bui.append(usr?.firstName?:"")
			bui.append(" ")
			bui.append(usr?.lastName?:"")
			out << bui.toString().substring(0, bui.toString().length()< 13 ?bui.toString().length():13)
		}
	}

	def fullInfoCompany= { attrs ->
		def principal = springSecurityService.principal
		if(principal?.username){
			def usr = User.findByUsername(principal?.username)
			StringBuilder bui=new StringBuilder();
			bui.append(usr?.companyName?:"")
			out << bui.toString().substring(0, bui.toString().length()< 13 ?bui.toString().length():13)
		}else{
			out << ""
		}
	}
}


