/* Copyright 2006-2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.codehaus.groovy.grails.plugins.springsecurity;

import grails.util.Environment;
import groovy.lang.Closure;
import groovy.lang.GroovyClassLoader;
import groovy.util.ConfigObject;
import groovy.util.ConfigSlurper;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.servlet.Filter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.codehaus.groovy.grails.commons.GrailsApplication;
import org.springframework.security.access.hierarchicalroles.RoleHierarchy;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserCache;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.FilterChainProxy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.switchuser.SwitchUserFilter;
import org.springframework.security.web.authentication.switchuser.SwitchUserGrantedAuthority;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.util.StringUtils;
import ar.com.goliath.*


import org.codehaus.groovy.grails.commons.ApplicationHolder
import org.springframework.context.ApplicationContext
/**
 * Helper methods.
 *
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
import dinerotaxi.*
public final class SpringDineroTaxiUtils {
	
	
	
		private static ConfigObject _securityConfig;
		private static GrailsApplication _application;
		private static final Map<String, Object> _context = new HashMap<String, Object>();
		private static final String VOTER_NAMES_KEY = "VOTER_NAMES";
		private static final String PROVIDER_NAMES_KEY = "PROVIDER_NAMES";
		private static final String LOGOUT_HANDLER_NAMES_KEY = "LOGOUT_HANDLER_NAMES";
		private static final String ORDERED_FILTERS_KEY = "ORDERED_FILTERS";
		private static final String CONFIGURED_ORDERED_FILTERS_KEY = "CONFIGURED_ORDERED_FILTERS";
	
		@SuppressWarnings("unchecked")
		private static <T> T getBean(final String name) {
			return (T)_application.getMainContext().getBean(name);
		}
	
		/**
		 * Rebuild an Authentication for the given username and register it in the security context.
		 * Typically used after updating a user's authorities or other auth-cached info.
		 * <p/>
		 * Also removes the user from the user cache to force a refresh at next login.
		 *
		 * @param username the user's login name
		 * @param password optional
		 */
		public static void reauthenticate(final String username, final String password, final Long rtaxi) {
			
			def userDetailsService = ApplicationHolder.getApplication().getMainContext().getBean('myUserDetailsService');
			UserCache userCache =ApplicationHolder.getApplication().getMainContext().getBean('userCache'); 
			
			if(rtaxi==null){
				UserDetails userDetails = userDetailsService.loadUserByUsername(username);
				SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(
						userDetails, password == null ? userDetails.getPassword() : password, userDetails.getAuthorities()));
				userCache.removeUserFromCache(username);
				
			}else{
			UserDetails userDetails = userDetailsService.loadUserByUsername(username,rtaxi);
			SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(
					userDetails, password == null ? userDetails.getPassword() : password, userDetails.getAuthorities()));
			userCache.removeUserFromCache(username);
			}
		}
	
}
