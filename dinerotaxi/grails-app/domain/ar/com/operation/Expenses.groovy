package ar.com.operation

import ar.com.goliath.User
class Expenses {
	
	Date createdDate
	String receiptNumber
	String supplier
	String concept
	String exchanges
	String creditCardNumber
	String typeCuit = "CUIT/RUT/RUC"
	Double base
	Double base1 
	Double base2 
	Double base3
	Double tax
	Double tax1
	Double tax2
	Double tax3
	
	Double base8
	Double base9
	Double base10
	Double base11
	String comments
	String total
	String typeCredit
	//=[cash,wire,credit card]
	String currency 
	//= [currency,ARS/USD/EUR]
	String typeTax
	//=[%, amount]
	String company
	//=[LLC,SA]
	boolean enabled=true
	boolean isAuthomatic=true
	boolean hadpaid=true
	boolean fixed=true
	static constraints = {
		creditCardNumber(nullable:true,blank:true)
		exchanges(nullable:true,blank:true)
		createdDate(nullable:true,blank:true)
	    receiptNumber(nullable:true,blank:true)
	    supplier(nullable:true,blank:true)
	    concept(nullable:true,blank:true)
	    typeCuit(nullable:true,blank:true)
	    base(nullable:true,blank:true)
	    base1(nullable:true,blank:true)
	    base2(nullable:true,blank:true)
	    base3(nullable:true,blank:true)
	    tax(nullable:true,blank:true)
	    tax1(nullable:true,blank:true)
	    tax2(nullable:true,blank:true)
	    tax3(nullable:true,blank:true)
	    
	    base8(nullable:true,blank:true)
	    base9(nullable:true,blank:true)
	    base10(nullable:true,blank:true)
	    base11(nullable:true,blank:true)
	    typeCredit(nullable:true,blank:true)
	    currency(nullable:true,blank:true)
	    typeTax(nullable:true,blank:true)
	    company(nullable:true,blank:true)
	    comments(nullable:true,blank:true)
	    total(nullable:true,blank:true)
	}
}
public enum EXPENSES_TYPE_TAX{
	PORCENTAJE,AMOUNT
}
public enum EXPENSES_COMPANY{
	SA,LLC
}
public enum EXPENSES_CURRENCY{
	ARS,USD,EUR
}
public enum EXPENSES_TYPE_CREDIT{
	CASH,WIRE,CREDIT_CARD
}
