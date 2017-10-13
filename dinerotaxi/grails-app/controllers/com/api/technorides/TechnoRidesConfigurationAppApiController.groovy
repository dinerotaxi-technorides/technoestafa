package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.EnabledCities;
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.notification.ConfigurationApp
import ar.com.operation.Parking
class TechnoRidesConfigurationAppApiController extends TechnoRidesValidateApiController {
	def technoRidesOperationService
	def utilsApiService
	def operationApiService
	def sendGridService
	def technoRidesEmailService
	def springDineroTaxiService
	def springSecurityService
	def rememberMeServices

	def addExcept(list) {
		list <<'get'//'index' << 'list' << 'show'
	}
	def get={
		render "asd"
	}
	def post={
		render "asd"
	}
	static allowedMethods = [jq_edit_config:'POST']
	def jq_config = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def company = null
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			if(usr?.rtaxi){
				company= ar.com.goliath.Company.get(usr.rtaxi.id)
			}else{
				company= ar.com.goliath.Company.get(usr.id)
			}

			if(!company.wlconfig){

				def wlConfigdefault=ConfigurationApp.first()
				def wlConfignew = new ConfigurationApp(
					app:company?.companyName.toString(),
					mailSecret:wlConfigdefault.mailSecret ,
					mailFrom:wlConfigdefault.mailFrom ,
					androidAccountType:wlConfigdefault.androidAccountType ,
					androidEmail:wlConfigdefault.androidEmail ,
					androidPass:wlConfigdefault.androidPass ,
					androidToken:wlConfigdefault.androidToken ,
					appleIp:wlConfigdefault.appleIp ,
					applePort:wlConfigdefault.applePort ,
					appleCertificatePath:wlConfigdefault.appleCertificatePath ,
					applePassword:wlConfigdefault.applePassword  ,
					isEnable:true,
					hasZoneActive:false,
					hasMobilePayment:false,
					paypal:false,
					endlessDispatch:false,
					digitalRadio:false,
					mailkey: wlConfigdefault.mailkey ,
					driversProfileEditable:true)
				wlConfignew.save()
				wlConfignew.errors.each{ println it }

				company.wlconfig=wlConfignew
				company.save()

			}
			def timezone = company.city.timeZone
			print timezone
			if (timezone.contains("-")){
				timezone = timezone.replace('-', '+')
			}else{
				timezone = timezone.replace('+', '-')

			}
			def packageCompany = 'BASIC'
			if(company.wlconfig?.isChatEnabled){
				packageCompany=company.wlconfig?.packageCompany
			}
			def driverQuota = 10
			if (company.wlconfig?.driverQuota){
				driverQuota=company.wlconfig?.driverQuota
			}

