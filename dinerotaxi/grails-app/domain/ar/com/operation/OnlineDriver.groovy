package ar.com.operation
import ar.com.goliath.*

class OnlineDriver{
	EmployUser driver
	Company company
	FStatus status=FStatus.ONLINE
	Float lat
	Float lng
	String driverVersion
	String driverCode
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	def beforeUpdate = {
		lastModifiedDate = new Date()
	}
	static constraints = {
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		company(nullable:true,blank:true)
		driverVersion(nullable:true,blank:true)
		driverCode(nullable:true,blank:true)
        lat (nullable:true)
        lng (nullable:true)
	}
	
}
public enum FStatus{
	ONLINE,OFFLINE,BLOCKED,INTRAVEL,DISCONNECTED
}