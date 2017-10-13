package com.api

import com.UserDevice;

import ar.com.favorites.*
import ar.com.goliath.*
import ar.com.operation.*
import grails.converters.*


class PlaceCompanyAccountEmployeeService {

    static transactional = true
    def notificationService
    def deletePlaces(User user) {
      def l = []
      l += user.places
       
      l.each { place ->
          user.removeFromPlaces(place)
          place.delete()
      }
      user.save(flush:true)
    }
    
    def createFromJson(List places){
        def o = JSON.parse(places[0])
        def pl = new Place(o)
        pl.json = places[0]
        return pl
    }
    
    def updatePlaces(User user, List places) {
      deletePlaces(user)

      places.each { result ->
         def o = JSON.parse(result)
        def pl = new Place(o)
        pl.json = result
        user.addToPlaces(pl)            
      }
      user.save(flush:true)
    }
	def createFavoriteAndOperationWithoutRegistration(User user,String place1,String place2,boolean isTemporal,String piso,String dpto,String comments,String name,String name1,UserDevice dev) {

		  
		  def o = JSON.parse(place1)
		  def pl = new Place(o)
		  pl.json = place1
		  if(!pl.save(flush:true)){
			  user.delete()
			  throw new Exception("createFavoriteAndOperationWithoutRegistration: Problem placeFrom")
		  }
		  if(place2!=null){
			  def o1 = JSON.parse(place2)
			  def pl1 = new Place(o)
			  pl1.json = place2
			  if(!pl1.save(flush:true)){
				  user.delete()
				  pl.delete()
				  throw new Exception("createFavoriteAndOperationWithoutRegistration: Problem placeTo")
			  }
			  def fav=isTemporal?new TemporalFavorites(name:name,placeFromPso:piso,placeFromDto:dpto,comments:comments,placeFrom:pl,placeTo:pl1,user:user):
			  					new Favorites(name:name,placeFromPso:piso,placeFromDto:dpto,comments:comments,placeFrom:pl,placeTo:pl1,user:user)
			  if(!fav.save(flush:true)){
				  user.delete()
				  pl.delete()
				  if(place1!=null){
					  pl1.delete()
				  }
				  throw new Exception("createFavoriteAndOperationWithoutRegistration: Problem Favorites")
			  }
			  def oper=new OperationCompanyPending(user:user,favorites:fav)
			  oper.isTestUser=user.isTestUser
			  oper.isCompanyAccount=true
			  
			  oper.dev=dev
			  if(!oper.save(flush:true)){
				  user.delete()
				  fav.delete()
				  pl.delete()
				  if(place1!=null){
					  pl1.delete()
				  }
				  throw new Exception("createFavoriteAndOperationWithoutRegistration: Problem Operation")
			  }else{
				  def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
				  trackOperation.operation=oper
				  trackOperation.isCompanyAccount=true
				  trackOperation.save(flush:true)
			  	notificationService.notificateOnCreateTrip(oper,user)
			  }
		  }else{
		  	def fav=isTemporal?new TemporalFavorites(name:name,placeFromPso:piso,placeFromDto:dpto,comments:comments,placeFrom:pl,placeTo:null,user:user):
			  					new Favorites(name:name,placeFromPso:piso,placeFromDto:dpto,comments:comments,placeFrom:pl,placeTo:null,user:user)
			  if(!fav.save(flush:true)){
				  user.delete()
				  pl.delete()
				  throw new Exception("createFavoriteAndOperationWithoutRegistration: Problem Favorites")
			  }
			  def oper=new OperationCompanyPending(user:user,favorites:fav)
			  
			  oper.dev=dev
			  oper.isTestUser=user.isTestUser
			  oper.isCompanyAccount=true
			  if(!oper.save(flush:true)){
				  user.delete()
				  fav.delete()
				  pl.delete()
				  throw new Exception("createFavoriteAndOperationWithoutRegistration: Problem Operation")
			  }else{
			  
			  
				  def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
				  trackOperation.operation=oper
				  trackOperation.isCompanyAccount=true
				  trackOperation.save(flush:true)
			  	notificationService.notificateOnCreateTrip(oper,user)
			  }
		  }
		 
	  }
	
