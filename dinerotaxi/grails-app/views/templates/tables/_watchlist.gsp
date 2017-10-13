<g:if test="${error}">
	<div class="error"><g:message code="error.watchlists"/></div>
</g:if>
<g:else>
	<section class="clearfix">
		<div class="well clearfix">
			<h3><g:message code="watchlist.add_ticker"/> ${watch.name}</h3>		
			<p><small><g:message code="watchlist.placeholder_symbols"/></small></p>
			<g:render template='/templates/watchlistTextListBox'></g:render>			
			<button class="btn success addTickers" onclick="addTickets(${watch.id})"><g:message code="button.add"/></button>
		</div>
		<g:if test="${flash.message}">
			<div class="success">${flash.message}</div>
		</g:if>
		<g:if test="${flash.error}">
			<div class="error">${flash.error}</div>
		</g:if>
			<table id="watchlist" class="listings" summary="Watchlist">
				<caption>${watch.name}</caption>
			      <thead>
			      <tr>
			        <th><g:message code="watchlist.symbol"/></th>
			        <th><a onclick="showQuoteMiniGraph(1)" style="cursor: pointer;"><g:message code="watchlist.day_abb"/></a> | <a onclick="showQuoteMiniGraph(2)" style="cursor: pointer;"><g:message code="watchlist.month_abb"/></a> | <a onclick="showQuoteMiniGraph(3)" style="cursor: pointer;" ><g:message code="watchlist.year_abb"/></a></th>
			        <th><g:message code="watchlist.last_price"/></th>
			        <th><g:message code="watchlist.change"/> (<a onclick="showChange(1)" style="cursor: pointer;">$</a> | <a onclick="showChange(2)" style="cursor: pointer;">%</a>)</th>
			        <th><g:message code="watchlist.volume"/></th>
			        <th><g:message code="watchlist.trade"/></th>
			        <th><g:message code="watchlist.remove"/></th>
			      </tr>
				</thead>
				<tbody>	
				<g:if test="${watch.quotes.size==0}">
					<td class="no_data" colspan="7">No data</td>
				</g:if>
				<g:else>
					<g:each in="${watch.quotes}" var="quote">
						<tr>
						  <td align="left"><a href="${createUrl(value:'/quotes/'+quote.symbol)}"><img src="${'https://static.dinerotaxi.com/symbols/icon/'+quote.symbol+'.ico'}" class="small_icon" alt=""/> ${quote.symbol}</a></td>
						  <td class="day" style="background:url(http://www.google.com/finance/chart?cht=s&q=${quote.symbol}&tlf=12h&p=1d) no-repeat center center"></td>
						  <td class="month" style="background:url(http://www.google.com/finance/chart?cht=s&q=${quote.symbol}&tlf=12h&p=1M) no-repeat center center; display:none"></td>
						  <td class="year" style="background:url(http://www.google.com/finance/chart?cht=s&q=${quote.symbol}&tlf=12h&p=1Y) no-repeat center center; display:none"></td>
						  <td><g:number value="${quote.last_price}" dollar="true"/></td>
						  <td class="dollar"><g:number value="${quote.change_absolute}" color="true" dollar="true" absolute="true"/></td>
						  <td class="percent" style="display:none"><g:number value="${quote.change}" percent="true" color="true" absolute="true"/></td>
						  <td><g:number value="${quote.volume}" letters="true"/></td>
						  <td class="centre"><button class="btn success" style="margin:0" title="Trade" onclick="showTradeBox('${quote.symbol}')">Trade</button></td>
						  <td class="centre">
							  <button title="Remove" class="btn danger smll removeTicker" onclick="deleteTicker('${quote.symbol}',${watch.id})">X</button>
						  </td>
						</tr>
					</g:each>
				</g:else>
			  	</tbody>
			</table>
		<div class="right">
			<button class="btn danger right deleteWatchlist" onclick="deleteWatchlist(${watch.id})"><g:message code="button.delete"/> ${watch.name}
				<div class="hidden _watchid">${watch.id}</div>
			</button>			
		</div>
		<hr class="space"/>				
	</section>
</g:else>
