<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<link rel="stylesheet" href="${resource(dir:'css',file:'skin.css')}" />

<script type="text/javascript"
	src="${resource(dir:'js',file:'jquery.jcarousel.min.js')}"></script>
<script type="text/javascript">

jQuery(document).ready(function() {
    jQuery('#mycarousel').jcarousel();
	scroll: 1
});

</script>
<meta name="layout" content="dineroTaxiAdminL" />

</head>
<body>
	
<!-- MAIN -->

<div class="mainContent_">

	<div class="con">
    	
		<g:render template="buttonsTaxi" model="['action':'queEs']" />
        
        <div class="clearFix"><br /></div>
        
        <div class="bOX955">
        
        	<h1>¿Qué es DINEROTAXI?</h1>
            
           Es un servicio que permite a los usuarios pedir un taxi desde su dispositivo movil (aplicación), por su computadora (sistema Online), móvil (SMS) o por Facebook (aplicación en la red), sin que se necesiten llamadas. <br /> Si usted es chofer de taxi y le interesa utilizar este servicio, sólo necesita  instalar la aplicación DineroTaxi para taxistas en su teléfono móvil, que le permitirá poder atender las peticiones de los usuarios. 
			 <br /> <br />
			Con DineroTaxi conseguirá incrementar sus ingresos de una forma sencilla y económica, sin gastos de registro ni cuotas. <br /> Además brinda la seguridad tanto a usted como al cliente de saber con quién se esta viajando. 
			 <br /> <br />
			Principalmente darte de alta no te cuesta nada: es gratuito.

        
        </div>
        
        <div class="bOX400">
        	<div class="movil">
            	<img src="${resource(dir:'images',file:'movilTaxista.png')}" alt="DineroTaxi aplicación" />
            </div>
            
            <div class="items_">
            	<img src="${resource(dir:'images',file:'movil.png')}" alt="móvil" />
                <h3>Móvil</h3>
            </div>
            <div class="mas"></div>
            <div class="items_">
            	<img src="${resource(dir:'images',file:'net.png')}" alt="internet" />
                <h3>Internet</h3>
            </div>
            <div class="mas"></div>
            <div class="items_">
            	<img src="${resource(dir:'images',file:'gps.png')}" alt="GPS" />
                <h3>GPS</h3>
            </div>
            
        </div>
        
        <div class="bOX550">
        
        	<h1>Paso a paso</h1>
            
            <ul>
				 <li>Se registra a través de la página Web totalmente gratis. </li>
				 <li>Entre en el sistema desde su celular. </li>
				 <li>Active su estado en Libre u Ocupado.</li>
				 <li>Recibe solicitudes para realizar viajes. </li>
				 <li>En caso de solicitud de NUEVO VIAJE podrás ver la dirección de partida y de arribo. También los datos de la persona que viaja. </li>
				 <li>Puede elegir entre ACEPTAR o RECHAZAR el viaje. </li>
				 <li>En el caso de aceptarlo se pone en estado OCUPADO y realiza el translado.</li> 
				 <li>Finalmente cobra y cambia su estado a LIBRE para continuar recibiendo viajes.</li>
            </ul>  
        </div>
        
      
    
    </div>

</div>

</body>
</html>
