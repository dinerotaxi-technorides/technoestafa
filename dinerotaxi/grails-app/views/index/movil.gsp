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


			<g:render template="buttons" model="['action':'movil']" />

			<div class="clearFix">
				<br />
			</div>
			<div class="bOX955 mt10">

				<h3 class="mt10">DineroTaxi ya esta disponible para:</h3>

				<div class="boxes">
					<div class="boxDescargar">
						<div class="num_">
							<img src="${resource(dir:'images',file:'android.png')}"
								alt="Android" />
						</div>
						<div class="title_">
							<h3>Versión Android</h3>
							<a
								href="https://play.google.com/store/apps/details?id=com.dinerotaxi.android.pasajero"
								class="descargar"></a>
						</div>
					</div>

					<div class="boxDescargar">
						<div class="num_">
							<img src="${resource(dir:'images',file:'apple.png')}" alt="Apple" />
						</div>
						<div class="title_">
							<h3>Versión iPhone</h3>
							<a
								href="http://itunes.apple.com/es/app/dinerotaxi/id561564267?mt=8&ign-mpt=uo%3D2"
								class="descargar"></a>

						</div>
					</div>

					<div class="boxDescargar">
						<div class="num_">
							<img src="${resource(dir:'images',file:'blackberry.png')}"
								alt="BlackBerry" />
						</div>
						<div class="title_">
							<h3>Versión BlackBerry</h3>
							<!--<a href="descargar.html" class="descargar"></a>-->
							<a
								href=" http://appworld.blackberry.com/webstore/content/123843/"
								class="descargar"></a>

						</div>
					</div>
				</div>

			</div>
			<div class="bOX955">

				<h1>Realiza tu pedido desde la aplicación</h1>

				<h3>Inicio del viaje</h3>

				<div class="sld">
					<ul id="mycarousel" class="jcarousel-skin-tango">
						<li>

							<div class="boxC">
								<div class="num">1 |</div>
								<div class="title">1. Registrarse como usuario en el
									sistema.</div>
								<br class="clearFix" />
								<div class="boxIMG">
									<img src="${resource(dir:'images',file:'p1.jpg')}"
										alt="DINERO TAXI pantalla de login" />
								</div>
							</div>
						</li>

						<li>
							<div class="boxC">
								<div class="num">2 |</div>
								<div class="title">Puede detectar cuál es su ubicación y
									enviar su pedido de taxi desde allí.</div>
								<br class="clearFix" />
								<div class="boxIMG">
									<img src="${resource(dir:'images',file:'p2.jpg')}"
										alt="DINERO TAXI pantalla inicial" />
								</div>
							</div>
						</li>

						<li>
							<div class="boxC">
								<div class="num">3 |</div>
								<div class="title">También puede ingresar una dirección
									manualmente.</div>

								<br class="clearFix" />
								<div class="boxIMG">
									<img src="${resource(dir:'images',file:'p3.jpg')}"
										alt="DINERO TAXI cargar ubicación" />
								</div>
							</div>

						</li>
						<li>
							<div class="boxC">
								<div class="num">4 |</div>
								<div class="title">Un taxi recibe su pedido y confirman su
									solicitud.</div>


								<br class="clearFix" />
								<div class="boxIMG">
									<img src="${resource(dir:'images',file:'p4.jpg')}"
										alt="DINERO TAXI pedido en curso" />
								</div>

							</div>
						</li>
						<li>
							<div class="boxC">
								<div class="num">5 |</div>
								<div class="title">La aplicación le confirma tu pedido con
									la información del chofer y el número de móvil.</div>

								<br class="clearFix" />
								<div class="boxIMG">
									<img src="${resource(dir:'images',file:'p5.jpg')}"
										alt="DINERO TAXI confirmación del pedido" />
								</div>

							</div>
						</li>
						<li>
							<div class="boxC">
								<div class="num">6 |</div>
								<div class="title">Cuando el taxi llega, DineroTaxi le
									avisa que lo está esperando.</div>

								<br class="clearFix" />
								<div class="boxIMG">
									<img src="${resource(dir:'images',file:'p6.jpg')}"
										alt="DINERO TAXI aviso de espera" />
								</div>

							</div>
						</li>
						<li>
							<div class="boxC">
								<div class="num">7 |</div>
								<div class="title">Tiene la posibilidad de registrar sus
									viajes más frecuentes.</div>

								<br class="clearFix" />
								<div class="boxIMG">
									<img src="${resource(dir:'images',file:'p7.jpg')}"
										alt="DINERO TAXI mis favoritos" />
								</div>

							</div>
						</li>
					</ul>


				</div>
			</div>

		</div>

	</div>
</body>
</html>
