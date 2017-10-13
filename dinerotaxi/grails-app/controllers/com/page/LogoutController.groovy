package com.page
import javax.servlet.http.Cookie
import javax.servlet.http.HttpSession

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.springframework.security.core.context.SecurityContextHolder

import ar.com.goliath.User
class LogoutController {
	def springSecurityService
	/**
	 * Index action. Redirects to the Spring security logout uri.
	 */

	//FacebookAuthUtils facebookAuthUtils
	def index = {
		// TODO  put any pre-logout code here
		//		Cookie cookie = facebookAuthUtils.getAuthCookie(request)
		//		if (cookie != null) {
		//			cookie.maxAge = 0
		//			cookie.path = '/'
		//			response.addCookie(cookie)
		//		}
		//		FacebookAuthUtils facebookAuthUtils
		//		def currentUser = currentUser()
		//		if(currentUser){
		//			def fb=FacebookUser.findByUser(currentUser)
		//			if(fb){
		//				//fb.delete()
		//			}
		//		}
		//
		//		// try to find facebook cookie
		//		def cookie33 = request.cookies.findAll {
		//				it.name.contains("fb")
		//			 }
		//		cookie33.each {
		//			def delCookie = new Cookie(it.name, null)
		//			delCookie.maxAge = 0
		//			delCookie.path = "/"
		//			response.addCookie(delCookie)
		//		}
		//
		//
		HttpSession session = request.getSession();
		if (session != null) {
			session.invalidate();
		}
		def cookie1 = new Cookie("JSESSIONID", null);
		cookie1.setPath(request.getContextPath());
		cookie1.setMaxAge(0);
		response.addCookie(cookie1);


		def cookie12 = new Cookie("fbsr_"+grailsApplication.config.grails.plugins.springsecurity.facebook.appId, null);
		cookie12.setPath(request.getContextPath());
		cookie12.setMaxAge(0);
		response.addCookie(cookie1);


		def cookie2 = new Cookie("ssc-ck", null);
		cookie2.setPath(request.getContextPath());
		cookie2.setMaxAge(0);
		response.addCookie(cookie2);




		SecurityContextHolder.clearContext();
		def cookie3 = request.cookies.find {
			it.name.contains("JSESSIONID")
		}
		if (cookie3) {
			def delCookie = new Cookie(cookie3.name, null)
			delCookie.maxAge = 0
			delCookie.path = "/"
			response.addCookie(delCookie)
		}


		redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl // '/j_spring_security_logout'
	}

	private currentUser(){
		if(springSecurityService?.principal==''){
			return User.get(springSecurityService.principal.id)
		}else{
			return null
		}
	}

}
