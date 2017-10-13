package com.page
import ar.com.goliath.*
class FavoritosController {
	def springSecurityService
	def index = {
		def us=springSecurityService.currentUser
		def userRole=Role.findByAuthority("ROLE_USER")
		def taxiRole=Role.findByAuthority("ROLE_TAXI")
		if(us){
			if (us.authorities.contains(taxiRole)) {
			}
		}
		[user:us]
	}
	def user = {
	}
	def register = {
	}
	def complete = {
	}
}
