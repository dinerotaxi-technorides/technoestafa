package ar.com.operation

import java.math.BigDecimal;
import java.util.Date;

import ar.com.favorites.TemporalFavorites
import ar.com.goliath.EmployUser
import ar.com.goliath.User
import ar.com.goliath.corporate.Corporate;
import ar.com.goliath.corporate.CostCenter;
import ar.com.operation.TRANSACTIONSTATUS;

import com.UserDevice
class DelayOperation {
	User user
	EmployUser taxista
	EmployUser intermediario
	//company es la empresa de radiotaxi 
	User company
	// es la empresa de cuenta corriente
	User companyUser
	Date createdDate
	Date lastModifiedDate
	Date executionTime
	Date executedTime
	CostCenter costCenter
	Corporate corporate
	Integer timeDelayExecution
	boolean isTestUser
	boolean isCompanyAccount
	TRANSACTIONSTATUS status=TRANSACTIONSTATUS.PENDING
	boolean sendToOperation
			
	boolean createdByOperator=false
	boolean pushedToDevice=false
	TemporalFavorites favorites
	Options options
	String paymentReference
	Integer driverNumber
	UserDevice dev
	Operation operation
	BigDecimal amount
	String ip= "0.0.0.0"
	String businessModel = BUSINESSMODEL.GENERIC
	static constraints = {
		favorites(nullable: false);
		intermediario(nullable: true);
		lastModifiedDate(nullable: true);
		costCenter(nullable: true);
		corporate(nullable: true);
		timeDelayExecution(nullable: true);
		operation(nullable: true);
		user(nullable: true);
		companyUser(nullable: true);
		company(nullable: true);
		taxista(nullable: true);
		createdDate(nullable:true,blank:true)
		paymentReference(nullable:true,blank:true)
		driverNumber(nullable:true,blank:true)
		options(nullable:true,blank:true)
		executionTime(nullable:false)
		amount(nullable:true,blank:true)
		executedTime(nullable:true)
	}
	def beforeInsert = {
		createdDate = new Date()
		lastModifiedDate = new Date()
		sendToOperation=true
		if(options==null){
			options=new Options().save(flush:true)
		}
	}
}	