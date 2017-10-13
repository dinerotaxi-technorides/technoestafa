<g:if test="${error}">
	<div class="error"><g:message code="error.watchlists"/></div>
</g:if>

<g:else>
		
	<section class="clearfix">
	
			<table id="watchlistInfo" class="listings" summary="Watchlist">
			      <thead>
			      <tr>
			        <th><g:message code="watchlist.symbol"/></th>
			        <th id="last_price"><g:message code="watchlist.last_price"/></th>
			        <th id="change"><g:message code="watchlist.change"/></th>
			      </tr>
				</thead>
				<tbody>	
				<g:if test="${watch.quotes.size==0}">
					<td class="no_data" colspan="7">No data</td>
				</g:if>
				<g:else>
					<g:each in="${watch.quotes}" var="quote">
<%--						<tr id="${quote.symbol}_row" onmouseover="changeOptions('${quote.symbol}')" onmouseout="changeInfo('${quote.symbol}')">--%>
						<tr class="sidewatchticketlist" id="${quote.symbol}_row" onmouseover="changeOptions('${quote.symbol}')" onmouseout="changeInfo('${quote.symbol}')">
						  <div class="_symbol hidden">${quote.symbol}</div>
						  <td class="quotes-symbol" align="left"><a href="${createUrl(value:'/quotes/'+quote.symbol)}"><img src="${'https://static.dinerotaxi.com/symbols/icon/'+quote.symbol+'.ico'}" class="small_icon" alt=""/> ${quote.symbol}</td></a>
						  <td id="${quote.symbol}_last_price"><g:number value="${quote.last_price}" dollar="true"/></td>
						  <td id="${quote.symbol}_change" class="dollar"><g:number value="${quote.change}" percent="true" color="true" absolute="true"/></td>
						  <td colspan="2" class="centre" style="display:none;" id="${quote.symbol}_trade_actions">
							  <button class="btn danger smll" title="Sell" onclick="showTradeBox('${quote.symbol}','SELL')"> &ndash; </button><button class="btn success smll" styl title="Buy" onclick="showTradeBox('${quote.symbol}','BUY')"> + </button>
						  </td>
<%--						  <td style="display:none;" id="${quote.symbol}_remove">--%>
<%--						  	<button class="remove smll" onclick="deleteTicket('${quote.symbol}',${watch.id})">X</button>--%>
<%--						  </td>--%>
						</tr>
					</g:each>
				</g:else>
			  	</tbody>
			</table>
			
		<div class="right">
			<button onclick="selectSideWatchlist()" class="btn success">Edit</button>
		</div>				
	</section>
</g:else>

<%--<script type="text/javascript">--%>
<%--	function bind(symbol){--%>
<%--		$('#'+symbol+"_row").bind("mouseenter",function(){--%>
<%--			changeOptions(symbol);--%>
<%--		});--%>
<%----%>
<%--		$('#'+symbol+"_row").bind("mouseleave",function(){--%>
<%--			changeInfo(symbol);--%>
<%--		});--%>
<%--	}--%>
<%--</script>--%>
