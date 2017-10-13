<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dineroTaxiTaxistaL" />
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


<!--SCRIPT VERSION EZE-->
<script type='text/javascript' src="${resource(dir:'js',file:'jquery.tools.min.js')}"></script>
<script type='text/javascript' src='${resource(dir:'js',file:'jquery.validate.js')}'></script>
<!--Google Analytics-->
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
	
    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.simplemodal.1.4.2.min.js')}"></script>
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

$(document).ready(function() {

var triggers = $(".agregar").overlay({

	mask: {
		color: '#333',
		loadSpeed: 200,
		opacity: 0.9
	},

	closeOnClick:true
        
        
});

//SUPRIMIR FAVORITOS
var triggers = $(".suprimir").overlay({
	top:'30%',
	mask: {
		color: '#333',
		loadSpeed: 200,
		opacity: 0.9,
	
	},

	closeOnClick:true       
     
});
//SUPRIMIR FAVORITOS
var triggers = $(".suprimirTodo").overlay({
	top:'30%',
	mask: {
		color: '#333',
		loadSpeed: 200,
		opacity: 0.9,
	
	},

	closeOnClick:true       
     
});

var buttons = $("#modal_favoritos a").click(function(e) {	
	// get user input
	var yes = buttons.index(this) === 0;
});

var buttons = $(".suprimirTodos").click(function(e) {	
	// get user input
	var yes = buttons.index(this) === 0;
});

var buttons = $(".suprimir").click(function(e) {	
	// get user input
	$('#favorite').val($(this).attr('id'));
});


//Valido formulario
            $("#formModal").validate({
		
			rules: {
				
                                name: "required",
                                placeinput1: "required"
				
			},
			messages: {
			
                                name:"Por Favor Ingrese el nombre del favorito",
                                placeinput1: "Por favor ingrese una direccion"
				
			},errorElement: "div"
				
		});  


$("#modal_favoritos form").submit(function(e) {

            
	// close the overlay
	triggers.eq(1).overlay().close();

	// get user input
	var input = $("input", this).val();
	// do something with the answer
	triggers.eq(1).html(input);

	// do not submit the form
	return true;
});


$("#modal_elim_fav form").submit(function(e) {

            
	// close the overlay
	triggers.eq(1).overlay().close();

	// get user input
	var input = $("input", this).val();

	// do something with the answer
	triggers.eq(1).html(input);

	// do not submit the form
	return true;
});
$("#modal_elim_all_fav form").submit(function(e) {

    
	// close the overlay
	triggers.eq(1).overlay().close();

	// get user input
	var input = $("input", this).val();

	// do something with the answer
	triggers.eq(1).html(input);

	// do not submit the form
	return true;
});


});
</script>


<!--FIN SCRIPT VERSION EZE-->


<script>
  
	$(function() {
		$( "#dialog:ui-dialog" ).dialog( "destroy" );
		$('#placeinput1').multiplace({tokenLimit: 1});
		
	});
	</script>

<script>
 
    function setupLabel() {
        if ($('.label_checkHome fixIe input').length) {
            $('.label_checkHome fixIe').each(function(){ 
                $(this).removeClass('c_on');
            });
            $('.label_checkHome fixIe input:checked').each(function(){ 
                $(this).parent('label').addClass('c_on');
            });                
        };
        if ($('.label_radio input').length) {
            $('.label_radio').each(function(){ 
                $(this).removeClass('r_on');
            });
            $('.label_radio input:checked').each(function(){ 
                $(this).parent('label').addClass('r_on');
            });
        };
    };
    $(document).ready(function(){
        $('body').addClass('has-js');
        $('.label_checkHome fixIe, .label_radio').click(function(){
            setupLabel();
        });
        setupLabel(); 
    });
</script>	
</head>
<body id="wrapper">

<div class="mainContent_">

	<div class="con">
    	
        <div class="content mt10">        	
            
        	<!-- TABS -->
        
            
			<g:render template="buttons" model="['action':'favorites']" />
             <div class="boxPanelTaxista">
            
            	<h1>Mis direcciones frecuentes</h1>
                
               	<div role="button" class="itemS mt10 ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="create-fav">
                    <span class="ui-button-text">
                       <a href="#new" class="agregar" rel="#modal_favoritos" ></a>
                    </span>
                </div>
                   <g:if test="${operationInstanceList.size()!=0 }">
                  	<div class="itemMBS mt10 ">
                  	  <span class="ui-button-text">
                       <a href="#dialog" class="suprimirTodo" rel="#modal_elim_all_fav" ></a>
                    </span>
                   </div>    
                 </g:if>
                 
                <div class="clearFix"></div>
	           <div class="bgHeadList_">
	                <div class="itemM">Nombre</div>
	                <div class="itemM">Direccion</div>
	                <div class="itemXSS">Piso</div>
	                <div class="itemSS">Depto</div>
	                <div class="itemM">Email</div>
	                <div class="itemS">Teléfono</div>
	                <div class="itemS"><span class="ml20">Administrar</span></div>
	            </div>
                
                <div id="users">
                  <g:if test="${operationInstanceList.size()!=0 }">
	                <g:each in="${operationInstanceList}" status="i" var="operationInstance">
		                <div class="itemList_">
		                	<div class="itemM">${operationInstance?.name }</div>
		                    <div class="itemM">${operationInstance?.placeFrom?.street }&nbsp;${operationInstance?.placeFrom?.streetNumber }</div>
		                  	<g:if test="${operationInstance?.placeFromPso}">
		                    	<div class="itemSS">${operationInstance?.placeFromPso}</div>
		                    </g:if>
		                    <g:else >
		                   		<div class="itemSS">--</div>
		                    </g:else>
		                    <g:if test="${operationInstance?.placeFromDto}">
		                    	<div class="itemSS">${operationInstance?.placeFromDto}</div>
		                    </g:if>
		                    <g:else >
		                   		<div class="itemSS">--</div>
		                    </g:else>
		                    <div class="itemSS"><a href="#dialog" class="suprimir" rel="#modal_elim_fav" id="${operationInstance?.id }"></a></div>
		                </div>
                	</g:each>
	                <div class="paged">
						<g:paginate total="${operationInstanceTotal}" />
					</div>
            	</g:if>
            	<g:else>
            	 		<div class="itemList_">
		                	<div class="itemXL">Por favor Agregue sus Direcciones a favoritos</div>
		                </div>
            	</g:else>
               	</div>
            </div>
            
            <div class="clearFix"><br /></div>
            
            
         </div>   
        
          

