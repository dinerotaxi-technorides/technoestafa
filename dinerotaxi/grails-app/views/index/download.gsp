<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<link rel="stylesheet" href="${resource(dir:'css',file:'skin.css')}" />

<script type="text/javascript"
	src="${resource(dir:'js',file:'jquery.jcarousel.min.js')}"></script>
<script type="text/javascript">

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
    
    	<div class="container">
    	
        <div class="bOX725 mt10">
        
                <h1>Obtené la aplicación de DineroTaxi.</h1>
                    
                <h3 class="mt10">Comenzá la descarga.</h3>
                
                <ul>
                	<li>Descarga gratuita.</li>
                    <li>Simple y fácil de utilizar. </li>
                    <li>Rápida y eficaz. </li>
                    <li>Para todos los dispositivos. </li>
                </ul>
                
         </div>       
                
         <div class="bOX725 mt20">
        
                <h1>Elije según tu dispositivo.</h1>
                
                <div class="p-us"></div>
                
                <h3 class="mt10">DineroTaxi ya esta disponible para:</h3>       
                
                <div class="boxDescargar">
                    <div class="num_"><img src="${resource(dir:'images',file:'android.png')}" alt="Android" /></div>
                    <div class="title_">
                        <h3>Versión Android</h3>
                        <a href="https://play.google.com/store/apps/details?id=com.dinerotaxi.android.pasajero" class="descargar"></a>
                    </div>
                </div>
                
                <div class="boxDescargar">
                    <div class="num_"><img src="${resource(dir:'images',file:'apple.png')}" alt="iPhone" /></div>
                    <div class="title_">
                        <h3>Versión iPhone</h3>
                        <a href="http://itunes.apple.com/es/app/dinerotaxi/id561564267?mt=8&ign-mpt=uo%3D2" class="descargar"></a>
                        
                    </div>
                </div>
                
                <div class="boxDescargar">
                    <div class="num_"><img src="${resource(dir:'images',file:'blackberry.png')}" alt="BlackBerry" /></div>
                    <div class="title_">
                        <h3>Versión BlackBerry</h3>
                        <!--<a href="descargar.html" class="descargar"></a>-->
                       <a href=" http://appworld.blackberry.com/webstore/content/123843/" class="descargar"></a>
                        
                    </div>
                </div>
                
               
            
        	</div>
            
        </div>
         
         <!-- SIDEBAR -->
            
 
        <div class="sidebar mt10">
            
              
			<!--  g:render template="/template/recomenda" /-->
                
              
			<g:render template="/template/shareFacebook" />
            
            </div>
    
    </div>

</div>

</body>
</html>
