package ar.com.operation

import java.util.Set;

import ar.com.favorites.TemporalFavorites
import ar.com.goliath.BlackListOperation
import ar.com.goliath.BlackListRadioTaxiOperation;
import ar.com.goliath.EmployUser
import ar.com.goliath.RealUser
import ar.com.goliath.Role;
import ar.com.goliath.User
import ar.com.goliath.corporate.Corporate;
import ar.com.goliath.corporate.CostCenter;

import com.UserDevice
abstract class Operation {
	static belongsTo = [parent:Operation];
	static hasMany = [children:Operation];
	User user
	EmployUser taxista
	EmployUser intermediario
	//company es la empresa de radiotaxi 
	User company
	// es la empresa de cuenta corriente
	User companyUser
	Date createdDate
	Date lastModifiedDate
	Date queueDate
	boolean isTestUser
	boolean isCompanyAccount
	TRANSACTIONSTATUS status=TRANSACTIONSTATUS.PENDING
	boolean enabled
	boolean sendToSocket = false
	TemporalFavorites favorites
	CostCenter costCenter
	Corporate corporate
	Options options
	UserDevice dev
	Long timeTravel
	BigDecimal amount
	String paymentReference
	Integer driverNumber
	Integer stars
	boolean createdByOperator = false
	boolean isDelayOperation = false
	String ip= "0.0.0.0"
	String businessModel = BUSINESSMODEL.GENERIC
	
	String queueType = QUEUETYPE.NORMAL
	String userType  = USERTYPE.NORMAL
	
	static constraints = {
		parent(nullable: true);
		children(nullable: true);
		costCenter(nullable: true);
		corporate(nullable: true);
		favorites(nullable: false);
		intermediario(nullable: true);
		user(nullable: true);
		companyUser(nullable: true);
		company(nullable: true);
		taxista(nullable: true);
		timeTravel(nullable: true);
		createdDate(nullable:true,blank:true)
		amount(nullable:true,blank:true)
		options(nullable:true,blank:true)
		stars(nullable:true,blank:true)
		paymentReference(nullable:true,blank:true)
		driverNumber(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		queueDate(nullable:true,blank:true)
	}
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
		queueDate = new Date()
		enabled=true
		if(options==null){
			options=new Options().save()
		}
	}
	
	Set<UserOperationLog> getUserOperationLog() {
		UserOperationLog.findAllByOperation((Operation)this).collect { it } as Set
	}
	
	def beforeUpdate = { lastModifiedDate = new Date() }
	Set<User> getBlackListUsers() {
		BlackListOperation.findAllByOperation((Operation)this).collect { it.user } as Set
	}
	Set<User> getBlackListRadiotaxiUsers() {
		BlackListRadioTaxiOperation.findAllByOperation((Operation)this).collect { it.user } as Set
	}
}

public enum TRANSACTIONSTATUS{
	PENDING,COMPLETED,BLOCKED,INTRANSACTION,INTRANSACTIONRADIOTAXI,HOLDINGUSER,CANCELED,CANCELED_EMP,CANCELED_DRIVER,
	CALIFICATED,ASSIGNEDRADIOTAXI,ASSIGNEDTAXI,REASIGNTRIP,ACCEPT_TRIP_DRIVER,REJECT_TRIP_DRIVER,REJECT_TRIP_QUEUE_DRIVER,
	REJECTTRIP,TIMEOUTTRIP,PENDINGFAVORITETRIP,CANCELTIMETRIP,CANCELOFFLINERTAXI,SETAMOUNT,UNKNOW,RINGUSER,IN_QUEUE
}

public enum BUSINESSMODEL{
	GENERIC,TAXI,LIMO,SHUTTLE,DELIVERY
}
public enum QUEUETYPE{
	NORMAL,CARPOOLING
}

public enum QUEUESTATUS{
	PENDING,DISPATCHED,RETRY
}
public enum USERTYPE{
	NORMAL,CORPORATE
}
