package com.notifier

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.Vehicle
import ar.com.notification.*
import ar.com.operation.*
import ar.com.operation.TRANSACTIONSTATUS

import com.TaxiCommand
import com.google.android.gcm.server.Message
import com.google.android.gcm.server.MulticastResult
import com.google.android.gcm.server.Result
import com.google.android.gcm.server.Sender

class GoogleCloudMessagePushService {



	static transactional = false

	def grailsApplication
	/**
	 * Sends a collapse message to one device
	 */
	final String apiKey="AIzaSyD-IDLVq6xgDx6jI-Hf3nXeSVrALTsj6SQ"
	Result sendCollapseMessage(String collapseKey, Map data, String registrationId,
			String apiKey = apiKeyFromConfig()) {
		sendMessage(data, [registrationId], collapseKey, apiKey)
	}

	/**
	 * Sends a collapse message to multiple devices
	 */
	MulticastResult sendMulticastCollapseMessage(String collapseKey, Map data,
			List<String> registrationIds, String apiKey = apiKeyFromConfig()) {
		sendMessage(data, registrationIds, collapseKey, apiKey)
	}
	/**
	 * Sends an instant message to one device
	 */

	Result sendInstantMessage(String title,String message,boolean isEncoded, String registrationId) {
		String apiKey = apiKeyFromConfig()
		def date=new Date()
		Message msg = new Message.Builder()   .collapseKey(date.time.toString())
				.timeToLive(32)
				.delayWhileIdle(true)
				.addData("title", title)
				.addData("message", message)
				.build();
		sender(apiKey).send(msg, registrationId,3)
	}
	Result sendInstantMessage(Notification notification,ConfigurationApp conf) {
		String apiKey = apiKeyFromConfig()
		def date=new Date()
		Sender sender = new Sender(conf.androidToken);
		if(notification?.operation_id){
			log.error "with operation"
			def oper=Operation.get(notification.operation_id)
			if(oper?.taxista && (oper.status==TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI||oper.status==TRANSACTIONSTATUS.INTRANSACTION||oper.status==TRANSACTIONSTATUS.ASSIGNEDTAXI)){
			log.error "with Taxi"
				def res=null
				if(oper.taxista){
					res=new TaxiCommand()
					if(oper?.intermediario){
						res.nombre= oper.taxista.firstName+" "+ oper.taxista.lastName
						def v=Vehicle.findByTaxistas(oper.taxista)
						if(v){
							res.marca=v.marca
							res.patente=v.patente
							res.modelo=v.modelo
						}
						def com=Company.get(oper.intermediario.employee.id)
						if(com){
							res.empresa= com.companyName
							res.companyPhone= com.phone
						}
						res.numeroMovil=oper.taxista.email.split("@")[0]
					}else{
						res.nombre= oper.taxista.firstName+" "+ oper.taxista.lastName
						def v=Vehicle.findByTaxistas(oper.taxista)
						if(v){
							res.marca=v.marca
							res.patente=v.patente
						}
					}
				}
				def onlineTaxi=OnlineDriver.findByDriver(oper.taxista)
				Message msg = new Message.Builder()
						.collapseKey(notification.operation_id.toString())
						.addData("title", notification?.subject?:"")
						.addData("message", notification?.message?:"")
						.addData("code", notification?.code.toString()?:"")
						.addData("opId", notification.operation_id.toString())
						.addData("status", oper.status.toString())
						.addData("company", res.empresa.toString())
						.addData("driverNumber", res.numeroMovil.toString())
						.addData("companyPhone", res.companyPhone.toString())
						.addData("timeTravel", oper.timeTravel.toString())
						.addData("usrLat", oper.favorites.placeFrom.lat.toString())
						.addData("usrLng", oper.favorites.placeFrom.lng.toString())
						.addData("taxiLat", onlineTaxi?.lat?onlineTaxi?.lat.toString():"")
						.addData("taxiLng", onlineTaxi?.lng?onlineTaxi?.lng.toString():"")
						.build();
				log.error "---------------------------------------"
				log.error notification.code_device
				log.error sender.send(msg, notification.code_device,3)
				log.error "---------------------------------------"
			}else{
				Message msg = new Message.Builder()
						.collapseKey(notification.operation_id.toString())
						.addData("title", notification?.subject?:"")
						.addData("message", notification?.message?:"")
						.addData("code", notification?.code.toString()?:"")
						.addData("opId", notification.operation_id.toString())
						.addData("status", oper.status.toString())
						.build();
				log.error "---------------------------------------"
				log.error notification.code_device
				log.error sender.send(msg, notification.code_device,3)
				log.error "---------------------------------------"
			}
		}else{
			Message msg = new Message.Builder()
					.collapseKey(notification.operation_id.toString())
					.addData("title", notification?.subject?:"")
					.addData("message", notification?.message?:"")
					.addData("code", notification?.code.toString()?:"")
					.build();
			log.error "---------------------------------------"
			log.error notification.code_device
			log.error sender.send(msg, notification.code_device,3)
			log.error "---------------------------------------"
		}
	}

	/**
	 * Sends an instant message to one device
	 */
	Result sendInstantMessage(Map data, String registrationId,
			String apiKey = apiKeyFromConfig()) {
		sendMessage(data: data, registrationIds: [registrationId], apiKey: apiKey)
	}

	/**
	 * Sends an instant message to multiple devices
	 */
	MulticastResult sendMulticastInstantMessage(Map data, List<String> registrationIds,
			String apiKey = apiKeyFromConfig()) {
		sendMessage(data:data, registrationIds: registrationIds, apiKey: apiKey)
	}

	/**
	 * Sends a message (instant by default, collapse if a collapse key is provided)
	 * to one or multiple devices, using the given api key (or obtaining it from the config
	 * if none is provided)
	 * @return a Result (if only one registration id is provided) or a MulticastResult
	 */
	def sendMessage(Map data, List<String> registrationIds, String collapseKey = '',
			String apiKey = apiKeyFromConfig()) {
		sender(apiKey).send(buildMessage(data, collapseKey),
				registrationIds.size() > 1 ? registrationIds : registrationIds[0], retries())
	}

	private Message buildMessage(Map data, String collapseKey = '') {
		withMessageBuilder(data) { messageBuilder ->
			if (collapseKey) {
				messageBuilder.collapseKey(collapseKey).timeToLive(timeToLive())
			}
		}
	}

	private Message withMessageBuilder(Map messageData, Closure builderConfigurator = null) {
		Message.Builder messageBuilder = new Message.Builder().delayWhileIdle(delayWhileIdle())
		if (builderConfigurator) {
			builderConfigurator(messageBuilder)
		}
		addData(messageData, messageBuilder).build()
	}

	private addData(Map data, Message.Builder messageBuilder) {
		data.each {
			messageBuilder.addData(it.key, it.value)
		}
		return messageBuilder
	}

	private sender(apiKey) {
		new Sender(apiKey)
	}

	private apiKeyFromConfig() {
		def key = apiKey
		if (!key) {
			throw new Exception(grailsApplication.config.android.gcm.api.key)
		}

		key
	}

	private timeToLive() {
		grailsApplication.config.android.gcm.time.to.live ?: 2419200
	}

	private delayWhileIdle() {
		grailsApplication.config.android.gcm.delay.'while'.idle ?: false
	}

	private retries() {
		grailsApplication.config.android.gcm.retries ?: 1
	}
}
