<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dineroTaxiCompanyAccountL" />
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
    <g:javascript library="jquery" plugin="jquery"/>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery-ui-1.8.16.custom.min.js')}"></script>

<!--Google Analytics-->
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
	
    <script src="${resource(dir:'js/imported',file:'jquery.tools.min.js')}"></script>
    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.simplemodal.1.4.2.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.validate.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'json2.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.tokeninput.js')}"></script>
    <jq:plugin name="fileuploader"/>
    <jq:plugin name="editable"/>    
    <jq:plugin name="places"/>    
    <jq:plugin name="multiselect"/>
    <jq:plugin name="multiplace"/>
    <jq:plugin name="newscomment"/>
    <jq:plugin name="follow"/>
<!-- This JavaScript snippet activates those tabs -->
<script type='text/javascript' src='${resource(dir:'js/jquery',file:'jquery.validate.js')}'></script>
<script type="text/javascript">
	$(function() {
		  $('#placeinput1').multiplace({tokenLimit: 1});
		  $('#placeinput2').multiplace({tokenLimit: 1});
	});

	$().ready(function() {
		// validate the comment form when it is submitted
		// validate signup form on keyup and submit
		$("#registrationForm").validate({
			 submitHandler: function(form) {
				   form.submit();
				 },
			rules: {
				placeinput1: "required"
				
			},
			messages: {
				placeinput1: "Por Favor Ingrese Su Direccion"
			},errorElement: "div"
				
		});

		
	});

		
</script>
</head>
<body id="wrapper">

<div class="mainContent_">

	<div class="con">
    	
        <div class="content mt10">        	
            
        	<!-- TABS -->
        
            
			<g:render template="buttons" model="['action':'calendar']" />
            <!-- DETAIL -->
            
           <!-- DETAIL -->
            
            <div class="boxPanelUser">
            
            	<h1>Mis viajes programados</h1>
            
                <br />
                
                
                <div class="proxMovil">
                    <h3>Próximamente</h3>
                    <span class="ml5">Hace tus reservas</span>
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
