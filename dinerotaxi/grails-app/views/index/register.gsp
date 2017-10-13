<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="main1" />
</head>
<body>
	<div id="loginRegisterBox" class="span-21">
    <!-- ====================================================
    Box for Customer Registration
    ========================================================= -->
    <div id="RTRegisterBox" class="span-11 areaBox">
        <p class="greenExtraLarge alignCenter">
            Registro de nuevo cliente en Wannataxi
        </p>
		<!--
        <div class="whiteBox">
            <p>
				Para que puedas usar Wannataxi es necesario que conozcamos tu n&uacute;mero de m&oacute;vil 
				para garantizarte el mejor servicio. Ten en cuenta que para validar el n&uacute;mero de 
				tel&eacute;fono que nos indiques te vamos a enviar un SMS.
            </p>
        </div>
		-->
		<g:if test="${flash.error}">
				<div class="errorNotification">${flash.error}</div>
			</g:if>
        <div id="registerErrorBox" class="span-11" style="display: none;">
            <p id="registerError" class="errorNotification">
            </p>
			
        </div>
        <form id="userRegisterForm" name="userRegisterForm" action="/register/register" method="post"  >
	        <div class="formField">

	            <label for="email">
	                Email
	            </label>
	            <input id="email"  name="email" class="textFieldShort" type="text" placeholder="matias@dinerotaxi.com">
	        </div>
	        <div class="formField">
	            <label for="password">
	                Elige tu contraseña
	            </label>
	            <input id="password"   name="password" class="textFieldShort" type="password" placeholder="*****">

	        </div>
	        <div class="formField">
	            <label for="password2">
	                Repítela, por favor
	            </label>
	            <input id="password2" name="password2" class="textFieldShort" type="password" placeholder="*****">
	        </div>
	       
	        <div class="paddingLeft30">
	            <input id="serviceConditionsAccepted" value="ok" type="checkbox">He leído y acepto las
				<a onclick="javascript:showTextInPopup(TEXT_SERVICE_CONDITIONS_FOR_USERS);" href="javaScript:;">Condiciones del servicio</a>
				así como las
				<a onclick="javascript:showTextInPopup(TEXT_USE_CONDITIONS);" href="javaScript:;">Condiciones de uso de la web</a>
				y la
				<a onclick="javascript:showTextInPopup(TEXT_PRIVACY_POLICY);" href="javaScript:;">Política de privacidad</a>
	        </div>

			<div class="formField small">
	        	<input id="noads" value="1" type="checkbox">No deseo recibir publicidad de WANNATAXI, SL&nbsp;
	    	</div>
	        <div class="alignRight">
	        	<a href="javascript:loadHomeCustomerNotLogged();" class="medium white nicebutton">Cancelar</a>
	        	<a onclick="javascript:callUserRegister();" href="#" class="large green nicebutton">Darme de alta</a>
				<input style="display: none;" type="submit">

	        </div>
		</form>
    </div>
    <!-- ====================================================
    Box for Customer Login
    ========================================================= -->
    <div id="RTLoginBox" class="span-8 areaBox last" style="display: none;">
        <p class="greenExtraLarge alignCenter">
            Acceso para clientes
        </p>
        <div id="userLoginErrorInBodyBox" style="display: none;">

            <p id="userLoginErrorInBody" class="errorNotification">
            </p>
        </div>
		<form id="userLoginInBodyForm" name="userLoginInBodyForm" action="javascript:callUserLoginInBody();">
	        <div class="formFieldMedium">
	            <label for="userMsisdn" class="labelShort">
	                Número de móvil
	            </label>
	            <input id="userMsisdn" class="textFieldExtraShort" type="text">

	        </div>
	        <div class="formFieldMedium">
	            <label for="userPassword" class="labelShort">
	                Contraseña
	            </label>
	            <input id="userPassword" class="textFieldExtraShort" type="password">
	        </div>
	        <div class="formFieldMedium alignRight">
	            <span class="small"><input checked="checked" id="userRememberCheckbox" value="rememberMe" type="checkbox">Recordarme</span>

	        </div>
	        <div class="formFieldMedium alignRight">
	            <a href='<g:createLink params="[country:"${params?.country?:''}"]"  controller="register" action="forgotPassword"/>' class="small">¿olvido su contraseña?</a> 
	        </div>
	        <p class="alignRight">
	        	<a onclick="$('#userLoginInBodyForm').submit();" href="#" class="medium green nicebutton">Entrar</a>
				<input style="display: none;" type="submit">
	        </p>

		</form>
    </div>
	
	<div id="spacer" class="span-8 spacer-20">
        &nbsp;
    </div>

    <!-- ====================================================
    Box for Mobile Phone Validation text & button
    ========================================================= -->
    <div id="RTValidateBox" class="span-8 areaBox bgGreyBeige last">    
    	<p>
            Para validar tu número de teléfono móvil te vamos a enviar un SMS con un código para 
			que puedas completar tu registro. Te recomendamos que uses tú número de teléfono móvil 
			habitual, el que lleves ahora mismo contigo.
		</p>

		<p>
    		¿Ya te has registrado previamente y has recibido un SMS con el código de validación?
    		<br><br>
			<a onclick="javascript:loadValidateUserLaterBox();" href="#" class="medium white nicebutton floatRight">Validar móvil</a>
		</p>
	</div>
	
    <div id="spacer" class="span-21 spacer-5">
        &nbsp;
    </div>

</div>
</body>
</html>
