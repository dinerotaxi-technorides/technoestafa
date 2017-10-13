package com
class AuthTagLib1{
	def authService
	def isFacebookLoggedIn = { attrs, body ->
		if(authService.isConnected() ) {
			  out << body()
		}
	}
	
	def isFacebookNotLoggedIn = { attrs, body ->
		if(!authService.isConnected()  ) {
			  out << body()
		}
	}
	
	def isFacebookLogged = {
		if(authService.isConnected() ) {
			  out << 'true'
		}else{
			out << 'false'
		}
	}
		
}