			print timezone
			def jsonCells =
			[
				package_company:packageCompany,
				driver_quota:driverQuota,
				intervalPoolingTrip:company.wlconfig.intervalPoolingTrip,
				timeDelayTrip:company.wlconfig.timeDelayTrip,
				distanceSearchTrip:company.wlconfig.distanceSearchTrip,
				percentageSearchRatio:company.wlconfig.percentageSearchRatio,
				driverSearchTrip:company.wlconfig.driverSearchTrip,
				parking:company.wlconfig.parking,
				parkingDistanceDriver:company.wlconfig.parkingDistanceDriver,
				parkingDistanceTrip:company.wlconfig.parkingDistanceTrip,
				hasDriverPayment:company.wlconfig.hasDriverPayment,
				hadUserNumber:company.wlconfig.hadUserNumber,
				driverPayment:company.wlconfig.driverPayment,
				driverTypePayment:company.wlconfig.driverTypePayment,
				driverAmountPayment:company.wlconfig.driverAmountPayment,
				driverCorporateCharge:company.wlconfig.driverCorporateCharge,
				hasZoneActive:company.wlconfig.hasZoneActive,
				hasRequiredZone:company.wlconfig.hasRequiredZone,
				costRute:company.wlconfig.costRute,
				costRutePerKm:company.wlconfig.costRutePerKm,
				costRutePerKmMin:company.wlconfig.costRutePerKmMin,
				hasMobilePayment:company.wlconfig.hasMobilePayment,
				paypal:company.wlconfig.paypal,
				endlessDispatch:company.wlconfig.endlessDispatch,
				mobileCurrency:company.wlconfig.mobileCurrency,
				pageTitle:company.wlconfig.pageTitle,
				parkingPolygon:company.wlconfig.parkingPolygon,
				pageCompanyTitle:company.wlconfig.pageCompanyTitle,
				driversProfileEditable:company.wlconfig.driversProfileEditable?:false,
				pageCompanyDescription:company.wlconfig.pageCompanyDescription,
				pageCompanyStreet:company.wlconfig.pageCompanyStreet,
				pageCompanyZipCode:company.wlconfig.pageCompanyZipCode,
				pageCompanyState:company.wlconfig.pageCompanyState,
				pageCompanyLinkedin:company.wlconfig.pageCompanyLinkedin,
				pageCompanyFacebook:company.wlconfig.pageCompanyFacebook,
				pageCompanyTwitter:company.wlconfig.pageCompanyTwitter,
				pageCompanyWeb:company.wlconfig?.pageCompanyWeb?:'',
				pageCompanyLogo:company.wlconfig?.pageCompanyLogo?:'',
				newOpshowAddressFrom:company.wlconfig?.newOpshowAddressFrom,
				newOpshowAddressTo:company.wlconfig?.newOpshowAddressTo,
				newOpshowCorporate:company.wlconfig?.newOpshowCorporate,
				newOpshowUserName:company.wlconfig?.newOpshowUserName,
				newOpshowOptions:company.wlconfig?.newOpshowOptions,
				newOpshowUserPhone:company.wlconfig?.newOpshowUserPhone,
				newOpshowUserPhone:company.wlconfig?.newOpshowUserPhone,
				hasDriverDispatcherFunction:company.wlconfig?.hasDriverDispatcherFunction,

				driverCancelTrip :company.wlconfig?.driverCancelTrip,
				passengerDispatchMultipleTrips :company.wlconfig?.passengerDispatchMultipleTrips,
				isChatEnabled :company.wlconfig?.isChatEnabled,
				operatorDispatchMultipleTrips :company.wlconfig?.operatorDispatchMultipleTrips,
				operatorSuggestDestination :company.wlconfig?.operatorDispatchMultipleTrips,
				blockMultipleTrips :company.wlconfig?.blockMultipleTrips,
				isFareCalculatorActive:company.wlconfig?.isFareCalculatorActive,
				creditCardEnable:company.wlconfig?.creditCardEnable,

				operatorCancelationReason:company.wlconfig?.operatorCancelationReason,
				driverCancellationReason:company.wlconfig?.driverCancellationReason,
				fareInitialCost:company.wlconfig?.fareInitialCost,
				fareCostPerKm:company.wlconfig?.fareCostPerKm,
				fareConfigActivateTimePerDistance:company.wlconfig?.fareConfigActivateTimePerDistance,
				fareConfigGracePeriodMeters:company.wlconfig?.fareConfigActivateTimePerDistance,
				fareConfigGraceTime:company.wlconfig?.fareConfigGraceTime,

				fareConfigTimeSecWait:company.wlconfig?.fareConfigTimeSecWait,
				fareConfigTimeInitialSecWait:company.wlconfig?.fareConfigTimeInitialSecWait,
				fareCostTimeWaitPerXSeg:company.wlconfig?.fareCostTimeWaitPerXSeg,
				fareCostTimeInitialSecWait:company.wlconfig?.fareCostTimeInitialSecWait,
				newOpComment:company.wlconfig?.newOpComment,
				currency:company.wlconfig?.currency?:'',
				subdomain:company.wlconfig?.subdomain?:'',
				useAdminCode:company.wlconfig.useAdminCode,
				distanceType:company.wlconfig.distanceType,
				googleApiKey:company.wlconfig.googleApiKey,
				driverShowScheduleTrips:company.wlconfig.driverShowScheduleTrips,
				admin1Code:company.city.admin1Code,
				timeZone:timezone,
				zoho:company.wlconfig.zoho,
				pageUrl:company.pageUrl,
				phone:company.phone,
				phone1:company.phone1,
				androidUrl:company.wlconfig.androidUrl,
				iosUrl:company.wlconfig.iosUrl,
				isPrePaidActive:company.wlconfig?.isPrePaidActive,
				id: company.id,
				status:100
			]
			render jsonCells as JSON
			return

		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") {
				status=11
			}
		}
	}
	def jq_edit_config  = {
		def message = ""
		def state   = "FAIL"
		def tok=PersistToken.findByToken(request.JSON?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		def company = Company.get(rtaxi.id)
		def configApp = ConfigurationApp.get( company?.wlconfig?.id)
		def city = EnabledCities.get(company.city.id)
		if(request.JSON?.percentageSearchRatio)
			request.JSON.percentageSearchRatio = request.JSON.percentageSearchRatio
		if(request.JSON?.distanceSearchTrip)
			request.JSON.distanceSearchTrip = request.JSON.distanceSearchTrip

		if(request.JSON?.pageUrl){
			company.pageUrl = request.JSON.pageUrl
			company.save()
		}
		if(request.JSON?.phone){
			company.phone = request.JSON.phone
			company.save()
		}
		if(request.JSON?.phone1){
			company.phone1 = request.JSON.phone1
			company.save()
		}
		if(request.JSON?.admin1Code){
			city.admin1Code = request.JSON.admin1Code
			city.save()
		}
		if(request.JSON?.timeZone){
			city.timeZone = request.JSON.timeZone
			city.save()
		}
		// determine our action
		switch (request.JSON.oper) {
			default:
				// default edit action
				// first retrieve the parking by its ID
				if (configApp) {
					configApp.properties = request.JSON
					if (! configApp.hasErrors() && configApp.save(flush:true)) {
						message = "configApp Updated"
						state = "OK"
					} else {
						configApp.errors.each{
							println it
						}
						message = "Could Not Update  "
					}
				}else{

				message = "Could Not Update   "+configApp
				}
			break;
		}

		println message
		println state
		def response = [message:message,state:state,id:configApp?.id]

		render response as JSON
	}

}
