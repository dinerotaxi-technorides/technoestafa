<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dinerotaxi" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- META for Google Webmasters -->
<meta name="google-site-verification"
	content="NBzIvboQVvrq0MoRtNg_bbN7g6Qf-zWkn6wDGarb0lk" />
<meta name="author" content="DineroTaxi" />
<meta name="version" content="1.0" />
<meta name="description"
	content="DineroTaxi es un servicio para pedir taxis de forma automatica desde el movil. Con DineroTaxi tienes tu taxi en tu movil">
<meta name="keywords"
	content="taxi quiero pedir solicitar Madrid Barcelona Sevilla Valencia automatico aqui ahora android iphone blackberry">
<meta name="copyright"
	content="Copyright (c) DineroTaxi.com Todos los derechos reservados." />
<!-- METAS for Facebook -->
<meta property="og:title" content="DineroTaxi" />
<meta property="og:type" content="company" />
<meta property="og:url" content="https://www.dinerotaxi.com" />
<meta property="og:image"
	content="${resource(dir:'img',file:'favicon.ico')}" />
<link rel="shortcut icon"
	href="${resource(dir:'img',file:'favicon.ico')}" type="image/x-icon" />
<link rel="apple-touch-icon-precomposed" href="${resource(dir:'images',file:'favicon.ico')}">
	
<%--	--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css/dinerotaxi',file:'modal.css')}" />--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />--%>
<%--   --%>

<link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />
    <g:javascript library="jquery" plugin="jquery"/>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery-ui-1.8.16.custom.min.js')}"></script>

<!--Google Analytics-->
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
	
    <script src="${resource(dir:'js/imported',file:'jquery.tools.min.js')}"></script>
    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.simplemodal.1.4.2.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.validate.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'json2.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.tokeninput.js')}"></script>
    <jq:plugin name="fileuploader"/>
    <jq:plugin name="editable"/>    
    <jq:plugin name="places"/>    
    <jq:plugin name="multiselect"/>
    <jq:plugin name="multiplace"/>
    <jq:plugin name="newscomment"/>
    <jq:plugin name="follow"/>
<!-- This JavaScript snippet activates those tabs -->
<script> 
        // perform JavaScript after the document is scriptable.
      $(function() {
    	  $('#placeinput1').multiplace({tokenLimit: 1});


          
        function customCallback (params) {
            say('custom');
            $('#placeInput1').geoplaces({
              placePane: '#placePane',
              placeTemplate: 'div.template.place',
              map: '#map_canvas',
              get: '/places/get',
              add: '/place/saveAjax',
              del: '/place/deleteAjax',
              delay: 1000
            });
        }
        
        function onShow (dialog) {
            $(dialog.wrap).find("form").validate({errorElement:'p'});
            $('#placeInput1').geoplaces({
              placePane: '#placePane',
              placeTemplate: 'div.template.place',
              map: '.google-map',
              get: '/places/get',
              add: '/place/saveAjax',
              del: '/place/deleteAjax',
              delay: 1000
            });
        }
        
        function onShowMessage (dialog) {
            $(dialog.wrap).find("form").validate({errorElement:'p'});
            
            $('#to').tokenInput(
              this.attr('search'), {
              theme: "tbo",
              hintText: "",
              prePopulate: eval(this.attr('prepopulate'))
            });      
        }
                      
        function onShowBasicdata1 (a) {
            alert("here");
        }    
        function onSubmitProduct (data) {
            // simulates similar behavior as an HTTP redirect
            window.location.replace(data);
        }
      });
    </script>
</head>
<body id="wrapper">

 <form method='POST' class="simplemodal-submit" autocomplete='off' accept-charset="utf-8">
	<div class="mainContent">

		<div class="con">


			<g:render template="buttons" model="['action':'pedir']" />

			<div class="clearFix">
				<br />
			</div>

			<div class="bOX955">


				<h1>Realiza tu pedido</h1>
 				<div class="paso1"></div>
            
          		<div class="clearFix"><br /></div>
          		
				<div class="bigMap" >

			
		          <div class="field-group">
		            <div id="map_canvas" class="google-map" style="width:671px; height:478px"></div>
		          </div> 
				</div>

				<div class="boxForm1">


						<h3>Inicio del viaje</h3>

						<span class="ml5">Dirección</span>


						<div class=" clearFix mt5" /></div>

			
					
					<div class="field-input">
					  <div class="field-group deleteable">
						  <input type="text" id="placeinput1" pre="" map="#map_canvas" placeholder="Ej:  Congreso 3800,Capital Federal"/>
					  </div>             
					</div>
				</div>

						<div class=" clearFix mt5" /></div>

						<div class="blockPD">

							<span class="ml5">Piso</span>

						</div>

						<div class="blockPD">

							<span class="ml5">Depto </span>


						</div>

						<div class=" clearFix mt5" /></div>

						<input id="piso" type="text" name="piso" placeholder=""
							class="inputShort" /> <input id="departamento" type="text"
							name="departamento" placeholder="" class="ml5 inputShort" />

						<div class=" clearFix mt5" /></div>

						<span class="ml5">Comentarios</span>

						<div class=" clearFix mt5" /></div>

						<textarea id="comentarios" type="text" name="comentarios"
							placeholder="ingresar comentario..." cols="" rows=""></textarea>


						<div class=" clearFix mt5" /></div>

						--------------------------------

						<div class=" clearFix mt5" /></div>

						<h3>Destino del viaje</h3>

						<span class="ml5">Dirección</span>

						<div class=" clearFix mt5" /></div>


				<div class="field">
					
					<div class="field-input">
					  <div class="field-group deleteable">
						  <input type="text" id="placeinput1" pre="" map="#map_canvas" placeholder="Ej:  Congreso 3800,Capital Federal"/>
					  </div>             
					</div>
				</div>
						<div class=" clearFix mt5" /></div>

						<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="pedirStep2" />" class="pedirTaxi_"></a>



				</div>

			</div>

		</div>

	</div>

		</form>
</body>
</html>
