package com.api.technorides

import grails.converters.JSON
import groovyx.net.http.RESTClient

import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.springframework.security.core.Authentication

import ar.com.goliath.Company
import ar.com.goliath.CompanyAccountEmployee
import ar.com.goliath.EmployUser
import ar.com.goliath.MailQueue
import ar.com.goliath.PersistToken
import ar.com.goliath.RealUser
import ar.com.goliath.Role
import ar.com.goliath.UStatus
import ar.com.goliath.User
import ar.com.goliath.UserRole
import ar.com.operation.Operation

import com.Device
class TechnoRidesBillingApiController extends TechnoRidesValidateApiController {
	def technoRidesBillingService
	
	def addExcept(list) {
		list <<'get'
	}
	def get={
		render "asd"
	}
	def jq_billing_history = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			
			def techno= technoRidesBillingService.getBillingHistory(params, rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	
	def jq_billing_no_paid = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesBillingService.getBillingNoPaid(params, rtaxi)
			render techno.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	
}

