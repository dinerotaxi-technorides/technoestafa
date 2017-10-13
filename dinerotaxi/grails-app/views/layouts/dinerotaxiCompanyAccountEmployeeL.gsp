
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript">
var contextPath="${createLink(absolute:true,uri:'/')}";
var isVisible=false;

</script>
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
<link rel="stylesheet" href="${resource(dir:'css',file:'skin.css')}" />


<link rel="stylesheet" href="${resource(dir:'css/notifications',file:'notifications.css')}" />
<link rel="stylesheet" href="${resource(dir:'css/notifications',file:'style_light.css')}" />
<link rel="stylesheet" href="${resource(dir:'css/notifications',file:'uniform.css')}" />


<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js" type="text/javascript"></script>

<script type="text/javascript" src="${resource(dir:'js',file:'jquery.placeholder.js')}"></script>
<script type="text/javascript"	src="${resource(dir:'js',file:'modal.js')}"></script>
<script type='text/javascript' src='${resource(dir:'js',file:'jquery.validate.js')}'></script>
<script  type="text/javascript" src="${resource(dir:'js',file:'funciones-basicas.js')}"></script>

<script type='text/javascript' src='${resource(dir:'js/miPanel',file:'common.js')}'></script>
<script type='text/javascript' src='${resource(dir:'js/bootstrap',file:'bootstrap-alerts.js')}'></script>


	

<g:layoutHead />

<%--Notificaciones--%>
<script type='text/javascript' src='${resource(dir:'js/notifications',file:'jquery-ui-1.8.14.custom.min.js')}'></script>
<script type='text/javascript' src='${resource(dir:'js/notifications',file:'ttw-notification-menu.js')}'></script>
<script type='text/javascript' src='${resource(dir:'js/notifications',file:'notifications.js')}'></script>

<script type='text/javascript' src='${resource(dir:'js/notifications',file:'jquery.tools.js')}'></script>
<script type='text/javascript' src='${resource(dir:'js/notifications',file:'jquery.uniform.min.js')}'></script>
<script type='text/javascript' src='${resource(dir:'js/notifications',file:'main.js')}'></script>
<style type="text/css">

        .tooltip {

            width: 250px;

            font-size: 11px;

            font-family: Arial, sans-serif;

            background: #444;

            border: 1px solid #090909;

            border-radius: 4px;

            -moz-border-radius: 4px;

            -webkit-border-radius: 4px;

            position: absolute;

            z-index: 1;

            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);

            -webkit-box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);

            -moz-box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);

            color:#fff;

            padding:12px 24px;

            line-height:18px;

        }



        .tooltip:after {

            content: '';

            position: absolute;

            border-color: transparent  #444 transparent transparent;

            border-style: solid;

            border-width: 10px;

            height: 0;

            width: 0;

            position: absolute;

            left: 0;

            top: 50%;

            margin-top: -10px;

            margin-left: -20px;

        }



        .tooltip:before {

            content: '';

            position: absolute;

            border-color:   transparent #090909 transparent transparent;

            border-style: solid;

            border-width: 10px;

            height: 0;

            width: 0;

            position: absolute;

            left: 0;

            top: 50%;

            margin-top: -10px;

            margin-left: -20px;

        }

        



        .ttw-notification-menu{

                width: 276px;

        }





    </style>
</head>

<body>

	<!-- HEADER -->

<div class="header">

	<div class="con">

		
        <div class="logo">
        
        	<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" />"><img src="${resource(dir:'images',file:'dineroTaxi.png')}" alt="DineroTaxi.com" title="DineroTaxi.com" border="0" /></a>

        </div>
           
        <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" action="download" />" target="_blank" class="download"></a>
        
        <div class="gratis"><img src="${resource(dir:'images',file:'gratis.png')}" alt="Totalmente Gratis" title="Totalmente Gratis" /></div>
	</div>

</div>

<!-- END HEADER -->	

<!-- TOP MENU -->

<div class="topMenu">
	
    <div class="con">
    
    	<div class="leftMenu">
        	
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee"  />" class="btn">Realizar Pedido</a> 
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" action="nosotros" />" class="btn">Nosotros</a> <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" action="comoFunciona" />" class="btn">¿Cómo funciona?</a>
            
        </div>
        
     
        <div class="rightMenu">
        
        	<div class="sepLog"></div>
            
            <div class="btn_">
            <span class="notification-menu-item first-item" id="notifications">
            <img src="${resource(dir:'images',file:'user.png')}" border="0" alt="registración" /></span>
             <span class="adjustment"><sprr:fullInfo/></span></div>
            
             <g:link  params="[country:"${params?.country?:''}"]" controller="miPanelCompanyAccountEmployee" class="btn"><img src="${resource(dir:'images',file:'config.png')}" border="0" alt="Login" /> <span class="adjustment">Mi panel</span></g:link>
       		 <sec:ifAllGranted roles="ROLE_FACEBOOK">
          
           		<a href="#" class="btn" onClick="logoutFacebook('${createLink(absolute:true,controller:'logout')}');">
           			<img src="${resource(dir:'images',file:'close.png')}" border="0" alt="Login" /> <span class="adjustment">Cerrar sesión</span>
      			</a>
            </sec:ifAllGranted>
            
             <sec:ifNotGranted roles="ROLE_FACEBOOK">
           		<g:link  params="[country:"${params?.country?:''}"]" controller="logout" class="btn"><img src="${resource(dir:'images',file:'close.png')}" border="0" alt="Login" /> 
           				<span class="adjustment">Cerrar sesión</span>
  				</g:link>
        	</sec:ifNotGranted>
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
        
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" action="comoFunciona" />" class="btn">¿Cómo funciona?</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" action="nosotros" />" class="btn">Nosotros</a>

            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" action="termsAndConditions" />" class="btn">Términos y condiciones</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" action="termsAndConditions" />" class="btn">Política de privacidad</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeCompanyAccountEmployee" action="contact" />" class="btn">Contactanos</a>
        
        </div>
        
        <div class="clearFix"></div>
    
        <hr />
        
        <div class="copyright">

        
        	2011/2012 © DineroTaxi | Todos los derechos reservados

		<g:render template="/template/remaking" /> 
		</div>    
    
    </div>

</div>

<div id="fb-root" class=" fb_reset"><div style="position: absolute; top: -10000px; height: 0pt; width: 0pt;"></div></div>
<%--<script type="text/javascript" >initFacebookIntegration('${grailsApplication.config.grails.plugins.springsecurity.facebook.appId }');</script>--%>
<!-- END FOOTER -->

</body>

</html>
