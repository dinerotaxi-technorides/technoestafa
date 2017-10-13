package com

import ar.com.goliath.RealUser
import ar.com.goliath.User

class Device {
	String keyValue;
	String description;
	User user
	UserDevice dev=UserDevice.WEB
	static constraints = {
		user(nullable:false,blank:false)
		keyValue(nullable:true,blank:true,maxSize:200)
		description(nullable:true,blank:true)
	}
}



public enum UserDevice {
	ANDROID,IPHONE,WEB,BB,UNDEFINDED
}