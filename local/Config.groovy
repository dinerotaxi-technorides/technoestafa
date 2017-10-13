// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

import org.apache.log4j.*
import grails.plugins.springsecurity.SecurityConfigType
import org.springframework.security.authentication.RememberMeAuthenticationToken
forkConfig = [maxMemory: 2020, minMemory: 400, debug: true, maxPerm: 1000]
grails.project.fork = [
  test: forkConfig, // configure settings for the test-app JVM
  run: forkConfig, // configure settings for the run-app JVM
  war: forkConfig, // configure settings for the run-war JVM
  console: forkConfig // configure settings for the Swing console JVM ]
]


grails.project.groupId = DineroTaxi // change this to alter the default package name and Maven publishing destination

System.properties["${appName}.config.location"]

grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false


grails.mime.types = [
    all:           '*/*',
    atom:          'application/atom+xml',
    css:           'text/css',
    csv:           'text/csv',
    form:          'application/x-www-form-urlencoded',
    html:          ['text/html','application/xhtml+xml'],
    js:            'text/javascript',
    json:          ['application/json', 'text/json'],
    multipartForm: 'multipart/form-data',
    rss:           'application/rss+xml',
    text:          'text/plain',

    xml:           ['text/xml', 'application/xml']
]


// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// What URL patterns should be processed by the resources plugin
grails.resources.adhoc.patterns = ['/images/*', '/css/*', '/js/*', '/plugins/*']

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'
sendgrid {
    username = 'mbaglieri'
    password = 'dTaxi021'
}
// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart=false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false
grails.app.context = "/"
environments {
    development {
        apiConnection.useSession = true
        apiHost = "10.10.44.9"
        apiPort = "8889"
        apiPath = "/"
        socket="http://localhost:2001/"
        grails.logging.jul.usebridge = true
        grails.serverURL = "http://localhost:8080"
        run_job =true
        restCreateTrip=true
    }
    production {
        grails.logging.jul.usebridge = false
        uiperformance.enabled = false
        apiConnection.maxConnections = 150
        apiConnection.useSession = true
        apiHost = "54.235.157.55"
        apiPort = "8889"
        apiPath = "/"
        socket="http://localhost:2001/"
        grails.serverURL = "http://localhost:8080/dinerotaxi"
        run_job = true
    }
}

// log4j configuration
  log4j = {
        appenders {
            rollingFile name: 'fileLog',
            file: 'logs/full.log',
            maxFileSize: 26214400,
            maxBackupIndex: 10,
            layout: pattern(conversionPattern: '%d{yyyy-MM-dd HH:mm:ss,SSS} %p %c{2} %m%n')
        }
        root {
             error()
             additivity = true
        }

   // debug fileLog:'grails.app'
   //,'org.springframework.security'

    warn 'org.mortbay.log'
  error  'org.codehaus.groovy.grails.web.servlet',        // controllers
       'org.codehaus.groovy.grails.web.pages',          // GSP
       'org.codehaus.groovy.grails.web.sitemesh',       // layouts
       'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
       'org.codehaus.groovy.grails.web.mapping',        // URL mapping
       'org.codehaus.groovy.grails.commons',            // core / classloading
       'org.codehaus.groovy.grails.plugins',            // plugins
       'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
       'org.springframework',
       'org.hibernate',
       'net.sf.ehcache.hibernate'
}

grails {
          mail {
                  host = "smtp.gmail.com"
                  port = 465
                  username = "rrhh@dinerotaxi.com"
                  password = "2GB>=g495bA"
                  props = ["mail.smtp.auth":"true",
                                          "mail.smtp.socketFactory.port":"465",
                                          "mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",
                                          "mail.smtp.socketFactory.fallback":"false"]
          }
  }
