package com.stadistics

import grails.converters.JSON
import ar.com.goliath.*
import ar.com.operation.*

import com.UserDevice
class StadisticsService {
	def getByDevice() {
		//This Month
		def c = Operation.createCriteria()
		def dateTo =new Date()
		Calendar calendarFrom = Calendar.getInstance();
		calendarFrom.set(Calendar.DAY_OF_MONTH, 1);
		def dateFrom=calendarFrom.getTime()
		def thisMonth = c.list() {
			and{
				between("createdDate", dateFrom,dateTo )
			}

			projections{
				groupProperty('dev')
				count('dev')

			}
		}
		//Past Month
		Calendar cal11 = Calendar.getInstance();
		cal11.set(Calendar.DAY_OF_MONTH, 1);
		cal11.set(Calendar.HOUR, 0);
		cal11.set(Calendar.MINUTE, 0);
		cal11.set(Calendar.MONTH, cal11.get(Calendar.MONTH)-1)
		def dateFromPastMonth=cal11.getTime()
		cal11.set(Calendar.MONTH, cal11.get(Calendar.MONTH)+1)
		cal11.set(Calendar.DAY_OF_MONTH, cal11.get(Calendar.DAY_OF_MONTH)-1)
		def c1= Operation.createCriteria()
		def dateToPastMonth=cal11.getTime()
		def month1 = c1.list() {
			and{
				between("createdDate", dateFromPastMonth,dateToPastMonth )
			}

			projections{
				groupProperty('dev')
				count('dev')

			}
		}
		Calendar calMonth2 = Calendar.getInstance();
		calMonth2.set(Calendar.DAY_OF_MONTH, 1);
		calMonth2.set(Calendar.HOUR, 0);
		calMonth2.set(Calendar.MINUTE, 0);
		calMonth2.set(Calendar.MONTH, calMonth2.get(Calendar.MONTH)-2)
		def dateFromMonth2=calMonth2.getTime()
		calMonth2.set(Calendar.MONTH, calMonth2.get(Calendar.MONTH)+1)
		calMonth2.set(Calendar.DAY_OF_MONTH, calMonth2.get(Calendar.DAY_OF_MONTH)-1)
		def c2= Operation.createCriteria()
		def dateToMonth2=calMonth2.getTime()
		def month2 = c2.list() {
			and{
				between("createdDate", dateFromMonth2,dateToMonth2 )
			}

			projections{
				groupProperty('dev')
				count('dev')

			}
		}
		def countActualMonth=setCount(thisMonth);
		def countMonth1=setCount(month1);
		def countMonth2=setCount(month2);
		def listAndroid=[
			UserDevice.ANDROID,
			countMonth2[0],
			countMonth1[0],
			countActualMonth[0]
		]
		def listIphone=[
			UserDevice.IPHONE,
			countMonth2[1],
			countMonth1[1],
			countActualMonth[1]
		]
		def listBlackBerry=[
			UserDevice.BB,
			countMonth2[2],
			countMonth1[2],
			countActualMonth[2]
		]
		def listWeb=[
			UserDevice.WEB,
			countMonth2[3],
			countMonth1[3],
			countActualMonth[3]
		]
		def listUndefined=[
			UserDevice.UNDEFINDED,
			countMonth2[4],
			countMonth1[4],
			countActualMonth[4]
		]

		def employeeData = [
			listAndroid,
			listIphone,
			listBlackBerry,
			listWeb,
			listUndefined
		]
		return employeeData
	}
	def setCount(month) {
		def devices=[0, 0, 0, 0, 0]
		month.each{
			if(it[0]==UserDevice.ANDROID){
				devices[0]=it[1]
			}else if(it[0]==UserDevice.IPHONE){
				devices[1]=it[1]

			}else if(it[0]==UserDevice.BB){
				devices[2]=it[1]

			}else if(it[0]==UserDevice.WEB){
				devices[3]=it[1]

			}else if(it[0]==UserDevice.UNDEFINDED){
				devices[4]=it[1]

			}

		}
		return devices;

	}

}