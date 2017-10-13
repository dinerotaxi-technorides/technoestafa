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
<meta name="layout" content="dinerotaxi" />
	
</head>
<body>

<div class="mainHome">

	<div class="con">
    
    	<div class="content">
        <div class="clearFix"><br /></div>
            
            <div class="boxUsuario">
            	
                <h2>QUIERO UN TAXI</h2>
                
                <span class="ml5">Simple, práctico y gratis!</span>

                
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"   controller="index" action="pedirw" />" class="pedirTaxi"></a>
                
            </div>
            
            <div class="boxTaxista">
            	
                <h2 class="yellow">TENGO RADIO TAXI:</h2>
 
                
                <span class="yellow ml5">¡Incrementá tus viajes!</span>
                
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"    controller="index" action="registro" />" class="masInfo"></a>
                
            </div>
            
            <div class="clearFix"><br /></div>
        
        	<div class="bOX725">
            	
                <h1>¿Qué es DINEROTAXI?</h1>
                	DineroTaxi es un novedoso sistema que te permite ahorrar tiempo a la hora de pedir un taxi.<br />
					Sólo necesitas bajar la aplicación, para que de manera rápida y segura te enviemos el taxi al lugar donde te encuentres. A través de un celular o smartphone, DineroTaxi localiza tu ubicación y te envía el taxi más cercano. 
					<br />También, podés establecer una dirección precisa vía online o por medio de tu celular registrándote en la página web.
            </div>
            
            <div class="clearFix"><br /></div>
            
            <div class="bOX725">
            
            	<div class="movil"><img src="${resource(dir:'images',file:'movilHome.png')}" alt="DineroTaxi" title="DineroTaxi" /></div>
            	
                <h1>¿Por qué elegir DINEROTAXI?</h1>
                
                <ul> 
                	<li>Sencillo y rápido a la hora de pedirlo.</li>
					<li>Sin tener que esperar a un operador, con dos clicks tu taxi estará esperándote.</li>
					<li>Una manera segura y confiable de viajar. </li>
					<li>Con toda la información del chofer y el móvil a tu disposición. </li>
					<li>Cuenta con sistema GPS que permite ubicar tu móvil durante todo el trayecto.</li>
					<li>Podés pedir tu taxi en todo momento y lugar. ¡100% gratis!"</li>
                </ul>                
                
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"   controller="index" action="pedirw" />" class="probar"></a>
                
            </div>
            
            
            
            

        
        </div>
        
        <div class="sidebar">
        
        	<div class="bOX221">
            	
                <img src="${resource(dir:'images',file:'movilApp.png')}" alt="Imagen decorativa de la aplicación de dinerotaxi.com" title="Dinero Taxi aplicación" align="left" class="mr5" />
                <h3>Descargá la aplicación:</h3>
                Para tu iphone, blackberry, android.
                
                <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="download" />" class="descargar"></a>
                
            </div>
            
            <div class="clearFix"><br /></div>

            	                               
         
			<g:render template="/template/shareFacebook" />
            <div class="clearFix"><br /></div>
            
          

            
            
        
        </div>
    
    </div>

</div>

            
</body>
</html>