fileuploader {
 avatar {
                maxSize = 1024 * 256 //256 kbytes
                allowedExtensions = ["jpg", "jpeg", "gif", "png"]
                path = "/tmp/avatar/"
        }
        docs {
                maxSize = 1000 * 1024 * 4 //4 mbytes
                allowedExtensions = ["doc", "docx", "pdf", "rtf"]
                path = "/tmp/docs/"
        }
}
grails.mail.default.from="info@dinerotaxi.com"


//grails.plugins.springsecurity.rejectIfNoRule = false
grails.plugins.springsecurity.active=true
grails.plugins.springsecurity.password.algorithm='SHA-256'
grails.plugins.springsecurity.anon.userAttribute = 'sss, ROLE_ANONYMOUS'
// Added by the Spring Security Core plugin:
grails.plugins.springsecurity.userLookup.userDomainClassName = 'ar.com.goliath.User'
grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'ar.com.goliath.UserRole'
grails.plugins.springsecurity.authority.className = 'ar.com.goliath.Role'
grails.plugins.springsecurity.requestMap.className = 'ar.com.goliath.Requestmap'
grails.plugins.springsecurity.securityConfigType = grails.plugins.springsecurity.SecurityConfigType.Requestmap
//token
grails.plugins.springsecurity.useBasicAuth = true
grails.plugins.springsecurity.basic.realmName = "DINEROTAXI API"
grails.plugins.springsecurity.filterChain.chainMap = [
    '/api/**': 'JOINED_FILTERS,-exceptionTranslationFilter',
    '/**': 'JOINED_FILTERS,-basicAuthenticationFilter,-basicExceptionTranslationFilter' ]
grails.plugins.springsecurity.useSessionFixationPrevention = true
grails.plugins.springsecurity.rememberMe.persistent = true
grails.plugins.springsecurity.rememberMe.persistentToken.domainClassName = 'ar.com.goliath.PersistToken'
grails.plugins.springsecurity.rememberMe.cookieName='dinerotaxi'
grails.plugins.springsecurity.rememberMe.alwaysRemember=true
grails.plugins.springsecurity.rememberMe.tokenValiditySeconds=1209600
grails.plugins.springsecurity.rememberMe.parameter='_spring_security_remember_me'
grails.plugins.springsecurity.rememberMe.key='grails222Rocks'
grails.plugins.springsecurity.rememberMe.useSecureCookie=true
grails.plugins.springsecurity.rememberMe.rememberMe.persistent = false
grails.plugins.springsecurity.rememberMe.persistentToken.seriesLength=16
grails.plugins.springsecurity.rememberMe.persistentToken.tokenLength=16
grails.plugins.springsecurity.atr.rememberMeClass=RememberMeAuthenticationToken
grails.plugins.springsecurity.providerNames = ['daoAuthenticationProvider', 'rememberMeAuthenticationProvider']
grails.plugins.springsecurity.logout.handlerNames = ['rememberMeServices', 'securityContextLogoutHandler']//, 'myLogoutHandler']

//user exeption loked expired etc
grails.plugins.springsecurity.failureHandler.exceptionMappings = [
        'org.springframework.security.authentication.LockedException':             '/account/accountLocked',
        'org.springframework.security.authentication.DisabledException':           '/account/accountDisabled',
        'org.springframework.security.authentication.AccountExpiredException':     '/account/accountExpired',
        'org.springframework.security.authentication.CredentialsExpiredException': '/account/passwordExpired'
 ]

//Cache user
grails.plugins.springsecurity.cacheUsers=true
//facebook
grails.plugins.springsecurity.facebook.domain.classname='ar.com.goliath.FacebookUser'
grails.plugins.springsecurity.facebook.appId='232931593411843'
grails.plugins.springsecurity.facebook.secret='9fabaf850410c550f0a04ebcceb518ad'



grails.plugins.activemq.port=7892
grails.plugins.activemq.useJmx=true

