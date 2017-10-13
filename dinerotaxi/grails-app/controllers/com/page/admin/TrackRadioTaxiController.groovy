package com.page.admin
import grails.converters.JSON
import ar.com.goliath.*
import ar.com.operation.OnlineRadioTaxi
import ar.com.operation.TrackOnlineRadioTaxi
class TrackRadioTaxiController {
	def springSecurityService
	def placeService
	def adminUserService

	static allowedMethods = [getPendingTrips:'GET',edit:'POST']

	def index = {
	}
	def jq_track_radio_taxi_serching_list = {

		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
		boolean hasDateBetween=org.apache.commons.lang.StringUtils.countMatches(params.filters,"createdDate")==2
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		java.text.SimpleDateFormat fm= new java.text.SimpleDateFormat("dd/MM/yyyy")
		def createdDateF
		def createdDateT
		def customers = TrackOnlineRadioTaxi.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(params?.filters){
				def o = JSON.parse(params.filters);
				o.rules.each{
					if(it.op.equals("eq")){
						if(it.field.equals("createdDate") && !it.data.isEmpty()){
							def f=fm.parse(it.data)
							between(it.field,f,f+1)
						}
						if(it.field.equals("onlineRTaxi") && !it.data.isEmpty()){
							def data=it.data
							def oper=OnlineRadioTaxi.get(data)
							eq("onlineRTaxi", oper)
						}
					}else{
						if(hasDateBetween){
							if(	it.op.equals("lt") && it.field.equals("createdDate") && !it.data.isEmpty()){
								createdDateT=fm.parse(it.data)
							}else if(!it.op.equals("lt") && it.field.equals("createdDate") && !it.data.isEmpty()){
								createdDateF=fm.parse(it.data)
							}
						}
					}
				}
			}

			if(hasDateBetween){
				between("createdDate",createdDateF,createdDateT)
			}

			// set the order and direction
			order(sortIndex, sortOrder)
		}

		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			[cell: [
					it?.createdDate?new java.text.SimpleDateFormat("dd/MM HH:mm").format(it.createdDate):'',
					it.onlineRTaxi.id,
					it?.onlineRTaxi?it?.onlineRTaxi.company.companyName:'',
					it.status.toString()
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
}