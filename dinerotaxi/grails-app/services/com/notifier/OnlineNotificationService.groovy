package com.notifier


import org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib

import ar.com.goliath.*
import ar.com.notification.*
import ar.com.operation.Operation
class OnlineNotificationService   {
	def grailsApplication
    boolean transactional = true

	void setNotification(Operation op,User usr,String titt,String mess,String args,boolean isEncoded){
		Long oper=op.id  as Long
		def onlineNotification = new ar.com.notification.OnlineNotification()
		def appCtx = grailsApplication.getMainContext()
		if (isEncoded){
			titt= appCtx.getMessage( titt,
					[] as Object[],
					"default message",
					new java.util.Locale("ES"))
			if(args!=null){
				mess= appCtx.getMessage(mess,
						[args as String] as Object[],
						"default message",
						new java.util.Locale("ES"))
			}else{
				mess= appCtx.getMessage( mess,
						[] as Object[],
						"default message",
						new java.util.Locale("ES"))

			}
			if(usr?.rtaxi){
				titt=titt.replaceAll("DineroTaxi.com", usr?.rtaxi.companyName)
				mess=mess.replaceAll("DineroTaxi.com", usr?.rtaxi.companyName)
			}

		}
		if(usr?.rtaxi){
			titt=titt.replaceAll("DineroTaxi.com", usr?.rtaxi.companyName)
			mess=mess.replaceAll("DineroTaxi.com", usr?.rtaxi.companyName)
		}
		onlineNotification.title=titt
		onlineNotification.message=mess
		onlineNotification.operation=oper
		onlineNotification.usr=usr

		if(!onlineNotification.save(flush:true)){
			 log.debug "no se pudo guardar la Online notification del usuario " + usr.id
		}else{
			log.debug "se guardo la notificacion ${onlineNotification.id}"
		}
	}

	def notificateOnCreateTrip(Operation op,User usr){
		String dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def appTagLib =new ApplicationTagLib()
		String sub= appTagLib.message( code : 'online.notification.on.create.trip.tittle' ) as String
		String mess= appTagLib.message( code : 'online.notification.on.create.trip.message', args : [ dir as String ] ) as String
		try{
			setNotification(op,usr,sub,mess,null,false)
		}catch(Exception e){
			log.error e
		}


	}
	def notificateOnCreateTripWithFavorite(Operation op,User usr){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub=null
		def mess=null
		def g =new ApplicationTagLib()
		sub= g.message( code : 'online.notification.on.create.trip.tittle' )
		mess= g.message( code : 'online.notification.on.create.tripf.message', args : [ dir as String ] )
	   try{
		   setNotification(op,usr,sub,mess,null,false)
	   }catch(Exception e){
		   log.error e
	   }


	}
	def notificateOnCancelTripByUser(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()

		def sub='online.notification.on.cancel.trip.tittle'
		def mess='online.notification.on.cancel.trip.message'
		if(isEncoded){
			setNotification(op,op?.company,sub,mess,dir,true)
		}else{

			 sub= g.message( code : 'online.notification.on.cancel.trip.tittle' )
			 mess= g.message( code : 'online.notification.on.cancel.trip.message', args : [ dir as String ] )

			try{
				setNotification(op,usr,sub,mess,dir,false)
			}catch(Exception e){
				log.error e
			}
		}

	}
	def notificateOnCancelTripByUser(Operation op,User usr){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.cancel.trip.tittle' )
		def mess= g.message( code : 'online.notification.on.cancel.trip.message', args : [ dir as String ] )

		try{
			setNotification(op,usr,sub,mess,dir,false)
		}catch(Exception e){
			log.error e
		}

	}
	def notificateOnReAsignTripByUserForRadioTaxi( op,usr, isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()

		def sub='online.notification.on.cancel.trip.tittle'
		def mess='online.notification.on.cancel1.trip.radiotaxi.message'
		if(isEncoded){
			setNotification(op,usr,sub,mess,dir,true)
		}else{
		 sub= g.message( code : 'online.notification.on.cancel.trip.tittle' )
		 mess= g.message( code : 'online.notification.on.cancel.trip.radiotaxi.message', args : [dir as String ] )

			try{
				if(op?.company)
					setNotification(op,op?.company,sub,mess,null,false)
			}catch(Exception e){
				log.error e
			}
		}


	}
	def notificateOnCancelTripByUserForRadioTaxi(Operation op,User usr){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.cancel.trip.tittle' )
		def mess= g.message( code : 'online.notification.on.cancel.trip.radiotaxi.message', args : [usr.firstName ,dir as String ] )

		try{
			if(op?.company)
				setNotification(op,op?.company,sub,mess,null,false)
		}catch(Exception e){
			log.error e
		}

	}
	def notificateToRadioTaxiTaxiWasSelected(Operation op){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.assigned.trip.tittle' )
		def mess= g.message( code : 'online.notification.on.assigned.trip.radiotaxi.message', args : [dir as String ] )

		try{
			if(op?.company)
				setNotification(op,op?.company,sub,mess,null,false)
		}catch(Exception e){
			log.error e
		}

	}

