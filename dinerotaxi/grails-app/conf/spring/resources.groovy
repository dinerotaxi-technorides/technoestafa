
// Place your Spring DSL code here

import org.codehaus.groovy.grails.commons.GrailsApplication;
import org.codehaus.groovy.grails.plugins.springsecurity.*
import  org.springframework.security.web.authentication.rememberme.*
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import dinerotaxi.*
import org.springframework.security.web.authentication.rememberme.*
import org.springframework.security.web.authentication.rememberme.MyInMemoryTokenRepositoryImpl
beans = {
	myUserDetailsService(dinerotaxi.MyUserDetailsService)
	userDetailsService(dinerotaxi.MyUserDetailsService)
	tboCache(org.springframework.cache.ehcache.EhCacheFactoryBean){
		overflowToDisk=false
		diskPersistent=false
		timeToLive=10000
	}
	//	facebookAuthCookieLogout(FacebookAuthCookieLogoutHandler) {
	//		facebookAuthUtils = ref('facebookAuthUtils')
	//	}
	//	SpringSecurityUtils.registerLogoutHandler('facebookAuthCookieLogout')
	//
	//	def conf = SpringSecurityUtils.securityConfig
	//	 facebookAuthDao(FacebookDao) {
	//           domainClassName = conf.facebook.domain.classname
	//           connectionPropertyName = 'RealUser'
	//           userDomainClassName = 'ar.com.goliath.RealUser'
	//           rolesPropertyName = conf.userLookup.authoritiesPropertyName
	//       }
	localeResolver(org.springframework.web.servlet.i18n.SessionLocaleResolver) {
		defaultLocale = new Locale("es","ES")
		java.util.Locale.setDefault(defaultLocale)
	}
	

	//jmsConnectionFactory(org.springframework.jms.connection.SingleConnectionFactory) {
	//targetConnectionFactory = { org.apache.activemq.ActiveMQConnectionFactory cf ->
	//    brokerURL = 'vm://localhost'
	//  }
	//}

	//defaultJmsTemplate(org.springframework.jms.core.JmsTemplate) {
	//  connectionFactory = ref("jmsConnectionFactory")
	//}


	//jmsConnectionFactory(ActiveMQConnectionFactory) {
	//  brokerURL = "tcp://localhost:61616"
	//}
	//	userDetailsService(com.zub.security.EgUserDetailsService) {
	//		grailsApplication = ref('grailsApplication')
	//	 }
	//	 tokenRepository(com.zub.security.EgPersistentTokenRepository) {
	//		 grailsApplication = ref('grailsApplication')
	//	 }
	//
	//	 def conf = SpringSecurityUtils.securityConfig
	//	 rememberMeServices(PersistentTokenBasedRememberMeServices) {
	//		 userDetailsService = ref("userDetailsService")
	//		 key = conf.rememberMe.key
	//		 cookieName = conf.rememberMe.cookieName
	//		 alwaysRemember = conf.rememberMe.alwaysRemember
	//		 tokenValiditySeconds = conf.rememberMe.tokenValiditySeconds
	//		 parameter = conf.rememberMe.parameter
	//		 useSecureCookie = conf.rememberMe.useSecureCookie // false
	//
	//		 tokenRepository = ref('tokenRepository')
	//		 seriesLength = conf.rememberMe.persistentToken.seriesLength // 16
	//		 tokenLength = conf.rememberMe.persistentToken.tokenLength // 16
	//	 }
	def conf = SpringSecurityUtils.securityConfig
	rememberMeServices(MyPersistentTokenBasedRememberMeServices) {
		userDetailsService = ref('myUserDetailsService')
		key = conf.rememberMe.key
		cookieName = conf.rememberMe.cookieName
		alwaysRemember = conf.rememberMe.alwaysRemember
		tokenValiditySeconds = conf.rememberMe.tokenValiditySeconds
		parameter = conf.rememberMe.parameter
		useSecureCookie = conf.rememberMe.useSecureCookie // false

		tokenRepository = ref('tokenRepository')
		seriesLength = conf.rememberMe.persistentToken.seriesLength // 16
		tokenLength = conf.rememberMe.persistentToken.tokenLength // 16
	}
	springDineroTaxiUtils(dinerotaxi.MyUserDetailsService){
		
	}
	tokenRepository(MyInMemoryTokenRepositoryImpl) {
		grailsApplication = ref('grailsApplication')
	}
}

