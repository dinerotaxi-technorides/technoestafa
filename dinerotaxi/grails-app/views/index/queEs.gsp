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
<meta name="layout" content="dineroTaxiTaxista" />

</head>
<body>
	
<!-- MAIN -->

<div class="mainContent_">

	<div class="con">
    	
		<g:render template="buttonsTaxi" model="['action':'queEs']" />
        
        <div class="clearFix"><br /></div>
        
        <div class="bOX955">
        
        	<h1>¿Qué es DINEROTAXI?</h1>
		 Es un servicio que permite a los usuarios pedir un taxi desde su celular (aplicación o vía SMS), su computadora (sistema Online), o por Facebook (aplicación en la red), sin necesidad de hacer llamadas. <br /> 
		A los choferes de taxis que les interese utilizar este servicio, sólo necesitan instalar la aplicación DineroTaxi para taxistas en su celular, que les permitirá poder atender los pedidos de los usuarios. <br />
		Con DineroTaxi, conseguirán incrementar sus ingresos de una forma sencilla y económica, sin costo alguno.<br />
		Además, brinda la seguridad tanto al taxista como al cliente de saber con quién está viajando. Registrarte no te cuesta nada: ¡Es gratuito!"
		        
        </div>
        
        <div class="bOX400">
        	<div class="movil">
            	<img src="${resource(dir:'images',file:'movilTaxista.png')}" alt="DineroTaxi aplicación" />
            </div>
            
            <div class="items_">
            	<img src="${resource(dir:'images',file:'movil.png')}" alt="móvil" />
                <h3>Celular/ Tablet</h3>
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
        
        	<h1>Paso a paso:</h1>
            
            <ul>
				<li>Resgistrate a través de la página web totalmente gratis.</li>
				<li>Accedé al sistema desde tu celular. Activá tu estado en Libre u Ocupado.</li>
				<li>Recibí solicitudes para realizar viajes.</li>
				<li>En caso de solicitud de NUEVO VIAJE, podrás ver la dirección de partida y de llegada. También los datos de la persona que viaja.</li>
				<li>Podrás elegir entre ACEPTAR o RECHAZAR el viaje.</li>
				<li>En caso de aceptarlo, se pone en estado OCUPADO y realizás el traslado. Finalmente cobrás y cambiás tu estado a LIBRE para continuar recibiendo viajes.</li>
            </ul>  
        
        </div>
        
        <div class="bOX550">
        
        	<h1>¿Qué necesito para usar DineroTaxi? </h1>
            
            Lo único que necesitas es un celular/tablet, que soporte aplicaciones y tenga GPS para poder recibir y aceptar los viajes.
            <div class="clearFix"></div>
            
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="registro" />" class="registrate"></a>
        
        </div>
    
    </div>

</div>

</body>
</html>
