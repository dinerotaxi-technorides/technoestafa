<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
	<script type="text/javascript"
				src="${resource(dir:'js',file:'jquery-1.4.2.min.js')}"></script>
  <link rel="stylesheet" href="${resource(dir:'css',file:'skin.css')}" />

	<script type="text/javascript"
				src="${resource(dir:'js',file:'jquery.jcarousel.min.js')}"></script><script type="text/javascript">

jQuery(document).ready(function() {
    jQuery('#mycarousel').jcarousel();
	scroll: 1
});

</script>
	<meta name="layout" content="dinerotaxiL" />
	
</head>
<body>
<div class="mainContent">
			
			
		<div class="con">
			
			
			<div class="container">

                                   
            <div class="cont_mail_confirma mt10">
                <div class="exitoso"></div>
                <div class="mens_confirma_mail">
                    <h2>Tu pedido está siendo procesado</h2>
                  
                    <a href='<g:createLink params="[country:"${params?.country?:''}"]"  action="index" controller="miPanel"/>' title="Ir a la Página principal" class="ir_inicio">Ir a la página principal</a>
                
                        
                   
                </div>
       
            </div>

		</div>


	</div>

</div>
</body>
</html>