	def notificateOnTripInTransactionForRadioTaxi( op,isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()

		def sub='online.notification.on.finish.trip.tittle'
		def mess='online.notification.on.finish.trip.radiotaxi.message'
		if(isEncoded){
			setNotification(op,op?.company,sub,mess,dir,true)
		}else{
		 sub= g.message( code : 'online.notification.on.finish.trip.tittle' )
		 mess= g.message( code : 'online.notification.on.finish.trip.radiotaxi.message', args : [dir as String ] )

			try{
				if(op?.company)
					setNotification(op,op?.company,sub,mess,null,false)
			}catch(Exception e){
				log.error e
			}
		}


	}
	def notificateOnTripFinishForRadioTaxi( op,usr, isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()

		def sub='online.notification.on.finish.trip.tittle'
		def mess='online.notification.on.finish.trip.radiotaxi.message'
		if(isEncoded){
			setNotification(op,usr,sub,mess,dir,true)
		}else{
		 sub= g.message( code : 'online.notification.on.finish.trip.tittle' )
		 mess= g.message( code : 'online.notification.on.finish.trip.radiotaxi.message', args : [dir as String ] )

			try{
				if(op?.company)
					setNotification(op,op?.company,sub,mess,null,false)
			}catch(Exception e){
				log.error e
			}
		}


	}
	def notificateOnCancelTripByTimeOutForRadioTaxi( op, isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def g =new ApplicationTagLib()

		def sub='online.notification.on.finish.radiotaxi.trip.tittle'
		def mess='online.notification.on.finish.radiotaxi.trip.message'
		if(isEncoded){
			setNotification(op,op.company,sub,mess,dir,true)
		}else{
		 sub= g.message( code : 'online.notification.on.finish.radiotaxi.trip.tittle' )
		 mess= g.message( code : 'online.notification.on.finish.radiotaxi.trip.message', args : [dir as String ] )

			try{
				if(op?.company)
					setNotification(op,op?.company,sub,mess,null,false)
			}catch(Exception e){
				log.error e
			}
		}


	}
	def notificateOnCancelOther(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub='online.notification.on.cancel.other.tittle'
		def mess='online.notification.on.cancel.other.message'
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code :mess, args : [ dir as String ] )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}

	}
	def notificateOnCancelWeNoVeTaxi(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub='online.notification.on.cancel.not.ve.taxi.trip.tittle'
		def mess='online.notification.on.cancel.not.ve.taxi.trip.message'
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : 'online.notification.on.cancel.not.ve.taxi.trip.tittle' )
			mess= g.message( code : 'online.notification.on.cancel.not.ve.taxi.trip.message', args : [ dir as String ] )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}

	}
	def notificateOnCancelOfflineRadioTaxi(Operation op,User usr,boolean isEncoded){
		def dir=null
		if(op?.company?.phone){
			dir=op?.company?.phone
		}else if(usr?.rtaxi?.phone){
			dir=usr?.rtaxi?.phone
		}
		def sub='online.notification.on.cancel.not.ve.company.tittle'
		def mess='online.notification.on.cancel.not.ve.company.message'
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : 'online.notification.on.cancel.not.ve.company.tittle' )
			mess= g.message( code : 'online.notification.on.cancel.not.ve.company.message', args : [ dir as String ] )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}


	}
	def notificateOnCancelRadiotaxiWhenUserCallDismiss(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub='online.notification.on.cancel.dismiss.trip.tittle'
		def mess='online.notification.on.cancel.dismiss.trip.message'
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args : [ dir as String ] )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}


	}
	def notificateOnCancelInvalidPhone(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub=null
		def mess=null
		if(isEncoded){
			sub= 'online.notification.on.cancel.invalid.phone.tittle'
			mess='online.notification.on.cancel.invalid.phone.message'
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : 'online.notification.on.cancel.invalid.phone.tittle' )
			mess= g.message( code : 'online.notification.on.cancel.invalid.phone.message', args : [ dir as String ] )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}


	}
	def notificateOnCancelWeNoVeACompanyTaxi(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub=null
		def mess=null
		if(isEncoded){
			sub= 'online.notification.on.cancel.not.ve.taxi.trip.tittle'
			mess='online.notification.on.cancel.not.ve.company.trip.message'
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : 'online.notification.on.cancel.not.ve.taxi.trip.tittle' )
			mess= g.message( code : 'online.notification.on.cancel.not.ve.company.trip.message', args : [ dir as String ] )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}


	}


	def notificateOnTripInProgress(Operation op,User usr){
		def g =new ApplicationTagLib()
		def sub= g.message( code : 'online.notification.on.progress.trip.tittle' )
		def mess= g.message( code : 'online.notification.on.progress.trip.message' )
		try{
			setNotification(op,usr,sub,mess,null,false)
		}catch(Exception e){
			log.error e
		}

	}
	def notificateOnTripTaxiSelect(Operation op,User usr,boolean isEncoded){

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
		   try{
			   setNotification(op,usr,sub,mess,dir.join(",") ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}
	}
	def notificateOnTripTaxiSelectByTaxi(Operation op,User usr,boolean isEncoded){

		def sub='online.notification.on.taxi.select.trip.tittle'
		def mess='online.notification.on.taxi.select.by.taxi.trip.message'
		def dir;
		if(op?.intermediario){
			def ops =op.company.refresh()
			def empresa=Company.get(ops.id)
			def name=op.taxista.email.split("@")[0]
			 dir=  [ name ]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			 dir=  [name as String ,ve.patente as String ,ve.marca as String ]

		}
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,dir.join(",") ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}
	}
	def notificateOnTripTimeOutRadioTaxiSelect(Operation op,User usr,boolean isEncoded){

		def sub='online.notification.on.cancel.company.not.ve.taxi.trip.tittle'
		def mess='online.notification.on.cancel.company.timeout.trip.message'
		def dir;

		if(op?.user?.rtaxi!=null){
			mess=mess.replaceAll("company", "radio.taxi");
			sub=sub.replaceAll("company", "radio.taxi");

		}
		if(op?.intermediario){
			def ops =op.company.refresh()
			def empresa=Company.get(ops.id)
			 dir=  [ empresa.companyName]
		}else{
			dir=  [ "DineroTaxi"]
		}
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,dir.join(",") ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}


	}
	def notificateOnTripRejectRadioTaxiSelect(Operation op,User usr,boolean isEncoded){

		def sub='online.notification.on.cancel.company.not.ve.taxi.trip.tittle'
		def mess='online.notification.on.cancel.company.not.ve.taxi.trip.message'
		def dir;

		if(op?.user?.rtaxi!=null){
			mess=mess.replaceAll("company", "radio.taxi");
			sub=sub.replaceAll("company", "radio.taxi");

		}
		if(op?.intermediario){
			def ops =op.company.refresh()
			def empresa=Company.get(ops.id)
			 dir=  [ empresa.companyName]
		}else{
			dir=  [ "DineroTaxi"]
		}
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,dir.join(",") ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}


	}
	def notificateOnTripRadioTaxiSelect(Operation op,User usr,boolean isEncoded){

		def sub='online.notification.on.radio.taxi.select.trip.tittle'
		def mess='online.notification.on.radio.taxi.select.trip.message'
		def dir;
		if(op?.intermediario){
			def ops =op.company.refresh()
			def empresa=Company.get(ops.id)
			 dir=  [ empresa.companyName]
		}else{
			def name=op?.firstName+" "+op?.lastName
			def ve =Vehicle.findByTaxista(op.taxista)
			 dir=  [name as String ,ve.patente as String ,ve.marca as String ]

		}
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,dir.join(",") ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}


	}
	def notificateOnReasignTripTaxiSelect(Operation op,User usr){
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
			setNotification(op,usr,sub,mess,null,false)
		}catch(Exception e){
			log.error e
		}

	}
	def notificateOnReasignTripRadioTaxiSelect(Operation op,User usr,boolean isEncoded){
		def sub='online.notification.on.radio.taxi.reasign.trip.tittle'
		def mess='online.notification.on.radio.taxi.reasign.trip.message'
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
		   try{
			   setNotification(op,usr,sub,mess,dir.join(",") ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			sub= g.message( code : sub )
			mess= g.message( code : mess, args :  dir   )
		   try{
			   setNotification(op,usr,sub,mess,null,false)
		   }catch(Exception e){
			   log.error e
		   }
		}

	}



	def notificateOnTripFinish(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub=null
		def mess=null
		if(isEncoded){
			sub= 'online.notification.on.finish.trip.tittle'
			mess='online.notification.on.finish.trip.message'
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			 sub= g.message( code : 'online.notification.on.finish.trip.tittle' )
			 mess= g.message( code : 'online.notification.on.finish.trip.message')
			try{
				setNotification(op,usr,sub,mess,null,false)
			}catch(Exception e){
				log.error e
			}
		}
	}
	def notificateOnTripCalificate(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub=null
		def mess=null
		if(isEncoded){
			sub= 'online.notification.on.calificate.trip.tittle'
			mess='online.notification.on.calificate.trip.message'
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			 sub= g.message( code : 'online.notification.on.calificate.trip.tittle' )
			 mess= g.message( code : 'online.notification.on.calificate.trip.message')

			try{
				setNotification(op,usr,sub,mess,null)
			}catch(Exception e){
				log.error e
			}
		}
	}
	def notificateOnTripHoldingUser(Operation op,User usr,boolean isEncoded){
		def dir=op.favorites?.placeFrom?.street+" "+op.favorites?.placeFrom?.streetNumber
		def sub=null
		def mess=null
		if(isEncoded){
			sub= 'online.notification.on.holding.trip.tittle'
			mess='online.notification.on.holding.trip.message'
		   try{
			   setNotification(op,usr,sub,mess,dir as String ,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			 sub= g.message( code : 'online.notification.on.holding.trip.tittle' )
			 mess= g.message( code : 'online.notification.on.holding.trip.message')

			try{
				setNotification(op,usr,sub,mess,null,false)
			}catch(Exception e){
				log.error e
			}
		}
	}

	def notificateOnTripIsNotAsigned(Operation op,User usr,boolean isEncoded,Integer counter){
		def sub='online.notification.on.trip.is.not.asigned.tittle'
		def mess='online.notification.on.trip.is.not.asigned.message.'+counter
		if(usr?.rtaxi){
			mess=mess+".wl"
		}
		if(isEncoded){
		   try{
			   setNotification(op,usr,sub,mess,null,true)
		   }catch(Exception e){
			   log.error e
		   }

		}else{
			def g =new ApplicationTagLib()
			 sub= g.message( code : sub )
			 mess=g.message( code : mess)

			try{
				setNotification(op,usr,sub,mess,null ,false)
			}catch(Exception e){
				log.error e
			}
		}
	}
	def getNotificationsNotRead(User usr){
		def c = ar.com.notification.OnlineNotification.createCriteria()
		def results = c.list(){
		   and{
				eq('usr', usr)
				eq('isRead',false)

		   }

		   order("createdDate", "desc")

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
			it.delete()
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
