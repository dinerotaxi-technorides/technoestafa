<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dinerotaxiCompanyAccountEmployeeL" />
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
<link rel="apple-touch-icon-precomposed" href="${resource(dir:'images',file:'favicon.ico')}">
	
<%--	--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css/dinerotaxi',file:'modal.css')}" />--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />--%>
<%--   --%>

<link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery-ui-1.8.16.custom.min.js')}"></script>

<!--Google Analytics-->
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
</head>
<body id="wrapper">

<div class="mainContent">

	<div class="con">
    	
        <div class="content mt10">        	
            
        	<!-- TABS -->
        
            
			<g:render template="buttons" model="['action':'calendar']" />
            <!-- DETAIL -->
            
           <!-- DETAIL -->
            
            <div class="boxPanelUser">
            
            	<h1>Mis viajes programados</h1>
            
                <br />
                
                <h3>¿Cómo funciona mi calendario?</h3>
                
                <br />
                
                
				Muy pronto vas a poder programar tus viajes ingresando la fecha y hora en tu calendario de eventos.
                 
                <br /><br /><br /><br />
                <div class="proxMovil">
                    <h3>Próximamente</h3>
                    <span class="ml5">Hacé tus reservas</span>
                </div>
                <br />                
                
            </div>
            
    
            
         </div>   
        
           <g:render template="sidebar" model="" />
    
    </div>

</div>


<!-- END MAIN -->
</body>
</html>
