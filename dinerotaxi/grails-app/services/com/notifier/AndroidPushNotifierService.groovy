package com.notifier

import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.io.OutputStream
import java.net.URL
import java.util.logging.Logger

import javax.net.ssl.HostnameVerifier
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLSession

import ar.com.notification.*

class AndroidPushNotifierService {

	static transactional = true
	def auth=null;
	public static final String PARAM_REGISTRATION_ID = "registration_id";
	public static final String PARAM_DELAY_WHILE_IDLE = "delay_while_idle";
	public static final String PARAM_COLLAPSE_KEY = "collapse_key";
	private static final String UPDATE_CLIENT_AUTH = "Update-Client-Auth";
	private static final String UTF8 = "UTF-8";
	public static final String C2DM_SEND_ENDPOINT = "https://android.apis.google.com/c2dm/send";

	private static final Logger log = Logger.getLogger(AndroidPushNotifierService.class.getName());

	def serviceMethod() {
	}

	def C2DMserver c2DMserver = new C2DMserver();

	public StatusCode sendNotification(Notification notification,ConfigurationApp conf, boolean retry) throws IOException {
		StringBuilder postDataBuilder = new StringBuilder();
		postDataBuilder.append(PARAM_REGISTRATION_ID).append("=")
				.append(notification.code_device);
		postDataBuilder.append("&").append(PARAM_COLLAPSE_KEY).append("=")
				.append("abc");
		for(value in notification.args)
			postDataBuilder.append("&"+value);
		byte[] postData = postDataBuilder.toString().getBytes(UTF8);
		// Hit the dm URL.
		URL url = new URL(C2DM_SEND_ENDPOINT);
		HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
		conn.setHostnameVerifier(new HostnameVerifier() {
					public boolean verify(String hostname, SSLSession session) {
						return true;
					}
				});
		conn.setDoOutput(true);
		conn.setUseCaches(false);
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type",
				"application/x-www-form-urlencoded");
		conn.setRequestProperty("Content-Length",
				Integer.toString(postData.length));
		String authToken = c2DMserver.getAuthToken(conf,!retry);
		if(!authToken)
			return StatusCode.ANDROID_AUTH_TOKEN_FAILED;
		conn.setRequestProperty("Authorization", "GoogleLogin auth="
				+ authToken);
		OutputStream out = conn.getOutputStream();
		out.write(postData);
		out.close();
		int responseCode = conn.getResponseCode();
		StatusCode status = StatusCode.OK;
		if (responseCode == 401 || responseCode == 503)
		// renovar token
		{
			log.warning("Unauthorized - need token");
			// serverConfig.invalidateCachedToken;
			if (retry)
				this.sendNotification(notification,conf,false);
			status = StatusCode.ANDROID_AUTH_TOKEN_FAILED;
		}

		String updatedAuthToken = conn.getHeaderField(UPDATE_CLIENT_AUTH);
		if (updatedAuthToken != null && !authToken.equals(updatedAuthToken)) {
			log.info("Got updated auth token from C2DM servers: "
					+ updatedAuthToken);
			c2DMserver.setAuthToken(conf,updatedAuthToken);
		}

		String responseLine = new BufferedReader(new InputStreamReader(
				conn.getInputStream())).readLine();

		// NOTE: You *MUST* use exponential backoff if you receive a 503
		// response code.
		// Since App Engine's task queue mechanism automatically does this for
		// tasks that
		// return non-success error codes, this is not explicitly implemented
		// here.
		// If we weren't using App Engine, we'd need to manually implement this.
		log.info("Got " + responseCode + " response from Google C2DM endpoint.");

		if (responseLine == null || responseLine.equals("")) {
			//no responde server de android
			//throw new IOException(
			//"Got empty response from Google C2DM endpoint.");
			status = StatusCode.GOOGLE_SERVER_UNPARSABLE_RESPONSE;
		}

		String[] responseParts = responseLine.split("=", 2);
		if (responseParts.length != 2) {
			log.warning("Invalid message from google: " + responseCode + " "
					+ responseLine);
			status = StatusCode.GOOGLE_SERVER_UNPARSABLE_RESPONSE;
			//throw new IOException("Invalid response from Google "
			//+ responseCode + " " + responseLine);
		}

		if (responseParts[0].equals("id")) {
			log.info("Successfully sent data message to device: "
					+ responseLine);
		}

		if (responseParts[0].equals("Error")) {
			String err = responseParts[1];
			log.warning("Got error response from Google C2DM endpoint: " + err);
			status = StatusCode.GOOGLE_SERVER_ERROR;
			// No retry.
			// (costin): show a nicer error to the user.
			//throw new IOException("Server error: " + err);
		} else {
			// 500 or unparseable response - server error, needs to retry
			log.warning("Invalid response from google " + responseLine + " "
					+ responseCode);
			status = StatusCode.GOOGLE_SERVER_UNPARSABLE_RESPONSE;
		}
		return status;
	}
}
