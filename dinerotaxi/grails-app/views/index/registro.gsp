<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<link rel="stylesheet" href="${resource(dir:'css',file:'skin.css')}" />

<script type="text/javascript"	src="${resource(dir:'js',file:'modal.js')}"></script>
<script type='text/javascript' src='${resource(dir:'js/jquery',file:'jquery.validate.js')}'></script>
<script type="text/javascript">

	$().ready(function() {
		// validate the comment form when it is submitted
		// validate signup form on keyup and submit
		$("#registrationForm1").validate({
			 submitHandler: function(form) {
				   form.submit();
				 },
			rules: {
				name: "required",
				phone: {
					required: true,
					minlength: 10,
					maxlength: 10
				},
				password: {
					required: true,
					minlength: 5
				},
				
				email: {
					required: true,
					email: true
				},
				password2: {
				      equalTo: "#password"
				    },
				agree: "required",
				politics: "required"
			},
			messages: {
				name: "Por Favor Ingrese Su Nombre/Razon Social",
				phone: {
					required: "Por Favor Ingrese un Telefono Valido",
					minlength: "Debe tener como minimo 10 numeros",
					maxlength: "Debe tener como maximo 10 numeros"
				},
				password: {
					required: "Por Favor Complete el campo Password",
					minlength: "La contraseña debe tener 5 caracteres"
				},
				password2: {
					equalTo: "El Password debe ser igual"
				},
				email: "Por Favor Ingrese un Email Valido",
				agree:"Debe Aceptar los terminos y condiciones",
				politics:"Debe Aceptar las politicas de privacidad"
			},errorElement: "div"
				
		});

		
	});

		
</script>
<meta name="layout" content="dineroTaxiTaxista" />

</head>
<body>

	
<div class="mainContent_">

	<div class="con">
    
		
        <div class="clearFix"><br /></div>
        
        <div class="bOX955">
        
        	<h1>Bienvenido a DINEROTAXI gracias por elegirnos!</h1>
            
            Date de alta en el sistema de Dinero<b>Taxi</b> completando el siguiente formulario y comienza a incrementar tus ingresos.
        
        </div>
        
        <div class="bOX460">
        	<h1>¿Qué necesito?</h1>
            Para poder usar el sistema de DINEROTAXI solo necesitas:
            <div class="clearFix"><br /><br /></div>
            <div class="blockNecesito">
            	<div class="obj">
                	<img src="${resource(dir:'images',file:'movil_.png')}" alt="Móvil" />
                    Móvil
                </div>
                <div class="llave"></div>
                <div class="row">
                    <img src="${resource(dir:'images',file:'net_.png')}" alt="Internet" align="left" /> 
                    <div class="txt">Internet</div> 
                    <img src="${resource(dir:'images',file:'gps_.png')}" alt="GPS" align="left" /> 
                    <div class="txt">GPS</div> 
                </div>
                <div class="row">Tener un celular con acceso a INTERNET y que tenga GPS.</div>
            </div>
            <div class="blockMas"></div>
            <div class="blockNecesito">
            	<div class="obj">
                	<img src="${resource(dir:'images',file:'aplicacion.png')}" alt="Aplicación" />
                    Aplicación
                </div>
                <div class="llave"></div>
                <div class="row">Descargar la aplicación e instalarla en tu celular.</div>
                <div class="row">¿Cómo descargar e instalar? Desde tu móvil ingresa en <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="downloadTaxista"/>">www.dinerotaxi.com/downloadTaxista</a></div>
            </div>
            <br /><br />
        </div>
        
        <div class="bOX460">
        	<h1>Comenzar la registración</h1>
            
			<g:form action="registro" controller="register" name="registrationForm1">
              <span style="margin: 1em 0 .5em 0; display: block;"><strong>Elija de que modo desea registrarse</strong></span>
                            <div class="contenedor_radio">
                    
                    <div class="cont_input_radio" style="display: inline;"><input type="radio" name="type" value="1" id="type" checked/><span class="lbl_radio">Empresa</span></div>
                    <!--  div class="cont_input_radio"><input type="radio" name="type" value="2" id="type"  /><span class="lbl_radio">Dueño</span></div-->
                    </div>

                <div class="clearFix"><br /></div>
                <div class="blockInput_">
                    <label class="fl2" for="name">Nombre y Apellido, <br />o razón social*</label>
                    <div class="encierra_input"><input id="name" type="text" name="name" placeholder="Juan Perez" size="34" /></div>
                </div>
                <div class="clearFix"><br /></div>
                
                <div class="blockInput_">
                    <label class="fl2" for="phone">Teléfono de <br />contacto*</label>  
                    <div class="encierra_input"><input id="phone" type="text" name="phone" placeholder="55554444" size="34" /></div>
                </div>
                <div class="clearFix"><br /></div>
                
                <div class="blockInput_">
                    <label class="fl2" for="email">Email*</label>
                    <div class="encierra_input"><input id="email" type="text" name="email" placeholder="juanperez@hotmail.com" size="34" /></div>
                </div>
                <div class="clearFix"><br /></div>
                
                <div class="blockInput_">
                    <label class="fl2" for="password">Contraseña*</label> 
                    <div class="encierra_input"><input id="password" type="password" name="password" placeholder="********" size="34" /></div>
                </div>
                <div class="clearFix"><br /></div>
                
                <div class="blockInput_">
                    <label class="fl2" for="password2">Repetir contraseña*</label>  
                    <div class="encierra_input"><input id="password2" type="password" name="password2" placeholder="********" size="34" /></div>
                </div>
                <div class="clearFix"><br /></div>
                     
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
                        <div class="clearFix"><br /><br /><br /></div>
                                               
						<div class="clearFix"><br /></div>

						 <input type="submit" name="submit" value="" class="registrate" />
            
            </g:form>
            <br /><br />
            
        </div>
      </div>

</div>


</body>
</html>
