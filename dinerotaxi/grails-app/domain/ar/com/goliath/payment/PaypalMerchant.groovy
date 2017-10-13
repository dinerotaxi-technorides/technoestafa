package ar.com.goliath.payment

import ar.com.goliath.Company

class PaypalMerchant{

	Company company
	String callerId
	String callerPassword
	String callerSignature

  static constraints = {
		company nullable:false
		callerId nullable:false
		callerPassword nullable:false
		callerSignature nullable:false
  }
}
