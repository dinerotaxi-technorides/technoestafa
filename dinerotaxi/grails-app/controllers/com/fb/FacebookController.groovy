package com.fb

//�import net.sf.json.groovy.JsonSlurper;
import sun.misc.BASE64Decoder;
import grails.converters.*
import com.api.GraphAPIService;

class FacebookController {

	def authService
	def wallService
	def graphAPIService
	def springSecurityService
	def facebookService
	def getData = {


		def signedRequest = params.signed_request
		if(signedRequest){
			def splitReq = signedRequest.split(/\./)

			if (splitReq.size() != 2) {
				log.error "Malformed Facebook signedRequest - expected signature and a request"
				return null
			}

			def sig = base64UrlDecode(splitReq[0])

			def data = (new groovy.json.JsonSlurper()).parseText(base64UrlDecode(splitReq[1]))

			if (data.algorithm != 'HMAC-SHA256') {
				log.error "Unsupported HMAC algorithm for a Facebook signed request"
				return null
			}
			return data
		}else{
			return null
		}
	
	}

	def index = {
		if(!session.accessToken||params.signed_request){
			def data = getData()
			if(data){
				def accessToken = data.oauth_token
				URL a = new URL("https://graph.facebook.com/me?access_token=${accessToken}")
				def user = JSON.parse(a.getText())
				def email = user.email;
				def uid=data.user_id
				def fbuser =facebookService.logUser(uid ,email,accessToken) 
				[fbuser:fbuser]
			}else{
			
				redirect(view:'dinerotaxi_error')
				return;
			}
		}
		
	}


	def base64UrlDecode(def encodedBase64Url) {
		encodedBase64Url += '=' * (4 - encodedBase64Url.size().mod(4))

		return (new String(encodedBase64Url?.tr('-_', '+/').decodeBase64()))

	}


	def invite = {
		render(view:'invite', model:[])
	}

}
