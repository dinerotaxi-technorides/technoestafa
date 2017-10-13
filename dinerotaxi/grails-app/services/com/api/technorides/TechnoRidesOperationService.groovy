package com.api.technorides

import grails.converters.JSON
import java.text.SimpleDateFormat
import ar.com.favorites.TemporalFavorites
import ar.com.goliath.Place
import ar.com.goliath.corporate.CorporateUser
import ar.com.operation.DelayOperation
import ar.com.operation.Operation
import ar.com.operation.OperationCompanyHistory
import ar.com.operation.OperationCompanyPending
import ar.com.operation.OperationHistory
import ar.com.operation.OperationPending
import ar.com.operation.Options
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.TrackOperation
import ar.com.operation.UserOperationLog
import com.api.utils.UtilsApiService

class TechnoRidesOperationService {
	static transactional = true
	def utilsApiService
	def notificationService
	def createFavoriteAndOperation(businessModel,middleMan, user, addressFrom, addressTo, optionsJSON,device,argss) {
		def comments = argss?.comments
		def paymentReference = argss?.payment_reference
		def driverNumber = argss?.driver_number
		def amount = argss?.amount

		def name=addressFrom?.street+" "+addressFrom?.number
		def placeFromString=utilsApiService.generateAddress(addressFrom)
		def o = JSON.parse(placeFromString)
		def pl = new Place(o)
		pl.json = placeFromString
		if(!pl.save(flush:true)){
			pl.errors.each{ println it }
			throw new Exception("createFavoriteAndOperation: Problem placeFrom")
		}
		if(addressTo!=null && !addressTo.equals("") && addressTo?.lat){
			def placeToString=utilsApiService.generateAddress(addressTo)
			def o1 = JSON.parse(placeToString)
			def pl1 = new Place(o1)
			pl1.json = placeToString
			if(!pl1.save(flush:true)){
				pl.delete()
				throw new Exception("createFavoriteAndOperation: Problem placeTo")
			}
			def fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
			if(!fav.save(flush:true)){
				pl.delete()
				if(pl1!=null){
					pl1.delete()
				}
				throw new Exception("createFavoriteAndOperation: Problem Favorites")
			}
			def options=new Options(optionsJSON)
			if(!options.save(flush:true)){
				pl.delete()
				fav.delete()
				if(pl1!=null){
					pl1.delete()
				}
				throw new Exception("createFavoriteAndOperation: Problem Options")
			}

			def oper=new OperationPending(user:user,favorites:fav,isTestUser:user.isTestUser)
			oper.businessModel = businessModel
			oper.options=options
			oper.isTestUser=user.isTestUser
			oper.dev=device.dev
			oper.company=user?.rtaxi
			oper.sendToSocket=false
			oper.paymentReference=paymentReference
			oper.createdByOperator=true
			oper.intermediario = middleMan
			try {
				if (driverNumber!=null && driverNumber.isNumber())
					oper.driverNumber = Integer.parseInt(driverNumber)
			} catch (Exception e) {
				e.printStackTrace()
			}
			try {
				if (amount!=null)
					oper.amount =Double.parseDouble(amount)
			} catch (Exception e) {
				e.printStackTrace()
			}
			if(!oper.save(flush:true)){
				fav.delete()
				pl.delete()
				if(pl1!=null){
					pl1.delete()
				}
				throw new Exception("createFavoriteAndOperation: Problem Operation")
			}else{
				def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
				trackOperation.operation=oper
				trackOperation.save(flush:true)
				//notificationService.notificateOnCreateTrip(oper,user)
			}
			return oper
		}else{
			def fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:null,user:user)
			//new Favorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:null,user:user)
			if(!fav.save(flush:true)){
				pl.delete()
				throw new Exception("createFavoriteAndOperation: Problem Favorites")
			}
			def options=new Options(optionsJSON)
			if(!options.save(flush:true)){
				pl.delete()
				fav.delete()
				throw new Exception("createFavoriteAndOperation: Problem Options")
			}
			def oper=new OperationPending(user:user,favorites:fav)
			oper.businessModel = businessModel
			oper.isTestUser=user.isTestUser
			oper.dev=device.dev
			oper.options=options
			oper.company=user?.rtaxi
			oper.sendToSocket=false
			oper.createdByOperator=true
			oper.paymentReference=paymentReference

			try {
				if (driverNumber!=null)
					oper.driverNumber = Integer.parseInt(driverNumber)
			} catch (Exception e) {
				e.printStackTrace()
			}
			try {
				if (amount!=null)
					oper.amount =Double.parseDouble(amount)
			} catch (Exception e) {
				e.printStackTrace()
			}
			if(!oper.save(flush:true)){
				oper.errors.each{ println it }
				fav.delete()
				pl.delete()
				throw new Exception("createFavoriteAndOperation: Problem Operation")
			}else{

				def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
				trackOperation.operation=oper
				trackOperation.save(flush:true)
				//notificationService.notificateOnCreateTrip(oper,user)
			}
			return oper
		}
	}

	def createOperationCC(businessModel, middleMan,user, addressFrom, addressTo, optionsJSON,device,argss) {
		def comments = argss?.comments
		def paymentReference = argss?.payment_reference
		def driverNumber = argss?.driver_number
		def amount =argss?.amount
		def name=addressFrom?.street+" "+addressFrom?.number
		def placeFromString=utilsApiService.generateAddress(addressFrom)
		def o = JSON.parse(placeFromString)
		def pl = new Place(o)
		pl.json = placeFromString
		if(!pl.save(flush:true)){
			pl.errors.each{ println it }
			throw new Exception("createFavoriteAndOperation: Problem placeFrom")
		}
		if(addressTo!=null && !addressTo.equals("")){
			def placeToString=utilsApiService.generateAddress(addressTo)
			def o1 = JSON.parse(placeToString)
			def pl1 = new Place(o1)
			pl1.json = placeToString
			if(!pl1.save(flush:true)){
				pl.delete()
				throw new Exception("createFavoriteAndOperation: Problem placeTo")
			}
			def fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
			//new Favorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:pl1,user:user,placeToFloor:addressTo?.floor,placeToApartment:addressTo?.apartment)
			if(!fav.save(flush:true)){
				pl.delete()
				if(pl1!=null){
					pl1.delete()
				}
				throw new Exception("createFavoriteAndOperation: Problem Favorites")
			}
			def options=new Options(optionsJSON)
			if(!options.save(flush:true)){
				pl.delete()
				fav.delete()
				if(pl1!=null){
					pl1.delete()
				}
				throw new Exception("createFavoriteAndOperation: Problem Options")
			}

			def oper=new OperationCompanyPending(user:user,favorites:fav,isTestUser:user.isTestUser)
			oper.businessModel = businessModel
			oper.options=options
			oper.isTestUser=user.isTestUser
			if(user?.costCenter?.corporate){
				oper.corporate=user?.costCenter?.corporate

			}
			oper.costCenter=user.costCenter
			oper.dev=device.dev
			oper.company=user?.rtaxi
			oper.isCompanyAccount=true
			oper.sendToSocket=false
			oper.createdByOperator=true
			oper.paymentReference=paymentReference

			oper.intermediario = middleMan
			try {
				if (driverNumber!=null)
					oper.driverNumber = Integer.parseInt(driverNumber)
			} catch (Exception e) {
				e.printStackTrace()
			}
			try {
				if (amount!=null)
					oper.amount =Double.parseDouble(amount)
			} catch (Exception e) {
				e.printStackTrace()
			}
			if(!oper.save(flush:true)){
				fav.delete()
				pl.delete()
				if(pl1!=null){
					pl1.delete()
				}
				throw new Exception("createFavoriteAndOperation: Problem Operation")
			}else{
				def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
				trackOperation.operation=oper
				trackOperation.save(flush:true)
				//notificationService.notificateOnCreateTrip(oper,user)
			}
			return oper
		}else{
			def fav=new TemporalFavorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:null,user:user)
			//new Favorites(name:name,placeFromPso:addressFrom?.floor,placeFromDto:addressFrom?.apartment,comments:comments,placeFrom:pl,placeTo:null,user:user)
			if(!fav.save(flush:true)){
				pl.delete()
				throw new Exception("createFavoriteAndOperation: Problem Favorites")
			}
			def options=new Options(optionsJSON)
			if(!options.save(flush:true)){
				pl.delete()
				fav.delete()
				throw new Exception("createFavoriteAndOperation: Problem Options")
			}
			def oper=new OperationCompanyPending(user:user,favorites:fav)
			oper.businessModel = businessModel
			oper.isTestUser=user.isTestUser
			oper.corporate=user.corporate
			oper.costCenter=user.costCenter
			oper.dev=device.dev
			oper.options=options
			oper.company=user?.rtaxi
			oper.isCompanyAccount=true
			oper.sendToSocket=false
			oper.createdByOperator=true
			oper.paymentReference=paymentReference

			try {
				if (driverNumber!=null)
					oper.driverNumber = Integer.parseInt(driverNumber)
			} catch (Exception e) {
				e.printStackTrace()
			}
			try {
				if (amount!=null)
					oper.amount =Double.parseDouble(amount)
			} catch (Exception e) {
				e.printStackTrace()
			}
			if(!oper.save(flush:true)){
				oper.errors.each{ println it }
				fav.delete()
				pl.delete()
				throw new Exception("createFavoriteAndOperation: Problem Operation")
			}else{

				def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
				trackOperation.operation=oper
				trackOperation.save(flush:true)
				//notificationService.notificateOnCreateTrip(oper,user)
			}
			return oper
		}
	}

	def getOperationsHistoryByUser( params,user) {
		def customers = Operation.createCriteria().list(max:params?.max?:5) {
			eq('user',user)
			order("id", "desc")
		}

		def jsonBuilder = new groovy.json.JsonBuilder()

		def jsonCells = customers.collect {
			def addressTostreet        = it?.favorites?.placeTo?.street?:''
			def addressTostreetNumber  = it?.favorites?.placeTo?.streetNumber?:''
			def addressTocountry       = it?.favorites?.placeTo?.country?:''
			def addressTolocality      = it?.favorites?.placeTo?.locality?:''
			def addressToadmin1Code    = it?.favorites?.placeTo?.admin1Code?:''
			def addressTofloor	       = it?.favorites?.placeToFloor?:''
			def addressTolat		       = it?.favorites?.placeTo?.lat?:0
			def addressTolng		       = it?.favorites?.placeTo?.lng?:0
			def addressToappartment    = it?.favorites?.placeToApartment?:''
			def placeToBuilder = jsonBuilder{
				street  addressTostreet
				streetNumber  addressTostreetNumber
				country  addressTocountry
				locality  addressTolocality
				admin1Code  addressToadmin1Code
				floor	addressTofloor
				lat		addressTolat
				lng		addressTolng
				appartment addressToappartment
			}
			def compania=it?.user?.rtaxi?.companyName?:'DineroTaxi'
			def piso = it.favorites?.placeFromPso?:''
			def depto= it?.favorites?.placeFromDto?:''
			def street_number =it.favorites?.placeFrom?.streetNumber?:''
			[
				id:it.id,
				street:it.favorites?.placeFrom?.street,
				street_number:street_number,
				admin_1_code:it.favorites?.placeFrom?.admin1Code,
				locality:it.favorites?.placeFrom?.locality,
				country:it.favorites?.placeFrom?.country,
				country_code:it.favorites?.placeFrom?.countryCode,
				floor:piso,
				department:depto,
				lat:it.favorites?.placeFrom?.lat,
				lng:it.favorites?.placeFrom?.lng,
				comments:it.favorites.comments,
				place_to:placeToBuilder

			]
		}
		def jsonData= [result: jsonCells,status:100]
		return jsonData as JSON
	}

	def getReportByTx( params,rtaxi) {

		def customers = Operation.createCriteria().list() {
			eq('company',rtaxi)
			order("favorites", "desc")
		}

		def jsonCells = customers.collect {
			def compania=it?.user?.rtaxi?.companyName?:'DineroTaxi'
			def piso = it.favorites?.placeFromPso?:''
			def depto= it?.favorites?.placeFromDto?:''
			[
				id:it.id,
				street:it.favorites?.placeFrom?.street,
				street_number:it.favorites?.placeFrom?.streetNumber,
				admin_1_code:it.favorites?.placeFrom?.admin1Code,
				locality:it.favorites?.placeFrom?.locality,
				country:it.favorites?.placeFrom?.country,
				country_code:it.favorites?.placeFrom?.countryCode,
				floor:piso,
				department:depto,
				lat:it.favorites?.placeFrom?.lat,
				lng:it.favorites?.placeFrom?.lng,
				comments:it.favorites.comments
			]
		}
		def jsonData= [result: jsonCells]
		return jsonData as JSON
	}
	def getOperationForInvoice( params,rtaxi) {
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
//		OperationCompanyHistory
		def customers = OperationCompanyHistory.createCriteria().list() {
			eq('company',rtaxi)
			between("createdDate", sf.parse( params?.dateFrom), addorDeleteDays(1,sf.parse( params?.dateTo),true) )

			order('id', 'desc')
		}

		def jsonCells = customers.collect {OperationCompanyHistory oper ->
			[
				date:utilsApiService.generateFormatedAddressToClient(oper.createdDate,oper.user),
				operationId:oper.id?:"",
				userId:oper.user?.id?:"",
				firstName:oper.user?.firstName?:"",
				lastName:oper.user?.lastName?:"",
				count:1,
				amount:oper?.amount?:0
			]
		}
		def jsonData= [result: jsonCells,status:100]
		return jsonData as JSON
	}
	def getOperationForInvoiceCost( params,rtaxi,cost_center) {
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		def customers = OperationCompanyHistory.createCriteria().list() {
			eq('company',rtaxi)
			eq('costCenter',cost_center)
			between("createdDate", sf.parse( params?.dateFrom), addorDeleteDays(1,sf.parse( params?.dateTo),true) )
			'in'("status",[TRANSACTIONSTATUS.COMPLETED,TRANSACTIONSTATUS.CALIFICATED,TRANSACTIONSTATUS.SETAMOUNT])
			order('id', 'desc')
		}

		def jsonCells = customers.collect {OperationCompanyHistory oper ->
			[
				date:utilsApiService.generateFormatedAddressToClient(oper.createdDate,oper.user),
				operationId:oper.id?:"",
				userId:oper.user?.id?:"",
				firstName:oper.user?.firstName?:"",
				lastName:oper.user?.lastName?:"",
				count:1,
				amount:oper?.amount?:0
			]
		}
		def jsonData= [result: jsonCells,status:100]
		return jsonData as JSON
	}
	private Date addorDeleteDays(int dayCount,Date incomingDate,boolean add){
		Calendar cal = Calendar.getInstance();
		cal.setTime(incomingDate);
		if (add) {
			cal.add(Calendar.DATE, +dayCount); //minus number would decrement the days
		}else{
			cal.add(Calendar.DATE,-dayCount); //minus number would decrement the days
		}
		return cal.getTime();
	}

	def generateReport( params,rtaxi) {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'

		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

		Date dateFrom = sf.parse(params?.dateFrom + ' 00:00:00')
		Date dateTo = sf.parse(params?.dateTo + ' 23:59:59')

		if(params.sidx.equals("auto")){
			sortIndex ="taxista"
		}
		def customers = OperationHistory.createCriteria().list() {
			and{
				eq('company',rtaxi)
				between("createdDate", dateFrom , dateTo)
			}

			order(sortIndex, sortOrder)
		}
		File file =null;
		file=new File("report.csv");
		if(!file.exists()) {
			file.createNewFile();
		}
		FileWriter report = new FileWriter(file);

		if('es' == rtaxi?.lang?:'es'){
			report.write(UtilsApiService.translateES("id,date,firstName,lastName,driver,phone,AddressFrom,AddressTo,comments,stars,status,amount")+"\n")
		}else{
			report.write("id,date,firstName,lastName,driver,phone,AddressFrom,AddressTo,comments,stars,status,amount"+"\n")
		}

		for (oper in customers) {
			def createDate = utilsApiService.generateFormatedAddressToClient(oper.createdDate,oper.user)

			//Check the createDate interval using country time zone and excludes it
			if (sf.parse(createDate).compareTo(dateFrom) != -1){
        def piso = oper.favorites?.placeFromPso?:''
        def depto= oper?.favorites?.placeFromDto?:''
        def driver =oper?.taxista?.username?oper?.taxista?.username.split('@')[0]:''
        def compania=oper?.user?.rtaxi?.companyName?:'DineroTaxi'
        def placeFrom = oper.favorites?.placeFrom?.street+" "+oper.favorites?.placeFrom?.streetNumber+" "+piso+" "+ depto
				placeFrom = placeFrom.replaceAll(",", " ")
			  def firstName = oper.user.firstName?oper.user.firstName.replaceAll(",", " "):""
			  def lastName = oper.user.lastName?oper.user.lastName.replaceAll(",", " "):""
        def placeTo=""
				if(oper.favorites?.placeTo?.street){
            placeTo = oper.favorites?.placeTo?.street+" "+oper.favorites?.placeTo?.streetNumber
						placeTo = placeTo.replaceAll(",", " ")
        }
				def comments = oper.favorites.comments
				//Removes (,) comma in order to avoid words shifting
        if (comments != null){comments=comments.replaceAll(",", " ")}
        def data = "${oper.id},${createDate},${firstName},${lastName},${driver},${oper.user.phone},${placeFrom},${placeTo},${comments},${oper.stars},${oper.status.toString()},${oper.amount}"
				report.write(data+"\n")
			}
    }
		report.flush();
		report.close();
		return file
	}

	def getOperationCompanyHistory( params,rtaxi) {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = Integer.valueOf(params.rows?:10)
		def currentPage = Integer.valueOf(params.page?: 1)
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		if(params.sidx.equals("auto")){
			sortIndex ="taxista"
		}
		def customers = Operation.createCriteria().list(max:maxRows, offset:rowOffset) {
			and{
				eq('company',rtaxi)
				if(  params.searchField.equals("id") && !params.searchString.isEmpty()){
					eq("id", Long.valueOf(params.searchString))
				}
				if(  params.searchField.equals("driver") && !params.searchString.isEmpty()){
					taxista{
						like("email", params.searchString+"%")
					}
				}
				if(  params.searchField.equals("user") && !params.searchString.isEmpty()){
					user{
						like("lastName", params.searchString+"%")
					}
				}
				if(  params.searchField.equals("user_id") && !params.searchString.isEmpty()){
					user{
						eq("id", Long.valueOf(params.searchString))
					}
				}
				if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
					user{
						like("phone", params.searchString+"%")
					}
				}
				if(  params.searchField.equals("driver_id") && !params.searchString.isEmpty()){
					taxista{
						eq("email", params.searchString)
					}
				}

				if( params?.searchDateFrom &&  !params.searchDateFrom.isEmpty()&& !params.searchDateTo.isEmpty()){

					java.text.SimpleDateFormat fm= new java.text.SimpleDateFormat("dd/MM/yyyy")
					def date_from =  params.searchDateFrom
					def date_to   =  params.searchDateTo
					between('createdDate',fm.parse(date_from),fm.parse(date_to))
				}
			}

			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			def piso = it.favorites?.placeFromPso?:''
			def depto= it?.favorites?.placeFromDto?:''
			def driver =it?.taxista?.username?it?.taxista?.username.split('@')[0]:''
			def compania=it?.user?.rtaxi?.companyName?:'DineroTaxi'
			def placeTo=""
			def placeFromLat = it.favorites?.placeFrom?.lat
			def placeFromLng = it.favorites?.placeFrom?.lng
            def placeFrom = it.favorites?.placeFrom?.street
			placeFrom += it.favorites?.placeFrom?.streetNumber?:""
			placeFrom += " " + piso + " " + depto
			placeFrom = placeFrom.replaceAll("null", "")

		    def messaging = it.options?.messaging?:false
		    def pet = it.options?.pet?:false
		    def airConditioning = it.options?.airConditioning?:false
		    def smoker = it.options?.smoker?:false
		    def specialAssistant = it.options?.specialAssistant?:false
		    def luggage = it.options?.luggage?:false
		    def airport = it.options?.airport?:false
		    def vip = it.options?.vip?:false
		    def invoice = it.options?.invoice?:false
			def intermediario =it?.intermediario?.username?it?.intermediario?.username:''
			if(it.favorites?.placeTo?.street){
				placeTo += it.favorites?.placeTo?.street?:""
				placeTo += " "
				placeTo += it.favorites?.placeTo?.streetNumber?:""
			}
			def is_corporate =false
			if (it.user instanceof CorporateUser){
				is_corporate = true
			}
			def jsonBuilder = new groovy.json.JsonBuilder()
			def userOperationLogs = UserOperationLog.findAllByOperation(it)
			def userOperationLogsList = []
			for (userLog in userOperationLogs) {
				def userB = jsonBuilder{
					user_id  userLog.user.id
					email  userLog.user.email
					first_name  userLog.user.firstName
					last_name   userLog.user.lastName
				}
				def code_app   = userLog.code
				def reason_app = userLog.reason
				def status_app = userLog.status
				def userOperationLogBuilder = jsonBuilder{
					user    	    userB
					status    	    status_app
					code    	    code_app
					reason    	    reason_app
					createdDate     utilsApiService.generateFormatedAddressToClient(userLog.createdDate,rtaxi)
				}
				userOperationLogsList.add(userOperationLogBuilder)
			}
			[cell: [
					it.id,
					utilsApiService.generateFormatedAddressToClient(it.createdDate,rtaxi),
					it.user.firstName,
					it.user.lastName,
					driver,
					it.user.phone,
					placeFrom,
					placeTo,
					it.favorites.comments,
					it.stars,
					it.status.toString(),
					it.amount,
					it.user.isFrequent,
					it.dev.toString(),
					placeFromLat,
					placeFromLng,
					messaging,
				    pet,
				    airConditioning,
				    smoker,
				    specialAssistant,
				    luggage,
				    airport,
				    vip,
				    invoice,
					is_corporate,
					intermediario

				], id: it.id,log_operation:userOperationLogsList]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}
	def exportOperationCompanyHistory( params,rtaxi) {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def customers = Operation.createCriteria().list() {
			and{
				eq('company',rtaxi)
				if(  params.searchField.equals("driver_id") && !params.searchString.isEmpty()){
					taxista{
						eq("id", params.long('searchString'))
					}
				}

				if( params?.searchDateFrom &&  !params.searchDateFrom.isEmpty()&& !params.searchDateTo.isEmpty()){

					java.text.SimpleDateFormat fm= new java.text.SimpleDateFormat("dd/MM/yyyy")
					def date_from =  params.searchDateFrom
					def date_to   =  params.searchDateTo
					between('createdDate',fm.parse(date_from),fm.parse(date_to))
				}
			}

			order(sortIndex, sortOrder)
		}

		def jsonCells = customers.collect {
			def piso = it.favorites?.placeFromPso?:''
			def depto= it?.favorites?.placeFromDto?:''
			def driver =it?.taxista?.username?it?.taxista?.username.split('@')[0]:''
			def compania=it?.user?.rtaxi?.companyName?:'DineroTaxi'
			def placeTo=""
			def placeFromLat = it.favorites?.placeFrom?.lat
			def placeFromLng = it.favorites?.placeFrom?.lng
            def placeFrom = it.favorites?.placeFrom?.street
			placeFrom += it.favorites?.placeFrom?.streetNumber?:""
			placeFrom += " " + piso + " " + depto
			placeFrom = placeFrom.replaceAll("null", "")

		    def messaging = it.options?.messaging?:false
		    def pet = it.options?.pet?:false
		    def airConditioning = it.options?.airConditioning?:false
		    def smoker = it.options?.smoker?:false
		    def specialAssistant = it.options?.specialAssistant?:false
		    def luggage = it.options?.luggage?:false
		    def airport = it.options?.airport?:false
		    def vip = it.options?.vip?:false
		    def invoice = it.options?.invoice?:false
			def intermediario =it?.intermediario?.username?it?.intermediario?.username:''
			if(it.favorites?.placeTo?.street){
				placeTo += it.favorites?.placeTo?.street?:""
				placeTo += " "
				placeTo += it.favorites?.placeTo?.streetNumber?:""
			}
			def is_corporate =false
			if (it.user instanceof CorporateUser){
				is_corporate = true
			}
			def jsonBuilder = new groovy.json.JsonBuilder()
			def userOperationLogs = UserOperationLog.findAllByOperation(it)
			def userOperationLogsList = []
			for (userLog in userOperationLogs) {
				def userB = jsonBuilder{
					user_id  userLog.user.id
					email  userLog.user.email
					first_name  userLog.user.firstName
					last_name   userLog.user.lastName
				}
				def userOperationLogBuilder = jsonBuilder{
					user    	    userB
					status    	    userLog.status
					code    	    userLog.code
					createdDate     utilsApiService.generateFormatedAddressToClient(userLog.createdDate,rtaxi)
				}
				userOperationLogsList.add(userOperationLogBuilder)
			}
			[cell: [
					it.id,
					utilsApiService.generateFormatedAddressToClient(it.createdDate,rtaxi),
					it.user.firstName,
					it.user.lastName,
					driver,
					it.user.phone,
					placeFrom,
					placeTo,
					it.favorites.comments,
					it.stars,
					it.status.toString(),
					it.amount,
					it.user.isFrequent,
					it.dev.toString(),
					placeFromLat,
					placeFromLng,
					messaging,
				    pet,
				    airConditioning,
				    smoker,
				    specialAssistant,
				    luggage,
				    airport,
				    vip,
				    invoice,
					is_corporate,
					intermediario

				], id: it.id,log_operation:userOperationLogsList]
		}
		def jsonData= [rows: jsonCells,status:200]
		return jsonData
	}
	def getOperationCompanyScheduleHistory( params,rtaxi) {
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = Integer.valueOf(params.rows?:10)
		def currentPage = Integer.valueOf(params.page?: 1)
		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		if(params.sidx.equals("auto")){
			sortIndex ="taxista"
		}
		def customers = DelayOperation.createCriteria().list(max:maxRows, offset:rowOffset) {
			and{
				eq('company',rtaxi)
				if(  params.searchField.equals("id") && !params.searchString.isEmpty()){
					eq("id", Long.valueOf(params.searchString))
				}
				if(  params.searchField.equals("driver") && !params.searchString.isEmpty()){
					taxista{
						like("email", params.searchString+"%")
					}
				}
				if(  params.searchField.equals("user") && !params.searchString.isEmpty()){
					user{
						like("lastName", params.searchString+"%")
					}
				}
				if(  params.searchField.equals("user_id") && !params.searchString.isEmpty()){
					user{
						eq("id", Long.valueOf(params.searchString))
					}
				}
				if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
					user{
						like("phone", params.searchString+"%")
					}
				}
				if(  params.searchField.equals("driver_id") && !params.searchString.isEmpty()){
					taxista{
						eq("email", params.searchString)
					}
				}
				if( params?.searchDateFrom && !params.searchDateFrom.isEmpty()&& !params.searchDateTo.isEmpty()){

					java.text.SimpleDateFormat fm= new java.text.SimpleDateFormat("dd/MM/yyyy")
					def date_from =  params.searchDateFrom
					def date_to   =  params.searchDateTo
					between('createdDate',fm.parse(date_from),fm.parse(date_to))
				}

			}

			order(sortIndex, sortOrder)
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)

		def jsonCells = customers.collect {
			def piso = it.favorites?.placeFromPso?:''
			def depto= it?.favorites?.placeFromDto?:''
			def driver =it?.taxista?.username?it?.taxista?.username.split('@')[0]:''
			def compania=it?.user?.rtaxi?.companyName?:'DineroTaxi'
			def placeTo=""
			def placeFromLat = it.favorites?.placeFrom?.lat
			def placeFromLng = it.favorites?.placeFrom?.lng
            def placeFrom = it.favorites?.placeFrom?.street
			placeFrom += it.favorites?.placeFrom?.streetNumber?:""
			placeFrom += " " + piso + " " + depto
			placeFrom = placeFrom.replaceAll("null", "")

		    def messaging = it.options?.messaging?:false
		    def pet = it.options?.pet?:false
		    def airConditioning = it.options?.airConditioning?:false
		    def smoker = it.options?.smoker?:false
		    def specialAssistant = it.options?.specialAssistant?:false
		    def luggage = it.options?.luggage?:false
		    def airport = it.options?.airport?:false
		    def vip = it.options?.vip?:false
		    def invoice = it.options?.invoice?:false
			if(it.favorites?.placeTo?.street){
				placeTo += it.favorites?.placeTo?.street?:""
				placeTo += " "
				placeTo += it.favorites?.placeTo?.streetNumber?:""
			}
			def intermediario =it?.intermediario?.username?it?.intermediario?.username:''
			def op_id =it?.operation?.id?it?.operation?.id:''
			def is_corporate =false
			if (it.user instanceof CorporateUser){
				is_corporate = true
			}
			[cell: [
					it.id,
					utilsApiService.generateFormatedAddressToClient(it.createdDate,rtaxi),
					it.user.firstName,
					it.user.lastName,
					driver,
					it.user.phone,
					placeFrom,
					placeTo,
					it.favorites.comments,
					it.status.toString(),
					it.amount,
					it.user.isFrequent,
					it.dev.toString(),
					placeFromLat,
					placeFromLng,
					messaging,
				    pet,
				    airConditioning,
				    smoker,
				    specialAssistant,
				    luggage,
				    airport,
				    vip,
				    invoice,
					is_corporate,
					intermediario,
					op_id

				], id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		return jsonData as JSON
	}

}
