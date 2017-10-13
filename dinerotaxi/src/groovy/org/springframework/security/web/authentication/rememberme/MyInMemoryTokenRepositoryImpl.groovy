package org.springframework.security.web.authentication.rememberme;



import org.codehaus.groovy.grails.commons.GrailsApplication
import org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.codehaus.groovy.grails.plugins.springsecurity.*
import java.util.Date;

import org.codehaus.groovy.grails.commons.GrailsApplication
import org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository
import org.slf4j.Logger
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.slf4j.LoggerFactory
class MyInMemoryTokenRepositoryImpl  {

	private final Logger log = LoggerFactory.getLogger(MyInMemoryTokenRepositoryImpl.class)

	/** Dependency injection for grailsApplication */
	GrailsApplication grailsApplication

	/**
	 * {@inheritDoc}
	 * @see org.springframework.security.web.authentication.rememberme.PersistentTokenRepository#createNewToken(
	 * 	org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken)
	 */
	void createNewToken(MyPersistentRememberMeToken token) {
		// join an existing transaction if one is active
		def clazz = lookupDomainClass()
		if (!clazz) return

		clazz.withTransaction { status ->
			clazz.newInstance(username: token.username, series: token.series,
					token: token.tokenValue, lastUsed: token.date,rtaxi:token.rtaxi).save(flush:true)
		}
	}

	/**
	 * {@inheritDoc}
	 * @see org.springframework.security.web.authentication.rememberme.PersistentTokenRepository#getTokenForSeries(
	 * 	java.lang.String)
	 */
	MyPersistentRememberMeToken getTokenForSeries(String seriesId) {
		def persistentToken
		def clazz = lookupDomainClass()
		if (clazz) {
			persistentToken = clazz.get(seriesId)
		}
		if (!persistentToken) {
			return null
		}

		return new MyPersistentRememberMeToken(persistentToken.username, persistentToken.series,
				persistentToken.token, persistentToken.lastUsed,persistentToken.rtaxi)
	}

	/**
	 * {@inheritDoc}
	 * @see org.springframework.security.web.authentication.rememberme.PersistentTokenRepository#removeUserTokens(
	 * 	java.lang.String)
	 */
	void removeUserTokens(String username,Long rtaxi) {
		def clazz = lookupDomainClass()
		if (!clazz) return

		// join an existing transaction if one is active
		clazz.withTransaction { status ->
			// was using HQL but it breaks with NoSQL, so using a less efficient impl:
			for (instance in clazz.findAllByUsernameAndRtaxi(username,rtaxi)) {
				instance.delete()
			}
		}
	}

	/**
	 * {@inheritDoc}
	 * @see org.springframework.security.web.authentication.rememberme.PersistentTokenRepository#updateToken(
	 * 	java.lang.String, java.lang.String, java.util.Date)
	 */
	void updateToken(String series, String tokenValue, Date lastUsed,Long rtaxi) {
		def clazz = lookupDomainClass()
		if (!clazz) return

		// join an existing transaction if one is active
		clazz.withTransaction { status ->
			def persistentLogin = clazz.get(series)
			persistentLogin?.token = tokenValue
			persistentLogin?.lastUsed = lastUsed
		}
	}

	protected Class lookupDomainClass() {
		def conf = SpringSecurityUtils.securityConfig
		String domainClassName = conf.rememberMe.persistentToken.domainClassName ?: ''
		def clazz = grailsApplication.getClassForName(domainClassName)
		if (!clazz) {
			log.error "Persistent token class not found: '${domainClassName}'"
		}
		clazz
	}
}
