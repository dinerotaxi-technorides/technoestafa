<table id="short-positions" class="listings">
	<caption>${title}</caption>
	<thead>
	<tr>
	  <th><g:message code='positions.company'/></th>
	  <th><g:message code='positions.price'/></th>
	  <th><g:message code='positions.quantity'/></th>
	  <th><g:message code='positions.gain'/></th>
	</tr>
	</thead>
	<tbody>
	<g:if test="${holdings.size()>0}">
		<g:each in="${holdings}" var="position">
		<tr>
			<td align="left">
			<a href="${createUrl(value:'/quotes/'+ position.symbol)}"><img src="${'https://static.dinerotaxi.com/symbols/icon/'+position.symbol+'.ico'}" class="small_icon" alt=""/></a>
			<a href="${createUrl(value:'/quotes/'+ position.symbol)}">${position.symbol}</a>
		</td>
		<td class="price">
			${position.last_price}
		</td>
		<td>
			<g:number value="${position.amount}" absolute="true" letters="true" format="###,###"/>
		</td>
		<td class="total">
			<g:number percent="true" value="${position.gain}" color="true" absolute="true"/>
			</td>
		</tr>
		</g:each>
	</g:if>
	<g:else>
		<td class="no_data" colspan="4"><g:message code='positions.nodata'/></td>
	</g:else>
</table>