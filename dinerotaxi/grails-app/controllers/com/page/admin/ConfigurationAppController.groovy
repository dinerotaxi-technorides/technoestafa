package com.page.admin
import grails.converters.JSON
import ar.com.goliath.*
import ar.com.notification.*
class ConfigurationAppController {
	def springSecurityService
	def placeService
	def tripPanelService

	static allowedMethods = [getPendingTrips:'GET',edit:'POST']

	def index = {
	}
	def jq_email_config_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = EmailBuilder.createCriteria().list(max:maxRows, offset:rowOffset) {
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			  [cell: [it.name,
					  it.subject,
					  '',
					  it.lang,
					  it.user?.companyName?:'',
					  it.isEnabled
				  ], id: it.id]
		  }
		  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		  render jsonData as JSON
	}

	def jq_configuration_app_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = ConfigurationApp.createCriteria().list(max:maxRows, offset:rowOffset) {
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			  [cell: [it.app,
					  it.mailkey,
					  it.mailSecret,
					  it.mailFrom,
					  it.androidAccountType,
					  it.androidEmail,
					  it.androidPass,
					  it.androidToken,
					  it.appleIp,
					  it.applePort,
					  it.appleCertificatePath,
					  it.applePassword,
					  it.androidUrl,
					  it.iosUrl,
					  it.windowsPhoneUrl,
					  it.bb10Url,
					  it.intervalPoolingTrip,
					  it.intervalPoolingTripInTransaction,
					  it.timeDelayTrip,
					  it.distanceSearchTrip,
					  it.driverSearchTrip,
					  it.percentageSearchRatio,
					  it.isEnable,
					  it.digitalRadio,
					  it.hasRequiredZone,
					  it.hasZoneActive,
					  it.costRute,
					  it.costRutePerKm,
					  it.costRutePerKmMin,
					  it.zoho,
					  it.hasMobilePayment

				  ], id: it.id]
		  }
		  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		  render jsonData as JSON
	}
	def jq_configuration_app_edit={
		def customer = null
		def message = ""
		def state = "FAIL"
		def id

		if(params?.percentageSearchRatio)
			params.percentageSearchRatio = params.float('percentageSearchRatio')

		if(params?.distanceSearchTrip)
			params.distanceSearchTrip = params.float('distanceSearchTrip')
		// determine our action
		switch (params.oper) {
		  case 'add':
			// add instruction sent
			customer = new ConfigurationApp(params)
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
			customer = ConfigurationApp.get(params.id)
			if (customer) {
			  // delete customer
//			  customer.delete()
			  message = "ConfigurationApp   ${customer.app} Deleted"
			  state = "OK"
			}
			break;
		  default:
			// default edit action
			// first retrieve the customer by its ID
			customer = ConfigurationApp.get(params.id)
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
	def jq_email_body={
		render "asd"
	}
   def jq_email_config_edit = {
      def customer = null
      def message = ""
      def state = "FAIL"
      def id

      // determine our action
      switch (params.oper) {
        case 'add':
          // add instruction sent
          customer = new EmailBuilder(params)
          if (! customer.hasErrors() && customer.save(flush:true)) {
            message = "EmailBuilder  ${customer.id}  Added"
            id = customer.id
            state = "OK"
          } else {
            message = "Could Not Save Customer"
          }

          break;
        default:
          // default edit action
          // first retrieve the customer by its ID
          customer = EmailBuilder.get(params.id)
          if (customer) {
            // set the properties according to passed in parameters
            customer.properties = params
            if (! customer.hasErrors() && customer.save(flush:true)) {
              message = "EmailBuilder   ${customer.id} Updated"
              id = customer.id
              state = "OK"
            } else {
				customer.errors.each{
					log.error it
				}
              message = "Could Not Update EmailBuilder"
            }
          }
          break;
      }

      def response = [message:message,state:state,id:id]

      render response as JSON
    }
}
