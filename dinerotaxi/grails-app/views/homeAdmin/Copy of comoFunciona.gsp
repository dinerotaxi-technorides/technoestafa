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
      //${createLink(action: 'rees' , controller:'homeAdmin')}
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

        var chart = new google.visualization.LineChart(document.getElementById('sssddd'));
        chart.draw(data, options);
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



			<div class="bOX955">

				<font>Estado</font>

				<gvisualization:pieCoreChart elementId="piechart"
					title="Registration" width="${450}" height="${300}"
					columns="${myDailyActivitiesColumns}"
					data="${myDailyActivitiesData}" />
				<div id="piechart"></div>

				<br>

				<gvisualization:table elementId="table" width="${400}"
					height="${130}" columns="${employeeColumns}" data="${employeeData}"
					select="selectHandler" />
				<div id="table"></div>
				<br>
				<div id="sssddd"></div>
				<gvisualization:lineCoreChart dynamicLoading="${false}"
					elementId="sssddd" title="Online RadioTaxi" width="${350}"
					height="${450}" columns="${labels}" data="${caso}" />
				<br>


			</div>

		</div>

	</div>

</body>
</html>
