<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon"
	href="${resource(dir:'img',file:'favicon.ico')}" type="image/x-icon" />

<link rel="stylesheet"
	href="${resource(dir:'css/mapsnw',file:'reset.css')}" />
<link rel="stylesheet"
	href="${resource(dir:'css/mapsnw',file:'text.css')}" />
<link rel="stylesheet"
	href="${resource(dir:'css/mapsnw',file:'960_24_col.css')}" />
<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.2.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/jquery-ui.min.js"></script>

<meta property="og:description" content="Es una aplicación que permite calcular el costo de un viaje en taxi en las principales ciudades de Argentina. Como opciones adicionales podrás visualizar caminos alternativos, consultar distancias recorridas e imprimir las rutas." />
<title>Taxista Virtual</title>

<link rel="stylesheet"
	href="${resource(dir:'css/mapsnw',file:'print.css')}" type="text/css"
	media="print">

<link rel="stylesheet"
	href="${resource(dir:'css/mapsnw',file:'tipTip.css')}" />

<script
	src="http://maps.google.com/maps/api/js?sensor=false&libraries=places"
	type="text/javascript"></script>
<script type="text/javascript"
	src="${resource(dir:'js/mapsnw',file:'jquery.vticker.js')}"></script>
<script type="text/javascript"
	src="${resource(dir:'js/mapsnw',file:'jsTaxi.js')}"></script>
<script type="text/javascript"
	src="${resource(dir:'js/mapsnw',file:'interfaz.js')}"></script>
<script type="text/javascript"
	src="${resource(dir:'js/mapsnw',file:'jquery.tipTip.js')}"></script>


<script type="text/javascript">
	var ciudadSeleccionada = 'BSAS_BuenosAires.php';

	$(document).ready(function() {

		$("#invertir-rutas").tipTip({
			defaultPosition : "top",
			delay : 50
		});
		$("#select-origen").tipTip({
			defaultPosition : "right",
			delay : 50
		});
		$("#select-destino").tipTip({
			defaultPosition : "right",
			delay : 50
		});

		$("#boton-tarifa-especial").tipTip({
			defaultPosition : "top",
			delay : 50
		});
		$("#boton-tarifa-normal").tipTip({
			defaultPosition : "top",
			delay : 50
		});
		$("input[name=input-origen]").tipTip({
			activation : "click",
			defaultPosition : "top",
			delay : 50
		});
		$("input[name=input-destino]").tipTip({
			activation : "click",
			defaultPosition : "top",
			delay : 50
		});

	});

	function precalculando() {

		//var x = $("div[class$='connect_widget_button_count_count']").html;
		//	window.alert(x);
		/*x.attr("src", "/images/mapsnw/mases.png')}");
		x.css("width","44px");
		x.css("height","78px");

		
		x = $("div[title$='Acerca la imagen']");
		x.css("width","44px");
		x.css("height","39px");
		
		x = $("div[title$='Aleja la imagen']");
		x.css("width","44px");
		x.css("height","39px");
		x.css("top","39px");
		 */
	};
</script>
<g:layoutHead />

</head>
<body style="width:100%;"  onload="precalculando();">





<script type="text/javascript">
 
