package com.page.admin
import grails.converters.JSON
import groovy.sql.Sql
import ar.com.goliath.*
import ar.com.operation.OnlineRadioTaxi
import ar.com.operation.TrackOnlineRadioTaxi

import com.UserDevice
class HomeAdminController {
	def springSecurityService
	def placeService
	def stadisticsService
	
	def dataSource
	def index = { redirect action:'comoFunciona' }
	def contact={
	}
	def termsAndConditions={
	}
	def saveContact={
		def contact = new Contact(params)
		def us=springSecurityService.currentUser
		us.attach()
		if(us instanceof FacebookUser){
			contact.email=us.user.email
			contact.firstName=us.user.firstName
			contact.lastName=us.user.lastName
			contact.phone=us.user.phone
		}else{
			contact.email=us.email
			contact.firstName=us.firstName
			contact.lastName=us.lastName
			contact.phone=us.phone
		}
		if (!contact.save(flush: true)) {
			render(view: "contact", model: [contact: contact])
			return
		}
		redirect(action: "contactShow")
	}
	def contactShow={
	}
	def example = {
		def sql = new Sql(dataSource)
		def result=sql.rows("SELECT COUNT(o.id) CantPedidos, DATE(o.created_date) FechaPedido FROM operation o where o.is_test_user = 0 GROUP BY FechaPedido")
		
		[ temp:result  ]
	}
	
