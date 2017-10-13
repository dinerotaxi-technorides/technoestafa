<g:if test="${!error}">
	<!-- Trader Account Info -->
	<div class="span-11">
	<table id="account_table" class="listings" summary="Trader Account Info" style="background-color: white;">
		<thead>
			<tr>
				<th colspan="2" style="color: green">
					<span class="left"><g:message code='portfolioheader.accountvaluehistory'/></span>
<%--					<div align="right"><a class="help">?</a></div>--%>
				</th>
			</tr>
		</thead>
		
		<tbody>
			<tr>
				<td style="background-color: #FFFFFF;">
					<div id="chart_div"></div>
				</td>
			</tr>
		</tbody>
	</table>
	</div>
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
			    chart.draw(data,{vAxis:{format:'###.##%'}, hAxis:{slantedText:false,slantedTextAngle:0},enableInteractivity:false,width: 410, height: 180,legend:'none',chartArea:{left:40,top:10,width:"100%",height:"80%"}});
			});
		</g:javascript>
		
	<div class="span-8">
		<g:render template="/templates/common/accountinfo" model="${[portfolio:portfolio]}"></g:render>
		<g:render template="/templates/common/resetaccount" model="${[portfolio:portfolio]}"></g:render>
	</div>
</g:if>
<g:else>
	<div class="error center"><g:message code="error.problem_ocurred"/></div>
</g:else>
