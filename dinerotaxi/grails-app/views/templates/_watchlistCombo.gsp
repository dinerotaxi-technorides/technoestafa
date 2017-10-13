<%watchlists=watchlists.sort{it.id} %>
<g:select id="watchlists" name="select" optionKey="id" onchange="getWatchList()" optionValue="name" from="${watchlists}" noSelection="['':'-Choose a watchlist-']" style="min-width:230px"/>

