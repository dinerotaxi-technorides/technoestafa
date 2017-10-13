
package com.api.technorides.corporate

import grails.converters.JSON
import sun.misc.BASE64Decoder
import ar.com.goliath.Company
import ar.com.goliath.PersistToken
import ar.com.goliath.Role
import ar.com.goliath.User
import ar.com.goliath.corporate.Corporate
import ar.com.goliath.corporate.CorporateUser
import ar.com.goliath.corporate.CostCenter
import ar.com.goliath.corporate.billing.BillingEnterpriseHistory
import ar.com.operation.OperationCompanyHistory
import ar.com.goliath.Looper
class TechnoRidesCorporateUserApiController extends TechnoRidesValidateCorporateApiController {
	def springSecurityService
	def technoRidesCorporateService
	def utilsApiService
	def addExcept(list) {
		list <<'get'<<'dashboard'
	}
	def get={ render "asd" }
	def dashboard = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def corporate_list = Corporate.createCriteria().count() {
			eq('rtaxi',rtaxi)
			eq('visible',true)
		}
		def cost_center = CostCenter.createCriteria().count() {
			eq('rtaxi',rtaxi)
			eq('visible',true)
		}
		Calendar cal = Calendar.getInstance();
		Calendar calTo = Calendar.getInstance();
		def dfd = new java.text.SimpleDateFormat("dd-MM-yyyy");

		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.set( Calendar.HOUR_OF_DAY, 0 );
		cal.set( Calendar.MINUTE, 0 );
		cal.set( Calendar.SECOND, 0 );
		cal.set( Calendar.MILLISECOND, 0 );

