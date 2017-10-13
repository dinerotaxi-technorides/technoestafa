package com.page.register

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
abstract class AbstractS2UiController1 {

	static allowedMethods = [save: 'POST', update: 'POST', delete: 'POST']
	static defaultAction = 'search'

	def grailsApplication
	def springSecurityService
	def springSecurityUiService

	protected boolean versionCheck(String messageCode, String messageCodeDefault, instance, model) {
		if (params.version) {
			def version = params.version.toLong()
			if (instance.version > version) {
				instance.errors.rejectValue('version', 'default.optimistic.locking.failure',
						[message(code: messageCode, default: messageCodeDefault)] as Object[],
						"Another user has updated this instance while you were editing")
				render view: 'edit', model: model
				return false
			}
		}
		true
	}

	protected void setIfMissing(String paramName, long valueIfMissing, Long max = null) {
		long value = (params[paramName] ?: valueIfMissing).toLong()
		if (max) {
			value = Math.min(value, max)
		}
		params[paramName] = value
	}

	protected String lookupUserClassName() {
		SpringSecurityUtils.securityConfig.userLookup.userDomainClassName
	}

	protected Class<?> lookupUserClass() {
		grailsApplication.getDomainClass(lookupUserClassName()).clazz
	}

	protected String lookupRoleClassName() {
		SpringSecurityUtils.securityConfig.authority.className
	}

	protected Class<?> lookupRoleClass() {
		grailsApplication.getDomainClass(lookupRoleClassName()).clazz
	}

	protected String lookupUserRoleClassName() {
		SpringSecurityUtils.securityConfig.userLookup.authorityJoinClassName
	}

	protected Class<?> lookupUserRoleClass() {
		grailsApplication.getDomainClass(lookupUserRoleClassName()).clazz
	}

	protected String lookupRequestmapClassName() {
		SpringSecurityUtils.securityConfig.requestMap.className
	}

	protected Class<?> lookupRequestmapClass() {
		grailsApplication.getDomainClass(lookupRequestmapClassName()).clazz
	}
}
