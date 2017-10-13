package com.api

import javax.servlet.http.HttpSession
class AuthService {
static transactional = false
	static scope = "singleton"
	def apiClientConnectionService
	def connectionRepository
	def facebook
	def socialLogin(String accessToken, String socialApp, String socialId, String socialName){
		
		return null
	}
	Boolean isConnected(String prov) {
		
		
		return false
	}
	def getUser(String providerId){
		
		return null
	}
	private HttpSession getSession() {
		return null
	}
}
