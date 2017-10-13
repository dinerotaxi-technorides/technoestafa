package com
import groovy.sql.Sql
import ar.com.operation.OperationHistory
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.goliath.Vehicle
import java.sql.ResultSet
import java.util.Date;

import grails.converters.JSON
import groovy.sql.Sql

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.core.RowCallbackHandler
import org.springframework.jdbc.datasource.DataSourceUtils
import com.admin.TaxiOperationCommand
class MiPanelCompanyService {
	def dataSource
    boolean transactional = true
	def sessionFactory
	
    def getAll( params,userInstance) {
       
		def now = Date.parse("yyyy-MM-dd", "2009-09-15")
		def c = OperationHistory.createCriteria()
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource)
		List<TaxiOperationCommand> l = new ArrayList<TaxiOperationCommand>();
		def query = jdbcTemplate.query("SELECT count(op.id) id,op.last_modified_date lastdate "+
											 "FROM operation op where Date(op.last_modified_date ) " +
												"BETWEEN ? AND ? and op.status='COMPLETED' and op.company_id=? "+
													"group by  YEAR(op.last_modified_date ), MONTH(op.last_modified_date ),DAY(op.last_modified_date )"
													,[ now, new Date(), userInstance.id]as Object[], { ResultSet rs ->
														def c1 = OperationHistory.createCriteria()
														def dat=Date.parse("yyyy-MM-dd",rs.getObject('lastdate').format("yyyy-MM-dd" ))
														def results = c1.count() {
														   and{
															   eq('company', userInstance)
															   between('lastModifiedDate', dat, dat+1)
														   }
													   }
			l.add(new TaxiOperationCommand(rs.getObject('id'),rs.getObject('lastdate'),results,results-rs.getObject('id')))
		} as RowCallbackHandler);

        return l
    }
    def getAllCount( params,userInstance) {
        def c = OperationHistory.createCriteria()
         def results = c.get() {
            and{
				eq('company', userInstance)
            }
                    
            projections{
                count("id")
            }
        }
        return results
    }
}