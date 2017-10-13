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


			<g:render template="buttons" model="['action':'sms']" />

			<div class="clearFix">
				<br />
			</div>

			<div class="bOX955">

				<h1>Realiza tu pedido desde tu móvil</h1>

				<br />

				<h3>¿Cómo funciona desde mi móvil?</h3>

				<br />A partir de su teléfono móvil podrá realizar el pedido del taxi de manera fácil y rápida.<br />
				 Envíe un mensaje de texto al *taxi con su nombre y dirección donde se encuentra, rápidamente recibirá
				un mensaje con su confirmación y la información del número de móvil y el chofer que lo llevará a su destino. <br /> <br /> <br /> <br />
				<div class="proxMovil">
					<h3>Próximamente</h3>
					<span class="ml5">Pedilo con un SMS</span>

				</div>
				<br />


			</div>
			
		</div>

	</div>


</body>
</html>
