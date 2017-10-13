package com.notifier

import javapns.*
import javapns.notification.*

import org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib

import ar.com.goliath.*
import ar.com.notification.*
import ar.com.operation.*

import com.NotificationCommand
class AndroidNotificationService   {
	def grailsApplication
	def feedService
    boolean transactional = true

	void setNotification(Operation op,User usr,String titt,String mess,String args,String key,boolean isEncoded=false){
		def notiCom=new NotificationCommand(op,usr,titt,mess)
		List<String> argss=new ArrayList<String>();
		argss.add("id=${op.id}")
		argss.add("status=${op.status}")
		def not= new ar.com.notification.Notification(subject:notiCom.subject,message:notiCom.message,user:usr,device_type:"ANDROID",code_device:key,type:"PUSH",retries:3,app:"DINEROTAXI",argss_as_string:"",alert_type:mess.toString(),badge:1)
		not.argss=argss
		not.argss_as_string= "id=${op.id}"+"status=${op.status}"
		not.isEncoded=isEncoded
		if(!not.save(flush:true)){
		}
		try{
			def status = feedService.sendNotifications(not)
			if(status.equals(StatusCode.OK))
				not.delete()
		}catch (Exception e){
			log.error  e
		}
	}
	void setNotification(OperationHistory op,User usr,String titt,String mess,String args,String key,boolean isEncoded=false){
		def notiCom=new NotificationCommand(op,usr,titt,mess)
		List<String> argss=new ArrayList<String>();
		argss.add("id=${op.id}")
		argss.add("status=${op.status}")
		def not= new ar.com.notification.Notification(subject:notiCom.subject,message:notiCom.message,user:usr,device_type:"ANDROID",code_device:key,type:"PUSH",retries:3,app:"DINEROTAXI",argss_as_string:"",alert_type:mess.toString(),badge:1)
		not.argss=argss
		not.argss_as_string= "id=${op.id}"+"status=${op.status}"
		not.isEncoded=isEncoded
		if(!not.save(flush:true)){
		}
		try{
			def status = feedService.sendNotifications(not)
			if(status.equals(StatusCode.OK))
				not.delete()
		}catch (Exception e){
			log.error  e

		}
	}
	void setNotification(OperationPending op,User usr,String titt,String mess,String args,String key,boolean isEncoded=false){
		def notiCom=new NotificationCommand(op,usr,titt,mess)
		List<String> argss=new ArrayList<String>();
		argss.add("id=${op.id}")
		argss.add("status=${op.status}")
		def not= new ar.com.notification.Notification(subject:notiCom.subject,message:notiCom.message,user:usr,device_type:"ANDROID",code_device:key,type:"PUSH",retries:3,app:"DINEROTAXI",argss_as_string:"",alert_type:mess.toString(),badge:1)
		not.argss=argss
		not.argss_as_string= "id=${op.id}"+"status=${op.status}"
		not.isEncoded=isEncoded
		if(!not.save(flush:true)){
		}
		try{
			def status = feedService.sendNotifications(not)
			if(status.equals(StatusCode.OK))
				not.delete()
		}catch (Exception e){
			log.error  e

		}
	}
	def notificateOnCreateTrip(Operation op,User usr,String key){
		log.debug("INICIO notificateOnCreateTrip")
		String dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def appTagLib =new ApplicationTagLib()
		String sub= appTagLib.message( code : 'online.notification.on.create.trip.tittle' ) as String
		String mess= appTagLib.message( code : 'online.notification.on.create.trip.message', args : [ dir as String ] ) as String
		try{
			setNotification(op,usr,sub,mess,null ,key)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnCreateTrip")
	}

	def notificateOnCreateTripWithFavorite(Operation op,User usr,String key){
		log.debug("INICIO notificateOnCreateTripWithFavorite")
		String dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def appTagLib =new ApplicationTagLib()
		String sub= appTagLib.message( code : 'online.notification.on.create.trip.tittle' ) as String
		String mess= appTagLib.message( code : 'online.notification.on.create.tripf.message', args : [ dir as String ] ) as String
		try{
			setNotification(op,usr,sub,mess,null ,key)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnCreateTripWithFavorite")
	}

	def notificateOnCancelTripByUser(Operation op,User usr,String key){
		log.debug("INICIO notificateOnCreateTripWithFavorite")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.cancel.trip.tittle' )
		def mess= g.message( code : 'online.notification.on.cancel.trip.message', args : [ dir as String ] )

		try{
			setNotification(op,usr,sub,mess,null ,key)
		}catch(Exception e){
			log.error e
		}

		log.debug("FIN notificateOnCreateTripWithFavorite")
	}
	def notificateOnCancelWeNoVeTaxi(Operation op,User usr,boolean isEncoded,String key){
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
			   setNotification(op,usr,sub,mess,dir as String  ,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code :mess, args : [ dir as String ] )
		   try{
			   setNotification(op,usr,sub,mess,null ,key)
		   }catch(Exception e){
			   log.error e
		   }
		}

		log.debug("FIN notificateOnCancelWeNoVeTaxi")

	}
	def notificateOnCancelWeNoVeACompanyTaxi(Operation op,User usr,boolean isEncoded,String key){
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
			   setNotification(op,usr,sub,mess,dir   ,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : [ dir as String ] )
		   try{
			   setNotification(op,usr,sub,mess,null ,key)
		   }catch(Exception e){
			   log.error e
		   }
		}

		log.debug("FIN notificateOnCancelWeNoVeACompanyTaxi")

	}



