package com.promotions

import grails.converters.JSON

import java.text.DateFormat
import java.text.SimpleDateFormat

import com.UserDevice;


class SettingsPromotionsController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
    }


    // return JSON list of settingsPromotions
    def jq_customer_list = {
      def sortIndex = params.sidx ?: 'codeQr'
      def sortOrder  = params.sord ?: 'asc'

      def maxRows = Integer.valueOf(params.rows)      
      def currentPage = params.page?Integer.valueOf(params.page) : 1
      def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

      def settingsPromotions = SettingsPromotions.createCriteria().list(max:maxRows, offset:rowOffset) {

            // first name case insensitive where the field begins with the search term
            if (params.name)
                ilike('name',params.name + '%')

            // last name case insensitive where the field begins with the search term
            if (params.codeQr)
                ilike('codeQr',params.codeQr + '%')


        
            // set the order and direction
            order(sortIndex, sortOrder)
      }

      def totalRows = settingsPromotions.totalCount
      def numberOfPages = Math.ceil(totalRows / maxRows)

      def jsonCells = settingsPromotions.collect {
            [cell: [it.name,
                    it.codeQr,
                    it.discount,
                    new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(it.startDate),
                    new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(it.finishDate)
                ], id: it.id]
        }
        def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
        render jsonData as JSON
    }


    def jq_edit_customer = {
      def settingsPromotions = null
      def message = ""
      def state = "FAIL"
      def id

      // determine our action
      switch (params.oper) {
        case 'add':
          // add instruction sent
		  DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		  if(params?.startDate)
		  	 params.startDate = df.parse( params?.startDate)
		  if(params?.finishDate)
			   params.finishDate = df.parse( params?.finishDate)
          settingsPromotions = new SettingsPromotions(params)
		 
		  
          if (! settingsPromotions.hasErrors() && settingsPromotions.save(flush:true)) {
            message = "SettingsPromotions  ${settingsPromotions.name} ${settingsPromotions.codeQr} Added"
            id = settingsPromotions.id
            state = "OK"
          } else {
		  settingsPromotions.errors.each {
		  }
            message = "Could Not Save SettingsPromotions"
          }

          break;
        case 'del':
          // check SettingsPromotions exists
          settingsPromotions = SettingsPromotions.get(params.id)
          if (settingsPromotions) {
            // delete SettingsPromotions
            settingsPromotions.delete()
            message = "SettingsPromotions  ${settingsPromotions.name} ${settingsPromotions.codeQr} Deleted"
            state = "OK"
          }
          break;
        default:
          // default edit action
          // first retrieve the SettingsPromotions by its ID
          settingsPromotions = SettingsPromotions.get(params.id)
		  DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		  if(params?.startDate)
		  	 params.startDate = df.parse( params?.startDate)
		  if(params?.finishDate)
			   params.finishDate = df.parse( params?.finishDate)
		 
          if (settingsPromotions) {
            // set the properties according to passed in parameters
            settingsPromotions.properties = params
            if (! settingsPromotions.hasErrors() && settingsPromotions.save(flush:true)) {
              message = "SettingsPromotions  ${settingsPromotions.name} ${settingsPromotions.codeQr} Updated"
              id = settingsPromotions.id
              state = "OK"
            } else {
              message = "Could Not Update SettingsPromotions"
            }
          }
          break;
      }

      def response = [message:message,state:state,id:id]

      render response as JSON
    }
	
	
	def render = {
		def myDailyActivitiesColumns = [['string', 'Fecha'], ['number', 'ANDROID'], ['number', 'IOS'],['number', 'BB'],['number', 'WEB']]
		def q=Promotions.executeQuery("SELECT date_format(clnt.createdDate, '%Y-%m-%d %H') as d,count(clnt.id),clnt.dev FROM Promotions clnt GROUP BY date_format(created_date, '%Y-%m-%d %H'),clnt.dev")
		TreeMap<String, Integer> web=new TreeMap<String,Integer>()
		TreeMap<String, Integer> android=new TreeMap<String,Integer>()
		TreeMap<String, Integer> ios=new TreeMap<String,Integer>()
		TreeMap<String, Integer> bb=new TreeMap<String,Integer>()
		q.each {  
				web.get(it[0])?:web.put(it[0], 0)
				android.get(it[0])?:android.put(it[0], 0)
				ios.get(it[0])?:ios.put(it[0], 0)
				bb.get(it[0])?:bb.put(it[0], 0)
				if(it[2]==UserDevice.WEB){
					web.put(it[0], it[1])
				} 
				if(it[2]==UserDevice.ANDROID){
					android.put(it[0], it[1])
				} 
				if(it[2]==UserDevice.IPHONE){
					ios.put(it[0], it[1])
				}
				if(it[2]==UserDevice.BB){
					bb.put(it[0], it[1])
				
				}
			
		}
		
		DateFormat df1 = new SimpleDateFormat("yyyy-MM-dd HH");
		def data1=[]
		for(Map.Entry<String,Integer> entry : web.entrySet()) {
			String key = entry.getKey();
			Integer value = entry.getValue();
			data1.add([key,android.get(key),ios.get(key),bb.get(key),web.get(key)])
		}
		
		
		def myDailyActivitiesData =  data1
		render template: "chart", model: ["myDailyActivitiesColumns": myDailyActivitiesColumns,
										  "myDailyActivitiesData": myDailyActivitiesData]
	}
}
