package com.api.technorides

import grails.converters.JSON
import groovy.sql.Sql
import ar.com.goliath.EmployUser
import ar.com.operation.OperationHistory

class TechnoRidesReportService {
	static transactional = true
	def dataSource

	def getReportTx( params,rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
             SELECT count(op.id) trips,usr.email email,DATE_FORMAT(op.created_date,'%m/%Y') month
		     FROM operation op,user usr 
             WHERE usr.id=op.taxista_id and  usr.rtaxi_id =:rtaxi and op.taxista_id is not null
             GROUP BY YEAR(op.created_date), MONTH(op.created_date),op.taxista_id
         ''',[rtaxi:rtaxi.id])
		
		return result
	}
	def getReportTxByMonth(rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
             SELECT count(op.id) trips,DATE_FORMAT(op.created_date,'%m/%Y') month
		     FROM operation op
             WHERE op.company_id =:rtaxi 
             GROUP BY YEAR(op.created_date), MONTH(op.created_date)
         ''',[rtaxi:rtaxi.id])
		
		return result
	}
	def getReportTxByDay( params,rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
			SELECT count(op.id) trips,DATE_FORMAT(op.created_date,'%d/%m/%Y') day
			FROM operation op
			WHERE op.company_id =:rtaxi
			GROUP BY YEAR(op.created_date), MONTH(op.created_date), DAY(op.created_date)
         ''',[rtaxi:rtaxi.id])
		
		return result
	}
	
	def exportReportTx(rtaxi,fromDate,toDate) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
         SELECT count(op.id) trips,usr.email email,DATE_FORMAT(op.created_date,'%m/%Y') month
	     FROM operation op,user usr 
         WHERE usr.id=op.taxista_id and  usr.rtaxi_id =:rtaxi and op.taxista_id is not null
		 and op.created_date BETWEEN :from_date and :to_date
         GROUP BY YEAR(op.created_date), MONTH(op.created_date),op.taxista_id 
		 ORDER BY month DESC
     ''',[rtaxi:rtaxi.id,from_date:fromDate,to_date:toDate])
		
		return result
	}
	def exportReportTxByMonth(rtaxi,fromDate,toDate) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
         SELECT count(op.id) trips,DATE_FORMAT(op.created_date,'%m/%Y') month
	     FROM operation op
         WHERE op.company_id =:rtaxi 
		 and op.created_date BETWEEN :from_date and :to_date
         GROUP BY YEAR(op.created_date), MONTH(op.created_date)
     ''',[rtaxi:rtaxi.id,from_date:fromDate,to_date:toDate])
		
		return result
	}
	def exportReportTxByDay(rtaxi,fromDate,toDate) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
		SELECT count(op.id) trips,DATE_FORMAT(op.created_date,'%d/%m/%Y') day
		FROM operation op
		WHERE op.company_id =:rtaxi
		 and op.created_date BETWEEN :from_date and :to_date
		GROUP BY YEAR(op.created_date), MONTH(op.created_date), DAY(op.created_date)
     ''',[rtaxi:rtaxi.id,from_date:fromDate,to_date:toDate])
		
		return result
	}
	
	
	def exportReportTx( maxMonths,rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
         SELECT count(op.id) trips,usr.email email,DATE_FORMAT(op.created_date,'%m/%Y') month
	     FROM operation op,user usr 
         WHERE usr.id=op.taxista_id and  usr.rtaxi_id =:rtaxi and op.taxista_id is not null
		 and op.created_date BETWEEN DATE_SUB(NOW(), INTERVAL :month MONTH)  and NOW()
         GROUP BY YEAR(op.created_date), MONTH(op.created_date),op.taxista_id 
		 ORDER BY month DESC
     ''',[month:maxMonths, rtaxi:rtaxi.id])
		
		return result
	}
	def exportReportTxByMonth( maxMonths,rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
         SELECT count(op.id) trips,DATE_FORMAT(op.created_date,'%m/%Y') month
	     FROM operation op
         WHERE op.company_id =:rtaxi and op.created_date BETWEEN DATE_SUB(NOW(), INTERVAL :month MONTH)  and NOW()
         GROUP BY YEAR(op.created_date), MONTH(op.created_date)
     ''',[month:maxMonths, rtaxi:rtaxi.id])
		
		return result
	}
	def exportReportTxByDay( maxDays,rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
		SELECT count(op.id) trips,DATE_FORMAT(op.created_date,'%d/%m/%Y') day
		FROM operation op
		WHERE op.company_id =:rtaxi and op.created_date BETWEEN DATE_SUB(NOW(), INTERVAL :days DAY)  and NOW()
		GROUP BY YEAR(op.created_date), MONTH(op.created_date), DAY(op.created_date)
     ''',[days:maxDays, rtaxi:rtaxi.id])
		
		return result
	}
	

	
	def getOperationsHistoryByDriverByDay( params,driver,rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
             SELECT DATE_FORMAT(op.created_date,'%d/%m/%Y') date,count(op.id) trips,sum(op.amount) amount
		     FROM operation op
             WHERE op.taxista_id =:driver and created_date> subdate(current_date, 30) and op.company_id=:company_id
             GROUP BY YEAR(op.created_date), MONTH(op.created_date),DAY(op.created_date)
         ''',[driver:driver.id,company_id:rtaxi.id])
		
		return result
	}
	
	
	def getOperationsHistoryByDriverByMonth( params,driver,rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
             SELECT DATE_FORMAT(op.created_date,'%d/%m/%Y') date,count(op.id) trips,sum(op.amount) amount
		     FROM operation op
             WHERE op.taxista_id =:driver and op.company_id=:company_id
             GROUP BY YEAR(op.created_date), MONTH(op.created_date)
         ''',[driver:driver.id,company_id:rtaxi.id])
		
		return result
	}
	
	def getInconsistentOperations() {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
             select count(op.id) trips,usr.phone,usr.company_name
			from dtax.operation op, dtax.user usr
			where op.created_date BETWEEN DATE_SUB(NOW(), INTERVAL 7 DAY)  and NOW() and usr.id = op.company_id
			and op.company_id in (
				select id from dtax.user
				where class ='ar.com.goliath.Company' and enabled = true and account_locked = false
				)
			group by op.company_id

         ''')
		
		return result
	}
	
	def blockCompanyUsers( Long id_rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.execute('''
            update user set account_locked=true,agree=false,politics=false where
			rtaxi_id = :rtaxi
         ''',[rtaxi:id_rtaxi])
		
	}
	def unblock( Long id_rtaxi) {
		def sql = new Sql(dataSource)
		def result=sql.execute('''
            update user set account_locked=false,agree=true,politics=true,enabled = true where
			rtaxi_id = :rtaxi
         ''',[rtaxi:id_rtaxi])
		
	}
	def exportReportTxByCompanyByWeek( ) {
		def sql = new Sql(dataSource)
		def result=sql.rows('''
             select id as operation_id,cost_center_id from operation where status
				not in ('CANCELED','CANCELED_EMP','CANCELED_DRIVER','CALIFICATED','CANCELTIMETRIP','COMPLETED','SETAMOUNT') and
			  created_date BETWEEN DATE_SUB(NOW(), INTERVAL 365 DAY)  and DATE_SUB(NOW(), INTERVAL 400 MINUTE)
         ''')
		
		return result
	}
}
