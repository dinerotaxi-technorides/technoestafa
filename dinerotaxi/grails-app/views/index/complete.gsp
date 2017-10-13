<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>

<link href="${resource(dir:'css',file:'gracias.css')}" rel="stylesheet" type="text/css" media="screen, projection, tv" />
	<script type="text/javascript"
				src="${resource(dir:'js',file:'jquery.jcarousel.min.js')}"></script>
				
<script type="text/javascript" src="${resource(dir:'js',file:'basic-jquery-slider.js')}"></script>
<script type="text/javascript">
	jQuery(document).ready(function($) {
	$('#d1').placeholder();	
	$('#d2').placeholder();
        
        $('#cont_sabias').bjqs({
          'animation' : 'slide',
          'width' : 201,
          'height' : 280
        });
        
	});
</script>
	<meta name="layout" content="dinerotaxi" />
	<!-- Google Code for Registraci&oacute;n Conversion Page -->
	<script type="text/javascript">
	/* <![CDATA[ */
	var google_conversion_id = 995045261;
	var google_conversion_language = "es";
	var google_conversion_format = "3";
	var google_conversion_color = "ffffff";
	var google_conversion_label = "9IsvCMPivwMQjd-82gM";
	var google_conversion_value = 0;
	/* ]]> */
	</script>
	<script type="text/javascript" src="https://www.googleadservices.com/pagead/conversion.js">
	</script>
	<noscript>
	<div style="display:inline;">
	<img height="1" width="1" style="border-style:none;" alt="" src="https://www.googleadservices.com/pagead/conversion/995045261/?value=0&amp;label=9IsvCMPivwMQjd-82gM&amp;guid=ON&amp;script=0"/>
	</div>
	</noscript>
</head>
<body>
<!-- MAIN -->

<div class="mainHome">
   <div class="con">
    
    	<div class="content"> 
           
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
            <!--COMIENZO DEL AGRADECIMIENTO DE USUARIO-->
            <div id="cont_gracias">
                <div class="contenido_gracias">
                    <div class="ima_exito"></div>
                    <div class="tit_agradecimiento"><h2> <g:fieldValue bean="${usr}" field="firstName" /> <g:fieldValue bean="${usr}" field="lastName" /> gracias por registrarte!!</h2></div>
                    <div class="cont_txt_agradecimiento">
                        <div class="ima_mail"></div>
                        <div class="txt_texto"><p><g:fieldValue bean="${usr}" field="firstName" /> <g:fieldValue bean="${usr}" field="lastName" /> es un placer que nos hayas elegido.<br /> <span class="negro resalta_mas">No olvides verificar tu casilla de e-mail para confirmar tu registro</span></p></div>
                        <div class="ima_cel"></div>
                <div class="txt_texto"><p>¿Aún no tenés dinero taxi en tu celular?<br />
                        <span class="negro">Te invitamos a que lo descargues desde <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="download"/>" title="Descargar aplicación de dinerotaxi para el celular (Acceso por teclado:d)" accesskey="d" >aquí</a></span></p></div>
                </div>
                </div>
                <p>A continuación podes iniciar la sesión con tu usuario, pero debes <strong>confirmar tu mail para acceder a todos los beneficios</strong></p>
            </div>

            <!--FIN AGRADECIMIENTO DE USUARIO-->
            <div class="clearFix"><br /></div>
           
           
     <!--  LOGIN -->
      			
			<g:render template="/template/login" />
            
           
     <!-- END LOGIN -->
            <div class="clearFix"><br /></div>
                <div class="boxUsuario">
            	
                <h2>QUIERO UN TAXI</h2>
                
                <span class="ml5">Simple, práctico y gratis!</span>
                
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="pedir" />" class="pedirTaxi"></a>
                
            </div>
            
            <div class="boxTaxista">
            	
                <h2 class="yellow">TENGO UN TAXI</h2>
                
                <span class="yellow ml5">Incrementa tus viajes!</span>
                
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="queEs" />" class="masInfo"></a>
                
            </div>
    
    
        </div>
       <div class="sidebar">
           
             <div id="cont_sabias">
            	
               
                <ul class="bjqs">
                    <li><h2>Sabías que...</h2>
                        <p>Con dinerotaxi vas a conocer de antemano quién te va a llevar, nosotros te informamos quién será tu chofer!!</p>
                <p>Nuestro objetivo es ofrecerte un servicio seguro y confiable. </p></li>
                    <li><h2>Sabías que...</h2>
                        <p>contarás con el nombre y apellido del conductor, una foto y el número de patente</p></li>
                </ul>

            </div>
           <div class="clearFix"><br /></div>
                   	<div class="bOX221">
            	
                <img src="${resource(dir:'images',file:'movilApp.png')}" alt="Dinero Taxi aplicación" title="Dinero Taxi aplicación" align="left" class="mr5" />
                <h3>Descarga la aplicación</h3>
                Para tu iphon, blackberry, android
                
                <a  title="Descargar aplicación de dinerotaxi para el celular (Acceso por teclado:d)" accesskey="d" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="download" />" class="descargar"></a>
                
            </div>
            
            <div class="clearFix"><br /></div>
            	                               
     
			<g:render template="/template/shareFacebook" />
            
            <div class="clearFix"><br /></div>
            
           
            
       </div>
        </div>
</div>

<div class="clearFix"></div>

</body>
</html>
