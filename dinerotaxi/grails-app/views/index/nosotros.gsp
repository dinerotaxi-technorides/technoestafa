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
            
            	<h1>Conocé a DineroTaxi: </h1>
                
                <h3 class="mt10">La empresa</h3>
                <br />
                La empresa: Somos la primera empresa de Latinoamérica dedicada al servicio de transporte Online. 	<br />
                Queremos innovar en tecnología y modernizar el servicio actual de taxis, brindando un sistema inteligente y con numerosos beneficios para nuestros clientes: usuarios particulares, choferes y empresas de Radio Taxi.	<br /> 
                Nuestro principal objetivo es ofrecer un servicio fácil y seguro para las personas que día a día utilizan taxis para su desplazamiento. 	<br />
                Además, es un método novedoso del que los choferes podrán beneficiarse gracias a los numerosos viajes que DineroTaxi recibirá.	<br />
                 Por medio de la tecnología propia del sistema, el servicio de GPS, permite conocer en todo momento la ubicación del cliente y el chofer, brindando seguridad y confianza al momento de viajar.
               	<br /><br />

                <h3>Objetivo:</h3>
                <br />
                Brindar a los clientes un servicio totalmente gratuito, confortable y seguro a la hora de viajar. <br />
                Con sólo un click, podrás tomar un taxi sin necesidad de largas esperas y de manera fácil y conveniente. <br />
                En cualquier momento y lugar, podrás tomar un taxi con la información necesaria para que viajes cómodo y tranquilo.                    
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
