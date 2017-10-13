<%@ page import="ar.com.operation.TRANSACTIONSTATUS" %>
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
<link rel="apple-touch-icon-precomposed" href="${resource(dir:'images',file:'favicon.ico')}">
	
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
                  id="contacted"
                      url="'${createLink(action:'jq_edit_trip_list',controller:'tripPanel')}'"
                          editurl="'${createLink(action:'jq_edit_trip_edit',controller:'tripPanel')}'"
                          	  colNames="'Fecha','Nombre','Apellido','Telefono','Direccion','Piso','Depto','Comentarios','Editar taxista','id'"
                               	 colModel="
                               	{name:'cratedDate',
                                           editable:false,
                                           editrules:{required:true}
                                          },
                                      {name:'firstName',
                                       editable:false,
                                       editrules:{required:true}
                                      },
                                      {name:'lastName',
                                          editable:false,
                                          editrules:{required:true}
                                       },                                    
                                       {name:'phone',
                                         editable:false,
                                         editrules:{required:true}
                                        },
                                       {name:'placeFrom',
                                        editable:false,
                                        editrules:{required:true}
                                       },
                                       {name:'placeFromPso',
                                        editable:false,
                                        editrules:{required:true}
                                       },
                                       {name:'placeFromDto',
                                        editable:false,
                                        editrules:{required:true}
                                       },
                                       {name:'comments',
                                         editable:false,
                                         editrules:{required:true}
                                        },     
		                                    {name:'intermidiario',
		                                        editable:true,
		                                        editoptions:{size:30},
		                                        editrules:{required:true,number: true}
		                                    },
                                  {name:'id',hidden:true}"
                  caption="'Edite el pedido o cancelelo '"
                  height="300"
                  autowidth="true"
                  scrollOffset="0"
                  viewrecords="true"
                  showPager="true"
                  datatype="'json'">
                  <jqgrid:navigation id="contacted" add="false" edit="true" del="true"  search="false" refresh="true" delcapt="Cancelar Pedido" delcaptmsg="Seguro desea cancelar el pedido?" />
                  <jqgrid:resize id="contacted" resizeOffset="-2" />
           </jqgrid:grid>

           jQuery("#contactedGrid")
           .navButtonAdd('#pager',{
              caption:"Add1", 
              buttonicon:"ui-icon-add", 
              onClickButton: function(){ 
                alert("Adding Row");
              }, 
              position:"last"
           });
           $("#btnDelete").click(function(){
             var gr = $("#contactedGrid").jqGrid('getGridParam','selrow');
             if( gr != null )
               $("#contactedGrid").jqGrid('del1GridRow',gr,
                {afterSubmit:afterSubmitEvent});
             else
               alert("Please Select Row to delete!");
           });
           
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
<body >

<div class="mainContent_">

	<div class="con">

		<g:render template="sidebar" model="['action':'edit']" />
        <!-- DETAIL -->

    

        <div class="boxPanelTaxista">      	
            
        	<!-- TABS -->
        
            
            <!-- DETAIL -->
            
          	
                <h1>Pedidos Disponibles Para editar</h1> 
                
                 <div id='message' class="message success" style="display:none;"></div>
                         <jqgrid:wrapper id="contacted" />
            
            
            
         
    
    </div>

</div>
</div>
<!-- END MAIN -->
</body>
</html>
