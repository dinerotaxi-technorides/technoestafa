package com.api

import grails.converters.JSON
import ar.com.goliath.Company
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import ar.com.notification.ConfigurationApp

import com.UserDevice
class ConfigApiController {
	
	def jq_config = {
		try{
			def company = null 
			if(params?.id){
				company = Company.get(params?.id)
			}else if(params?.domain){
			 	company = Company.findByPageUrl(params?.domain)
			
			}else if(params?.subdomain){
				def configs = ConfigurationApp.findAllBySubdomain(params?.subdomain)
				print configs
				for(conf in configs){
					print conf
					def company_c = Company.findByWlconfig(conf)
				 	if(company_c){
						 print "saveconfig"
						 company = company_c
						 
					 }
					
				}
				
			}
			if(company?.wlconfig){
				
				def business_model = company.businessModel.collect(){
					it.name
				}
				def jsonCells =
				[
					androidUrl:company.wlconfig.androidUrl,
					iosUrl:company.wlconfig.iosUrl,
					mailContacto:company.mailContacto,
					username:company.username,
					companyName:company.companyName,
					phone:company.phone,
					phone1:company.phone1,
					lang:company.lang,
					latitude:company.latitude,
					longitude:company.longitude,
					name:company.city.name,
					country:company.city.country,
					admin1Code:company.city.admin1Code,
					timeZone:company.city.timeZone,
					countryCode:company.city.countryCode,
					pageTitle:company.wlconfig.pageTitle,
					pageCompanyTitle:company.wlconfig.pageCompanyTitle,
					pageCompanyDescription:company.wlconfig.pageCompanyDescription,
					pageCompanyStreet:company.wlconfig.pageCompanyZipCode,
					pageCompanyZipCode:company.wlconfig.pageCompanyZipCode,
					pageCompanyState:company.wlconfig.pageCompanyState,
					pageCompanyLinkedin:company.wlconfig.pageCompanyLinkedin,
					pageCompanyFacebook:company.wlconfig.pageCompanyFacebook,
					pageCompanyTwitter:company.wlconfig.pageCompanyTwitter,
					pageCompanyWeb:company.wlconfig?.pageCompanyWeb?:'',
					pageCompanyLogo:company.wlconfig?.pageCompanyLogo?:'',
					distanceType:company.wlconfig.distanceType,
					googleApiKey:company.wlconfig.googleApiKey,
					businessModel: business_model,
					driverShowScheduleTrips:company.wlconfig.driverShowScheduleTrips,
					currency:company.wlconfig?.currency?:'',
					package_company:company.wlconfig?.packageCompany,
					driver_quota:company.wlconfig?.driverQuota,
					zoho:company.wlconfig.zoho,
					subdomain:company.wlconfig.subdomain,
					pageUrl:company.pageUrl,
					id: company.id,
					status:100
				]
				render jsonCells as JSON
				return
			}
			render(contentType:'text/json',encoding:"UTF-8") {
				status=12
			}
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") {
				status=11
			}
		}
	}
	def jq_all_config = {
		try{
			def companies = Company.findAllByEnabled(true)
			def jsonCells = []
			for (company in companies) {
				if(company.wlconfig){
					def cell=[
						'androidUrl':company.wlconfig.androidUrl,
						'iosUrl':company.wlconfig.iosUrl,
						'mailContacto':company.mailContacto,
						'username':company.username,
						'lang':company.lang,
						'name':company.city.name,
						'country':company.city.country,
						'rtaxi_id':company.id,
						'companyName':company.companyName,
						'phone':company.phone,
						'phone1':company.phone1,
						'latitude':company.latitude,
						'longitude':company.longitude,
						'city':company.city.admin1Code,
						'countryCode':company.city.countryCode,
						'timeZone':company.city.timeZone,
						'intervalPoolingTrip':company.wlconfig.intervalPoolingTrip,
						'timeDelayTrip':company.wlconfig.timeDelayTrip,
						'distanceSearchTrip':company.wlconfig.distanceSearchTrip,
						'percentageSearchRatio':company.wlconfig.percentageSearchRatio,
						'driverCorporateCharge':company.wlconfig.driverCorporateCharge,
						'driverSearchTrip':company.wlconfig.driverSearchTrip,
						'subdomain':company.wlconfig.subdomain,
						'parking':company.wlconfig.parking,
						'parkingDistanceDriver':company.wlconfig.parkingDistanceDriver,
						'parkingDistanceTrip':company.wlconfig.parkingDistanceTrip,
						'hasDriverPayment':company.wlconfig.hasDriverPayment,
						'driverPayment':company.wlconfig.driverPayment,
						'driverTypePayment':company.wlconfig.driverTypePayment,
						'driverAmountPayment':company.wlconfig.driverAmountPayment,
						'hasRequiredZone':company.wlconfig.hasRequiredZone,
						'hasZoneActive':company.wlconfig.hasZoneActive,
						'digitalRadio':company.wlconfig.digitalRadio,
						'mobileCurrency':company.wlconfig.mobileCurrency,
						
						'costRute':company.wlconfig.costRute,
						'costRutePerKm':company.wlconfig.costRutePerKm,
						'costRutePerKmMin':company.wlconfig.costRutePerKmMin,
						'pageUrl':company.pageUrl,
						'zoho':company.wlconfig.zoho,
						'id': company.wlconfig.id
					]
					jsonCells.add(cell)
				}
			}
			def respon =  [data:jsonCells,status:100] 
			render respon as JSON
			return
			
			
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") {
				status=11
			}
		}
	}
}
