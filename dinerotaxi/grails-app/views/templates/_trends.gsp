<g:if test="${!error}">
	<g:if test="${symbols.size()>0}">
		<g:if test="${type=='M'}">
			<${isFacebook()=='true'?'h4':'h3'}>Monthly Trends</${isFacebook()=='true'?'h4':'h3'}>
		</g:if>
		<g:elseif test="${type=='d'}">
			<${isFacebook()=='true'?'h4':'h3'}>Today Trends</${isFacebook()=='true'?'h4':'h3'}>
		</g:elseif>
		<g:each in="${symbols}" var="symbol">
			<div>
				<img class="small_icon" src="https://static.dinerotaxi.com/symbols/icon/${symbol.stock.symbol}.ico" align="absmiddle" alt=""/>
				<a class="symbol" onMouseOver="loadingGraphic('${symbol.stock.symbol}')" href="${createUrl(value:'/quotes/'+symbol.stock.symbol)}"> ${symbol.stock.symbol}</a><img src="http://www.google.com/finance/chart?cht=s&q=${symbol.stock.symbol}&tlf=12h&p=1${type}"alt="" />
<%--				<g:if test="${type=='d'}">--%>
<%--					<span>Last price: ${symbol.last_price}</span>--%>
<%--				</g:if>--%>
			</div>
		</g:each>
	</g:if>
</g:if>
<g:else>
	<div class="error center"><g:message code="error.problem_ocurred"/></div>
</g:else>
<script type="text/javascript">setTooltip();</script>