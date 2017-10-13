/**
 * @author Wannataxi
 */

$(document).ready(function() {
	//initWebUser();
});

/**
 * ============================================================================
 * TIME AND DISTANCE ESTIMATION
 * Move these functions to wannataxi_commons.js !!!
 * ============================================================================
 */
var EARTH_DIAMETER = Math.PI * 12742000;
var K = EARTH_DIAMETER / 360;

function estimateDistance(lat0, long0, lat1, long1) {
	var difLat = lat0 - lat1;
	var difLong = long0 - long1;
	return parseInt(Math.sqrt(Math.pow((difLat * K), 2)+ Math.pow(difLong * K * Math.cos((lat1 + difLat / 2)*(Math.PI/180)),2)));
}

function getDistanceWithUnits(distance) {
	var distanceLiteral = "";
	
	if (distance < 1000) {
		if (distance < 100) {
			distanceLiteral = "Menos de 100m";
		} else {
			distanceLiteral = parseInt(distance/100) + "00" + " metros";
		}
	} else {
		var distanceKms = parseInt(distance/1000);
		var distanceMeters = distance%1000;
		distanceLiteral =  distanceKms + "," + parseInt(distanceMeters/100) + " km";
	}
	
	return distanceLiteral;
}

function getEstimatedTimeWithUnits(currentEstimatedDistance) {
	var elapsedTime = $('#container').data('serviceElapsedTime');
	if (!elapsedTime) {
		elapsedTime = 0;
		$('#container').data('serviceElapsedTime', elapsedTime);
	}
    var initialServiceDistance = $('#container').data('initialServiceDistance');
    if (!initialServiceDistance) {
    	initialServiceDistance = currentEstimatedDistance;
    	$('#container').data('initialServiceDistance', initialServiceDistance);
	}
	
    var timeEstimation = "";
    if (elapsedTime > 0) {
    	var distanceDifference = initialServiceDistance - currentEstimatedDistance;
    	if (distanceDifference < 0) {
    		distanceDifference = -(distanceDifference);
    	}
    	
    	// Estimation in seconds
    	timeEstimation = (currentEstimatedDistance * elapsedTime) / distanceDifference;
    	// Estimation rounded in minutes
    	timeEstimation = Math.round(parseFloat(timeEstimation/60));
    	
    	if (timeEstimation >= 2) {
    		timeEstimation = timeEstimation + " minutos";
    	} else {
    		timeEstimation = "Menos de 1 min.";
    	}
    	
    } else {
    	timeEstimation = "Calculando...";
    }
    
    return timeEstimation;
}

/**
 * ============================================================================
 * INITIALIZE WEB INTERFACE
 * ============================================================================
 */
function initWebUser(){
    // Mark Warning as not displayed at the beginning
    $('#container').data('warningDisplayed', "false");
    
	// Change body background image
	$('body').css('backgroundImage' ,  "url('" +BACKGROUND_IMAGE_FOR_USER+ "')");
	
	loadLegalTexts();
	
	loadHome();
    
    // Loader for AJAX requests
    $('#loader').hide() // hide it initially
.ajaxStart(function(){
        $(this).show();
    }).ajaxStop(function(){
        $(this).hide();
    });
}

/**
 * ============================================================================
 * FUNCTIONS FOR LOAD SECTIONS; SHOW, HIDE & TOGGLE BLOCKS AND ELEMENTS
 * ============================================================================
 */
function loadHome(){
    // Check whether the USER has an active session or not
   
}

function loadHomeCustomer(){
    // Check whether the USER has an active session or not
    var session = checkData();
    if (session == USER_ACTIVE_SESSION) {
    	loadHomeCustomerWithLoggedUser();
    }
    else {
    	hideAllSections();
        showUserAccess();
		
		loadHomeCustomerNotLogged();
        
    }
}

function loadHomeCustomerNotLogged() {
	//TODO: Complete this function
	
}

function loadCustomerRegister() {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserRegister', 'Load']);
	
	hideAllSections();
	showUserAccess();
	$('#loginRegisterWrapper').load('login_register_customer.html', function(){
        $('#loginRegisterWrapper').show();
        $('#validateUserBox').hide();
        $('#newUserName').focus();
        reloadCaptcha();
		$('#userServiceConditions').load('userServiceConditions.html');		
	});
}

function loadHomeCustomerWithLoggedUser(){
    hideAllSections();
    
// TODO: REview whether this is needed or not, or change it to other function
    $('#RTWrapper').show();
    
    // Initialize stored data in page
    $('#RTWrapper').data('selectedInmediatePickup', null);
    $('#RTWrapper').data('selectedDateTime', null);
    $('#RTWrapper').data('selectedPickupAddress', null);
    $('#RTWrapper').data('selectedPickupLat', null);
    $('#RTWrapper').data('selectedPickupLon', null);
    $('#RTWrapper').data('selectedIsNewAddress', null);
    $('#RTWrapper').data('selectedHasSpecialRequests', null);
    $('#RTWrapper').data('selectedSpecialRequests', null);
	
    showLoggedUser();
	$('#homeWrapper').load('home_customer.html', function() {
		$('#homeWrapper').show();
		$('#newAddress').focus();
		
	    // Display Warning box to users, only the first time
	    if ($('#container').data('warningDisplayed') == "false") {
	    	$('#container').data('warningDisplayed', "true");
	    	$('#warningBox').fadeIn();
	    	// Close Warning Box after 12 seconds = 12000 miliseconds
	        window.setTimeout("$('#warningBox').fadeOut();", 12000);
	    }
	    
	    // Check whether the user has a Service "on going"
		callUserServiceGetForLoadHome();
	});
}

function loadCustomerProfile() {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserProfile', 'Load']);

	hideAllSections();
	
	$('#customerProfileWrapper').load('customer_profile.html', function() {
		$('#customerProfileWrapper').show();
		$('#customerName').html(getData("WT_USER_NAME"));
		$('#customerMsisdn').html(getData("WT_USER_MSISDN"));
		
	});	
}

function callUserServiceGetForLoadHome() {
	userServiceGet(processUserServiceGetForLoadHomeSuccess, processUserServiceGetForLoadHomeError);
}

function processUserServiceGetForLoadHomeSuccess(json, textStatus) {
	var serviceStatus = json.status;

    if (serviceStatus == "NOT_ACCEPT") {
        callUserHabitualAddressGet();
	} else if (serviceStatus == "TAXI_NF") {
		callUserHabitualAddressGet();
    } else {
		processUserServiceGetSuccess(json, textStatus);		
	}
}

function processUserServiceGetForLoadHomeError(xhr, textStatus, errorThrown){
	callUserHabitualAddressGet();
}

function closeUserLoginBox(){
    $('#userLoginBox').hide();
    $('#userLoginErrorInHeaderBox').hide();
    $('#userLoginErrorInHeader').html("");
    $('#userStatusBox').fadeIn();
}

function toggleUserLoginBox(){
    $('#userLoginErrorInHeaderBox').hide();
    $('#userLoginErrorInHeader').html("");
    $('#userStatusBox').toggle();
    $('#userLoginBox').toggle(0, function() {
		$('#userLoginMsisdn').focus();
	});
}

function showUserAccess(){
    $('#userAccess').show();
    $('#loggedUser').hide();
    $('#exitTaxiZone').hide();
}

function hideUserStatusBox(){
    $('#userAccess').hide();
    $('#loggedUser').hide();
    $('#exitTaxiZone').show();
}

function openTaxiLoginBox(){
	window.setTimeout("$('#TDBoxRightTaxiLogin').show();", TIMEOUT_FOR_DATA_LOAD);
    
}

function closeTaxiLoginBox(){
    $('#taxiLoginBox').hide();
    $('#taxiLoginErrorBox').hide();
}

function closeTaxiStatusBox(){
    $('#TDBoxRightTaxiStatus').hide();
}

function hideAllSections(){
    hideAllNotifications();
    $('#loginRegisterWrapper').hide();
    $('#homeWrapper').hide();
    $('#RTWrapper').hide();
	$('#customerProfileWrapper').hide();
    $('#exitTaxiZone').hide();
    $('#userAccess').hide();
    closeUserLoginBox();
}

function hideAllNotifications(){
    $('#taxiError').html("");
    $('#taxiErrorBox').hide();
    $('#requestTaxiError').html("");
    $('#requestTaxiErrorBox').hide();
    $('#registerError').html("");
    $('#registerErrorBox').hide();
    $('#userLoginErrorInBody').html("");
    $('#userLoginErrorInBodyBox').hide();
    $('#addNewHabitualAddressError').html("");
    $('#addNewHabitualAddressErrorBox').hide();
    
    $('#taxiLoginError').html("");
    $('#taxiLoginErrorBox').fadeOut();
    $('#userLoginErrorInHeader').html("");
    $('#userLoginErrorInHeaderBox').fadeOut();
    
}

function toggleUserServiceConditions(){
	$('#userServiceConditionsBox').toggle();
	$('#taxiServiceConditionsBox').hide();
	$('#privacyPolicyBox').hide();
	$('#useConditionsBox').hide();
}

function loadValidateUserLaterBox() {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserValidateLater', 'Load']);
	
	hideAllNotifications();
	$('#loginRegisterBox').hide();
	$('#validateUserLaterBox').show(0, function() {
		$('#newUserMsisdnLater').focus();	
	});
}

function toggleCustomerModifyPasswordBox(){
	$('#customerModifyPasswordBox').slideToggle('slow');
	$('#customerModifyPasswordOpenToggleBar').toggle();
	$('#customerModifyPasswordCloseToggleBar').toggle();
}

/**
 * ============================================================================
 * LOAD SECTION: REQUEST A TAXI (RT)
 * ============================================================================
 */
