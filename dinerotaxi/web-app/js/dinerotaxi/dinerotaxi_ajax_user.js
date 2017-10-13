/**
 * @author Wannataxi
 */

/**
 * ============================================================================
 * AJAX
 * ============================================================================
 */

/*
 * @param {String} msisdn: @param {string} password: @param {String}
 * rememberUser: receives "true" or null @param {String} successFunc: Callback
 * function for success @param {String} errorFunc: Callback function for error
 */
function userLogin(msisdn, password, rememberUser, successFunc, errorFunc) {
	var serviceName = "user/login";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "";
	if (rememberUser != null) {
		params = (rememberUser) ? "remember=1&" : "";
	}
	params += "method=" + "json" + "&msisdn=" + msisdn + "&password="
			+ password;

	$.ajax({
		type : "POST",
		url : reqURL,
		data : params,
		dataType : "json",
		success : successFunc,
		error : errorFunc
	});
}

/*
 * @param {String} successFunc: Callback function for success @param {String}
 * errorFunc: Callback function for error
 */
function userLogout(successFunc, errorFunc) {
	var serviceName = "user/logout";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json";

	params = securizeForUser(params);

	$.ajax({
		type : "POST",
		url : reqURL,
		data : params,
		dataType : "json",
		success : successFunc,
		error : errorFunc
	});
}

/*
 * @param {String} successFunc: Callback function for success @param {String}
 * errorFunc: Callback function for error
 */
function userGet(successFunc, errorFunc) {
	var serviceName = "user/get";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json";

	params = securizeForUser(params);

	$.ajax({
		type : "GET",
		url : reqURL,
		data : params,
		dataType : "json",
		success : successFunc,
		error : errorFunc
	});
}

/*
 * @param {String} successFunc: Callback function for success @param {String}
 * errorFunc: Callback function for error
 */
function userUpdatePassword(oldpassword, newpassword, successFunc, errorFunc) {
	var serviceName = "user/updatepassword";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "";
	params += "method=" + "json" + "&newpassword=" + newpassword
			+ "&oldpassword=" + oldpassword;

	params = securizeForUser(params);

	$.ajax({
		type : "POST",
		url : reqURL,
		data : params,
		dataType : "json",
		success : successFunc,
		error : errorFunc
	});
}

/*
 * @param {String} msisdn: 
 * @param {String} name: 
 * @param {string} password:
 * @param {String} captchaid: 
 * @param {String} captcha: 
 * @param {string} noads
 * @param {String} successFunc: Callback function for success 
 * @param {String} errorFunc:
 * Callback function for error
 */
function registerUser(msisdn, name, password, captchaid, captcha, noads, successFunc,
		errorFunc) {
	var serviceName = "user/register";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json" + "&msisdn=" + msisdn + "&name=" + name
			+ "&password=" + password + "&captchaid=" + captchaid + "&captcha="
			+ captcha + "&noads=" + noads;

	$.ajax({
		type : "POST",
		url : reqURL,
		data : params,
		dataType : "json",
		success : successFunc,
		error : errorFunc
	});
}

/*
 * @param {String} msisdn: @param {String} token: @param {String} successFunc:
 * Callback function for success @param {String} errorFunc: Callback function
 * for error
 */
function userValidate(msisdn, token, successFunc, errorFunc) {
	var serviceName = "user/validate";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "autologin=1" + "&method=" + "json" + "&msisdn=" + msisdn
			+ "&token=" + token;

	$.ajax({
		type : "POST",
		url : reqURL,
		data : params,
		dataType : "json",
		success : successFunc,
		error : errorFunc
	});
}

/*
 * @param {String} msisdn: @param {String} captchaid: @param {String} captcha:
 * @param {String} successFunc: Callback function for success @param {String}
 * errorFunc: Callback function for error
 */
function userForgotPassword(msisdn, captchaid, captcha, successFunc, errorFunc) {
	var serviceName = "user/forgotpassword";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json" + "&msisdn=" + msisdn + "&captchaid="
			+ captchaid + "&captcha=" + captcha;

	$.ajax({
		type : "POST",
		url : reqURL,
		data : params,
		dataType : "json",
		success : successFunc,
		error : errorFunc
	});
}

/*
 * @param {String} lat: 
 * @param {String} lon: 
 * @param {string} address: 
 * @param {string} distance:
 * @param {String} successFunc: Callback function for success
 * @param {String} errorFunc: Callback function for error
 */
function userServiceRequest(lat, lon, address, distance, successFunc, errorFunc) {
	var serviceName = "user/servicerequest";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;

	var params = "method=" + "json" + "&lat=" + lat + "&long=" + lon
		+ "&address=" + address;
	if (distance != null) {
		params += "&distance=" + distance;
	}

	var params = securizeForUser(params);

	if (params != null) {
		$.ajax({
			type : "POST",
			url : reqURL,
			data : params,
			dataType : "json",
			success : successFunc,
			error : errorFunc
		});
	} else {
		processNoSessionError();
	}
}

