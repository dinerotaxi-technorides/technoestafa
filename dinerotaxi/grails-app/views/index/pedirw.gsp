
<%@ page import="com.page.register.IntegrateRegistrationCommand" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<script type="text/javascript"
	src="${resource(dir:'js',file:'jquery-1.4.2.min.js')}"></script>
<link rel="stylesheet" href="${resource(dir:'css',file:'skin.css')}" />

<meta name="layout" content="dinerotaxi1" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- META for Google Webmasters -->
<meta name="google-site-verification"
	content="NBzIvboQVvrq0MoRtNg_bbN7g6Qf-zWkn6wDGarb0lk" />
<meta name="author" content="DineroTaxi" />
<meta name="version" content="1.0" />
<meta name="description"
	content="DineroTaxi es un servicio para pedir taxis de forma automatica desde el movil. Con DineroTaxi tienes tu taxi en tu movil">
<meta name="keywords"
	content="taxi quiero pedir solicitar Madrid Barcelona Sevilla Valencia automatico aqui ahora android iphone blackberry">
<meta name="copyright"
	content="Copyright (c) DineroTaxi.com Todos los derechos reservados." />
<!-- METAS for Facebook -->
<meta property="og:title" content="DineroTaxi1" />
<meta property="og:type" content="company" />
<meta property="og:url" content="https://www.dinerotaxi.com" />
<meta property="og:image"
	content="${resource(dir:'img',file:'favicon.ico')}" />
<link rel="shortcut icon"
	href="${resource(dir:'img',file:'favicon.ico')}" type="image/x-icon" />
<link rel="apple-touch-icon-precomposed" href="${resource(dir:'images',file:'favicon.ico')}">
	
<%--	--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css/dinerotaxi',file:'modal.css')}" />--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />--%>
<%--   --%>

<link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />
    <g:javascript library="jquery" plugin="jquery"/>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery-ui-1.8.16.custom.min.js')}"></script>

<!--Google Analytics-->
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
	
    <script src="${resource(dir:'js/imported',file:'jquery.tools.min.js')}"></script>
    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true&language=es"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.simplemodal.1.4.2.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.validate.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'json2.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.tokeninput.js')}"></script>
    <jq:plugin name="fileuploader"/>
    <jq:plugin name="editable"/>    
    <jq:plugin name="places"/>    
    <jq:plugin name="multiselect"/>
    <script type="text/javascript" src="${resource(dir:"js/dinerotaxi${params?.country?'/'+params?.country:''}",file:'jquery.tbo.multiplace.js')}"></script>
    <jq:plugin name="newscomment"/>
    <jq:plugin name="follow"/>
	<script type="text/javascript"	src="${resource(dir:'js',file:'modal.js')}"></script>
<script  type="text/javascript" src="${resource(dir:'js',file:'funciones.js')}"></script>
<!-- This JavaScript snippet activates those tabs -->
<script> 
        // perform JavaScript after the document is scriptable.
      $(function() {
    	  $('#placeinput1').multiplace({tokenLimit: 1});
    	  $('#placeinput2').multiplace({tokenLimit: 1});


          
        function customCallback (params) {
            say('custom');
            $('#placeInput1').geoplaces({
              placePane: '#placePane',
              placeTemplate: 'div.template.place',
              map: '#map_canvas',
              get: '/places/get',
              add: '/place/saveAjax',
              del: '/place/deleteAjax',
              delay: 1000
            });
        }
        
        function onShow (dialog) {
            $(dialog.wrap).find("form").validate({errorElement:'p'});
            $('#placeInput1').geoplaces({
              placePane: '#placePane',
              placeTemplate: 'div.template.place',
              map: '.google-map',
              get: '/places/get',
              add: '/place/saveAjax',
              del: '/place/deleteAjax',
              delay: 1000
            });
        }
        
        function onShowMessage (dialog) {
            $(dialog.wrap).find("form").validate({errorElement:'p'});
            
            $('#to').tokenInput(
              this.attr('search'), {
              theme: "tbo",
              hintText: "",
              prePopulate: eval(this.attr('prepopulate'))
            });      
        }
                      
        function onShowBasicdata1 (a) {
            alert("here");
        }    
        function onSubmitProduct (data) {
            // simulates similar behavior as an HTTP redirect
            window.location.replace(data);
        }
      });

    </script>


