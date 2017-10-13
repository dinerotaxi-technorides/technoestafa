def ENV_NAME = "GRAILS_PROP"
if(!grails.config.locations || !(grails.config.locations instanceof List)) {
	grails.config.locations = [ ]
}

println "-----------------------------------------------------------------------"
println System.getenv(ENV_NAME)
println System.getProperty(ENV_NAME)
println "-----------------------------------------------------------------------"

if(System.getenv(ENV_NAME)) {
	
	grails.config.locations << "file:"+System.getenv(ENV_NAME)+ "/Config.groovy"
	grails.config.locations << "file:"+System.getenv(ENV_NAME)+ "/DataSource.groovy"
} else if(System.getProperty(ENV_NAME)) {
	grails.config.locations << "file:"+System.getProperty(ENV_NAME)+ "/Config.groovy"
	grails.config.locations << "file:"+System.getProperty(ENV_NAME)+ "/DataSource.groovy"
	
} else {
}
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
