package com

import groovy.sql.Sql
import ar.com.operation.OperationHistory
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.goliath.Vehicle
import java.sql.ResultSet
import groovy.sql.Sql

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.core.RowCallbackHandler
import org.springframework.jdbc.datasource.DataSourceUtils
import com.admin.TaxiOperationCommand
class MiPanelTaxistaService {
	def dataSource
    boolean transactional = true
	def sessionFactory
	
    def getAll( params,userInstance) {
       
		def now = Date.parse("yyyy-MM-dd", "2009-09-15")
		def c = OperationHistory.createCriteria()
		def results = c.list([offset:params.offset,max:params.max]){
		   and{
				eq('taxista', userInstance)
				eq('status', TRANSACTIONSTATUS.COMPLETED)
				between("lastModifiedDate",now,new Date())
		   }
	   }
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource)
		List<TaxiOperationCommand> l = new ArrayList<TaxiOperationCommand>();
		def query = jdbcTemplate.query("SELECT count(op.id) id,op.last_modified_date lastdate "+
											 "FROM operation op where Date(op.last_modified_date ) " +
												"BETWEEN ? AND ? and op.status='COMPLETED' and op.taxista_id=? "+
													"group by  YEAR(op.created_date ), MONTH(op.created_date ),DAY(op.created_date )"
													,[ now, new Date(), userInstance.id]as Object[], { ResultSet rs ->
			l.add(new TaxiOperationCommand(rs.getObject('id'),rs.getObject('lastdate')))
		} as RowCallbackHandler);
		

        return l 
    }
    def getAllCount( params,userInstance) {
        def c = OperationHistory.createCriteria()
         def results = c.get() {
            and{
                 eq('taxista', userInstance)
            }
                    
            projections{
                count("id")
            }
        }
        return results
    }
}