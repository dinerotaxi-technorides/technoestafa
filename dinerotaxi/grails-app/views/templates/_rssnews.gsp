<ul id="news_rss">
	<g:if test="${!error}">
		<g:each in="${items}" var="item">
			<li><a href="${item.link.text()}" target="_blank">${item.title.text()}</a></li>
		</g:each>
	</g:if>
	<g:else>
		<li><a><g:message code="error.problem_ocurred"/></a></li>
	</g:else>
</ul>
