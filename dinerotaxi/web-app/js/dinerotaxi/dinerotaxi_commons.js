/**
 * @author Wannataxi
 */

$(document).ready(function() {
	// Close Popup when Clicking in the close icon (x)
	$("#popupContactClose").click(function(){  
		disablePopup();  
	});
	  
	// Close Popup when Clicking out of popup
	$("#backgroundPopup").click(function(){  
		disablePopup();  
	});
	 
	// Close Popup when pressing Escape 
	$(document).keydown(function(e){  
		if(e.keyCode==27 && popupStatus==1) {  
			disablePopup();  
		}  
	});
	 
});

//SETTING UP MODAL POPUP: 0 means disabled; 1 means enabled;  
var popupStatus = 0;  

/**
 * ============================================================================
 * CONSTANTS
 * ============================================================================
 */
var RESPONSE_METHOD = "XML";
var TIMEOUT_FOR_DATA_LOAD = 500; // In miliseconds
var NO_ACTIVE_SESSION = 0;
var TAXI_ACTIVE_SESSION = 1;
var USER_ACTIVE_SESSION = 2;
var SESSION_EXPIRED = 2;
var TIMER_FOR_NOTIFICATIONS = 5000; // In miliseconds
var INTERVAL_FOR_SERVICE_REQUEST_TIMER = 5000; // In miliseconds
var TIMES_FOR_SERVICE_REQUEST_TIMER = 36; 
var INTERVAL_FOR_REFRESH_TAXI_POSITION = 20000; // In miliseconds
var MAP_SMALL = 1;
var MAP_LARGE = 2;
var PICKUP_DATETIME_NUMBER_OF_OPTIONS = 7;
var DEFAULT_MAP_ZOOM = 16;
//AJAX
var IP_AND_PORT = "";
var APP_NAME = "api";
//FORM VALIDATION
var MSISDN_MIN = 9;
var MSISDN_MAX = 11;
var PASSWORD_MIN = 6;
var PASSWORD_MAX = 12;
var NAME_MIN = 3;
var NAME_MAX = 20;
var CAPTCHA_MIN = 6;
var VALIDATION_TOKEN_MIN = 6;
var VALIDATION_TOKEN_MAX = 6;
var ADDRESS_MIN = 10;
var ADDRESS_MAX = 100;
var ADDRESS_NAME_MIN = 3;
var ADDRESS_NAME_MAX = 20;
var LICENSE_MAX = 12;
var CAR_PLATE_MAX = 10;
var CAR_MODEL_MAX = 10;
var ADDRESS_STREET_MAX = 100;
var ADDRESS_CITY_MAX = 50;
// LEGAL TEXTS
var TEXT_SERVICE_CONDITIONS = 1;
var TEXT_USE_CONDITIONS = 2;
var TEXT_PRIVACY_POLICY = 3;
var TEXT_SERVICE_CONDITIONS_FOR_USERS = 4;

/**
 * ============================================================================
 * CONSTANTS FOR LITERALS: ERRORS, MESSAGES, TEXTS & NOTIFICATIONS
 * ============================================================================
 */
var VAL_ERROR_NO_MSISDN = "Falta el n&uacute;mero de tel&eacute;fono m&oacute;vil.";
var VAL_ERROR_MSISDN_LENGTH = "El n&uacute;mero de tel&eacute;fono debe tener entre "+ MSISDN_MIN + " y " + MSISDN_MAX + " caracteres.";
var VAL_ERROR_MSISDN = VAL_ERROR_MSISDN_LENGTH + " S&oacute;lo puede contener n&uacute;meros.";

var VAL_ERROR_NO_PASSWORD = "Falta la contrase&ntilde;a.";
var VAL_ERROR_PASSWORD_LENGTH = "La contrase&ntilde;a debe tener entre "+ PASSWORD_MIN + " y " + PASSWORD_MAX + " caracteres.";
var VAL_ERROR_PASSWORD = VAL_ERROR_PASSWORD_LENGTH + " S&oacute;lo puede contener letras y n&uacute;meros.";
var VAL_ERROR_PASSWORDS_DONT_MATCH = "Las contrase&ntilde;as no coinciden.";

var VAL_ERROR_NO_CURRENT_PASSWORD = "Falta la contrase&ntilde;a actual.";
var VAL_ERROR_NO_NEW_PASSWORD = "Falta la nueva contrase&ntilde;a.";

var VAL_ERROR_NO_NAME = "Falta el nombre.";
var VAL_ERROR_NAME_LENGTH = "El nombre debe tener entre " + NAME_MIN + " y "+ NAME_MAX + " caracteres.";
var VAL_ERROR_NAME = VAL_ERROR_NAME_LENGTH + " S&oacute;lo puede contener letras, n&uacute;meros y espacios en blanco.";

var VAL_ERROR_CONDITIONS_NOT_ACCEPTED = "Debes aceptar las condiciones del servicio";
var VAL_ERROR_NO_VALIDATION_CODE = "Por favor, introduce el c&oacute;digo de validaci&oacute;n";
var VAL_ERROR_VALIDATION_CODE_LENGTH = "El c&oacute;digo de validaci&oacute;n debe tener "+ VALIDATION_TOKEN_MIN + " d&iacute;gitos";