function appendPickupDateTimeOption(index){
    var todayOrTomorrow = "";
    (index == 0) ? todayOrTomorrow = "Hoy, " : todayOrTomorrow = todayOrTomorrow;
    (index == 1) ? todayOrTomorrow = "Ma&ntilde;ana, " : todayOrTomorrow = todayOrTomorrow;
    
    var currentDateTime = new Date();
    var optionDateTime = new Date();
    optionDateTime.setDate(currentDateTime.getDate() + index);
    
    var weekDay = optionDateTime.getDay();
    (weekDay == 0) ? weekDay = 7 : weekDay = weekDay;// When Sunday
    var year = optionDateTime.getFullYear();
    var month = optionDateTime.getMonth() + 1;
    var day = optionDateTime.getDate();
    
    var weekDayName = "";
    switch (weekDay) {
        case 1:
            weekDayName = "Lunes";
            break;
        case 2:
            weekDayName = "Martes";
            break;
        case 3:
            weekDayName = "Mi&eacute;rcoles";
            break;
        case 4:
            weekDayName = "Jueves";
            break;
        case 5:
            weekDayName = "Viernes";
            break;
        case 6:
            weekDayName = "S&aacute;bado";
            break;
        case 7:
            weekDayName = "Domingo";
            break;
    }
    
    $('#pickupDate').append("<option value='" + day + "/" + month + "/" + year + "'>" +
    todayOrTomorrow +
    weekDayName +
    " " +
    day +
    "/" +
    month +
    "</option>");
}

function loadRequestTaxi(isNewUser){
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserRequestTaxi', 'Load']);
	
    hideAllNotifications();
    
    $('#RTBoxLeft1').load('RequestTaxi.html');
    $('#RTBoxLeft1').show();
    window.setTimeout("$('#pickupDateTimeBox').fadeIn();", TIMEOUT_FOR_DATA_LOAD);
    //$('#RTBoxLeft2').hide();
    //$('#RTBoxLeft3').hide();
    
    // Load dates in dropdown list for pickup date&time selection
    for (var i = 0; i <= PICKUP_DATETIME_NUMBER_OF_OPTIONS; i++) {
        window.setTimeout("appendPickupDateTimeOption(" + i + ");", TIMEOUT_FOR_DATA_LOAD);
    }
    $("#pickupDate option:eq(0)").attr("selected", "selected");
    
    if ($('#RTWrapper').data('selectedIsNewAddress') == "true") {
        window.setTimeout("$('#isNewAddress').val('true');", TIMEOUT_FOR_DATA_LOAD);
        if ($('#RTWrapper').data('selectedPickupAddress')) {
            window.setTimeout("$('#newAddress').val($('#RTWrapper').data('selectedPickupAddress'));", TIMEOUT_FOR_DATA_LOAD);
        }
        if ($('#RTWrapper').data('selectedPickupLat')) {
            window.setTimeout("$('#newAddressLat').val($('#RTWrapper').data('selectedPickupLat'));", TIMEOUT_FOR_DATA_LOAD);
        }
        if ($('#RTWrapper').data('selectedPickupLon')) {
            window.setTimeout("$('#newAddressLon').val($('#RTWrapper').data('selectedPickupLon'));", TIMEOUT_FOR_DATA_LOAD);
        }
    }
    
    if (!isNewUser) {
        window.setTimeout("callUserHabitualAddressGet();", TIMEOUT_FOR_DATA_LOAD);
    }
}

function acceptPickupLocation(){
	var pickupAddress = $('#pickupAddress').val();
	pickupLatitude = $('#pickupAddressLat').val();
	pickuplongitude = $('#pickupAddressLon').val();
	taxiLatitude = null;
	taxiLongitude = null;
	
    $('#RTWrapper').data('selectedPickupAddress', pickupAddress);
    $('#RTWrapper').data('selectedPickupLat', pickupLatitude);
    $('#RTWrapper').data('selectedPickupLon', pickuplongitude);
    $('#RTWrapper').data('selectedIsNewAddress', $('#isNewAddress').val());
    
    window.setTimeout("$('#selectedPickupAddress').html($('#RTWrapper').data('selectedPickupAddress'));", TIMEOUT_FOR_DATA_LOAD);
    window.setTimeout("$('#selectedPickupLat').html($('#RTWrapper').data('selectedPickupLat'));", TIMEOUT_FOR_DATA_LOAD);
    window.setTimeout("$('#selectedPickupLon').html($('#RTWrapper').data('selectedPickupLon'));", TIMEOUT_FOR_DATA_LOAD);
    
	$('#requestTaxiMediumBox').hide();
    $('#habitualAddressesBox').hide();
    
    $('#enSeparator').show();
    $('#ellipsis').hide();
    $('#comfirmRequestTaxiBox').show();
    //$('#cancelTaxiRequestBox').show();
	
	$('#mapForTaxiRequestBox').show();
	$('#map_canvas_for_taxi_request').show(0, function() {
		loadMap('map_canvas_for_taxi_request', pickupLatitude, pickuplongitude, taxiLatitude, taxiLongitude, MAP_LARGE);
		// Search & display number of taxis around this location in the map
		callUserTaxisAroundGet(pickupLatitude, pickuplongitude, pickupAddress, null);
	});
}

/**
 * ============================================================================
 * USER LOGIN
 * ============================================================================
 */
function showLoggedUser(){
	userGet(processUserGetSuccess, processUserGetError);
}

function processUserGetSuccess(json, textStatus) {
	userName = json.name;
	userMsisdn = json.msisdn;
	setData("WT_USER_NAME", userName, 0);
	setData("WT_USER_MSISDN", userMsisdn, 0);
	
	$('#loggedUserName').html(userName);
    $('#loggedUser').fadeIn();
    $('#userAccess').hide();
    $('#exitTaxiZone').hide();
}

function processUserGetError(xhr, textStatus, errorThrown) {
}

function callUserLoginInHeader() {
	if (validateUserLoginInHeader()) {
		msisdn = $('#userLoginMsisdn').val();
		password = $('#userLoginPassword').val();
		rememberUser = $('#userRememberCheckbox:checked').val();
		
		// Google Analytics: track event
		_gaq.push(['_trackEvent', 'UserLoginInHeader', 'Call']);
		
		userLogin(msisdn, password, rememberUser, processUserLoginSuccess, processUserLoginErrorInHeader);
	}
}

function callUserLoginInBody() {
	if (validateUserLoginInBody()) {
		msisdn = $('#userMsisdn').val();
		password = $('#userPassword').val();
		rememberUser = $('#userRememberCheckbox:checked').val();
		
		// Google Analytics: track event
		_gaq.push(['_trackEvent', 'UserLoginInBody', 'Call']);
		
		userLogin(msisdn, password, rememberUser, processUserLoginSuccess, processUserLoginErrorInBody);
	}
}

function validateUserLoginInHeader(){
    var result = true;
    var errorMessage = "";
    $('#userLoginErrorInHeader').html("");
    $('#userLoginErrorInHeaderBox').fadeOut();
    
    var msisdn = $('#userLoginMsisdn').val();
    if (msisdn.length < 1) {
        errorMessage += VAL_ERROR_NO_MSISDN + "<br/>";
        result = false;
    }
    else 
        if (!checkMsisdn(msisdn)) {
            errorMessage += VAL_ERROR_MSISDN_LENGTH + "<br/>";
            result = false;
        }
    var password = $('#userLoginPassword').val();
    if (password.length < 1) {
        errorMessage += VAL_ERROR_NO_PASSWORD + "<br/>";
        result = false;
    }
    else 
        if (!checkPassword(password)) {
            errorMessage += VAL_ERROR_PASSWORD_LENGTH + "<br/>";
            result = false;
        }
    
    if (errorMessage != "") {
        $('#userLoginErrorInHeader').html(errorMessage);
        $('#userLoginErrorInHeaderBox').fadeIn();
    }
    
    return result;
}

function validateUserLoginInBody(){
    var result = true;
    var errorMessage = "";
    $('#userLoginErrorInBody').html("");
    $('#userLoginErrorInBodyBox').fadeOut();
    
    var msisdn = $('#userMsisdn').val();
    if (msisdn.length < 1) {
        errorMessage += VAL_ERROR_NO_MSISDN + "<br/>";
        result = false;
    }
    else 
        if (!checkMsisdn(msisdn)) {
            errorMessage += VAL_ERROR_MSISDN_LENGTH + "<br/>";
            result = false;
        }
    var password = $('#userPassword').val();
    if (password.length < 1) {
        errorMessage += VAL_ERROR_NO_PASSWORD + "<br/>";
        result = false;
    }
    else 
        if (!checkPassword(password)) {
            errorMessage += VAL_ERROR_PASSWORD_LENGTH + "<br/>";
            result = false;
        }
    
    if (errorMessage != "") {
        $('#userLoginErrorInBody').html(errorMessage);
        $('#userLoginErrorInBodyBox').fadeIn();
    }
    
    return result;
}

function processUserLoginSuccess(json, textStatus){
    createUserSession(json.id, json.sessionId, json.sessionSecret, json.expiration);
    toggleUserLoginBox();
//OLD
    //showLoggedUser();
    //loadHomeCustomer();
//NEW
    loadHomeCustomerWithLoggedUser();
//NEW
    
    // If there were a TAXI session then close it
    //deleteTaxiSession();
}

function processUserLoginErrorInHeader(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#userLoginErrorInHeader').html(errorMessage);
    $('#userLoginErrorInHeaderBox').fadeIn();
}

function processUserLoginErrorInBody(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#userLoginErrorInBody').html(errorMessage);
    $('#userLoginErrorInBodyBox').fadeIn();
}

function callUserLogout() {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserLogout', 'Call']);
	
	userLogout(processUserLogoutSuccess, processUserLogoutError);
}

function processUserLogoutSuccess(json, textStatus){
    showNotificationWithTimer(LOGOUT_SUCCESS);
    $('#loggedUser').hide();
    $('#loggedUserName').html("");
	//$(document).stopTime("serviceRequestTimer");
    deleteUserSession();
    loadHome();
}

function processUserLogoutError(xhr, textStatus, errorThrown){
    $('#userLoginErrorInHeaderBox').fadeIn();
    $('#userLoginErrorInHeader').html(textStatus + ": " + errorThrown);
    deleteUserSession();
    loadHome();
}

