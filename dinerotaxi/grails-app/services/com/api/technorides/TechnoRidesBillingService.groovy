package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.TypeEmployer
import ar.com.goliath.driver.charges.ChargesDriverHistory
import ar.com.goliath.driver.charges.CorporateItemDetailDriver
import ar.com.goliath.driver.charges.ItemDetailDriver
import ar.com.operation.Billing
import ar.com.operation.BillingDriver
import ar.com.operation.Operation
import ar.com.operation.OperationCompanyHistory
import ar.com.operation.OperationHistory

class TechnoRidesBillingService {
	static transactional = true
	def utilsApiService
	def getBillingHistory( params,user) {

		def customers = Billing.createCriteria().list() {
				eq("user",user)
			// set the order and direction
		}
		
		def jsonData= [result: customers,status:100]
		return jsonData as JSON
	}
	def getBillingNoPaid( params,user) {

		def customers = Billing.createCriteria().list() {
				eq("hadpaid", false)
				eq("user",user)
			// set the order and direction
		}
		
		def jsonData= [result: customers,status:100]
		return jsonData as JSON
	}
	
	def getBillingDriverHistory( params,user) {
		
		def rows  =params?.rows ?: 10
		def page = params.page ?:1
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = Integer.valueOf(rows)
		def currentPage = Integer.valueOf(page) ?: 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = BillingDriver.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq("user",user)
			// set the order and direction
		}
		println customers
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def jsonCells = customers.collect {
			[
				id:it.id,
				billingDate: new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.billingDate),
				amount:it.amount?:0.0,
				comments:it.comments?:'',
				recive:it.recive?:'',
				hadpaid:it.hadpaid
			]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	def getBillingDriverNoPaid( params,user) {
		def rows  =params?.rows ?: 10
		def page = params.page ?:1
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = Integer.valueOf(rows)
		def currentPage = Integer.valueOf(page) ?: 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = BillingDriver.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq("hadpaid", false)
				eq("visible", true)
				eq("user",user)
			// set the order and direction
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def jsonCells = customers.collect {
			[
				id:it.id,
				billingDate: new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.billingDate),
				amount:it.amount?:0.0,
				comments:it.comments?:'',
				recive:it.recive?:'',
				hadpaid:it.hadpaid
			]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	
	def chargeDriverPayment(Company company){
		def drivers = EmployUser.findAllByEmployeeAndTypeEmployAndEnabled(company,TypeEmployer.TAXISTA,true)
		for (driver in drivers) {  
			println "PROCESS PAYMENT DRIVER ${driver}"
			processDriverPayment(company,driver)
		}
	}
	
	def processDriverPayment (Company company,EmployUser driver){
		//daily weekly quarter monthly
		def driverTypePayment = company?.wlconfig?.driverTypePayment
		// porcentage or fixed money
		def driverPayment = company?.wlconfig?.driverPayment
		print driverPayment
		print driverTypePayment
		if(driverPayment == 1){
			if( validateIsTimeToCharge(driverTypePayment)){
				billingDriver(company,driver)
			}
		}else if (driverPayment == 0){
			if( validateIsTimeToCharge(driverTypePayment)){
				billingDriverPerPorcentage(company,driver)
			}
		}
		corporateDriver(company,driver)
	}
	boolean validateIsTimeToCharge(driverTypePayment){
		def cal1=Calendar.getInstance();
		print cal1.getTime()
		return (isMonthPayment(driverTypePayment,cal1) || isQuarterPayment(driverTypePayment,cal1)
				|| isWeekPayment(driverTypePayment,cal1) || isDayPayment(driverTypePayment,cal1) )
	}


	boolean isMonthPayment(def driverTypePayment,def cal1){
		return (driverTypePayment==3 && cal1.get(Calendar.DAY_OF_MONTH)==1)
	}
	boolean isQuarterPayment(def driverTypePayment,def cal){
		return (driverTypePayment==2
				&& cal.get(GregorianCalendar.DAY_OF_MONTH)==1
				&& cal.get(GregorianCalendar.DAY_OF_MONTH)==15)
	}
	boolean isWeekPayment(def driverTypePayment,def cal){
		return (driverTypePayment==1 && cal.get(Calendar.DAY_OF_WEEK)==1)
	}
	boolean isDayPayment(def driverTypePayment,def cal1){
		return (driverTypePayment==0 )
	}
	boolean isChargeComputable(def charge,def cal1){
		def driverTypePayment = charge.driverPayment
		return (isMonthPayment(driverTypePayment,cal1)
				|| isQuarterPayment(driverTypePayment,cal1)
				|| isWeekPayment(driverTypePayment,cal1)
				|| isDayPayment(driverTypePayment,cal1) )

	}
	private Calendar getDateFromPerPorcentage(def driverPayment){
		def dateFrom=Calendar.getInstance();
		if(driverPayment==3){
			dateFrom.add(Calendar.MONTH, -1)
		}else if(driverPayment==2){
			dateFrom.add(Calendar.DAY_OF_MONTH, -15)
		}else if(driverPayment==1){
			dateFrom.add(Calendar.DAY_OF_MONTH, -7)
		}else if(driverPayment==0){
			dateFrom.add(Calendar.DAY_OF_MONTH, -1)
		}
		return dateFrom
	}
	def corporateDriver(def company, def driver){
		def cal1=Calendar.getInstance();
		def dateFrom=getDateFromPerPorcentage(0 )
		def operationCharges = OperationCompanyHistory.createCriteria().list() {
			eq("taxista",driver)
			between ("createdDate", dateFrom.getTime(), cal1.getTime())
			// set the order and direction
		}

		operationCharges.each{Operation operation ->
			def billing = CorporateItemDetailDriver.findByOperation(operation)
			if(!billing && operation.amount >0){
				def corporateItem = new CorporateItemDetailDriver()
				corporateItem.driver = operation.taxista
				corporateItem.rtaxi = operation.company
				corporateItem.chargesDate = operation.createdDate
				corporateItem.operation = operation
				
				def amountOperation =operation.amount!=null?(operation.amount/100*company?.wlconfig.driverCorporateCharge):0d
				corporateItem.total    = amountOperation
				corporateItem.status    = 'PENDING'
				if(!corporateItem.save()){
					corporateItem.errors.each(){ print it }
				}
			}

		}
	}
	//COBRO A DRIVER POR PORCENTAJE !! SE FACTURA AL DRIVER POR LOS VIAJES REALIZADOS
	def billingDriverPerPorcentage(def company, def driver){
		println "billing driver porcentaje ${driver}"
		println "----------------"
		def cal1=Calendar.getInstance();
		def dateFrom=getDateFromPerPorcentage(company?.wlconfig?.driverTypePayment )
		cal1.set(Calendar.MINUTE, 0);
		cal1.set(Calendar.SECOND, 0);
		cal1.set(Calendar.HOUR_OF_DAY, 0);
		dateFrom.set(Calendar.MINUTE, 0);
		dateFrom.set(Calendar.SECOND, 0);
		dateFrom.set(Calendar.HOUR_OF_DAY, 0);
		println "${dateFrom.getTime()}----${cal1.getTime()}"
		def operationCharges = OperationHistory.createCriteria().list() {
			eq("taxista",driver)
			between ("createdDate", dateFrom.getTime(), cal1.getTime())
			isNotNull('amount')
			// set the order and direction
		}
		def billing = ChargesDriverHistory.findByChargesDateAndDriver(cal1.getTime(),driver)
		def charges = 0
		def operationChargesNotInInvoice = []
		if (operationCharges != null && operationCharges.amount != null){
			operationCharges.each{OperationHistory op ->
				def item = ItemDetailDriver.findByOperation(op)
				if(!item){
					charges = charges + op.amount
					operationChargesNotInInvoice.push(op)
					
				}
				
			}
			
		}
		if ( !billing && charges >0 ){
			def amountOperation =charges!=null?(charges/100*company?.wlconfig.driverAmountPayment):0d
			def charge_driver = new ChargesDriverHistory(status:'PENDING',driver:driver,rtaxi:company,total:amountOperation)
			charge_driver.chargesDate = cal1.getTime();
			charge_driver.dueDate = cal1.getTime();
			charge_driver.subTotal    = amountOperation
			charge_driver.invoiceId   = driver.id
			operationChargesNotInInvoice.each{OperationHistory operation ->
				def item = new ItemDetailDriver()
				item.operation = operation
				item.amount    = operation.amount != null?(operation.amount/100*company?.wlconfig.driverAmountPayment):0d
				item.quantity  = 1
				item.name      = operation.id
				if(!item.save()){
					item.errors.each(){ print it }
				}
				charge_driver.addToItems(item)
			}

			if(!charge_driver.save()){
				charge_driver.errors.each { println it }
			}
		}
	}

	def billingDriver(Company company, def driver){
		def cal1=Calendar.getInstance();
		cal1.set(Calendar.MINUTE, 0);
		cal1.set(Calendar.SECOND, 0);
		cal1.set(Calendar.HOUR_OF_DAY, 0);

		def billing = ChargesDriverHistory.findByChargesDateAndDriver(cal1.getTime(),driver)
		def amountOperation = company?.wlconfig?.driverAmountPayment?:0d
		if ( !billing && amountOperation>0){
			def charge_driver = new ChargesDriverHistory(status:'PENDING',driver:driver,rtaxi:company,total:amountOperation)
			charge_driver.chargesDate = cal1.getTime();
			charge_driver.dueDate     = cal1.getTime();
			charge_driver.subTotal    = amountOperation
			charge_driver.invoiceId   = driver.id


			if(!charge_driver.save()){
				charge_driver.errors.each { println it }
			}

		}
	}
}
