<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="main1" />
</head>
<body>
	<!-- ===== BODY ====================== -->
		<div id="homeCustomerNotLoggedBox" class="span-21">
			<div id="howToRequestATaxiBox" class="span-21">
				<p class="greenExtraLarge alignCenter">Pedir un taxi con
					Wannataxi es así de fácil</p>
				<img src="/images/how_to_request_a_taxi.png"
					alt="Como pedir un taxi con Wannataxi">
			</div>


			<div id="newUserBox" class="span-9 areaBox bgWhite">
				<div>
					<p class="greenExtraLarge alignCenter">¿Es tu primera vez en
						Wannataxi?</p>
					<p>
						Para poder usar Wannataxi es necesario que te registres como
						usuario, y para ello sólo necesitamos tu nombre y tu número de
						teléfono, así de fácil. <br>
						<br>
					</p>
					<p class="alignRight">
						<g:link  params="[country:"${params?.country?:''}"]" controller="index" action="register" class="medium green nicebutton">Registrarme</g:link>
					</p>
				</div>

			</div>
			<div id="spacer" class="span-1">&nbsp;</div>

			<div id="RTLoginBox" class="span-9 areaBox bgWhite last">
				<p class="greenExtraLarge alignCenter">¿Ya eres cliente?</p>

				<div id="userLoginErrorInBodyBox" style="display: none;">
					<p id="userLoginErrorInBody" class="errorNotification"></p>
				</div>
				<form action="${request.contextPath}/j_spring_security_check"
				method='POST' id='userLoginInBodyForm'  name="userLoginInBodyForm" class='cssform' autocomplete='on'>
				
					<div class="formFieldMedium">
						<label for="userMsisdn" class="labelShort">Email </label>
						<input id='username' type='text'
					class='textFieldExtraShort' name='j_username' placeholder="matias@dinerotaxi.com" />
						
					</div>
					<div class="formFieldMedium">
						<label for="userPassword" class="labelShort"> Contraseña </label>
						<input id='password' type='text'
					class='textFieldExtraShort' name='j_password' placeholder="****"/>
						
					</div>
					<div class="formFieldMedium alignRight">

						<span class="small"><input checked="checked"
							id="userRememberCheckbox" value="rememberMe" type="checkbox">Recordarme</span>
					</div>

					<div class="formFieldMedium alignRight">
						
	            		<a href='<g:createLink params="[country:"${params?.country?:''}"]"  controller="register" action="forgotPassword"/>' class="small">¿olvido su contraseña?</a> 
						&nbsp;&nbsp; <a onclick="$('#userLoginInBodyForm').submit();"
							href="#" class="medium green nicebutton">Entrar</a> <input
							style="display: none;" type="submit">
							<s2ui:linkButton elementId='register' class="medium green nicebutton" controller='register' messageCode='spring.security.ui.login.register'/>
					</div>

				</form>
			</div>

			<!-- <div id="spacer" class="span-20 spacer-10">&nbsp;</div> -->
			<!--
	<div id="loginBox" class="span-20 areaBox">
		<p class="alignLeft">
            <a href="javascript:loadHome();" class="medium white nicebutton">Volver</a>
        </p>	
	</div>
	-->
		</div>
	</div>
	<!-- ===== REQUEST A TAXI ======== -->
	<div style="display: none;" id="RTWrapper"></div>

	<!-- ===== CUSTOMER PROFILE ======== -->
	<div style="display: none;" id="customerProfileWrapper"></div>


</body>
</html>
