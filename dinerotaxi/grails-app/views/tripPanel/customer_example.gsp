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
        <link rel="stylesheet" href="${resource(dir:'css',file:'ui.jqgrid.css')}" />
        <link rel="stylesheet" href="${resource(dir:'css/ui-lightness',file:'jquery-ui-1.7.2.custom.css')}" />
        <g:javascript library="jquery-1.3.2.min"/>
        <g:javascript library="jquery-ui-1.7.2.custom.min"/>
        <g:javascript library="grid.locale-en"/>
        <g:javascript library="jquery.jqGrid.min"/>
</head>
<body >

<div class="mainContent_">

	<div class="con">
	<div class="sidebar1 mt10">
		<g:render template="sidebar" />
    </div>
        <div class="content mt10">        	
            
        	<!-- TABS -->
        
            
            <!-- DETAIL -->
            
            <div class="boxPanelRadioTaxi">
            
            	
                <h1>Pedidos Disponibles Para asignar</h1> 
                
                 <div id='message' class="message" style="display:none;"></div>
            
            <!-- table tag will hold our grid -->
            <table id="customer_list" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
            <!-- pager will hold our paginator -->
            <div id="customer_list_pager" class="scroll" style="text-align:center;"></div>

            <div style="margin-top:5px">
              <input class="ui-corner-all" id="btnAdd" type="button" value="Add Record"/>
              <input class="ui-corner-all" id="btnEdit" type="button" value="Edit Selected Record"/>
              <input class="ui-corner-all" id="btnDelete" type="button" value="Delete Selected Record"/>
            </div>


            <script type="text/javascript">
            var lastSelectedId;
            
            /* when the page has finished loading.. execute the following */
            $(document).ready(function () {

                // set on click events for non toolbar buttons
                $("#btnAdd").click(function(){
                  $("#customer_list").jqGrid("editGridRow","new",
                     {addCaption:'Create New Customer',
                     afterSubmit:afterSubmitEvent,
                     savekey:[true,13]});
                });

                $("#btnEdit").click(function(){
                   var gr = $("#customer_list").jqGrid('getGridParam','selrow');
                   if( gr != null )
                     $("#customer_list").jqGrid('editGridRow',gr,
                     {closeAfterEdit:true,
                      afterSubmit:afterSubmitEvent
                     });
                   else
                     alert("Please Select Row");
                });

                $("#btnDelete").click(function(){
                  var gr = $("#customer_list").jqGrid('getGridParam','selrow');
                  if( gr != null )
                    $("#customer_list").jqGrid('delGridRow',gr,
                     {afterSubmit:afterSubmitEvent});
                  else
                    alert("Please Select Row to delete!");
                });
                

                $("#customer_list").jqGrid({
                  url:'${createLink(action:'jq_customer_list',controller:'customer')}',
                  editurl:'${createLink(action:'jq_edit_customer',controller:'customer')}',
                  datatype: "json",
                  colNames:['First Name','Last Name','Age','Email Address','id'],
                  colModel:[
                    {name:'firstName',
                     editable:true,
                     editrules:{required:true}
                    },
                    {name:'lastName',
                     editable:true,
                     editrules:{required:true}
                    },
                    {name:'age',
                      editable:true,
                      editoptions:{size:3},
                      editrules:{required:true,integer:true}
                    },
                    {name:'emailAddress',                    
                     editable:true,
                     editoptions:{size:30},
                     editrules:{required:true,email:true}
                    },
                    {name:'id',hidden:true}
                  ],
                  rowNum:2,
                  rowList:[1,2,3,4],
                  pager:'#customer_list_pager',
                  viewrecords: true,
                  gridview: true

                }).navGrid('#customer_list_pager',
                    {add:true,edit:true,del:true,search:false,refresh:true},      // which buttons to show?
                    {closeAfterEdit:true,
                     afterSubmit:afterSubmitEvent
                    },                                   // edit options
                    {addCaption:'Create New Customer',
                     afterSubmit:afterSubmitEvent,
                     savekey:[true,13]},            // add options
                    {afterSubmit:afterSubmitEvent}  // delete options
                );


                $("#customer_list").jqGrid('filterToolbar',{autosearch:true});
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
            
            <div class="clearFix"><br /></div>
            
            
         </div>   
       
    
    </div>

</div>
</div>
<!-- END MAIN -->
</body>
</html>
