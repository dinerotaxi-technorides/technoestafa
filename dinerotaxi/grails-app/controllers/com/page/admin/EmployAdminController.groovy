package com.page.admin
import java.util.List;
import org.json.JSONArray
import org.json.JSONObject

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
class EmployAdminController {
	def springSecurityService
	def placeService
	def employAdminService

	static allowedMethods = [getPendingTrips:'GET',edit:'POST']

	def index = {
	}

	def vehicle = {
	}
 // return JSON list of customers
    def jq_customer_list = {
      def sortIndex = params.sidx ?: 'lastName'
      def sortOrder  = params.sord ?: 'asc'

      def maxRows = Integer.valueOf(params.rows)
      def currentPage = params.page?Integer.valueOf(params.page) : 1
      def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

	  def companyRole=Role.findByAuthority("ROLE_COMPANY")
	  def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
	  def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
	  def principal = springSecurityService.principal
	  def userInstance = User.findByUsername(principal.username)
	  def intermediario=null
	  if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
	  	 intermediario = EmployUser.findByUsername(principal.username)

	  }else if ( userInstance.authorities.contains(companyRole) ){
	  	 intermediario = Company.findByUsername(principal.username)
	  }
	  def customers=employAdminService.getAll( maxRows,rowOffset,sortIndex,sortOrder,intermediario)

      def totalRows = customers.totalCount
      def numberOfPages = Math.ceil(totalRows / maxRows)

