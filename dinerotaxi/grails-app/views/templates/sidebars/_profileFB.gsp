<g:render template="/templates/common/accountinfo" model="${[portfolio:portfolio]}"></g:render>

<div id='short_positions_container'>
	<!-- Short Positions -->
	<table id="short-positions" class="listings">
		<caption>
			<g:message code="position.short_positions" />
		</caption>
		<thead>
			<tr>
				<th><g:message code="position.company" /></th>
				<th><g:message code="position.buy_price" /></th>
				<th><g:message code="position.quantity" /></th>
				<th><g:message code="position.gain" /></th>
			</tr>
		</thead>
		<tbody>
			<g:if test="${portfolio.short_holdings.size()>0}">
				<g:each in="${portfolio.short_holdings}" var="position">
					<tr>
						<td align="left"><a href="#"><img
								src="${'https://static.dinerotaxi.com/symbols/icon/'+position.symbol+'.ico'}"
								class="small_icon" alt=""/> </a><a href="${createUrl(value:'/quotes/'+ position.symbol)}"> ${position.symbol} </a></td>
						<td class="price">
							${position.last_price}
						</td>
						<td><g:formatNumber number="${position.amount.abs()}"
								format="###,###" /></td>
						<td class="total"><g:number percent="true"
								value="${position.gain}" color="true" absolute="true" /></td>
					</tr>
				</g:each>
			</g:if>
			<g:else>
				<td class="no_data" colspan="4">No data</td>
			</g:else>
		<tbody>
	</table>
</div>

<!-- Long Positions -->
<div id='long_positions_container'>
	<table id="long-positions" class="listings">
		<caption>
			<g:message code="position.long_positions" />
		</caption>
		<thead>
			<tr>
				<th><g:message code="position.company" /></th>
				<th><g:message code="position.buy_price" /></th>
				<th><g:message code="position.quantity" /></th>
				<th><g:message code="position.gain" /></th>
			</tr>
		</thead>
		<tbody>
			<g:if test="${portfolio.long_holdings.size>0}">
				<g:each in="${portfolio.long_holdings}" var="position">
					<tr>
						<td align="left"><a href="#"><img
								src="${'https://static.dinerotaxi.com/symbols/icon/'+position.symbol+'.ico'}"
								class="small_icon" alt=""/> </a><a href="${createUrl(value:'/quotes/'+ position.symbol)}"> ${position.symbol} </a></td>
						<td class="price">
							${position.last_price}
						</td>
						<td><g:formatNumber number="${position.amount}"
								format="###,###" /></td>
						<td class="total"><g:number percent="true"
								value="${position.gain}" color="true" absolute="true" /></td>
					</tr>
				</g:each>
			</g:if>
			<g:else>
				<td class="no_data" colspan="4"><g:message code='profile.nodata'/></td>
			</g:else>
		<tbody>
	</table>
</div>

<div id='friends_balance_container'>
	<table class="listings" style="text-align: center">
		<thead>
			<tr>
				<th colspan="5" class="title"><g:message code='profile.friendsbalance'/></th>
			</tr>
		</thead>
		<tbody class="small" id="global_all_time">
			<tr>
				<td class="no_data" colspan="8"><g:message code='profile.loading'/> <img
					src="${application.getContextPath()}/img/spinner.gif" alt="" /></td>
			</tr>
		</tbody>
	</table>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		${remoteFunction(controller:'ranking', action:'friendsAllTime',update:'global_all_time')}
	});
</script>