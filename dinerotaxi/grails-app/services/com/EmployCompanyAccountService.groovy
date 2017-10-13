package com
import ar.com.goliath.*
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.*
class EmployCompanyAccountService {
	def dataSource
	boolean transactional = true
	def sessionFactory

	def getAll( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = CorporateUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('employee', user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}

	def searchingTrips( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = OperationCompanyHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
			and{
				eq('companyUser',user)
				or{
					eq('status', TRANSACTIONSTATUS.COMPLETED)
					eq('status', TRANSACTIONSTATUS.CALIFICATED)
				}
			}

			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getUsers( user) {

		def customers = CorporateUser.createCriteria().list() {
			eq('employee', user)
			// set the order and direction
		}
		return    customers
	}
}