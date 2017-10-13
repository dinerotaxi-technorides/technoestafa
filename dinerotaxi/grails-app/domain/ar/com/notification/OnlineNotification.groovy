package ar.com.notification

import ar.com.goliath.User
import java.util.Date;

class OnlineNotification {
	String title;
	// mensaje para enviar la push
	String message;
	// email para enviar por emal.
	String args;
	boolean hasEncoded=false;
	Long operation;
	User usr
	boolean isRead=false;
	boolean isForCompany=false;
	Date createdDate
	def beforeInsert = {
		createdDate = new Date()
	}
	
	static constraints = {
		title(nullable:false,blank:false,maxSize:200)
		message(nullable:false,blank:false,maxSize:300)
		args(nullable:true,blank:true,maxSize:300)
		usr(nullable:false)
		operation(nullable:true,maxSize:16)
		createdDate (nullable:true)
	}
}
