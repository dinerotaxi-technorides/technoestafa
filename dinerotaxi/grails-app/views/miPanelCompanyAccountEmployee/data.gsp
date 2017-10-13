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

	$().ready(function() {
		// validate the comment form when it is submitted
		// validate signup form on keyup and submit
		$("#modificationForm").validate({
			 submitHandler: function(form) {
				   form.submit();
				 },
			rules: {
				fistName: "required",
				lastName: "required",
				phone: {
					required: true,
					minlength: 10,
					maxlength: 10
				}
				
			},
			messages: {
				firstName: "Por Favor Ingrese Su Nombre",
				lastName: "Por Favor Ingrese Su Apellido",
				phone: {
					required: "Por Favor Ingrese un Telefono Valido",
					minlength: "Debe tener como minimo 10 numeros",
					maxlength: "Debe tener como maximo 10 numeros"
				}
			},errorElement: "div"
				
		});

		
	});

		
</script>
</head>
<body id="wrapper">

<div class="mainContent">

	<div class="con">
    	
        <div class="content mt10">        	
            
        	<!-- TABS -->
            <g:if test="${flash.message}">
            	<div class="success" on>${flash.message}</div>
				<script type="text/javascript">
					showSuccessMessage();
				</script>
            </g:if>
            <g:if test="${flash.error}">
            	<div class="errors">${flash.error}</div>
				<script type="text/javascript">
					showErrorMessage();
				</script>
            </g:if>
        
            
			<g:render template="buttons" model="['action':'data']" />
              <!-- DETAIL -->
            
            <div class="boxPanelUser">
            
            	<h1>Información personal</h1>
                
                <div class="itemDatos">
                	
                    <div class="itemM"><b>Nombre</b></div>
                    <div class="itemM">${usr?.firstName }</div>
                    
                </div>
                <div class="itemDatos">
                	
                    <div class="itemM"><b>Apellido</b></div>
                    <div class="itemM">${usr?.lastName }</div>
                    
                </div>
                <div class="itemDatos">
                	
                    <div class="itemM"><b>Teléfono</b></div>
                    <div class="itemM">${usr?.phone }</div>
                    
                </div>
                <div class="itemDatos">
                	
                    <div class="itemM"><b>E-mail</b></div>
                    <div class="itemM">${usr?.email }</div>
                    
                </div>
                
                <br />
                
                <h1>Realizar modificaciones</h1>
                               
                <g:form action="saveModification" controller="miPanelCompanyAccountEmployee" name="modificationForm">
            
                	<div class="blockInput_"><span class="fl">Nombre*</span>  
                		<input id="firstName" type="text" name="firstName" placeholder="Matias" size="34" value="${usr?.firstName}"/>
                	</div>
                    
                	<div class="blockInput_"><span class="fl">Apellido*</span>  
                	<input id="lastName" type="text" name="lastName" placeholder="Baglieri" size="34"  value="${usr?.lastName}"/>
                	</div>
                    
                    <div class="clearFix"></div>
                    
                    <div class="blockInput_"><span class="fl">Teléfono*</span>  
                    <input id="phone" type="text" name="phone" placeholder="1564646464" size="34"  value="${usr?.phone}"/>
                    </div>
                    
                    <div class="clearFix"></div>
                    
                    <div class="itemXSS"><img src="${resource(dir:'images',file:'important.png')}" alt="Importante" /></div> <div class="itemL txtImportante">Por favor mantené actualizados todos tus datos.</div>
                    
					<input type="submit" name="submit" value="" class="modificar">
                </g:form>
                
                
            </div>
            
            <div class="clearFix"><br /></div>
            
            
         </div>   
        
   
           <g:render template="sidebar" model="" />

	</div>
</div>

<!-- END MAIN -->
</body>
</html>