var VAL_ERROR_NO_NEW_ADDRESS = "Por favor, introduce la direcci&oacute;n";
var VAL_ERROR_NEW_ADDRESS_LENGTH = "La direcci&oacute;n debe tener entre " + ADDRESS_MIN + " y " + ADDRESS_MAX + " caracteres";
var VAL_ERROR_NO_NEW_ADDRESS_NAME = "Tienes que introducir un nombre para la direcci&oacute;n habitual";
var VAL_ERROR_NEW_ADDRESS_NAME = "El nombre de la direcci&oacute;n debe tener entre " + ADDRESS_NAME_MIN + " y "+ ADDRESS_NAME_MAX + " caracteres. S&oacute;lo puede contener letras, n&uacute;meros, guiones bajos y espacios en blanco.";
var VAL_ERROR_NO_CAPTCHA = "Tienes que indicarnos qu&eacute; pone en la imagen";
var VAL_ERROR_CAPTCHA_LENGTH = "Eso no es lo que pone en la imagen.";
var VAL_ERROR_CAPTCHA = VAL_ERROR_CAPTCHA_LENGTH + " S&oacute;lo puede contener letras";

var VAL_ERROR_INCORRECT_EMAIL = "Por favor, introduce una direcci&oacute;n de correo electronico correcta. Por ejemplo: tunombre@gmail.com";
var VAL_ERROR_NO_EMAIL="Por favor, introduce una direcci&oacute;n de correo electronico . Por ejemplo: tunombre@gmail.com";
var VAL_ERROR_LICENSE_LENGTH = "La licencia debe tener menos de "+ LICENSE_MAX + " caracteres.";
var VAL_ERROR_CAR_PLATE_LENGTH = "La matr&iacute;cula debe tener menos de "+ CAR_PLATE_MAX + " caracteres.";
var VAL_ERROR_CAR_MODEL_LENGTH = "El modelo debe tener menos de "+ CAR_MODEL_MAX + " caracteres.";
var VAL_ERROR_ADDRESS_STREET_LENGTH = "La calle y n&uacute;mero deben tener menos de "+ ADDRESS_STREET_MAX + " caracteres.";
var VAL_ERROR_ADDRESS_PC = "El c&oacute;digo postal no es correcto.";
var VAL_ERROR_ADDRESS_CITY_LENGTH = "La localidad debe tener menos de "+ ADDRESS_CITY_MAX + " caracteres.";

var ERROR_5_INCORRECT_LOGIN_PASSWORD = "El n&uacute;mero de m&oacute;vil o la contrase&ntilde;a son incorrectos.";
var ERROR_10_SERVICE_NOT_FOUND = "Lo sentimos, pero no encontramos el servicio.";
var ERROR_20_TAXI_NOT_FOUND = "Lo sentimos, no hemos encontrado ning&uacute;n taxi disponible cercano a la direcci&oacute;n que nos has indicado. Por favor, vuelve a intentarlo pasados unos minutos. ";
var ERROR_30_USER_ALREADY_REGISTERED = "Lo sentimos, pero ya existe un usuario registrado con ese n&uacute;mero de tel&eacute;fono m&oacute;vil.";
var ERROR_31_REGISTER_USER_ALREADY_EXISTS = "Lo sentimos, pero ya existe un usuario en proceso de registro con ese n&uacute;mero de tel&eacute;fono m&oacute;vil.";
var ERROR_32_TAXI_ALREADY_EXISTS = "Lo sentimos, pero ya existe un taxista registrado con ese n&uacute;mero de tel&eacute;fono m&oacute;vil.";
var ERROR_33_REGISTER_TAXI_ALREADY_EXISTS = "Lo sentimos, pero ya existe un taxista en proceso de registro con ese n&uacute;mero de tel&eacute;fono m&oacute;vil. Si ya has recibido el c&oacute;digo por SMS puedes proceder a validar tu m&oacute;vil.";
var ERROR_40_INVALID_TOKEN = "El c&oacute;digo de validaci&oacute;n que has introducido no coincide con el que te hemos enviado por SMS.";
var ERROR_41_REGISTER_USER_NOT_FOUND = "No encontramos ning&uacute;n registro de usuario en proceso para el n&uacute;mero de tel&eacute;fono indicado. Por favor, revisa el n&uacute;mero o inicia el registro de nuevo.";
var ERROR_42_REGISTER_TAXI_NOT_FOUND = "No encontramos ning&uacute;n registro de taxista en proceso para el n&uacute;mero de tel&eacute;fono indicado. Por favor, revisa el n&uacute;mero o inicia el registro de nuevo.";
var ERROR_50_WRONG_CAPTCHA = "Parece que no has introducido correctamente el texto que aparece en la imagen. Hemos puesto un texto nuevo que esperamos te sea m&aacute;s f&aacute;cil.";
var ERROR_60_NO_SUCH_USER = "Lo sentimos. El usuario no existe.";
var ERROR_8888_GENERIC_ERROR = "Lo sentimos. Se ha producido un error";
var ERROR_9999_INTERNAL_ERROR = "Lo sentimos. Parece que se ha producido un error en el servidor de Wannataxi. Int&eacute;ntalo de nuevo m&aacute;s tarde, por favor.";

