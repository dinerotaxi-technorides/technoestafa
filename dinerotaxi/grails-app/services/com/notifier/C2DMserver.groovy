package com.notifier

import java.util.HashMap;
import java.util.logging.Logger
import javax.net.ssl.HttpsURLConnection

import ar.com.notification.*


class C2DMserver {
	private final static String googleUri = "https://www.google.com/accounts/ClientLogin";
	private HashMap<String, String> auth_tokens;
	private static final String UTF8 = "UTF-8";
	private static final Logger log = Logger.getLogger(C2DMserver.class.getName())
	private final static String service = "ac2dm";
	def serviceMethod() {
	}
	public C2DMserver(){
		auth_tokens = new HashMap<String, String>();
	}


	public synchronized String getAuthToken(ConfigurationApp conf,boolean renovate) {
		if(!auth_tokens.get(conf.androidEmail) || renovate)
			setSessionToken(conf);
		return auth_tokens.get(conf.androidEmail);
	}

	public synchronized void setAuthToken(ConfigurationApp conf,String authToken) {
		this.auth_tokens.put(conf.androidEmail,authToken);
	}

	private setSessionToken(ConfigurationApp conf){
		String parameters = "accountType=" + conf.androidAccountType + "&Email=" + conf.androidEmail+ "&Passwd=" + conf.androidPass + "&service=" + service;
		URL url = new URL(googleUri);
		byte[] postData = parameters.getBytes(UTF8);
		HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
		conn.setDoOutput(true);
		conn.setUseCaches(false);
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type",
				"application/x-www-form-urlencoded");
		conn.setRequestProperty("Content-Length",
				Integer.toString(postData.length));
		OutputStream out = conn.getOutputStream();
		out.write(postData);
		out.close();
		int responseCode = conn.getResponseCode();
		if (responseCode == 200) {
			BufferedReader br = new BufferedReader(new InputStreamReader(
					conn.getInputStream()));
			String line = "";
			String token = "";
			while (((line = br.readLine()) != null)) {
				if (line.startsWith("Auth=")) {
					token = line.substring("Auth=".length());
				}
			}
			if (token != null) {
				setAuthToken(conf, token)
				log.info("Got updated auth token from C2DM servers: " + token);
			} else
				log.info("could not found string of token");
		} else {
			log.info("Got " + responseCode
					+ " response from Google C2DM endpoint.");
			String responseLine = new BufferedReader(new InputStreamReader(
					conn.getInputStream())).readLine();

			if (responseLine == null || responseLine.equals("")) {
				throw new IOException(
				"Got empty response from Google C2DM endpoint.");
			}

			String[] responseParts = responseLine.split("=", 2);
			if (responseParts.length != 2) {
				log.warning("Invalid message from google: " + responseCode
						+ " " + responseLine);
				throw new IOException("Invalid response from Google "
				+ responseCode + " " + responseLine);
			}

			if (responseParts[0].equals("Error")) {
				String err = responseParts[1];
				log.warning("Got error response from Google C2DM endpoint: "
						+ err);
				throw new IOException("Server error: " + err);
			} else {
				// 500 or unparseable response - server error, needs to retry
				log.warning("Invalid response from google " + responseLine
						+ " " + responseCode);
			}
		}
	}
}
