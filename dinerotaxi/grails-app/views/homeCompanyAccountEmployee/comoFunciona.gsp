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


<script src="https://connect.facebook.net/en_US/all.js#xfbml=1" type="text/javascript"></script>
		
		
	<meta name="layout" content="dinerotaxiCompanyAccountEmployeeL" />
	
</head>
<body>

<div class="mainContent">

	<div class="con">
    
        
        <div class="bOX955 mt10">

        	<h1>¿Cómo pido un taxi en DineroTaxi?</h1>
            
            <div class="boxPasos">
            	<div class="numero"><img src="${resource(dir:'images',file:'uno.png')}" alt="Paso 1" /></div>
                <div class="titulo">
                	<h2>Tu ubicación</h2>
                    <div class="misc">Nos dices donde te encuentras</div>
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
                	<h2>Aviso</h2>
                    <div class="misc">En minutos el taxi estará esperandolo</div>
                </div>
            </div>
        
        </div>

        
      
    </div>

</div>
</body>
</html>