<script src="js/modal.js" type="text/javascript"></script>
</head>
<body>

<!-- MODAL -->

<div id="boxes">
    <div id="dialog" class="window">
    	<div class="modal">
        
        	<img src="${resource(dir:'images',file:'dineroTaxi.png')}" alt="DineroTaxi.com" title="DineroTaxi.com" />
        	<h3>Bienvenido!</h3>
        	A partir de este momento puedes comenzar a<br /> utilizar los servicios de DINERO<b>TAXI</b>
            <br /><br />
            Confirmar para terminar el pedido.
            <br />
            <a href="#" class="conagre"></a>
            <div class="clearFix"></div>
            <a href="#" class="confirmar"></a>
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

<!-- MAIN -->


<div class="mainContent_">

	<div class="con">
    	
		<g:render template="buttons" model="['action':'pedir']" />
		   <g:if test="${flash.message}">
            	<div class="success" on>${flash.message}</div>
				<script type="text/javascript">
					showSuccessMessage();
				</script>
            </g:if>
            <g:if test="${flash.error}">
            	<div class="errors">${flash.error}</div>
				<script type="text/javascript">
					showErrorMessage();
				</script>
            </g:if>
        <br />
        	
			<g:form action="integrateRegistration" controller="register" name="registrationForm">

                <!--PASO 1-->    	
            <div class="nUsuario">
            	
                
                <div class="tit_combinado">
                    <img src="${resource(dir:'images',file:'uno.png')}" alt="Paso 1" />
                    <span class="txt_tit_combinado" style="margin-top: 20px;">Registrate</span>
                </div>
                	<div class="clearFix"><br /></div> 
                    <div class="ml20">
                    
                        <!--NOMBRE-->
                        <div class="cont_campo_form mt20">
                            <label class="ml5" for="firstname">Nombre*</label>
                            <div class="encierra_input">                                         
                            <input id="firstName" type="text" name="firstName" placeholder="requerido" value="${command?.firstName }"/></div>
                        </div>                                
                        
                        <!--APELLIDO-->
                        <div class="cont_campo_form">
                            <label class="ml5" for="lastName">Apellido*</label>
                        <div class="encierra_input"><input id="lastName" type="text" name="lastName" placeholder="requerido" value="${command?.lastName }""/></div>
                        </div>

                        <!--E-MAIL-->
                        <div class="cont_campo_form">
                        <label class="ml5" for="email">Email*</label>
                        <div class="encierra_input">
                            <input id="email" type="text" name="email" placeholder="ejemplo@mail.com" value="${command?.email }""/>
                        </div>
                        </div>
                        
                        <!--TELEFONO-->
                        <div class="cont_campo_form">
                            <label class="ml5" for="phone">Teléfono*</label>
                             <div class="encierra_input">
                            <input id="phone" type="text" name="phone" placeholder="Ej:1155554444" value="${command?.phone }""/>
                            </div>
                        </div>
                        
                        <!--CONTRASEÑA-->
                        <div class="cont_campo_form">
                            <label class="ml5" for="password">Contraseña*</label>
                             <div class="encierra_input">
                            <input id="password" type="password" name="password" placeholder="contraseña"/>
                            </div>
                        </div>
                        
                        <!--CONTRASEÑA-->
                        <div class="cont_campo_form">
                            <label class="ml5" for="password2">Repita Contraseña*</label>
                             <div class="encierra_input">
                            <input id="password2" type="password" name="password2" placeholder="confirmar contraseña" />
                            </div>
                        </div>
                        
                 	<!--TERMINOS Y CONDICIONES-->
                        <div class="cont_campo_form_check">
                          <label class="label_checkHome fixIe" for="agree"><a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="termsAndConditions" />" target="_blank" class="linkDocs">Términos y condiciones(**)</a></label>
                            <input name="agree" id="agree" value="1" type="checkbox" />
                      </div>
                        
                        <!--POLITICAS-->
                        <div class="cont_campo_form_check">
                          <label class="label_checkHome fixIe" for="politics"><a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="termsAndConditions" />" target="_blank" class="linkDocs">Políticas de privacidad(**)</a></label>
                            <input name="politics" id="politics" value="1" type="checkbox" />
                       </div>
                        
               
                            <span class="f12 ml20">(*) Campos obligatorios</span>
                            <br />
                            <span class="f12 ml20">(**) Aceptar condiciones y políticas</span>
                            
             
                        
                        
                </div>
            
            </div>
            
            <div class="divide"></div>
            
            <!--PASO 2-->
            <div class="tPedido">
                <div class="tit_combinado">
                    <img src="${resource(dir:'images',file:'dos.png')}" alt="Paso 2" />
                    <span class="txt_tit_combinado">Completá los datos para pedir tu taxi</span>
                </div>
                
            <div class="boxForm3_vers2 ml20 mt20">
                  
                              
               <div class="ini_viaje">

                    <label class="ml5" for="placeinput1">Dirección inicial</label>
                    <div class="field-input deleteabl1e" >
					  <div class="field-group deleteable">
				<input type="text" id="placeinput1" name="placeinput1" pre="" map="#map_canvas" placeholder="Ej:  Congreso 3800,Ciudad Autonoma de Buenos Aires"  />
					  </div>             
		</div>

                </div>
                               
                <div class="blockPD_2">
                    
                    <label class="ml5" for="piso">Piso</label> 
                     <input id="piso" type="text" name="piso" placeholder="-" class="inputShort2" value="${command?.piso}" /> 
                 </div>
                         
                <div class="blockPD_2">
                    <label class="ml5" for="departamento">Depto </label>
                    <input id="departamento" type="text" name="departamento" placeholder="-" class="ml5 inputShort2" value="${command?.departamento}" />
                </div>
            </div>
            
            
            <!--FIN DE VIAJE-->
            <div class="boxForm3_vers2 mt10 ml20">
         
               <div class="ini_viaje">
                    
                    <label class="ml5" for="placeinput2">Dirección de destino</label>
                    <div class="field-input deleteabl1e" >
					  <div class="field-group deleteable">
                                          <input id="placeinput2" type="text" name="placeinput2" placeholder="Ej: Av Maipu 1234"  pre="" map="#map_canvas"  />
					  </div>             
                    </div>

             </div>
             <div class="cont_texarea">
                   <label for="comentarios">Comentarios:</label><br />
                   <textarea name="comentarios" rows="5" cols="40" placeholder="Ingresar comentario" id="comentarios" value="${command?.comentarios}" ></textarea>
            </div>
            </div>
            
                <div class="mediumMap ml20">
                 <div id="map_canvas" class="google-map" style="width: 360px; height: 385px;"></div>
                	<!--<img src="images/ejRealizaTuPedido_.jpg" alt="ej realizar pedido" />-->
                
                </div>

            
            </div>
            <div class="divide"></div>
            <!--PASO 3-->
            <div class="pedi_taxi">
                
                <div class="tit_combinado">
                    <img src="${resource(dir:'images',file:'tres.png')}" alt="Paso 3" />
                    <span class="txt_tit_combinado">Difrutá tu viaje</span>
                </div>
                 <div class="clearFix"><br /></div> 
                <input type="submit" name="submit" value="" class="pedirTaxi_" />
                 <div class="clearFix"></div> 
                <p>Gracias por confiar en dinerotaxi.com.¡Hasta el próximo viaje!</p>
            </div>
            </g:form>
            <div class="clearFix"><br /></div> 
         
          <!-- LOGIN -->

				<div class="bOX955">

					<h1>¿Usuario de DINEROTAXI?</h1>

					<form action="${request.contextPath}/j_spring_security_check"
					method='POST' id='userLoginInBodyForm' name="userLoginInBodyForm"
					 autocomplete='on' class="ml20">

						<div class="blockInput_">
							<span class="fl_">Email</span> <input id="j_username" type="text"
								name='j_username' placeholder="pepe@hotmail.com"
								size="34" />
						</div>


						<div class="blockInput_">
							<span class="fl_">Contraseña</span> <input id="j_password"
								type="password" name="j_password" placeholder="**********"
								size="34" />
						</div>

					<a
						onclick="$('#userLoginInBodyForm').submit();" href="#"
						class="entrar"></a>
					<div class="olvido">
						<a href='<g:createLink params="[country:"${params?.country?:''}"]"  controller="register" action="forgotPassword"/>' class="">¿Olvidaste la contraseña?</a>
						&nbsp;&nbsp;
						
					</div>


					</form>

					
					<br />

					

				</div>

    </div>    

</div>



</body>
</html>
