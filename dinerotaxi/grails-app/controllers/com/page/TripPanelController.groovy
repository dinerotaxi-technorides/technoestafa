package com.page
import grails.converters.JSON
import ar.com.goliath.*
import ar.com.operation.Operation
import ar.com.operation.OperationHistory
import ar.com.operation.OperationPending
import ar.com.operation.TRANSACTIONSTATUS
class TripPanelController {
	def springSecurityService
	def placeService
	def tripPanelService
	def miPanelCompanyService
	def notificationService
	static allowedMethods = [getPendingTrips:'GET',edit:'POST']
	
	def index = {
	}
	
	def users = {
	}
	
	def report = {
		
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def intermediario=null
		def company=null
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			 intermediario = EmployUser.findByUsername(principal.username)
			 company=intermediario.employee
		}else if ( userInstance.authorities.contains(companyRole) ){
			 intermediario = User.findByUsername(principal.username)
			 company=intermediario
		}
		
		
		
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[operationInstanceList:miPanelCompanyService.getAll(params,company) 
			,operationInstanceTotal:miPanelCompanyService.getAllCount(params,company) ]
   }
	def cancelTrips = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[operationInstanceList:tripPanelService.getAll(params) 
			,operationInstanceTotal:tripPanelService.getAllCount(params) ]
   }
	def historyTrips = {
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def intermediario=null
		def company=null
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			 intermediario = EmployUser.findByUsername(principal.username)
			 company=intermediario.employee
		}else if ( userInstance.authorities.contains(companyRole) ){
			 intermediario = User.findByUsername(principal.username)
			 company=intermediario
		}
		def operationcrit=OperationHistory.createCriteria()
		
		
		java.util.Calendar c = java.util.Calendar.getInstance() ;
		c.set(java.util.Calendar.DAY_OF_MONTH, 1) ;
		c.add(java.util.Calendar.DAY_OF_MONTH, -1) ;
		c.set(java.util.Calendar.HOUR, 00) ;
		c.set(java.util.Calendar.MINUTE, 00) ;
		c.set(java.util.Calendar.SECOND, 00) ;
		
		def lastDayMonth=c.getTime()
		java.util.Calendar c1 = java.util.Calendar.getInstance() ;
		c1.set(java.util.Calendar.DAY_OF_MONTH, 1) ;
		c1.add(java.util.Calendar.MONTH, -1) ;
		c1.set(java.util.Calendar.HOUR, 00) ;
		c1.set(java.util.Calendar.MINUTE, 00) ;
		c1.set(java.util.Calendar.SECOND, 00) ;
		def firstDayMonth=c1.getTime()
		def countTrips =operationcrit.get() {
			projections {
				count('id')
			}
			or{
				eq('status', TRANSACTIONSTATUS.CANCELED_EMP)
				eq('status', TRANSACTIONSTATUS.CANCELED)
				eq('status', TRANSACTIONSTATUS.CALIFICATED)
				eq('status', TRANSACTIONSTATUS.COMPLETED)
			}
			eq('company',company)
			between('createdDate', firstDayMonth, lastDayMonth)
		
		}
		//log.debug "TripPanel HistoryTrips: $firstDayMonth --- $lastDayMonth"
		
		[ countTrips: countTrips]
   }
	def jq_trip_pending_list = {
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def intermediario=null
		def company=null
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			 intermediario = EmployUser.findByUsername(principal.username)
			 company=intermediario.employee
		}else if ( userInstance.authorities.contains(companyRole) ){
			 intermediario = User.findByUsername(principal.username)
			 company=intermediario
		}
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
  
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def operationcrit=OperationPending.createCriteria()

		def customers =operationcrit.list(max:maxRows, offset:rowOffset) {
			and{
				isNull('intermediario')
				isNull('taxista')
				eq('status', TRANSACTIONSTATUS.PENDING)
				eq('isTestUser', company.isTestUser)
			}
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def jsonCells = customers.collect {
			  [cell: ['',new java.text.SimpleDateFormat("dd/MM hh:mm").format(it.createdDate+4),
					  it?.user?.firstName,
					  it?.user?.lastName,
					  it?.user?.phone,
					  it.favorites?.placeFrom?.street+" "+it.favorites?.placeFrom?.streetNumber,
					  it.favorites.placeFromPso,
					  it.favorites.placeFromDto,
					  it.favorites.comments,
					  it.intermediario
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
  
		// determine our action
		switch (params.oper) {
		  default:
			// default edit action
			// first retrieve the customer by its ID
			  def oper= Operation.get(params?.id)
			  def companyRole=Role.findByAuthority("ROLE_COMPANY")
			  def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
			  def operatorRole=Role.findByAuthority('ROLE_OPERATOR')
			  def principal = springSecurityService.principal
			  def userInstance = User.findByUsername(principal.username)
			  def intermediario = EmployUser.findByUsername(principal.username)
			  String respuesta=""
			  if(userInstance.authorities.contains(companyRole) ){
				  def taxista= EmployUser.findByUsernameAndEmployee(params?.intermidiario+"@"+userInstance.email.split("@")[1],userInstance)
				  def usrInterm=EmployUser.findByEmployeeAndTypeEmploy(userInstance,TypeEmployer.OPERADOR)	
				  if (usrInterm){
					  def usr=User.get(usrInterm?.id)
					  message=tripPanelService.setTaxiByRadioTaxi(usr,oper,taxista,usrInterm,supervisorRole,operatorRole)
					  if(message.contains("OK")){
				   	   message = "Se transfirio el taxi correctamente"
					   state = "OK"
					  }
				  }else{
				  	message =" No tiene operadores debe agregar un operador"
				  }
				  break;
			  }
			  def taxista= EmployUser.findByUsernameAndEmployee(params?.intermidiario+"@"+intermediario.email.split("@")[1],intermediario.employee)
			  message=tripPanelService.setTaxiByRadioTaxi(userInstance,oper,taxista,intermediario,supervisorRole,operatorRole)
			  if(message.contains("OK")){
				  message = "Se transfirio el taxi correctamente"
				  state = "OK"
			  }
			
			break;
		}
  
		def response = [message:message,state:state,id:id]
  
		render response as JSON
	  }
	//editar pedidos 
	
	
	def jq_edit_trip_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
  
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
  
		
		
		
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def intermediario=null
		def company=null
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			 intermediario = EmployUser.findByUsername(principal.username)
			 company=intermediario.employee
		}else if ( userInstance.authorities.contains(companyRole) ){
			 intermediario = User.findByUsername(principal.username)
			 company=intermediario
		}
		def customers = OperationPending.createCriteria().list(max:maxRows, offset:rowOffset) {
			and{
				eq('company',company)
				eq('status', TRANSACTIONSTATUS.INTRANSACTIONRADIOTAXI)
		    }
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def jsonCells = customers.collect {
			 if( it?.user?.isTestUser==company.isTestUser && it?.user?.isTestUser!=null ){
			  [cell: [new java.text.SimpleDateFormat("dd/MM hh:mm").format(it.createdDate),
					  it.user.firstName,
					  it.user.lastName,
					  it.user.phone,
					  it.favorites?.placeFrom?.street+" "+it.favorites?.placeFrom?.streetNumber,
					  it.favorites.placeFromPso,
					  it.favorites.placeFromDto,
					  it.favorites.comments,
					  it.taxista.email.split("@")[0]
				  ], id: it.id]
			 }
		  }
		  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		  render jsonData as JSON
	}
	def jq_history_trip_list = {
		def sortIndex = params.sidx ?: 'createdDate'
		def sortOrder  = params.sord ?: 'asc'
  
		def maxRows = Integer.valueOf(params.rows)
		def currentPage = params.page?Integer.valueOf(params.page) : 1
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
  
		
		
		
		def companyRole=Role.findByAuthority("ROLE_COMPANY")
		def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
		def operadorRole=Role.findByAuthority('ROLE_OPERATOR')
		def principal = springSecurityService.principal
		def userInstance = User.findByUsername(principal.username)
		def intermediario=null
		def company=null
		if(  userInstance.authorities.contains(supervisorRole) || userInstance.authorities.contains(operadorRole) ){
			 intermediario = EmployUser.findByUsername(principal.username)
			 company=intermediario.employee
		}else if ( userInstance.authorities.contains(companyRole) ){
			 intermediario = User.findByUsername(principal.username)
			 company=intermediario
		}
		def customers = OperationHistory.createCriteria().list(max:maxRows, offset:rowOffset) {
			and{
				eq('company',company)
				isNotNull('taxista')
				or{
					
					eq('status', TRANSACTIONSTATUS.CANCELED_EMP)
					eq('status', TRANSACTIONSTATUS.CANCELED)
					eq('status', TRANSACTIONSTATUS.COMPLETED)
					eq('status', TRANSACTIONSTATUS.CALIFICATED)
				}
			}
		  
			  // set the order and direction
			  order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		
		def jsonCells = customers.collect {
			def piso = it.favorites?.placeFromPso?:''
			def depto= it?.favorites?.placeFromDto?:''
			def compania=it?.user?.rtaxi?.companyName?:'DineroTaxi'
			  [cell: [new java.text.SimpleDateFormat("dd/MM hh:mm").format(it.createdDate),
					  it.user.firstName,
					  it.user.lastName,
					  it.taxista.username.split('@')[0],
					  it.user.phone,
					  it.favorites?.placeFrom?.street+" "+it.favorites?.placeFrom?.streetNumber+" "+piso+" "+ depto,
					  it.favorites.comments,
					  it.status.toString(),
					  compania
				  ], id: it.id]
		  }
		  def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages]
		  render jsonData as JSON
	}
	def jq_edit_trip_edit = {
		def customer = null
		def message = ""
		def state = "FAIL"
		def id
  
		// determine our action
		switch (params.oper) {
			case 'del':
			// check customer exists
			
			def operationInstance = Operation.get(params.id)
			if (operationInstance) {
				try {
					operationInstance.status=TRANSACTIONSTATUS.CANCELED_EMP
					operationInstance.save(flush:true)
					Operation.executeUpdate("update Operation b set b.class=:cClass, b.status=:status where b.id=:oldTitle",
						[cClass: OperationHistory.name, oldTitle: operationInstance.id,status:TRANSACTIONSTATUS.CANCELED_EMP])
					operationInstance.status=TRANSACTIONSTATUS.CANCELED_EMP
					notificationService.notificateOnCancelWeNoVeTaxi(operationInstance,operationInstance.user,false)
					message = "Se ha cancelado el pedido pendiente."
					state = "OK"
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					message = message(code: 'mipanel.mispedidos.cancelOrder.error')
				}
			}else{
				message = message(code: 'mipanel.mispedidos.cancelOrder.error.not.found')
			}
			
			break;
		  default:
			// default edit action
			// first retrieve the customer by its ID
			  def oper= Operation.get(params?.id)
			  def companyRole=Role.findByAuthority("ROLE_COMPANY")
			  def supervisorRole=Role.findByAuthority('ROLE_SUPERVISOR')
			  def operatorRole=Role.findByAuthority('ROLE_OPERATOR')
			  def principal = springSecurityService.principal
			  def userInstance = User.findByUsername(principal.username)
			  def intermediario = EmployUser.findByUsername(principal.username)
			  String respuesta=""
			  if(userInstance.authorities.contains(companyRole) ){
				  def taxista= EmployUser.findByUsernameAndEmployee(params?.intermidiario+"@"+userInstance.email.split("@")[1],userInstance)
				  def usrInterm=EmployUser.findByEmployeeAndTypeEmploy(userInstance,TypeEmployer.OPERADOR)
				  if (usrInterm){
					  def usr=User.get(usrInterm?.id)
					  message=tripPanelService.setTaxi(usr,oper,taxista,usrInterm,supervisorRole,operatorRole)
					  if(message.contains("OK")){
						  message = "Se transfirio el taxi correctamente"
					   state = "OK"
					  }
				  }else{
					  message =" No tiene operadores debe agregar un operador"
				  }
				  break;
			  }
			  def taxista= EmployUser.findByUsernameAndEmployee(params?.intermidiario+"@"+intermediario.email.split("@")[1],intermediario.employee)
			  message=tripPanelService.setTaxi(userInstance,oper,taxista,intermediario,supervisorRole,operatorRole)
			  if(message.contains("OK")){
				  message = "Se transfirio el taxi correctamente"
				  state = "OK"
			  }
			
			break;
		}
  
		def response = [message:message,state:state,id:id]
  
		render response as JSON
	  }
	
	
	
	
	
	
	
}
