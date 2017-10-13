package dinerotaxi

import org.codehaus.groovy.grails.plugins.springsecurity.GrailsUser 
import org.codehaus.groovy.grails.plugins.springsecurity.GrailsUserDetailsService 
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils 
import org.springframework.security.core.authority.GrantedAuthorityImpl 
import org.springframework.security.core.userdetails.UserDetails 
import org.springframework.security.core.userdetails.UsernameNotFoundException
import ar.com.goliath.User
import ar.com.goliath.MyUserDetails
class MyUserDetailsService implements GrailsUserDetailsService {

	/** * Some Spring Security classes (e.g. RoleHierarchyVoter) expect at least * one role, so we give a user with no granted 
	 * roles this one which gets * past that restriction but doesn't grant anything. */ 
	static final List NO_ROLES = [new GrantedAuthorityImpl(SpringSecurityUtils.NO_ROLE)]
	
	UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		return loadUserByUsername(username,null)
	}
	UserDetails loadUserByUsername(String username, boolean loadRoles) throws UsernameNotFoundException {
		return loadUserByUsername(username,null)
	}
	UserDetails loadUserByUsernameAndRtaxi(String username,Long rtaxi) throws UsernameNotFoundException {
		return loadUserByUsername(username,rtaxi)
	}
	UserDetails loadUserByUsernameAndRtaxi(String username,Long rtaxi, boolean loadRoles) throws UsernameNotFoundException {
		return loadUserByUsername(username,rtaxi)
	}
	UserDetails loadUserByUsername(String username,Long rtaxi) throws UsernameNotFoundException {

		User.withTransaction {
			status ->
			
			User user = null
			if(rtaxi==null){
				user=User.findByUsernameAndRtaxiIsNull(username)
			}else{
				User rtaxiUser = User.get(rtaxi)
				user=User.findByUsernameAndRtaxi(username,rtaxiUser)
			
			}
			
			if (!user) throw new UsernameNotFoundException( 'User not found', username)

			def authorities = user.authorities.collect {
				new GrantedAuthorityImpl(it.authority)
			}

			return new MyUserDetails(user.username, user.password, user.enabled, !user.accountExpired, !user.passwordExpired, !user.accountLocked, authorities ?: NO_ROLES, user.id, user.firstName + " " + user.lastName)
		}
	}
}