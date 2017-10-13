package com.page.admin
import java.util.List;
import org.json.JSONArray
import org.json.JSONObject
import ar.com.notification.*
import com.DataTableRequestParam
import com.api.PlaceService;
import com.DataTablesParamUtility
import ar.com.goliath.*
import ar.com.operation.Operation
import ar.com.operation.OperationPending;
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.OperationHistory
import grails.converters.JSON
import ar.com.favorites.Favorites
class EnabledCitiesAdminController {
	def springSecurityService
	def placeService
	def tripPanelService

	static allowedMethods = [getPendingTrips:'GET',edit:'POST']

	def index = {
	}


	def jq_enabled_cities_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = EnabledCities.createCriteria().list(max:maxRows, offset:rowOffset) {
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [
					it.name,
					it.country,
					it.admin1Code,
					it.locality,
					it.countryCode,
					it.timeZone,
					it.northEastLatBound,
					it.northEastLngBound,
					it.southWestLatBound,
					it.southWestLngBound,
					it.enabled,
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_enabled_cities_edit = {
		def customer = null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent
				customer = new EnabledCities(params)
				if (! customer.hasErrors() && customer.save(flush:true)) {
					message = "ConfigurationApp  ${customer.name}  Added"
					id = customer.id
					state = "OK"
				} else {
					message = "Could Not Save Customer"
				}

				break;
			case 'del':
			// check customer exists
				customer = EnabledCities.get(params.id)
				if (customer) {
					// delete customer
					customer.delete()
					message = "ConfigurationApp   ${customer.name} Deleted"
					state = "OK"
				}
				break;
			default:
			// default edit action
			// first retrieve the customer by its ID
				customer = EnabledCities.get(params.id)
				if (customer) {
					// set the properties according to passed in parameters
					def northEastLatBound=params.float('northEastLatBound')
					def northEastLngBound=params.float('northEastLngBound')
					def southWestLatBound= params.float('southWestLatBound')
					def southWestLngBound=params.float('southWestLngBound')
					params.northEastLatBound=0
					params.northEastLngBound=0
					params.southWestLatBound= 0
					params.southWestLngBound=0
					customer.properties = params
					customer.northEastLatBound=northEastLatBound
					customer.northEastLngBound=northEastLngBound
					customer.southWestLatBound= southWestLatBound
					customer.southWestLngBound=southWestLngBound
					if (! customer.hasErrors() && customer.save(flush:true)) {
						message = "ConfigurationApp   ${customer.name} Updated"
						id = customer.id
						state = "OK"
					} else {
						message = "Could Not Update Customer"
						customer.errors.each{
							log.error it
						}
					}
				}
				break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	}
}
