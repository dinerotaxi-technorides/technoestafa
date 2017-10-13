<%@ page import="ar.com.goliath.TypeEmployer"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>

<meta name="layout" content="dineroTaxiAdminL" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- META for Google Webmasters -->
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
<link rel="shortcut icon"
	href="${resource(dir:'img',file:'favicon.ico')}" type="image/x-icon" />
<link rel="apple-touch-icon-precomposed"
	href="${resource(dir:'images',file:'favicon.ico')}">

<script
	src="${resource(dir:'libraries/modernizr',file:'modernizr-custom.min.js')}"></script>

<link href="${resource(dir:'libraries/prettify',file:'prettify.css')}"
	rel="stylesheet" type="text/css" media="all">

<link rel="stylesheet"
	href="${resource(dir:'css',file:'bootstrap-duallistbox.css')}" />

<script src="${resource(dir:'libraries',file:'jquery-1.9.0.min.js')}"></script>
<script src="${resource(dir:'libraries/prettify',file:'prettify.js')}"></script>
<script
	src="${resource(dir:'js',file:'jquery.bootstrap-duallistbox.js')}"></script>

<script
	src="${resource(dir:'js',file:'jquery.bootstrap-duallistbox.js')}"
	type="text/javascript"></script>
<%--	--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css/dinerotaxi',file:'modal.css')}" />--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />--%>
<%--   --%>

<link href="${resource(dir:'bootstrap/css',file:'bootstrap.css')}"
	rel="stylesheet" type="text/css">

<!--Google Analytics-->
<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>

</head>
<body>


	<div class="mainContent_">


		<div class="con">

			<g:render template="/tripPanelAdmin/sidebar"
				model="['action':'role']" />
			<!-- DETAIL -->



			<div class="boxPanelTaxista">

				<label for="roleddl11">Country:</label>
				<g:select name="roleddl" id="roleddl"
					from="${role.authority}" keys="${role.id}"
					noSelection="['':'Select one...']"
					onChange="${remoteFunction( action:'updateRequestMap',
                                          params: '\'id=\'+escape(this.value)',
                                          update: [success: 'provinceddl'] )}"></g:select>
				<br />
				<br />
				<div id="provinceddl">
				</div>

				
			</div>

		</div>


	</div>


	<!-- END MAIN -->
</body>
</html>
