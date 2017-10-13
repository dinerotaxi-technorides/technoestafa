<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>



<title>DineroTaxi.com | La nueva forma de tomar un taxi!</title>

<meta name="Subject" content="DINERO TAXI" />
<meta name="Keywords" content="DINERO TAXI" />

<!--[if IE]><![endif]--> 
<!--[if lt IE 7 ]> <html lang="es" class="no-js ie6"> <![endif]--> 
<!--[if IE 7 ]>    <html lang="es" class="no-js ie7"> <![endif]--> 
<!--[if IE 8 ]>    <html lang="es" class="no-js ie8"> <![endif]--> 
<!--[if IE 9 ]>    <html lang="es" class="no-js ie9"> <![endif]--> 
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="es" class="no-js"> <!--<![endif]--> 

<link rel="shortcut icon" href="${resource(dir:'img',file:'favicon.ico')}" />
<link rel="stylesheet" href="${resource(dir:'css',file:'styles.css')}" />
<link rel="stylesheet" href="${resource(dir:'css',file:'crossbrowsing.css')}" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${resource(dir:'js',file:'jquery.placeholder.js')}"></script>
<script  type="text/javascript" src="${resource(dir:'js',file:'jquery.lwtCountdown-1.0.js')}"></script>
<script type="text/javascript"	src="${resource(dir:'js',file:'modal.js')}"></script>
<script type='text/javascript' src='${resource(dir:'js',file:'jquery.validate.js')}'></script>
<script  type="text/javascript" src="${resource(dir:'js',file:'funciones-basicas.js')}"></script>
<script type='text/javascript' src='${resource(dir:'js/miPanel',file:'common.js')}'></script>


<script type='text/javascript' src='${resource(dir:'js/bootstrap',file:'bootstrap-alerts.js')}'></script>

	
<g:layoutHead />
</head>

<body>

	<!-- HEADER -->

<div class="header">

	<div class="con">

		
        <div class="logo">
        
        	<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" />"><img src="${resource(dir:'images',file:'dineroTaxi.png')}" alt="DineroTaxi.com"  title="Ir a Inicio (Tecla de Acceso:a)"  border="0" /></a>

        </div>
       <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="download" />" target="_blank" class="download"></a>
        
        <div class="gratis"><img src="${resource(dir:'images',file:'gratis.png')}" alt="Totalmente Gratis" title="Totalmente Gratis" /></div>
   
	</div>
        

</div>

<!-- END HEADER -->	

<!-- TOP MENU -->

<div class="topMenu">
	
    <div class="con">
    
    	<div class="leftMenu">
        	
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="pedirw" />" class="btn">Realizar Pedido</a> 
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="nosotros" />" class="btn">Nosotros</a> <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="comoFunciona" />" class="btn">¿Cómo funciona?</a>
            
        </div>
        
        <div class="rightMenu">
        
        	<div class="sepLog"></div>

            
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="registration" />" class="btn"><img src="${resource(dir:'images',file:'register.png')}" border="0" alt="registración" /> <span class="adjustment">Registrarse</span></a>
            
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="login" action="auth" />" class="btn"><img src="${resource(dir:'images',file:'login.png')}" border="0" alt="Login" /> <span class="adjustment">Login</span></a>
            
        </div>
    
    </div>
    
</div>

	<!-- END MENU -->

	<!-- MAIN -->

	<g:layoutBody />


	<!-- END MAIN -->

	<div class="clearFix"></div>

<!-- FOOTER -->

<div class="footer">
	
    <div class="con">
    
 
		<g:render template="/template/socialMedia" />       
        <div class="clearFix"></div>
        
        <div class="menuBottom">
        
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="comoFunciona" />" class="btn">¿Cómo funciona?</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="nosotros" />" class="btn">Nosotros</a>

            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="termsAndConditions" />" class="btn">Términos y condiciones</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="termsAndConditions" />" class="btn">Política de privacidad</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="contact" />" class="btn">Contactanos</a>
        
        </div>
        
        <div class="clearFix"></div>
    
        <hr />
        
        <div class="copyright">

        
        	2011/2012 © DineroTaxi | Todos los derechos reservados

		<g:render template="/template/remaking" /> 
		</div>    
    
    </div>
  
</div>

<!-- END FOOTER -->

<div id="fb-root" class=" fb_reset"><div style="position: absolute; top: -10000px; height: 0pt; width: 0pt;"></div></div>
<%--<script type="text/javascript" >initFacebookIntegration(${grailsApplication.config.grails.plugins.springsecurity.facebook.appId });</script>--%>

</body>

</html>
