package com.notifier

import javapns.*
import javapns.notification.*

import org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib

import ar.com.goliath.*
import ar.com.notification.*
import ar.com.operation.*

import com.Device
import com.NotificationCommand
import com.UserDevice
class MobileNotificationService   {
	def grailsApplication
	def feedService
	boolean transactional = true

	void setNotification(Operation op,User usr,String titt,String mess,Device dev,int code){
		def app="DINEROTAXI"
		if(usr?.rtaxi){
			titt=titt.replaceAll("DineroTaxi.com", usr?.rtaxi.companyName)
			mess=mess.replaceAll("DineroTaxi.com", usr?.rtaxi.companyName)
			if(usr?.rtaxi?.wlconfig){
				app=usr?.rtaxi?.wlconfig?.app
			}
		}
		def notiCom=new NotificationCommand(op,usr,titt,mess)
		List<String> argss=new ArrayList<String>();
		argss.add("id=${op.id}")
		argss.add("status=${op.status}")
		argss.add("code=${code}")

		def not
		if(dev.dev==UserDevice.IPHONE ){
			not= new ar.com.notification.Notification(user:usr,device_type:"IPHONE",code_device:dev.keyValue,type:"PUSH",retries:3,app:app,argss_as_string:"",alert_type:mess.toString(),badge:1)
		}else if(dev.dev==UserDevice.ANDROID ){
			not= new ar.com.notification.Notification(operation_id:op.id,subject:notiCom.subject,message:notiCom.message,
				user:usr,device_type:"ANDROID",code_device:dev.keyValue,type:"PUSH",retries:3,app:app,argss_as_string:"",
				alert_type:mess.toString(),badge:1)
		}else{
			return;
		}
		not.argss=argss
		not.code=code
		not.argss_as_string= "id=${op.id}"+"&status=${op.status}"+"&code=${code}"
		if(!not.save(flush:true)){
			not.errors.each{ log.debug it }
		}
		try{
			def status = feedService.sendNotifications(not)
			if(status.equals(StatusCode.OK))
				not.delete()
		}catch (Exception e){
			log.error  e
		}
	}

	def notificateOnCreateTrip(Operation op,User usr,Device dev){
		log.debug("INICIO notificateOnCreateTrip")
		String dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def appTagLib =new ApplicationTagLib()
		String sub= appTagLib.message( code : 'online.notification.on.create.trip.tittle' ) as String
		String mess= appTagLib.message( code : 'online.notification.on.create.trip.message', args : [dir as String ]) as String
		try{
			setNotification(op,usr,sub,mess,dev,2000)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnCreateTrip")
	}
	def notificateOnCreateTripWithFavorite(Operation op,User usr,Device dev){
		log.debug("INICIO notificateOnCreateTripWithFavorite")
		String dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def appTagLib =new ApplicationTagLib()
		String sub= appTagLib.message( code : 'online.notification.on.create.trip.tittle' ) as String
		String mess= appTagLib.message( code : 'online.notification.on.create.tripf.message', args : [dir as String ]) as String
		try{
			setNotification(op,usr,sub,mess ,dev,2001)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnCreateTripWithFavorite")
	}

	def notificateOnCancelTripByUser(Operation op,User usr,Device dev){
		log.debug("INICIO notificateOnCreateTripWithFavorite")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.cancel.trip.tittle' )
		def mess= g.message( code : 'online.notification.on.cancel.trip.message', args : [dir as String ])

		try{
			setNotification(op,usr,sub,mess ,dev,2002)
		}catch(Exception e){
			log.error e
		}

		log.debug("FIN notificateOnCreateTripWithFavorite")
	}
	def notificateOnCancelOther(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnCancelWeNoVeTaxi")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub= 'online.notification.on.cancel.other.tittle'
		def mess='online.notification.on.cancel.other.message'
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub= appCtx.getMessage( sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess= appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2003)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code :mess, args : [dir as String ])
			try{
				setNotification(op,usr,sub,mess,dev,2003)
			}catch(Exception e){
				log.error e
			}
		}
	}

