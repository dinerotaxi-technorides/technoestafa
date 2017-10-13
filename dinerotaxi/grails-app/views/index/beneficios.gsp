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
    	
		<g:render template="buttonsTaxi" model="['action':'beneficios']" />
        
      <div class="bOX955 mt20">
        
        	<h1>Beneficios de contar con DINEROTAXI</h1>
            
           DineroTaxi será tu socio y por medio de esta novedosa y práctica aplicación en tu móvil, lo ayudará a incrementar sus viajes brindando confiabilidad, rapidez, sencillez, seguridad y por sobre todo responsabilidad para con el cliente y con el chofer. 
            <div class="clearFix"><br /></div>
            
        	<h1>¿Qué ofrecemos?</h1>
            
           DineroTaxi le ofrece las últimas tendencias y novedades tecnológicas puestas a su servicio.<br> Brindándole con ello la posibilidad de incrementar su negocio consiguiendo más clientes de la forma más sencilla que se puedas imaginar. Destacando que es un servicio sin costo alguno para usted. 
            <br />
            
            <div class="grafBeneficios">
            	<div class="bene">
                	SIN<br />GASTOS<br />FIJOS
                </div>
                <div class="sep"></div>
                <div class="bene mt20">
                	REGISTRO<br />GRATIS
                </div>
                <div class="sep"></div>
                <div class="bene mt5">
                	USALO<br />SIN<br />COSTO
                </div>
            </div>
            
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="registroTaxista" />" class="registrate_"></a>
             
            
            </div>
            
                <div class="bOX955">
                
                <div class="movBene">
                    <img src="${resource(dir:'images',file:'movilTaxistaNV.png')}" alt="Notificación nuevo viaje" />
                </div>
            
            <div class="divide"></div>
            
                <div class="blockBene">
                
                    <div class="boxTitle_">
                        <h3 class="white">Comenzá a levantar viajes!</h3>
                        <div class="item">
                            <img src="${resource(dir:'images',file:'incrementa.png')}" alt="Incrementa ingresos" />
                            <br /><br />
                            Incrementa tus ingresos
                        </div>
                        <div class="item">
                            <img src="${resource(dir:'images',file:'sinInversion.png')}" alt="Sin inversión" />
                            <br /><br />
                            Sin gastos fijos ni de inversión
                        </div>
                        <div class="item">
                            <img src="${resource(dir:'images',file:'maxBeneficio.png')}" alt="Maximo beneficio" />
                            <br /><br />
                            Máximo beneficio
                        </div>
                        
                    </div>
                    
                    <div class="boxIMG_">
                        <img src="${resource(dir:'images',file:'ejMapaCF.jpg')}" alt="Ejemplo del funcionamiento" />
                    </div>
                
                </div>
            
            </div>
            
        </div>
        
    </div>

</div>

            

</body>
</html>
