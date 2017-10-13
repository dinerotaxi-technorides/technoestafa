package com.api
import ar.com.goliath.*

import ar.com.favorites.Favorites
import grails.converters.JSON
import ar.com.operation.Operation
import ar.com.operation.OperationPending;
import ar.com.operation.TRANSACTIONSTATUS
import ar.com.operation.OperationHistory
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.codehaus.groovy.grails.plugins.springsecurity.ui.RegistrationCode
import org.springframework.security.core.Authentication

import ar.com.goliath.api.JsonToken;
import ar.com.goliath.EmployUser;
import ar.com.goliath.User;
import ar.com.goliath.UStatus
import ar.com.goliath.*
import ar.com.goliath.TypeEmployer
import ar.com.goliath.Role
import ar.com.goliath.UserRole
import ar.com.goliath.PersistToken
import com.Calification
import com.Device
import com.sun.org.apache.xpath.internal.operations.String;
class FavoritesApiController {
	def exportService
	def springSecurityService
	def placeService
	def userService
	def emailService
	def utilsApiService

	// the delete, save and update actions only accept POST requests
	//static allowedMethods = [createTrip:'POST']

	def createFavorite={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
			    usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def addressFrom=JSON.parse(params?.addressFrom)
					def piso=params?.piso?:""
					def dpto=params?.departamento?:""
					def favName=params?.favoriteName?:"temp"
					boolean isfav=params?.isFavorite?!params?.isFavorite.contains("true"):true
					def placeFromString=utilsApiService.generateAddress(addressFrom)
					def o = JSON.parse(placeFromString)
					def pl = new Place(o)
					pl.json = placeFromString
					if(!pl.save(flush:true)){
						pl.errors.each{
							log.error it
						}
					}
					def fav=new Favorites(name:favName,placeFromPso:piso,placeFromDto:dpto,placeFrom:pl,placeTo:null,user:usr)
					if(!fav.save(flush:true)){
						pl.delete()
					}
					render(contentType:'text/json',encoding:"UTF-8") {
						status=100
						id=fav.id
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.getMessage()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}

	def deleteListFavorites={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					if(params?.id){
						def id=params?.id.split(",")
						id.each{
							def favoriteInstance = Favorites.get(it)
							if(favoriteInstance){
								if (favoriteInstance.user==usr){
									favoriteInstance.setEnabled(false);
									favoriteInstance.save(flush:true);
								}else{

								}
							}
						}
						render(contentType:'text/json',encoding:"UTF-8") { status=100 }
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=125 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def deleteFavorite={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					def id=params?.id
					def favoriteInstance = Favorites.get(params.id)
					if(favoriteInstance){
						if (favoriteInstance.user==usr){
							favoriteInstance.setEnabled(false);
							favoriteInstance.save(flush:true);
							render(contentType:'text/json',encoding:"UTF-8") { status=100 }
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=125 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=121 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def deleteAllFavorites={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
				if(usr){
					placeService.deleteFavorites(usr)
					render(contentType:'text/json',encoding:"UTF-8") { status=100 }
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def getListFavorites={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}

			if(tok || springSecurityService.isLoggedIn()){

				if(usr){
					def c = Favorites.createCriteria()
					def opL=c.list(){
						and{
							eq ('user',usr)
							eq('enabled',true)
						}
					}
					def ids= opL.collect { it.id }
					render(contentType:'text/json',encoding:"UTF-8") {
						status=100
						id=ids.join(",")

					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def getFullListFavorites={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){
					def c = Favorites.createCriteria()
					def opL=c.list(){
						and{
							eq ('user',usr)
							eq('enabled',true)
						}
						order("createdDate", "desc")
					}
					def listTrip=new ArrayList()
					opL.each{
						def tr=new com.FavoriteCommand(it.id,it.createdDate,it.placeFrom?.street+" "+ it.placeFrom?.streetNumber,
								it?.placeFromPso?it.placeFromPso:'',
								it?.placeFromDto?it.placeFromDto:'',it?.name?it.name:'')
						listTrip.add(tr)
					}
					render(contentType:'text/json',encoding:"UTF-8") {
						status=100
						json=listTrip
					}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=11 }
		}
	}
	def isAvailable={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){

				if(usr){
					def c = Favorites.createCriteria()
					def opL=c.list(){
						and{
							eq ('user',usr)
							eq('name',params?.name?:"temp")
						}
					}
					if(opL){
						render(contentType:'text/json',encoding:"UTF-8") { status=130 }
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=100 }
					}

				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}

		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
	def getFavorite={
		try{
			def usr=null
			if (springSecurityService.isLoggedIn()){
				def prin= springSecurityService.principal
				usr = springSecurityService.currentUser

			}
			def tok=null
			if(params?.token){
				tok=PersistToken.findByToken(params?.token)
				if(tok){
					usr=User.findByUsernameAndRtaxi(tok.username,tok?.rtaxi?User.get(tok.rtaxi):null)
				}
			}
			if(tok || springSecurityService.isLoggedIn()){

				if(usr){
					def id=params?.id
					def operationInstance = Favorites.get(params.id)
					if(operationInstance){
						if (operationInstance.user==usr){
							render(contentType:'text/json',encoding:"UTF-8") {
								id=operationInstance?.id
								status=100
								placeFrom=operationInstance.placeFrom.street+" "+ operationInstance.placeFrom.streetNumber
								piso=operationInstance?.placeFromPso?operationInstance?.placeFromPso:''
								depto=operationInstance?.placeFromDto?operationInstance?.placeFromDto:''
								favoriteName=operationInstance.name
							}
						}else{
							render(contentType:'text/json',encoding:"UTF-8") { status=125 }
						}
					}else{
						render(contentType:'text/json',encoding:"UTF-8") { status=121 }
					}
				}else{
					render(contentType:'text/json',encoding:"UTF-8") { status=2 }
				}
			}else{
				render(contentType:'text/json',encoding:"UTF-8") { status=1 }
			}
		}catch (Exception e){
			log.error e.printStackTrace()
			render(contentType:'text/json',encoding:"UTF-8") { status=1 }
		}
	}
}
