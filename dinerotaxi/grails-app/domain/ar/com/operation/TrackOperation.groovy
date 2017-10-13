package ar.com.operation

import java.util.Date;
import ar.com.goliath.EmployUser
class TrackOperation {
	OnlineRadioTaxi onlineRTaxi
	TRANSACTIONSTATUS status
	Operation operation
	Long timeTravel
	EmployUser taxista
	boolean isCompanyAccount
	String comment
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }
	static constraints = {
		createdDate(nullable:true,blank:true)
		timeTravel(nullable:true,blank:true)
		taxista(nullable:true,blank:true)
		comment(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		onlineRTaxi(nullable:true,blank:true)
	}
}