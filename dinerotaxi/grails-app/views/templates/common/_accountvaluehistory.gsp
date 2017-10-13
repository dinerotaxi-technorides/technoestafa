<table id="account_table" class="listings" summary="Trader Account Info" style="background-color: white;">
	<caption>${message(code:'help.account_value_history')}</caption>
<%--	<a class="help right" title='${message(code:'help.account_value_history')}'>?</a>--%>
	<thead>
		<tr><th><g:message code='accountinfo.today'/></th></tr>
	</thead>
	
	<tbody>
		<tr>
			<td style="background-color: #FFFFFF;">
				<div id="chart_div"></div>
			</td>
		</tr>
	</tbody>
</table>

<g:javascript>
	$(document).ready(function(){
		    var data = new google.visualization.DataTable();
		    data.addColumn('string', 'Hour');
		    data.addColumn('number','Value');
		    <g:if test="${hstats}">
			    data.addRows(${hstats.stats.size()});
			    var min = ${new BigDecimal(hstats.stats.get(0)[1])}
			    var val;
				<g:each in="${hstats.stats}" var="stat" status="i">
					data.setValue(${i}, 0, "${formatDate (date:new Date(stat[0].replace('-','/').replace('.0','')), format:"hh:mm") }");
		    		val = (((${new Double(stat[1])}*100)/min)-100)
					val = Math.floor(val * 10000) / 1000000;
	    			data.setValue(${i}, 1, val);
				</g:each>
			</g:if>
		    var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
		    chart.draw(data,{vAxis:{format:'###.##%'}, enableInteractivity:false,width: 250, height: 200,legend:'none',chartArea:{left:40,top:10,width:"100%",height:"80%"}});
	});
</g:javascript>