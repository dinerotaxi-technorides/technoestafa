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
class OperationCharges {
	Operation operation
	
	Date createdDate
	
	TYPE_CHARGE type_charge=TYPE_CHARGE.TIME
	Double charge = 0d
	String name = ""
	String json
	
	
	static mapping = {
		
	}
	static constraints = {
		createdDate(nullable: true);
	}
	def beforeInsert = {
		createdDate = new Date()
	}
	
}

public enum TYPE_CHARGE{
	TIME,DISTANCE,WAIT,ADDITIONAL,INITIAL_COST,PRICE
}

