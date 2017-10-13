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
class NotificationController {
	def springSecurityService
	def placeService
	def tripPanelService
	
	static allowedMethods = [getPendingTrips:'GET',edit:'POST']
	
	def index = {
	}

	def jq_online_notification_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
  
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
  
		def customers = OnlineNotification.createCriteria().list(max:maxRows, offset:rowOffset) {
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def jsonCells = customers.collect {
			  [cell: [it?.createdDate?new java.text.SimpleDateFormat("dd/MM HH:mm").format(it.createdDate):'',it.usr.username,
					  it.operation,it.title,
					  it.message,
					  it.args,
					  it.hasEncoded,
					  it.operation,
					  it.isRead
				  ], id: it.id]
		  }
		  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		  render jsonData as JSON
	}
   def jq_online_notification_edit = {
	  def customer = null
	  def message = ""
	  def state = "FAIL"
	  def id

	  // determine our action
	  switch (params.oper) {
		case 'add':
		  // add instruction sent
		  customer = new OnlineNotification(params)
		  if (! customer.hasErrors() && customer.save(flush:true)) {
			message = "OnlineNotification  ${customer.id}  Added"
			id = customer.id
			state = "OK"
		  } else {
			message = "Could Not Save Customer"
		  }

		  break;
		case 'del':
		  // check customer exists
		  customer = OnlineNotification.get(params.id)
		  if (customer) {
			// delete customer
			customer.delete()
			message = "OnlineNotification   ${customer.id} Deleted"
			state = "OK"
		  }
		  break;
		default:
		  // default edit action
		  // first retrieve the customer by its ID
		  customer = OnlineNotification.get(params.id)
		  if (customer) {
			// set the properties according to passed in parameters
			customer.properties = params
			if (! customer.hasErrors() && customer.save(flush:true)) {
			  message = "OnlineNotification   ${customer.id} Updated"
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
	def jq_notification_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
  
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
  
		def customers = Notification.createCriteria().list(max:maxRows, offset:rowOffset) {
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def jsonCells = customers.collect {
			  [cell: [it.device_type,
					  it.code_device,
					  it.subject,
					  it.message,
					  it.email,
					  it.name,
					  it.message_id,
					  it.app,
					  it.type,
					  it.alert_type,
					  it.badge,
					  it.retries,
					  new java.text.SimpleDateFormat("dd/MM hh:mm").format(new Date())
				  ], id: it.id]
		  }
		  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		  render jsonData as JSON
	}
   def jq_notification_edit = {
      def customer = null
      def message = ""
      def state = "FAIL"
      def id

      // determine our action
      switch (params.oper) {
        case 'add':
          // add instruction sent
          customer = new Notification(params)
          if (! customer.hasErrors() && customer.save(flush:true)) {
            message = "ConfigurationApp  ${customer.app}  Added"
            id = customer.id
            state = "OK"
          } else {
            message = "Could Not Save Customer"
          }

          break;
        case 'del':
          // check customer exists
          customer = Notification.get(params.id)
          if (customer) {
            // delete customer
            customer.delete()
            message = "ConfigurationApp   ${customer.app} Deleted"
            state = "OK"
          }
          break;
        default:
          // default edit action
          // first retrieve the customer by its ID
          customer = Notification.get(params.id)
          if (customer) {
            // set the properties according to passed in parameters
            customer.properties = params
            if (! customer.hasErrors() && customer.save(flush:true)) {
              message = "ConfigurationApp   ${customer.app} Updated"
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