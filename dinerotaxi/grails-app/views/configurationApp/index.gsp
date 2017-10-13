<%@ page import="ar.com.goliath.TypeEmployer"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dineroTaxiAdminL" />
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
                         id="configNotif"
                             url="'${createLink(action:'jq_configuration_app_list',controller:'configurationApp')}'"
                                 editurl="'${createLink(action:'jq_configuration_app_edit',controller:'configurationApp')}'"
                         colNames="'app','mailkey','mailSecret','mailFrom','androidAccountType','androidEmail','androidPass','androidToken'
                        	 ,'appleIp','applePort','appleCertificatePath','applePassword','androidUrl','iosUrl','windowsPhoneUrl','bb10Url','intervalPoolingTrip','intervalPoolingTripInTransaction'
                        	 ,'timeDelayTrip','distanceSearchTrip','driverSearchTrip','percentageSearchRatio','isEnable','digitalRadio',
                        	 'hasRequiredZone','hasZoneActive','costRute','ctRuteKm','ctRuteKmMin','zoho','mobilePayment','id'"
                         	 colModel="{name:'app', editable:true,editrules:{required:true}},
			              	 			{name:'mailkey', editable:true,editrules:{required:true}},
			             	 			{name:'mailSecret', editable:true,editrules:{required:true}},
			             	 			{name:'mailFrom', editable:true,editrules:{required:true}},
			             	 			{name:'androidAccountType', editable:true,editrules:{required:true}},
			             	 			{name:'androidEmail', editable:true,editrules:{required:true}},
			             	 			{name:'androidPass', editable:true,editrules:{required:true}},
			             	 			{name:'androidToken', editable:true,editrules:{required:true}},
			             	 			{name:'appleIp', editable:true,editrules:{required:true}},
			             	 			{name:'applePort', editable:true,editrules:{required:true,integer:true}},
			             	 			{name:'appleCertificatePath', editable:true,editrules:{required:true}},
			             	 			{name:'applePassword', editable:true,editrules:{required:true}},
			             	 			{name:'androidUrl', editable:true,editrules:{required:true}},
			             	 			{name:'iosUrl', editable:true,editrules:{required:true}},
			             	 			{name:'windowsPhoneUrl', editable:true,editrules:{required:true}},
			             	 			{name:'bb10Url', editable:true,editrules:{required:true}},
			             	 			{name:'intervalPoolingTrip', editable:true,editrules:{required:true}},
			             	 			{name:'intervalPoolingTripInTransaction', editable:true,editrules:{required:true}},
			             	 			{name:'timeDelayTrip', editable:true,editrules:{required:true}},
			             	 			{name:'distanceSearchTrip', editable:true,editrules:{required:true}},
			             	 			{name:'driverSearchTrip', editable:true,editrules:{required:true}},
			             	 			{name:'percentageSearchRatio', editable:true,editrules:{required:true}},
			             	 			
                       			        {name:'isEnable',   editable:true,  editrules:{required:true},edittype:'checkbox' },
                       			        {name:'digitalRadio',   editable:true,  editrules:{required:true},edittype:'checkbox' },
                       			        {name:'hasRequiredZone',   editable:true,  editrules:{required:true},edittype:'checkbox' },
                       			        {name:'hasZoneActive',   editable:true,  editrules:{required:true},edittype:'checkbox' },
			             	 			{name:'costRute', editable:true,editrules:{required:false}},
			             	 			{name:'costRutePerKm', editable:true,editrules:{required:false}},
			             	 			{name:'costRutePerKmMin', editable:true,editrules:{required:false}},
			             	 			{name:'zoho', editable:true,editrules:{required:true}},
                       			        {name:'hasMobilePayment',   editable:true,  editrules:{required:true},edittype:'checkbox' },
                                         {name:'id',hidden:true}"
                         sortname="'app'"
                         caption="'Configuracion de empresa'"
                         height="300"
                         autowidth="true"
                         scrollOffset="0"
                         viewrecords="true"
                         showPager="true"
                         datatype="'json'">
                         <jqgrid:navigation id="configNotif" add="true" edit="true" del="true" search="false" refresh="true" />
                         <jqgrid:resize id="configNotif" resizeOffset="-2" />
                  </jqgrid:grid>
           <jqgrid:grid
           id="onlinenotification"
               url="'${createLink(action:'jq_email_config_list',controller:'configurationApp')}'"
                   editurl="'${createLink(action:'jq_email_config_edit',controller:'configurationApp')}'"
           colNames="'Name','Subject','Body','Lang','User','isEnabled','id'"
           	 colModel="{name:'name', editable:true,editrules:{required:true}},
	 						{name:'subject', editable:true,editrules:{required:true}},
	 						{name:'body',index:'body', 
        			         editable:true,editrules:{required:true},edittype:'textarea',
     			    		 editoptions:{rows:'14',cols:'40',dataUrl:'${createLink(action:'jq_email_body',controller:'configurationApp')}' }
           					},
		     	 			{name:'lang', editable:true,editrules:{required:true}},
		     	 			{name:'user', editable:false},
		     	 			{name:'isEnabled',  editable:true,  editrules:{required:true},edittype:'checkbox' },
                           {name:'id',hidden:true}"
           sortname="'name'"
           caption="'Email Configuration'"
           height="300"
           autowidth="true"
           scrollOffset="0"
           viewrecords="true"
           showPager="true"
           datatype="'json'">
           <jqgrid:navigation id="onlinenotification" add="true" edit="true" del="true" search="false" refresh="true" />
           <jqgrid:resize id="onlinenotification" resizeOffset="-2" />
    </jqgrid:grid>
               });
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

			<g:render template="/tripPanelAdmin/sidebar"
				model="['action':'configurationApp']" />
			<!-- DETAIL -->



			<div class="boxPanelTaxista">


				<h1>Configurar  sssss Notificaciones1</h1>

				<div id='message' class="message" style="display: none;"></div>

				<jqgrid:wrapper id="configNotif" />
				<br />
				<jqgrid:wrapper id="notification" />
				<br />
				<jqgrid:wrapper id="onlinenotification" />


			</div>


		</div>

	</div>
	<!-- END MAIN -->
</body>
</html>
