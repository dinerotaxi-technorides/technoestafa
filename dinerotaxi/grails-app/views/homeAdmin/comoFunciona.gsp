<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<link rel="stylesheet" href="${resource(dir:'css',file:'skin.css')}" />
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript"
	src="${resource(dir:'js',file:'jquery.jcarousel.min.js')}"></script>
<script type="text/javascript">

jQuery(document).ready(function() {
    jQuery('#mycarousel').jcarousel();
	scroll: 1
});

</script>
<script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      //
      function drawChart() {
          
    	  var jsonData = $.ajax({
              url: "${createLink(action: 'rees' , controller:'homeAdmin')}",
              dataType: "json",
              async: false
          }).responseText;

          var obj = jQuery.parseJSON(jsonData);
          var data = google.visualization.arrayToDataTable(obj);
                                                            	  

        var options = {
          title: 'Company Performance'
        };

        var chart = new google.visualization.LineChart(document.getElementById('sssddd'));
        chart.draw(data, options);
      }
    </script>
<script type="text/javascript">
   function selectHandler(e) {
	   var selectedItem = chart.getSelection()[0];
	    if (selectedItem) {
	      var value = data.getValue(selectedItem.row, selectedItem.column);
	      alert('The user selected ' + value);
	    }

   }
</script>
<meta name="layout" content="dineroTaxiAdminL" />

</head>
<body>
	<%
    	def labels = ['First','Second','Third']
		def caso=[
          ['Year', 'Sales', 'Expenses'],
          ['2004',  1000,      400],
          ['2005',  1170,      460],
          ['2006',  660,       1120],
          ['2007',  1030,      540]
        ]
    %>

	<div class="mainContent_">


		<div class="con">

			<g:render template="/tripPanelAdmin/sidebar"
				model="['action':'stadistic']" />
			<!-- DETAIL -->



			<div class="boxPanelTaxista">

				<font>Estado</font>

				<gvisualization:pieCoreChart elementId="piechart"
					title="Registration" width="${450}" height="${300}"
					columns="${myDailyActivitiesColumns}"
					data="${myDailyActivitiesData}" />
				<div id="piechart"></div>

				<br>

      			 <h2>Instalacion por dispositivo Ultimos 3 meses</h2>
				<gvisualization:table elementId="table" width="${400}"   allowHtml="${true}"
					height="${130}" columns="${employeeColumns}" data="${employeeData}"
					select="selectHandler" />
				<div id="table" ></div>
				<br>
      			 <h2>Pedidos Por Fecha</h2>
				<gvisualization:table elementId="pedidosporfecha" width="${400}"
					height="${130}" columns="${pedidosporfechaColumns}" data="${pedidosporfecha}"
					select="selectHandler" />
				<div id="pedidosporfecha" ></div>
				<br>
      			 <h2>Pedidos Por Usuario</h2>
				<gvisualization:table elementId="pedidosporusuario" width="${500}"
					height="${130}" columns="${pedidosporusuarioColumns}" data="${pedidosporusuario}"
					select="selectHandler" />
				<div id="pedidosporusuario"></div>
				<br>
				
      			 <h2>Pedidos Por Usuario Por Fecha</h2>
				<gvisualization:table elementId="pedidosporusuarioporfecha" width="${500}"
					height="${130}" columns="${pedidosporusuarioporfechaColumns}" data="${pedidosporusuarioporfecha}"
					select="selectHandler" />
				<div id="pedidosporusuarioporfecha"></div>
				<br>

      			 <h2>Pedidos Por Dispositivo</h2>
				<gvisualization:table elementId="pedidospordispositivo" width="${500}"
					height="${130}" columns="${pedidospordispositivoColumns}" data="${pedidospordispositivo}"
					select="selectHandler" />
				<div id="pedidospordispositivo"></div>
				<br>
      			 <h2>Pedidos Por Dispositivo Por Fecha</h2>
				<gvisualization:table elementId="pedidospordispositivoporfecha" width="${500}"
					height="${130}" columns="${pedidospordispositivoporfechaColumns}" data="${pedidospordispositivoporfecha}"
					select="selectHandler" />
				<div id="pedidospordispositivoporfecha"></div>
				<br>
      			 <h2>Cantidad de usuarios nuevos por dia</h2>
				<gvisualization:table elementId="cantidadusuariosnuevospordia" width="${500}"
					height="${130}" columns="${cantidadusuariosnuevospordiaColumns}" data="${cantidadusuariosnuevospordia}"
					select="selectHandler" />
				<div id="cantidadusuariosnuevospordia"></div>
				<br>
      			 <h2>Cantidad de usuarios nuevos por dia por plataforma</h2>
				<gvisualization:table elementId="cantidadusuariosnuevospordiaplataforma" width="${500}"
					height="${130}" columns="${cantidadusuariosnuevospordiaplataformaColumns}" data="${cantidadusuariosnuevospordiaplataforma}"
					select="selectHandler" />
				<div id="cantidadusuariosnuevospordiaplataforma"></div>
				<br>
      			 <h2>Cantidad de pedidos por mes</h2>
				<gvisualization:table elementId="cantidadpedidospormes" width="${500}"
					height="${130}" columns="${cantidadpedidospormesColumns}" data="${cantidadpedidospormes}"
					select="selectHandler" />
				<div id="cantidadpedidospormes"></div>
				<br>

			</div>

		</div>

	</div>

</body>
</html>
