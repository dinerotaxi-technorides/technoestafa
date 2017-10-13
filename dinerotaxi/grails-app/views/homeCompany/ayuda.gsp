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
	
<!-- MAIN -->

<div class="mainContent_">

	<div class="con">
    	
		<g:render template="buttonsTaxi" model="['action':'ayuda']" />
        
      <div class="bOX955 mt20">
              
           <h3 class="mt10">DineroTaxi ya esta disponible para:</h3>
           
             <div class="boxes">       
                
                <div class="boxDescargar">
                    <div class="num_"><img src="${resource(dir:'images',file:'android.png')}" alt="Android" /></div>
                    <div class="title_">
                        <h3>Versión Android</h3>
                        <%--<a href="descargar.html" class="descargar"></a>--%>
                        
                        Próximamente
                    </div>
                </div>
                
                <div class="boxDescargar">
                    <div class="num_"><img src="${resource(dir:'images',file:'apple.png')}" alt="Apple" /></div>
                    <div class="title_">
                        <h3>Versión IPHONE</h3>
                        <!--<a href="descargar.html" class="descargar"></a>-->
                        Próximamente
                    </div>
                </div>
                
                <div class="boxDescargar">
                    <div class="num_"><img src="${resource(dir:'images',file:'blackberry.png')}" alt="Balckberry" /></div>
                    <div class="title_">
                        <h3>Versión Balckberry</h3>
                        <!--<a href="descargar.html" class="descargar"></a>-->
                        Próximamente
                    </div>
                </div>
        	  </div>
        </div>
        
        <div class="bOX955">
        
        	<h1>¿Cómo funciona DINEROTAXI para el taxista?</h1>
			Con sólo un click, usted puede incrementar sus ingresos y aceptar las solicitudes de viajes que lleguen a su móvil. De esta forma, Dinerotaxi le brinda de una forma fácil y simple aumentar sus ganancias.<br />
			Cuando un cliente de Dinerotaxi solicita un servicio indica con precisión el lugar donde se encuentra. En ese instante, usted recibirá una propuesta de servicio detallándole la dirección y la distancia estimada desde la posición actual de su taxi hasta el punto donde lo espera el cliente. 
			<br /><br />
			Al pedir un taxi, un cliente de Dinerotaxi facilita también su nombre y su número de teléfono, y esta información está a disposición del taxista. Puede utilizar el número de teléfono del cliente para ponerse en contacto con él en caso de necesidad. Brindando un plus en seguridad y seriedad. 
			<br /><br />
			Con sólo descargar la aplicación para taxistas, registrarte y entrar en el sistema con tu móvil y clave, ya estará contando con Dinerotaxi como aliado estratégico. <br /><br />
            <h3>Paso a paso</h3>
            
            <div class="sld">
            
              <ul id="mycarousel" class="jcarousel-skin-tango">
                <li>
                	<div class="boxC">
                    	<div class="num">1 |</div>
                      <div class="title">Registrarse como usuario en el sistema.</div>
                    
                        <br class="clearFix" />
                        <div class="boxIMG">                        
                            <img src="${resource(dir:'images',file:'p1.jpg')}" alt="DINERO TAXI pantalla de login" />                            
                        </div>
                    </div>
                </li>
                <li>
                    <div class="boxC">
                        <div class="num">2 |</div>
                         <div class="title">El sistema detecta cuál es su ubicación en el mapa. Luego usted indicará su estado en Libre u Ocupado.</div>
                        <br class="clearFix" />
                        <div class="boxIMG">                        
                            <img src="${resource(dir:'images',file:'at2.jpg')}" alt="DINERO TAXI estado del taxi" />                            
                        </div>
                    
                    </div>
                </li>
                <li>
                    <div class="boxC">
                        <div class="num">3 |</div>
                       <div class="title">Recibe una alerta de solicitud de viaje y confirma, visualizando la dirección a la que debe dirigirse.</div>
                            <br class="clearFix" />
                            <div class="boxIMG">                        
                                <img src="${resource(dir:'images',file:'at3.jpg')}" alt="DINERO TAXI cargar ubicación" />                            
                            </div>
                    </div>
                </li>
                <li>
                    <div class="boxC">
                        <div class="num">4 |</div>
                         <div class="title">La aplicación le confirma su pedido al cliente.</div>        
                    
                        <br class="clearFix" />
                        <div class="boxIMG">                        
                            <img src="${resource(dir:'images',file:'p4.jpg')}" alt="DINERO TAXI pedido en curso" />                            
                        </div>
                    </div>
                </li>
                <li>
                    <div class="boxC">
                        <div class="num">5 |</div>
                        <div class="title">Cuando el taxi llega, DineroTaxi le avisa que lo está esperando.</div>
                    <br class="clearFix" />
                    <div class="boxIMG">                        
                        <img src="${resource(dir:'images',file:'p5.jpg')}" alt="DINERO TAXI confirmación del pedido" />                            
                    </div>
                    </div>
                </li>
                <li>
                    <div class="boxC">
                        <div class="num">6 |</div>
                         <div class="title">Tiene la posibilidad de registrar sus viajes y sus clientes más frecuentes.</div>

                    <br class="clearFix" />
                    <div class="boxIMG">                        
                        <img src="${resource(dir:'images',file:'p6.jpg')}" alt="DINERO TAXI aviso de espera" />                            
                    </div></div>
                </li>
                
              </ul>            
              
           </div>
            
        </div>
        
        
    </div>

</div>

</body>
</html>
