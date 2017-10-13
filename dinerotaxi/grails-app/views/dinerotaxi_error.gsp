<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>


<!--METATAGS-->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="DC.title"
	content="DineroTaxi.com | La nueva forma de tomar un taxi!" />
<meta name="DC.creator" content="Carlos Matías Baglieri" />
<meta name="DC.description" content="La nueva forma de tomar un taxi" />
<meta name="DC.type" scheme="DCTERMS.DCMIType" content="Text" />
<meta name="DC.format" content="text/html; charset=UTF-8" />
<meta name="DC.identifier" scheme="DCTERMS.URI"
	content="https://www.dinerotaxi.com" />
<meta http-equiv="content-language" content="es" />
<meta name="Language" content="Spanish, Español" />
<meta name="Geography"
	content="capital Federal, Buenos Aires, Argentina" />
<meta name="distribution" content="Global" />
<meta name="robots" content="nofollow" />
<meta name="country" content="Argentina" />
<meta name="Classification" content="services" />
<meta name="generator" content="Bluefish 2.0.2" />
<meta name="Keywords" content="taxi|transporte|dinero|viajes" />
<meta name="copyright" content="https://www.dinerotaxi.com" />
<meta http-equiv="Expires" content="never" />
<meta name="Subject" content="DINERO TAXI" />
<meta name="layout" content="dinerotaxi" />
<script type="text/javascript"
	src="${resource(dir:'js',file:'funciones1.js')}"></script>
</head>
<body>

	<div class="mainContent">

		<div class="con">
			<div class="bOX1055 mt10">
				<div class="exclama"></div>
				<div class="mens_error">
					<p>
						Ha ocurrido un error , lo estaremos reportando <br /> <a href="#"
							title="Atencion al usuario(Acceso por teclado: u)" accesskey="r">Muchas
							Gracias por usar DineroTaxi.com</a>
					</p>
				</div>
			</div>


		</div>
		<div class="message" style="display: none">
			<strong>Error ${request.'javax.servlet.error.status_code'}:
			</strong>
			${request.'javax.servlet.error.message'.encodeAsHTML()}<br /> <strong>Servlet:</strong>
			${request.'javax.servlet.error.servlet_name'}<br /> <strong>URI:</strong>
			${request.'javax.servlet.error.request_uri'}<br />
			<g:if test="${exception}">
				<strong>Exception Message:</strong>
				${exception.message?.encodeAsHTML()}
				<br />
				<strong>Caused by:</strong>
				${exception.cause?.message?.encodeAsHTML()}
				<br />
				<strong>Class:</strong>
				${exception.className}
				<br />
				<strong>At Line:</strong> [${exception.lineNumber}] <br />
				<strong>Code Snippet:</strong>
				<br />
				<div class="snippet">
					<g:each var="cs" in="${exception.codeSnippet}">
						${cs?.encodeAsHTML()}<br />
					</g:each>
				</div>
			</g:if>
			<g:if test="${exception}">
				<h2>Stack Trace</h2>
				<div class="stack">
					<pre>
						<g:each in="${exception.stackTraceLines}">
							${it.encodeAsHTML()}<br />
						</g:each>
					</pre>
				</div>
			</g:if>

		</div>
	</div>
</body>
</html>
