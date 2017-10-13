package com;

import java.util.Date;

import org.json.*;

import org.codehaus.groovy.grails.commons.*;
public class PlaceCommand {

	public String floor, appartment;
	public String number, street,city,country,ccode;
	public Double lng, lat;
	PlaceCommand(JSONObject placeJSON) throws JSONException{
		this.floor=placeJSON.getString("floor");
		this.appartment=placeJSON.getString("appartment");
		this.number=placeJSON.getString("number");
		this.street=placeJSON.getString("street");
		this.city=placeJSON.getString("city");
		this.country=placeJSON.getString("country");
		this.ccode=placeJSON.getString("ccode");
		this.lng=placeJSON.getDouble("lng");
		this.lat=placeJSON.getDouble("lat");
	}


}
