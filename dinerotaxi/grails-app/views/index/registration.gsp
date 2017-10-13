<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>



<!--METATAGS-->    
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="DC.title" content="DineroTaxi.com | La nueva forma de tomar un taxi!" />
<meta name="DC.creator" content="Carlos Matías Baglieri" />
<meta name="DC.description" content="La nueva forma de tomar un taxi" />
<meta name="DC.type" scheme="DCTERMS.DCMIType" content="Text" />
<meta name="DC.format" content="text/html; charset=UTF-8" />
<meta name="DC.identifier" scheme="DCTERMS.URI" content="https://www.dinerotaxi.com" />
<meta http-equiv="content-language" content="es" />
<meta name="Language" content="Spanish, Español"/>
<meta name="Geography" content="capital Federal, Buenos Aires, Argentina"/>
<meta name="distribution" content="Global"/>
<meta name="robots" content="nofollow"/>
<meta name="country" content="Argentina"/>
<meta name="Classification" content="services"/>
<meta name="generator" content="Bluefish 2.0.2" />
<meta name="Keywords" content="taxi|transporte|dinero|viajes"/>
<meta name="copyright" content="https://www.dinerotaxi.com" />
<meta http-equiv="Expires" content="never"/>
<meta name="Subject" content="DINERO TAXI"/>
<meta name="layout" content="dinerotaxi"/>
<script  type="text/javascript" src="${resource(dir:'js',file:'funciones1.js')}"></script>

</head>
<body>
<!-- MODAL -->

<div id="boxes">
    <div id="dialog" class="window">

    	<div class="modal">
        
        	<img src="${resource(dir:'images',file:'dineroTaxi.png')}" alt="DineroTaxi.com" title="DineroTaxi.com" />
        	<h3>Bienvenido Juan Perez!</h3>
        	A partir de este momento puedes comenzar a<br /> utilizar los servicios de DINERO<b>TAXI</b>
            <br /><br />
            Confirmar para terminar el pedido.
            <br />

            <a href="realizarPedido.html" class="conagre"></a>
            <div class="clearFix"></div>
            <a href="realizarPedido.html" class="confirmar"></a>
            <a href="#" class="cancelar close"></a>
        	<!--<a href="#"class="close"/><img src="images/ejModal.jpg" alt="ejModal" border="0" /></a>-->
        </div>        
	</div>
    
    <div id="olvido" class="window">
        <div class="modal">

        
            <h3>Recuperar contraseña!</h3>
            <br />
            
            Ingrese su email y recibirá la contraseña en su casilla de correo
            <br />
            
            <form action="">
            
                    <div class="bloInMin_"><span class="flMin">Email</span>  <input id="mail" type="text" name="email" placeholder="pepe@hotmail.com" class="inputShortMin" /></div>
                                                               
                   	<a class="env_" href="" ></a>
                    <a href="#" class="cancelar close"></a>

          		</form>
                
            
            <!--<a href="#"class="close"/><img src="images/ejModal.jpg" alt="ejModal" border="0" /></a>-->
        </div>        
    </div>
   
    <div id="mask"></div>
</div>


<!-- FIN MODAL -->
	<div class="mainContent_">
		    <g:if test="${flash.message}">
				<div class="notice">${flash.message}</div>
				
			</g:if>
			<g:hasErrors bean="${command}">
				<div class="error">
					<g:renderErrors bean="${command}" as="list" />	
				</div>
			</g:hasErrors>
		<div class="con">

			<g:if test="${flash.error}">
				<div class="bOX955 mt10">
                            <div class="exclama"></div>
                            <div class="error"><p>${flash.error}</p></div>
		        </div>
			</g:if>
			<div class="container">

				<!-- NEW USER -->


			<g:render template="/template/registration" />
				<!-- END NEW USER -->
				<div class="clearFix"><br /></div>
			<!-- LOGIN -->

	
			<g:render template="/template/login" />

				<!-- END LOGIN -->
			</div>

			<!-- SIDEBAR -->

			<div class="sidebar mt10">

				
			<!--  g:render template="/template/recomenda" /-->


				
			<g:render template="/template/shareFacebook" />

			</div>

			<!-- END SIDEBAR -->



		</div>


	</div>
</body>
</html>
