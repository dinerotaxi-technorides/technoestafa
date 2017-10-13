
//-------------------------------------------------
// CHANGES START HERE

//facebook app id
var clientID = '232931593411843';
//perms needed for the app
var appPerms = {scope: ''};
//page with the login area
var urlLoginPage = 'https://www.dinerotaxi.com/login/auth';
//first time logged 
var urlLoggedHome = 'https://www.dinerotaxi.com/home/pedir';
//page to go when logout
var urlLoginPage = 'https://www.dinerotaxi.com/login/auth';
//callbacks to call after FB.init has run
if(typeof(callbacksAfterFbInit) === "undefined"){
	var callbacksAfterFbInit = [];
}
//to know if ran FB.init
var fbInited = false;

var baseAppUrl= "";
var url= "";

function initFacebookIntegration() {
	
	//called after loaded facebook sdk lib
	window.fbAsyncInit = function() {
		//init facebook sdk
		FB.init({
			appId : clientID,
			status : true,
			cookie : true,
			xfbml : true,
			session:false,
			oauth : true
		});
		fbInited = true;
		
		//_adjustCanvasHeight();
		
		//call user callbacks:
		//copy to not allow modification in the cycle
		var _cbs = callbacksAfterFbInit.slice(0);
		for(var i = 0; i < _cbs.length ; i++){
			_cbs[i]();
		}
	};

	//load facebook javascript sdk library
   (function() {
	     var e = document.createElement("script");
	     e.type = "text/javascript";
	     e.src = document.location.protocol +
	     "//connect.facebook.net/es_LA/all.js";
	     e.async = true;
	     document.getElementById("fb-root").appendChild(e);
	   }());
}

/**
 * Adjust the canvas height
 */
function _adjustCanvasHeight(){
	
	//Adjust Canvas height
	FB.Canvas.setAutoGrow(true);
	var last_height = 0;
	setInterval(function() {
		var height = $('html').height();
		if (height != last_height) {
			FB.Canvas.setSize({
				height : height
			});
			last_height = height;
		}
	}, 500);
	$(".fb-preload")
		.css("visibility", "visible")
		.removeClass("fb-preload");	
}

/**
 * Add callbacks to run after FB init only once
 */
function addFBinitCallbacksOnce(cb){
	var cbs = callbacksAfterFbInit;
	var length = cbs.length;
	for(var i = 0; i < length; i++){
		if(cbs[i] === cb){return;}				
	}
	cbs[length] = cb;
}

/**
 * Manual login a facebook user and accept facebook app 
 * if success redirect to urlLoggedHome
 */
function loginFacebookUser(){
	
	//need to wait for FB init
	if(fbInited === false){
		addFBinitCallbacksOnce(window.loginFacebookUser);
		return;
	}
	//FB init was started
	FB.getLoginStatus(function(response) {
		  if (response.status === 'connected') {
		    // the user is logged in and has authenticated your app
		    //var uid = response.authResponse.userID;
		    //var accessToken = response.authResponse.accessToken;
			location.href = urlLoggedHome; 
		  } else {
			  //response.status === 'not_authorized'
			  	//the user is logged in to Facebook, 
			  	//but has not authenticated your app
			  //response.status === 'unknown'
			  	//the user isn't logged in to Facebook.
			  FB.login(function(response) {
				   if (response.authResponse) {
					 //logged now  
					 location.href = urlLoggedHome;		   
				   } else {
					   //User cancelled login or did not fully authorize.
					   //nothing to do
				   }
			  }, appPerms);			  
		  }
	 });
}

/**
 * Call this function inside every page which need
 * the facebook user logged in, and accepted the app perms 
 */
function verifyFacebookUserLogin(){
	
	//need to wait for FB init
	if(fbInited === false){
		addFBinitCallbacksOnce(window.verifyFacebookUserLogin);
		return;
	}
	//FB init was started
	FB.getLoginStatus(function(response) {
		  if (response.status === 'connected') {
		    // the user is logged in and has authenticated your app
		    //var uid = response.authResponse.userID;
		    //var accessToken = response.authResponse.accessToken;
			  
		    //nothing to do, continue in the same page
		  } else {
			  //response.status === 'not_authorized'
			  	//the user is logged in to Facebook, 
			  	//but has not authenticated your app
			  //response.status === 'unknown'
			  	//the user isn't logged in to Facebook.
			  FB.login(function(response) {
				   if (response.authResponse) {
					 //logged now  
					   
					 //nothing to do, continue in the same page		   
				   } else {
					   //User cancelled login or did not fully authorize.
					   location.href = urlLoginPage;
				   }
			  }, appPerms);			  
		  }
	 });
}

