<g:if test="${!error}">
	<table class="listings">
	<thead>
		<tr>
			<th colspan="2" style="color: green">
				<span class="left">Watchlists</span>
				<div align="right"><a class="help" title='${message(code:'watchlist.description.tip')}'>?</a></div>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<g:if test="${watchlists==null || watchlists.size()==0}">
					<input type="text" id="watchname" class="search" placeholder="Create watchlist"	autocomplete="off" name="q" maxlength="20" size="20" id="q"/>
					<button onclick="createWatchlist()" class="btn success">Create</button>
				</g:if>
				<g:else>
					<div id="watchlistCombo"  class="right">
						<%watchlists=watchlists.sort{it.id}%>
						<g:select id="sidewatchlist"  onchange="getSideWatchlist(this);" name="select" optionKey="id" optionValue="name" from="${watchlists}" noSelection="['':'Choose a watchlist']" style="min-width:255px"/>	
					</div>
					<div id="tickets"></div>
				</g:else>
			</td>
		</tr>
	</tbody>
</table>
</g:if>
<g:else>
	<div class="error"><g:message code='watchlist.errorload'/></div>
</g:else>
