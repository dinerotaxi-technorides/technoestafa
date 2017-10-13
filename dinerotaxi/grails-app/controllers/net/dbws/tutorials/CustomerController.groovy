package net.dbws.tutorials

import grails.converters.JSON

class CustomerController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [customerInstanceList: Customer.list(params), customerInstanceTotal: Customer.count()]
    }

    def create = {
        def customerInstance = new Customer()
        customerInstance.properties = params
        return [customerInstance: customerInstance]
    }

    def save = {
        def customerInstance = new Customer(params)
        if (customerInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'customer.label', default: 'Customer'), customerInstance.id])}"
            redirect(action: "show", id: customerInstance.id)
        }
        else {
            render(view: "create", model: [customerInstance: customerInstance])
        }
    }

    def show = {
        def customerInstance = Customer.get(params.id)
        if (!customerInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'customer.label', default: 'Customer'), params.id])}"
            redirect(action: "list")
        }
        else {
            [customerInstance: customerInstance]
        }
    }

    def edit = {
        def customerInstance = Customer.get(params.id)
        if (!customerInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'customer.label', default: 'Customer'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [customerInstance: customerInstance]
        }
    }

    def update = {
        def customerInstance = Customer.get(params.id)
        if (customerInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (customerInstance.version > version) {
                    
                    customerInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'customer.label', default: 'Customer')] as Object[], "Another user has updated this Customer while you were editing")
                    render(view: "edit", model: [customerInstance: customerInstance])
                    return
                }
            }
            customerInstance.properties = params
            if (!customerInstance.hasErrors() && customerInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'customer.label', default: 'Customer'), customerInstance.id])}"
                redirect(action: "show", id: customerInstance.id)
            }
            else {
                render(view: "edit", model: [customerInstance: customerInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'customer.label', default: 'Customer'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def customerInstance = Customer.get(params.id)
        if (customerInstance) {
            try {
                customerInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'customer.label', default: 'Customer'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'customer.label', default: 'Customer'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'customer.label', default: 'Customer'), params.id])}"
            redirect(action: "list")
        }
    }

    // return JSON list of customers
    def jq_customer_list = {
      def sortIndex = params.sidx ?: 'lastName'
      def sortOrder  = params.sord ?: 'asc'

      def maxRows = Integer.valueOf(params.rows)      
      def currentPage = params.page?Integer.valueOf(params.page) : 1
      def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

      def customers = Customer.createCriteria().list(max:maxRows, offset:rowOffset) {

            // first name case insensitive where the field begins with the search term
            if (params.firstName)
                ilike('firstName',params.firstName + '%')

            // last name case insensitive where the field begins with the search term
            if (params.lastName)
                ilike('lastName',params.lastName + '%')

            // age search where the age Equals the search term
            if (params.age)
                eq('age', Integer.valueOf(params.age))

            // email case insensitive where the field contains search term
            if (params.emailAddress)
                ilike('emailAddress','%' + params.emailAddress + '%')

        
            // set the order and direction
            order(sortIndex, sortOrder)
      }

      def totalRows = customers.totalCount
      def numberOfPages = Math.ceil(totalRows / maxRows)

      def jsonCells = customers.collect {
            [cell: [it.firstName,
                    it.lastName,
                    it.age,
                    it.emailAddress
                ], id: it.id]
        }
        def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
        render jsonData as JSON
    }


    def jq_edit_customer = {
      def customer = null
      def message = ""
      def state = "FAIL"
      def id

      // determine our action
      switch (params.oper) {
        case 'add':
          // add instruction sent
          customer = new Customer(params)
          if (! customer.hasErrors() && customer.save(flush:true)) {
            message = "Customer  ${customer.firstName} ${customer.lastName} Added"
            id = customer.id
            state = "OK"
          } else {
            message = "Could Not Save Customer"
          }

          break;
        case 'del':
          // check customer exists
          customer = Customer.get(params.id)
          if (customer) {
            // delete customer
            customer.delete()
            message = "Customer  ${customer.firstName} ${customer.lastName} Deleted"
            state = "OK"
          }
          break;
        default:
          // default edit action
          // first retrieve the customer by its ID
          customer = Customer.get(params.id)
          if (customer) {
            // set the properties according to passed in parameters
            customer.properties = params
            if (! customer.hasErrors() && customer.save(flush:true)) {
              message = "Customer  ${customer.firstName} ${customer.lastName} Updated"
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
