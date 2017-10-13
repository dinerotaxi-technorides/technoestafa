package com.api.technorides

import grails.converters.JSON
import ar.com.notification.Zone
import ar.com.notification.ZonePricing
import ar.com.operation.BillingDriver

class TechnoRidesZoneService {
	static transactional = true
	def utilsApiService
	def getZone( params,user) {

		def customers = Zone.createCriteria().list() {
				eq("user",user)
			// set the order and direction
		}

		def jsonCells = customers.collect {
			[
				id:it.id,
				date: new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.lastModifiedDate),
				name:it.name,
				coordinates:it.coordinates,
			]
		}
		def jsonData= [result: jsonCells,status:100]
		return jsonData as JSON
	}

	def generateZonePricing(user,zone){
		def zoneList = Zone.findAllByUser(user)
		zoneList.each{
			//Creates zone From: To:
			def zonePri = new ZonePricing(zoneFrom:it,zoneTo:zone,user:user,amount:0d)
			if (zonePri.hasErrors() || !zonePri.save(flush:true)) {
				zonePri.errors.each{
					println it
				}
			}
			//Creates zone To: From:
			def zone2Pri = new ZonePricing(zoneFrom:zone,zoneTo:it,user:user,amount:0d)
			if (zone2Pri.hasErrors() || !zone2Pri.save(flush:true)) {
				zone2Pri.errors.each{
					println it
				}
			}
		}
	}

	def getZonePricing( params,user) {

		def rows  =params?.rows ?: 10
		def page = params.page ?:1
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = Integer.valueOf(rows)
		def currentPage = Integer.valueOf(page) ?: 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		print params
		def customers = ZonePricing.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq("user",user)
				if(  params.searchField.equals("zoneFrom") && !params.searchString.isEmpty()){
					zoneFrom{
						ilike("name", params.searchString+"%")
					}
				}
				if(  params.searchField.equals("zoneTo") && !params.searchString.isEmpty()){
					zoneTo{
						ilike("name", params.searchString+"%")
					}
				}
				if(params?.id){
					or{
						zoneFrom{
							ilike("name", params?.id+"%")
						}
						zoneTo{
							ilike("name", params?.id+"%")
						}
					}
				}
			order(sortIndex, sortOrder)
			// set the order and direction
		}
		println customers
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[
				id:it.id,
				date: new java.text.SimpleDateFormat("dd/MM/yyyy").format(it.lastModifiedDate),
				amount:it.amount?:0.0,
				zoneFrom:it.zoneFrom?.name?:'',
				zoneTo:it.zoneTo?.name?:'',
			]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}

}