function callUserModifyPassword() {
	if (validateUserModifyPassword()) {
		oldpassword = $('#oldCustomerPassword').val();
		newpassword = $('#newCustomerPassword').val();

		// Google Analytics: track event
		_gaq.push(['_trackEvent', 'UserHabitualAddressAdd', 'Call']);

		userUpdatePassword(oldpassword, newpassword, processUserModifyPasswordSuccess, processUserModifyPasswordError);
	}
}

function validateUserModifyPassword() {
	var result = true;
    var errorMessage = "";
    $('#modifyPasswordError').html("");
    $('#modifyPasswordErrorBox').fadeOut();

    var pass = $('#oldCustomerPassword').val();
    if (pass.length < 1) {
        errorMessage += VAL_ERROR_NO_CURRENT_PASSWORD + "<br/>";
        result = false;
    }
    
    var pass = $('#newCustomerPassword').val();
    if (pass.length < 1) {
        errorMessage += VAL_ERROR_NO_NEW_PASSWORD + "<br/>";
        result = false;
    }
    else 
        if (pass.length < PASSWORD_MIN | pass.length > PASSWORD_MAX) {
            errorMessage += VAL_ERROR_PASSWORD_LENGTH + "<br/>";
            result = false;
        }
    var rePass = $('#newCustomerRePassword').val();
    if (pass != rePass) {
        errorMessage += VAL_ERROR_PASSWORDS_DONT_MATCH + "<br/>";
        result = false;
    }
    
    if (errorMessage != "") {
        $('#modifyPasswordErrorBox').fadeIn();
        $('#modifyPasswordError').html(errorMessage);
    }
    
    return result;
}

function processUserModifyPasswordSuccess(){
	showNotificationWithTimer(USER_MODIFY_PASSWORD_SUCCESS);
	toggleCustomerModifyPasswordBox();
	$('#customerModifyPasswordForm').each (function(){
	  this.reset();
	});
} 

function processUserModifyPasswordError() {
	var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#modifyPasswordError').html(errorMessage);
    $('#modifyPasswordErrorBox').fadeIn();	
}


/**
 * ============================================================================
 * USER REGISTRATION
 * ============================================================================
 */
function toggleUserServiceConditions(){
    $('#userServiceConditionsBox').slideToggle("slow");
}

function validateUserRegister(){
    var result = true;
    var errorMessage = "";
    $('#registerError').html("");
    $('#registerErrorBox').fadeOut();
    
    var msisdn = $('#email').val();
    if (msisdn.length < 1) {
        errorMessage += VAL_ERROR_NO_EMAIL + "<br/>";
        result = false;
    }
    else 
        if (!checkEmail(msisdn)) {
            errorMessage += VAL_ERROR_INCORRECT_EMAIL + "<br/>";
            result = false;
        }
    var pass = $('#password').val();
    if (pass.length < 1) {
        errorMessage += VAL_ERROR_NO_PASSWORD + "<br/>";
        result = false;
    }
    else 
        if (pass.length < PASSWORD_MIN | pass.length > PASSWORD_MAX) {
            errorMessage += VAL_ERROR_PASSWORD_LENGTH + "<br/>";
            result = false;
        }
    var rePass = $('#password2').val();
    if (pass != rePass) {
        errorMessage += VAL_ERROR_PASSWORDS_DONT_MATCH + "<br/>";
        result = false;
    }
   
    var conditionsAccepted = $('#serviceConditionsAccepted:checked').val();
    if (conditionsAccepted == null) {
        errorMessage += VAL_ERROR_CONDITIONS_NOT_ACCEPTED + "<br/>";
        result = false;
    }
    
    if (errorMessage != "") {
        $('#registerErrorBox').fadeIn();
        $('#registerError').html(errorMessage);
    }
    
    return result;
}

function callUserRegister() {
	if (validateUserRegister()) {
		msisdn = $('#newUserMsisdn').val();
    	password = $('#newUserPassword').val();
		noads = $('#noads:checked').val();
		if (noads == null) {
			noads = "0";
		} else {
			noads = "1";
		}
		
		// Google Analytics: track event
		_gaq.push(['_trackEvent', 'UserRegister', 'Call']);
		 document.forms["userRegisterForm"].submit();
		//registerUser(msisdn, name, password, , noads, userRegisterSuccess, userRegisterError);
	}
}

function backToUserRegister(){
    $('#validateUserBox').hide();
    $('#validateUserLaterBox').hide();
    $('#loginRegisterBox').fadeIn();
}

function userRegisterSuccess(json, textStatus){
    $('#loginRegisterBox').hide();
    $('#validateUserBox').show();
	window.setTimeout("$('#validationCode').focus();", TIMEOUT_FOR_DATA_LOAD);
    window.setTimeout("$('#newUserNameSpan').html($('#newUserName').val());", TIMEOUT_FOR_DATA_LOAD);
    window.setTimeout("$('#newUserMsisdnSpan').html($('#newUserMsisdn').val());", TIMEOUT_FOR_DATA_LOAD);
}

function userRegisterError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#registerError').html(errorMessage);
    $('#registerErrorBox').fadeIn();
    
    reloadCaptcha();
}

function callUserValidate() {
	if (validateUserValidate()) {
		msisdn =  $('#newUserMsisdn').val();
    	token = $('#validationCode').val();
		
		// Google Analytics: track event
		_gaq.push(['_trackEvent', 'UserValidate', 'Call']);
		
		userValidate(msisdn, token, processUserValidateSuccess, processUserValidateError);
	}
}

function validateUserValidate(){
    var result = true;
    var errorMessage = "";
    $('#validateRegisterError').html("");
    $('#validateRegisterErrorBox').fadeOut();
    
    var validationCode = $('#validationCode').val();
    if (validationCode == "") {
        errorMessage += VAL_ERROR_NO_VALIDATION_CODE + "<br/>";
        result = false;
    }
    else 
        if (validationCode.length != VALIDATION_TOKEN_MIN) {
            errorMessage += VAL_ERROR_VALIDATION_CODE_LENGTH + "<br/>";
            result = false;
        }
    
    if (errorMessage != "") {
        $('#validateRegisterErrorBox').fadeIn();
        $('#validateRegisterError').html(errorMessage);
    }
    
    return result;
}

function callUserValidateLater() {
	if (validateUserValidateLater()) {
		msisdn =  $('#newUserMsisdnLater').val();
    	token = $('#validationCodeLater').val();
		userValidate(msisdn, token, processUserValidateSuccess, processUserValidateLaterError);
	}
}

function validateUserValidateLater(){
    var result = true;
    var errorMessage = "";
    $('#validateRegisterLaterError').html("");
    $('#validateRegisterLaterErrorBox').fadeOut();

	var newUserMsisdnLater = $('#newUserMsisdnLater').val();
    if (newUserMsisdnLater == "") {
        errorMessage += VAL_ERROR_NO_MSISDN + "<br/>";
        result = false;
    }
    else 
        if (newUserMsisdnLater.length < MSISDN_MIN | newUserMsisdnLater.length > MSISDN_MAX) {
            errorMessage += VAL_ERROR_MSISDN_LENGTH + "<br/>";
            result = false;
        }
    
    var validationCodeLater = $('#validationCodeLater').val();
    if (validationCodeLater == "") {
        errorMessage += VAL_ERROR_NO_VALIDATION_CODE + "<br/>";
        result = false;
    }
    else 
        if (validationCodeLater.length != VALIDATION_TOKEN_MIN) {
            errorMessage += VAL_ERROR_VALIDATION_CODE_LENGTH + "<br/>";
            result = false;
        }
    
    if (errorMessage != "") {
        $('#validateRegisterLaterErrorBox').fadeIn();
        $('#validateRegisterLaterError').html(errorMessage);
    }
    
    return result;
}

function processUserValidateSuccess(json, textStatus){
    // Cookies will expire with the session
    var expires = 0;
    createUserSession(json.id, json.sessionId, json.sessionSecret, expires);
//OLD
    //showLoggedUser();
    //loadHomeCustomer();
//NEW
    loadHomeCustomerWithLoggedUser();
//NEW    
    
    showNotificationWithTimer(VALIDATION_CODE_SUCCESS);
}

function processUserValidateError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#validateRegisterError').html(errorMessage);
    $('#validateRegisterErrorBox').fadeIn();
}

function processUserValidateLaterError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#validateRegisterLaterError').html(errorMessage);
    $('#validateRegisterLaterErrorBox').fadeIn();
}

/**
 * ============================================================================
 * USER REMEMBER PASSWORD
 * ============================================================================
 */
function validateUserRememberPassword(){
    var result = true;
    var errorMessage = "";
    $('#userRememberPasswordError').html("");
    $('#userRememberPasswordErrorBox').fadeOut();
    

    var msisdn = $('#rememberPasswordMsisdn').val();
    if (msisdn.length < 1) {
        errorMessage += VAL_ERROR_NO_MSISDN + "<br/>";
        result = false;
    }
    else 
        if (msisdn.length < MSISDN_MIN | msisdn.length > MSISDN_MAX) {
            errorMessage += VAL_ERROR_MSISDN_LENGTH + "<br/>";
            result = false;
        }
    
    var captcha = $('#rememberPasswordCaptcha').val();
    if (captcha.length < 1) {
        errorMessage += VAL_ERROR_NO_CAPTCHA + "<br/>";
        result = false;
    }
    else 
        if (captcha.length < CAPTCHA_MIN) {
            errorMessage += VAL_ERROR_CAPTCHA_LENGTH + "<br/>";
            result = false;
        }
    
    if (errorMessage != "") {
        $('#userRememberPasswordErrorBox').fadeIn();
        $('#userRememberPasswordError').html(errorMessage);
    }
    
    return result;
}

