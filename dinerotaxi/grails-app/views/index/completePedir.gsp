<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>

<link href="${resource(dir:'css',file:'gracias.css')}" rel="stylesheet" type="text/css" media="screen, projection, tv" />
	<script type="text/javascript"
				src="${resource(dir:'js',file:'jquery.jcarousel.min.js')}"></script>
				
	
	<meta name="layout" content="dinerotaxi" />
	
</head>
<body>
<!-- MAIN -->
<div class="mainContent">
			
			
		<div class="con">
			
			
			<div class="container">

                                   
            <div class="cont_mail_confirma mt10">
                <div class="exitoso"></div>
                <div class="mens_confirma_mail">
                    <h2><g:fieldValue bean="${usr}" field="firstName" /> <g:fieldValue bean="${usr}" field="lastName" /> tu pedido está siendo procesado</h2>
                     <p><span class="negro resalta_mas">Recordá verificar tu casilla de e-mail para poder utilizar los servicios de DineroTaxi.com</span></p>
          
                    <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="index"/>" title="Ir a la Página principal" class="ir_inicio">Ir a la página principal</a>
                
                        
                   
                </div>
       
            </div>

		</div>


	</div>



</body>
</html>
