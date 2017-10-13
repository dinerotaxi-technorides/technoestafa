package com.api

import org.apache.http.HttpEntity
import org.apache.http.HttpHost
import org.apache.http.HttpResponse
import org.apache.http.NameValuePair
import org.apache.http.client.HttpClient
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.HttpDelete
import org.apache.http.client.methods.HttpEntityEnclosingRequestBase
import org.apache.http.client.methods.HttpGet
import org.apache.http.client.methods.HttpPost
import org.apache.http.client.methods.HttpPut
import org.apache.http.client.methods.HttpUriRequest
import org.apache.http.client.protocol.ClientContext
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.conn.routing.HttpRoute
import org.apache.http.impl.client.BasicCookieStore
import org.apache.http.impl.client.DefaultHttpClient
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager
import org.apache.http.message.BasicNameValuePair
import org.apache.http.protocol.BasicHttpContext
import org.apache.http.protocol.HttpContext
import org.apache.http.util.EntityUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException
import org.codehaus.jackson.map.ObjectMapper
import javax.servlet.http.HttpSession
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.context.request.ServletRequestAttributes
import org.apache.http.client.CookieStore

import com.dinerotaxi.IdleConnectionMonitorThread
import com.sun.jndi.dns.Header;


public class ApiClientConnectionService {

	//Declarations

	ThreadSafeClientConnManager cm
	ObjectMapper objectMapper
	Boolean useSession
	String apiUrl
	//+
	public ApiClientConnectionService(){
	}

	public void init(){
		def config = ConfigurationHolder.config
		cm = new ThreadSafeClientConnManager();
		// Increase max total connection
		cm.setMaxTotal(new Integer(config.apiConnection.maxConnections));
		// Increase default max connection per route
		cm.setDefaultMaxPerRoute(new Integer(config.apiConnection.maxConnections));
		// Increase max connections for API
		HttpHost localhost = new HttpHost(config.apiHost, new Integer(config.apiPort));
		cm.setMaxForRoute(new HttpRoute(localhost), new Integer(config.apiConnection.maxConnections));

		// Set API URL
		apiUrl = "http://"+config.apiHost+":"+config.apiPort+config.apiPath;

		// Should service use session to keep client cookies
		useSession = config.apiConnection.useSession

		// Instance json object mapper
		objectMapper = new ObjectMapper();

		// Start monitor thread
		new IdleConnectionMonitorThread(cm).start();
	}

	def void logRequest(HttpUriRequest request){
		logRequest(request, null)
	}

	def void logRequest(HttpUriRequest request, Map params){
		if(log.infoEnabled){
			log.info("----------- API Request -------------");
			log.info(request.method + " " + request.URI);
			if(params != null){
				log.info("Params: "+params);
			}
		}
	}

	def Map get(String relativeUrl){
		HttpGet request = new HttpGet(apiUrl+relativeUrl);
		logRequest(request);
		return doHttpMethod(request)
	}

	def Map get(String relativeUrl, Map params){
		HttpGet request = new HttpGet(apiUrl+relativeUrl+getURLGetParameters(params));
		logRequest(request);
		return doHttpMethod(request)
	}

	def Map post(String relativeUrl, Map params){
		HttpPost request = new HttpPost(apiUrl+relativeUrl);
		logRequest(request,params);
		request.setEntity(getEntityFromParams(params));
		return doHttpMethod(request)
	}

	def Map post(String relativeUrl){
		return post(relativeUrl,null)
	}

	def Map put(String relativeUrl, Map params){
		HttpPut request = new HttpPut(apiUrl+relativeUrl);
		logRequest(request,params);
		request.setEntity(getEntityFromParams(params));
		return doHttpMethod(request)
	}

	def Map put(String relativeUrl){
		return put(relativeUrl,null)
	}

	def Map delete(String relativeUrl){
		HttpDelete request = new HttpDelete(apiUrl+relativeUrl);
		logRequest(request);
		return doHttpMethod(request)
	}

	def Map doHttpMethod(HttpUriRequest request){
		HttpClient client = new DefaultHttpClient(cm);

		if(useSession && getSession().apiContext == null){
			CookieStore cookieStore = new BasicCookieStore();
			HttpContext localContext = new BasicHttpContext();
			localContext.setAttribute(ClientContext.COOKIE_STORE, cookieStore);
			getSession().apiContext = localContext;
		}

		HttpResponse response =	execute(client,request,getSession().apiContext);

		if(log.infoEnabled){
			log.info("----------- API Response ------------");
			log.info(response.getStatusLine().getStatusCode());
			log.info("-------------------------------------");
		}


		return processWebResponse(request, response)
	}

	private Map processWebResponse(HttpUriRequest request, HttpResponse response){
		def webResponse = [error:false, ans:null, httpcode:null, location:null]
		HttpEntity entity = response.getEntity();
		def result = null;
		def status = response.getStatusLine().getStatusCode();

		if (entity != null && entity.getContentLength()> 0) {
			String responseString = null;
			InputStream instream = entity.getContent();
			try {
				responseString = instream.getText();
				if(objectMapper != null){
					webResponse.ans = objectMapper.readValue(responseString, Map.class);
				} else {
					webResponse.ans = responseString;
				}
			} catch (JsonMappingException e){
				webResponse.ans = responseString;
			} catch (JsonParseException e){
				webResponse.ans = responseString;
			} catch (java.io.EOFException ignore){
			} catch (RuntimeException ex) {
				request.abort();
				throw ex;
			} finally {
				try { instream.close(); } catch (Exception ignore) {}
				EntityUtils.consume(response.getEntity());
			}
		} else {
			EntityUtils.consume(response.getEntity());
		}

		def isOk = status>=200 && status<300;
		if(!isOk){
			webResponse.error = true;
			if(log.infoEnabled){
				log.info("API RESPONSE ERROR: "+webResponse)
			}
		}

		webResponse.location = response.getFirstHeader("Content-Location")?.value
		webResponse.httpcode = status;

		return webResponse
	}

	private HttpEntity getEntityFromParams(Map params){
		List<NameValuePair> formparams = new ArrayList<NameValuePair>();
		params.each {
			formparams.add(new BasicNameValuePair(it.key, it.value.toString()));
		}
		return new UrlEncodedFormEntity(formparams, "UTF-8");
	}

	private HttpResponse execute(HttpClient client, HttpUriRequest request, HttpContext context){
		if(context != null){
			client.execute(request,context)
		} else {
			client.execute(request);
		}
	}

	private HttpSession getSession() {
		ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
		return attr.getRequest().getSession(true); // true == allow create
	}

	private String getURLGetParameters(Map params){
		List<NameValuePair> formparams = new ArrayList<NameValuePair>();
		params.each {
			formparams.add(new BasicNameValuePair(it.key, it.value.toString()));
		}
		return '?'+URLEncodedUtils.format(formparams, "UTF-8");
	}
}
