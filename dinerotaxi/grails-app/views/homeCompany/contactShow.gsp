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
	<meta name="layout" content="dineroTaxiCompanyL" />
	
</head>
<body>
<!-- MAIN -->

<div class="mainContent">

	<div class="con">
    
    	<div class="container">
           
            <!--COMIENZO DEL AGRADECIMIENTO DE USUARIO-->
            <div id="cont_gracias">
                <div class="contenido_gracias">
                    <div class="ima_exito"></div>
                    <div class="tit_agradecimiento"><h2> Gracias por enviar tu consulta.</h2></div>
                    <div class="cont_txt_agradecimiento">
                        <div class="ima_mail"></div>
                        <div class="txt_texto"> <p>Es un placer que nos hayas elegido.En instantes estaremos revisando su consulta.</p></div>
                    </div>
                </div>
                <p>A continuación podes iniciar la sesión con tu usuario</p>
            </div>

            <!--FIN AGRADECIMIENTO DE USUARIO-->
         
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
         
           
            
           
            
       </div>
        </div>
</div>

</body>
</html>
