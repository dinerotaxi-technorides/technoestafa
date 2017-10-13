<aside id="sidebar">
	<g:if test="${!error}">
		<g:render template="/templates/common/accountvaluehistory" model="${[hstats:hstats]}"></g:render>
		<g:render template="/templates/common/accountinfo" model="${[portfolio:portfolio]}"></g:render>
		<g:render template="/templates/common/resetaccount" model="${[portfolio:portfolio]}"></g:render>
	</g:if>
	<g:else>
		<div class="error center"><g:message code="error.problem_ocurred"/></div>
	</g:else>
</aside>