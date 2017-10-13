<section class="listtable">
	<table class="listings">
		<tbody>
			<g:if test="${!error}">
				<g:if test="${users.size()>0}">
					<g:each in="${users}" var="user">
						<tr>
							<td>
								<img src="https://graph.facebook.com/${user.social_id?:1}/picture" alt=""/>
								<a href="${createUrl(value:'/users/'+user.id)}" title="View ${user.name}'s Profile">${user.name}</a>	
							</td>
						</tr>
					</g:each>
				</g:if>
				<g:else>
					<span><g:message code='tradersearch.notradersfound'/></span>
				</g:else>
			</g:if>
			<g:else>
				<tr><td class="error center"><g:message code="error.problem_ocurred"/></td></tr>
			</g:else>
		</tbody>
	</table>
</section>
