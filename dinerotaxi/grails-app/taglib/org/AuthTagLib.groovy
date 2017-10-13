package org
class AuthTagLib {
	def authService
	def isFacebookLoggedIn = { attrs, body ->
		if(authService.isConnected('facebook')) {
			  out << body()
		}
	}
	
	def isFacebookNotLoggedIn = { attrs, body ->
		if(!authService.isConnected('facebook')) {
			  out << body()
		}
	}
	def isTwitterLoggedIn = { attrs, body ->
		if(authService.isConnected('twitter')) {
			  out << body()
		}
	}
	
	def isTwitterNotLoggedIn = { attrs, body ->
		if(!authService.isConnected('twitter')) {
			  out << body()
		}
	}
}