</div>
<!-- END MAIN -->

<!-- MODAL ELIMINAR FAVORITO-->
<div id="boxes">
    <div id="modal_elim_fav" class="window2">
        <form id="frm_modal_elim_fav" name="frm_modal_elim_fav" method="post" action="deleteFavorite">
        	
            <div class="blockInput_" style="height: 55px;"> 
                <label for="supr_favorito"><strong>¿Estas seguro de eliminar el registro seleccionado?</strong></label>
                <div class="btns_favoritos_elim">
	           <button type="button" class="no_fav_elim close"></button>
                   <input id="supr_favorito" name="supr_favorito" class="si_fav_elim" value="" type="submit" />
                   <input style="display:none;" id="favorite" name="favorite" value="" type="text"> 
	         </div>
            </div>
        </form>
	</div>
    
   
    
    <div id="mask"></div>
</div>


<!--FIN MODAL -->
<!-- MODAL ELIMINAR TODOS FAVORITO-->
<div id="boxes">
    <div id="modal_elim_all_fav" class="window2">
        <form id="frm_modal_elim_all_fav" name="frm_modal_elim_all_fav" method="post" action="deleteAllFavorites">
        	
            <div class="blockInput_" style="height: 55px;"> 
                <label for="supr_favorito"><strong>¿Estas seguro de eliminar todos los favoritos?</strong></label>
                <div class="btns_favoritos_elim">
	           <button type="button" class="no_fav_elim close"></button>
                   <input id="supr_favorito" name="supr_favorito" class="si_fav_elim" value="" type="submit" />
	         </div>
            </div>
        </form>
	</div>
    
   
    
    <div id="mask"></div>
</div>


<!--FIN MODAL -->


                <div class="modal_eze" id="modal_favoritos">
        	
                <g:form action="newFavorites" id="formModal" name ="formModal">
            
         		<div class="map">

			
		          <div class="field-group">
		            <div id="map_canvas" class="google-ma1p" style="width: 300px; height: 150px; position: relative; background-color: rgb(229, 227, 223); overflow: hidden;">
                                 
				</div></div></div>
            <div class="for">
                   
                   <!--DETALLE-->
                   <div class="blockInput_" style="height: 55px;"> 
                       <label class="label_modal" for="detalle">Detalle*</label>
                       <div class="encierra_input_modal">
	                   	<input id="name" name="name" placeholder="Casa" type="text"  />
	                   	</div>
                   	</div>                     
            
                
                <div class=" clearFix"></div>
                    
                
                <!--DIRECCION-->
                <div class="blockInput_"> 
	             <label class="label_modal" for="placeinput1">Dirección*</label>
	                <div class="encierra_input_modal">
	                   		<div class="field-input">
				 <div class="field-group updateable">
				<input aria-haspopup="true" aria-autocomplete="list" role="textbox" 
					  			autocomplete="off" class="ui-autocomplete-input" id="placeinput1" name="placeinput1" pre="" map="#map_canvas" 
					  			placeholder="Ej:  Congreso 3800,Capital Federal" type="text" />
				 				 </div>             
							</div>
	                   	</div>
                </div> 
                   	
                   	<div class=" clearFix"></div>
                   	
              
                <!--PISO-->
                <div class="blockInput_"> 
                <div class="blockPD">
            		<label class="label_modal" for="piso">Piso</label>
                        <div class="encierra_input_modal">
                        <input id="piso" name="piso" placeholder="Ej:1" class="inputShort" type="text" />                           </div>
                 </div>
                 
                 <div class="blockPD">
            
                    <label class="label_modal" for="departamento">Depto</label>
                    <div class="encierra_input_modal">
                    <input id="departamento" name="departamento" placeholder="Ej:B" class="ml5 inputShort" type="text" />
                    </div>
                </div>
                </div>
            </div>
            <div class=" clearFix"><br /></div>
            <div class="btns_favoritos">
                <!-- <a href="#cancelar" id="cancelar" name="cancelar" class="cancelar_fav close">Cancelar</a>-->
                <button type="button" class="cancelar_fav close"></button>
                <input id="newFavorites" name="newFavorites" class="confirmar_fav" value="" type="submit" />
                
               
            </div>
            
            
            </g:form >
        </div>        


<!--FIN MODAL -->
</body>
</html>
