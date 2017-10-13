package com
import ar.com.goliath.*
import ar.com.operation.*
class EmployAdminService {
	def dataSource
	boolean transactional = true
	def sessionFactory

	def getAll( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = EmployUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('employee', user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}
	def getAllVehiclesByCompany( maxRows,rowOffset,sortIndex,sortOrder,user) {
		def customers = Vehicle.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('company', user)
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		return    customers
	}

	def getUsers( user) {
		def customers = EmployUser.createCriteria().list() {
			eq('employee', user)
			// set the order and direction
		}
		return    customers
	}
}