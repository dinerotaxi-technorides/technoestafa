package com.audit

import java.text.DateFormat
import java.text.SimpleDateFormat
import com.Spam
import com.SpamUser
import com.SpamType
import com.UserDevice
import grails.converters.JSON
import  ar.com.goliath.*
class AuditController {

	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def index = {
	}


	// return JSON list of spam
	def jq_customer_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'

		boolean hasDateBetween=org.apache.commons.lang.StringUtils.countMatches(params.filters,"createdDate")==2
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def spam = Audit.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(params?.filters){
				def o = JSON.parse(params.filters);
				 o.rules.each{
					 if(it.op.equals("eq")){
						 if(it.field.equals("createdDate") && !it.data.isEmpty()){
							 def f=fm.parse(it.data)
							between(it.field,f,f+1)
							
						 }
						 if(it.field.equals("id") && !it.data.isEmpty()){
							def data=it.data
							def oper=Audit.get(data)
							eq("id", oper)
						}
						 if(it.field.equals("jsonParams") && !it.data.isEmpty()){
							like("jsonParams", it.data)
						}
						 if(it.field.equals("email") && !it.data.isEmpty()){
							like("email", it.data)
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

		def totalRows = spam.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = spam.collect {
			[cell: [it.id,new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(it.createdDate),
					it.page,
					it.ip,
					it?.jsonParams?it?.jsonParams:'',
					it?.email?it?.email:''
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	// return JSON list of spam
	def jq_spam_user_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def c=SpamUser.createCriteria()
		def spam = c.list(max:maxRows, offset:rowOffset) {
			
			projections{
				
				property ("spam")
				property("createdDate")
				groupProperty('spam')
				count('spam')

			}
			// set the order and direction
			order(sortIndex, sortOrder)
		}
		def totalRows = spam.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = spam.collect {
			[cell: [it.id,new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(it.createdDate),
					0
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}

	def jq_edit_customer = {
		def spam = null
		def message = ""
		def state = "FAIL"
		def id

		// determine our action
		switch (params.oper) {
			case 'add':
			// add instruction sent

				spam = new Spam(params)
				if (!spam.hasErrors() && spam.save(flush:true)) {
					message = "Spam  ${spam.id}  Added"
					id = spam.id
					state = "OK"
				} else {
					message = "Could Not Save Spam"
				}

				break;
			case 'del':
			// check Spam exists
				spam = Spam.get(params.id)
				if (spam) {
					// delete Spam
					spam.delete()
					message = "Spam  ${spam.id}  Deleted"
					state = "OK"
				}
				break;
			default:
			// default edit action
			// first retrieve the Spam by its ID
				spam = Spam.get(params.id)


				if (spam) {
					// set the properties according to passed in parameters
					spam.properties = params
					if (! spam.hasErrors() && spam.save(flush:true)) {
						message = "Spam  ${spam.id}  Updated"
						id = spam.id
						state = "OK"
					} else {
						message = "Could Not Update Spam"
					}
				}
				break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	}
	def jq_get_user_device_status={

		StringBuffer buf = new StringBuffer("<select id='status' name='status'>")

		def l=UserDevice.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}
	def jq_get_spam_type_status={

		StringBuffer buf = new StringBuffer("<select id='status' name='status'>")

		def l=SpamType.values().collect{

			buf.append("<option value='${it.name()}'").append(it.name()).append('>')
			buf.append(it.name())
			buf.append("</option>")
		}
		buf.append("</select>")

		render buf.toString()
	}


}
