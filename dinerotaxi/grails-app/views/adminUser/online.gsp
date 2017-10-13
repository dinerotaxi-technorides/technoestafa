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
                  id="contactOnlineEmpresas"
                      url="'${createLink(action:'jq_online_company_list',controller:'adminUser')}'"
                       editurl="'${createLink(action:'jq_edit_online_company_list',controller:'adminUser')}'"
                  colNames="'Id','companyName','Telefono','status','isTestUser','v','countTaxi','countTrips','tripFail','countRejectTrip','countTimeOut','id'"
                  	 colModel="{name:'id', editable:false,editrules:{required:true}},
                				{name:'companyName', editable:false,editrules:{required:true}},
                				{name:'phone', editable:false,editrules:{required:true}},
                       			     {name:'status',index:'status', width:200, sortable:false,
                           			         editable:true, edittype:'select'  , editrules:{required:true},
                       			     editoptions:{dataUrl:'${createLink(action:'jq_get_radiotaxi_status',controller:'adminUser')}'}
	                           			    },
	                        		{name:'isTestUser', editable:false,editrules:{required:true}},
                 					{name:'countTaxi', editable:false,editrules:{required:true}},
                 					{name:'version', editable:false,editrules:{required:true}},
                 					{name:'countTrips', editable:false,editrules:{required:true}},
                 					{name:'tripFail', editable:false,editrules:{required:true}},
                 					{name:'countRejectTrip', editable:false,editrules:{required:true}},
                 					{name:'countTimeOut', editable:false,editrules:{required:true}},
                                  {name:'id',hidden:true}"
                  sortname="'isTestUser'"
                  caption="'ONLINE COMPANIES'"
                  height="300"
                  autowidth="true"
                  scrollOffset="0"
                  viewrecords="true"
                  showPager="true"
                  datatype="'json'">
                  <jqgrid:navigation id="contactOnlineEmpresas" add="false" edit="true"  search="false" refresh="true" />
                  <jqgrid:resize id="contactOnlineEmpresas" resizeOffset="-2" />
           </jqgrid:grid>
               <jqgrid:grid
                      id="trackOnlineRadioTaxi"
                          url="'${createLink(action:'jq_track_radio_taxi_serching_list',controller:'trackRadioTaxi')}'"
                      colNames="'Created Date','RadioTaxi id','RadioTaxi','Status','id'"
                      	 colModel="{name:'createdDate',
                               editable:false,
                               editrules:{required:true}
                              },	{name:'onlineRTaxi',editable:true,editrules:{required:true}},
                                     {name:'radiotaxi',editable:true,search:false, editrules:{required:true}},
                     					{name:'status', editable:true,search:false, editrules:{required:true}},
                                      {name:'id',hidden:true}"
                      sortname="'createdDate'"
                      caption="'Track Radio Taxi'"
                      height="300"
                      autowidth="true"
                      scrollOffset="0"
                      viewrecords="true"
                      showPager="true"
                      datatype="'json'">
                      <jqgrid:navigation id="trackOnlineRadioTaxi" add="false" edit="false" search="true" refresh="true" />
                      <jqgrid:resize id="trackOnlineRadioTaxi" resizeOffset="-2" />
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

			<g:render template="/tripPanelAdmin/sidebar" model="['action':'online']" />
			<!-- DETAIL -->



			<div class="boxPanelTaxista">


				<h1>Online Companies</h1>

				<div id='message' class="message" style="display: none;"></div>


				<jqgrid:wrapper id="contactOnlineEmpresas" />
				<br>
				<jqgrid:wrapper id="trackOnlineRadioTaxi" />





			</div>


		</div>

	</div>
	<!-- END MAIN -->
</body>
</html>
