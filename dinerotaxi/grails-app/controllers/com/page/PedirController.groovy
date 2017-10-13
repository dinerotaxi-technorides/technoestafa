package com.page
import ar.com.goliath.*
class PedirController {
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
	def favorite={
	}
	def register = {
	}
	def complete = {
	}
}