	def notificateOnTripInProgress(Operation op,User usr,String key){
		log.debug("INICIO notificateOnTripInProgress")
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.progress.trip.tittle' )
		def mess= g.message( code : 'online.notification.on.progress.trip.message' )
		try{
			setNotification(op,usr,sub,mess,null ,key)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnTripInProgress")

	}
	def notificateOnTripTaxiSelect(Operation op,User usr,String key,boolean isEncoded){
		log.debug("INICIO notificateOnTripTaxiSelect")

		def sub='online.notification.on.taxi.select.trip.tittle'
		def mess='online.notification.on.taxi.select.trip.message'
		def dir;
		if(op?.intermediario){
			def ops =op.company.refresh()
			def empresa=Company.get(ops.id)
			def name=op.taxista.email.split("@")[0]
			 dir=  [ name ,op.timeTravel]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			 dir=  [name as String ,ve.patente as String ,ve.marca as String ]

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
			   setNotification(op,usr,sub,mess,dir.join(",") ,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
		   try{
			   setNotification(op,usr,sub,mess,null,key)
		   }catch(Exception e){
			   log.error e
		   }
		}
		log.debug("FIN notificateOnTripTaxiSelect")


	}
	def notificateOnTripTimeOutRadioTaxiSelect(Operation op,User usr,String key,boolean isEncoded){
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
			 dir=  [ empresa.companyName as String ]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			 dir=  [name as String ,ve.patente as String ,ve.marca as String ]

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
			   setNotification(op,usr,sub,mess,dir.join(",") ,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : dir)
		   try{
			setNotification(op,usr,sub,mess,dir ,key)
		   }catch(Exception e){
			   log.error e
		   }
		}
		log.debug("FIN notificateOnTripTimeOutRadioTaxiSelect")

	}
	def notificateOnTripRejectRadioTaxiSelect(Operation op,User usr,String key,boolean isEncoded){
		log.debug("INICIO notificateOnTripRejectRadioTaxiSelect")
		def sub='online.notification.on.cancel.company.not.ve.taxi.trip.tittle'
		def mess='online.notification.on.cancel.company.not.ve.taxi.trip.message'
		if(op?.user?.rtaxi!=null){
			mess=mess.replaceAll("company", "radio.taxi");
			sub=sub.replaceAll("company", "radio.taxi");

		}
		def dir;

		if(op?.intermediario){
			op.intermediario.refresh()
			def empresa=Company.get(op?.intermediario?.employee.id)
			 dir=  [ empresa.companyName as String ]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			 dir=  [name as String ,ve.patente as String ,ve.marca as String ]

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
			   setNotification(op,usr,sub,mess,dir.join(",") ,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : dir)
		   try{
			setNotification(op,usr,sub,mess,dir ,key)
		   }catch(Exception e){
			   log.error e
		   }
		}

		log.debug("FIN notificateOnTripRejectRadioTaxiSelect")
	}
	def notificateOnTripRadioTaxiSelect(Operation op,User usr,String key,boolean isEncoded){
		log.debug("INICIO notificateOnTripRadioTaxiSelect")
		def sub='online.notification.on.radio.taxi.select.trip.tittle'
		def mess='online.notification.on.radio.taxi.select.trip.message'
		def dir;

		if(op?.intermediario){
			op.intermediario.refresh()
			def empresa=Company.get(op?.intermediario?.employee.id)
			 dir=  [ empresa.companyName as String ]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			 dir=  [name as String ,ve.patente as String ,ve.marca as String ]

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
			   setNotification(op,usr,sub,mess,dir.join(",") ,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : dir)
		   try{
			setNotification(op,usr,sub,mess,dir ,key)
		   }catch(Exception e){
			   log.error e
		   }
		}
		log.debug("FIN notificateOnTripRadioTaxiSelect")

	}
	def notificateOnReasignTripTaxiSelect(Operation op,User usr,String key){
		log.debug("INICIO notificateOnReasignTripTaxiSelect")
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.taxi.reasign.trip.tittle' )
		def mess=null
		if(op?.intermediario){
			def empresa=Company.get(op?.intermediario.employee.id)
			def name=op.taxista.email.split("@")[0]
			 mess= g.message( code : 'online.notification.on.taxi.reasign.trip.message', args : [ name as String ] )
		}else{
			def name=op.taxista?.firstName+" "+op.taxista?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			 mess= g.message( code : 'online.notification.on.taxi.reasign.trip.message', args : [name as String ,ve.patente as String ,ve.marca as String ] )

		}
		try{
			setNotification(op,usr,sub,mess,null ,key)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnReasignTripTaxiSelect")

	}
	def notificateOnReasignTripRadioTaxiSelect(Operation op,User usr,String key,boolean isEncoded){
		log.debug("INICIO notificateOnReasignTripRadioTaxiSelect")
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.radio.taxi.reasign.trip.tittle' )
		def mess=null
		if(op?.intermediario){
			def empresa=Company.get(op?.intermediario.employee.id)
			 mess= g.message( code : 'online.notification.on.radio.taxi.reasign.trip.message', args : [ empresa.companyName as String ] )
		}else{
			def name=op.taxista?.firstName+" "+op.taxista?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			 mess= g.message( code : 'online.notification.on.radio.taxi.reasign.trip.message', args : [name as String ,ve.patente as String ,ve.marca as String ] )

		}
		try{
			setNotification(op,usr,sub,mess,null ,key)
		}catch(Exception e){
			log.error e
		}
		log.debug("FIN notificateOnReasignTripRadioTaxiSelect")

	}
	def notificateOnTripFinish(Operation op,User usr,boolean isEncoded,String key){
		log.debug("INICIO notificateOnTripFinish")
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub=sub= 'online.notification.on.finish.trip.tittle'
		def mess=mess='online.notification.on.finish.trip.message'
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
			   setNotification(op,usr,sub,mess,dir as String ,key ,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			 sub= g.message( code : sub )
			 mess= g.message( code : mess)
			try{
				setNotification(op,usr,sub,mess,null ,key)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripFinish")
	}
	def notificateOnTripCalificate(Operation op,User usr,boolean isEncoded,String key){
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
			   setNotification(op,usr,sub,mess,dir.join(",")  ,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			 sub= g.message( code : sub )
			 mess= g.message( code : mess)

			try{
				setNotification(op,usr,sub,mess,null ,key)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripCalificate")
	}
	def notificateOnTripHoldingUser(Operation op,User usr,boolean isEncoded,String key){
		log.debug("INICIO notificateOnTripHoldingUser")


		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub= 'online.notification.on.holding.trip.tittle'
		def mess='online.notification.on.holding.trip.message'
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
			   setNotification(op,usr,sub,mess,dir.join(",") ,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			 sub= g.message( code : sub )
			 mess= g.message( code : mess,args:dir)

			try{
				setNotification(op,usr,sub,mess,null ,key)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripHoldingUser")
	}
	def notificateOnTripIsNotAsigned(Operation op,User usr,boolean isEncoded,String key){
		log.debug("INICIO notificateOnTripIsNotAsigned")
		def sub= 'online.notification.on.trip.is.not.asigned.tittle'
		def mess='online.notification.on.trip.is.not.asigned.message'
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
			   setNotification(op,usr,sub,mess,null,key,isEncoded)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			 sub= g.message( code : sub )
			 mess=g.message( code : mess )

			try{
				setNotification(op,usr,sub,mess,null ,key)
			}catch(Exception e){
				log.error e
			}
		}
		log.debug("FIN notificateOnTripIsNotAsigned")

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
            projections{
                count("id")
            }
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
		   and{
				eq('usr', usr)
		   }
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
