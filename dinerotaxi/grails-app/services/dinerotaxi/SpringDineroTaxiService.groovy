package dinerotaxi

import javax.servlet.http.HttpServletRequest

import org.codehaus.groovy.grails.plugins.springsecurity.SpringDineroTaxiUtils
import org.springframework.security.core.Authentication
import org.springframework.security.core.context.SecurityContextHolder as SCH
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource
import grails.plugins.springsecurity.SpringSecurityService
import ar.com.goliath.*
class SpringDineroTaxiService extends SpringSecurityService{
	
	Authentication getAuthentication() { SCH.context?.authentication }

	
	static transactional = false
   
	/**
	 * Rebuild an Authentication for the given username and register it in the security context.
	 * Typically used after updating a user's authorities or other auth-cached info.
	 * <p/>
	 * Also removes the user from the user cache to force a refresh at next login.
	 *
	 * @param username the user's login name
	 * @param password optional
	 */
	void reauthenticate(String username, String password = null,User rtaxi = null) {
		
		if(rtaxi==null){
			SpringDineroTaxiUtils.reauthenticate username, password,null
		}else{
			SpringDineroTaxiUtils.reauthenticate username, password,rtaxi.id
		}
										
	}
}
