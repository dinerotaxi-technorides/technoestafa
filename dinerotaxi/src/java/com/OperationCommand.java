package com;

import java.util.Date;

import org.json.JSONObject;

public class OperationCommand {

	public String placeFrom, placeFromFloor, placeFromApartment, placeTo,
			placeToFloor, placeToApartment, comments, favoriteName;
	public OptionsCommand options;
	public boolean isTemporal;

	OperationCommand(JSONObject operation) {
		
	}

	OperationCommand(String placeFrom, String placeFromFloor,
			String placeFromApartment, String placeTo, String placeToFloor,
			String placeToApartment, String comments, String favoriteName,
			OptionsCommand options) {
		this.placeFrom = placeFrom;
		this.placeFromFloor = placeFromFloor;
		this.placeFromApartment = placeFromApartment;
		this.placeTo = placeTo;
		this.comments = comments;
		this.options = options;
	}

}