function callUserRememberPassword() {
	if (validateUserRememberPassword()) {
		msisdn = $('#rememberPasswordMsisdn').val();
   		captchaid = $('#rememberPasswordCaptchaid').val();
    	captcha = $('#rememberPasswordCaptcha').val();
		
		// Google Analytics: track event
		_gaq.push(['_trackEvent', 'UserRememberPassword', 'Call']);
		
		userForgotPassword(msisdn, captchaid, captcha, userRememberPasswordSuccess, userRememberPasswordError);
	}
}

function userRememberPasswordSuccess(json, textStatus){
    $('#userRememberPasswordBox').hide();
    disablePopup();
    
    showNotificationWithTimer(USER_REMEMBER_PASSWORD_SUCCESS);
}

function userRememberPasswordError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#userRememberPasswordError').html(errorMessage);
    $('#userRememberPasswordErrorBox').fadeIn();
    
    reloadRememberPasswordCaptcha();
}

/**
 * ============================================================================
 * REQUEST TAXI
 * ============================================================================
 */
function callUserServiceRequest() {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserServiceRequest', 'Call']);
	
	$('#requestTaxiError').html("");
    $('#requestTaxiErrorBox').hide();

	/*
	// Hide warning box
	$('#warningBox').hide();
	// Hide taxis around info box
	$('#taxisAroundBox').hide();
	*/
	
    var lat = $('#RTWrapper').data('selectedPickupLat');
    var lon = $('#RTWrapper').data('selectedPickupLon');
	var address = $('#RTWrapper').data('selectedPickupAddress');
	var distance = null;
	userServiceRequest(lat, lon, address, distance, processUserServiceGetSuccess, processServiceRequestError);
}

function processServiceRequestError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
	
	$('#requestTaxiError').html(errorMessage);
	$('#requestTaxiErrorBox').fadeIn();
	
	taxiNotFoundForService();
}

function checkTaxiAssigned(i){
    if (i > TIMES_FOR_SERVICE_REQUEST_TIMER) {
        taxiNotFoundForService();
    }
    else {
        callUserServiceGet();
    }
}

function taxiNotFoundForService(){
    $('#searchingTaxiBox').hide();
}

function callUserServiceGet() {
	userServiceGet(processUserServiceGetSuccess, processServiceRequestError)
}

function processUserServiceGetSuccess(json, textStatus){
	
	// Hide warning box
	$('#warningBox').hide();
	// Hide taxis around info box
	$('#taxisAroundBox').hide();
	
    var serviceStatus = json.status;
    // When there is a service Cancelled by User then do nothing
    if (serviceStatus == "CANCEL_U") {
        $(document).stopTime("refreshTaxiPositionTimer");
		$('#requestTaxiError').html(SERVICE_CANCELLED_BY_USER);
    	$('#requestTaxiErrorBox').show();
		//$('#acceptMessageBox').show();
    } else { // In any other service status show Service data
	    $('#requestTaxiMediumBox').hide();
	    $('#habitualAddressesBox').hide();
		$('#ellipsis').hide();
		$('#enSeparator').show();
		$('#selectedPickupAddress').html(json.pickuppoint.address);
    }
    if (serviceStatus == "NOT_ACCEPT") {
        //$(document).stopTime("serviceRequestTimer");
		
		//TODO: Mostrar un mensaje de error en este caso
		$('#requestTaxiError').html(ERROR_20_TAXI_NOT_FOUND);
		$('#requestTaxiErrorBox').fadeIn();
		$('#acceptMessageBox').show();
		
		taxiNotFoundForService();
        //$('#cancelTaxiRequestBox').show();
	} else if (serviceStatus == "TAXI_NF") {
		$('#requestTaxiError').html(ERROR_20_TAXI_NOT_FOUND);
		$('#requestTaxiErrorBox').fadeIn();
		$('#acceptMessageBox').show();
		
		taxiNotFoundForService();
    } else if (serviceStatus == "SEARCHING") {
        $('#searchingTaxiBox').show();

		//$('#specialRequestsBox').hide();
        
        $('#comfirmRequestTaxiBox').hide();
		//$('#cancelTaxiRequestBox').hide();
        
        $(document).oneTime(INTERVAL_FOR_SERVICE_REQUEST_TIMER, "serviceRequestTimer", function(i){
            checkTaxiAssigned(i);
		});
        //}, TIMES_FOR_SERVICE_REQUEST_TIMER);
        
        // While searching store service elapsed time to zero
        $('#container').data('serviceElapsedTime', 0);
        // While searching store service distance to zero
        $('#container').data('serviceDistance', 0);
    } else if (serviceStatus == "ASSIGNED") {
		var taxiStatus = json.taxi.status;
		$('#taxiStatusSpan').html(taxiStatus);
		
        $('#searchingTaxiBox').hide();
		$('#mapForTaxiRequestBox').hide();
		$('#requestTaxiMediumBox').hide();
    	$('#habitualAddressesBox').hide();
        
		$('#taxiFoundForServiceBox').show();
        
		// Taxi driver's MSISDN
		// Temporarily we are not going to show it
        //$('#taxiMsisdnSpan').html(json.taxi.msisdn);
        
     	// Taxi driver's Name
        $('#taxiNameSpan').html(json.taxi.name);
        
        // Taxi's License
        var taxiLicense = json.taxi.license;
        if (taxiLicense == "" || taxiLicense == null) {
        	$('#taxiInformationLicense').hide();
        } else {
        	$('#taxiLicenseSpan').html(taxiLicense);
        	$('#taxiInformationLicense').show();
        }
        
        // Taxi's vehicle brand & model
        var taxiBrand = json.taxi.car.brand;
        var taxiModel = json.taxi.car.model;
        var taxiCarBrandModel = "";
        if (taxiBrand != "" && taxiBrand != null) {
        	taxiCarBrandModel = taxiBrand + " ";
        }
        if (taxiModel != "" && taxiModel != null) {
        	taxiCarBrandModel = taxiCarBrandModel + taxiModel;
        }
        if (taxiCarBrandModel == "" || taxiCarBrandModel == null) {
        	$('#taxiInformationCarBrandModel').hide();
        } else {
        	$('#taxiCarBrandModelSpan').html(taxiCarBrandModel);
        	$('#taxiInformationCarBrandModel').show();
        }
        
        // Taxi's car plate
        var taxiCarPlate = json.taxi.car.plate;
        if (taxiCarPlate == "" || taxiCarPlate == null) {
        	$('#taxiInformationCarPlate').hide();
        } else {
        	$('#taxiCarPlateSpan').html(taxiCarPlate);
        	$('#taxiInformationCarPlate').show();
        }
        
        $('#taxiInformationBox').show();
        
        var taxiLatitude = json.taxi.location.latitude;
        var taxiLongitude = json.taxi.location.longitude;
        var pickupLatitude = json.pickuppoint.latitude;
        var pickuplongitude = json.pickuppoint.longitude;
        
        // Store service distance and service initial distance in meters in "container", only the first time
        if ($('#container').data('serviceDistance') == 0) {
        	var initialServiceDistance = estimateDistance(taxiLatitude, taxiLongitude, pickupLatitude, pickuplongitude);
        	$('#container').data('serviceDistance', initialServiceDistance);
        	$('#container').data('initialServiceDistance', initialServiceDistance);
        }
        
        $('#map_canvas_for_service').show(0, function() {
			loadMap('map_canvas_for_service', pickupLatitude, pickuplongitude, taxiLatitude, taxiLongitude, MAP_LARGE);
		});
		
		if (taxiStatus == "INCO" || taxiStatus == "ON") {
			$(document).oneTime(INTERVAL_FOR_REFRESH_TAXI_POSITION, "refreshTaxiPositionTimer", function(){
				// Add time in seconds to service elapsed time
				var elapsedTime = $('#container').data('serviceElapsedTime');
				if (!elapsedTime) {
					elapsedTime = 0;
				}
				
				elapsedTime = elapsedTime + (INTERVAL_FOR_REFRESH_TAXI_POSITION/1000);
				// Store service elapsed time in seconds in "container"
				$('#container').data('serviceElapsedTime', elapsedTime);
            	
				callUserServiceGet();
        	});
			
			$('#taxiWaitingBox').hide();
			$('#taxiWaitingIconBox').hide();
			$('#taxiIncomingBox').show();
			$('#taxiIncomingIconBox').show();
			$('#taxiPositionInformationBox').show();
		} else if (taxiStatus == "WAIT") {
			$('#taxiWaitingBox').show();
			$('#taxiWaitingIconBox').show();
			$('#finishServiceBox').show();
			$('#taxiIncomingBox').hide();
			$('#taxiIncomingIconBox').hide();
			$('#taxiPositionInformationBox').hide();
			$('#cancelTaxiBox').hide();
		}
    } else if (serviceStatus == "CANCEL_T") {
		$(document).stopTime("refreshTaxiPositionTimer");
		$('#requestTaxiError').html(SERVICE_CANCELLED_BY_TAXI);
    	$('#requestTaxiErrorBox').show();
		$('#acceptMessageBox').show();
		$('#cancelTaxiBox').hide();
	}
}

function callUserServiceCancel() {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserServiceCancel', 'Call']);
	
	userServiceCancel(processUserServiceCancelSuccess, processServiceRequestError);
}

function processUserServiceCancelSuccess(json, textStatus){
    $(document).stopTime("serviceRequestTimer");
    showNotificationWithTimer(SERVICE_CANCELLED_WITH_SUCESS);
    loadHomeCustomer();
}

/**
 * ============================================================================
 * USER: GET TAXIS AROUND
 * ============================================================================
 */
function callUserTaxisAroundGet(lat, lon, address, distance) {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserTaxisAroundGet', 'Call']);
	
	userTaxisAroundGet(lat, lon, address, distance, processUserTaxisAroundGetSuccess, processUserTaxisAroundGetError);
}

function processUserTaxisAroundGetError(xhr, textStatus, errorThrown){
	$('#taxisAroundInnerBox').addClass("bgRed");
	$('#taxisAroundInnerBox').removeClass("bgWhite");
	$('#taxisAroundNumber').addClass("whiteExtraLarge");
	$('#taxisAroundNumber').removeClass("greenExtraLarge");
	$('#taxisAroundNumber').html("0");
	
}

