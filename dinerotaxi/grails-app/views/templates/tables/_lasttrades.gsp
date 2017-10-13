<table id="last_trades" class="listings tablesorter" summary="Last Trades" style="background-color: white;">
      <caption><g:message code="common.transactionshistory"/></caption>
<%--      <a class="help right" title='${message(code:'help.last_trades')}'>?</a>--%>
      <thead>
      <tr>
        <th><g:message code='lasttrades.id'/></th>
        <th><g:message code='lasttrades.type'/></th>
        <th><g:message code='lasttrades.symbol'/></th>
        <th><g:message code='lasttrades.price'/></th>
        <th><g:message code='lasttrades.quantity'/></th>
        <th><g:message code='lasttrades.gain'/></th>
        <th><g:message code='lasttrades.total'/></th>
        <th><g:message code='lasttrades.date'/></th>
      </tr>
	</thead>
	<tbody class="small">
		<g:if test="${!error}">
			<g:if test="${trades.size==0}">
				<td class="no_data" colspan="8"><g:message code='lasttrades.nodata'/></td>
			</g:if>
			<g:else>
				<g:each in="${trades}" var="trade">
					<tr>
					  <td>${trade.id}</td>
					  <g:if test="${trade.type=='DIVIDEND'}">
							 <td class="type"><strong>DIVIDEND</strong></td>
					  </g:if>
					  <g:else>
						  <td class="type"><strong>${trade.type} ${trade.amount>0?trade.transtype:trade.transtype=='BUY'?'SHORT':'COVER'}</strong></td>
					  </g:else>
					  <td align="left" class="symbol" onMouseOver="loadingGraphic('${trade.symbol}')"><a href="${createUrl(value:'/quotes/'+trade.symbol)}"><img src="${'https://static.dinerotaxi.com/symbols/icon/'+trade.symbol+'.ico'}" alt="" class="small_icon symbol" /></a><a href="${createUrl(value:'/quotes/'+trade.symbol)}">${trade.symbol}</a></td>
					  <g:if test="${trade.type=='DIVIDEND'}">
						  <td class="price"><g:number value="${trade.payout}" dollar="true"/></td>
					  </g:if>
					  <g:else>
  						  <td class="price"><g:number value="${trade.price}" dollar="true"/></td>
					  </g:else>
					  
					  <td><g:number value="${trade.amount.abs()}" letters="true" format="#"/></td>
					  <g:if test="${trade.gain}">
					 	 <td class="total"><g:number value="${trade.gain}" color="true" dollar="true" absolute="true" letters="true"/></td>
					  </g:if>
					  <g:else>
					  	<td>-</td>
					  </g:else>
					  <g:if test="${trade.type=='DIVIDEND'}">
							 <td class="total"><g:number value="${trade.payout*trade.amount}" dollar="true" absolute="true" letters="true"/></td>
					  </g:if>
					  <g:else>
					  		<td class="total"><g:number value="${trade.price*trade.amount}" dollar="true" absolute="true" letters="true"/></td>
					  </g:else>
					  <td>${trade.transition_date?trade.transition_date:trade.entry_date}</td>
					</tr>
				</g:each>
			</g:else>
		</g:if>
		<g:else>
			<tr><td class="error center"><g:message code="error.problem_ocurred"/></td></tr>
		</g:else>
  	</tbody>
  	<tfoot>
	</tfoot>  	
  	
</table>
<script type="text/javascript">
	$(document).ready(function(){
		$("#last_trades").tablesorter();
		setTooltip();
	});
</script>
