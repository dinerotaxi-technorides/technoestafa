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
<meta name="layout" content="dinerotaxi" />

</head>
<body>
	
<div class="mainContent_">

	<div class="con">
    	
        <div class="content mt10">        	
            
        	<div class="bOX725">
            
            	
<h1>Dinerotaxi.com gana OpenApps Challenge</h1>

<h2>En medio del debate en el congreso, llega un servicio público gratuito para pedir taxis que comienza a pisar fuerte.</h2>

<p>El pasado 28 de Junio se anunciaron los ganadores de OpenApps Challenge Argentina 2012.</p>

<p>El concurso, que comenzó en diciembre de 2011, fue auspiciado por el grupo Telefónica y cerró su segundo ciclo con una entrega de premios a los ganadores de cada categoría.</p>

<p>En la categoría Dispositivos Móviles se destacó Dinerotaxi.com, una aplicación para pedir y pagar taxis a través del teléfono celular.</p>

<p>"Agradecemos al grupo Telefónica por permitirnos demostrar que la forma de pedir y pagar un taxi está cambiando en Argentina." dijo Matías Baglieri, CEO de Dinerotaxi.com</p>

<p>Con respecto al estado del producto se manifestó "Estamos doblemente contentos ya que luego de más de un año y medio de trabajo, esta premiación coincide con nuestra salida al mercado. Ya se están realizando viajes a través de nuestra web y a lo largo de las próximas dos semanas lanzaremos las aplicaciones para Android, Iphone y BlackBerry. Comenzamos incorporando 500 taxis para satisfacer la demanda y estamos en tratativas para alcanzar los 3000 vehículos en tiempo record".</p>

<p>Esto Ocurre en medio del debate en el congreso sobre si la telefonía celular debe considerarse un servicio público.</p>

<p>Dinerotaxi.com utiliza una aplicación móvil del lado del taxista y del lado del cliente, permitiéndole a este último realizar los pedidos por web si así lo desea.</p>

<p>Se apunta a incorporar un medio de pago electrónico que permita eliminar la utilización de dinero en efectivo aumentando la seguridad tanto para el taxista como para el pasajero.</p>
            </div>
         
         </div>
         
         <!-- SIDEBAR -->
            
        <div class="sidebar mt10">
        
          
			<!--  g:render template="/template/recomenda" /-->
            
            <div class="bOX221">
                
                <img src="${resource(dir:'images',file:'atencion.png')}" alt="Atención al cliente" title="Atención al cliente" align="left" class="mr5" />
                <h3>Atención al cliente</h3>
                Contactanos!
                                
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="contact" />" class="atencion"></a>
                
            </div>
            
            <div class="clearFix"><br /></div>
            
          
			<g:render template="/template/shareFacebook" />
                
        </div>
    
    </div>

</div>


</body>
</html>
