<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
  <link rel="stylesheet" href="${resource(dir:'css',file:'skin.css')}" />

	<script type="text/javascript"
				src="${resource(dir:'js',file:'jquery.jcarousel.min.js')}"></script><script type="text/javascript">

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
    
        
        <div class="bOX955 mt10">

        
        	<h1>¿Cómo pido un taxi en DineroTaxi?</h1>
            
            <div class="boxPasos">
            	<div class="numero"><img src="${resource(dir:'images',file:'uno.png')}" alt="Paso 1" /></div>
                <div class="titulo">
                	<h2>Tu ubicación:</h2> 
                    <div class="misc">Nos decís dónde estás	</div>
                </div>

            </div>
            <div class="boxPasos">
            	<div class="numero"><img src="${resource(dir:'images',file:'dos.png')}" alt="Paso 2" /></div>
                <div class="titulo">
                	<h2>Proximidad</h2>
                    <div class="misc">Enviamos el taxi libre más próximo</div>
                </div>
            </div>

            <div class="boxPasos">
            	<div class="numero"><img src="${resource(dir:'images',file:'tres.png')}" alt="Paso 3" /></div>
                <div class="titulo">
                	<h2>Aviso:</h2> 
                    <div class="misc">En minutos el taxi estará esperándote.</div>
                </div>
            </div>
        
        </div>

        
        <div class="bOX460">
        	<h1>¿Primera vez en DineroTaxi?</h1>
             Para poder hacer uso del sistema tenés que registrarte con tu nombre y tu número de celular. 
            <br />
            Accedé ya a los beneficios de DineroTaxi.
            <div class="containerBtn">
            	<a href='<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="registration"/>' class="registrate"></a>
            </div>

        </div>
        
        <div class="bOX460">
        	<h1>Usuarios de DineroTaxi</h1>
				<form action="${request.contextPath}/j_spring_security_check"
					method='POST' id='userLoginInBodyForm' name="userLoginInBodyForm"
					class='' autocomplete='on'>
					
            		<div class="blockInput_">
						<span class="fl">Email</span> <input id='username' type='text'
							name='j_username' placeholder="ejemplo@mail.com" size="34" />
					</div>
 
                	<div class="clearFix"></div>
               
					<div class="blockInput_">
						<span class="fl">Contraseña</span> <input id="password"
							type="password" name='j_password' placeholder="contraseña"
							size="34" />
					</div>
					<div class="clearFix"></div>
	                <div class="containerBtn_">
						<div class="olvido">
							<a href='<g:createLink params="[country:"${params?.country?:''}"]"  controller="register" action="forgotPassword"/>' class="">¿Olvidaste la contraseña?</a>
						</div>
						<a	onclick="$('#userLoginInBodyForm').submit();" href="#"
							class="entrar"></a> 
	                </div>  
              
            </form>    
        </div>
    
    </div>

</div>
</body>
</html>
