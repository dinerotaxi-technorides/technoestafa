package com.api
import ar.com.favorites.*
import ar.com.operation.Operation
import grails.converters.JSON
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;

import ar.com.goliath.*


import org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib
import ar.com.goliath.RealUser;
import ar.com.goliath.PersistToken
import ar.com.notification.OnlineNotification
import com.NotificationApiCommand
import com.NotificationCommand
class NotificationApiController {
	def springSecurityService
	def onlineNotificationService
	// the delete, save and update actions only accept POST requests
	//static allowedMethods = [createTrip:'POST']

	def decodeMsgAndTittle={
		def g =new ApplicationTagLib()
		def sub= params?.tittle ?g.message( code : params?.tittle ):""
		def mess= params?.message?g.message( code : params?.message ):""
		render(contentType:'text/json',encoding:"UTF-8") {
			status=100
			conversionMessage=mess
			conversionTittle=sub
		}

	}
	def getAllNotificationsNotReader={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def oper=onlineNotificationService.getNotificationsNotRead(usr)
					if(oper){
						List<NotificationCommand> not=new ArrayList<NotificationCommand>();
						oper.each{
							not.add(new NotificationCommand(it))
						}
						def osfx=not
						if(params?.markRead){
							onlineNotificationService.setAllNotificationsRead(usr)
						}
						render(contentType:'text/json',encoding:"UTF-8") {
							status=100
							notifications=osfx
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=100 }
					}

				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def hasPendingNotifications={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					log.debug "preguntando notification ${usr}"
					def oper=onlineNotificationService.getCountNotificationsNotRead(usr)
					render(contentType:'text/json',encoding:"UTF-8") {
						status=100
						count=oper
					}

				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def markAllNotificationReader={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def oper=onlineNotificationService.setAllNotificationsRead(usr)
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }

				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def markNotificationReader={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def notif= OnlineNotification.get(params?.id)
					if(notif){
						if(notif.usr==usr){
							notif.isRead=true
							notif.save(flush:true);
							render(contentType:'text/json',encoding:"UTF-8") { status=100 }
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=100 }
						}

					}

				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def markListNotificationReader={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					if(params?.ids){
						def ids=params?.ids.split(",")
						ids.each{
							def operationInstance = OnlineNotification.get(it)
							if(operationInstance){
								if (operationInstance.usr==usr){
									operationInstance.isRead=true;
									operationInstance.save(flush:true);
								}
							}
						}
						render(contentType:'text/json',encoding:"UTF-8") { status=100 }
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=125 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
}

