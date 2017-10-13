<g:if test="${!error}">
	<h3 class="title">
		<img src="${'https://static.dinerotaxi.com/symbols/icon/'+symbol+'.ico'}" align="absmiddle" alt=""/>
		<g:capitalize value="${description}"/> 
		<span class="mkt">(${stock.exchange.text()})</span> 
		<img id="popoverLoading" class="right" style="display:none;" src="${resource(dir:'img',file:'indicator.gif')}"/>
	</h3>
	<div class="content">
		<div class="span-2">	
			<img class="logoCompany" height=24 src="${'https://static.dinerotaxi.com/symbols/logo/'+symbol+'.gif'}" alt=""/>
		</div>
		<div class="span-2"  style="margin-left:10px;">			
			<h6>Last Price</h6>
			<p><g:number value="${stock.last.text()}" color="true" dollar="true"/></p>
		</div>	
		<div class="span-2">	
			<h6>Change</h6>
			<p><span><g:number value="${stock.change.text()}" color="true" percent="true"/></span></p>
			
		</div>
		<hr class="space"/>
		<img class="graphicCompany" src='http://www.google.com/finance/chart?cht=c&q=${symbol}&tlf=12h' height="130" width="250" alt=""/>
</div>
</g:if>
<g:else>
	<div class="center" style="color:#FFFFFF">
		This symbol does not exist
		<img id="popoverLoading" style="display:none;" src="${resource(dir:'img',file:'indicator.gif')}"/>
	</div>
</g:else>

