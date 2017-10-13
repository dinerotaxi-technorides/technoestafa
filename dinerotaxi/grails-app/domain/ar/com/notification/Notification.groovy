package ar.com.notification

import ar.com.goliath.User

class Notification {
	//ANDROID , IPHONE , BLACKBERRY
	String device_type;
	// codigo para enviar la push
	String code_device;
	// asunto para enviar la push
	String subject;
	// mensaje para enviar la push
	String message;
	// email para enviar por emal.
	String email;
	boolean isEncoded=false;
	String name;
	// operacion involucrada
	Long operation_id;
	// cuando se implemente los mensajes entre chofer y pasajero seria el msj id
	Long message_id
	//
	String app
	// mail push o ambos
	String type;
	// mensaje de alerta para iphone
	String alert_type;
	// numero de alerta para la notificacion del usuario autoincrement
	Integer badge;
	//argumentos para las notificaciones android y iphone
	List<String>argss;
	//sin uso
	String argss_as_string;
	// reintentos para enviar el push
	Integer retries;
	// reintentos para enviar el push
	Integer code;
	// fecha de expiracion del mensaje
	Date expired;

	User user;
	static constraints = {
		code_device(nullable:true,maxSize:500)
		device_type(nullable:true,maxSize:20)
		subject(nullable:true,maxSize:50)
		message(nullable:true,maxSize:1000)
		email(nullable:true,maxSize:100)
		name(nullable:true,maxSize:50)
		operation_id(nullable:true,maxSize:60)
		message_id(nullable:true,maxSize:60)
		alert_type(nullable:true,maxSize:200)
		badge(nullable:true,maxSize:3)
		type(maxSize:20)
		expired(nullable:true)
		code(nullable:true)
		argss(nullable:true)
		user(nullable:true)
	}

	public boolean validateNotification() {
		boolean validate = false;
		if(type!=null && app!=null){
			switch (type){
				case "MAIL":
					validate = email!=null && message !=null && subject != null && email ==~"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}"
					break;
				case "PUSH":
					validate = device_type!=null && code_device!=null && alert_type !=null;
					if(argss && validate)
					//						if(device_type.equals("ANDROID")) {
					//							int i = 0;
					//							while (validate && i<argss.size()) {
					//								validate = argss.get(i)==~"(data\\.)[a-zA-Z0-9_]+=[a-zA-Z0-9_+-]+"
					//								i++
					//							}
					//						}
					break;
				case "MAILANDPUSH":
					validate = email!=null && message !=null && subject != null && device_type!=null && code_device!=null && email ==~"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}"
					if(argss && validate)
					//						if(device_type.equals("ANDROID")) {
					//							int i = 0;
					//							while (validate && i<argss.size()) {
					//								validate = argss.get(i)==~"(data\\.)[a-zA-Z0-9_]+=[a-zA-Z0-9_+-]+"
					//								i++
					//							}
					//						}
					break;
				default:
					break;
			}
		}
		return validate;
	}

	def initialize(){
		retries = 3
		if(argss)
			argss_as_string = argss.toString();
	}
}
