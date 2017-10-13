package com

import java.util.Date;

class Spam {
	String msj;
	Integer maxx
	SpamType type=SpamType.NOUSER
	UserDevice dev=UserDevice.WEB
	Date createdDate;
	Date lastModifiedDate;
	boolean hadRuning
	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }
	static constraints = {
		createdDate(nullable:true,blank:true)
		lastModifiedDate(nullable:true,blank:true)
		msj(nullable:true,blank:true,size:0..65535)
		maxx(nullable:true,blank:true)
		type(nullable:true,blank:true)
	}
}
public enum SpamType{
	NOUSER,USER,RECOVERUSERS
}