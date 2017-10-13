<table id="account_table" class="listings" summary="Trader Account Info">
       	<caption>Trader Account</caption>
           <thead>
           	<tr>
               	<th colspan="2"><g:message code='accountinfo.title'/></th>
			</tr>
		</thead>
           <tbody>
            <tr>
				<td>
					<g:message code="portfolio.short_balance" />
			</td>
			<td>
				<span class="neutral_value"><g:number value="${portfolio.short_balance}" letters="true" dollar="true" /></span>
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
          </tbody>
          <tfoot>
              <tr>
                  <th><g:message code="portfolio.account_value"/></th>
                  <th><g:number value="${portfolio.balance}" letters="true" dollar="true"/></th>
              </tr>
          </tfoot>
</table>