	def createFavoriteAndOperation(User user,String place1,String place2,boolean isTemporal,String piso,String dpto,String comments,String name,String name1,UserDevice dev) {
		
		OperationCompanyPending.withTransaction{txn ->
			def o = JSON.parse(place1)
			def pl = new Place(o)
			pl.json = place1
			if(!pl.save(flush:true)){
				throw new Exception("createFavoriteAndOperation: Problem placeFrom")
			}
			if(place2!=null){
				def o1 = JSON.parse(place2)
				def pl1 = new Place(o1)
				pl1.json = place2
				if(!pl1.save(flush:true)){
					pl.delete()
					throw new Exception("createFavoriteAndOperation: Problem placeTo")
				}
				def fav=isTemporal?new TemporalFavorites(name:name,placeFromPso:piso,placeFromDto:dpto,comments:comments,placeFrom:pl,placeTo:pl1,user:user):
									new Favorites(name:name,placeFromPso:piso,placeFromDto:dpto,comments:comments,placeFrom:pl,placeTo:pl1,user:user)
				if(!fav.save(flush:true)){
					pl.delete()
					if(place1!=null){
						pl1.delete()
					}
					throw new Exception("createFavoriteAndOperation: Problem Favorites")
				}
				def oper=new OperationCompanyPending(user:user,favorites:fav,isTestUser:user.isTestUser)
				oper.isTestUser=user.isTestUser
				oper.dev=dev
				oper.isCompanyAccount=true
				if(!oper.save(flush:true)){
					fav.delete()
					pl.delete()
					if(place1!=null){
						pl1.delete()
					}
					throw new Exception("createFavoriteAndOperation: Problem Operation")
				}else{
				
					def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
					trackOperation.operation=oper
					trackOperation.isCompanyAccount=true
					trackOperation.save(flush:true)
					notificationService.notificateOnCreateTrip(oper,user)
				}
				return oper
			}else{
				def fav=isTemporal?new TemporalFavorites(name:name,placeFromPso:piso,placeFromDto:dpto,comments:comments,placeFrom:pl,placeTo:null,user:user):
									new Favorites(name:name,placeFromPso:piso,placeFromDto:dpto,comments:comments,placeFrom:pl,placeTo:null,user:user)
				if(!fav.save(flush:true)){
					pl.delete()
					throw new Exception("createFavoriteAndOperation: Problem Favorites")
				}
				def oper=new OperationCompanyPending(user:user,favorites:fav)
				oper.isTestUser=user.isTestUser
				oper.dev=dev
				oper.isCompanyAccount=true
				if(!oper.save(flush:true)){
					fav.delete()
					pl.delete()
					throw new Exception("createFavoriteAndOperation: Problem Operation")
				}else{
					def trackOperation=new TrackOperation(status:TRANSACTIONSTATUS.PENDING)
					trackOperation.operation=oper
					trackOperation.isCompanyAccount=true
					trackOperation.save(flush:true)
					  notificationService.notificateOnCreateTrip(oper,user)
				}
				return oper
			}
		}
		 
	  }
	def deleteFavorites(User usr){
		def c = Favorites.findAllByUserAndEnabled(usr,true)
		c.each {
			it.setEnabled(false);
			it.save(flush:true);
		}
	}
	def deleteFavorite(Long id){
		def c = Favorites.get(id)
		c.setEnabled(false);
		c.save(flush:true);
	}
	def createFavorite(User user,String place1,String piso,String dpto,String name) {
		
		def o = JSON.parse(place1)
		def pl = new Place(o)
		pl.json = place1
		if(!pl.save(flush:true)){
			throw new Exception("createFavorite: Problem placeFrom")
		}
		def fav=new Favorites(name:name,placeFromPso:piso,placeFromDto:dpto,placeFrom:pl,placeTo:null,user:user)
		if(!fav.save(flush:true)){
			pl.delete()
			throw new Exception("createFavorite: Problem Favorites")
		}
		return fav	
	}
}

