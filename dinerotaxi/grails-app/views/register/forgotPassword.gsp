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
                
        </div>        
    </div>
   
    <div id="mask"></div>
</div>


<!-- FIN MODAL -->
	<div class="mainContent_">
			
		<div class="con">
				<g:if test="${flash.message}">
					<div class="notice">${flash.message}</div>
				</g:if>
				<g:if test="${flash.error}">
					<div class="errors">${flash.error}</div>
				</g:if>

			<div class="container">

				<!-- NEW USER -->

					<div class="bOX725">

					<h1>Ingrese su email y recibirá la contraseña en su casilla de correo</h1>


					<g:form action="forgotPassword" controller="register" name="forgotForm">
						<div class="blockInput_"> 
							 <label class="fl" for="firstName">Email*</label> 
                 		 <div class="encierra_input"><input id="username" type="text"
								name="username" placeholder="info@dinerotaxi.com" size="34" value="${command?.username}" /></div>
						</div>

						<br/>
						<br/>
						<br/>

						 <input type="submit" name="submit" value="" class="registrate">
						<%--<a class="registrate" href="#dialog" name="modal"></a>

					--%></g:form>

				</div>

				<!-- END NEW USER -->

			</div>

			<!-- SIDEBAR -->

			
			<!--  g:render template="/template/recomenda" /-->
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

			<!-- END SIDEBAR -->



		</div>


	</div>
</body>
</html>
