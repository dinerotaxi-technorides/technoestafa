package ar.com.goliath

import org.codehaus.groovy.grails.plugins.springsecurity.GrailsUser

import org.springframework.security.core.GrantedAuthority 
import org.springframework.security.core.userdetails.User

class MyUserDetails extends GrailsUser {

	final String fullName
	final Long rtaxi
	MyUserDetails(String username,Long rtaxi, String password,
		 boolean enabled, boolean accountNonExpired, boolean credentialsNonExpired,
		  boolean accountNonLocked, Collection<GrantedAuthority> authorities, long id, 
		  String fullName) {
		super(username, password, enabled, accountNonExpired, 
			credentialsNonExpired, accountNonLocked, authorities, id)
		this.rtaxi=rtaxi
		this.fullName = fullName
	}
	  MyUserDetails(String username, String password,
		  boolean enabled, boolean accountNonExpired, boolean credentialsNonExpired,
		   boolean accountNonLocked, Collection<GrantedAuthority> authorities, long id,
		   String fullName) {
		 super(username, password, enabled, accountNonExpired,
			 credentialsNonExpired, accountNonLocked, authorities, id)
		 this.fullName = fullName
	 }
}