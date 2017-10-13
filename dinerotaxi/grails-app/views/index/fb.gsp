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

			<g:render template="buttons" model="['action':'fb']" />

			<div class="clearFix">
				<br />
			</div>


			<div class="bOX955">

				<h1>Realiza tu pedido desde Facebook</h1>

				<br />

				<h3>¿Cómo funciona desde Facebook?</h3>

				<br /> Si usted utiliza Facebook, puede registrarse a partir de su usuario y utilizar la aplicación de DineroTaxi para Facebook.  <br />
				Desde allí podrá realizar su pedido sólo ubicando la dirección donde deseea que lo espere el taxi y hacia donde se dirige. <br />
				DineroTaxi le enviará una confirmación del taxi que lo llevará y los datos del chofer. <br />
				 De esta manera ahorrará en tiempo y en dinero, permitiendo un viaje confiable, seguro y conveniente. <br />
				<br />
				<br />
				<br />

				<div class="proxFB">
					<h3>Próximamente</h3>
					<span class="ml5">Desde Facebook</span>

				</div>

				<br />

			</div>
		
		</div>

	</div>

</body>
</html>
