<g:if test="${!error}">
	<g:each in="${items}" var="item">
		<tr>
			<td class="news">
				<h6><a href="${item.link.text()}" target="_blank">${item.title.text()}</a></h6>
				<p>${item.description.text()}</p>
			</td>
		</tr>
	</g:each>
</g:if>
<g:else>
	<tr><td class="error center"><g:message code="error.problem_ocurred"/></td></tr>
</g:else>