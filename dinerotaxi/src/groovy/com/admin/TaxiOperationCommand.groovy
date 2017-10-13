
package com.admin

class TaxiOperationCommand {
   
    Long countTravel
	Date lastDate
	Long total
	Long canceled
	Long porcent
	public Long getPorcent(){
		return 100/total*countTravel
	}
	TaxiOperationCommand(Long countTravel,	Date lastDate){
		this.countTravel=countTravel
		this.lastDate=lastDate
	}
	TaxiOperationCommand(Long countTravel,	Date lastDate,Long total ,Long canceled){
		this.countTravel=countTravel
		this.lastDate=lastDate
		this.total=total
		this.canceled=canceled
	}
}

