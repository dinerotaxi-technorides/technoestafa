package com.api.technorides

import grails.converters.JSON
import ar.com.goliath.EmployUser
import ar.com.goliath.PersistToken
import ar.com.goliath.User
import com.api.utils.UtilsApiService

class TechnoRidesReportApiController extends TechnoRidesValidateApiController {
	def technoRidesReportService
	def utilsApiService
	def operationApiService
	def sendGridService
	def technoRidesEmailService
	def springDineroTaxiService
	def springSecurityService
	def rememberMeServices
	def technoRidesOperationService
	def addExcept(list) {
		list <<'get'<< 'create_web_trip'<< 'send_contact_mail'//'index' << 'list' << 'show'
	}
	def get={
		render "asd"
	}
	def jq_report_tx = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def techno= technoRidesReportService.getReportTx(params, rtaxi)
			def result = [rows:techno,status:100]
			render result as JSON
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_report_tx_month = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def techno= technoRidesReportService.getReportTxByMonth(rtaxi)
			def result = [rows:techno,status:100]
			render result as JSON
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def jq_report_tx_day = {
		try{
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			def techno= technoRidesReportService.getReportTxByDay(params, rtaxi)
			def result = [rows:techno,status:100]
			render result as JSON
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def jq_report_driver_ammount = {
		try{
			def tok = PersistToken.findByToken(params?.token)
			def usr = User.findByUsernameAndRtaxi(tok.username, tok?.rtaxi ? User.get(tok.rtaxi) : null)

			def realUser = EmployUser.get(params?.driver_id)

			def rtaxi  = searchRtaxi(usr)
			def techno = null
			def result = []
			if(realUser){
				if(!params?.month){
					techno = technoRidesReportService.getOperationsHistoryByDriverByDay(params, realUser, rtaxi)
					result = [rows:techno,status:100]
					render result as JSON
					return
				}
				techno = technoRidesReportService.getOperationsHistoryByDriverByMonth(params, realUser, rtaxi)
				result = [rows:techno,status:100]
				render result as JSON
				return
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=222 }
			}
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def  export_jq_report_tx = {
		try{
			def month = Integer.valueOf(params.month?:3)
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			if(!params?.fromDate){
				def result = [status:400]
				render result as JSON
				return;
			}
			def fromDate =new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.fromDate)
			def toDate =new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.toDate)
			def techno= technoRidesReportService.exportReportTx(rtaxi,fromDate,toDate)
			print techno
			File file =null;
			file=new File("report.csv");
			if(!file.exists()) {
				file.createNewFile();
			}
			FileWriter report = new FileWriter(file)
			if('es' == usr?.rtaxi?.lang?:'es'){
				report.write(UtilsApiService.translateES("trips,email,month")+"\n")
			}else{
				report.write("trips,email,month"+"\n")
			}
			for (rep in techno) {
				def data = "${rep.trips},${rep.email},${rep.month}"
				report.write(data+"\n")
			}
			report.flush();
			report.close();
			technoRidesEmailService.sendReport(rtaxi, params, file)
//			return file
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def  export_jq_report_tx_month = {
		try{
			def month = Integer.valueOf(params.month?:3)
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			if(!params?.fromDate){
				def result = [status:400]
				render result as JSON
				return;
			}
			def fromDate =new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.fromDate)
			def toDate =new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.toDate)
			def techno= technoRidesReportService.exportReportTxByMonth(rtaxi,fromDate,toDate)
			print techno
			File file =null;
			file=new File("report.csv");
			if(!file.exists()) {
				file.createNewFile();
			}
			FileWriter report = new FileWriter(file);

			if('es' == usr?.rtaxi?.lang?:'es'){
				report.write(UtilsApiService.translateES("trips,month")+"\n")
			}else{
				report.write("trips,month"+"\n")
			}

			for (rep in techno) {
				def data = "${rep.trips},${rep.month}"
//				print data
				report.write(data+"\n")
			}
			report.flush();
			report.close();
			technoRidesEmailService.sendReport(rtaxi, params, file)
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def  export_jq_report_tx_day = {
		try{
			def days = Integer.valueOf(params.days?:30)
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)

			if(!params?.fromDate){
				def result = [status:400]
				render result as JSON
				return;
			}
			def fromDate =new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.fromDate)
			def toDate =new java.text.SimpleDateFormat("dd/MM/yyyy").parse(params.toDate)
			def techno= technoRidesReportService.exportReportTxByDay(rtaxi,fromDate,toDate)
			print techno
			File file =null;
			file=new File("report.csv");
			if(!file.exists()) {
				file.createNewFile();
			}
			FileWriter report = new FileWriter(file);
			if('es' == usr?.rtaxi?.lang?:'es'){
				report.write(UtilsApiService.translateES("trips,day")+"\n")
			}else{
				report.write("trips,day"+"\n")
			}
			for (rep in techno) {
				def data = "${rep.trips},${rep.day}"
				report.write(data+"\n")
			}
			report.flush();
			report.close();
			technoRidesEmailService.sendReport(rtaxi, params, file)
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}

	def export_jq_report_driver_ammount = {
		try{
			def tok = PersistToken.findByToken(params?.token)
			def usr = User.findByUsernameAndRtaxi(tok.username, tok?.rtaxi ? User.get(tok.rtaxi) : null)

			def realUser = EmployUser.get(params?.driver_id)

			def rtaxi  = searchRtaxi(usr)
//			def techno = null
//			def result = []
//			if(realUser){
//				if(!params?.month){
//					techno = technoRidesReportService.getOperationsHistoryByDriverByDay(params, realUser, rtaxi)
//					result = [rows:techno,status:100]
//					render result as JSON
//					return
//				}
//				techno = technoRidesReportService.getOperationsHistoryByDriverByMonth(params, realUser, rtaxi)
//				result = [rows:techno,status:100]
//				render result as JSON
//				return
//			}else{
//				render(contentType:'text/json',encoding:"UTF-8") { status=222 }
//			}
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def  export_company_operation_history = {
		try{
			def days = Integer.valueOf(params.days?:30)
			def tok=PersistToken.findByToken(params?.token)
			def usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
			def rtaxi=searchRtaxi(usr)
			def techno= technoRidesOperationService.exportOperationCompanyHistory(params, rtaxi)
			File file =null;
			file=new File("report.csv");
			if(!file.exists()) {
				file.createNewFile();
			}
			FileWriter report = new FileWriter(file);
			if('es' == usr?.rtaxi?.lang?:'es'){
				report.write(UtilsApiService.translateES("id,date,firstName,lastName,driver,phone,AddressFrom,AddressTo,comments,stars,amount,isPassengerFrequent,userDevice,latAddressFrom,lngAddressFrom,options_messaging,options_pet,options_airConditioning,options_smoker,options_specialAssistant,options_luggage,options_airport,options_vip,options_invoice,isEnterpriseUser,middle_man")+"\n")
			}else{
				report.write("id,date,firstName,lastName,driver,phone,AddressFrom,AddressTo,comments,stars,amount,isPassengerFrequent,userDevice,latAddressFrom,lngAddressFrom,options_messaging,options_pet,options_airConditioning,options_smoker,options_specialAssistant,options_luggage,options_airport,options_vip,options_invoice,isEnterpriseUser,middle_man"+"\n")
			}
			for (rep in techno.rows) {
				String data = ""
				if(rep?.cell)
					data=rep.cell.join(",")
				report.write(data+"\n")
			}
			report.flush();
			report.close();
			technoRidesEmailService.sendReport(rtaxi, params, file)
			render(contentType:'text/json',encoding:"UTF-8") { status=200 }
			return
		}catch (Exception e){
			log.error e.getMessage()
			log.error e.getCause()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}


}
