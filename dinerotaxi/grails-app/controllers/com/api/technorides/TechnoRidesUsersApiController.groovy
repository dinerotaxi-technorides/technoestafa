
package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.goliath.Vehicle
import ar.com.goliath.corporate.CorporateUser

class TechnoRidesUsersApiController extends TechnoRidesValidateApiController {
	def technoRidesUsersService
	def addExcept(list) {
		list <<'get' //'index' << 'list' << 'show'
	}
	def get={ render "asd" }
	def is_active={
		render(contentType:'text/json',encoding:"UTF-8") { status=200 }
	}

	def jq_get_user_by={
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			if(params?.type && params?.type.contains("phone")){
				def techno= technoRidesUsersService.getUserByPhone(params?.term, rtaxi)
				def result = [rows:techno,status:100]
				render result as JSON
				return
			}else if(params?.type && params?.type.contains("surname")){
				def techno= technoRidesUsersService.getUserByLastName(params?.term, rtaxi)
				def result = [rows:techno,status:100]
				render result as JSON
				return
			}else{
				def techno= technoRidesUsersService.getUserByEmail(params?.term, rtaxi)
				def result = [rows:techno,status:100]
				render result as JSON
				return
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_users = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesUsersService.getUsers(params, rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_companies = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def techno= technoRidesUsersService.getCompanies()
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_investor_counter = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def techno= technoRidesUsersService.getInvestorCounters()
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_monitor_counter = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesUsersService.getMonitorCounters(rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_employ_users = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def searchList=technoRidesUsersService.getEmployUsers(params, rtaxi)
			render searchList.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_employ_users_driver = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def searchList=technoRidesUsersService.getEmployUsersDriver(params, rtaxi)
			render searchList.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def get_driver = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def customers = EmployUser.get(params?.driver_id)
			if (customers && customers.rtaxi == rtaxi){
				def vere=Vehicle.findByTaxistas(customers)

				render(contentType:'text/json',encoding:"UTF-8") {
					status=200
					email     = customers.username
					password  = "****"
					first_name= customers.firstName
					last_name = customers.lastName
					phone = customers.phone
					type_employ = customers.typeEmploy.toString()
					enabled = customers.enabled
					marca = vere?.marca?:""
					modelo = vere?.modelo?:""
					patente = vere?.patente?:""
					cuit = customers?.cuit?:""
					licence_number = customers?.licenceNumber?:""
					is_profile_editable = customers?.isProfileEditable
					isCorporate=customers?.isCorporate
					isMessaging=customers?.isMessaging
					isPet=customers?.isPet
					isAirConditioning=customers?.isAirConditioning
					isSmoker=customers?.isSmoker
					isSpecialAssistant=customers?.isSpecialAssistant
					isLuggage=customers?.isLuggage
					isAirport=customers?.isAirport
					isVip=customers?.isVip
					isInvoice=customers?.isInvoice
					isRegular=customers?.isRegular
					licence_end_date = customers?.licenceEndDate?new java.text.SimpleDateFormat("dd/MM/yyyy").format(customers?.licenceEndDate):""
					id = customers.id
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=404 }
			}
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_corporative_account = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def searchList=technoRidesUsersService.getCorporativeAccount(params, rtaxi)
			render searchList.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_corporative_account_users = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def searchList=technoRidesUsersService.getCorporativeAccountUsers(params, rtaxi)
			render searchList.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_vehicule_list = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)

			def customers=technoRidesUsersService.getAllVehiclesByCompany( params, rtaxi)
			render customers.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_vehicule_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)

			def customers=technoRidesUsersService.editVehiclesByCompany( params, rtaxi)
			render customers.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_get_company_account={
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def customers=technoRidesUsersService.getAllCompanyAccount(rtaxi)
			StringBuffer buf = new StringBuffer("<select id='companyAccount' name='companyAccount'>")
			buf.append("<option value=''></option>")
			def l=customers.each{

				buf.append("<option value='${it.id}'").append(it.companyName).append('>')
				buf.append(it.companyName)
				buf.append("</option>")
			}
			buf.append("</select>")
			render  buf.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_get_patente={
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)

			def customers = Vehicle.findAllByCompany(rtaxi)
			StringBuffer buf = new StringBuffer("<select id='patente' name='patente'>")
			buf.append("<option value=''></option>")
			def l=customers.each{
				buf.append("<option value='${it.patente}'").append(it.patente).append('>')
				buf.append(it.patente)
				buf.append("</option>")
			}
			buf.append("</select>")
			render  buf.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_get_type={
		StringBuffer buf = new StringBuffer("<select id='typeEmploy' name='typeEmploy'>")
		buf.append("<option value='OPERADOR'").append("OPERADOR").append('>')
		buf.append("OPERADOR")
		buf.append("</option>")
		buf.append("<option value='TELEFONISTA'").append("TELEFONISTA").append('>')
		buf.append("TELEFONISTA")
		buf.append("</option>")
		buf.append("<option value='MONITOR'").append("MONITOR").append('>')
		buf.append("MONITOR")
		buf.append("</option>")
		buf.append("</select>")

		render buf.toString()
	}

	def jq_user_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def typeEdit=TypeUser.valueOf(params?.type)
			switch ( typeEdit ) {
				//				case TypeUser.CORPORATEACCOUNT:
				//					def customers=technoRidesUsersService.createOrEditCorporateAccount( params, rtaxi)
				//					render customers.toString()
				//					return
				//				case TypeUser.CORPORATEACCOUNTUSER:
				//					print "acaaaaa"
				//					def customers=technoRidesUsersService.createOrEditCorporateAccountUser( params, rtaxi)
				//					render customers.toString()
				//					return
				case TypeUser.USER:
					def customers=technoRidesUsersService.createOrEditUser( params, rtaxi)
					render customers.toString()
					return
				case TypeUser.EMPLOYUSERDRIVER:
					def customers=technoRidesUsersService.createOrEditEmployUserDriver( params, rtaxi)
					render customers.toString()
					return
				case TypeUser.EMPLOYUSEROPERATOR:
					def customers=technoRidesUsersService.createOrEditEmployUserOperator( params, rtaxi)
					render customers.toString()
					return
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_driver_profile={
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		try {
			Integer driver_id = Integer.valueOf(params?.username.split("@")[0])
			def customers = technoRidesUsersService.createDriverProfile( params, rtaxi)
			render customers.toString()
		} catch (Exception e) {
			print e.stackTrace
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_driver_activate={
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		try {
			def customer = EmployUser.get(params.driver_id)
			if(customer.rtaxi==rtaxi){
				customer.enabled =!customer.enabled
				customer.accountLocked =!customer.enabled
				if (! customer.hasErrors() && customer.save(flush:true)) {
					render(contentType:'text/json',encoding:"UTF-8") {
						status = 100
						enabled = !customer.enabled
					}
				} else {
					message = "customer.error.not.updated"
					render(contentType:'text/json',encoding:"UTF-8") { status=400 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=400 }
			}
		} catch (Exception e) {
			print e.stackTrace
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_employ_users_del={
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def driver=EmployUser.get(params?.id)

			if(driver && driver.rtaxi==rtaxi){
				driver.visible=false
				driver.enabled=false
				driver.accountLocked=true
				driver.save()

				render(contentType:'text/json',encoding:"UTF-8") { status=100 }
			}else{

				render(contentType:'text/json',encoding:"UTF-8") { status=101 }
			}
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_posible_investor_get = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def techno= technoRidesUsersService.getPosibleInvestor(params)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_posible_investor_edit = {
		try{
			def customers=technoRidesUsersService.createOrEditInvestorsContact( params)
			render customers.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_get_information_company = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def company=Company.get(rtaxi?.id)

			render(contentType:'text/json',encoding:"UTF-8") {
				status=200
				contact_name=company?.firstName
				contact_mail=company?.mailContacto
				phone_company=company?.phone
				celular_phone=company?.phone1
				company_name=company?.companyName
				price=company?.price
				cuit=company?.cuit
				lat=company?.latitude
				lng=company?.longitude
				password="****"
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_edit_information_company = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def company=Company.get(rtaxi?.id)

			if(company){
				if(params?.contact_name)
					company.firstName=params?.contact_name
				if(params?.contact_mail)
					company.mailContacto=params?.contact_mail
				if(params?.phone_company)
					company.phone=params?.phone_company
				if(params?.celular_phone)
					company.phone1=params?.celular_phone
				if(params?.company_name)
					company.companyName=params?.company_name
				if(params?.cuit)
					company.cuit=params?.cuit
				if(params?.lat)
					company.latitude=Float.valueOf(params?.lat)
				if(params?.lng)
					company.longitude=Float.valueOf(params?.lng)
				if(params?.password)
					company.password=params?.password

				if(company.save())
					render(contentType:'text/json',encoding:"UTF-8") { status=200 }
				render(contentType:'text/json',encoding:"UTF-8") { status=400 }
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=401}
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
}

public enum TypeUser{
	CORPORATEACCOUNT,CORPORATEACCOUNTUSER,USER,EMPLOYUSERDRIVER,EMPLOYUSEROPERATOR
}
