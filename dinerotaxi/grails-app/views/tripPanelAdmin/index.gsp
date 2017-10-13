<%@ page import="ar.com.operation.TRANSACTIONSTATUS"%>
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
                                id="contact"
                                    url="'${createLink(action:'jq_trip_pending_list',controller:'tripPanelAdmin')}'"
                                        editurl="'${createLink(action:'jq_edit_customer',controller:'tripPanelAdmin')}'"
                                colNames="'operationId','Fecha Del Pedido','CC','RTX','Username','Nombre','Direccion','Intermediario','Taxista','Estado','Tiempo','Comentario','isTestUser','isTestOperation','id'"
                                	 colModel="{name:'id',search:false, 
                                         editable:false,
                                         editrules:{required:true}
                                        },{name:'cratedDate',
                                         editable:false,
                                         editrules:{required:true}
                                        },

                                        {name:'isCompanyAccount',editable:false, 
                                            editable:false,
                                            editrules:{required:true}
                                           },
                                           {name:'rtaxi',editable:false, 
                                               editable:false,
                                               editrules:{required:true}
                                              },
                                        {name:'user.email',
                                            editable:false,
                                            editrules:{required:true}
                                           },
                                        {name:'user.firstName',search:false, 
                                         editable:false,
                                         editrules:{required:true}
                                        },
                                        {name:'trip.address',search:false, 
                                            editable:false,
                                            editrules:{required:true}
                                           },
                                        {name:'intermidiario',index:'intermidiario', width:200, sortable:false,
                          			         editable:true, edittype:'select'  , editrules:{required:true},
                      			     editoptions:{dataUrl:'${createLink(action:'jq_get_company_radiotaxi_status',controller:'adminUser')}'}
	                           			    },
                                        {name:'taxista',
                                            editable:true,search:false, 
                                            editoptions:{size:30},
                                            editrules:{required:true}
                                        },
                                        {name:'status',index:'status', width:200, sortable:false,
                          			         editable:false
	                           			    },
                                        {name:'timeTravel',
                                            editable:true,search:false, 
                                            editoptions:{size:30},
                                            editrules:{required:true,number: true}
                                        },
                                        {name:'comentario',
                                            editable:false,search:false 
                                           
                                        },
                                        {name:'isTestUser',search:false, 
                                            editable:false,
                                            editrules:{required:true}
                                           },
                                        {name:'isTestOperation',search:false, 
                                            editable:false,
                                            editrules:{required:true}
                                           },
	                                            {name:'id',hidden:false}"
                                caption="'Contact List'"
                                height="300"
                                autowidth="true"
                                scrollOffset="0"
                                viewrecords="true"
                                showPager="true"
                                datatype="'json'">
                                <jqgrid:navigation id="contact" add="false" edit="true" del="true" search="false" refresh="true" />
                                <jqgrid:resize id="contact" resizeOffset="-2" />
                         </jqgrid:grid>
                         <jqgrid:grid
                         id="operationSerch"
                             url="'${createLink(action:'jq_trip_serching_list',controller:'tripPanelAdmin')}'"
                         colNames="'Operation Id','Fecha Del Pedido','CC','RTX','costo','Username','Nombre','Direccion','Intermediario','Taxista','Estado','Tiempo','Comentario','isTestUser','isTestOperation','id'"
                         	 colModel="{name:'id',
                                 editable:false,search:false, 
                                 editrules:{required:true}
                                },{name:'createdDate',
                                  editable:false,
                                  editrules:{required:true}
                                 },

                                 {name:'isCompanyAccount',editable:false, 
                                     editable:false,
                                     editrules:{required:true}
                                    },
                                    {name:'rtaxi',editable:false, 
                                        editable:false,
                                        editrules:{required:true}
                                       },
                                    {name:'amount',search:false, 
                                        editable:false,
                                        editrules:{required:true}
                                       },
                                 {name:'email',
                                     editable:false,
                                     editrules:{required:true}
                                    },
                                 {name:'user.firstName',search:false, 
                                  editable:false,
                                  editrules:{required:true}
                                 },
                                 {name:'trip.address',search:false, 
                                     editable:false,
                                     editrules:{required:true}
                                    },
                                 {name:'intermidiario',search:false, 
                                     editable:true,
                                     editoptions:{size:30},
                                     editrules:{required:true,email: true}
                                 },
                                 {name:'taxista',search:false, 
                                     editable:true,
                                     editoptions:{size:30},
                                     editrules:{required:true,email: true}
                                 },
                                 {name:'status',search:false, 
                                     editable:true,
                                     editoptions:{size:30},
                                     editrules:{required:true,number: true}
                                 },
                                 {name:'timeTravel',search:false, 
                                     editable:true,
                                     editoptions:{size:30},
                                     editrules:{required:true,number: true}
                                 },
                                 {name:'comentario',
                                     editable:true,search:false, 
                                     editoptions:{size:30},
                                     editrules:{required:true,number: true}
                                 },
                                 {name:'isTestUser',search:false, 
                                     editable:false,
                                     editrules:{required:true}
                                    },
                                 {name:'isTestOperation',
                                     editable:false,search:false, 
                                     editrules:{required:true}
                                    },
                                         {name:'id',hidden:true}"
                         caption="'Contact List'"
                         sortname="'createdDate'"
                         height="300"
                         autowidth="true"
                         scrollOffset="0"
                         viewrecords="true"
                         showPager="true"
                         datatype="'json'">
                         <jqgrid:navigation id="operationSerch" add="false" edit="false"  search="true" refresh="true" />
                         <jqgrid:resize id="operationSerch" resizeOffset="-2" />
                  </jqgrid:grid>
               });
	        $(document).ready(function() {
                <jqgrid:grid
                       id="operationTracker"
                           url="'${createLink(action:'jq_track_trip_serching_list',controller:'trackTrip')}'"
                       colNames="'Created Date','Operation id','RadioTaxi','Status','tiempo','taxista','id'"
                       	 colModel="{name:'createdDate',
                                editable:false,search:false, 
                                editrules:{required:true}
                               },	{name:'operation',editable:true,editrules:{required:true}},
                                    {name:'radiotaxi',search:false, editable:true,editrules:{required:true}},
                    				{name:'status', search:false, editable:true,editrules:{required:true}},
                                    {name:'timeTravel',search:false, editable:true,editrules:{required:true}},
                                    {name:'taxista',search:false, editable:true,editrules:{required:true}},
                                    {name:'id',hidden:true}"
                       sortname="'createdDate'"
                       caption="'TrackTrip'"
                       height="300"
                       autowidth="true"
                       scrollOffset="0"
                       viewrecords="true"
                       showPager="true"
                       datatype="'json'">
                       <jqgrid:navigation id="operationTracker" add="false" edit="false" search="true" refresh="true" />
                       <jqgrid:resize id="operationTracker" resizeOffset="-2" />
                </jqgrid:grid>
                
             
      });
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

			<g:render template="sidebar" model="['action':'trips']" />
			<!-- DETAIL -->



			<div class="boxPanelTaxista">


				<h1>Pedidos Disponibles Para asignar</h1>

				<div id='message' class="message" style="display: none;"></div>
				<jqgrid:wrapper id="contact" />

				<div class="clearFix">
					<br />
				</div>
				<jqgrid:wrapper id="operationSerch" />
				<div class="clearFix">
					<br />
				</div>
				<jqgrid:wrapper id="operationTracker" />


			</div>


		</div>

	</div>
	<!-- END MAIN -->
</body>
</html>
