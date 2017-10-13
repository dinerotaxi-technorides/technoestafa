<g:if test="${!error}">
	<ul id="trends-ticker">
		<li>
			<div class="inner">
				<span class="trending-headline"><g:message code="trendingbar.trendingnow"/></span>
				<g:each in="${symbols}" var="item">
<%--					<img class="small_icon" src="${'https://static.dinerotaxi.com/symbols/icon/'+item.stock.symbol+'.ico'}" align="absmiddle" alt=""/>--%>
					<g:link  params="[country:"${params?.country?:''}"]" url="${application.getContextPath()}/quotes/${item.stock.symbol}">
						$<span>${item.stock.symbol}</span>
					</g:link>
				</g:each>
			</div>
		</li>
		<li>
			<div class="inner">
				<span class="trending-headline"><g:message code="trendingbar.indexes"/></span>
				<span class="markets"><a href="${application.getContextPath()}/quotes/$dji"><g:message code="trendingbar.dow"/> </a>${indexes.quotes[0].close} <g:number value="${indexes.quotes[0].change}" color="true" parenthesis="true"/></span>
				<span class="markets"><a href="${application.getContextPath()}/quotes/$compx"><g:message code="trendingbar.nasdaq"/> </a>${indexes.quotes[1].close} <g:number value="${indexes.quotes[1].change}" color="true" parenthesis="true"/></span>
				<span class="markets last-markets"><a href="${application.getContextPath()}/quotes/$spx.x"><g:message code="trendingbar.sp500"/> </a>${indexes.quotes[2].close} <g:number value="${indexes.quotes[2].change}" color="true" parenthesis="true"/></span>
			</div>
		</li>
	</ul>
</g:if>
