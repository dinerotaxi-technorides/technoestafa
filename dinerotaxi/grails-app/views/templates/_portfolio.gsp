<div id="portfolio">
	<g:render model="${[type:'orders',orders:orders]}" template="/templates/tables/orders"/>
	<g:render model="${[type:'dividends',orders:dividends]}" template="/templates/tables/orders"/>
	<g:render model="${[type:'long',positions:portfolio.long_holdings]}" template="/templates/tables/positions"/>
	<g:render model="${[type:'short',positions:portfolio.short_holdings]}" template="/templates/tables/positions"/>
	<div id="lastTradesContainer"></div>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		initPortfolio();
		stopPropagation('.gainSelector');
	});
</script>
