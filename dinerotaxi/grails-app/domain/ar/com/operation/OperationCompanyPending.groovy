package ar.com.operation
import com.Product
import ar.com.goliath.CompanyAccountEmployee

class OperationCompanyPending extends Operation {
	//import org.codehaus.groovy.grails.commons.DefaultGrailsDomainClass
	//	public OperationPending(OperationHistory orig){
	//		def d = new DefaultGrailsDomainClass(OperationHistory.class)
	//		d.persistentProperties.each { val ->
	//			this[val.name] = orig[val.name]
	//		}
	//	}
	
	def beforeInsert = {
		createdDate = new Date()
		enabled=true
		isCompanyAccount=true
	}
}