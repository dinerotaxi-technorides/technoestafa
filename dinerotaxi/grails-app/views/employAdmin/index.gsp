<%@ page import="ar.com.goliath.TypeEmployer"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dineroTaxiCompanyL" />
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
<link rel="apple-touch-icon-precomposed"
	href="${resource(dir:'images',file:'favicon.ico')}">

<%--	--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css/dinerotaxi',file:'modal.css')}" />--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />--%>
<%--   --%>


<!--Google Analytics-->
<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>

<!-- This JavaScript snippet activates those tabs -->

<jqui:resources />
<jqgrid:resources />
<script type="text/javascript">
	        $(document).ready(function() {
                         <jqgrid:grid
                                id="contact"
                                    url="'${createLink(action:'jq_customer_list',controller:'employAdmin')}'"
                                        editurl="'${createLink(action:'jq_edit_customer',controller:'employAdmin')}'"
                                colNames="'UserName','Password','Nombre','Apellido','Telefono','Tipo','Agree','Habilitado','Auto Asignado','id'"
                                	 colModel="{name:'username', editable:true,editrules:{required:true,custom:true, custom_func:isAlphabet}},
                                	 			{name:'password', edittype:'password',editable:true,editrules:{required:true}, viewable: false},
                                               {name:'firstName',editable:true,editrules:{required:true}},
	                           					{name:'lastName', editable:true,editrules:{required:true}},
	                           			        {name:'phone', editable:true, editrules:{required:true} ,editoptions: {size:10, manlength: 3}},
	                           			     {name:'typeEmploy',index:'typeEmploy', width:200, sortable:false,
		                           			         editable:true, edittype:'select'  , editrules:{required:true},
	                           			     editoptions:{dataUrl:'${createLink(action:'jq_get_type',controller:'employAdmin')}'}
			                           			    },
	                           			        {name:'agree', editable:true,  editrules:{required:true} ,edittype:'checkbox' },
	                           			        {name:'enabled',   editable:true,  editrules:{required:true},edittype:'checkbox' },
	                           			     {name:'patente',index:'patente', width:200, sortable:false,
		                           			         editable:true, edittype:'select'  , editrules:{required:false},
	                           			     editoptions:{dataUrl:'${createLink(action:'jq_get_patente',controller:'employAdmin')}'}
			                           			    },
	                                            {name:'id',hidden:true}"
                                sortname="'firstName'"
                                caption="'Usuarios'"
                                height="300"
                                autowidth="true"
                                scrollOffset="0"
                                viewrecords="true"
                                showPager="true"
                                datatype="'json'">
                                <jqgrid:navigation id="contact" add="true" edit="true"  search="true" refresh="true" />
                                <jqgrid:resize id="contact" resizeOffset="-2" />
                         </jqgrid:grid>
               });

	        function isMarca(value, colname) {
	        	var alphaExp =  /^[a-zA-Z]+$/;
	        	if(value.match(alphaExp) && value.length >3){
		        	   return [true,""];
	        	}else{
		        	   return [false,"la marca tiene que tener por lo menos 5 letras "+colname];
	        	}
        	}
	        function isModelo(value, colname) {
	        	var alphaExp =  /^[a-zA-Z]+$/;
	        	if(value.match(alphaExp) && value.length >3){
		        	   return [true,""];
	        	}else{
		        	   return [false,"El modelo tiene que tener por lo menos 5 letras "+colname];
	        	}
        	}
	        function isPatente(value, colname) {
	        	var alphaExp = /^[A-Z]{3}\d{3}$/;
	        	if(value.match(alphaExp)){
		        	   return [true,""];
	        	}else{
		        	   return [false,"Debe ser una patente valida ej : ASD123 "+colname];
	        	}
        	}
	        function isAlphabet(value, colname) {
	        	var alphaExp = /^[0-9a-zA-Z]+$/;
	        	if(value.match(alphaExp)){
		        	   return [true,""];
	        	}else{
		        	   return [false,"Solo se puede escribir Letras o numeros en la columna "+colname];
	        	}
        	}
            function afterSubmitEvent(response, postdata) {
                var success = true;
                console.log ('here')
                var json = eval('(' + response.responseText + ')');
                var message = json.message;

                if(json.state == 'FAIL') {
                    success = false;
                } else {
               	  $("#contact").trigger("reloadGrid");
                  $('#message').html(message);
                  $('#message').show().fadeOut(10000);  // 10 second fade
                }

                var new_id = json.id
                return [success,message,new_id];
            }
	     
	                    
        </script>
</head>
<body>

	<div class="mainContent_">

		<div class="con">
			<g:render template="/tripPanel/sidebar" model="['action':'employ']" />
			<!-- DETAIL -->



			<div class="boxPanelTaxista">


				<h1>Empleados Taxistas</h1>

				<div id='message' class="message" style="display: none;"></div>

				<jqgrid:wrapper id="contact" />

				<div class="clearFix">
					<br />
				</div>




			</div>

		</div>
	</div>
	<!-- END MAIN -->
</body>
</html>