		dfd.format(cal.getTime());
		def rides_history = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			between("createdDate",cal.getTime(),calTo.getTime())
		}

		def billing_pending = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('rtaxi',rtaxi)
					eq('visible',true)
				}
				eq('status','PENDING')
			}

			projections { sum('total') }
		}
		billing_pending = billing_pending[0]

		def billing_paid = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('rtaxi',rtaxi)
					eq('visible',true)
				}
				or{
					eq('status','PENDING')
					eq('status','OVERDUE')
					eq('status','PARTIALLY_PAID')
				}
			}

			projections { sum('subTotal') }
			//			between("createdDate",cal.getTime(),calTo.getTime())
		}
		def billing_sub_total = 0
		if( billing_paid[0] !=null)
			billing_sub_total = billing_paid[0]
		def billing_unpaid = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('rtaxi',rtaxi)
					eq('visible',true)
				}
				or{
					eq('status','PENDING')
					eq('status','OVERDUE')
					eq('status','PARTIALLY_PAID')
				}
			}

			projections { sum('total') }
			//			between("createdDate",cal.getTime(),calTo.getTime())
		}
		billing_unpaid = billing_unpaid[0]
		print billing_unpaid
		print billing_sub_total
		def billing_total = 0
		if( billing_unpaid !=null)
			billing_total=billing_unpaid
		def jsonBuilder = new groovy.json.JsonBuilder()
		def montlyBuilder = jsonBuilder{
			"0"     0
			"1"     0
			"2"     0
			"3"     0
			"4"     0
			"5"     0
			"6"     0
			"7"     0
			"8"     0
			"9"     0
			"10"    0
			"11"    0
		}
		def accountsBuilder = jsonBuilder{
			total    	    corporate_list
			enterprises     cost_center
			monthly_rides   rides_history
		}
		def paymentsBuilder = jsonBuilder{
			expected    	      billing_pending
			unpaid                billing_total
			paid                  billing_sub_total-billing_total
			montly_paid_percent   1
		}
		print paymentsBuilder
		def j1 = jsonBuilder{
			monthly montlyBuilder
			accounts accountsBuilder
			payments paymentsBuilder
			status  100
		}
		render j1 as JSON
	}
	def dashboard_user_admin_cost_center = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=CorporateUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)

		def jsonBuilder = new groovy.json.JsonBuilder()

		Calendar cal = Calendar.getInstance();
		Calendar calTo = Calendar.getInstance();
		def dfd = new java.text.SimpleDateFormat("dd-MM-yyyy");

		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.set( Calendar.HOUR_OF_DAY, 0 );
		cal.set( Calendar.MINUTE, 0 );
		cal.set( Calendar.SECOND, 0 );
		cal.set( Calendar.MILLISECOND, 0 );

		def cost_center = CostCenter.get(params.cost_id)
		if(!cost_center || cost_center.rtaxi!=rtaxi){
			render(contentType:'text/json',encoding:"UTF-8") { status=401 }
			return
		}
		dfd.format(cal.getTime());
		def rides_history = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('costCenter',cost_center)
			between("createdDate",cal.getTime(),calTo.getTime())
		}
		def rides_history_total = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('costCenter',cost_center)
		}
		cal.set(Calendar.DAY_OF_MONTH, calTo.get(Calendar.DAY_OF_MONTH)-7);
		def rides_history_week = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('costCenter',cost_center)
			between("createdDate",cal.getTime(),calTo.getTime())
		}

		def operationsBuilder = jsonBuilder{
			lastWeek rides_history_week
			total    rides_history_total
			lastMonth   rides_history
		}

		def billing_unpaid = BillingEnterpriseHistory.createCriteria().list() {
			and{
				eq('costCenter',cost_center)
				or{
					eq('status','PENDING')
					eq('status','OVERDUE')
					eq('status','PARTIALLY_PAID')
				}
			}

			projections { sum('total') }
			//			between("createdDate",cal.getTime(),calTo.getTime())
		}
		billing_unpaid = billing_unpaid[0]?:0

		def billing_total = BillingEnterpriseHistory.createCriteria().list() {
			and{
				eq('costCenter',cost_center)
			}

			projections { sum('total') }
		}
		billing_total = billing_total[0]?:0
		def billing_paid = BillingEnterpriseHistory.createCriteria().list() {
			and{
				eq('costCenter',cost_center)
				eq('status','PAID')
			}

			projections { sum('total') }
		}
		billing_paid = billing_paid[0]?:0

		def paymentsBuilder = jsonBuilder{
			toPay billing_unpaid
			total  billing_total
			paid   billing_paid
		}
		def operations_by_time_n = jsonBuilder{
			label "Night"
			value 12
		}
		def operations_by_time_m = jsonBuilder{
			label "Midday"
			value 20
		}
		def operations_by_time_mn = jsonBuilder{
			label "Morning"
			value 20
		}
		def operations_by_time_a = jsonBuilder{
			label "Afternoon"
			value 10
		}
		Calendar calMontly = Calendar.getInstance();
		Calendar calMontlyTo = Calendar.getInstance();

		calMontly.set(Calendar.DAY_OF_MONTH, 1);
		calMontly.set( Calendar.HOUR_OF_DAY, 0 );
		calMontly.set( Calendar.MINUTE, 0 );
		calMontly.set( Calendar.SECOND, 0 );
		calMontly.set( Calendar.MILLISECOND, 0 );

		calMontlyTo.set( Calendar.HOUR_OF_DAY, 0 );
		calMontlyTo.set( Calendar.MINUTE, 0 );
		calMontlyTo.set( Calendar.SECOND, 0 );
		calMontlyTo.set( Calendar.MILLISECOND, 0 );
		int i = 0
		def montly_data = []
		Looper.loop {
		   calMontly.set(Calendar.MONTH, i)
		   calMontlyTo.set(Calendar.MONTH, i)

		   calMontlyTo.set( Calendar.DAY_OF_MONTH, calMontlyTo.getActualMaximum(Calendar.DAY_OF_MONTH) );
		   def billing = BillingEnterpriseHistory.createCriteria().list() {
			   and{
				   eq('costCenter',cost_center)
				   between("createdDate",calMontly.getTime(),calMontlyTo.getTime())
			   }

			   projections { sum('total') }
		   }
		   billing = billing[0]?:0
		   montly_data.add(["${i}":billing])
		   i += 1
		} until { i > 11 }

		def operationByTime = [operations_by_time_n, operations_by_time_m, operations_by_time_mn, operations_by_time_a]
		def j1 = jsonBuilder{
			payments paymentsBuilder
			operations operationsBuilder
			operations_by_time operationByTime
			expenses_by_month montly_data
			status  100
		}
		render j1 as JSON
	}

	def dashboard_user_admin_corporate = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=CorporateUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)

		def jsonBuilder = new groovy.json.JsonBuilder()

		Calendar cal = Calendar.getInstance();
		Calendar calTo = Calendar.getInstance();
		def dfd = new java.text.SimpleDateFormat("dd-MM-yyyy");

		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.set( Calendar.HOUR_OF_DAY, 0 );
		cal.set( Calendar.MINUTE, 0 );
		cal.set( Calendar.SECOND, 0 );
		cal.set( Calendar.MILLISECOND, 0 );

		def corporate = Corporate.get(params.corporate_id)
		if(!corporate || corporate.rtaxi!=rtaxi){
			render(contentType:'text/json',encoding:"UTF-8") { status=401 }
			return
		}
		dfd.format(cal.getTime());
		def rides_history = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('corporate',corporate)
			between("createdDate",cal.getTime(),calTo.getTime())
		}
		def rides_history_total = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('corporate',corporate)
		}
		cal.set(Calendar.DAY_OF_MONTH, calTo.get(Calendar.DAY_OF_MONTH)-7);
		def rides_history_week = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('corporate',corporate)
			between("createdDate",cal.getTime(),calTo.getTime())
		}

		def operationsBuilder = jsonBuilder{
			lastWeek rides_history_week
			total    rides_history_total
			lastMonth   rides_history
		}

		def billing_unpaid = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('corporate',corporate)
				}
				or{
					eq('status','PENDING')
					eq('status','OVERDUE')
					eq('status','PARTIALLY_PAID')
				}
			}

			projections { sum('total') }
			//			between("createdDate",cal.getTime(),calTo.getTime())
		}
		billing_unpaid = billing_unpaid[0]?:0

		def billing_total = BillingEnterpriseHistory.createCriteria().list() {
			and{

				costCenter{
					eq('corporate',corporate)
				}
			}

			projections { sum('total') }
		}
		billing_total = billing_total[0]?:0
		def billing_paid = BillingEnterpriseHistory.createCriteria().list() {
			and{

				costCenter{
					eq('corporate',corporate)
				}
				eq('status','PAID')
			}

			projections { sum('total') }
		}
		billing_paid = billing_paid[0]?:0

		def paymentsBuilder = jsonBuilder{
			toPay billing_unpaid
			total  billing_total
			paid   billing_paid
		}
		def operations_by_time_n = jsonBuilder{
			label "Night"
			value 12
		}
		def operations_by_time_m = jsonBuilder{
			label "Midday"
			value 20
		}
		def operations_by_time_mn = jsonBuilder{
			label "Morning"
			value 20
		}
		def operations_by_time_a = jsonBuilder{
			label "Afternoon"
			value 10
		}
		Calendar calMontly = Calendar.getInstance();
		Calendar calMontlyTo = Calendar.getInstance();

		calMontly.set(Calendar.DAY_OF_MONTH, 1);
		calMontly.set( Calendar.HOUR_OF_DAY, 0 );
		calMontly.set( Calendar.MINUTE, 0 );
		calMontly.set( Calendar.SECOND, 0 );
		calMontly.set( Calendar.MILLISECOND, 0 );

		calMontlyTo.set( Calendar.HOUR_OF_DAY, 0 );
		calMontlyTo.set( Calendar.MINUTE, 0 );
		calMontlyTo.set( Calendar.SECOND, 0 );
		calMontlyTo.set( Calendar.MILLISECOND, 0 );
		int i = 0
		def montly_data = []
		Looper.loop {
		   calMontly.set(Calendar.MONTH, i)
		   calMontlyTo.set(Calendar.MONTH, i)

		   calMontlyTo.set( Calendar.DAY_OF_MONTH, calMontlyTo.getActualMaximum(Calendar.DAY_OF_MONTH) );
		   def billing = BillingEnterpriseHistory.createCriteria().list() {
			   and{

					costCenter{
						eq('corporate',corporate)
					}
				   between("createdDate",calMontly.getTime(),calMontlyTo.getTime())
			   }

			   projections { sum('total') }
		   }
		   billing = billing[0]?:0
		   montly_data.add(["${i}":billing])
		   i += 1
		} until { i > 11 }

		def operationByTime = [operations_by_time_n, operations_by_time_m, operations_by_time_mn, operations_by_time_a]
		def j1 = jsonBuilder{
			payments paymentsBuilder
			operations operationsBuilder
			operations_by_time operationByTime
			expenses_by_month montly_data
			status  100
		}
		render j1 as JSON
	}
	def dashboard_user_admin = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=CorporateUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)

		def jsonBuilder = new groovy.json.JsonBuilder()

		Calendar cal = Calendar.getInstance();
		Calendar calTo = Calendar.getInstance();
		def dfd = new java.text.SimpleDateFormat("dd-MM-yyyy");

		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.set( Calendar.HOUR_OF_DAY, 0 );
		cal.set( Calendar.MINUTE, 0 );
		cal.set( Calendar.SECOND, 0 );
		cal.set( Calendar.MILLISECOND, 0 );

		dfd.format(cal.getTime());
		def rides_history = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('corporate',usr.costCenter.corporate)
			between("createdDate",cal.getTime(),calTo.getTime())
		}
		def rides_history_total = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('corporate',usr.costCenter.corporate)
		}
		cal.set(Calendar.DAY_OF_MONTH, calTo.get(Calendar.DAY_OF_MONTH)-7);
		def rides_history_week = OperationCompanyHistory.createCriteria().count() {
			eq('company',rtaxi)
			eq('corporate',usr.costCenter.corporate)
			between("createdDate",cal.getTime(),calTo.getTime())
		}

		def operationsBuilder = jsonBuilder{
			lastWeek rides_history_week
			total    rides_history_total
			lastMonth   rides_history
		}

		def billing_unpaid = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('rtaxi',rtaxi)
					eq('visible',true)
				}
				or{
					eq('status','PENDING')
					eq('status','OVERDUE')
					eq('status','PARTIALLY_PAID')
				}
			}

			projections { sum('total') }
			//			between("createdDate",cal.getTime(),calTo.getTime())
		}
		billing_unpaid = billing_unpaid[0]?:0

		def billing_total = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('rtaxi',rtaxi)
					eq('visible',true)
				}
			}

			projections { sum('total') }
		}
		billing_total = billing_total[0]?:0
		def billing_paid = BillingEnterpriseHistory.createCriteria().list() {
			and{
				costCenter{
					eq('rtaxi',rtaxi)
					eq('visible',true)
				}
				eq('status','PAID')
			}

			projections { sum('total') }
		}
		billing_paid = billing_paid[0]?:0

		def paymentsBuilder = jsonBuilder{
			toPay billing_unpaid
			total  billing_total
			paid   billing_paid
		}
		def operations_by_time_n = jsonBuilder{
			label "Night"
			value 12
		}
		def operations_by_time_m = jsonBuilder{
			label "Midday"
			value 20
		}
		def operations_by_time_mn = jsonBuilder{
			label "Morning"
			value 20
		}
		def operations_by_time_a = jsonBuilder{
			label "Afternoon"
			value 10
		}
		Calendar calMontly = Calendar.getInstance();
		Calendar calMontlyTo = Calendar.getInstance();

		calMontly.set(Calendar.DAY_OF_MONTH, 1);
		calMontly.set( Calendar.HOUR_OF_DAY, 0 );
		calMontly.set( Calendar.MINUTE, 0 );
		calMontly.set( Calendar.SECOND, 0 );
		calMontly.set( Calendar.MILLISECOND, 0 );

		calMontlyTo.set( Calendar.HOUR_OF_DAY, 0 );
		calMontlyTo.set( Calendar.MINUTE, 0 );
		calMontlyTo.set( Calendar.SECOND, 0 );
		calMontlyTo.set( Calendar.MILLISECOND, 0 );
		int i = 0
		def montly_data = []
		Looper.loop {
		   calMontly.set(Calendar.MONTH, i)
		   calMontlyTo.set(Calendar.MONTH, i)

		   calMontlyTo.set( Calendar.DAY_OF_MONTH, calMontlyTo.getActualMaximum(Calendar.DAY_OF_MONTH) );
		   def billing = BillingEnterpriseHistory.createCriteria().list() {
			   and{
				   costCenter{
					   eq('rtaxi',rtaxi)
					   eq('visible',true)
				   }
				   between("createdDate",calMontly.getTime(),calMontlyTo.getTime())
			   }

			   projections { sum('total') }
		   }
		   billing = billing[0]?:0
		   montly_data.add(["${i}":billing])
		   i += 1
		} until { i > 11 }

		def operationByTime = [operations_by_time_n, operations_by_time_m, operations_by_time_mn, operations_by_time_a]
		def j1 = jsonBuilder{
			payments paymentsBuilder
			operations operationsBuilder
			operations_by_time operationByTime
			expenses_by_month montly_data
			status  100
		}
		render j1 as JSON
	}
	def cost_center_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)

			def corporate = Corporate.get(params.id)
			if (corporate && corporate.rtaxi == rtaxi) {
				def customers=technoRidesCorporateService.editCostCenter( params, rtaxi)
				render customers.toString()
				return
			}else{

				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def cost_center_list = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def corporate = Corporate.get(params.corporate_id)
		def costCenter = CostCenter.get(params.cost_center_id)
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1

		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def customers = CostCenter.createCriteria().list(max:maxRows, offset:rowOffset) {
			if( params.searchString && params.searchField.equals("name") ){
				if(params.searchOper.equals("eq"))
					eq("name", params.searchString)
				if(params.searchOper.equals("like"))
					ilike("name", params.searchString+"%")
			}
			if(params.searchString &&  params.searchField.equals("id")){
				eq("id",params.long("searchString"))
			}

			eq('corporate',corporate)
			eq('visible',true)
			eq('rtaxi',rtaxi)
			// set the order and direction
			order(sortIndex, sortOrder)
		}

		def metrics = []
		if(costCenter)
			metrics = technoRidesCorporateService.getMetricsByCostCenter(costCenter)

		def totalRows = customers.totalCount

		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			def costCenterId = CostCenter.get(it.id)
			def metrics_c = technoRidesCorporateService.getMetricsByCostCenter(costCenterId)
			print metrics_c
			[cell: [it.name,it.phone,it.legalAddress], id: it.id,metrics:metrics_c]
		}
		def jsonData= [
			rows: jsonCells,
			page:currentPage,
			records:totalRows,
			total:numberOfPages,
			status:100,

			settings:metrics
		]
		render jsonData as JSON
	}


	def corporate_view_list = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)

		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1

		def corporate_u = Corporate.get(params.corporate_id)
		def metrics = []
		if(corporate_u)
			metrics = technoRidesCorporateService.getMetricsByCorporate(corporate_u)

		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def corporate = Corporate.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(params?.searchString &&  params.searchField.equals("name") ){
				if(params.searchOper.equals("eq"))
					eq("name", params.searchString)
				if(params.searchOper.equals("like"))
					ilike("name", params.searchString+"%")
			}
			if(  params?.searchString && params.searchField.equals("id")){
				eq("id",params.long("searchString"))
			}


			eq('rtaxi',rtaxi)
			eq('visible',true)
			// set the order and direction
			order(sortIndex, sortOrder)
		}

		def totalRows = corporate.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = corporate.collect {
			[cell: [
					name:it.name,
					phone:it.phone,
					phone1:it.phone1,
					cuit:it.cuit,
					discount:it.discount,
					legalAddress:it.legalAddress,
					settings:metrics

				], id: it.id]
		}
		def jsonData= [
			rows: jsonCells,
			page:currentPage,
			records:totalRows,
			total:numberOfPages,
			status:100
		]
		render jsonData as JSON
	}

	def corporate_list = {
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)

		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1


		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows

		def corporate = Corporate.createCriteria().list(max:maxRows, offset:rowOffset) {
			if(params?.searchString &&  params.searchField.equals("name") ){
				if(params.searchOper.equals("eq"))
					eq("name", params.searchString)
				if(params.searchOper.equals("like"))
					ilike("name", params.searchString+"%")
			}
			if(  params?.searchString && params.searchField.equals("id")){
				eq("id",params.long("searchString"))
			}


			eq('rtaxi',rtaxi)
			eq('visible',true)
			// set the order and direction
			order(sortIndex, sortOrder)
		}

		def totalRows = corporate.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = corporate.collect {

			def corporate_u = Corporate.get(it.id)
			def metrics = []
			if(corporate_u)
				metrics = technoRidesCorporateService.getMetricsByCorporate(corporate_u)
			[cell: [
					name:it.name,
					phone:it.phone,
					phone1:it.phone1,
					cuit:it.cuit,
					legalAddress:it.legalAddress

				], id: it.id,metrics:metrics]
		}
		def jsonData= [
			rows: jsonCells,
			page:currentPage,
			records:totalRows,
			total:numberOfPages,
			status:100
		]
		render jsonData as JSON
	}

	def corporate_edit = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def customers=technoRidesCorporateService.editCorporate( params, rtaxi)
			render customers.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_corporate_user_edit = {

		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def companyRole=Role.findByAuthority("ROLE_COMPANY")
			if(!usr.authorities.contains(companyRole) ){
				render(contentType:'text/json',encoding:"UTF-8") { status=12 }
				return
			}
			def rtaxi=searchRtaxi(usr)
			def customers=technoRidesCorporateService.createOrEditCorporate( params, rtaxi,true,usr)
			render customers.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_admin_corporate_user_edit = {

		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=CorporateUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			if(!usr){
				render(contentType:'text/json',encoding:"UTF-8") { status=11 }
				return
			}
			def rtaxi=searchRtaxi(usr)
			print usr as JSON
			def customers=technoRidesCorporateService.createOrEditCorporate( params, rtaxi, usr.corporateSuperUser, usr)
			render customers.toString()
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def user_corporate_metrics = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=CorporateUser.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def usr_r = CorporateUser.get(params.user_id)

			if(!usr){
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
				return
			}
			if(!usr_r){
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				return
			}
			if(usr_r.costCenter != usr.costCenter){
				render(contentType:'text/json',encoding:"UTF-8") { status=3 }
				return
			}
			def metrics = technoRidesCorporateService.getMetricsByUserCorporate(usr_r)
			render(contentType:'text/json',encoding:"UTF-8") {
				status=200
				user_metrics = metrics
			}
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_corporate_user_list = {
		if(!params?.id_cost){
			response.setStatus(400)
			render(contentType: 'text/json',encoding:"UTF-8") { status=400 }
			return false
		}
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

		def rtaxi=searchRtaxi(usr)
		def costCenter = CostCenter.get(params.id_cost)
		def sortIndex = params.sidx ?: 'id'
		def sortOrder  = params.sord ?: 'desc'
		def maxRows = params?.rows?Integer.valueOf(params.rows):10
		def currentPage =params?.page? Integer.valueOf(params.page):1

		def rowOffset = currentPage == 1 ? 0 : (currentPage - 1) * maxRows
		def customers = CorporateUser.createCriteria().list(max:maxRows, offset:rowOffset) {
			eq('rtaxi', rtaxi)
			eq('costCenter',costCenter)
			if(  params.searchField.equals("id") && !params.searchString.isEmpty()){
				eq("id", params.long("searchString"))
			}
			if(  params.searchField.equals("username") && !params.searchString.isEmpty()){
				ilike("username", params.searchString+"%")
			}
			if(  params.searchField.equals("firstName") && !params.searchString.isEmpty()){
				ilike("firstName", params.searchString+"%")
			}
			if(  params.searchField.equals("firstName") && !params.searchString.isEmpty()){
				ilike("lastName", params.searchString+"%")
			}
			if(  params.searchField.equals("phone") && !params.searchString.isEmpty()){
				ilike("phone", params.searchString+"%")
			}
			if( params?.filter && params.filter.equals("active")){

				eq("accountLocked",false)
			}
			if( params?.filter && params.filter.equals("blocked")){

				eq("accountLocked",true)
			}
			if( params?.search && !params.search.isEmpty()){

				or{
					ilike("phone", params.search+"%")
					ilike("username", params.search+"%")
					ilike("firstName", params.search+"%")
					ilike("lastName", params.search+"%")
				}
			}
			// set the order and direction
			for (sortI in sortIndex.split (",")) {
				order(sortI, sortOrder)

			}
		}
		def totalRows = customers.totalCount
		def numberOfPages = Math.ceil(totalRows / maxRows)
		def jsonCells = customers.collect {
			[cell: [it.username, "****", it.firstName, it.lastName, it.phone, it.admin, it.accountLocked, it.corporateSuperUser],id: it.id]
		}
		def jsonData= [rows: jsonCells,page:currentPage,records:totalRows,total:numberOfPages,status:100]
		render jsonData as JSON
	}
	def jq_corporate_user_activate={
		def tok=PersistToken.findByToken(params?.token)
		def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
		def rtaxi=searchRtaxi(usr)
		try {
			def customer = CorporateUser.get(params.user_id)
			if(customer.rtaxi==rtaxi){
				customer.enabled =!customer.enabled
				customer.accountLocked =!customer.enabled
				if (! customer.hasErrors() && customer.save(flush:true)) {
					render(contentType:'text/json',encoding:"UTF-8") {
						status = 100
						enabled = !customer.enabled
					}
				} else {
					customer.errors.each { println it }
					message = "customer.error.not.updated"
					render(contentType:'text/json',encoding:"UTF-8") { status=400 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=400 }
			}
		} catch (Exception e) {
			print e.stackTrace
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def upload_logo_croped={
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)

			def rtaxi=searchRtaxi(usr)
			def corporate=Corporate.get(params?.id)
			if(usr && corporate){
				corporate.logotype=((byte[]) decodeToImage(params.image))
				corporate.save()
				render(contentType:'text/json',encoding:"UTF-8") { status=100 }
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=2 }
			}
		}catch (Exception e){
			log.error e.getCause()
			log.error e.getMessage()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def display_logo = {
		def profile=Corporate.get(params.long('id'))
		if(!profile?.logotype){
			render(contentType:'text/json',encoding:"UTF-8") { status=5 }
			return false;
		}
		try {

			response.contentType = "image/jpeg"
			if(profile?.logotype){
				response.contentLength = profile?.logotype?.length?:0
				response.outputStream.write(profile?.logotype)
			}
		} catch (Exception e) {
			e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=6 }
		}
	}

	public static byte[] decodeToImage(String imageString) {

		byte[] imageByte;
		try {
			BASE64Decoder decoder = new BASE64Decoder();
			imageByte = decoder.decodeBuffer(imageString);
			ByteArrayInputStream bis = new ByteArrayInputStream(imageByte);
			bis.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return imageByte;
	}
}