/**
 * Logout a user from facebook
 * and redirect to logout page  
 */
function logoutFacebook(url) {
	
	//need to wait for FB init
	if(fbInited === false){
		addFBinitCallbacksOnce(window.logoutFacebook);
		return;
	}	
	//FB init was started
	FB.logout(function(response) {
		// user is now logged out
		location.href = url;
	});
}

// END OF CHANGES
//-------------------------------------------------

function inviteFriendsToAppPredef(accessToken) {
	inviteFriends(
			accessToken,
			'iframe',
			function(response) {
				if (response && response.request_ids) {
					var inviteCount = (response.request_ids).toString().split(
							',').length;
					var message;
					if (inviteCount == 1) {
						message = '<p><strong>Congrats!</strong> Thank you for inviting your friend</p>';
					} else if (inviteCount > 1) {
						message = '<p><strong>Congrats!</strong> Thank you for inviting '
								+ inviteCount + ' friends</p>';
					}
					showSuccessMessage(message);
				}
			},"ssssss");
}

function inviteFriend(button,userId, accessToken) {
	inviteFriendHelper(button,
			accessToken,
			userId,
			'iframe',"ssssss");
}

function inviteFriendHelper(button,fbaccessToken, userId, displayType,inviteMessage) {
	FB.ui({
		method : 'apprequests',
		message : inviteMessage,
		to : userId
	}, function(response) {
		if(response){			
			showSuccessMessage('The user has been invited successfully');
			button.addClass("disabled");
			button.attr('onClick','');
		}
	});
}

function inviteFriends(fbaccessToken, displayType, callBackFunction,
		inviteMessage) {
	FB.ui({
		access_token : fbaccessToken,
		method : 'apprequests',
		title : 'DineroTaxi',
		message : inviteMessage,
		filters : [ 'app_non_users' ],
		display : displayType
	}, function(response) {
		callBackFunction(response);
	});
}

function postYourFace(fbClientId, fbaccessToken, displayType, captionText,
		symbol, successText) {
	FB.ui({
		access_token : fbaccessToken,
		method : 'feed',
		to : fbClientId,
		name : 'dinerotaxi',
		display : displayType,
		link : 'http://apps.facebook.com/dinerotaxi',
		picture : 'http://static.dinerotaxi.com/symbols/logo/'
				+ symbol.toUpperCase() + '.gif',
		caption : captionText
	}, function(response) {
		if (response && response.post_id) {
			showSuccessMessage(successText);
		}
	});
}

function postYourBalance(fbaccessToken, displayType, userTo, captionText,
		successText) {
	FB.ui({
		access_token : fbaccessToken,
		method : 'feed',
		to : userTo,
		name : 'dinerotaxi',
		display : displayType,
		link : 'http://apps.facebook.com/dinerotaxi',
		picture : 'http://static.dinerotaxi.com/balance.png',
		caption : captionText
	}, function(response) {
		if (response && response.post_id) {
			showSuccessMessage(successText);
		}
	});
}

function sharePost(fbaccessToken, captionText, successText, link) {
	var reg = /[^\s\r\n]?\$(\.?([a-zA-Z])+(\.[a-zA-Z])?)/g;
	var ar = reg.exec(captionText);
	var symbol = ar ? ar[1].toUpperCase() : 'clover';
	var obj = {
		method : 'feed',
		name : 'Follow this post on dinerotaxi',
		link : link,
		picture : 'http://static.dinerotaxi.com/symbols/logo/' + symbol
				+ '.gif',
		caption : captionText,
		actions : [ {
			name : 'Comment on dinerotaxi',
			link : link
		} ],
		user_message_prompt : 'Join this conversation on dinerotaxi'
	};

	// if (fbaccessToken!=''){
	// obj.access_token=fbaccessToken;
	// }

	FB.ui(obj, function(response) {
		if (response && response.post_id) {
			showSuccessMessage(successText);
		}
	});
}

