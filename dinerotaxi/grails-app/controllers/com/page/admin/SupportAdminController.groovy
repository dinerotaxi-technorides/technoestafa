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
class SupportAdminController {
	def springSecurityService
	def placeService
	def tripPanelService
	
	static allowedMethods = [getPendingTrips:'GET',edit:'POST']
	
	def index = {
	}

	
	def jq_support_admin_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
  
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
  
		def customers = Contact.createCriteria().list(max:maxRows, offset:rowOffset) {
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def jsonCells = customers.collect {
			  [cell: [it.email,
					  it.firstName,
					  it.lastName,
					  it.phone,
					  it.subject,
					  it.comment,
					  new java.text.SimpleDateFormat("dd/MM hh:mm").format(it.createdDate)
				  ], id: it.id]
		  }
		  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		  render jsonData as JSON
	}
   def jq_support_admin_edit = {
      def customer = null
      def message = ""
      def state = "FAIL"
      def id

      // determine our action
      switch (params.oper) {
        case 'add':
          // add instruction sent
          customer = new Contact(params)
          if (! customer.hasErrors() && customer.save(flush:true)) {
            message = "ConfigurationApp  ${customer.email}  Added"
            id = customer.id
            state = "OK"
          } else {
            message = "Could Not Save Customer"
          }

          break;
        case 'del':
          // check customer exists
          customer = Contact.get(params.id)
          if (customer) {
            // delete customer
            customer.delete()
            message = "ConfigurationApp   ${customer.email} Deleted"
            state = "OK"
          }
          break;
        default:
          // default edit action
          // first retrieve the customer by its ID
          customer = Contact.get(params.id)
          if (customer) {
            // set the properties according to passed in parameters
            customer.properties = params
            if (! customer.hasErrors() && customer.save(flush:true)) {
              message = "ConfigurationApp   ${customer.email} Updated"
              id = customer.id
              state = "OK"
            } else {
              message = "Could Not Update Customer"
            }
          }
          break;
      }

      def response = [message:message,state:state,id:id]

      render response as JSON
    }
}