/*
 * @param {String} lat: 
 * @param {String} lon: 
 * @param {string} address: 
 * @param {string} distance:
 * @param {String} successFunc: Callback function for success
 * @param {String} errorFunc: Callback function for error
 */
function userTaxisAroundGet(lat, lon, address, distance, successFunc, errorFunc) {
	var serviceName = "user/taxisaroundget";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;

	var params = "method=" + "json" + "&lat=" + lat + "&long=" + lon
		+ "&address=" + address;
	if (distance != null) {
		params += "&distance=" + distance;
	}

	var params = securizeForUser(params);

	if (params != null) {
		$.ajax({
			type : "POST",
			url : reqURL,
			data : params,
			dataType : "json",
			success : successFunc,
			error : errorFunc
		});
	} else {
		processNoSessionError();
	}
}

/*
 * @param {String} successFunc: Callback function for success @param {String}
 * errorFunc: Callback function for error
 */
function userServiceGet(successFunc, errorFunc) {
	var serviceName = "user/serviceget";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json";

	var params = securizeForUser(params);

	if (params != null) {
		$.ajax({
			type : "GET",
			url : reqURL,
			data : params,
			dataType : "json",
			success : successFunc,
			error : errorFunc
		});
	} else {
		processNoSessionError();
	}
}

/*
 * @param {String} successFunc: Callback function for success @param {String}
 * errorFunc: Callback function for error
 */
function userServiceCancel(successFunc, errorFunc) {
	var serviceName = "user/servicecancel";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json";

	var params = securizeForUser(params);

	if (params != null) {
		$.ajax({
			type : "POST",
			url : reqURL,
			data : params,
			dataType : "json",
			success : successFunc,
			error : errorFunc
		});
	} else {
		processNoSessionError();
	}
}

/*
 * @param {String} successFunc: Callback function for success @param {String}
 * errorFunc: Callback function for error
 */
function userHabitualAddressGet(successFunc, errorFunc) {
	var serviceName = "user/habitualaddressget";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json";

	var params = securizeForUser(params);

	if (params != null) {
		$.ajax({
			type : "GET",
			url : reqURL,
			data : params,
			dataType : "json",
			success : successFunc,
			error : errorFunc
		});
	} else {
		processNoSessionError();
	}
}

/*
 * @param {HabitualAddress(name, address, lat, lon)} habAddress: @param {String}
 * successFunc: Callback function for success @param {String} errorFunc:
 * Callback function for error
 */
function userHabitualAddressAdd(name, address, lat, lon, successFunc, errorFunc) {
	var serviceName = "user/habitualaddressadd";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;

	var params = "method=" + "json" + "&name=" + name + "&address=" + address
			+ "&lat=" + lat + "&long=" + lon;
	/*
	 * var params = "method=" + "json" + "&name=" + $('#newAddressName').val() +
	 * "&address=" + $('#newAddress').val() + "&lat=" +
	 * $('#newAddressLat').val() + "&long=" + $('#newAddressLon').val();
	 */
	var params = securizeForUser(params);

	if (params != null) {
		$.ajax({
			type : "POST",
			url : reqURL,
			data : params,
			dataType : "json",
			success : successFunc,
			error : errorFunc
		});
	} else {
		processNoSessionError();
	}
}

/*
 * @param {String} nameToDelete: @param {String} successFunc: Callback function
 * for success @param {String} errorFunc: Callback function for error
 */
function userHabitualAddressDel(nameToDelete, successFunc, errorFunc) {
	var serviceName = "user/habitualaddressdel";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json";

	params += "&name=" + nameToDelete;

	var params = securizeForUser(params);

	if (params != null) {
		$.ajax({
			type : "POST",
			url : reqURL,
			data : params,
			dataType : "json",
			success : successFunc,
			error : errorFunc
		});
	} else {
		processNoSessionError();
	}
}

/*
 * @param {String} nameToEdit: @param {String} newName: @param {String}
 * successFunc: Callback function for success @param {String} errorFunc:
 * Callback function for error
 */
function userHabitualAddressEdit(nameToEdit, newName, successFunc, errorFunc) {
	var serviceName = "user/habitualaddressedit";
	var reqURL = IP_AND_PORT + "/" + APP_NAME + "/" + serviceName;
	var params = "method=" + "json";

	params += "&name=" + nameToEdit + "&newname=" + newName;

	var params = securizeForUser(params);

	if (params != null) {
		$.ajax({
			type : "POST",
			url : reqURL,
			data : params,
			dataType : "json",
			success : successFunc,
			error : errorFunc
		});
	} else {
		processNoSessionError();
	}
}