package com.api

import groovy.json.JsonSlurper
import ar.com.goliath.PersistToken;

import com.Device;
import com.OrderDetails
import com.Orders
import com.Product
import com.Shippers;

import grails.converters.*
class StaticProvidersController {

	def index = {
		redirect (action:'index' ,controller:'inicio')
	}

	def devices={
		if(checkUser(params)){
			def dev=(ArrayList)Device.list()
			render dev as JSON
		}else{
			render "error"
		}
	}
	def shippers={
		if(checkUser(params)){
			def dev=Shippers.list()
			render dev as JSON
		}else{
			render "error"
		}
	}
	def payments={
		if(checkUser(params)){
			def dev=Payment.list()
			render dev as JSON
		}else{
			render "error"
		}
	}
	def products={
		if(checkUser(params)){
			def dev=com.Product.list()
			render dev as JSON
		}else{
			render "error"
		}
	}
	def categories={
		if(checkUser(params)){
			def dev=com.Category.list()
			render dev as JSON
		}else{
			render "error"
		}
	}
	
	def createOrder = {
		String msg="";
		if(checkUser(params)){
			def pojo1 = new JsonSlurper().parseText( params?.json )
			
			Orders pojo =new Orders(pojo1)
			if(!pojo.hasErrors() && pojo.save(flush:true)) {
				msg= "Ok"
			}
		}
		msg=msg==""? "error":msg
		render msg
	}
	
	private String checkUser(params){
		def usr=PersistToken.findByTokenAndUsername(params?.token,params?.username)
		return usr
	}
}