var REQUEST_ERROR = "Error en la petici&oacute;n";
var NO_SESSION_ERROR = "La sesi&oacute;n ha expirado o no has iniciado sesi&oacute;n";
var LOGOUT_SUCCESS = "La sesi&oacute;n se ha cerrado correctamente";
var TAXI_PRE_REGISTER_SUCCESS = "Pre-Registro del taxista realizado con &eacute;xito";
var VALIDATION_CODE_SUCCESS = "C&oacute;digo de validaci&oacute;n correcto. Registro completado.";
var TAXI_UPDATED_SUCCESS = "Datos actualizados correctamente";
var USER_PRE_REGISTER_SUCCESS = "Pre-Registro del cliente realizado con &eacute;xito";
var FIRST_TIME_USER_OR_NOT = "&iquest;Es la primera vez que usas wanna taxi o ya eres usuario?";
var USER_REMEMBER_PASSWORD_SUCCESS = "La nueva contrase&ntilde;a se ha enviado correctamente por SMS";
var USER_MODIFY_PASSWORD_SUCCESS = "La contrase&ntilde;a se ha modificado correctamente"
var HABITUAL_ADDRESS_ADDED_WITH_SUCCESS = "Direcci&oacute;n habitual guardada correctamente";
var HABITUAL_ADDRESSES = "Direcciones habituales";
var HABITUAL_ADDRESS_EMPTY_LIST = "No tienes direcciones habituales. ";
var HABITUAL_ADDRESS_INFO_MESSAGE = "A&ntilde;adirlas es muy sencillo: s&oacute;lo tienes que buscar la direcci&oacute;n, seleccionarla y darle un nombre, como por ejemplo Trabajo, Casa, Gimnasio, etc.";
var HABITUAL_ADRESS_DELETE = "Eliminar esta direcci&oacute;n habitual";
var HABITUAL_ADDRESS_DELETED_WITH_SUCCESS = "Direcci&oacute;n habitual borrada";
var HABITUAL_ADDRESS_EDITED_WITH_SUCCESS = "El nombre de la direcci&oacute;n habitual se ha modificado correctamente";
var ADDRESS_NOT_FOUND = "No encontramos esa direcci&oacute;n. Prueba a poner calle, n&uacute;mero, localidad y provincia";
var INCORRECT_POSITION_TAXI = "La posisi&oacute;n geogr&aacute;fica del taxi no es correcta";
var INCORRECT_POSITION_CUSTOMER = "La posisi&oacute;n geogr&aacute;fica del cliente no es correcta";
var ROUTE_CAN_NOT_BE_DISPLAYED = "No se puede mostrar el recorrido desde la posici&oacute;n actual del taxi";
var PICKUP_TIME_INMEDIATE = "ahora";
var PICKUP_TIME_SCHEDULED = "con recogida programada para el ";
var PICKUP_TIME_SCHEDULED_2 = " a las ";
var WITH_SPECIAL_REQUESTS = "Con peticiones especiales";
var WITHOUT_SPECIAL_REQUESTS = "Ninguna petici&oacute;n especial";
var SERVICE_CANCELLED_WITH_SUCESS = "El servicio ha sido anulado con &eacute;xito";
var SERVICE_CANCELLED_BY_TAXI = "Lo sentimos, el servicio ha sido cancelado por el taxista debido a un caso de fuerza mayor. Por favor, vuelve a pedir un taxi";
var SERVICE_CANCELLED_BY_USER = "Lo sentimos pero has cancelado un servicio recientemente y el sistema no puede asignarte un nuevo taxi en estos momentos. Intentalo de nuevo en unos minutos.";
var SERVICE_TAXI_WAITING = "El taxi solicitado ya ha llegado y est&aacute; esperando en el punto de recogida";

/**
 * ============================================================================
 * CSS STYLES CONSTANTS
 * ============================================================================
 */
BACKGROUND_IMAGE_FOR_USER = '/images/bg_header_user.png';
BACKGROUND_IMAGE_FOR_TAXI = '/images/bg_header_taxi.png';

/**
 * ============================================================================
 * MISCELANEOUS FUNCTIONS
 * ============================================================================
 */
function loadLegalTexts() {
	$('#useConditions').load('useConditions.html');
	$('#privacyPolicy').load('privacyPolicy.html');	
}

function showNotificationWithTimer(message) {
	$('#notification').html(message);
	jQuery('#notification').center();	
	$('#notification').fadeIn();
	window.setTimeout("$('#notification').fadeOut();", TIMER_FOR_NOTIFICATIONS);
}

/**
 * ============================================================================
 * PROCESS REQUEST ERRORS
 * ============================================================================
 */
