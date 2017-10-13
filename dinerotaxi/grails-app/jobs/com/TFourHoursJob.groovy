package com

import org.codehaus.groovy.grails.commons.ConfigurationHolder

import ar.com.operation.*

class TFourHoursJob {
	def timeout = 1000*60*60*24 // execute job once in 24HOURS
	/**
	 * Es Frecuente el usuario?
	 * Este Job se encarga de determinar si lo es. una vez por dia
	 * @return
	 */
	def technoRidesReportService
	def technoRidesEmailService
	def execute() {
		print "TFourHoursJob"
		
		Calendar c = Calendar.getInstance();
		if(c.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY){
			print "INNNN"
			print c.get(Calendar.DAY_OF_WEEK)
			def techno= technoRidesReportService.exportReportTxByCompanyByWeek()
			File file =null;
			file=new File("report.csv");
			if(!file.exists()) {
				file.createNewFile();
			}
			FileWriter report = new FileWriter(file);
			for (rep in techno) {
				def data = "${rep.trips},${rep.phone},${rep.company_name}"
//				print data
				report.write(data+"\n")
			}
			report.flush();
			report.close();
			technoRidesEmailService.sendInternalReport( file)
		}
		def config = ConfigurationHolder.config
		if(config.run_job){
			Operation.withTransaction {
				def op=Operation.createCriteria()
				def d1=new Date()
				d1.setMinutes(d1.minutes-16)
				def results = op.list() {
					projections {
						groupProperty("user")
						rowCount()
					}
					and{
						or{
							eq('status',TRANSACTIONSTATUS.COMPLETED)
							eq('status',TRANSACTIONSTATUS.CALIFICATED)
						}
					}
				}
				results.each{oper ->
					if( oper[1]>2){
						oper[0].isFrequent=true
						oper[0].countTripsCompleted=oper[1]
						oper[0].save(flush:true)
					}else{
						oper[0].countTripsCompleted=oper[1]
						oper[0].save(flush:true)
					}
				}
	
			}
		}
	}
}
