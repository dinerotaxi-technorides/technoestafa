package com.page.admin

import ar.com.operation.*
import grails.converters.*
import ar.com.goliath.*
import ar.com.goliath.api.*
import ar.com.goliath.TypeEmployer

import com.*
class TripPanelAdminController {
	def springSecurityService
	def placeService
	def tripPanelService
	def notificationService
	static allowedMethods = [getPendingTrips:'GET',edit:'POST']

	def index = {
	}


	def jq_trip_pending_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'

		def maxRows = Integer.valueOf(params?.rows)
		def currentPage = Integer.valueOf(params?.page) ?: 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = Operation.createCriteria().list(max:maxRows, offset:rowOffset) {
			isNotNull('createdDate')
			or{
				eq('status',TRANSACTIONSTATUS.PENDING)
				eq('status',TRANSACTIONSTATUS.INTRANSACTION)
				eq('status',TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI)
				eq('status',TRANSACTIONSTATUS.ASSIGNEDRADIOTAXI)
				eq('status',TRANSACTIONSTATUS.ASSIGNEDTAXI)
			}
			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			String taxi=""
			if(it.taxista?.email){
				taxi=it.taxista?.email.split("@")[0]
			}
			[cell: [it.id,new java.text.SimpleDateFormat("dd/MM HH:mm").format(it.createdDate),
					it.isCompanyAccount,
					it?.user?.rtaxi?true:false,
					it.user.username,
					it.user.firstName+" "+
					it.user.lastName,
					it.favorites?.placeFrom?.street+" "+it.favorites?.placeFrom?.streetNumber,
					it.company?.companyName,
					taxi,
					it.status.name(),
					it.timeTravel,
					it.favorites.comments,
					it.user.isTestUser,
					it.isTestUser
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	def jq_edit_customer = {
		def customer = null
		def message = ""
		def state = "FAIL"
		def id
		String respuesta=""
		// determine our action
		switch (params.oper) {
				case 'del':
					
					def oper= Operation.get(params?.id)
					if(oper&& (oper instanceof OperationPending || oper instanceof OperationCompanyPending)){
						oper.status=TRANSACTIONSTATUS.CANCELED
						oper.save(flush:true)
						
						if(oper?.isCompanyAccount){
							Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
								[cClass: OperationCompanyHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.CANCELED])
						}else{
							Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
								[cClass: OperationHistory.name, oldTitle: oper.id,status:TRANSACTIONSTATUS.CANCELED])
						
						}
	
						def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.CANCELED_EMP)
						trackOperation.operation=oper
						trackOperation.comment=params.comment
						trackOperation.save(flush:true)
						notificationService.notificateOnCancelWeNoVeTaxi(oper, oper.user, false);
						message = "Se transfirio el taxi correctamente"
						state = "OK"
					}else if ( !(oper instanceof OperationPending || oper instanceof OperationCompanyPending)){
						message = "Error operacion ya cancelada"
					
					}else{
						message = "Error no se encuentra el pedido"
					
					}
					
					break;
				default:
					def oper= Operation.get(params?.id)
					oper.refresh()
					def onlineRadiotaxi=OnlineRadioTaxi.get(params?.intermidiario)
					def intermediario=User.get(onlineRadiotaxi.company.id)
					def taxista= EmployUser.findByUsernameAndEmployee(params?.taxista+"@"+intermediario.email.split("@")[1],intermediario)
					
					def supervisorRole=Role.findByAuthority("ROLE_SUPERVISOR")
					def operadorRole=Role.findByAuthority("ROLE_OPERATOR")
					Long timeT=Long.valueOf(params?.timeTravel.toString())
					if(!operadorRole || !supervisorRole){
						message="los roles no existen"
					}else if(!taxista?.employee){
						message="No existe el taxista"
					
					}else if(!onlineRadiotaxi){
						message="no existe el radiotaxi"
					}else if (oper&& (oper instanceof OperationPending || oper instanceof OperationCompanyPending)){
						def usrInterm=EmployUser.findByEmployeeAndTypeEmploy(intermediario,TypeEmployer.OPERADOR)
						message=tripPanelService.setTaxiByRadioTaxiApi(onlineRadiotaxi.operator,oper,taxista,usrInterm,supervisorRole,operadorRole,timeT)
						
						if(message.contains("OK")){
							message = "Se transfirio el taxi correctamente"
							state = "OK"
						}
					}else{
						message =" No tiene operadores debe agregar un operador"
					}
					
					if(message.contains("OK")){
						message = "Se transfirio el taxi correctamente"
						state = "OK"
					}
				    break;
		}

		def response = [message:message,state:state,id:id]

		render response as JSON
	}
	
	
	
	def jq_trip_serching_list = {
		
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
		boolean hasDateBetween=org.apache.commons.lang.StringUtils.countMatches(params.filters,"createdDate")==2
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		java.text.SimpleDateFormat fm= new java.text.SimpleDateFormat("dd/MM/yyyy")
		def createdDateF
		def createdDateT
		  def customers = Operation.createCriteria().list(max:maxRows, offset:rowOffset) {
				eq('isTestUser', false)
			  
			  if(params?.filters){
				  def o = JSON.parse(params.filters);
				   o.rules.each{
					   if(it.op.equals("eq")){
						   if(it.field.equals("createdDate") && !it.data.isEmpty()){
							   def f=fm.parse(it.data)
							  between(it.field,f,f+1)
							  
						   }
						   if(it.field.equals("status") && !it.data.isEmpty()){
							  eq(it.field,TRANSACTIONSTATUS.valueOf(it.data ))
						   }
						   if(it.field.equals("email") && !it.data.isEmpty()){
							   def data=it.data
							   user{
								   ilike("email", data)
							   }
						   }
						   if(it.field.equals("intermidiario") && !it.data.isEmpty()){
							   def data=it.data
							   company{
								   ilike("companyName", data)
							   }
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
			String taxi=""
			if(it.taxista?.email){
				taxi=it.taxista?.email.split("@")[0]
			}
			[cell: [it.id,it?.createdDate?new java.text.SimpleDateFormat("dd/MM hh:mm").format(it.createdDate):'',
					it.isCompanyAccount,
					it?.user?.rtaxi?true:false,
					it?.amount?it?.amount:'',
					it.user.email,
					it.user.firstName+" "+
					it.user.lastName,
					it.favorites?.placeFrom?.street+" "+it.favorites?.placeFrom?.streetNumber,
					it.company?.companyName,
					taxi,
					it.status.name(),
					it.timeTravel,
					it.favorites.comments,
					it.user.isTestUser,
					it.isTestUser
				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		render jsonData as JSON
	}
	
	
	
	
	
}