function processRequestError(xhr, textStatus, errorThrown) {
	var errorMessage = "";

	errorResponse = jQuery.parseJSON(xhr.responseText);

	if (errorResponse != null) {
		var errorCode = errorResponse.code;
		var errorDescription = errorResponse.description;
		var errorParam = errorResponse.param;
		errorMessage = "Error (" + errorCode + "): " + errorDescription;
		
		if (errorParam != null) {
			if (errorParam.length > 0) {
				errorMessage += "[" + errorParam + "]";
			}
		}
		
		if (errorCode == "1") { //Incorrect signature
			errorMessage = ERROR_8888_GENERIC_ERROR + " (" + errorDescription + ")";
		} else if (errorCode == "2") { //SessionException
			errorMessage = NO_SESSION_ERROR;
		} else if (errorCode == "3") { //SequenceException
		} else if (errorCode == "5") { //PasswordException
			errorMessage = ERROR_5_INCORRECT_LOGIN_PASSWORD;
		} else if (errorCode == "10") { //ServiceNotFoundException
			errorMessage = ERROR_10_SERVICE_NOT_FOUND;
		} else if (errorCode == "20") { //TaxiNotFoundException
			errorMessage = ERROR_20_TAXI_NOT_FOUND;
		} else if (errorCode == "30") { //AlreadyExistUserException
			errorMessage = ERROR_30_USER_ALREADY_REGISTERED;
		} else if (errorCode == "31") { //AlreadyExistRegisterUserException
			errorMessage = ERROR_31_REGISTER_USER_ALREADY_EXISTS;
		} else if (errorCode == "32") {// Taxi already exists
			errorMessage = ERROR_32_TAXI_ALREADY_EXISTS;
		} else if (errorCode == "33") { // RegisterTaxi already exists
			errorMessage = ERROR_33_REGISTER_TAXI_ALREADY_EXISTS;
		} else if (errorCode == "40") { //InvalidTokenException
			errorMessage = ERROR_40_INVALID_TOKEN;
		} else if (errorCode == "41") { //NoSuchRegisterUserException
			errorMessage = ERROR_41_REGISTER_USER_NOT_FOUND;
		} else if (errorCode == "42") { //RegisterTaxi not found
			errorMessage = ERROR_42_REGISTER_TAXI_NOT_FOUND;
		} else if (errorCode == "50") { // CaptchaException
			errorMessage = ERROR_50_WRONG_CAPTCHA;
		} else if (errorCode == "60") { //NoSuchUserException
			errorMessage = ERROR_60_NO_SUCH_USER;
		} else if (errorCode == "8888") { //NoSuchUserException
			errorMessage = 	ERROR_8888_GENERIC_ERROR + " (" + errorDescription + ")";
		} else if (errorCode == "9999") { //InternalErrorException
			errorMessage = ERROR_9999_INTERNAL_ERROR;
		} 

	} else {
		errorMessage = REQUEST_ERROR + ": " + textStatus;
	}
	return errorMessage;
}

/**
 * ============================================================================
 * FORM VALIDATION
 * ============================================================================
 */
function checkMsisdn(msisdn) {
	var regex = new RegExp("^[0-9]{"+MSISDN_MIN+","+MSISDN_MAX+"}$");
	return regex.test(msisdn);
}

function checkName(name) {
	var regex = new RegExp("^[a-zA-Z0-9\ \'\u00e1\u00e9\u00ed\u00f3\u00fa\u00c1\u00c9\u00cd\u00d3\u00da\u00f1\u00d1\u00FC\u00DC]{"+NAME_MIN+","+NAME_MAX+"}$");
	return regex.test(name);
}

function checkPassword(password) {
	var regex = new RegExp("^[a-zA-Z0-9]{"+PASSWORD_MIN+","+PASSWORD_MAX+"}$");
	return regex.test(password);
}

function checkCaptcha(captcha) {
	var regex = new RegExp("^[a-zA-Z]{"+CAPTCHA_MIN+",}$");
	return regex.test(captcha);
}

function checkToken(token) {
	var regex = new RegExp("^[a-zA-Z0-9]{"+VALIDATION_TOKEN_MIN+",}$");
	return regex.test(token);
}

function checkAddress(address) {
	var regex = new RegExp("^.{"+ADDRESS_MIN+","+ADDRESS_MAX+"}$");
	return regex.test(address);
}

function checkAddressName(addressName) {
	//Antes: [a-zA-Z0-9_ ]
	var regex = new RegExp("^[a-zA-Z0-9\ \'\u00e1\u00e9\u00ed\u00f3\u00fa\u00c1\u00c9\u00cd\u00d3\u00da\u00f1\u00d1\u00FC\u00DC]{"+ADDRESS_NAME_MIN+","+ADDRESS_NAME_MAX+"}$");
	return regex.test(addressName);
}

function checkValidationCode(validationCode) {
	var regex = new RegExp("^[0-9]{"+VALIDATION_TOKEN_MIN+","+VALIDATION_TOKEN_MAX+"}$");
	return regex.test(validationCode);
}

