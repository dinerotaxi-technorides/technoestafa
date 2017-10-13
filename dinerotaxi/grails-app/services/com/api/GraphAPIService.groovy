package com.api

import java.util.Map;

import grails.converters.*

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.HttpDelete
import org.apache.http.message.BasicNameValuePair
import org.apache.http.params.BasicHttpParams
import org.apache.http.params.HttpParams

import com.sun.net.httpserver.HttpsParameters;

class GraphAPIService {

    static transactional = false

	def apiClientConnectionService
	def errorService	
	
	def doesUserLike(String accessToken, String pageID){
		try{
			URL a = new URL("https://graph.facebook.com/me/likes/${pageID}?access_token=${accessToken}")
			return (JSON.parse(a.getText()).data.size()>0)
		}catch(Exception e){
			errorService.logError("userLikes", e)
		}
	}				
	
	def deleteRequest(String accessToken, String requestID){
		HttpDelete request = new HttpDelete(new URI("https://graph.facebook.com/${requestID}?access_token=${URLEncoder.encode(accessToken)}"))
		request.setHeader('Content-Length', '0')
		apiClientConnectionService.logRequest(request)
		apiClientConnectionService.doHttpMethod(request)
	}
	
	private HttpEntity getEntityFromParams(Map params){
		List<NameValuePair> formparams = new ArrayList<NameValuePair>();
		
		params.each {
			formparams.add(new BasicNameValuePair(it.key, it.value.toString()));
		}
		
		return new UrlEncodedFormEntity(formparams, "UTF-8");
	}
}
