<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page import="ar.com.goliath.EnabledCities"%>
<html xmlns:og="http://ogp.me/ns#">
<head>
<%--        <meta name="layout" content="main_facebook" />--%>
<meta name="google-site-verification"
	content="NBzIvboQVvrq0MoRtNg_bbN7g6Qf-zWkn6wDGarb0lk" />
<meta name="author" content="DineroTaxi" />
<meta name="version" content="1.0" />
<meta name="description"
	content="DineroTaxi es un servicio para pedir taxis de forma automatica desde el movil. Con DineroTaxi tienes tu taxi en tu movil">
<meta name="keywords"
	content="taxi quiero pedir solicitar Madrid Barcelona Sevilla Valencia automatico aqui ahora android iphone blackberry">
<meta name="copyright"
	content="Copyright (c) DineroTaxi.com Todos los derechos reservados." />
<!-- METAS for Facebook -->
<meta property="og:title" content="DineroTaxi" />
<meta property="og:type" content="company" />
<meta property="og:url" content="https://www.dinerotaxi.com" />
<meta property="og:image"
	content="${resource(dir:'img',file:'favicon.ico')}" />


<link href="${resource(dir:'assets/css',file:'styles.css')}"
	rel="stylesheet">
</head>
<body>
	<div class="dt-container">
		<g:if test="${!facebookContext.app.id}">
			<g:render template="/website/configError" />
		</g:if>
		<g:else>
			<!--
			  We use the Facebook JavaScript SDK to provide a richer user experience. For more info,
			  look here: http://github.com/facebook/facebook-js-sdk
			-->

			<img src="${resource(dir:'assets/images',file:'1.png')}" alt="Paso 1"
				width="14" height="41" class="dt-float-left dt-number-section">
			<h1>Registrate</h1>
			<hr>
			<form action="#" class="dt-fomr" method="POST"
				novalidate="novalidate">
				<fieldset>
					<!-- <legend>Inputs</legend> -->
					<p class="dt-hint">* Campos requeridos</p>

					<div class="dt-form-row">
						<label for="name_lasta_name"> Nombre y apellido: </label> <input
							type="text" id="name_lasta_name" name="name_lasta_name" size="30"
							placeholder="" value="${user.name} ${user.lastName}"
							class="dt-input-registration">
						<!-- <span class="dt-form-hint">Add your category</span> -->
						<!-- <i class="ch-form-ico ch-icon-question-sign"></i> -->
					</div>

					<div class="dt-form-row">
						<label for="pais"> País/Ciudad: </label>
						<g:select name="city" from="${EnabledCities.list()}"
							optionValue="${{it.locality +' , '+it.country}}" optionKey="id" />
					</div>

					<div class="dt-form-row">
						<label for="email"> E-mail: </label> <input type="email"
							id="email" name="email" required="required"
							class="dt-input-registration" value="${user.email}"
							placeholder="fedesca@dinerotaxi.com">
					</div>

					<div class="dt-form-row">
						<label for="celular-1a"> Celular: </label> <input type="number"
							id="celular-1a" name="number"
							class="dt-input-registration dt-input-first-number"> <input
							type="number" id="celular-1b" name="number"
							class="dt-input-registration dt-input-second-number">
					</div>

					<div class="dt-form-row">
						<label for="password"> Contraseña: </label> <input type="password"
							id="password" name="password" required="required"
							class="dt-input-registration">
					</div>

					<div class="dt-form-row">
						<label for="password-confirm"> Repetir contraseña: </label> <input
							type="password" id="password-confirm" name="password-confirm"
							required="required" class="dt-input-registration">
					</div>

					<div class="dt-form-actions">
						<input type="submit" name="" value="Registrate" class="dt-btn">
						<a href="#" class="dt-btn-cancel">Cancel</a>
					</div>
			</form>
			<div class="dt-legales">
				<img src="${resource(dir:'assets/images',file:'legales.png')}"
					alt="Legales" width="348" height="69">
			</div>


		</g:else>
	</div>
</body>
</html>