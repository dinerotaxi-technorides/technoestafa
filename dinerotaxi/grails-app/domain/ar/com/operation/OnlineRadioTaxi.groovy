package ar.com.operation
import ar.com.goliath.Company
import ar.com.goliath.EmployUser
class OnlineRadioTaxi implements Comparable<OnlineRadioTaxi>{
	Company company
	EmployUser operator
	OFStatus status=OFStatus.ONLINE
	Long position
	Long penality
	Long countTaxi
	Long countTrips
	Long tripSucess
	Long tripCalification
	Long tripFail
	Long countRejectTrip
	Long countTimeOut
	Long timeEffort
	boolean isTestUser=false
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
	}
	def beforeUpdate = { lastModifiedDate = new Date() }
	static constraints = {
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		position(nullable:true,blank:true)
		penality(nullable:true,blank:true)
		countTimeOut(nullable:true,blank:true)
		countTaxi(nullable:true,blank:true)
		countTrips(nullable:true,blank:true)
		tripSucess(nullable:true,blank:true)
		tripCalification(nullable:true,blank:true)
		tripFail(nullable:true,blank:true)
		timeEffort(nullable:true,blank:true)
		countRejectTrip(nullable:true,blank:true)
	}

	@Override
	public int compareTo(OnlineRadioTaxi o) {
		int ret=-1
		def totalFailTrips=tripFail+countRejectTrip
		def totalFailTripsOther=o.tripFail+o.countRejectTrip
		if(totalFailTrips>totalFailTripsOther){
			ret=1
		}else{
			if(countTaxi<o.countTaxi){
				ret=1
			}else if(countTaxi==o.countTaxi){
				ret=0
			}
		}

		return ret;
	}
}
public enum OFStatus{
	ONLINE,OFFLINE,BLOCKED,INTRAVEL
}