$(document).ready(function() {  
 
    //select all the a tag with name equal to modal
    $('a[name=modal]').click(function(e) {
    	
    	
    	
    	var origen =  $("input[name=input-origen]").val();
    	var destino =  $("input[name=input-destino]").val();
    	
    	
    	
    	
    	url = origen+";"+destino;
    	
    	var ciudad = 'BSAS_BuenosAires.php'    		
    	$.post("http://www.taxistavirtual.com.ar/php/short_links.php",{texto:url,city:ciudad},function(data){   	
    		
    		$("#inputUrl").val(data);
    		
    		
    		var urlFacebook = "http://www.facebook.com/sharer.php?u="+data+"&src=sp";
    		 
    		
    		var onclick = "window.open(')}" +urlFacebook+" ','','height=600,width=600,resizable=no,scrollbars=yes,modal=yes,alwaysRaised=yes,menubar=no,toolbar=yes');"
    		
    		$("a[name=fb_share]").attr("onclick",onclick);
    		$("#twitter").attr("data-url",data);
    		$(".g-plusone").attr("data-href",data);
    		$("#script-compartir").load("includes/scriptsCompartir.html");
    	});	
    	
    
    	
    	
        //Cancel the link behavior
        e.preventDefault();
        //Get the A tag
        var id = $(this).attr('href');
     
        //Get the screen height and width
        var maskHeight = $(document).height();
        var maskWidth = $(window).width();
     
        //Set height and width to mask to fill up the whole screen
        $('#mask').css({'width':maskWidth,'height':maskHeight});
         
        //transition effect     
        $('#mask').fadeIn(1000);    
        $('#mask').fadeTo("slow",0.8);  
     
        //Get the window height and width
        var winH = $(window).height();
        var winW = $(window).width();
               
        //Set the popup window to center
        $(id).css('top',  winH/2-$(id).height()/2);
        $(id).css('left', winW/2-$(id).width()/2);
     
        //transition effect
        $(id).fadeIn(2000); 
     
    });
     
    //if close button is clicked
    $('.window .close').click(function (e) {
        //Cancel the link behavior
        e.preventDefault();
        $('#mask, .window').hide();
    });     
     
    //if mask is clicked
    $('#mask').click(function () {
        $(this).hide();
        $('.window').hide();
    });         
     
});
 
</script>


<div id="script-compartir"></div>


<!-- #dialog is the id of a DIV defined in the code below -->



 
<div id="boxes">
 
     
    <!-- #customize your modal window here -->
 
    <div id="dialog" class="window">
    	
    	<div >
	    	<div style="margin-left: auto;margin-right: auto;width: 50%;"><img src="${resource(dir:'images/mapsnw' ,file:'comparti-recorrido.png')}" /></div>
	    	<p>
	    		<label style="font-family: Arial;font-size: 14px">Link:</label><br />
	    		<input style="width:510px; height: 30px" type="text" id="inputUrl" value="" />
	    	</p>
    	</div>
         
      <!--   <hr />-->
         <div style="width:100%">
         	
	         	<div>
		         	<!--<div id="facebook" style="top:-3px;" class="fb-like" data-href="http://www.taxistavirtual.com.ar/ciudades" data-send="false" data-layout="button_count" data-width="50" data-show-faces="false"></div><br />-->
                  

                    <div style="margin-bottom:5px;margin-left:auto;margin-right:auto;width: 148px;">
		         	
		         	<a name="fb_share"  type="button"  href="#" onclick="" ><img src="${resource(dir:'images/mapsnw',file:'facebook-compartir.jpg')}" /> </a>
                    
                                     
                    </div>
                  	
					
		         	<div style="margin-bottom:5px;margin-left:auto;margin-right:auto;width:70px;">
		         	<a id="twitter" href="https://twitter.com/share" class="twitter-share-button" data-url="http://www.taxistavirtual.com.ar/" data-lang="es" data-count="none"  >Twittear</a>
                    </div>
                 
		
		         	
		         	<div style="margin-bottom:5px;width:40px;overflow:hidden;margin-left:auto;margin-right:auto;">
			         	<div class="g-plusone" data-annotation="inline" data-href="http://www.taxistavirtual.com.ar/">
                        </div>
                    </div>
	        	</div> 	
			         	
         </div>
         <hr style="margin-bottom: 10px;margin-top: 10px;" />
         
        <!-- close button is defined as close class -->
        <div style="margin-left: auto;margin-right: auto;width:101px;">
        	<a href="#" class="close"><img src="${resource(dir:'images/mapsnw',file:'boton-cerrar-popup.png')}" /></a>
 		</div>
    </div>
 
     
    <!-- Do not remove div#mask, because you'll need it to fill the whole screen --> 
    <div id="mask"></div>
</div><div id="fb-root"></div>
<script type="text/javascript">
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/es_LA/all.js#xfbml=1&appId=109897279105809";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
/*
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/es_LA/all.js#xfbml=1&appId=283176665099348";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/es_ES/all.js#xfbml=1&appId=283176665099348";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
*/
</script>




