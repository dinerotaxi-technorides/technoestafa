<h3>Top Traders to Follow</h3>
<g:each in="${toptraders}" var="toptrader">
	<g:if test="${toptrader.id!=session.userId}">
		<a href="${createUrl(value:'/users/'+toptrader.id)}"><img  src="https://graph.facebook.com/${toptrader.social_id?:1}/picture" alt="${toptrader.name}" width="${isFacebook()=='true'?'26':'32'}" height="${isFacebook()=='true'?'26':'32'}"></a>
	</g:if>
</g:each>
