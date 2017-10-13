<table id="news" class="listings">
	<thead>
		<tr>
			<th><span class="left" style="color:green"><small><g:message code='stocknews.lastest'/> ${description}</small></span></th>
		</tr>
	</thead>
	<tbody id="newstable">
		<g:if test="${!error}">
			<g:each in="${items}" var="item">
				<tr>
					<td class="news">
						<span style="color:grey">${item.description.text().replaceAll('a href','a target=\"_blank\" href')}</span>
					</td>
				</tr>
			</g:each>
		</g:if>
		<g:else>
			<tr><td class="error center"><g:message code="error.problem_ocurred"/></td></tr>
		</g:else>
	</tbody>
</table>