function checkEmail(email) {
	var regex = new RegExp("^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
	return regex.test(email);
}

function checkPostalCode(postalCode) {
	var regex = new RegExp("^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$");
	return regex.test(postalCode);
}


/**
 * ============================================================================ 
 * OBJECTS
 * ============================================================================
 */
function HabitualAddress(name, address, lat, lon){
    this.name = name;
    this.address = address;
    this.lat = lat;
    this.lon = lon;
}

/**
 * ============================================================================
 * COOKIES MANAGEMENT
 * ============================================================================
 */

function getData(name) {
	
	var result =sessionStorage[name];
	if(result!=null){
		return result;
	}
	return localStorage[name];
}

function setData(name, value, remember) {
	
	var storage = sessionStorage;
	if(remember){
		storage=localStorage;
	}
	storage[name]=value;
}

function deleteData(name) {
	//delete sessionStorage[name];
	//delete localStorage[name];
	sessionStorage.removeItem(name);
	localStorage.removeItem(name);	
}

function checkData() {
	var taxiId = getData("WT_TAXI_ID");
	var taxiSessionId = getData("WT_TAXI_SESSION_ID");
	var taxiSessionSecret = getData("WT_TAXI_SESSION_SECRET");
	
	var userId = getData("WT_USER_ID");
	var userSessionId = getData("WT_USER_SESSION_ID");
	var userSessionSecret = getData("WT_USER_SESSION_SECRET");
	
	// First check if there is a USER active session
	if (userId != null && userSessionId != null && userSessionSecret != null) {
		return USER_ACTIVE_SESSION;
	} else if (taxiId != null && taxiSessionId != null && taxiSessionSecret != null) {  
		// Second check if there is a TAXI active session
		return TAXI_ACTIVE_SESSION;		
	} else { // No active session
		return NO_ACTIVE_SESSION;
	}
}

/**
 * ============================================================================
 * SECURIZATION
 * ============================================================================
 */

function initTimestamp() {
	var date = new Date();

	return date.getTime();
}

function securizeForUser(params) {
	var sessionId = getData("WT_USER_SESSION_ID");
	var sessionSecret = getData("WT_USER_SESSION_SECRET");
	if (sessionSecret == null || sessionId == null) {
		// If there is not active session, then return null
		return null;
	}
	return securize(params, sessionId, sessionSecret);
}

function securizeForTaxi(params) {
	var sessionId = getData("WT_TAXI_SESSION_ID");
	var sessionSecret = getData("WT_TAXI_SESSION_SECRET");
	if (sessionSecret == null || sessionId == null) {
		// If there is not active session, then return null
		return null;
	}
	return securize(params, sessionId, sessionSecret);
}

function securize(params, sessionId, sessionSecret) {
	var timestamp = initTimestamp();
	params += "&sequence=" + timestamp + "&sessionid=" + sessionId;	
	var arrayParams = params.split('&').sort();
	var toEncrypt ='';
	for (x in arrayParams) {
		toEncrypt+=arrayParams[x];
    }
	toEncrypt += sessionSecret;
	var securityId = MD5(toEncrypt);
	params += "&sig="+ securityId;
	return params;
}

/**
 * ============================================================================
 * MODAL POPUPS
 * ============================================================================
 */
function showPictureInPopup(i) {
	var item = androidPhonesArray[i];
	var html = '<center><img src="' + item.pictureurl + 
		'" width="340" height="340" /><br/><span class="purpleExtraLarge">'+item.brand+' '+item.name+'<span></center>' ;
	$('#popupItem').html(html);
	$('#popupItem').show();
	showPopup();
}

function showTextInPopup(text) {
	if (text == TEXT_SERVICE_CONDITIONS) {
		$('#taxiServiceConditionsBox').show();
	} else if (text == TEXT_USE_CONDITIONS) {
		$('#useConditionsBox').show();		
	} else if (text == TEXT_PRIVACY_POLICY) {
		$('#privacyPolicyBox').show();			
	} else if (text == TEXT_SERVICE_CONDITIONS_FOR_USERS) {
		$('#userServiceConditionsBox').show();
	}
	
	showPopup();
}

function showPopup() {
	centerPopup();  
	loadPopup(); 
} 

function loadPopup() {  
	//loads popup only if it is disabled  
	if (popupStatus==0){  
		$("#backgroundPopup").css({  
			"opacity": "0.7"  
		});  
		$("#backgroundPopup").fadeIn("slow");  
		$("#popupContact").fadeIn("slow");  
		popupStatus = 1;  
	}  
} 

function disablePopup() {  
	//disables popup only if it is enabled  
	if (popupStatus==1){  
		$("#backgroundPopup").fadeOut("slow");  
		$("#popupContact").fadeOut("slow");  
		popupStatus = 0;  
	}  
	
	// hide picture
	$('#popupItem').fadeOut("slow");
	
	// hide texts
	$('#taxiServiceConditionsBox').fadeOut("slow");
	$('#useConditionsBox').fadeOut("slow");
	$('#privacyPolicyBox').fadeOut("slow");
	$('#userServiceConditionsBox').fadeOut("slow");	
} 

function centerPopup() {  
	// Request data for centering 
	var windowWidth = 0;
	var windowHeight = 0;  

	// Compatible with all browsers except Explorer
	if (self.innerHeight) {
		windowWidth = self.innerWidth;
		windowHeight = self.innerHeight;
	// Explorer 6 in "strict" mode
	} else if (document.documentElement && document.documentElement.clientHeight) {
		windowWidth = document.documentElement.clientWidth;
		windowHeight = document.documentElement.clientHeight;
	// Specific for IE
	} else if (document.body) {
		windowWidth = document.body.clientWidth;
		windowHeight = document.body.clientHeight;
	}
	
	var popupHeight = $("#popupContact").height();
    var popupWidth = $("#popupContact").width();
	
	var top = (windowHeight/2 - popupHeight/2) - 20;
	var left = (windowWidth/2 - popupWidth/2) - 20;
	
    //centering  
    $("#popupContact").css({  
    	"position": "absolute",  
    	"top": top,  
    	"left": left  
    });  
    
	//only need force for IE6  
    $("#backgroundPopup").css({  
    	"height": windowHeight  
    });  
}  
/**
 * ============================================================================
 * FUNCTIONS FOR UTF-8
 * ============================================================================
 */

function code2utf(code)
{
    if (code < 128) return chr(code);
    if (code < 2048) return chr(192+(code>>6)) + chr(128+(code&63));
    if (code < 65536) return chr(224+(code>>12)) + chr(128+((code>>6)&63)) + chr(128+(code&63));
    if (code < 2097152) return chr(240+(code>>18)) + chr(128+((code>>12)&63)) + chr(128+((code>>6)&63)) + chr(128+(code&63));
}

function chr(code)
{
    return String.fromCharCode(code);
}


function _utf8Encode(str)
{   
    var utf8str = new Array();
    for (var i=0; i<str.length; i++) {
        utf8str[i] = code2utf(str.charCodeAt(i));
    }
    return utf8str.join('');
}

function utf8Encode(str)
{   
    var utf8str = new Array();
    var pos,j = 0;
    var tmpStr = '';
    
    while ((pos = str.search(/[^\x00-\x7F]/)) != -1) {
        tmpStr = str.match(/([^\x00-\x7F]+[\x00-\x7F]{0,10})+/)[0];
        utf8str[j++] = str.substr(0, pos);
        utf8str[j++] = _utf8Encode(tmpStr);
        str = str.substr(pos + tmpStr.length);
    }
    
    utf8str[j++] = str;
    return utf8str.join('');
}


/**
 * ============================================================================
 * FUNCTIONS FOR MD5 HASH CALCULATION
 * ============================================================================
 */
var hex_chr = "0123456789abcdef";
function rhex(num) {
	str = "";
	for (j = 0; j <= 3; j++)
		str += hex_chr.charAt((num >> (j * 8 + 4)) & 0x0F)
				+ hex_chr.charAt((num >> (j * 8)) & 0x0F);
	return str;
}

function str2blks_MD5(str) {
	nblk = ((str.length + 8) >> 6) + 1;
	blks = new Array(nblk * 16);
	for (i = 0; i < nblk * 16; i++)
		blks[i] = 0;
	for (i = 0; i < str.length; i++)
		blks[i >> 2] |= str.charCodeAt(i) << ((i % 4) * 8);
	blks[i >> 2] |= 0x80 << ((i % 4) * 8);
	blks[nblk * 16 - 2] = str.length * 8;
	return blks;
}

function add(x, y) {
	var lsw = (x & 0xFFFF) + (y & 0xFFFF);
	var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
	return (msw << 16) | (lsw & 0xFFFF);
}

function rol(num, cnt) {
	return (num << cnt) | (num >>> (32 - cnt));
}

function cmn(q, a, b, x, s, t) {
	return add(rol(add(add(a, q), add(x, t)), s), b);
}

function ff(a, b, c, d, x, s, t) {
	return cmn((b & c) | ((~b) & d), a, b, x, s, t);
}

function gg(a, b, c, d, x, s, t) {
	return cmn((b & d) | (c & (~d)), a, b, x, s, t);
}

function hh(a, b, c, d, x, s, t) {
	return cmn(b ^ c ^ d, a, b, x, s, t);
}

function ii(a, b, c, d, x, s, t) {
	return cmn(c ^ (b | (~d)), a, b, x, s, t);
}

function MD5(str) {
	str=utf8Encode(decodeURIComponent(str));
	x = str2blks_MD5(str);
	var a = 1732584193;
	var b = -271733879;
	var c = -1732584194;
	var d = 271733878;
	for (i = 0; i < x.length; i += 16) {
		var olda = a;
		var oldb = b;
		var oldc = c;
		var oldd = d;
		a = ff(a, b, c, d, x[i + 0], 7, -680876936);
		d = ff(d, a, b, c, x[i + 1], 12, -389564586);
		c = ff(c, d, a, b, x[i + 2], 17, 606105819);
		b = ff(b, c, d, a, x[i + 3], 22, -1044525330);
		a = ff(a, b, c, d, x[i + 4], 7, -176418897);
		d = ff(d, a, b, c, x[i + 5], 12, 1200080426);
		c = ff(c, d, a, b, x[i + 6], 17, -1473231341);
		b = ff(b, c, d, a, x[i + 7], 22, -45705983);
		a = ff(a, b, c, d, x[i + 8], 7, 1770035416);
		d = ff(d, a, b, c, x[i + 9], 12, -1958414417);
		c = ff(c, d, a, b, x[i + 10], 17, -42063);
		b = ff(b, c, d, a, x[i + 11], 22, -1990404162);
		a = ff(a, b, c, d, x[i + 12], 7, 1804603682);
		d = ff(d, a, b, c, x[i + 13], 12, -40341101);
		c = ff(c, d, a, b, x[i + 14], 17, -1502002290);
		b = ff(b, c, d, a, x[i + 15], 22, 1236535329);
		a = gg(a, b, c, d, x[i + 1], 5, -165796510);
		d = gg(d, a, b, c, x[i + 6], 9, -1069501632);
		c = gg(c, d, a, b, x[i + 11], 14, 643717713);
		b = gg(b, c, d, a, x[i + 0], 20, -373897302);
		a = gg(a, b, c, d, x[i + 5], 5, -701558691);
		d = gg(d, a, b, c, x[i + 10], 9, 38016083);
		c = gg(c, d, a, b, x[i + 15], 14, -660478335);
		b = gg(b, c, d, a, x[i + 4], 20, -405537848);
		a = gg(a, b, c, d, x[i + 9], 5, 568446438);
		d = gg(d, a, b, c, x[i + 14], 9, -1019803690);
		c = gg(c, d, a, b, x[i + 3], 14, -187363961);
		b = gg(b, c, d, a, x[i + 8], 20, 1163531501);
		a = gg(a, b, c, d, x[i + 13], 5, -1444681467);
		d = gg(d, a, b, c, x[i + 2], 9, -51403784);
		c = gg(c, d, a, b, x[i + 7], 14, 1735328473);
		b = gg(b, c, d, a, x[i + 12], 20, -1926607734);
		a = hh(a, b, c, d, x[i + 5], 4, -378558);
		d = hh(d, a, b, c, x[i + 8], 11, -2022574463);
		c = hh(c, d, a, b, x[i + 11], 16, 1839030562);
		b = hh(b, c, d, a, x[i + 14], 23, -35309556);
		a = hh(a, b, c, d, x[i + 1], 4, -1530992060);
		d = hh(d, a, b, c, x[i + 4], 11, 1272893353);
		c = hh(c, d, a, b, x[i + 7], 16, -155497632);
		b = hh(b, c, d, a, x[i + 10], 23, -1094730640);
		a = hh(a, b, c, d, x[i + 13], 4, 681279174);
		d = hh(d, a, b, c, x[i + 0], 11, -358537222);
		c = hh(c, d, a, b, x[i + 3], 16, -722521979);
		b = hh(b, c, d, a, x[i + 6], 23, 76029189);
		a = hh(a, b, c, d, x[i + 9], 4, -640364487);
		d = hh(d, a, b, c, x[i + 12], 11, -421815835);
		c = hh(c, d, a, b, x[i + 15], 16, 530742520);
		b = hh(b, c, d, a, x[i + 2], 23, -995338651);
		a = ii(a, b, c, d, x[i + 0], 6, -198630844);
		d = ii(d, a, b, c, x[i + 7], 10, 1126891415);
		c = ii(c, d, a, b, x[i + 14], 15, -1416354905);
		b = ii(b, c, d, a, x[i + 5], 21, -57434055);
		a = ii(a, b, c, d, x[i + 12], 6, 1700485571);
		d = ii(d, a, b, c, x[i + 3], 10, -1894986606);
		c = ii(c, d, a, b, x[i + 10], 15, -1051523);
		b = ii(b, c, d, a, x[i + 1], 21, -2054922799);
		a = ii(a, b, c, d, x[i + 8], 6, 1873313359);
		d = ii(d, a, b, c, x[i + 15], 10, -30611744);
		c = ii(c, d, a, b, x[i + 6], 15, -1560198380);
		b = ii(b, c, d, a, x[i + 13], 21, 1309151649);
		a = ii(a, b, c, d, x[i + 4], 6, -145523070);
		d = ii(d, a, b, c, x[i + 11], 10, -1120210379);
		c = ii(c, d, a, b, x[i + 2], 15, 718787259);
		b = ii(b, c, d, a, x[i + 9], 21, -343485551);
		a = add(a, olda);
		b = add(b, oldb);
		c = add(c, oldc);
		d = add(d, oldd);
	}
	return rhex(a) + rhex(b) + rhex(c) + rhex(d);
}

/**
 * ============================================================================
 * PLUGIN JQUERY NAME: CENTER 2.0 
 * URL: http://andreaslagerkvist.com/jquery/center/ 
 * HOW TO USE:
 * jQuery('#my-element').center(true); would center the element with ID
 * 'my-element' using absolute position (leave empty for fixed).
 * ============================================================================
 */
jQuery.fn.center = function (absolute) {
    return this.each(function () {
        var t = jQuery(this);

        t.css({
            position:    absolute ? 'absolute' : 'fixed', 
            left:        '50%', 
			top:         '14px', 
            zIndex:        '99'
        }).css({
            marginLeft:    '-' + (t.outerWidth() / 2) + 'px', 
            marginTop:    '-' + (t.outerHeight() / 2) + 'px'
        });

        if (absolute) {
            t.css({
                marginTop:    parseInt(t.css('marginTop'), 10) + jQuery(window).scrollTop(), 
                marginLeft:    parseInt(t.css('marginLeft'), 10) + jQuery(window).scrollLeft()
            });
        }
    });
};

/*
jQuery.fn.centerOverMap = function (absolute) {
    return this.each(function () {
        var t = jQuery(this);

        t.css({
            position:    absolute ? 'absolute' : 'fixed', 
            left:        '49%', 
			top:         '325px', 
            zIndex:        '99'
        }).css({
            marginLeft:    '-' + (t.outerWidth() / 2) + 'px', 
            marginTop:    '-' + (t.outerHeight() / 2) + 'px'
        });

        if (absolute) {
            t.css({
                marginTop:    parseInt(t.css('marginTop'), 10) + jQuery(window).scrollTop(), 
                marginLeft:    parseInt(t.css('marginLeft'), 10) + jQuery(window).scrollLeft()
            });
        }
    });
};
*/

/**
 * ============================================================================
 * PLUGIN JQUERY NAME: TIMERS 
 * jQuery.timers - Timer abstractions for jQuery
 * Written by Blair Mitchelmore (blair DOT mitchelmore AT gmail DOT com)
 * Licensed under the WTFPL (http://sam.zoy.org/wtfpl/).
 * Date: 2009/10/16
 * @author Blair Mitchelmore
 * @version 1.2
 * URL: http://plugins.jquery.com/project/timers
 * HOW TO USE:
 * everyTime(interval : Integer | String, [label = interval : String], fn :
 * Function, [times = 0 : Integer]) 
 * oneTime(interval : Integer | String, [label =
 * interval : String], fn : Function) 
 * stopTime([label : Integer | String], [fn :
 * Function])
 * ============================================================================
 */
jQuery.fn.extend({
	everyTime: function(interval, label, fn, times) {
		return this.each(function() {
			jQuery.timer.add(this, interval, label, fn, times);
		});
	},
	oneTime: function(interval, label, fn) {
		return this.each(function() {
			jQuery.timer.add(this, interval, label, fn, 1);
		});
	},
	stopTime: function(label, fn) {
		return this.each(function() {
			jQuery.timer.remove(this, label, fn);
		});
	}
});

jQuery.extend({
	timer: {
		global: [],
		guid: 1,
		dataKey: "jQuery.timer",
		regex: /^([0-9]+(?:\.[0-9]*)?)\s*(.*s)?$/,
		powers: {
			// Yeah this is major overkill...
			'ms': 1,
			'cs': 10,
			'ds': 100,
			's': 1000,
			'das': 10000,
			'hs': 100000,
			'ks': 1000000
		},
		timeParse: function(value) {
			if (value == undefined || value == null)
				return null;
			var result = this.regex.exec(jQuery.trim(value.toString()));
			if (result[2]) {
				var num = parseFloat(result[1]);
				var mult = this.powers[result[2]] || 1;
				return num * mult;
			} else {
				return value;
			}
		},
		add: function(element, interval, label, fn, times) {
			var counter = 0;
			
			if (jQuery.isFunction(label)) {
				if (!times) 
					times = fn;
				fn = label;
				label = interval;
			}
			
			interval = jQuery.timer.timeParse(interval);

			if (typeof interval != 'number' || isNaN(interval) || interval < 0)
				return;

			if (typeof times != 'number' || isNaN(times) || times < 0) 
				times = 0;
			
			times = times || 0;
			
			var timers = jQuery.data(element, this.dataKey) || jQuery.data(element, this.dataKey, {});
			
			if (!timers[label])
				timers[label] = {};
			
			fn.timerID = fn.timerID || this.guid++;
			
			var handler = function() {
				if ((++counter > times && times !== 0) || fn.call(element, counter) === false)
					jQuery.timer.remove(element, label, fn);
			};
			
			handler.timerID = fn.timerID;
			
			if (!timers[label][fn.timerID])
				timers[label][fn.timerID] = window.setInterval(handler,interval);
			
			this.global.push( element );
			
		},
		remove: function(element, label, fn) {
			var timers = jQuery.data(element, this.dataKey), ret;
			
			if ( timers ) {
				
				if (!label) {
					for ( label in timers )
						this.remove(element, label, fn);
				} else if ( timers[label] ) {
					if ( fn ) {
						if ( fn.timerID ) {
							window.clearInterval(timers[label][fn.timerID]);
							delete timers[label][fn.timerID];
						}
					} else {
						for ( var fn in timers[label] ) {
							window.clearInterval(timers[label][fn]);
							delete timers[label][fn];
						}
					}
					
					for ( ret in timers[label] ) break;
					if ( !ret ) {
						ret = null;
						delete timers[label];
					}
				}
				
				for ( ret in timers ) break;
				if ( !ret ) 
					jQuery.removeData(element, this.dataKey);
			}
		}
	}
});