function processUserTaxisAroundGetSuccess(json, textStatus) {
	var countTaxisAround = json.taxi.length;
	
	if (countTaxisAround > 0) {
		$('#taxisAroundInnerBox').addClass("bgWhite");
		$('#taxisAroundInnerBox').removeClass("bgRed");
		$('#taxisAroundNumber').addClass("greenExtraLarge");
		$('#taxisAroundNumber').removeClass("whiteExtraLarge");
	} else {
		$('#taxisAroundInnerBox').addClass("bgRed");
		$('#taxisAroundInnerBox').removeClass("bgWhite");
		$('#taxisAroundNumber').addClass("whiteExtraLarge");
		$('#taxisAroundNumber').removeClass("greenExtraLarge");
	}
	$('#taxisAroundNumber').html(countTaxisAround);
}

/**
 * ============================================================================
 * HABITUAL ADDRESSES
 * ============================================================================
 */
function callUserHabitualAddressGet() {
	userHabitualAddressGet(processUserHabitualAddressGetSuccess, processServiceRequestError);
}


function processUserHabitualAddressGetSuccess(json, textStatus){
    var arrayHabitualAddresses = new Array();
    arrayHabitualAddresses = extractHabitualAddresses(json, textStatus);
    
    var content = "";
    var emptyList = true;
    for (index in arrayHabitualAddresses) {
        if (emptyList) {
            emptyList = false;
            content = "";
        }
        var name = arrayHabitualAddresses[index].name;
        var shortName = constrain(arrayHabitualAddresses[index].name, 210, 'blackBold');
        var address = arrayHabitualAddresses[index].address;
        var shortAddress = constrain(arrayHabitualAddresses[index].address, 780, 'small');
        var lat = arrayHabitualAddresses[index].lat;
        var lon = arrayHabitualAddresses[index].lon;
        
        content += "<a name='aUserHabitualAddress' href='#'>" +
        "<div name='userHabitualAddress' class='address'>" +
        "<span class='blackBold'>" +
        shortName +
        "</span>&nbsp;<span class='small'>" +
        shortAddress +
        "</span>" +
        "</div>" +
        "</a>" +
        "<div id='RTdelHabitualAddress" +
        index +
        "' class='dropDownField' style='display:none'>" +
        "&iquest;Seguro que quieres borrar esta direcci&oacute;n?&nbsp;" +
        "<a href='#' onclick='javascript:confirmUserHabitualAddressDel(" +
        index +
        ");' class='small darkgrey nicebutton'>S&iacute;</a>&nbsp;" +
        "<a href='#' onclick='javascript:toggleUserHabitualAddressDel(" +
        index +
        ");' class='small darkgrey nicebutton'>No</a>" +
        "</div>" +
        "<div id='userHabitualAddressEdit" +
        index +
        "' class='dropDownField' style='display:none'>" +
        "Puedes cambiar el nombre de esta direcci&oacute;n habitual&nbsp;" +
        "<input type='text' id='userHabitualAddressEditNewName" +
        index +
        "' class='textFieldMedium' value='" +
        name +
        "'/>&nbsp;" +
        "<a href='#' onclick='javascript:confirmUserHabitualAddressEdit(" +
        index +
        ");' class='small darkgrey nicebutton'>Guardar</a>&nbsp;" +
        "<a href='#' onclick='javascript:toggleUserHabitualAddressEdit(" +
        index +
        ");' class='small darkgrey nicebutton'>Cancelar</a>" +
        "</div>" +
        "<input type='hidden' id='habitualAddress" +
        index +
        "' value='" +
        address +
        "'>" +
        "<input type='hidden' id='habitualAddressName" +
        index +
        "' value='" +
        name +
        "'>" +
        "<input type='hidden' id='habitualAddressLat" +
        index +
        "' value='" +
        lat +
        "'>" +
        "<input type='hidden' id='habitualAddressLon" +
        index +
        "' value='" +
        lon +
        "'>";
    }
    
    if (emptyList) {
        content = "<br />" + "<span class='blackBold'>" +
        HABITUAL_ADDRESS_EMPTY_LIST +
        "</span>" +
        HABITUAL_ADDRESS_INFO_MESSAGE;
        $('#manageHabitualAddressesBox').hide();
        $('#endManageHabitualAddressesBox').hide();
        $('#editHabitualAddressesBox').hide();
        $('#endEditHabitualAddressesBox').hide();
    }
    else {
        $('#manageHabitualAddressesBox').show();
        $('#endManageHabitualAddressesBox').hide();
        $('#editHabitualAddressesBox').show();
        $('#endEditHabitualAddressesBox').hide();
    }
    
    $('#habitualAddressesBox').html(content);
    
    var index = 0;
    $("a[name^='aUserHabitualAddress']").each(function(){
        var $this = $(this);
        var code = "selectHabitualAddress(" + index + ");return false;";
        var handler = new Function(code);
        $this.attr('onclick', '').click(handler);
        index++;
    });
}

function extractHabitualAddresses(json, textStatus){
    var arrayHabitualAddresses = new Array();
    
    for (var i = 0, l = json.habitualaddress.length; i < l; ++i) {
        var name = json.habitualaddress[i].name;
        var address = json.habitualaddress[i].address;
        var lat = json.habitualaddress[i].lat;
        var lon = json.habitualaddress[i].lon;
        
        arrayHabitualAddresses[i] = new HabitualAddress(name, address, lat, lon);
    }
    
    return arrayHabitualAddresses;
}

function selectHabitualAddress(index){
    hideAllNotifications();
    $('#isNewAddress').val('false');
    $('#pickupAddress').val($('#habitualAddress' + index).val());
    $('#pickupAddressLat').val($('#habitualAddressLat' + index).val());
    $('#pickupAddressLon').val($('#habitualAddressLon' + index).val());
    acceptPickupLocation();
}

function selectHabitualAddressForQuickTaxi(index){
    //loadRTCommonParts();
    hideAllNotifications();
    hideAllSections();
    
    $('#RTWrapper').show();
    
    $('#RTBoxLeft1').load('RequestTaxi.html');
    $('#RTBoxLeft1').show();
    //$('#RTBoxLeft2').hide();
    //$('#RTBoxLeft3').hide();
    
    $('#RTWrapper').data('selectedInmediatePickup', 'true');
    $('#RTWrapper').data('selectedDateTime', '');
    $('#RTWrapper').data('selectedPickupAddress', $('#habitualAddressForQuickTaxi' + index).val());
    $('#RTWrapper').data('selectedPickupLat', $('#habitualAddressLatForQuickTaxi' + index).val());
    $('#RTWrapper').data('selectedPickupLon', $('#habitualAddressLonForQuickTaxi' + index).val());
    $('#RTWrapper').data('selectedIsNewAddress', 'false');
    $('#RTWrapper').data('selectedHasSpecialRequests', 'false');
    $('#RTWrapper').data('selectedSpecialRequests', WITHOUT_SPECIAL_REQUESTS);
    
    window.setTimeout(function(){
        $('#requestTaxiInfoBox').show();
        
        $('#selectedPickupTime').html(PICKUP_TIME_INMEDIATE);
        $('#enSeparator').show();
        $('#ellipsis').hide();
        $('#selectedPickupAddress').html($('#RTWrapper').data('selectedPickupAddress'));
        $('#selectedPickupLat').html($('#RTWrapper').data('selectedPickupLat'));
        $('#selectedPickupLon').html($('#RTWrapper').data('selectedPickupLon'));
        
        $('#selectedSpecialRequests').html($('#RTWrapper').data('selectedSpecialRequests'));
        $('#selPickupDateTimeBox').show();
        $('#selPickupLocationBox').show();
        $('#selSpecialRequestsBox').show();
        $('#comfirmRequestTaxiBox').show();
    }, TIMEOUT_FOR_DATA_LOAD);
    
}

function selectNewAddress(index){
    $('#newAddress').val($('#newAddress' + index).val());
    $('#newAddressLat').val($('#newAddressLat' + index).val());
    $('#newAddressLon').val($('#newAddressLon' + index).val());
    
    $('#pickupAddress').val($('#newAddress' + index).val());
    $('#pickupAddressLat').val($('#newAddressLat' + index).val());
    $('#pickupAddressLon').val($('#newAddressLon' + index).val());
    
    processNewAddress();
}

function processNewAddress(){
	// Clean error messages
	$('#requestTaxiError').html("");
	$('#requestTaxiErrorBox').hide();
	
    if ($('#addToHabitual:checked').val() != null) {
        if (validateUserHabitualAddressAdd()) {
            var name = $('#newAddressName').val();
            var address = $('#newAddress').val();
            var lat = $('#newAddressLat').val();
            var lon = $('#newAddressLon').val();
            
            $('#pickupAddress').val(address);
            $('#pickupAddressLat').val(lat);
            $('#pickupAddressLon').val(lon);
            $('#isNewAddress').val('true');
            
            callUserHabitualAddressAdd(name, address, lat, lon, processAddNewHabitualAddressAndSelectSuccess, processAddNewHabitualAddressError);
        
			acceptPickupLocation();
		    
            $('#newAddressName').toggle();
            $('#addToHabitualBox').hide();
        }
    }
    else {
		$('#pickupAddress').val($('#newAddress').val());
        $('#pickupAddressLat').val($('#newAddressLat').val());
        $('#pickupAddressLon').val($('#newAddressLon').val());
        $('#isNewAddress').val('true');
        acceptPickupLocation();
    }
}

function chooseNewAddressFromList(index){
    $('#newAddress').val($('#newAddress' + index).val());
    $('#newAddressLat').val($('#newAddressLat' + index).val());
    $('#newAddressLon').val($('#newAddressLon' + index).val());
    
    $('#pickupAddress').val($('#newAddress' + index).val());
    $('#pickupAddressLat').val($('#newAddressLat' + index).val());
    $('#pickupAddressLon').val($('#newAddressLon' + index).val());
    
    searchAddress();
}

