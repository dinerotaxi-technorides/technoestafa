   <table id="${type}-positions" class="listings tablesorter" summary="Positions" style="background-color: white;">
		<caption>${message(code:'position.'+type+'_positions')}</caption>
<%--		<a class="help right" title='${message(code:'help.'+type+'_positions')}'>?</a>--%>
		<thead>
	      <tr>
	        <th><g:message code="position.company"/></th>
	        <th><g:message code="position.buy_price"/></th>
	        <th><g:message code="position.quantity"/></th>
	        <th><g:message code="position.last_price"/></th>
	        <th><g:message code="position.market_value"/></th>
	        <th><g:message code="position.gain"/> (<a class="gainSelector" onclick="showGain(1,'${type}')" style="cursor: pointer;">$</a> | <a class="gainSelector" onclick="showGain(2,'${type}')" style="cursor: pointer;">%</a>)</th>
	        <th><g:message code="position.trade"/></th>
	      </tr>
		</thead>

	    <tbody class="small">
		    <g:if test="${positions.size()>0}">
		    	<g:each in="${positions}" var="position">
			      <tr>
			        <td align="left" class="symbol" onMouseOver="loadingGraphic('${position.symbol}')"><a href="${createUrl(value:'/quotes/'+position.symbol)}"><img src="${'https://static.dinerotaxi.com/symbols/icon/'+position.symbol+'.ico'}" class="small_icon" alt=""/></a><a href="${createUrl(value:'/quotes/'+position.symbol)}">${position.symbol}</a></td>
					<td class="price"><g:number value="${position.price}" dollar="true"/></td>
			        <td class="quantity"><g:number value="${position.amount}" absolute="true" format="###,###"/></td>
			        <td><g:number value="${position.last_price}" dollar="true"/> <g:number value="${position.change}" dollar="true"  absolute="true" color="true" parenthesis="true"/></td>
			        <td><g:number value="${position.market_value}" letters="true" dollar="true"/></td>
			        <td class="gain dollar">
			        	<g:number value="${(position.gain_value)}" letters="true" color="true" dollar="true" absolute="true"/>
			        </td>
			       	<td class="gain percent" style="display:none;">
			        	<g:number value="${(position.gain)}"  percent="true" color="true" absolute="true"/>
			        </td>
			        <td class="centre trade-buttons">
						<button class="${position.amount>0?'btn danger smll':'btn danger smll'}" title=${position.amount>0?"Sell":"Cover"} onclick="showTradeBox('${position.symbol}','${position.amount>0?"SELL":"COVER"}')"> &ndash; </button><button class="${position.amount>0?"btn success smll":"btn success smll"}" title=${position.amount>0?"Buy":"Short"} onclick="showTradeBox('${position.symbol}','${position.amount>0?"BUY":"SHORT"}')"> + </button>
			        </td>
			      </tr>
			    </g:each>
		    </g:if>
		    <g:else>
		    	<td class="no_data" colspan="8">No data</td>
		    </g:else>
	    </tbody>
	</table>
	