<div class="contenido_calcular" >

	<div class="container_24">
    <form id="form-calcular">
    	<div class="grid_24" id="contenido-calcular">
        		
        
        
	         <div id="input-origen" class="alpha grid_6" action="#" >	         	
	         	<div id="print-origen">Origen:</div>
                <input type="text" title="No se Admiten Intersecciones" name="input-origen" class="inputs-ruta" value="Origen" maxlength="50"
                	onclick='if($(this).val() == "Origen"){$(this).val("").css("color","#3E3E3E")};$("#cartel-real").css("background-position","0px 0px");' 
                    onblur='if($(this).val()==""){$(this).val("Origen")}'
                    tabindex="1"/>
	         	<select id="select-origen" class="select-poi" title="Seleccione Punto de Interés">
	         		<option value=''>Seleccione...</option><option value='Aeroparque Jorge Newbery'>Aeroparque Jorge Newbery</option><option value='Autopista Tte. Gral. Ricchieri Km 33,5'>Aeropuerto Internacional Ezeiza</option><option value='Balcarce 50'>Casa Rosada</option><option value='Av. Juan B. Justo 9200'>Club Atlético Vélez Sarsfield</option><option value='Club Ferrocarril Oeste - Federico García Lorca'>Club Ferrocarril Oeste</option><option value='Brandsen 805'>Estadio Boca Juniors</option><option value='Estadio Monumental de Núñez'>Estadio River Plate</option><option value=' Av. Madero 420'>Luna Park</option><option value='Carlos Pellegrini 425'>Obelisco</option><option value='Cerrito 628'>Teatro Colón</option><option value='Av Dr. José María Ramos Mejía 1502-1600'>Terminal de Ómnibus Retiro</option>	
	         	</select>
	         	
	         	
	         	<div class="clear"></div>
	         	<div id="input-mapa-origen" class="input-mapa"> Seleccionar desde el Mapa</div>
	         </div>
	         
	         <div class="grid_1 alpha" id="invertir"> 
	         	<button  title="Invertir Rutas" id="invertir-rutas"></button>
	         </div>
	         
	         <div id="input-destino" class="grid_6" >
	         	<span id="print-destino">Destino:</span>
	         	<input type="text" class="inputs-ruta" title="No se Admiten Intersecciones" name="input-destino" value="Destino" 
                	onclick='if($(this).val() == "Destino"){$(this).val("").css("color","#3E3E3E")};$("#cartel-real").css("background-position","0px 0px");' 
                    onblur='if($(this).val()==""){$(this).val("Destino")}'
                	tabindex="2"/>
	         	<select id="select-destino" class="select-poi" title="Seleccione Punto de Interés">
	         		<option value=''>Seleccione...</option><option value='Aeroparque Jorge Newbery'>Aeroparque Jorge Newbery</option><option value='Autopista Tte. Gral. Ricchieri Km 33,5'>Aeropuerto Internacional Ezeiza</option><option value='Balcarce 50'>Casa Rosada</option><option value='Av. Juan B. Justo 9200'>Club Atlético Vélez Sarsfield</option><option value='Club Ferrocarril Oeste - Federico García Lorca'>Club Ferrocarril Oeste</option><option value='Brandsen 805'>Estadio Boca Juniors</option><option value='Estadio Monumental de Núñez'>Estadio River Plate</option><option value=' Av. Madero 420'>Luna Park</option><option value='Carlos Pellegrini 425'>Obelisco</option><option value='Cerrito 628'>Teatro Colón</option><option value='Av Dr. José María Ramos Mejía 1502-1600'>Terminal de Ómnibus Retiro</option>	         	</select>
                
      
                
	         	<div class="clear"></div>
                
                
	         	<div id="input-mapa-destino" class="input-mapa"> Seleccionar desde el Mapa</div>
	         </div>
	         
	         <div class="prefix_1 grid_6 alpha omega">
	         	<button id="boton-calcular" tabindex="3" value="submit" ></button>
	         </div>
             
	      	
	         <div id="contenedor-cartel" class="prefix_1 grid_3 omega">
	         	<div id="cartel-real">
                </div>
	         </div>
	         <div class="clear"></div>
             
        </div>
	
        <div class="clear"></div>
     	<div id="print-datosCalculo">
        	<div style="font-weight:bold;">Precio:</div> <div id="print-precio">$354.00</div><br />
            <div style="font-weight:bold;">Duración del viaje:</div> <div id="print-tiempo">23 minutos</div><br />
            <div style="font-weight:bold;">Distancia recorrida:</div> <div id="print-distancia">24 km.</div>
        </div>
        
        <div id="tarifas-back" style="width:100%" >
	        <div id="tarifas" class="grid_24">
				
