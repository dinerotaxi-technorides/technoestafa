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

    <g:javascript library="jquery" plugin="jquery"/>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery-ui-1.8.16.custom.min.js')}"></script>

<!--Google Analytics-->
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
	
    <script src="${resource(dir:'js/imported',file:'jquery.tools.min.js')}"></script>
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
		
		<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="https://www.datatables.net/rss.xml">
		
		<style type="text/css" media="screen">
			@import "${resource(dir:'css/datatable',file:'demo_page.css')}";
			@import "${resource(dir:'css/datatable',file:'demo_table.css')}";
			@import "https://www.datatables.net/media/css/site_jui.ccss";
			@import "${resource(dir:'css/datatable',file:'jdemo_table_jui.css')}";
			@import "${resource(dir:'css/datatable/themes/base',file:'jquery-ui.css')}";
			@import "${resource(dir:'css/datatable/themes/smoothness',file:'jquery-ui-1.7.2.custom.css')}";
			/*
			 * Override styles needed due to the mix of three different CSS sources! For proper examples
			 * please see the themes example in the 'Examples' section of this site
			 */
			.dataTables_info { padding-top: 0; }
			.dataTables_paginate { padding-top: 0; }
			.css_right { float: right; }
			#example_wrapper .fg-toolbar { font-size: 0.8em }
			#theme_links span { float: left; padding: 2px 10px; }
		</style>

	<script type="text/javascript" src="${resource(dir:'js/jquery',file:'complete.js')}"></script>
	<script src="${resource(dir:'js/jquery',file:'jquery-1.4.4.min.js')}" type="text/javascript"></script>
	<script src="${resource(dir:'js/jquery',file:'jquery.dataTables.min.js')}" type="text/javascript"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:'jquery.dataTables.editable.js')}"></script>
	<script src="${resource(dir:'js/jquery',file:'jquery.jeditable.js')}" type="text/javascript"></script>
	<script src="${resource(dir:'js/jquery',file:'jquery-ui.js')}" type="text/javascript"></script>
	<script src="${resource(dir:'js/jquery',file:'jquery.validate.js')}" type="text/javascript"></script>
	<script type="text/javascript" charset="utf-8">
			$(document).ready( function () {
				var id = -1;//simulation of id
				$('#example').dataTable({ bJQueryUI: true,
	                "bServerSide": true,
	                "sAjaxSource": "${createLink(action:'getPendingTrips')}",
	                "bProcessing": true,
	                "sPaginationType": "full_numbers",
	                "bJQueryUI": true,
	                "aoColumns": [
	                              {  "sName": "ID",
	                                 "bSearchable": false,
	                                 "bSortable": false,
	                                 "bVisible": false
	                                     },
	                      { "sName": "FECHA_DEL_VIAJE" },
	                      { "sName": "NOMBRE_DEL_USUARIO" },
	                      { "sName": "TAXISTA" }
	                     ]
							}).makeEditable({
									sUpdateURL:"${createLink(action:'edit')}",
                           			sAddURL: "add",
                           			sAddHttpMethod: "GET",
                                    sDeleteHttpMethod: "GET",
									sDeleteURL: "edit",
                    							"aoColumns": [
                    									{ 	cssclass: "required" },
                    									{
                    									},
                    									{
              									        indicator: 'Guardando pedido..',
	              									      fnOnCellUpdated: function(sStatus, sValue, settings){
	                              							alert("Se asigno correctamente el taxi " + sValue);
	                              						},
                                       					tooltip: 'Doble click para asignar',
                                       					
														type: 'text',
                                                 						submit:'Asignar Auto'
                    									},
                    									{
                                                            					indicator: 'Saving Engine Version...',
                                                            					tooltip: 'Click to select engine version',
                                                            					loadtext: 'loading...',
                           					                                type: 'select',
                               						            		onblur: 'cancel',
												submit: 'Ok',
                                         		loadurl: '${createLink(action:'getPendingTrips')}',
												loadtype: 'GET'
                    									},
                    									{
                                           					indicator: 'Saving CSS Grade...',
                                           					tooltip: 'Click to select CSS Grade',
                                           					loadtext: 'loading...',
          					                                type: 'select',
              						            		onblur: 'submit',
                                           					data: "{'':'Please select...', 'A':'A','B':'B','C':'C'}"
                                       				}
											],
									oAddNewRowButtonOptions: {	label: "Add...",
													icons: {primary:'ui-icon-plus'} 
									},
									oDeleteRowButtonOptions: {	label: "Remove", 
													icons: {primary:'ui-icon-trash'}
									},

									oAddNewRowFormOptions: { 	
                                                    title: 'Add a new browser',
													show: "blind",
													hide: "explode",
                                                    modal: true
									}	,
									sAddDeleteToolbarSelector: ".dataTables_length"								

										});
				
			} );
		</script>
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
                
                <div class="full_widt1h">
					<form id="formAddNewRow" action="#" title="Add a new browser" style="width:600px;min-width:600px">
					        <label for="engine">Rendering engine</label><br />
						<input type="text" name="engine" id="name" class="required" rel="0" />
					        <br />
					        <label for="browser">Browser</label><br />
						<input type="text" name="browser" id="browser" rel="1" />
					        <input type="hidden" name="platform" rel="2" />
					        <br />
					        <label for="version">Engine version</label><br />
						<select name="version" id="version" rel="3">
					                <option>1.5</option>
					                <option>1.7</option>
					                <option>1.8</option>
					        </select>
					        <br />
					        <label for="grade">CSS grade</label><br />
							<input type="radio" name="grade" value="A" rel="4"> First<br>
							<input type="radio" name="grade" value="B" rel="4"> Second<br>
							<input type="radio" name="grade" value="C" checked rel="4"> Third
					        <br />
					</form>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="example">
					<thead>
						<tr>
							<th>Id</th>
							<th>Fecha del Viaje</th>
							<th>Nombre del usuario</th>
							<th>Taxista</th>
						</tr>
					</thead>
					<tbody>
				       
					</tbody>
				</table>
              
            </div>
            
            <div class="clearFix"><br /></div>
            
            
         </div>   
       
    
    </div>

</div>
<!-- END MAIN -->
</body>
</html>