      def jsonCells = customers.collect {
            [cell: [it.username.split("@")[0],"****",it.firstName,
                    it.lastName,
					it.phone,it.typeEmploy.name().toString(),it.agree,it.enabled
                ], id: it.id]
        }
        def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
        render jsonData as JSON
    }
 // return JSON list of customers
    def jq_vehicule_list = {
      def sortIndex = params.sidx ?: 'lastName'
      def sortOrder  = params.sord ?: 'asc'

      def maxRows = Integer.valueOf(params.rows)
      def currentPage = params.page?Integer.valueOf(params.page) : 1
      def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

	  def companyRole=Role.findByAuthority("ROLE_COMPANY")
	  def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
	  def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
	  def principal = springSecurityService.principal
	  def userInstance = User.findByUsername(principal.username)
	  def intermediario=null
	  if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
	  	 intermediario = EmployUser.findByUsername(principal.username)
	  }else if ( userInstance.authorities.contains(companyRole) ){
	  	 intermediario = Company.findByUsername(principal.username)
	  }
	  def customers=employAdminService.getAllVehiclesByCompany( maxRows,rowOffset,sortIndex,sortOrder,intermediario)

      def totalRows = customers.totalCount
      def numberOfPages = Math.ceil(totalRows / maxRows)

      def jsonCells = customers.collect {
            [cell: [it.patente,it.marca,it.modelo,
                    it.active
                ], id: it.id]
        }
        def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
        render jsonData as JSON
    }

	def jq_get_type={

		StringBuffer buf = new StringBuffer("<select id='user.typeEmploy' name='user.typeEmploy'>")

		def l=TypeEmployer.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			 buf.append(it.name())
			 buf.append("</option>")
		}
		 buf.append("</select>")

		 render buf.toString()
	}

	def jq_get_patente={
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def intermediario=null
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			def inter = EmployUser.findByUsername(principal.username)
			intermediario = Company.findByUsername(inter.employee.username)
		}else if ( userInstance.authorities.contains(companyRole) ){
			 intermediario = Company.findByUsername(principal.username)
		}
		def customers = Vehicle.findAllByCompany(intermediario)
		StringBuffer buf = new StringBuffer("<select id='patente' name='patente'>")
		buf.append("<option value=''></option>")
		def l=customers.each{

			buf.append("<option value='${it.patente}'").append(it.patente).append('>')
			 buf.append(it.patente)
			 buf.append("</option>")
		}
		 buf.append("</select>")

		 render buf.toString()
	}
    def jq_edit_customer = {
      def customer = null
	  def intermediario =null
      def message = ""
      def state = "FAIL"
      def id

      // determine our action
      switch (params.oper) {
        case 'add':
          // add instruction sent
          customer = new EmployUser(params)
		  def companyRole=Role.findByAuthority("ROLE_COMPANY")
		  def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		  def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		  def taxiRol1e=Role.findByAuthority("ROLE_TAXI_OWNER")
		  def principal = springSecurityService.principal
		  def userInstance = User.findByUsername(principal.username)
		  if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			   intermediario = EmployUser.findByUsername(principal.username)
			   customer.employee=intermediario.employee
		  }else if ( userInstance.authorities.contains(companyRole) ){
			   intermediario = Company.findByUsername(principal.username)
			   customer.employee=intermediario
		  }
		  customer.status=UStatus.DONE
		  customer.isTestUser=customer.employee.isTestUser
		  customer.password=params?.password
		  customer.username=customer.username+"@"+intermediario.email.split("@")[1]
		  customer.rtaxi=intermediario
		  customer.email=customer.username
		  customer.politics=customer.agree
          if (! customer.hasErrors() && customer.save(flush:true)) {
            message = "Customer  ${customer.firstName} ${customer.lastName} Added"
            id = customer.id
			if(customer.typeEmploy==TypeEmployer.OPERADOR){
				UserRole.create customer, operadorRole
			}else if(customer.typeEmploy==TypeEmployer.CORDINADOR){
				UserRole.create customer, supervisorRole
			} else if(customer.typeEmploy==TypeEmployer.TELEFONISTA){
				UserRole.create customer, operadorRole
			} else if(customer.typeEmploy==TypeEmployer.TAXISTA){
				if(params?.patente){
					def ve=Vehicle.findByPatente(params?.patente)
					if(ve){
						ve.addToTaxistas(customer)
					}
				}
				UserRole.create customer, taxiRol1e
			}
            state = "OK"
          } else {
            message = "Could Not Save User"
          }

          break;

        default:
          // default edit action
          // first retrieve the customer by its ID
          customer = EmployUser.get(params.id)
          if (customer) {
            // set the properties according to passed in parameters
            customer.firstName = params?.firstName
			customer.lastName = params?.lastName
			customer.phone = params?.phone

			if(!params?.password.equals("****")){
				customer.password=params?.password
			}
			customer.enabled = params.enabled.contains("off")?false:true
			customer.agree= params.agree.contains("off")?false:true
		    customer.politics=customer.agree
			if(customer.typeEmploy==TypeEmployer.TAXISTA){

				if(params?.patente){
					def vere=Vehicle.findByTaxistas(customer)
					if(vere){
						vere.removeFromTaxistas(customer)
					}
					def ve=Vehicle.findByPatente(params?.patente)
					if(ve){
						ve.addToTaxistas(customer)
					}
				}
			}
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
    def jq_edit_vehicule = {
      def customer = null
	  def intermediario =null
      def message = ""
      def state = "FAIL"
      def id

      // determine our action
      switch (params.oper) {
        case 'add':
          // add instruction sent
          customer = new Vehicle(params)
		  def companyRole=Role.findByAuthority("ROLE_COMPANY")
		  def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		  def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		  def taxiRol1e=Role.findByAuthority("ROLE_TAXI_OWNER")
		  def principal = springSecurityService.principal
		  def userInstance = User.findByUsername(principal.username)

		  if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			   intermediario = EmployUser.findByUsername(principal.username)
			   customer.company=intermediario.employee
		  }else if ( userInstance.authorities.contains(companyRole) ){
			   intermediario = Company.findByUsername(principal.username)
			   customer.company=intermediario
		  }

          if (! customer.hasErrors() && customer.save(flush:true)) {
            message = "Vehicle  ${customer.patente} ${customer.marca} Agregado"
            id = customer.id
            state = "OK"
          } else {
            message = "Could Not Save User"
			customer.errors.each{
				log.error it
			}
          }

          break;

        default:
          // default edit action
          // first retrieve the customer by its ID
          customer = Vehicle.get(params.id)
          if (customer) {
            // set the properties according to passed in parameters
            customer.patente = params?.patente
			customer.marca = params?.marca
			customer.modelo = params?.modelo
			customer.active = params.active.contains("off")?false:true
            if (! customer.hasErrors() && customer.save(flush:true)) {
              message = "Vehicle  ${customer.patente} ${customer.marca} Editado"
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