<div id="tarifa-normal" class="prefix_1 grid_11 alpha omega" style="width:435px;" >
	<img id="boton-tarifa-normal" title="Click para Cambiar la Tarifa" class="boton"src="${resource(dir:'images/mapsnw',file:'boton-tarifa-normal.jpg')}"  alt="boton-tarifa-normal"/>
    <div id="print-tarifa-normal">Tarifa Normal</div>
	<input type="checkbox" name="tarifa-normal" id="cb_normal"  style ="display:none"/>
	<!--<div class="clear"></div>-->
	<div class="tarifa-contenido">
		<div class="alto_10">
			<div class="prefix_1 grid_1"><img src="${resource(dir:'images/mapsnw',file:'bandera-icono.png')}" alt= "boton-over"/></div>
			<div class="grid_2 precio-tarifa">$9.10</div>
           	<div class="grid_4 texto-tarifa">Bajada de Bandera</div>
			<div class="clear"></div>
		</div>
					
		<div class="alto_5">
			<div class="prefix_1 grid_1"><img src="${resource(dir:'images/mapsnw',file:'ruta-icono.png')}"alt= "boton-over"/></div>
			<div class="grid_2 precio-tarifa">$0.91</div>
			<div class="grid_4 texto-tarifa">Por cada 200m</div>
			<div class="clear"></div>
		</div>
		
   		<div class="alto_5">						
			<div class="prefix_1 grid_1"><img src="${resource(dir:'images/mapsnw',file:'reloj-icono.png')}" alt= "boton-over"/></div>
			<div class="grid_2 precio-tarifa">$0.91</div>
			<div class="grid_6 texto-tarifa">Por minuto de espera</div>
			<div class="clear"></div>
		</div>
	</div>
</div>
			
<div id="tarifa-especial" class="grid_11 alpha omega suffix_1" style="width:435px;">
	<img id="boton-tarifa-especial" title="Click para Cambiar la Tarifa" class="boton" src="${resource(dir:'images/mapsnw',file:'boton-tarifa-especial.jpg')}"  alt="boton-tarifa-especial" style="padding-left:5px;"/>
    <div id="print-tarifa-especial">Tarifa Especial</div>
	<input type="checkbox"  name="tarifa-especial" id="cb_especial"  style ="display:none"/>
	<!--<div class="clear"></div>-->			
	<div class="tarifa-contenido">
		<div class="alto_10">
			<div class="prefix_1 grid_1"><img src="${resource(dir:'images/mapsnw',file:'bandera-icono.png')}" alt="boton-over" /></div>
			<div class="grid_2 precio-tarifa">$10.90</div>
			<div class="grid_4 texto-tarifa">Bajada de Bandera</div>
			<div class="clear"></div>
		</div>
					
		<div class="alto_5">
			<div class="prefix_1 grid_1"><img src="${resource(dir:'images/mapsnw',file:'ruta-icono.png')}" alt="boton-over" /></div>
			<div class="grid_2 precio-tarifa">$1.09</div>
			<div class="grid_4 texto-tarifa">Por cada 200m</div>
			<div class="clear"></div>
		</div>
				
           <div class="alto_5">						
			<div class="prefix_1 grid_1"><img src="${resource(dir:'images/mapsnw',file:'reloj-icono.png')}" alt="boton-over" /></div>
			<div class="grid_2 precio-tarifa">$1.09</div>
			<div class="grid_6 texto-tarifa">Por minuto</div>
			<div class="clear"></div>
		</div>
	</div>			
</div>
                
<div class="clear"></div>
				
    
                
<div id="adicionales-tarifa" class="alpha prefix_1 grid_17" style=" margin-top: 10px;">					
	<div class="adicional-tarifa grid_4" style="border-right:1 px solid #a9a9a9;">
       	<input type="checkbox" name="check-autopista" class="check-adicional styled"/> Evitar Autopistas 
    </div> 
		
	        
    	<div class="adicional-tarifa grid_7">
       	<input type="checkbox" name="adicional1" class="styled check-adicional"/>Radiollamada    </div> 
            
	      
        

