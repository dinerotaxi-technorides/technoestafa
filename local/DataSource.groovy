dataSource {
    pooled = true
    driverClassName = "com.mysql.jdbc.Driver"
    username = "root"
    password = "root_beta"
	properties {
		maxActive = 50
		maxIdle = 25
		minIdle = 5
		initialSize = 5
		numTestsPerEvictionRun = 3
		testOnBorrow = true
		testWhileIdle = true
		testOnReturn = true
		validationQuery="SELECT 1 from dual"
		minEvictableIdleTimeMillis = 1800000
		timeBetweenEvictionRunsMillis = 1800000
	}
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class='org.hibernate.cache.EhCacheProvider'
    //cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
    //dialect = 'org.hibernate.dialect.Oracle10gDialect';
}
// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
             // url = "jdbc:mysql://localhost:3306/dtax?autoReconnect=true"
             url = "jdbc:mysql://54.91.10.244:3306/dtax_ci?autoReconnect=true"
        }
    }
    test {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
             url = "jdbc:mysql://dtax.cbuprwqrl306.sa-east-1.rds.amazonaws.com/dtax?autoReconnect=true"
        }
    }
    production {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
             url = "jdbc:mysql://polaris.cbuprwqrl306.sa-east-1.rds.amazonaws.com/dtax?autoReconnect=true"
        }
    }
}