	def rees ={
		def c = TrackOnlineRadioTaxi.createCriteria()
		def dateTo =new Date()
		Calendar calendarFrom = Calendar.getInstance();
		calendarFrom.set(Calendar.MONTH, calendarFrom.get(Calendar.MONTH)-1)
		def dateFrom=calendarFrom.getTime()
		def date1= dateFrom.format("dd/MM")
		def thisMonth = c.list() {
			and{
				between("createdDate", dateFrom,dateTo )
			}

		}
		def onlineRt=OnlineRadioTaxi.list()

		onlineRt.each{

		}

		def data=[
			[
				'Day',
				'Sutaxi',
				'Amistax'
			],
			[date1, 1000, 400],
			['2005', 1170, 460],
			['2006', 660, 1120],
			[
				'2007',
				1030,
				540]
		]
		render data as JSON
	}
	def pedir = {
	}
	def comoFunciona={
		//		RealUser.findAllByUsrDevice(null).each{
		//			it.usrDevice=UserDevice.UNDEFINDED
		//			it.save(flush:true)
		//		}
		def undef=RealUser.countByUsrDevice(UserDevice.UNDEFINDED)
		def android=RealUser.countByUsrDevice(UserDevice.ANDROID)
		def iphone=RealUser.countByUsrDevice(UserDevice.IPHONE)
		def bb=RealUser.countByUsrDevice(UserDevice.BB)
		def web=RealUser.countByUsrDevice(UserDevice.WEB)
		def myDailyActivitiesColumns = [
			['string', 'Task'],
			[
				'number',
				'Hours per Day']
		]
		def myDailyActivitiesData = [
			['Android', android],
			['Iphone', iphone],
			['BlackBerry', bb],
			['Web', web],
			['Undefined', undef]
		]



		def employeeColumns = [
			['string', 'Type'],
			['string', 'Month 1'],
			['string', 'Month 2'],
			['string', 'Actual']
		]
		def sql = new Sql(dataSource)
		def reqdColName = "CantPedidos,FechaPedido"
		
		def pedidosporfecha = []
		
		def pedidosporfechaColumns = [
			['string', 'CantPedidos'],
			['string', 'FechaPedido']
		]
		sql.rows("SELECT COUNT(o.id) CantPedidos, DATE(o.created_date) FechaPedido FROM operation o where o.is_test_user = 0 GROUP BY FechaPedido").each{ row ->
		  
        pedidosporfecha << [row[0],row[1]]
		}
		
		def pedidosporusuarioColumns = [
			['string', 'CantPedidos'],
			['string', 'username'],
			['string', 'first_name'],
			['string', 'last_name']
		]
		def pedidosporusuario=[]
		sql.rows("SELECT COUNT(o.id) CantPedidos, u.username, u.first_name, u.last_name FROM operation o, user u  where o.is_test_user = 0 and o.user_id = u.id GROUP BY user_id").each{ row ->
			pedidosporusuario << [row[0],row[1],row[2],row[3]]
		}
		
		def pedidosporusuarioporfechaColumns = [
			['string', 'CantPedidos'],
			['string', 'username'],
			['string', 'FechaPedido']
		]
		def pedidosporusuarioporfecha=[]
		sql.rows("SELECT COUNT(o.id) CantPedidos, u.username, DATE(o.created_date) FechaPedido FROM operation o, user u  where o.is_test_user = 0 and o.user_id = u.id GROUP BY user_id, FechaPedido").each{ row ->
			pedidosporusuarioporfecha << [row[0],row[1],row[2]]
		}
		def pedidospordispositivoColumns = [
			['string', 'CantPedidos'],
			['string', 'dev']
		]
		
			def pedidospordispositivo=[]
		sql.rows("SELECT COUNT(o.id) CantPedidos, o.dev FROM operation o where o.is_test_user = 0 GROUP BY dev").each{ row ->
		 pedidospordispositivo << [row[0],row[1]]
		}
		def pedidospordispositivoporfechaColumns = [
			['string', 'CantPedidos'],
			['string', 'dev'],
			['string', 'FechaPedido']
		]
		def pedidospordispositivoporfecha=[]
		sql.rows("SELECT COUNT(o.id) CantPedidos, o.dev, DATE(o.created_date) FechaPedido FROM operation o where o.is_test_user = 0 GROUP BY dev, FechaPedido").each{ row ->
		 pedidospordispositivoporfecha << [row[0],row[1],row[2]]
		}
		def cantidadusuariosnuevospordiaColumns = [
			['string', 'CantPedidos'],
			['string', 'DateOnly']
		]
		def cantidadusuariosnuevospordia=[]
		sql.rows("SELECT COUNT(id), DATE(created_date) DateOnly FROM user GROUP BY DateOnly").each{ row ->
		 cantidadusuariosnuevospordia << [row[0],row[1]]
		}
		def cantidadusuariosnuevospordiaplataformaColumns = [
			['string', 'CantPedidos'],
			['string', 'DateOnly'],
			['string', 'usr_device']
		]
		def cantidadusuariosnuevospordiaplataforma=[]
		sql.rows("SELECT COUNT(id), DATE(created_date) DateOnly, usr_device FROM user GROUP BY DateOnly, usr_device").each{ row ->
			cantidadusuariosnuevospordiaplataforma << [row[0],row[1],row[2]]
		}
		def cantidadpedidospormesColumns = [
			['string', 'Anio'],
			['string', 'Mes'],
			['string', 'CantPedidos']
		]
		def cantidadpedidospormes=[]
		sql.rows("SELECT Year(o.created_date) as Anio, Month(o.created_date) as Mes, COUNT(o.id) as CantPedidos FROM operation o where o.is_test_user = 0 GROUP BY Year(o.created_date), Month(o.created_date)").each{ row ->
			cantidadpedidospormes << [row[0],row[1],row[2]]
		}
		
		
		
		
		
		[
			myDailyActivitiesColumns:myDailyActivitiesColumns,
			myDailyActivitiesData:myDailyActivitiesData
			,employeeColumns:employeeColumns,employeeData:stadisticsService.getByDevice()
			,pedidosporfecha:pedidosporfecha,pedidosporfechaColumns:pedidosporfechaColumns
			,pedidosporusuario:pedidosporusuario,pedidosporusuarioColumns:pedidosporusuarioColumns
			,pedidosporusuarioporfecha:pedidosporusuarioporfecha,pedidosporusuarioporfechaColumns:pedidosporusuarioporfechaColumns
			,pedidospordispositivo:pedidospordispositivo,pedidospordispositivoColumns:pedidospordispositivoColumns
			,pedidospordispositivoporfecha:pedidospordispositivoporfecha,pedidospordispositivoporfechaColumns:pedidospordispositivoporfechaColumns
		    ,cantidadusuariosnuevospordia:cantidadusuariosnuevospordia,cantidadusuariosnuevospordiaColumns:cantidadusuariosnuevospordiaColumns
			,cantidadusuariosnuevospordiaplataforma:cantidadusuariosnuevospordiaplataforma,cantidadusuariosnuevospordiaplataformaColumns:cantidadusuariosnuevospordiaplataformaColumns
			,cantidadpedidospormesColumns:cantidadpedidospormesColumns,cantidadpedidospormes:cantidadpedidospormes
		]
	}
	def comoUsarlo={
	}
	def nosotros = {
	}
	def queEs = {
	}
	def beneficios = {
	}
	def ayuda = {
	}
	def complete={
	}
}