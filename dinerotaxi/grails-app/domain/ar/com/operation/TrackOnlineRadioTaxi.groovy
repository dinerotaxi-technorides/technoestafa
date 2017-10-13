package ar.com.operation
class TrackOnlineRadioTaxi {
	OnlineRadioTaxi onlineRTaxi
	OFStatus status
	Date createdDate
	def beforeInsert = { createdDate = new Date() }
	static constraints = {
		createdDate(nullable:true,blank:true)
	}
}