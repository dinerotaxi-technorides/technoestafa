package com.notifier


import javapns.*
import javapns.notification.*
import ar.com.goliath.*
import ar.com.notification.*
import ar.com.operation.*

import com.Device
import com.UserDevice
class NotificationService   {
	def onlineNotificationService
	def mobileNotificationService
	def grailsApplication
	def feedService
	boolean transactional = true
	def notificateOnCreateTrip(Operation op,User usr){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCreateTrip(op,op.user,it)
			}else{
				log.debug "sending online notification"
				onlineNotificationService.notificateOnCreateTrip(op,op.user)
			}
		}
	}
	def notificateOnCreateTripWithFavorite(Operation op,User usr){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCreateTripWithFavorite(op,op.user,it)
			}else{
				log.debug "sending online notification"
				onlineNotificationService.notificateOnCreateTripWithFavorite(op,op.user)
			}
		}
	}
	def notificateOnCancelTripByUser(Operation op,User usr){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCancelTripByUser(op,op.user,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnCancelTripByUser(op,op.user)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnCancelTripByUser(op,op.user)
		}
	}
	def notificateOnCancelTripByUserForRadioTaxi(Operation op,User usr){
		onlineNotificationService.notificateOnCancelTripByUserForRadioTaxi(op,usr)
	}
	def notificateOnReAsignTripByUserForRadioTaxi( op, usr, isEncoded){
		onlineNotificationService.notificateOnReAsignTripByUserForRadioTaxi(op,usr,true)
	}
	def notificateOnCancelTripByTimeOutForRadioTaxi( op,usr,  isEncoded){
		onlineNotificationService.notificateOnCancelTripByTimeOutForRadioTaxi(op,usr,true)
	}
	
	def notificateOnTripFinishForRadioTaxi(Operation op,boolean isEncoded){
		
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripFinishForRadioTaxi(op,op.user,isEncoded)

	}
	
	def notificateOnTripInTransactionForRadioTaxi(Operation op,boolean isEncoded){
		
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripInTransactionForRadioTaxi(op,isEncoded)

	}
	//isEncoded is false when we use a job
	def notificateOnCancelOther(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCancelOther(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnCancelOther(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnCancelOther(op,op.user,isEncoded)

		}

	}
	//isEncoded is false when we use a job
	def notificateOnCancelWeNoVeTaxi(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCancelWeNoVeTaxi(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnCancelWeNoVeTaxi(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnCancelWeNoVeTaxi(op,op.user,isEncoded)

		}

	}
	//isEncoded is false when we use a job
	def notificateOnCancelOfflineRadioTaxi(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCancelOfflineRadioTaxi(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnCancelOfflineRadioTaxi(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnCancelOfflineRadioTaxi(op,op.user,isEncoded)

		}

	}
	//isEncoded is false when we use a job
	def notificateOnCancelRadiotaxiWhenUserCallDismiss(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCancelRadiotaxiWhenUserCallDismiss(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnCancelRadiotaxiWhenUserCallDismiss(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnCancelRadiotaxiWhenUserCallDismiss(op,op.user,isEncoded)

		}

	}
	def notificateOnCancelInvalidPhone(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCancelInvalidPhone(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnCancelInvalidPhone(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnCancelInvalidPhone(op,op.user,isEncoded)

		}

	}
	//isEncoded is false when we use a job
	def notificateOnCancelWeNoVeACompanyTaxi(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnCancelWeNoVeACompanyTaxi(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnCancelWeNoVeACompanyTaxi(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnCancelWeNoVeACompanyTaxi(op,op.user,isEncoded)

		}

	}



	def notificateOnTripInProgress(Operation op,User usr){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripInProgress(op,op.user,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnTripInProgress(op,op.user)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripInProgress(op,op.user)

		}

	}
	def notificateOnTripTaxiSelect(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripTaxiSelect(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				onlineNotificationService.setReadOldOperation(op.user,op.id,)
				onlineNotificationService.notificateOnTripTaxiSelect(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripTaxiSelect(op,op.user,isEncoded)

		}
	}
	def notificateOnTripTaxiSelectByTaxi(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripTaxiSelectByTaxi(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				onlineNotificationService.setReadOldOperation(op.user,op.id,)
				onlineNotificationService.notificateOnTripTaxiSelectByTaxi(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripTaxiSelectByTaxi(op,op.user,isEncoded)

		}
	}
	
	
	
	
	
	def notificateToRadioTaxiTaxiWasSelected(Operation op,boolean isEncoded){
		onlineNotificationService.notificateToRadioTaxiTaxiWasSelected(op)
	}
	def notificateOnTripRadioTaxiSelect(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripRadioTaxiSelect(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnTripRadioTaxiSelect(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripRadioTaxiSelect(op,op.user,isEncoded)

		}

	}
	def notificateOnTripTimeOutRadioTaxiSelect(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripTimeOutRadioTaxiSelect(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnTripTimeOutRadioTaxiSelect(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripTimeOutRadioTaxiSelect(op,op.user,isEncoded)

		}

	}
	def notificateOnTripRejectRadioTaxiSelect(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripRejectRadioTaxiSelect(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnTripRejectRadioTaxiSelect(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripRejectRadioTaxiSelect(op,op.user,isEncoded)

		}

	}
	def notificateOnReAsignTripRadioTaxiSelect(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnReasignTripRadioTaxiSelect(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnReasignTripRadioTaxiSelect(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnReasignTripRadioTaxiSelect(op,op.user,isEncoded)

		}

	}
	def notificateOnReAsignTripTaxiSelect(Operation op,User usr){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnReAsignTripTaxiSelect(op,op.user,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnReAsignTripTaxiSelect(op,op.user)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnReAsignTripTaxiSelect(op,op.user)

		}

	}
	def notificateOnTripFinish(Operation op,User usr,boolean isEncoded){
		op.status=TRANSACTIONSTATUS.COMPLETED
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripFinish(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnTripFinish(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripFinish(op,op.user,isEncoded)

		}

	}
	def notificateOnTripCalificate(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripCalificate(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnTripCalificate(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripCalificate(op,op.user,isEncoded)

		}

	}
	def notificateOnTripHoldingUser(Operation op,User usr,boolean isEncoded){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripHoldingUser(op,op.user,isEncoded,it)
			}else{
				log.debug "sending online notification"
				//onlineNotificationService.setReadOldOperation(op.user,op.id)
				onlineNotificationService.notificateOnTripHoldingUser(op,op.user,isEncoded)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			//onlineNotificationService.setReadOldOperation(op.user,op.id)
			onlineNotificationService.notificateOnTripHoldingUser(op,op.user,isEncoded)

		}
	}

	def notificateOnTripIsNotAsigned(Operation op,User usr,boolean isEncoded,Integer counter){
		def dev =Device.findAllByUser(op.user)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){
				if( it?.keyValue ||  it!=null)
					mobileNotificationService.notificateOnTripIsNotAsigned(op,op.user,isEncoded,it,counter)
			}else{
				log.debug "sending online notification"
				onlineNotificationService.notificateOnTripIsNotAsigned(op,op.user,isEncoded,counter)
			}
		}
		if(!isPush){
			log.debug "sending online notification"
			onlineNotificationService.notificateOnTripIsNotAsigned(op,op.user,isEncoded,counter)
		}

	}
	def notificateSpam( message,Device dev){
		if(dev.dev==UserDevice.IPHONE || dev.dev==UserDevice.ANDROID){
			if( dev?.keyValue ||  dev!=null)
				mobileNotificationService.notificateSpam(message,dev)
		}

	}
	def checkPush(User usr){
		def dev =Device.findAllByUser(usr)
		boolean isPush=false
		dev.each {
			isPush=true
			if(it.dev==UserDevice.IPHONE || it.dev==UserDevice.ANDROID){

			}else{
				log.debug "No Device Id"
			}
		}

	}


}
