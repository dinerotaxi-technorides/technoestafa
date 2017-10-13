package com

import ar.com.goliath.*
import ar.com.operation.*
class RadioTaxiUserService {
	def dataSource
	boolean transactional = true
	def sessionFactory

	def getAll( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = EmployUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi',user)
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	
	def getAllRealUser( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = RealUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi',user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getAllCompanyUser( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = Company.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi',user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getAllCompanyAccount( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = CompanyAccount.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi',user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return customers
	}
	
	def getAllCompanyAccount( user) {
		def customers = CompanyAccount.createCriteria().list() {
			eq('rtaxi',user)
		}
		return customers
	}
	def getAllCompanyAccountEmployee( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = CompanyAccountEmployee.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi',user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getAllRealUserCompany( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = RealUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi',user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getAllOnlineCompanyUser( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = OnlineRadioTaxi.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi',user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
}