</div>
        
        
        
        
        
        
        
        
        
        
        
        
        
<script>$(document).ready(function () {  $('#boton-tarifa-normal').click();   });</script>			
			</div>
		</div>
            </form>
    </div>
</div><!-- end contenido calcular -->

<div id="content-ciudades" style="width:100%;max-width:100%;">
	<div class="container_24" id="cont_tax">
   
    	<div id="map_canvas" class="grid_24">
        
    	</div>
        

<div id="taximetro" style="z-index:90;">
		<div style="width: 50%;text-align: center;position: absolute;top: 16px;left: 136px;">
        	Precio del Viaje
        </div>
            <div style="position:absolute;top:59px;left:82%;">
           		<a href="#" id="taximetro-mas-rapido" style="display:block;" title="Viaje Más Rápido"></a>
            </div>
            <div style="position:absolute;top:104px;left:87%;">
           		<a href="#" id="taximetro-mas-corto" style="display:block;" class="activado" title="Viaje Más Corto"></a>
            </div>
            <div style="position:absolute;top:149px;left:82%;">
           		<a href="#" id="taximetro-otro"style="display:block;" title="Otro Viaje"></a>
            </div>
            
			<div style="position:absolute;top:192px;right:39%;">
           		<a href="#" id="taximetro-print" style="display:block;" title="Imprimir Viaje"></a>
            </div>
            <div style="position:absolute;top:192px;left:64%;">
           		<a href="#dialog" id="taximetro-compartir" name="modal" style="display:block" title="Compartir Viaje" ></a>
            </div>
           
       
        
        <div id="recuadro-precio">
	        <div class="izquierda"> 
            </div>
	        <div class="centro" id="tarifa">
            	<img src="${resource(dir:'images/mapsnw',file:'taximetro/signopeso.png')}" alt="signo peso" style="float:left;" /> 

          	    <div class="izquierda comunes"> 
	            </div>
		        <div class="centro comunes">
	            	&nbsp;&nbsp;&nbsp;<span id="taximetro-precio1" style="font-size:78px;font-weight:bold;line-height:80px;">000</span>&nbsp;&nbsp;&nbsp;&nbsp;
                    <span id="taximetro-precio2" style="font-size:34px;font-weight:bold;text-decoration:underline;vertical-align:top;line-height:52px;">00</span>&nbsp;&nbsp;&nbsp;
	            </div>
				<div class="derecha comunes">
	            </div>
            </div>
			<div class="derecha">
            </div>
        </div> <!-- fin recuadro-precio -->
             
       
        
	       <div style="height: 40px;top: 147px;right: 39%;position: absolute;width: 120px;">
            	<table style="border-spacing: 0px;float:right;">
                <tr><td style="text-align:center;padding:0;">Metros</td></tr>
                <tr><td style="text-align:center;padding:0;"> 
                <div class="mas-info-right mas-info-comun right"></div>   
                <div id="taximetro-distancia"class="mas-info-centro mas-info-comun right">00000</div>
                <div class="mas-info-left mas-info-comun right"></div></td></tr></table>
			</div>
			<div style="height: 40px;top: 147px;left: 63%;position: absolute;width: 70px;">
		        <table style="border-spacing: 0px;float:left;">
                <tr><td style="text-align:center;padding:0;">Minutos</td></tr>
                <tr><td style="text-align:center;padding:0;"> <div class="mas-info-right mas-info-comun right"></div>   
                <div id="taximetro-duracion" class="mas-info-centro mas-info-comun right">00:00</div>
                <div class="mas-info-left mas-info-comun right"></div></td></tr></table>
            </div>
         
        
        
     
	</div>
    	<div class="clear"></div>
    </div>
    
    <div class="clear"></div>
</div>


<div class="clear"></div>


<style>
.compartio{
	margin-top: 35px;
	margin-left: 50px;
	float: left;
	position: relative;
}	
	
</style>
	
	


<div id="ver-tarifas"> </div>
<div id="directionsPanel" style="display:none"> </div>



	<g:layoutBody />

</body>
</html>