function searchAddress(){
	searchLocations("map_canvas", $('#newAddress').val());
}

function callUserHabitualAddressAdd(name, address, lat, lon, successFun, errorFun) {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserHabitualAddressAdd', 'Call']);
	
	userHabitualAddressAdd(name, address, lat, lon, successFun, errorFun);
	
}

function validateUserHabitualAddressAdd(){
    var result = true;
    var errorMessage = "";
    $('#requestTaxiError').html("");
    $('#requestTaxiErrorBox').fadeOut();
    
    var addressName = $('#newAddressName').val();
    if (addressName.length < 1) {
        errorMessage += VAL_ERROR_NO_NEW_ADDRESS_NAME + "<br/>";
        result = false;
    }
    else 
        if (!checkAddressName(addressName)) {
            errorMessage += VAL_ERROR_NEW_ADDRESS_NAME + "<br/>";
            result = false;
        }

    if (errorMessage != "") {
        $('#requestTaxiErrorBox').fadeIn();
        $('#requestTaxiError').html(errorMessage);
    }
    
    return result;
}

function processUserHabitualAddressAddSuccess(json, textStatus){
    showNotificationWithTimer(HABITUAL_ADDRESS_ADDED_WITH_SUCCESS);
    
    $('input[name=addToHabitual]').attr('checked', false);
    $('#newAddressNameBox').toggle();
    
    acceptPickupLocation();
}

function processUserHabitualAddressAddError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#habitualAddressesError').html(errorMessage);
    $('#habitualAddressesErrorBox').fadeIn();
}

/**
 * ============================================================================
 * HABITUAL ADDRESSES MANAGEMENT
 * ============================================================================
 */
function resetManagementTabs(){
    $('div[id=tabEditBg]').removeClass('green').addClass('greybeige');
    $('#tabEditArrow').hide();
    $('div[id=tabDeleteBg]').removeClass('green').addClass('greybeige');
    $('#tabDeleteArrow').hide();
    $('div[id=tabAddBg]').removeClass('green').addClass('greybeige');
    $('#tabAddArrow').hide();
    
    deactivateEditHabitualAddress();
    deactivateDeleteHabitualAddress();
    
    $('#requestTaxiUpperBox').hide();
    $('#requestTaxiMediumBox').hide();
    $('#requestTaxiBottomBox').hide();
    $('#addNewHabitualAddressesBox').hide();
    $('#habitualAddressesBox').show();
    $('#habitualAddressesManagementBox').show();
	
	//Clean error messages for habitual addresses
	$('#habitualAddressesError').html("");
    $('#habitualAddressesErrorBox').hide();
	$('#addNewHabitualAddressError').html("");
    $('#addNewHabitualAddressErrorBox').hide();
}

function enableEditHabitualAddresses(){
    resetManagementTabs();
    
    $('div[id=tabEditBg]').removeClass('greybeige').addClass('green');
    $('#tabEditArrow').show();
    
    activateEditHabitualAddress();
}

function enableDeleteHabitualAddresses(){
    resetManagementTabs();
    
    $('div[id=tabDeleteBg]').removeClass('greybeige').addClass('green');
    $('#tabDeleteArrow').show();
    
    activateDeleteHabitualAddress();
    
}

function enableAddHabitualAddresses(){
    resetManagementTabs();
    
    $('div[id=tabAddBg]').removeClass('greybeige').addClass('green');
    $('#tabAddArrow').show();
    
    $('#addNewHabitualAddressesBox').show();
    $('#habitualAddressesBox').hide();
	
	$('#newAddressToAddHabitual').focus();
}


/**
 * ============================================================================
 * DELETE HABITUAL ADDRESS IN REQUEST TAXI
 * ============================================================================
 */
function activateDeleteHabitualAddress(){
    $('div[name=userHabitualAddress]').removeClass('address').addClass('addressDelete');
    
    var index = 0;
    $("a[name^='aUserHabitualAddress']").each(function(){
        var $this = $(this);
        var code = "toggleUserHabitualAddressDel(" + index + ");return false;";
        var handler = new Function(code);
        $this.unbind('click');
        $this.attr('onclick', '').click(handler);
        index++;
    });
    
    $('#manageHabitualAddressesBox').hide();
    $('#endManageHabitualAddressesBox').show();
    $('#editHabitualAddressesBox').hide();
    $('#endEditHabitualAddressesBox').hide();
}

function deactivateDeleteHabitualAddress(){
    $('div[name=userHabitualAddress]').removeClass('addressDelete').addClass('address');
    
    var index = 0;
    $("a[name^='aUserHabitualAddress']").each(function(){
        var $this = $(this);
        var code = "selectHabitualAddress(" + index + ");return false;";
        var handler = new Function(code);
        $this.unbind('click');
        $this.attr('onclick', '').click(handler);
        index++;
    });
    
    $("div[id^='RTdelHabitualAddress']").each(function(){
        $(this).hide();
    });
    
    $('#manageHabitualAddressesBox').show();
    $('#endManageHabitualAddressesBox').hide();
    $('#editHabitualAddressesBox').show();
    $('#endEditHabitualAddressesBox').hide();
}

function toggleUserHabitualAddressDel(index){
    $('#RTdelHabitualAddress' + index).slideToggle("slow");
}

function confirmUserHabitualAddressDel(indexAddressToDelete){
    $('#RTAddressToDelete').val($('#habitualAddressName' + indexAddressToDelete).val());
    window.setTimeout("callUserHabitualAddressDel();", TIMEOUT_FOR_DATA_LOAD);
}

function callUserHabitualAddressDel() {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserHabitualAddressDel', 'Call']);
	
	var nameToDelete = $('#RTAddressToDelete').val();
	userHabitualAddressDel(nameToDelete, processUserHabitualAddressDelSuccess, processUserHabitualAddressDelError);
}

function processUserHabitualAddressDelSuccess(json, textStatus){
    $('#RTAddressToDelete').val("");
    showNotificationWithTimer(HABITUAL_ADDRESS_DELETED_WITH_SUCCESS);
    
    callUserHabitualAddressGet();
    window.setTimeout("enableDeleteHabitualAddresses();", TIMEOUT_FOR_DATA_LOAD);
}

function processUserHabitualAddressDelError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#habitualAddressesError').html(errorMessage);
    $('#habitualAddressesErrorBox').fadeIn();
}

/**
 * ============================================================================
 * EDIT HABITUAL ADDRESS IN REQUEST TAXI
 * ============================================================================
 */
function activateEditHabitualAddress(){
    $('div[name=userHabitualAddress]').removeClass('address').addClass('addressEdit');
    
    var index = 0;
    $("a[name^='aUserHabitualAddress']").each(function(){
        var $this = $(this);
        var code = "toggleUserHabitualAddressEdit(" + index + ");return false;";
        var handler = new Function(code);
        $this.unbind('click');
        $this.attr('onclick', '').click(handler);
        index++;
    });
}

function deactivateEditHabitualAddress(){
    $('div[name=userHabitualAddress]').removeClass('addressEdit').addClass('address');
    
    var index = 0;
    $("a[name^='aUserHabitualAddress']").each(function(){
        var $this = $(this);
        var code = "selectHabitualAddress(" + index + ");return false;";
        var handler = new Function(code);
        $this.unbind('click');
        $this.attr('onclick', '').click(handler);
        index++;
    });
    
    $("div[id^='userHabitualAddressEdit']").each(function(){
        $(this).hide();
    });
}

function toggleUserHabitualAddressEdit(index){
    $('#userHabitualAddressEdit' + index).slideToggle("slow");
}

function callUserHabitualAddressEdit() {
	// Google Analytics: track event
	_gaq.push(['_trackEvent', 'UserHabitualAddressEdit', 'Call']);
	
	var nameToEdit = $('#addressToEdit').val();
    var newName = $('#addressToEditNewName').val();
	userHabitualAddressEdit(nameToEdit, newName, processUserHabitualAddressEditSuccess, processUserHabitualAddressEditError);
}

function validateUserHabitualAddressEdit(index){
    var result = true;
    var errorMessage = "";
    $('#habitualAddressesError').html("");
    $('#habitualAddressesErrorBox').fadeOut();
    
    var newName = $('#userHabitualAddressEditNewName' + index).val();
    
    if (newName.length < 1) {
        errorMessage += VAL_ERROR_NO_NEW_ADDRESS_NAME + "<br/>";
        result = false;
    }
    else 
        if (!checkAddressName(newName)) {
            errorMessage += VAL_ERROR_NEW_ADDRESS_NAME + "<br/>";
            result = false;
        }
	
    if (errorMessage != "") {
        $('#habitualAddressesErrorBox').fadeIn();
        $('#habitualAddressesError').html(errorMessage);
    }
    
    return result;
}

function confirmUserHabitualAddressEdit(indexAddressToEdit){
    $('#addressToEdit').val($('#habitualAddressName' + indexAddressToEdit).val());
    $('#addressToEditNewName').val($('#userHabitualAddressEditNewName' + indexAddressToEdit).val());
    if (validateUserHabitualAddressEdit(indexAddressToEdit)) {
        window.setTimeout("callUserHabitualAddressEdit();", TIMEOUT_FOR_DATA_LOAD);
    }
}

function processUserHabitualAddressEditSuccess(json, textStatus){
    $('#addressToEdit').val("");
    $('#addressToEditNewName').val("");
    showNotificationWithTimer(HABITUAL_ADDRESS_EDITED_WITH_SUCCESS);
    
    callUserHabitualAddressGet();
    window.setTimeout("enableEditHabitualAddresses();", TIMEOUT_FOR_DATA_LOAD);
}

function processUserHabitualAddressEditError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#habitualAddressesError').html(errorMessage);
    $('#habitualAddressesErrorBox').fadeIn();
}

/**
 * ============================================================================
 * INTEGRATION WITH GOOGLE MAPS GEOCODING
 * ============================================================================
 */
