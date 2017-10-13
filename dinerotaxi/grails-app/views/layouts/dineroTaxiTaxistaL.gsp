<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

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
	<script type="text/javascript"
				src="${resource(dir:'js',file:'jquery.placeholder.js')}"></script>
	
<script type="text/javascript">
	jQuery(document).ready(function($) {
	$('#d1').placeholder();	
	$('#d2').placeholder();
	});
</script>


<g:layoutHead />
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-29162604-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</head>

<body>

	<!-- HEADER -->

<div class="header">

	<div class="con">

		
        <div class="logo">
        
        	<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" />"><img src="${resource(dir:'images',file:'dineroTaxi.png')}" alt="DineroTaxi.com" title="DineroTaxi.com" border="0" /></a>

        </div>
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="downloadTaxista" />" class="download_"></a>
        
        <div class="gratis"><img src="${resource(dir:'images',file:'gratis.png')}" alt="Totalmente Gratis" title="Totalmente Gratis" /></div>
        
	</div>

</div>

<!-- END HEADER -->	

<!-- TOP MENU -->

<div class="topMenu">
	
    <div class="con">
    
    	<div class="leftMenu">
        	
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeTaxista" action="comoUsarlo" />" class="btn">¿Cómo Usarlo?</a> 
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeTaxista" action="nosotros" />" class="btn">Nosotros</a> <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeTaxista" action="comoFunciona" />" class="btn">¿Cómo funciona?</a>
            
        </div>
        
        <div class="rightMenu">
        
        	<div class="sepLog"></div>
            
            <div class="btn_"><img src="${resource(dir:'images',file:'user.png')}" border="0" alt="registración" /> <span class="adjustment"><sprr:fullInfo/></span></div>
            
             <g:link  params="[country:"${params?.country?:''}"]" controller="miPanelTaxista" class="btn"><img src="${resource(dir:'images',file:'config.png')}" border="0" alt="Login" /> <span class="adjustment">Mi panel</span></g:link>
           <g:link  params="[country:"${params?.country?:''}"]" controller="logout" class="btn"><img src="${resource(dir:'images',file:'close.png')}" border="0" alt="Login" /> <span class="adjustment">Cerrar sesión</span></g:link>
            
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
        
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeTaxista" action="comoFunciona" />" class="btn">¿Cómo funciona?</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeTaxista" action="nosotros" />" class="btn">Nosotros</a>

            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeTaxista" action="termsAndConditions" />" class="btn">Términos y condiciones</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeTaxista" action="termsAndConditions" />" class="btn">Política de privacidad</a>
            <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeTaxista" action="contact" />" class="btn">Contactanos</a>
        
        </div>
        
        <div class="clearFix"></div>
    
        <hr />
        
        <div class="copyright">

        
        	2011/2012 © DineroTaxi | Todos los derechos reservados

		</div>    
    
    </div>

</div>

<!-- END FOOTER -->

</body>

</html>
