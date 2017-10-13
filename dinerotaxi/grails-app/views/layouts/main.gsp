<!DOCTYPE html>
<html>
	<head>
		<title>DineroTaxi.com</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<!-- META for Google Webmasters -->
		<meta name="google-site-verification"
				content="NBzIvboQVvrq0MoRtNg_bbN7g6Qf-zWkn6wDGarb0lk" />
		<meta name="author" content="DineroTaxi" />
		<meta name="version" content="1.0" />
		<meta name="description"
				content="Dinero es un servicio para pedir taxis de forma automatica desde el movil. Con DineroTaxi tienes tu taxi en tu movil">
		<meta name="keywords"
				content="taxi quiero pedir solicitar Madrid Barcelona Sevilla Valencia automatico aqui ahora android iphone blackberry">
		<meta name="copyright"
				content="Copyright (c) DineroTaxi.com Todos los derechos reservados." />
		<!-- METAS for Facebook -->
		<meta property="og:title" content="DineroTaxi" />
		<meta property="og:type" content="company" />
		<meta property="og:url" content="https://www.dinerotaxi.com" />
		<meta property="og:image"
				content="${resource(dir:'images',file:'logo_dinerotaxi_only_image.png')}" />
		<link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
		<link rel="apple-touch-icon-precomposed" href="${resource(dir:'images',file:'icon.png')}">
		<link rel="stylesheet"
				href="${resource(dir:'css/blueprint',file:'screen.css')}"
				type="text/css" media="screen, projection">
		<link rel="stylesheet"
				href="${resource(dir:'css/blueprint',file:'print.css')}"
				type="text/css" media="print">
		<!--[if lt IE 8]><link rel="stylesheet" href="css/blueprint/ie.css" type="text/css" media="screen, projection"><![endif]-->
		<link rel="stylesheet"
				href="${resource(dir:'css',file:'dinerotaxi.css')}" type="text/css"
				media="screen" />
		<script type="text/javascript"
				src="${resource(dir:'js/dinerotaxi',file:'jquery.js')}"></script>
		<script type="text/javascript"
				src="${resource(dir:'js/dinerotaxi',file:'dinerotaxi_commons.js')}"></script>
		<script type="text/javascript"
				src="${resource(dir:'js/dinerotaxi',file:'dinerotaxi_user.js')}"></script>
		<script type="text/javascript"
				src="${resource(dir:'js/dinerotaxi',file:'dinerotaxi_ajax_user.js')}"></script>
		<script type="text/javascript"
				src="${resource(dir:'js/dinerotaxi',file:'dinerotaxi_session_user.js')}"></script>
		<!--Google Maps API-->
		<script
				src="https://maps.google.com/maps/api/js?v=3&sensor=false&region=ES"
				type="text/javascript"></script>
		<!--Google Analytics-->
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-29162604-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
		<!-- GOOGLE +1 BUTTON -->
		<script type="text/javascript"
				src="https://apis.google.com/js/plusone.js">
		{lang: 'es'}
		</script>
		
		<g:layoutHead />
	</head>
	<body>
	<!-- FACEBOOK LIKE BUTTON -->
		<div id="fb-root"></div>
		<script>(function(d, s, id) {
var js, fjs = d.getElementsByTagName(s)[0];
if (d.getElementById(id)) {return;}
js = d.createElement(s);
js.id = id;
js.src = "${resource(dir:'js/facebook',file:'all.js')}#xfbml=1";
fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
		<div id="container" class="container">
            <!-- ===== HEADER ====================== -->
            <div id="headerWrapper" class="headerWrapper">
                <span id="notification" class="notification" style="display: none;"></span>
				<div id="userStatusBox" class="span-23">
	                <div id="userStatusLeftBox" class="span-3 prepend-1">
	                	<div class="switchToMobile">
							<span class="small">
	        					<a href="mobile"><img src="${resource(dir:'images',file:'icon_mobile_small.png')}" alt="<g:message code="home.message.version.movile" default="Versi�n M�vil"/>" title="<g:message code="home.message.version.movile" default="Versi�n M�vil"/>"></a><a href="mobile" class="switchToMobile"><g:message code="home.message.version.movile" default="Versi�n M�vil"/></a>&nbsp;

							</span>
						</div>
					</div>
					<div id="userStatusRightBox" class="span-6 prepend-12">
	                    <div class="alignCenter userStatus">
	                        <span style="display: inline;" id="userAccess"><g:message code="home.message.areyouclient" default="�Eres Usuario?"/> <a href="javascript:toggleUserLoginBox();" class=""><g:message code="home.message.enter" default="Ingresar"/></a></span>
	                        <span id="loggedUser" style="display: none;">
	                        	<a href="javascript:loadCustomerProfile();"><img src="${resource(dir:'images',file:'icon_user_small.png')}" alt="<g:message code="home.message.userdata" default="Datos de usuario"/>" title="<g:message code="home.message.userdata" default="Datos de usuario"/>"></a>

								<a href="javascript:loadCustomerProfile();" class="userName"><span id="loggedUserName"></span></a>
								&nbsp;|&nbsp;<a href="javascript:callUserLogout();"><g:message code="home.message.exit" default="Salir"/></a>
							</span>
	                        <span id="exitTaxiZone" style="display: none;"><a href="javascript:callTaxiLogout();loadHome();"><g:message code="home.message.exit.taxi" default="Salir de la Zona del Taxista"/></a></span>
	                    </div>
	                </div>
				</div>

                <div id="userLoginBox" class="span-21 prepend-1" style="display: none;">
					<div class="loginBox">
						<form id="userLoginForm" name="userLoginForm" action="javascript:callUserLoginInHeader();">
							<span class="labelLogin2">Email</span>&nbsp;
							<input class="textFieldLogin" id="userLoginMsisdn" name="userLoginMsisdn" type="text">&nbsp;
							<span class="labelLogin2">Contrase�a</span>&nbsp;
							<input class="textFieldLogin" id="userLoginPassword" name="userLoginPassword" type="password">&nbsp;
							<span class="small"><input id="userRememberCheckbox" value="rememberMe" checked="checked" type="checkbox"><g:message code="home.message.remember" default="Recordarme"/></span>

							<a onclick="$('#userLoginForm').submit();" href="#" class="small white nicebutton"><g:message code="home.message.enter" default="Entrar"/></a>
							<a onclick="javascript:showUserRememberPasswordInPopup();" href="#" class="small"><g:message code="home.message.missing.user" default="�Olvidaste tu contrase�a?"/></a>
							<input style="display: none;" type="submit">
							<a href="javascript:toggleUserLoginBox();" class="floatRight"><img src="${resource(dir:'images',file:'close-icon.png')}" alt="<g:message code="home.message.close" default="Cerrar"/>" height="24" width="24"></a>&nbsp;
						</form>
					</div>
                </div>
				<div id="userLoginErrorInHeaderBox" class="span-21 prepend-1" style="display: none;">

                    <p id="userLoginErrorInHeader" class="errorNotification"></p>
                </div>
				<div id="headerLogo" class="span-23 headerLogo">
					<div id="headerLogo_left" class="span-5 alignLeft">
                        <img src="${resource(dir:'images',file:'separator_vert.png')}">
                    </div>
                    <div id="headerLogo_center" class="span-13 alignCenter">
                        <a href="javascript:loadHome();"><img src="${resource(dir:'images',file:'Logo_dinerotaxi_486x85_w.png')}" alt="<g:message code="home.message.logo" default="Logo DineroTaxi"/>"></a>
                    </div>

                    <div id="headerLogo_right" class="span-3 alignLeft">
                        <img src="${resource(dir:'images',file:'tag_beta.png')}" alt="beta">
                    </div>
					<div id="headerLogo_spinner" class="span-1 alignRight last">
						<span style="display: none;" id="loader" class="alignRight"><img src="${resource(dir:'images',file:'ajax-loader.gif')}" alt="<g:message code="home.message.loading" default="Cargando..."/>"></span>
					</div>
				</div>
			</div>
			<div id="bodyContainer" class="span-24 bodyContainer">
				<div class="span-23 spacer-10">
                	&nbsp;
           		</div>
				<div class="span-1">
                	&nbsp;
            	</div>
	            <!-- ===== REGISTER OR LOGIN ======================== -->
	            <div style="display: none;" id="loginRegisterWrapper">

	            </div>
	            <!-- ===== HOME ======================== -->
	            <div style="display: block;" id="homeWrapper"><div id="spacer" class="span-1 alignCenter">
				    &nbsp;
				</div>
					<g:layoutBody />
			</div>
	<div class="span-21 prepend-2 spacer-10">&nbsp;</div>
			<div id="footerWrapper" class="span-23">
				<div id="socialButtonsBox" class="alignCenter">
					<!-- TWITTER BUTTON -->
			       	<iframe title="Twi`tter para sitios web: Boton para Twittear" style="width: 118px; height: 20px" class="twitter-share-button twitter-count-horizontal" src="https://platform.twitter.com/widgets/tweet_button.html#_=1321300283576&amp;count=horizontal&amp;dnt=&amp;id=twitter_tweet_button_0&amp;lang=es&amp;original_referer=http%3A%2F%2Fdinerotaxi.com%2Fuser%2F&amp;text=%C2%BFTodav%C3%ADa%20no%20conoces%20dinerotaxi%3F&amp;url=http%3A%2F%2Fwww.dinerotaxi.com&amp;via=dinerotaxi" allowtransparency="true" frameborder="0" scrolling="no"></iframe>
		        	<script type="text/javascript" src="https://platform.twitter.com/widgets.js"></script>

					<!-- FACEBOOK LIKE BUTTON -->
						<!-- GOOGLE +1 BUTTON -->
	                <div style="height: 20px; width: 90px; display: inline-block; text-indent: 0pt; margin: 0pt; padding: 0pt; background: none repeat scroll 0% 0% transparent; border-style: none; float: none; line-height: normal; font-size: 1px; vertical-align: baseline;" id="___plusone_0"><iframe allowtransparency="true" hspace="0" id="I1_1321300283796" marginheight="0" marginwidth="0" name="I1_1321300283796" src="https://plusone.google.com/u/0/_/+1/fastbutton?url=http%3A%2F%2Fdinerotaxi.com%2Fuser%2F&amp;size=medium&amp;count=true&amp;annotation=&amp;hl=es&amp;jsh=r%3Bgc%2F25095437-ce843676#id=I1_1321300283796&amp;parent=http%3A%2F%2Fdinerotaxi.com&amp;rpctoken=500412297&amp;_methods=onPlusOne%2C_ready%2C_close%2C_open%2C_resizeMe" style="position: static; left: 0pt; top: 0pt; width: 90px; margin: 0px; border-style: none; height: 20px; visibility: visible;" tabindex="-1" vspace="0" title="+1" frameborder="0" scrolling="no" width="100%"></iframe></div>
					<div style="align:center;" class="fb-like fb_edge_widget_with_comment fb_iframe_widget" data-href="https://www.dinerotaxi.com" data-send="false" data-layout="button_count" data-width="120" data-show-faces="false"><span><iframe src="http://www.facebook.com/plugins/like.php?channel_url=https%3A%2F%2Fs-static.ak.fbcdn.net%2Fconnect%2Fxd_proxy.php%3Fversion%3D3%23cb%3Df355dda7e3c8208%26origin%3Dhttp%253A%252F%252Fdinerotaxi.com%252Ff2a5c6f48789358%26relation%3Dparent.parent%26transport%3Dpostmessage&amp;extended_social_context=false&amp;href=http%3A%2F%2Fwww.dinerotaxi.com&amp;layout=button_count&amp;locale=es_ES&amp;node_type=link&amp;sdk=joey&amp;send=false&amp;show_faces=false&amp;width=120" class="fb_ltr" title="Like this content on Facebook." style="border: medium none; overflow: hidden; height: 20px; width: 120px;" name="f37d57776c284d8" id="f352bb0417c3eec" scrolling="no"></iframe></span></div>
				</div>
				
				<ul id="menuFooterlinks" class="horizUL">
	                <li>

	                    @ 2011 dinerotaxi.com
	                </li>
	                <li>
	                    &nbsp;|&nbsp;
	                </li>
	                <li>
	                    <a onclick="javascript:showTextInPopup(TEXT_PRIVACY_POLICY);" href="javaScript:;"><g:message code="home.message.politica" default="Pol�tica de Privacidad"/></a>
	                </li>

					<li>
	                    &nbsp;|&nbsp;
	                </li>
					<li>
	                    <a onclick="javascript:showTextInPopup(TEXT_USE_CONDITIONS);" href="javaScript:;"><g:message code="home.message.condiciones" default="Condiciones de uso"/></a>
	                </li>
					<li>
	                    &nbsp;|&nbsp;

	                </li>
					<li>
					<g:message code="home.message.contact" default="Contacta con nosotros por "/>
					<a href="mailto:info@dinerotaxi.com"><g:message code="home.message.contact.email" default="Email"/></a>
					<g:message code="home.message.contact.or" default=" o por "/>
						<a target="_blank" href="https://twitter.com/dinerotaxi">
					<g:message code="home.message.contact.twitter" default="Twitter"/></a>
					</li>
					
	            </ul>

			</div>
	        <div class="span-21 prepend-2 spacer-20">&nbsp;</div>
        </div>
	<!-- ===== FOOTER ====================== -->
	        
			</div>
		<!-- ===== POPUP MODAL ====================== -->
		<div id="popupContact">
				<a id="popupContactClose"><img src="${resource(dir:'images',file:'close-icon.png')}"
						height="24" width="24" alt="Cerrar" />
				</a>
				<div id="popupItem"></div>
				<div id="privacyPolicyBox" style="display: none;">
						<div class="bgGreyBeige areaBox last">
						
								<p class="purpleBoldLarge"><g:message code="home.message.contact.politic" default="Pol�tica de Privacidad"/></p>
								<div id="privacyPolicy" class="scrollableBox small"></div>
						</div>
				</div>
				<div id="useConditionsBox" style="display: none;">
						<div class="bgGreyBeige areaBox last">
								<p class="purpleBoldLarge"><g:message code="home.message.contact.use" default="Condiciones de Uso de la web"/></p>
								<div id="useConditions" class="scrollableBox small"></div>
						</div>
				</div>
				<div id="userServiceConditionsBox" style="display: none;">
						<div class="bgGreyBeige areaBox last">
								<p class="purpleBoldLarge">
								<g:message code="home.message.contact.contract" default="Contrato de prestaci&oacute;n de servicios"/>
								
								</p>
								<div id="userServiceConditions" class="scrollableBox small">
								</div>
						</div>
				</div>
				<div id="userRememberPasswordBox" style="display: none;">
						<div class="bgGreyBeige areaBox last">
								<p class="purpleBoldLarge"><g:message code="home.message.box.miss" default="&iquest;Has olvidado tu	contrase&ntilde;a?"/>
								</p>
								<p>
								<g:message code="home.message.box.tele" default="Dinos un n&uacute;mero de tel&eacute;fono m&oacute;vil y te enviaremos una nueva contrase&ntilde;a por SMS"/>
								</p>
								<div id="userRememberPasswordErrorBox" style="display: none;">
										<p id="userRememberPasswordError" class="errorNotification">
										</p>
								</div>
								<form id="userRememberPasswordForm"
										name="userRememberPasswordForm"
										action="javascript:callUserRememberPassword();">
										<div class="formField">
												<label for="rememberPasswordMsisdn">
												<g:message code="home.message.box.tel" default="Email"/>
														</label> <input type="text"
														id="rememberPasswordMsisdn" class="textFieldExtraShort" />
										</div>
										<div class="formField">
												<label for="rememberPasswordCaptcha">
												<g:message code="home.message.box.imag" default="&iquest;Qu&eacute; pone en la imagen? "/>
														</label> <input type="text"
														id="rememberPasswordCaptcha" class="textFieldExtraShort" />
										</div>
										<p class="captchaBox">
												<img id="rememberPasswordCaptchaImage"
														src="${resource(dir:'images',file:'captcha_empty.png')}" alt="Imagen de seguridad" />
												<br /> <span class="small">
												<g:message code="home.message.box.imag.1" default="&iquest;No entiendes el texto de la imagen?&nbsp;"/>
												<a
														onclick='javascript:reloadRememberPasswordCaptcha();'
														href='#'><g:message code="home.message.box.imag.2" default="Cargar otra imagen"/></a>
												</span>
										</p>
										<div class="alignRight">
												<a onclick="$('#userRememberPasswordForm').submit();"
														href="#" class="large green nicebutton"><g:message code="home.message.box.new.pass" default="Enviar nueva contrase&ntilde;a"/></a> <input type="submit"
														style="display: none;" />
										</div>
										<input type="hidden" id="rememberPasswordCaptchaid" />
								</form>
						</div>
				</div>
				<p class="small lightGrey alignRight"><g:message code="home.message.box.new.scape" default="Presiona la tecla 'Escape' para cerrar"/>
						</p>
		</div>
		<div id="backgroundPopup"></div>
		<input type="hidden" id="timestamp" value="" />
		<!--Google Analytics-->
		<script type="text/javascript"> (function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
</script>
	</body>
</html>