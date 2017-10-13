
package com.api

import static grails.async.Promises.*
import static groovyx.net.http.ContentType.URLENC
import grails.converters.JSON

import javax.servlet.*
import javax.servlet.http.*

import org.codehaus.groovy.grails.commons.*

import ar.com.favorites.*
import ar.com.goliath.*
import ar.com.operation.*

import com.*
import com.api.utils.*
class InboxApiController {
	
	def inbox = {
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=Company.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def status_in = INBOXSTATUS.DRIVER
		if(params?.status)
			status_in = INBOXSTATUS.get(params.status.toString())
		def mails = Inbox.createCriteria().list() {
			eq('rtaxi',usr)
			eq('trashed',false)
			eq('status',status_in)
		}
		print mails
		def m_collected = mails.collect {
			[
				id:it.id,
				lastUpdated: it.lastUpdated,
				from:it.from?:'',
				subject:it.subject?:0.0,
				body:it.body?:'',
				wasReaded:it.wasReaded?:'',
				hasStar:it.hasStar
			]
		}
		def jsonData= [rows: m_collected,status:100]
		render jsonData as JSON
		return false

	}
	def star_list = {
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=Company.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def trash = params?.trashed?:false
		def stars = params?.hasStars?:false
		def wasReaded = params?.wasReaded?:false
		def status_in = INBOXSTATUS.DRIVER
		if(params?.status)
			status_in = INBOXSTATUS.get(params.status.toString())
		
		def mails = Inbox.createCriteria().list() {
			eq('rtaxi',usr)
			eq('trashed',false)
			eq('hasStar',true)
			eq('status',status_in)
		}
		print mails
		def m_collected = mails.collect {
			[
				id:it.id,
				lastUpdated: it.lastUpdated,
				from:it.from?:'',
				subject:it.subject?:0.0,
				body:it.body?:'',
				wasReaded:it.wasReaded?:'',
				hasStar:it.hasStar
			]
		}
		def jsonData= [rows: m_collected,status:100]
		render jsonData as JSON
		return false

	}
	def trash_list = {
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=Company.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def trash = params?.trashed?:false
		def stars = params?.hasStars?:false
		def wasReaded = params?.wasReaded?:false
		def status_in = INBOXSTATUS.DRIVER
		if(params?.status)
			status_in = INBOXSTATUS.get(params.status.toString())
			
		def mails = Inbox.createCriteria().list() {
			eq('rtaxi',usr)
			eq('trashed',true)
			eq('status',status_in)
		}
		print mails
		def m_collected = mails.collect {
			[
				id:it.id,
				lastUpdated: it.lastUpdated,
				from:it.from?:'',
				subject:it.subject?:0.0,
				body:it.body?:'',
				wasReaded:it.wasReaded?:'',
				hasStar:it.hasStar
			]
		}
		def jsonData= [rows: m_collected,status:100]
		render jsonData as JSON
		return false

	}
	def markReaded = {
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=Company.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def inboxP = Inbox.get(params.inbox_id)
		if(inboxP && inboxP.rtaxi == usr){
			inboxP.wasReaded = !inboxP.wasReaded
			inboxP.save()
			render(contentType: 'text/json',encoding:"UTF-8") { status=200 }
			return false
		}
		render(contentType: 'text/json',encoding:"UTF-8") { status=400 }
		return false
	}
	def trash = {
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=Company.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def inboxP = Inbox.get(params.inbox_id)
		if(inboxP && inboxP.rtaxi == usr){
			inboxP.trashed = !inboxP.trashed
			inboxP.save()
			render(contentType: 'text/json',encoding:"UTF-8") { status=200 }
			return false
		}
		render(contentType: 'text/json',encoding:"UTF-8") { status=400 }
		return false
	}
	def star = {
		def tok=PersistToken.findByToken(params.token)
		if(!tok){
			render(contentType: 'text/json',encoding:"UTF-8") { status=411 }
			return false
		}
		def usr=Company.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		if(!usr){
			render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
			return false
		}
		def inboxP = Inbox.get(params.inbox_id)
		if(inboxP && inboxP.rtaxi == usr){
			inboxP.hasStar = !inboxP.hasStar
			inboxP.save()
			render(contentType: 'text/json',encoding:"UTF-8") { status=200 }
			return false
		}
		render(contentType: 'text/json',encoding:"UTF-8") { status=400 }
		return false
	}
	
	def send_email = {
		try {
			print "-------------"
			print params
			print "-------------"
			def usr=Company.findByUsername(params?.to)
			if(!usr){
				render(contentType: 'text/json',encoding:"UTF-8") { status=412 }
				return false
			}
			def status_in = INBOXSTATUS.DRIVER
			if(params?.status){
				status_in = INBOXSTATUS.get(params.status.toString())
			}
				
			def inboxP = new Inbox()
			inboxP.from      = params?.from
			inboxP.subject   = params?.subject
			inboxP.body      = params?.message
			inboxP.status    = status_in
			inboxP.rtaxi     = usr
			if (! inboxP.hasErrors() && inboxP.save(flush:true)) {
				render(contentType: 'text/json',encoding:"UTF-8") { status=200 }
				return false
			}else{
				print "asasdasd"
				inboxP.errors.allErrors.each  {
					print it
				}
				render(contentType: 'text/json',encoding:"UTF-8") { status=400 }
				return false
			}
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType: 'text/json',encoding:"UTF-8") { status=11 }
		}
		
	}
}