app.android='https://play.google.com/store/apps/details?id=com.dinerotaxi.android.pasajero'
app.ios='http://itunes.apple.com/es/app/dinerotaxi/id561564267?mt=8&ign-mpt=uo%3D2'
app.blackberry='http://appworld.blackberry.com/webstore/content/123843/'
googleapi.url.json = 'http://maps.googleapis.com/maps/api/geocode/json?sensor=true&language=es&address='

countries=['/ar','/pe','/mx','/']




android.gcm.api.key = 'AIzaSyD-IDLVq6xgDx6jI-Hf3nXeSVrALTsj6SQ'
android.gcm.time.to.live=1419200
android.gcm.delay.'while'.idle=false
android.gcm.retries=3
server.timezone='America/Buenos_Aires'
cloudmade.url.json='http://geocoding.cloudmade.com/c01914ea8a854c71a53966e51e383fd5/geocoding/v2/find.js?query='
create.trip.generic='{"name":"#STREET# #NUMBER#,#CITY#,#COUNTRY#","lat":#LAT#,"lng":#LNG#,"northEastLatBound":-34.5627767697085,"northEastLngBound":-58.47518266970849,"southWestLatBound":-34.5654747302915,"southWestLngBound":-58.47788063029145,"country":"#COUNTRY#","countryCode":"#SCOUNTRY#","locality":"#CITY#","admin2Code":"","admin3Code":"","street":"#STREET#","streetNumber":"#NUMBER#","postalCode":"","locationType":"RANGE_INTERPOLATED","type":"street_address","latlng":{"$a":-34.5641195,"ab":-58.476537199999996},"viewport":{"aa":{"b":-34.5654747302915,"j":-34.5627767697085},"ba":{"b":-58.47788063029145,"j":-58.47518266970849}}}'
googleapi.generic='{"address_components":[{"long_name":"#NUMBER#","types":["street_number"],"short_name":"#NUMBER#"},{"long_name":"#STREET#","types":["route"],"short_name":"#STREET#"},{"long_name":"#CITY#","types":["neighborhood","political"],"short_name":"#CITY#"},{"long_name":"#CITY#","types":["locality","political"],"short_name":"CF"},{"long_name":"#CITY#","types":["administrative_area_level_1","political"],"short_name":"#CITY#"},{"long_name":"#COUNTRY#","types":["country","political"],"short_name":"#SCOUNTRY#"}],"postcode_localities":[],"formatted_address":"#STREET# #NUMBER#, #CITY#,#COUNTRY#","types":["street_address"],"geometry":{"bounds":{"southwest":{"lng":#LNG#,"lat":#LAT#},"northeast":{"lng":#LNG#,"lat":#LAT#}},"viewport":{"southwest":{"lng":#LNG#,"lat":#LAT#},"northeast":{"lng":#LNG#,"lat":#LAT#}},"location_type":"RANGE_INTERPOLATED","location":{"lng":#LNG#,"lat":#LAT#}}}'
googleapi.peru='{"address_components":[{"long_name":"#NUMBER#","types":["street_number"],"short_name":"#NUMBER#"},{"long_name":"#STREET#","types":["route"],"short_name":"#STREET#"},{"long_name":"Lima","types":["neighborhood","political"],"short_name":"Lima"},{"long_name":"Lima","types":["locality","political"],"short_name":"CF"},{"long_name":"Lima","types":["administrative_area_level_1","political"],"short_name":"Lima"},{"long_name":"Perú","types":["country","political"],"short_name":"PE"}],"postcode_localities":[],"formatted_address":"#STREET# #NUMBER#, Lima,Perú","types":["street_address"],"geometry":{"bounds":{"southwest":{"lng":-58.43600929999999,"lat":-34.5692129},"northeast":{"lng":-58.43599859999999,"lat":-34.5692005}},"viewport":{"southwest":{"lng":-58.4373529302915,"lat":-34.5705556802915},"northeast":{"lng":-58.43465496970849,"lat":-34.5678577197085}},"location_type":"RANGE_INTERPOLATED","location":{"lng":-58.43599859999999,"lat":-34.5692005}}}'