function loadMap(mapDivName, latA, lonA, latB, lonB, mapSize){
    var pointCustomer = new google.maps.LatLng(latA, lonA, false);
    
    if (!pointCustomer) {
        $('#requestTaxiErrorBox').fadeIn();
        $('#requestTaxiError').html(INCORRECT_POSITION_CUSTOMER);
    }
    else {
        var mapTypeControlStyle;
        var navigationControlStyle;
        if (mapSize == MAP_SMALL) {
            mapTypeControlStyle = google.maps.MapTypeControlStyle.DROPDOWN_MENU;
            navigationControlStyle = google.maps.NavigationControlStyle.SMALL;
        }
        else 
            if (mapSize == MAP_LARGE) {
                mapTypeControlStyle = google.maps.MapTypeControlStyle.HORIZONTAL_BAR;
                navigationControlStyle = google.maps.NavigationControlStyle.SMALL;
            }
        
        var myOptions = {
            zoom: DEFAULT_MAP_ZOOM,
            // center : pointCustomer,
            mapTypeControl: true,
            mapTypeControlOptions: {
                style: mapTypeControlStyle
            },
            navigationControl: true,
            navigationControlOptions: {
                style: navigationControlStyle
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        
        var map = new google.maps.Map(document.getElementById(mapDivName), myOptions);
        
        // If a second lat/lon is received corresponding to TAXI
        // then display two markers (taxi & customer)
        // and display ROUTE
        if ((latB != null) && (lonB != null)) {
            var pointTaxi = new google.maps.LatLng(latB, lonB, false);
            
            if (!pointTaxi) {
                $('#requestTaxiErrorBox').fadeIn();
                $('#requestTaxiError').html(INCORRECT_POSITION_TAXI);
            }
            else {
                var markerTaxi = new google.maps.MarkerImage('./images/marker_taxi.png', new google.maps.Size(20, 34), new google.maps.Point(0, 0), new google.maps.Point(9, 34));
                var markerTaxiShadow = new google.maps.MarkerImage('./images/marker_taxi_shadow.png', new google.maps.Size(37, 34), new google.maps.Point(0, 0), new google.maps.Point(9, 34));
                var markerTaxi = new google.maps.Marker({
                    position: pointTaxi,
                    icon: markerTaxi,
                    shadow: markerTaxiShadow,
                    map: map
                });
 
                // Display estimated distance
                var currentEstimatedDistance = estimateDistance(latA, lonA, latB, lonB);
                var distanceLiteral = getDistanceWithUnits(currentEstimatedDistance);
                $('#distanceSpan').html(distanceLiteral);
                
                // Display estimated time
                var timeEstimationLiteral = getEstimatedTimeWithUnits(currentEstimatedDistance);
                $('#timeEstimationSpan').html(timeEstimationLiteral);
                
                // Store estimated distance in meters in "container"
                $('#container').data('serviceDistance', currentEstimatedDistance);
                
                //map.setCenter(pointCustomer);
                
                // Zoom To Fit Customer & Taxi Markers
                var LatLngList = new Array(pointCustomer, pointTaxi);
                //  Create a new viewpoint bound
                var bounds = new google.maps.LatLngBounds ();
                //  Go through each...
                for (var i = 0, LtLgLen = LatLngList.length; i < LtLgLen; i++) {
                  //  And increase the bounds to take this point
                  bounds.extend (LatLngList[i]);
                }
                //  Fit these bounds to the map
                map.fitBounds (bounds);
                
                
                // Calculate GOOGLE MAPS directions from TAXI to CUSTOMER and display in the map
                /*
                var directionsService = new google.maps.DirectionsService();
                var rendererOptions = {
                    map: map,
                    suppressMarkers: true
                };
                var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
                //directionsDisplay.setMap(map);
                
                var request = {
                    origin: pointTaxi,
                    destination: pointCustomer,
                    provideRouteAlternatives: false,
                    avoidTolls: true,
                    travelMode: google.maps.DirectionsTravelMode.DRIVING,
                    unitSystem: google.maps.DirectionsUnitSystem.METRIC
                };
                directionsService.route(request, function(result, status){
                    if (status == google.maps.DirectionsStatus.OK) {
                        directionsDisplay.setDirections(result);
                    }
                    else {
                        $('#requestTaxiErrorBox').fadeIn();
                        $('#requestTaxiError').html(ROUTE_CAN_NOT_BE_DISPLAYED);
                    }
                    
                    var distance = result.routes[0].legs[0].distance.text;
                    $('#distanceSpan').html(distance);
                    var timeEstimation = result.routes[0].legs[0].duration.text;
                    $('#timeEstimationSpan').html(timeEstimation);
                    
                });
                */
            }
        }
        else {
            map.setCenter(pointCustomer);
			// Hide warning box
			$('#warningBox').hide();		
			
			// Show contextual info window on map with info
			$('#taxisAroundBox').show();
        }
        
        var markerCustomer = new google.maps.MarkerImage('./images/marker_customer.png', new google.maps.Size(20, 34), new google.maps.Point(0, 0), new google.maps.Point(9, 34));
        var markerCustomerShadow = new google.maps.MarkerImage('./images/marker_customer_shadow.png', new google.maps.Size(37, 34), new google.maps.Point(0, 0), new google.maps.Point(9, 34));
        var markerCustomer = new google.maps.Marker({
            position: pointCustomer,
            icon: markerCustomer,
            shadow: markerCustomerShadow,
            map: map
        });
		
        $('#' + mapDivName).fadeIn();
    }
}

function getAddressFromComponents(addrComponents){
    var address = "";
    var number = "";
    var street = "";
    var city = "";
    var province = "";
    
    if (isNaN(parseInt(addrComponents[0].short_name)) == false) {
        number = addrComponents[0].short_name;
        street = addrComponents[1].short_name;
        city = addrComponents[2].short_name;
        province = addrComponents[3].long_name;
        address = street + ", " + number + ", " + city + ", " + province;
    }
    else {
        street = addrComponents[0].short_name;
        city = addrComponents[1].short_name;
        province = addrComponents[2].long_name;
        address = street + ", " + city + ", " + province;
    }
    
    return address;
}

function searchLocations(divName, address){
    $('#locatedAddressesBox').html("");
    $('#locatedAddressesBox').hide();
    
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({
        'address': address
    }, function(results, status){
        if (status == google.maps.GeocoderStatus.OK) {
			
			// Hide habitual addresses
			$('#habitualAddressesHeader').hide();
			$('#habitualAddressesBox').hide();
			
            if (results.length == 1) { // If only one address
                // is found: show map
                
                $('#manyAddressesBox').hide();
                
                var point = results[0].geometry.location;
                var lat = point.lat();
                var lon = point.lng();
                
                //var addr = getAddressFromComponents(results[0].address_components);
                var addr= results[0].formatted_address;
				
                $('#' + divName).fadeIn();
                $('#newAddress').val(addr);
                $('#newAddressLat').val(lat);
                $('#newAddressLon').val(lon);
                
                loadMap(divName, lat, lon, null, null, MAP_LARGE);
				
				// Search & display number of taxis around this location in the map
				//callUserTaxisAroundGet(lat, lon, addr, null);
                
                var i = 0;
                var content = "<center><img src='images/separator.png'/></center>";
                content += "<a href='javascript:selectNewAddress(" + i + ");'>" +
                "<div class='address'>" +
                addr +
                "</div>" +
                "</a>" +
                "<input type='hidden' id='newAddress" +
                i +
                "' value='" +
                addr +
                "'>" +
                "<input type='hidden' id='newAddressName" +
                i +
                "' value=''>" +
                "<input type='hidden' id='newAddressLat" +
                i +
                "' value='" +
                lat +
                "'>" +
                "<input type='hidden' id='newAddressLon" +
                i +
                "' value='" +
                lon +
                "'>";
                
                $('#locatedAddressesBox').html(content);
                $('#locatedAddressesBox').fadeIn();
                
                $('#addToHabitualBox').fadeIn();
                
            }
            else { // If several addresses are found: show list
                $('#addToHabitualBox').hide();
                
                $('#' + divName).fadeOut();
                $('#manyAddressesBox').show();
                var content = "";
                /*
                 * var content = "<p class='blackBoldMedium'>Se han
                 * encontrado varias direcciones.</p>" + "<p>Elige una
                 * de ellas o precisa un poco m&aacute;s tu b&uacute;squeda
                 * con calle, n&uacute;mero, localidad y provincia</p>";
                 */
                for (var i = 0; i < results.length; i++) {
                
                    var point = results[i].geometry.location;
                    var lat = point.lat();
                    var lon = point.lng();
                    //var addr = getAddressFromComponents(results[i].address_components);
					var addr= results[i].formatted_address;
                    
                    content += "<a href='javascript:chooseNewAddressFromList(" +
                    i +
                    ");'>" +
                    "<div class='addressCheck'>" +
                    addr +
                    "</div>" +
                    "</a>" +
                    "<input type='hidden' id='newAddress" +
                    i +
                    "' value='" +
                    addr +
                    "'>" +
                    "<input type='hidden' id='newAddressName" +
                    i +
                    "' value=''>" +
                    "<input type='hidden' id='newAddressLat" +
                    i +
                    "' value='" +
                    lat +
                    "'>" +
                    "<input type='hidden' id='newAddressLon" +
                    i +
                    "' value='" +
                    lon +
                    "'>";
                }
                $('#locatedAddressesBox').html(content);
                $('#locatedAddressesBox').fadeIn();
            }
        }
        else {
            $('#requestTaxiErrorBox').fadeIn();
            $('#requestTaxiError').html(ADDRESS_NOT_FOUND);
        }
    });
}

/**
 * ============================================================================
 * ADD NEW HABITUAL ADDRESSES
 * ============================================================================
 */
function searchAddressToAddHabitual(){
	searchLocationsToAddHabitual("mapCanvasToAddHabitual", $('#newAddressToAddHabitual').val());
}

function searchLocationsToAddHabitual(divName, address){
    $('#locatedAddressesToAddHabitualBox').html("");
    $('#locatedAddressesToAddHabitualBox').hide();
    
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({
        'address': address
    }, function(results, status){
        if (status == google.maps.GeocoderStatus.OK) {
            if (results.length == 1) { // If only one address
                // is found: show map
                
                $('#manyAddressesToAddHabitualBox').hide();
                
                var point = results[0].geometry.location;
                var lat = point.lat();
                var lon = point.lng();
                
                //var addr = getAddressFromComponents(results[0].address_components);
				var addr= results[0].formatted_address;
                
                $('#' + divName).fadeIn();
                $('#newAddressToAddHabitual').val(addr);
                $('#newAddressLatToAddHabitual').val(lat);
                $('#newAddressLonToAddHabitual').val(lon);
                
                loadMap(divName, lat, lon, null, null, MAP_LARGE);
                
                var i = 0;
				var content = "<center><img src='images/separator.png'/></center>";
                content += "<a href='javascript:selectNewAddressToAddHabitual(" + i + ");'>" +
                "<div class='addressAdd'>" +
                addr +
                "</div>" +
                "</a>" +
                "<input type='hidden' id='newAddressToAddHabitual" +
                i +
                "' value='" +
                addr +
                "'>" +
                "<input type='hidden' id='newAddressNameToAddHabitual" +
                i +
                "' value=''>" +
                "<input type='hidden' id='newAddressLatToAddHabitual" +
                i +
                "' value='" +
                lat +
                "'>" +
                "<input type='hidden' id='newAddressLonToAddHabitual" +
                i +
                "' value='" +
                lon +
                "'>";
                
                $('#locatedAddressesToAddHabitualBox').html(content);
                $('#locatedAddressesToAddHabitualBox').fadeIn();
                
                $('#addNewToHabitualBox').fadeIn();
                
            }
            else { // If several addresses are found: show list
                $('#addNewToHabitualBox').hide();
                
                $('#' + divName).fadeOut();
                $('#manyAddressesToAddHabitualBox').show();
                var content = "";
                /*
                 * var content = "<p class='blackBoldMedium'>Se han
                 * encontrado varias direcciones.</p>" + "<p>Elige una
                 * de ellas o precisa un poco m&aacute;s tu b&uacute;squeda
                 * con calle, n&uacute;mero, localidad y provincia</p>";
                 */
                for (var i = 0; i < results.length; i++) {
                
                    var point = results[i].geometry.location;
                    var lat = point.lat();
                    var lon = point.lng();
                    //var addr = getAddressFromComponents(results[i].address_components);
					var addr= results[i].formatted_address;
                    
                    //content += "<div class='addressField'>"
                    content += "<a href='javascript:chooseNewAddressFromListToAddHabitual(" +
                    i +
                    ");'>" +
                    "<div class='addressCheck'>" +
                    addr +
                    "</div>" +
                    "</a>" +
                    "<input type='hidden' id='newAddressToAddHabitual" +
                    i +
                    "' value='" +
                    addr +
                    "'>" +
                    "<input type='hidden' id='newAddressNameToAddHabitual" +
                    i +
                    "' value=''>" +
                    "<input type='hidden' id='newAddressLatToAddHabitual" +
                    i +
                    "' value='" +
                    lat +
                    "'>" +
                    "<input type='hidden' id='newAddressLonToAddHabitual" +
                    i +
                    "' value='" +
                    lon +
                    "'>";
                    //+ "</div>";
                }
                $('#locatedAddressesToAddHabitualBox').html(content);
                $('#locatedAddressesToAddHabitualBox').fadeIn();
            }
        }
        else {
            $('#addNewHabitualAddressErrorBox').fadeIn();
            $('#addNewHabitualAddressError').html(ADDRESS_NOT_FOUND);
        }
    });
}

function selectNewAddressToAddHabitual(index){
    var name = $('#newAddressNameToAddHabitual').val();
    var address = $('#newAddressToAddHabitual' + index).val();
    var lat = $('#newAddressLatToAddHabitual' + index).val();
    var lon = $('#newAddressLonToAddHabitual' + index).val();
    
    $('#newAddressToAddHabitual').val(address);
    $('#newAddressLatToAddHabitual').val(lat);
    $('#newAddressLonToAddHabitual').val(lon);
    if (validateAddNewHabitualAddress()) {
		callUserHabitualAddressAdd(name, address, lat, lon, processAddNewHabitualAddressSuccess, processAddNewHabitualAddressError);
    }
}

function chooseNewAddressFromListToAddHabitual(index){
    $('#newAddressToAddHabitual').val($('#newAddressToAddHabitual' + index).val());
    $('#newAddressLatToAddHabitual').val($('#newAddressLatToAddHabitual' + index).val());
    $('#newAddressLonToAddHabitual').val($('#newAddressLonToAddHabitual' + index).val());
    
    searchAddressToAddHabitual();
}

function validateAddNewHabitualAddress(){
    var result = true;
    var errorMessage = "";
    $('#addNewHabitualAddressError').html("");
    $('#addNewHabitualAddressErrorBox').fadeOut();
    
    var addressName = $('#newAddressNameToAddHabitual').val();
    if (addressName.length < 1) {
        errorMessage += VAL_ERROR_NO_NEW_ADDRESS_NAME + "<br/>";
        result = false;
    }
    else 
        if (!checkAddressName(addressName)) {
            errorMessage += VAL_ERROR_NEW_ADDRESS_NAME + "<br/>";
            result = false;
        }
    
    if (errorMessage != "") {
        $('#addNewHabitualAddressErrorBox').fadeIn();
        $('#addNewHabitualAddressError').html(errorMessage);
    }
    
    return result;
}

function processAddNewHabitualAddressSuccess(json, textStatus){
    showNotificationWithTimer(HABITUAL_ADDRESS_ADDED_WITH_SUCCESS);
    
    $('#locatedAddressesToAddHabitualBox').html("");
    $('#locatedAddressesToAddHabitualBox').hide();
    $('#newAddressToAddHabitual').val('');
    $('#newAddressNameToAddHabitual').val('');
    $('#newAddressLatToAddHabitual').val('');
    $('#newAddressLonToAddHabitual').val('');
    $('#addNewToHabitualBox').hide();
    $('#mapCanvasToAddHabitual').hide();
    
    callUserHabitualAddressGet();
    window.setTimeout("enableEditHabitualAddresses();", TIMEOUT_FOR_DATA_LOAD);
}

function processAddNewHabitualAddressAndSelectSuccess(json, textStatus){
    showNotificationWithTimer(HABITUAL_ADDRESS_ADDED_WITH_SUCCESS);
}

function processAddNewHabitualAddressError(xhr, textStatus, errorThrown){
    var errorMessage = processRequestError(xhr, textStatus, errorThrown);
    $('#addNewHabitualAddressError').html(errorMessage);
    $('#addNewHabitualAddressErrorBox').fadeIn();
}

/**
 * ============================================================================
 * UTILS FUNCTIONS
 * ============================================================================
 */
function validatePassword(password, rePassword, passwordErrorMessage){
    var pass = document.getElementById(password);
    var rePass = document.getElementById(rePassword);
    if (pass.value != rePass.value) {
        $('#passwordErrorMessage').fadeIn();
        return false;
    }
    $('#passwordErrorMessage').fadeOut();
    return true;
}

function sortParams(encryptSessionId, encryptText1, encryptText2, encryptText3, encryptText4, encryptText5, encryptText6, encryptText7, encryptText8, encryptText9, encryptGeneralResponseMethod, encryptTimestamp){
    var paramsArray = [encryptSessionId, encryptText1, encryptText2, encryptText3, encryptText4, encryptText5, encryptText6, encryptText7, encryptText8, encryptText9, encryptGeneralResponseMethod, encryptTimestamp];
    paramsArray.sort();
    
    return paramsArray.join("");
}

function clearParam(paramName){
    document.getElementById(paramName).value = "";
}

function hideAllParams(){
    var numParams = 9;
    for (i = 1; i <= numParams; i++) {
        $('#paramName' + i).val("");
        $('#param' + i + 'row').style.display = "none";
    }
}

function reloadCaptcha(){
    var date = new Date();
    var timestamp = date.getTime();
    $('#captchaImage').attr('src', IP_AND_PORT + '/' + APP_NAME + '/captcha?captchaid=' + timestamp);
    $('#captchaid').val(timestamp);
}

function reloadRememberPasswordCaptcha(){
    var date = new Date();
    var timestamp = date.getTime();
    $('#rememberPasswordCaptchaImage').attr('src', IP_AND_PORT + '/' + APP_NAME + '/captcha?captchaid=' + timestamp);
    $('#rememberPasswordCaptchaid').val(timestamp);
}

function showUserRememberPasswordInPopup() {
	$('#userRememberPasswordError').html("");
    $('#userRememberPasswordErrorBox').hide();
	reloadRememberPasswordCaptcha();
	$('#userRememberPasswordBox').show();
	showPopup();
}

function showFieldHelp(fieldName) {
	$("div[id$='Help']").hide();
	fieldName += "Help";
	$('#'+fieldName).show();
}

function constrain(text, ideal_width, className){

    var temp_item = ('<span class="'+className+'_hide" style="display:none;">'+ text +'</span>');
    $(temp_item).appendTo('body');
    var item_width = $('span.'+className+'_hide').width();
    var ideal = parseInt(ideal_width);
    var smaller_text = text;

    if (item_width>ideal_width){
        while (item_width > ideal) {
            smaller_text = smaller_text.substr(0, (smaller_text.length-1));
            $('.'+className+'_hide').html(smaller_text);
            item_width = $('span.'+className+'_hide').width();
        }
        smaller_text = smaller_text + '&hellip;'
    }
    $('span.'+className+'_hide').remove();
    return smaller_text;
}

jQuery(window).bind("unload", function() {
	jQuery.each(jQuery.timer.global, function(index, item) {
		jQuery.timer.remove(item);
	});
});