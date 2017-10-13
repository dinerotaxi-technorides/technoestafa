<g:if test="${!error}">
		<!-- Trader Account Info -->
		
		<div id='account_table_container'> 
			<table id="account_table" class="listings" summary="Trader Account Info" style="background-color: white;">
				<thead>
					<tr>
						<th colspan="2" style="color: green"><span class="left">ACCOUNT INFO</span></th>
					</tr>
				</thead>
				<tbody class="small">
					<tr>
						<td>
							<g:message code="portfolio.short_balance" />
						</td>
						<td>
							<span class="neutral_value"><g:number value="${portfolio.short_balance}" letters="true" dollar="true"/></span>
						</td>
					</tr>
					<tr>
						<td>
							<g:message code="portfolio.long_balance" />
						</td>
						<td>
							<span class="neutral_value"><g:number value="${portfolio.long_balance}" letters="true" dollar="true"/></span>
						</td>
					</tr>
					<tr>
						<td>
							<g:message code="portfolio.available_cash" />
						</td>
						<td>
							<span class="neutral_value"><g:number value="${portfolio.cash}" letters="true" dollar="true"/></span>
						</td>
					</tr>
					<tr>
						<td>
							<g:message code="portfolio.spendable_cash" />
						</td>
						<td>
							<span class="neutral_value"><g:number value="${portfolio.av_cash}" letters="true" dollar="true"/></span>
						</td>
					</tr>
					<tr>
						<td>
							<span style="font-weight:900"><g:message code="portfolio.account_value"/></span>
						</td>
						<td>
							<span class="neutral_value" style="font-weight:900"><g:number value="${portfolio.balance}" letters="true" dollar="true"/></span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id='short_positions_container'>
		
		<!-- Short Positions -->
			<table id="short-positions" class="listings">
				<caption>
					<g:message code="position.short_positions" />
				</caption>
				<thead>
					<tr>
						<th><g:message code="position.company" />
						</th>
						<th><g:message code="position.buy_price" />
						</th>
						<th><g:message code="position.quantity" />
						</th>
						<th><g:message code="position.gain" />
						</th>
					</tr>
				</thead>
				<tbody>
					<g:if test="${portfolio.short_holdings.size()>0}">
						<g:each in="${portfolio.short_holdings}" var="position">
							<tr>
								<td align="left"><a href="#"><img
										src="${'https://static.dinerotaxi.com/symbols/icon/'+position.symbol+'.ico'}"
										class="small_icon" alt=""/>
								</a><a href="#">
										${position.symbol}
								</a>
								</td>
								<td class="price">
									${position.last_price}
								</td>
								<td>
									<g:formatNumber number="${position.amount.abs()}" format="###,###"/> 
								</td>
								<td class="total">
									<g:number percent="true" value="${position.gain}" color="true" absolute="true"/>
								</td>
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
						<th><g:message code="position.company" />
						</th>
						<th><g:message code="position.buy_price" />
						</th>
						<th><g:message code="position.quantity" />
						</th>
						<th><g:message code="position.gain" />
						</th>
					</tr>
				</thead>
				<tbody>
					<g:if test="${portfolio.long_holdings.size>0}">
						<g:each in="${portfolio.long_holdings}" var="position">
							<tr>
								<td align="left"><a href="#"><img
										src="${'https://static.dinerotaxi.com/symbols/icon/'+position.symbol+'.ico'}"
										class="small_icon" alt="" />
								</a><a href="#">
										${position.symbol}
								</a>
								</td>
								<td class="price">
									${position.last_price}
								</td>
								<td>
									<g:formatNumber number="${position.amount}" format="###,###"/> 
								</td>
								<td class="total">
									<g:number percent="true" value="${position.gain}" color="true" absolute="true"/>
								</td>
							</tr>
						</g:each>
					</g:if>
					<g:else>
						<td class="no_data" colspan="4">No data</td>
					</g:else>
				<tbody>
			</table>
		</div>
		
		<div id='friends_balance_container'>
			<table class="listings" style="text-align: center">
				<thead>
					<tr>
						<th colspan="5" class="title">Friends' Balance</th>
					</tr>
				</thead>
				<tbody class="small" id="global_all_time">
					<tr>
						<td class="no_data" colspan="8">Loading... <img
							src="${application.getContextPath()}/img/spinner.gif" alt=""/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

</g:if>

<g:else>
	<div class="error center"><g:message code="error.problem_ocurred"/></div>
</g:else>
	
<script type="text/javascript">
	$(document).ready(function(){
		${remoteFunction(controller:'ranking', action:'friendsAllTime',update:'global_all_time')}
	});
</script>
