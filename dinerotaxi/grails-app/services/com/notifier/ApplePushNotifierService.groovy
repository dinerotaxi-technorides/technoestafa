package com.notifier

import ar.com.notification.*

import javapns.back.PushNotificationManager
import javapns.back.SSLConnectionHelper
import javapns.data.Device
import javapns.data.PayLoad
import javapns.data.PayLoadCustomAlert


import org.apache.log4j.Logger

class ApplePushNotifierService {

	static transactional = true
	static final Logger log = Logger.getLogger(ApplePushNotifierService.class);
	static String sound = "default";
	private static String device_type = "iPhone";
	def serviceMethod() {
	}

	private static PushNotificationManager pushManager;

	private ApplePushNotifier() {
	}

	public static void initConnection(String ip, int port,
	String certificatePath, String password) throws Exception {

		// Conecta a APNs
		pushManager = PushNotificationManager.getInstance();

		log.info("Initializing connectiong with APNS...");
		pushManager.initializeConnection(ip, port, certificatePath, password,
				SSLConnectionHelper.KEYSTORE_TYPE_PKCS12);
	}

	public void  sendPushNotification(Notification notification) throws Exception {

		PayLoad payLoad = new PayLoad();
		if(notification.badge)
			payLoad.addBadge(notification.badge);
		payLoad.addSound(sound);
		addCustomDictionaries(payLoad,notification)
		/*
		 * En principio siempre agrego un device y despues lo saco. Podria
		 * cambiarse...
		 */	
		pushManager.addDevice(device_type, notification.code_device);
		Device client = pushManager.getDevice(device_type);
		pushManager.removeDevice(device_type);

		// Mando push
//		log.info("Sending push notification...");
//		
//		
//		String as222d=new String(payLoad.payloadAsBytes, "UTF8")
//		
//		
//		
//		log.info("----------------------------");
		PushNotificationManager.getInstance().sendNotification(client, payLoad);
	}

	public void endConnection() throws Exception {
		pushManager.stopConnection();
		log.info("Connection stopped!");
	}

	public void addCustomDictionaries(PayLoad payLoad,Notification notification){
			PayLoadCustomAlert alert = new PayLoadCustomAlert();
			alert.addLocKey(notification.alert_type);
			if(notification.argss) {
				List<String>keys = new ArrayList<String>();
				for (String param : notification.argss) {
					String[] params = param.split("=",2);
					if(params.length ==2) {
						payLoad.addCustomDictionary(params[0], params[1]);
					}else{
						keys.add(param);
					}
				}
				alert.addLocArgs(keys);
			}
			payLoad.addCustomAlert(alert);
				
	}
}
