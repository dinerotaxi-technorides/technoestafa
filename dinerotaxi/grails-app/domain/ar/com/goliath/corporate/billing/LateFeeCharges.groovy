package ar.com.goliath.corporate.billing

class LateFeeCharges {
	String name
	Double charge
	//1 day 2 week 3 fortnight 4 month
	Integer frequency
	//1 % 2 flat_fee
	Integer typeCharge
	LateFeeConfig config
}
