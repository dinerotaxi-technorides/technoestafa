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
<meta name="layout" content="dineroTaxiCompanyL" />

</head>
<body>
	
<div class="mainContent">

	<div class="con">
    	
        <div class="content mt10">        	
            
        	<div class="bOX725">
            
            	<h1>Conoce DineroTaxi</h1>
                
                <h3 class="mt10">La empresa</h3>
                <br />
                	Somos la primer empresa de Latinoamérica dedicada al servicio de transporte Online. Queremos innovar en tecnología y modernizar el servicio actual del taxi, brindando un sistema inteligente y con numerosos beneficios para nuestros clientes: usuarios particulares, choferes y empresas de Radio Taxi.<br />
	Nuestro objetivo es ofrecer un servicio fácil y seguro para las personas que día a día utilizan el taxi para su desplazamiento. Además es una novedosa manera para que los choferes puedan beneficiarse con los numerosos viajes que DineroTaxi recibirá.<br />
	Gracias a la tecnología del sistema, el servicio de GPS permite conocer en todo momento la ubicación donde se encuetra el cliente y el chofer, brindando seguridad y confianza al momento de viajar.<br />
	<br /><br />

                <h3>Objetivo</h3>
                <br />
                Brindar a los clientes un servicio totalmente gratuito, para su confort y seguridad a la hora de viajar.<br /> Con sólo un click, usted podrá tomar un taxi sin necesidad de largas esperas, de manera fácil y conveniente.<br /> En cualquier momento y lugar, usted podrá tomar un taxi con la información necesaria para que viaje tranquilo y confortable.  <br /><br />
                                    
            </div>
         
         </div>
         
         <!-- SIDEBAR -->
            
        <div class="sidebar mt10">
        
           
            
            <div class="bOX221">
                
                <img src="${resource(dir:'images',file:'atencion.png')}" alt="Atención al cliente" title="Atención al cliente" align="left" class="mr5" />
                <h3>Atención al cliente</h3>
                Contactanos!
                                
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompany" action="contact" />" class="atencion"></a>
                
            </div>
            
            <div class="clearFix"><br /></div>
            
			<g:render template="/template/shareFacebook" />
                
        </div>
    
    </div>

</div>


</body>
</html>