	def notificateOnCancelWeNoVeTaxi(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnCancelWeNoVeTaxi")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub= 'online.notification.on.cancel.not.ve.taxi.trip.tittle'
		def mess='online.notification.on.cancel.not.ve.taxi.trip.message'
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub= appCtx.getMessage( sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess= appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2004)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code :mess, args : [dir as String ])
			try{
				setNotification(op,usr,sub,mess,dev,2004)
			}catch(Exception e){
				log.error e
			}
		}

		log.debug("FIN notificateOnCancelWeNoVeTaxi")
	}
	def notificateOnCancelOfflineRadioTaxi(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnCancelOfflineRadioTaxi")
		def dir=null
		if(op?.company?.phone){
			dir=op?.company?.phone
		}else if(usr?.rtaxi?.phone){
			dir=usr?.rtaxi?.phone
		}

		def sub= 'online.notification.on.cancel.not.ve.company.tittle'
		def mess='online.notification.on.cancel.not.ve.company.message'
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub= appCtx.getMessage( sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess= appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2005)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code :mess, args : [dir as String ])
			try{
				setNotification(op,usr,sub,mess,dev,2005)
			}catch(Exception e){
				log.error e
			}
		}

		log.debug("FIN notificateOnCancelOfflineRadioTaxi")
	}

	def notificateOnCancelRadiotaxiWhenUserCallDismiss(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnCancelRadiotaxiWhenUserCallDismiss")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub='online.notification.on.cancel.dismiss.trip.tittle'
		def mess='online.notification.on.cancel.dismiss.trip.message'
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub= appCtx.getMessage( sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess= appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2006)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code :mess, args : [dir as String ])
			try{
				setNotification(op,usr,sub,mess,dev,2006)
			}catch(Exception e){
				log.error e
			}
		}

		log.debug("FIN notificateOnCancelRadiotaxiWhenUserCallDismiss")
	}
	def notificateOnCancelInvalidPhone(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnCancelInvalidPhone")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub= 'online.notification.on.cancel.invalid.phone.tittle'
		def mess='online.notification.on.cancel.invalid.phone.message'
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub= appCtx.getMessage( sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess= appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2007)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code :mess, args : [dir as String ])
			try{
				setNotification(op,usr,sub,mess,dev,2007)
			}catch(Exception e){
				log.error e
			}
		}

		log.debug("FIN notificateOnCancelInvalidPhone")
	}
	def notificateOnCancelWeNoVeACompanyTaxi(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnCancelWeNoVeACompanyTaxi")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub='online.notification.on.cancel.not.ve.taxi.trip.tittle'
		def mess='online.notification.on.cancel.not.ve.company.trip.message'
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub= appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2008)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : [dir as String ])
			try{
				setNotification(op,usr,sub,mess,dev,2008)
			}catch(Exception e){
				log.error e
			}
		}

		log.debug("FIN notificateOnCancelWeNoVeACompanyTaxi")
	}



	def notificateOnTripInProgress(Operation op,User usr,Device dev){
		log.debug("INICIO notificateOnTripInProgress")
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.progress.trip.tittle' )
		def mess= g.message( code : 'online.notification.on.progress.trip.message' )
		try{
			setNotification(op,usr,sub,mess,dev,2009)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnTripInProgress")
	}
	def notificateOnTripTaxiSelect(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnTripTaxiSelect")

		def sub='online.notification.on.taxi.select.trip.tittle'
		def mess='online.notification.on.taxi.select.trip.message'
		def dir;
		if(op?.intermediario){
			def ops =op.company.refresh()
			def empresa=Company.get(ops.id)
			def name=op.taxista.email.split("@")[0]
			dir=  [name , op.timeTravel]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			dir=  [
				name as String ,
				ve.patente as String ,
				ve.marca as String
			]
		}
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2010)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
			try{
				setNotification(op,usr,sub,mess,dev,2010)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripTaxiSelect")
	}
	def notificateOnTripTaxiSelectByTaxi(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnTripTaxiSelect")

		def sub='online.notification.on.taxi.select.trip.tittle'
		def mess='online.notification.on.taxi.select.by.taxi.trip.message'
		def dir;
		if(op?.intermediario){
			def ops =op.company.refresh()
			def empresa=Company.get(ops.id)
			def name=op.taxista.email.split("@")[0]
			dir=  [name ]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			dir=  [
				name as String ,
				ve.patente as String ,
				ve.marca as String
			]
		}
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2011)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
			try{
				setNotification(op,usr,sub,mess,dev,2011)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripTaxiSelect")
	}
	def notificateOnTripTimeOutRadioTaxiSelect(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnTripTimeOutRadioTaxiSelect")

		def sub='online.notification.on.cancel.company.not.ve.taxi.trip.tittle'
		def mess='online.notification.on.cancel.company.timeout.trip.message'
		def dir;

		if(op?.user?.rtaxi!=null){
			mess=mess.replaceAll("company", "radio.taxi");
			sub=sub.replaceAll("company", "radio.taxi");

		}
		if(op?.intermediario){
			op.intermediario.refresh()
			def empresa=Company.get(op?.intermediario?.employee.id)
			dir=  [
				empresa.companyName as String
			]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			dir=  [
				name as String ,
				ve.patente as String ,
				ve.marca as String
			]
		}
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2012)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : dir)
			try{
				setNotification(op,usr,sub,mess,dev,2012)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripTimeOutRadioTaxiSelect")
	}
	def notificateOnTripRejectRadioTaxiSelect(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnTripRejectRadioTaxiSelect")
		def sub='online.notification.on.cancel.company.not.ve.taxi.trip.tittle'
		def mess='online.notification.on.cancel.company.not.ve.taxi.trip.message'
		def dir;

		if(op?.user?.rtaxi!=null){
			mess=mess.replaceAll("company", "radio.taxi");
			sub=sub.replaceAll("company", "radio.taxi");

		}
		if(op?.intermediario){
			op.intermediario.refresh()
			def empresa=Company.get(op?.intermediario?.employee.id)
			dir=  [
				empresa.companyName as String
			]
		}else{
			def name=""
			if(op.taxista?.firstName){
				name=name+op.taxista?.firstName +" "
			}
			if(op.taxista?.lastName){
				name=name+op.taxista?.lastName
			}
			def ve =Vehicle.findByTaxista(op.taxista)
			dir=  [
				name as String ,
				ve.patente as String ,
				ve.marca as String
			]
		}
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					dir  as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2013)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : dir)
			try{
				setNotification(op,usr,sub,mess,dev,2013)
			}catch(Exception e){
				log.error e
			}
		}

		log.debug("FIN notificateOnTripRejectRadioTaxiSelect")
	}
	def notificateOnTripRadioTaxiSelect(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnTripRadioTaxiSelect")
		def sub='online.notification.on.radio.taxi.select.trip.tittle'
		def mess='online.notification.on.radio.taxi.select.trip.message'
		def dir;

		if(op?.intermediario){
			op.intermediario.refresh()
			def empresa=Company.get(op?.intermediario?.employee.id)
			dir=  [
				empresa.companyName as String
			]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			dir=  [
				name as String ,
				ve.patente as String ,
				ve.marca as String
			]
		}
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					dir as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2014)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : dir)
			try{
				setNotification(op,usr,sub,mess,dev,2014)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripRadioTaxiSelect")
	}
	def notificateOnReasignTripTaxiSelect(Operation op,User usr,Device dev){
		log.debug("INICIO notificateOnReasignTripTaxiSelect")
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.taxi.reasign.trip.tittle' )
		def mess=null
		if(op?.intermediario){
			def empresa=Company.get(op?.intermediario.employee.id)
			def name=op.taxista.email.split("@")[0]
			mess= g.message( code : 'online.notification.on.taxi.reasign.trip.message', args : [name as String ])
		}else{
			def name=op.taxista?.firstName+" "+op.taxista?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			mess= g.message( code : 'online.notification.on.taxi.reasign.trip.message', args : [
				name as String ,
				ve.patente as String ,
				ve.marca as String ]
			)
		}
		try{
			setNotification(op,usr,sub,mess,dev,2015)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnReasignTripTaxiSelect")
	}
	def notificateOnReasignTripRadioTaxiSelect(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnReasignTripRadioTaxiSelect")
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.radio.taxi.reasign.trip.tittle' )
		def mess=null
		if(op?.intermediario){
			def empresa=Company.get(op?.intermediario.employee.id)
			mess= g.message( code : 'online.notification.on.radio.taxi.reasign.trip.message', args : [
				empresa.companyName as String ]
			)
		}else{
			def name=op.taxista?.firstName+" "+op.taxista?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			mess= g.message( code : 'online.notification.on.radio.taxi.reasign.trip.message', args : [
				name as String ,
				ve.patente as String ,
				ve.marca as String ]
			)
		}
		try{
			setNotification(op,usr,sub,mess,dev,2016)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnReasignTripRadioTaxiSelect")
	}
	def notificateOnTripFinish(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnTripFinish")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub= 'online.notification.on.finish.trip.tittle'
		def mess='online.notification.on.finish.trip.message'
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					[dir as String] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2017)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess)
			try{
				setNotification(op,usr,sub,mess,dev,2017)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripFinish")
	}
	def notificateOnTripCalificate(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnTripCalificate")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub= 'online.notification.on.calificate.trip.tittle'
		def mess='online.notification.on.calificate.trip.message'
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2018)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess)

			try{
				setNotification(op,usr,sub,mess,dev,2018)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripCalificate")
	}
	def notificateOnTripHoldingUser(Operation op,User usr,boolean isEncoded,Device dev){
		log.debug("INICIO notificateOnTripHoldingUser")
		def sub='online.notification.on.holding.trip.tittle'
		def mess='online.notification.on.holding.trip.message'
		def dir;

		if(op?.intermediario){
			op.intermediario.refresh()
			def empresa=Company.get(op?.intermediario?.employee.id)
			dir=  [
				empresa.companyName as String
			]
		}else{
			def name=""
			if(op.taxista?.firstName){
				name=name+op.taxista?.firstName +" "
			}
			if(op.taxista?.lastName){
				name=name+op.taxista?.lastName
			}
			def ve =Vehicle.findByTaxista(op.taxista)
			dir=  [
				name as String ,
				ve.patente as String ,
				ve.marca as String
			]
		}
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					dir  as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2019)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : dir)
			try{
				setNotification(op,usr,sub,mess,dev,2019)
			}catch(Exception e){
				log.error e
			}
		}

		log.debug("FIN notificateOnTripHoldingUser")
	}
	def notificateOnTripIsNotAsigned(Operation op,User usr,boolean isEncoded,Device dev,Integer counter){
		log.debug("INICIO notificateOnTripIsNotAsigned")
		def sub= 'online.notification.on.trip.is.not.asigned.tittle'
		def mess='online.notification.on.trip.is.not.asigned.message.'+counter
		if(usr?.rtaxi){
			mess=mess+".wl"
		}
		if(isEncoded){
			def appCtx = grailsApplication.getMainContext()
			sub=appCtx.getMessage(sub,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			mess=appCtx.getMessage(mess,
					[] as Object[],
					"default message",
					new java.util.Locale("EN"))
			try{
				setNotification(op,usr,sub,mess,dev,2020+counter)
			}catch(Exception e){
				log.error e
			}
		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess=g.message( code : mess )

			try{
				setNotification(op,usr,sub,mess,dev,2020+counter)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripIsNotAsigned")
	}
	def notificateSpam(message,Device dev){
		log.debug("INICIO notificateSpam ${dev.user}")

		try{
			List<String> argss=new ArrayList<String>();
			argss.add("status=PENDING")
			def not
			if(dev.dev==UserDevice.IPHONE ){
				not= new ar.com.notification.Notification(user:dev.user,device_type:"IPHONE",code_device:dev.keyValue,type:"PUSH",retries:3,app:"DINEROTAXI",argss_as_string:"",alert_type:message.toString(),badge:1)
			}else if(dev.dev==UserDevice.ANDROID ){
				not= new ar.com.notification.Notification(subject:message,message:message,user:dev.user,device_type:"ANDROID",code_device:dev.keyValue,type:"PUSH",retries:3,app:"DINEROTAXI",argss_as_string:"",alert_type:message,badge:1)
			}else{
				return;
			}
			not.argss=argss
			//es necesario poner args sino no envia error typo malformed
			not.argss_as_string= "status=PENDING"
			if(!not.save(flush:true)){
				not.errors.each{ log.debug it }
			}
			try{
				def status = feedService.sendNotifications(not)
				if(status.equals(StatusCode.OK))
					not.delete()
			}catch (Exception e){
				log.error  e
			}
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateSpam")
	}
	def getNotificationsNotRead(User usr){
		def c = ar.com.notification.OnlineNotification.createCriteria()
		def results = c.list(){
			and{
				eq('usr', usr)
				eq('isRead',false)
			}
		}
		return results
	}
	def getCountNotificationsNotRead(User usr){
		def c = ar.com.notification.OnlineNotification.createCriteria()
		def results = c.get(){
			and{
				eq('usr', usr)
				eq('isRead',false)
			}
			projections{ count("id") }
		}
		return results
	}
	def setReadOldOperation(User usr,Long op){
		def c = ar.com.notification.OnlineNotification.createCriteria()
		def results = c.list(){
			and{
				eq('usr', usr)
				eq('operation', op)
				eq('isRead',false)
			}
		}
		results.each {
			it.isRead=true
			it.save(flush:true)
		}

		return results
	}
	def getAllNotifications(User usr){
		def c = ar.com.notification.OnlineNotification.createCriteria()
		def results = c.list(){
			and{ eq('usr', usr) }
		}
		return results
	}
	def setAllNotificationsRead(User usr){
		def nt=getNotificationsNotRead(usr)
		nt.each{
			it.isRead=true
			it.save(flush:true)
		}
		return true
	}
}