function shareOnFacebook(title, captionText, successText, link, img) {
	var obj = {
		method : 'feed',
		name : title,
		link : link,
		picture : (img)?img:'http://static.dinerotaxi.com/symbols/logo/clover.gif',
		caption : captionText,
		actions : [ {
			name : 'Join dinerotaxi',
			link : 'http://www.dinerotaxi.com'
		} ],
		user_message_prompt : title
	};

	// if (fbaccessToken!=''){
	// obj.access_token=fbaccessToken;
	// }

	FB.ui(obj, function(response) {
		if (response && response.post_id) {
			showSuccessMessage(successText);
		}
	});
}

function shareTradeFacebook(fbaccessToken, captionText, successText, link) {
	var obj = {
		method : 'feed',
		name : 'Share something',
		link : link,
		picture : 'http://static.dinerotaxi.com/symbols/logo/clover.gif',
		caption : captionText,
		actions : [ {
			name : 'Comment on dinerotaxi',
			link : link
		} ],
		user_message_prompt : 'Join this conversation on dinerotaxi'
	};
	FB.ui(obj, function(response) {
		if (response && response.post_id) {
			showSuccessMessage(successText);
		}
	});
}

function socialLogin(provider) {
	var a = document.getElementsByName('loginForm' + provider);
	a[0].submit();
}

function renewFacebookAccessToken() {
	FB.login(function(response) {
		
	}, {
		scope : 'email'
	});
}

function loginWithFacebook(clientId) {
	FB.login(
		function(response) {
			if (response.authResponse) {
				var accessToken = response.authResponse.accessToken;
				var userId = response.authResponse.userID;
				$("body").css("cursor", "progress");
				window.location.href = window.location.href;
			} else {
			}
	}, {
		scope : 'email'
	});
}

function linkFacebookModalDialog() {
	FB
			.login(
					function(response) {
						if (response.authResponse) {
							var accessToken = response.authResponse.accessToken;
							FB
									.api(
											'/me',
											function(response) {
												$
														.ajax({
															type : 'GET',
															data : 'facebookId='
																	+ response.id,
															url : baseAppUrl
																	+ '/facebook/linkedUser',
															dataType : 'json',
															complete : function(
																	data) {
																var res = $
																		.parseJSON(data.responseText)
																if (res.error
																		&& res.ans.code == 5) {
																	// NO
																	// USUARIOS
																	// LINKEADOS
																	$
																			.ajax({
																				type : 'POST',
																				data : 'facebookId='
																						+ response.id
																						+ "&keep=true&accessToken="
																						+ accessToken,
																				url : baseAppUrl
																						+ '/facebook/linkFacebook',
																				dataType : 'html',
																				success : function(
																						data) {
																					window.location
																							.reload();
																				},
																				error : function(
																						data) {
																					$(
																							'#modalDialog')
																							.remove();
																					showErrorMessage("<p><strong>Error!</strong> "
																							+ data.responseText
																							+ "</p>");
																				}
																			});
																} else {
																	// SE
																	// ENCONTRO
																	// USUARIO
																	// LINKEADO
																	var json = JSON
																			.stringify(response);
																	$
																			.ajax({
																				type : 'POST',
																				data : json,
																				contentType : "application/json; charset=utf-8",
																				dataType : "html",
																				url : baseAppUrl
																						+ '/facebook/linkFacebookModal',
																				success : function(
																						data) {
																					showDialog(data);
																				}
																			});
																}
															}
														});
											});
						} else {
						}
					}, {
						scope : 'email'
					});
}

function linkFacebookAccount() {
	FB.login(function(response) {
		if (response.authResponse) {
			var accessToken = response.authResponse.accessToken;
			FB.api('/me', function(response) {
				var keep = $('#keep-portfolio input:checked').val() == '0';
				$.ajax({
					type : 'POST',
					data : 'facebookId=' + response.id + "&keep=" + keep
							+ "&accessToken=" + accessToken,
					url : baseAppUrl + '/facebook/linkFacebook',
					dataType : 'html',
					success : function(data) {
						window.location.reload();
					},
					error : function(data) {
						$('#modalDialog').remove();
						showErrorMessage("<p><strong>Error!</strong> "
								+ data.responseText + "</p>");
					}
				});
			});
		} else {
		}
	}, {
		scope : 'email'
	});
}

