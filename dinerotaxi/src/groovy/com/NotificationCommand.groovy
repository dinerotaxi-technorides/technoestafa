package com

import java.util.Date;
import ar.com.operation.Operation
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.goliath.User;
import  ar.com.goliath.Vehicle
import  ar.com.goliath.Company
import org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib
import ar.com.notification.OnlineNotification;

class NotificationCommand {
	// asunto para enviar la push
	String subject;
	// mensaje para enviar la push
	String message;
	String taxiNumber;
	Long id
	boolean isRead;

	Date createdDate
	Long opId
	TripCommand trip
	NotificationCommand(OnlineNotification not){
		if(not.hasEncoded){
			def appTagLib =new ApplicationTagLib()
			subject= appTagLib.message( code : not.title ) as String
			if(not.args){
				def arg= not.args.split(",") .collect { it }
				message= appTagLib.message( code : not.message, args :  arg ) as String
			}else{
				message= appTagLib.message( code : not.message ) as String
			}
			isRead=not.isRead
			createdDate=not.createdDate
			opId=not.operation
		}else{
			subject=not.title
			message=not.message
			isRead=not.isRead
			createdDate=not.createdDate
			opId=not.operation
		}
		id=not.id
		def f=Operation.get(opId)
		def res=null
		if(f?.taxista){
			res=new TaxiCommand()
			if(f?.intermediario){
				res.nombre= f.taxista.firstName+" "+ f.taxista.lastName
				def v=Vehicle.findByTaxistas(f.taxista)
				if(v){
					res.marca=v.marca
					res.patente=v.patente
					res.modelo=v.modelo
				}
				def com=Company.get(f.intermediario.employee.id)
				if(com){
					res.empresa= com.companyName
					res.companyPhone= com.phone
				}
			}else{
				res.nombre= f.taxista.firstName+" "+ f.taxista.lastName
				def v=Vehicle.findByTaxistas(f.taxista)
				if(v){
					res.marca=v.marca
					res.patente=v.patente
				}
			}
			res.numeroMovil=f.taxista.email.split("@")[0]
			taxiNumber=res.numeroMovil
		}
		def tr=new com.TripCommand(f.id,f?.timeTravel,f.createdDate,f.favorites?.placeFrom.name,
				f.favorites?.placeFromPso?f.favorites?.placeFromPso:'',
				f.favorites?.placeFromDto?f.favorites?.placeFromDto:'',
				f.favorites?.placeTo?f.favorites?.placeTo.name:'',
				f.favorites?.comments?f.favorites?.comments:'',f.status.toString(),res,f.favorites?.name)

		trip=tr
	}

	NotificationCommand(Operation op,User usr,String titt,String mess){

		subject=titt
		message=mess
		isRead=false
		createdDate=op.createdDate
		opId=op.id
		id=op.id
		def f=op
		def res=null
		if(f.taxista){
			res=new TaxiCommand()
			if(f?.intermediario){
				res.nombre= f.taxista.firstName+" "+ f.taxista.lastName
				def v=Vehicle.findByTaxistas(f.taxista)
				if(v){
					res.marca=v.marca
					res.patente=v.patente
					res.modelo=v.modelo
				}
				def com=Company.get(f.intermediario.employee.id)
				if(com){
					res.empresa= com.companyName
					res.companyPhone= com.phone
				}
			}else{
				res.nombre= f.taxista.firstName+" "+ f.taxista.lastName
				def v=Vehicle.findByTaxistas(f.taxista)
				if(v){
					res.marca=v.marca
					res.patente=v.patente
				}
			}
			res.numeroMovil=f.taxista.email.split("@")[0]
			taxiNumber=res.numeroMovil
		}
		def tr=new com.TripCommand(f.id,f.timeTravel,f.createdDate,f.favorites?.placeFrom.name,
				f.favorites?.placeFromPso?f.favorites?.placeFromPso:'',
				f.favorites?.placeFromDto?f.favorites?.placeFromDto:'',
				f.favorites?.placeTo?f.favorites?.placeTo.name:'',
				f.favorites?.comments?f.favorites?.comments:'',f.status.toString(),res,f.favorites?.name)
		trip=tr
	}
}
