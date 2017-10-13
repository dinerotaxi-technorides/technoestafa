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
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript">
        
          // Load the Visualization API and the areachart package.
          google.load('visualization', '1', {'packages':['areachart']});
          
          // Set a callback to run when the API is loaded.
          google.setOnLoadCallback(initialize);
          
          function initialize() {
            var query = new google.visualization.Query("${createLink(action: 'rees' , controller:'homeAdmin')}");
            query.send(drawChart);
          }
          
          // Callback that creates and populates a data table, 
          // instantiates the pie chart, passes in the data and
          // draws it.
          function drawChart(response) {
            var data = response.getDataTable();    
            var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
            chart.draw(data, {width: 860, height: 240, legend: 'none', title: 'Visits'});
          }
        </script>

<script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Year', 'Sales', 'Expenses'],
          ['2004',  1000,      400],
          ['2005',  1170,      460],
          ['2006',  660,       1120],
          ['2007',  1030,      540]
        ]);

        var options = {
          title: 'Company Performance'
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>

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
                                    url="'${createLink(action:'jq_customer_list',controller:'settingsPromotions')}'"
                                        editurl="'${createLink(action:'jq_edit_customer',controller:'settingsPromotions')}'"
                                colNames="'name','codeQr','discount','startDate','finishDate','id'"
                                	 colModel="{name:'name',
                                         editable:true,
                                         editrules:{required:true}
                                        },
                                        {name:'codeQr',
                                            editable:true,
                                            editrules:{required:true}
                                           },
                                        {name:'discount',
                                         editable:true,
                                         editrules:{required:true}
                                        },
                                        {name:'startDate',
                                            editable:true,
                                            editrules:{required:true}
                                           },
                                        {name:'finishDate',
                                            editable:true,
                                            editrules:{required:true}
                                        },
                                        
	                                            {name:'id',hidden:true}"
                                caption="'Configuracion de promociones'"
                                height="300"
                                autowidth="true"
                                scrollOffset="0"
                                viewrecords="true"
                                showPager="true"
                                datatype="'json'">
                                <jqgrid:navigation id="contact" add="true" edit="true"  del="true" search="true" refresh="true" />
                                <jqgrid:resize id="contact" resizeOffset="-2" />
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

			<g:render template="/tripPanelAdmin/sidebar" model="['action':'settingsPromotions']" />
			<!-- DETAIL -->



			<div class="boxPanelTaxista">


					<h1>Configurar Promociones</h1>

					<div id='message' class="message" style="display: none;"></div>
					<jqgrid:wrapper id="contact" />

					<div class="clearFix">
						<br />
					</div>

					<%--            --%>
					<%--         <div id="chart_div"></div>--%>
					<input type="button"
						onclick="${remoteFunction(controller:'settingsPromotions',action:'render',update:'chart')}">
					<br>
					<div id="chart"></div>
				</div>



		</div>
	</div>
	<!-- END MAIN -->
</body>
</html>
