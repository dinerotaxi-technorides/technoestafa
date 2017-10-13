package com.notifier

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils

import ar.com.notification.*
import grails.converters.JSON
class FeedService {
	def androidPushNotifierService;
	def applePushNotifierService;
	def googleCloudMessagePushService
	def emailService
	private boolean send;
	static transactional = false
	private int code;
	private StatusCode status;
	public FeedService(){
	}
	def serviceMethod() {
	}
	def sendNotifications(def notification) {
		if(!notification.validateNotification()){
			status = StatusCode.INVALID_FIELDS_FORMAT;
		}else{
			try {
				def conf=ConfigurationApp.findByApp(notification.app)
				if(conf){
					switch (notification.type) {
						case "MAIL":
							sendMailNotification(notification);
							break;
						case "PUSH":
							sendPushNotification(notification,conf);
							break;
						case "MAILANDPUSH":
							sendMailNotification(notification);
							sendPushNotification(notification,conf);
							break;
					}
				}else{
					status = StatusCode.INVALID_APP
					log.error("The configuration for this app is not setted please configure the ConfigurationApp appId:" +notification.app);
				}
			} catch (Exception e) {
				log.error(e.getMessage());
				status = StatusCode.INTERNAL_ERROR
				saveNotification(notification);
			}
		}
		return status;
	}

	private void sendPushNotification(Notification notification,ConfigurationApp conf)
	throws Exception {
		switch (notification.device_type) {
			case Device.ANDROID.toString():
				sendAndroidNotification(notification,conf);
				break;
			case Device.IPHONE.toString():
				sendIphoneNotification(notification,conf);
				break;
			case Device.BB.toString():
				sendBlackBerryNotification(notification,conf);
				break;
		}
	}
	private void sendAndroidNotification(Notification notification,ConfigurationApp conf) throws IOException {
		log.info( "send android notification")

		//def resu = googleCloudMessagePushService.sendCollapseMessage("acc",new java.util.HashMap(),notification.code_device);
		//def resu = googleCloudMessagePushService.sendInstantMessage(new java.util.HashMap(),notification.code_device);
		//googleCloudMessagePushService.sendInstantMessage(notification?.subject?:"",notification?.message?:"",notification?.isEncoded, notification.code_device)
		googleCloudMessagePushService.sendInstantMessage(notification,conf)
		//		if(!status.equals(StatusCode.GOOGLE_SERVER_UNPARSABLE_RESPONSE) && !status.equals(StatusCode.OK))
		//			saveNotification(notification)
	}
	public static <K, V> java.util.LinkedHashMap<K, V> map(K key0, V value0, Object... pairs) {

		java.util.LinkedHashMap<K, V> map = map();
		map.put(key0, value0);

		for (int i = 0; i < pairs.length - 1; i += 2)
			map.put((K) pairs[i], (V) pairs[i + 1]);

		return map;
	}
	private void sendBlackBerryNotification(Notification notification,ConfigurationApp conf) throws IOException {
		log.info( "send blackberry notification")
	}
	private void sendIphoneNotification(Notification notification,ConfigurationApp conf) throws Exception {
		try {
			log.info( "send iphone notification")
			log.error (conf.appleCertificatePath)
			applePushNotifierService.initConnection(conf.appleIp,
					conf.applePort,conf.appleCertificatePath, conf.applePassword);
			applePushNotifierService.sendPushNotification(notification);
			status = StatusCode.OK
		}catch (NumberFormatException e){
			status = StatusCode.INVALID_DEVICE_ID;
		} catch (Exception e) {
			log.error(
					"Error while sending notifications to apple: "
					+ e.getMessage());
			status = StatusCode.IPHONE_NOTIFICATION_FAILED;
			saveNotification(notification)
		} finally {
			applePushNotifierService.endConnection();
			log.info( "finish iphone notification")
		}
	}

	private void saveNotification(Notification notification){
		notification.retries--;
		switch(notification.retries){
			case 2:
				notification.save(flush:true)
				break;
			case 1:
				notification.save(flush:true)
				break;
			case 0:
				notification.delete()
				break;
		}
	}


	private sendMailNotification(Notification notification)	throws Exception {
		def conf = SpringSecurityUtils.securityConfig


		def body =  g.render(template:"/emailconfirmation/baseMail", model:[body: notification.message]).toString()

		emailService.send(notification.email, conf.ui.register.emailFrom, notification.subject,  body.toString())
	}
}
enum Device {
	ANDROID("ANDROID"), IPHONE("IPHONE"),BB("BB")
	Device(String value) {
		this.value = value
	}
	private final String value
	public String value() {
		return value
	}
}