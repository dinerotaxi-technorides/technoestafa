grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.servlet.version = "2.5"
//grails.project.war.file = "target/${appName}-${appVersion}.war"
forkConfig = [maxMemory: 2024, minMemory: 264, debug: false, maxPerm: 556]
grails.project.fork = [
	test: forkConfig, // configure settings for the test-app JVM
	run: forkConfig, // configure settings for the run-app JVM
	war: forkConfig, // configure settings for the run-war JVM
	console: forkConfig // configure settings for the Swing console JVM
]
grails.project.dependency.resolution = {
	// inherit Grails' default dependencies
	inherits("global") {
		//runtime 'net.sf.ehcache:ehcache-core:2.4.3'
		// uncomment to disable ehcache
		// excludes 'ehcache'
	}
	log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
	repositories {
		grailsPlugins()
		grailsHome()
		grailsCentral()

		// uncomment the below to enable remote dependency resolution
		// from public Maven repositories
		mavenLocal()
		mavenCentral()
		mavenRepo "http://snapshots.repository.codehaus.org"
		mavenRepo "http://repository.codehaus.org"
		mavenRepo "http://download.java.net/maven/2/"
		mavenRepo "http://repository.jboss.com/maven2/"
		mavenRepo "https://github.com/slorber/gcm-server-repository/raw/master/releases"
		mavenRepo "http://repo.grails.org/grails/core"
    mavenRepo "http://repo.grails.org/grails/plugins"
	}
	grails.war.resources = { stagingDir ->
		delete(file:"${stagingDir}/WEB-INF/lib/slf4j-api-1.5.2.jar")
	}

	dependencies {
		// specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.
		runtime 'mysql:mysql-connector-java:5.1.13'
		compile 'org.codehaus.jackson:jackson-jaxrs:1.8.5'
		compile 'org.apache.httpcomponents:httpclient:4.1.2'
		compile 'log4j:log4j:1.2.13'
		compile "net.sf.ehcache:ehcache-core:2.4.6"
		compile 'org.springframework:spring-jms:3.2.4.RELEASE'
		//compile 'javax.mail:mail:1.4'
		compile 'org.springframework.social:spring-social-core:1.0.1.RELEASE'
		compile 'org.springframework.social:spring-social-facebook:1.0.1.RELEASE'

		compile 'org.json:json:20090211'
		runtime 'com.googlecode.json-simple:json-simple:1.1'

		compile 'com.google.android.gcm:gcm-server:1.0.2'
		compile 'com.googlecode.javapns:javapns-jdk16:167'
		//grails install-dependency com.googlecode.javapns:javapns-jdk16:165 --dir=lib
		//for install dependency
		//mvn install:install-file -Dfile=/Users/carlosmatiasbaglieri/workspace/perser/DineroTaxi/2.0/dinerotaxi/lib/javapns-jdk16-167.jar -DgroupId=com.googlecode.javapns -DartifactId=javapns-jdk16 -Dversion=165 -Dpackaging=jar -DgeneratePom=true
		//		compile ":spring-security-facebook:0.6.2"
		//		compile 'org.apache.activemq:activemq-all:5.5.0'
		//		compile 'org.apache.activemq:activemq-core:5.5.0'
		//		compile 'org.slf4j:jul-to-slf4j:1.5.8'
		//		warn 'org.grails.plugins:goliath:0.5'
	}

	plugins {
		compile ":crypto:2.0"
		runtime ':sendgrid:0.2'
		compile ":rest:0.7"
		compile ":jqgrid:3.8.0.1"
		compile ':mail:1.0', { excludes 'spring-test' }
		// plugins for the build system only
		build ":tomcat:7.0.42"
		// plugins for the compile step
		compile ":scaffolding:2.0.0"
		compile ':cache:1.1.1'
		compile ":joda-time:1.4"
		runtime ":cors:1.1.2"
		// plugins needed at runtime but not for compilation
		runtime ":hibernate:3.6.10.1" // or ":hibernate4:4.1.11.1"
		runtime ":database-migration:1.3.5"
		runtime ":jquery:1.10.2"
		runtime ":resources:1.2"
		runtime ':fbootstrapp:0.1.1'
		compile ':spring-security-core:1.2.7.3'
		// Uncomment these (or add new ones) to enable additional resources capabilities
		//runtime ":zipped-resources:1.0"
		//runtime ":cached-resources:1.0"
		//runtime ":yui-minify-resources:0.1.4"
		runtime ":database-migration:1.2.1"
	}
}
