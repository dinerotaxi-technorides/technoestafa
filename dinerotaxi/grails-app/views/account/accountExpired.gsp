<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dinerotaxi" />

</head>
<body>
<!-- MODAL -->

<div id="boxes">
    <div id="dialog" class="window">

    	<div class="modal">
        
        	<img src="images/dineroTaxi.png" alt="DineroTaxi.com" title="DineroTaxi.com" />
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
	<div class="mainContent">

		<div class="con">

				<div class="bOX955 mt10">
                            <div class="exclama"></div>
                            <div class="mens_error"><p>Su cuenta a caducado</p></div>
		        </div>
			<div class="container">

				<!-- LOGIN -->

				
			<g:render template="/template/login" />

				<!-- END LOGIN -->

				<!-- NEW USER -->

					<div class="bOX725 mt20">

					<h1>Nuevo Usuario</h1>


					<g:form action="registerUsr" controller="register" name="registrationForm">
						<div class="blockInput_"> 
							 <label class="fl" for="firstName">Nombre*</label> 
                 		 <div class="encierra_input"><input id="firstName" type="text"
								name="firstName" placeholder="Juan " size="34" value="${command?.firstName}" /></div>
						</div>

						<div class="blockInput_">
							<label class="fl" for="lastname">Apellido*</label> 
                     <div class="encierra_input"><input id="lastName" type="text"
								name="lastName" placeholder="Perez" size="34" value="${command?.lastName}"/></div>
						</div>

						<div class="clearFix"><br /></div>

						<div class="blockInput_">
							 <label class="fl" for="email">Email*</label> 
                       <div class="encierra_input">
                       <input id="email" type="text" name="email" placeholder="juanperez@hotmail.com" size="34" value="" />
                       </div>
						</div>
						<div id=”emailInfo” align=”left”></div>
						<div class="blockInput_">
								<label class="fl" for="phone">Teléfono*</label> 
                         <div class="encierra_input"> <input id="phone" type="text" name="phone" placeholder="1164640019" size="34" value=""/></div>
						</div>


						<div class="clearFix"><br /></div>

					
						<div class="blockInput_">
							<label class="fl" for="password">Contraseña*</label> 
                     <div class="encierra_input"><input id="password" type="password" name="password" placeholder="********" size="34" /></div>
						</div>

						<div class="blockInput_">
							<label class="fl" for="password2">Repetir contraseña*</label> 
                                                      	
                      <div class="encierra_input"><input id="password2" type="password" name="password2" placeholder="********" size="34" /></div>
						</div>

						<div class="clearFix"><br /><br /></div>


						<div class="blockInput_ ml90 mt10" >
							<label class="label_checkHome fixIe" for="agree">
                                                        	<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="termsAndConditions" />" target="_blank"
								class="linkDocs">Acepto los terminos y condiciones</a>
                                                        </label>       
                                                            <input name="agree" id="agree" value="1" type="checkbox"  />

							<div class="clearFix mt10"></div>
							<label class="label_checkHome fixIe" for="politics">
                     <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="termsAndConditions" />" target="_blank" class="linkDocs">Acepto las políticas de privacidad</a> </label>   
                       <input
								name="politics" id="politics" value="1"
								type="checkbox" /> 
							<div class="clearFix"></div>
							<div class="itemL txtImportante">(*)Por favor complete
								todos los campos.</div>
					
</div>

						<div class="blockInput_ mt10 ml90">
							<img src="${resource(dir:'images',file:'eConfianza.png')}" alt="eConfianza.org"
								title="eConfianza.org" />
						</div>

						<div class="clearFix">
							<br />
							<br />
						</div>

						 <input type="submit" name="submit" value="" class="registrate">
						<%--<a class="registrate" href="#dialog" name="modal"></a>

					--%></g:form>

				</div>

				<!-- END NEW USER -->

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
