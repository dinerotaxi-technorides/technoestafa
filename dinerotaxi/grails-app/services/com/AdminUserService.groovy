package com

import ar.com.goliath.*
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.*
class AdminUserService {
	def dataSource
	boolean transactional = true
	def sessionFactory

	def getAll( maxRows,rowOffset,sortIndex,sortOrder,params) {
		def customers = EmployUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
				ilike("username", params.searchString+"%")
			}
			
			if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
				ilike("phone", params.searchString+"%")
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	
	def getAllInvestor( maxRows,rowOffset,sortIndex,sortOrder,params) {
		def customers = InvestorUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
				ilike("username", params.searchString+"%")
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return customers
	}
	def getAllRealUser( maxRows,rowOffset,sortIndex,sortOrder) {
		def customers = RealUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getAllCompanyUser( maxRows,rowOffset,sortIndex,sortOrder,params) {
		def customers = Company.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
				ilike("username", params.searchString+"%")
			}
			if(  params.searchField.equals("companyName") && !params.searchString.isEmpty()){
				ilike("companyName", params.searchString+"%")
			}
			if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
				ilike("phone", params.searchString+"%")
			}
			if(  params.searchField.equals("mailContacto") && !params.searchString.isEmpty()){
				ilike("mailContacto", params.searchString+"%")
			}
//			eq("enabled",true)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getAllBilling( maxRows,rowOffset,sortIndex,sortOrder,params) {
		def customers = Billing.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(  params.searchField.equals("hadpaid") && !params.searchString.isEmpty()){
				if(params.searchString.contains("1")){
					eq("hadpaid", true)
				}else{
					eq("hadpaid", true)
				}
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return customers
	}
	def getAllExpenses( maxRows,rowOffset,sortIndex,sortOrder,params) {
		def customers = Expenses.createCriteria().list(max:maxRows, offset:rowOffset) {
			and{
				if(  params.searchField.equals("hadpaid") && !params.searchString.isEmpty()){
					eq("hadpaid", true)
				}
				if(  params.searchField.equals("receiptNumber") && !params.searchString.isEmpty()){
					ilike("receiptNumber", params.searchString+"%")
				}
				if(  params.searchField.equals("supplier") && !params.searchString.isEmpty()){
					ilike("supplier", params.searchString+"%")
				}
				if(  params.searchField.equals("concept") && !params.searchString.isEmpty()){
					ilike("concept", params.searchString+"%")
				}
				if(  params.searchField.equals("total") && !params.searchString.isEmpty()){
					ilike("total", params.searchString)
				}
				or{
					eq("typeCredit", EXPENSES_TYPE_CREDIT.CASH.toString())
					eq("typeCredit", EXPENSES_TYPE_CREDIT.WIRE.toString())
				}
			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return customers
	}
	
	def getAllExpensesCreditCard( maxRows,rowOffset,sortIndex,sortOrder,params) {
		def customers = Expenses.createCriteria().list(max:maxRows, offset:rowOffset) {
			and{
				if(  params.searchField.equals("hadpaid") && !params.searchString.isEmpty()){
					eq("hadpaid", true)
				}
				if(  params.searchField.equals("receiptNumber") && !params.searchString.isEmpty()){
					ilike("receiptNumber", params.searchString+"%")
				}
				if(  params.searchField.equals("supplier") && !params.searchString.isEmpty()){
					ilike("supplier", params.searchString+"%")
				}
				if(  params.searchField.equals("concept") && !params.searchString.isEmpty()){
					ilike("concept", params.searchString+"%")
				}
				if(  params.searchField.equals("total") && !params.searchString.isEmpty()){
					ilike("total", params.searchString)
				}
				eq("typeCredit", EXPENSES_TYPE_CREDIT.CREDIT_CARD.toString())
			}
			
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return customers
	}
	def getAllCompanyAccount( maxRows,rowOffset,sortIndex,sortOrder) {
		def customers = CompanyAccount.createCriteria().list(max:maxRows, offset:rowOffset) {
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return customers
	}
	def getAllCompanyAccountEmployee( maxRows,rowOffset,sortIndex,sortOrder) {
		def customers = CorporateUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getAllOnlineCompanyUser( maxRows,rowOffset,sortIndex,sortOrder) {
		def customers = OnlineRadioTaxi.createCriteria().list(max:maxRows, offset:rowOffset) {
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	
	def getAllParking( maxRows,rowOffset,sortIndex,sortOrder) {
		def customers = Parking.createCriteria().list(max:maxRows, offset:rowOffset) {
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	
	
	
}