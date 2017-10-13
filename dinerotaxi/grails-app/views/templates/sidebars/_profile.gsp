<aside id="sidebar"> <!-- Progress Bar -->
	<g:if test="${!error}">
		<g:render template="/templates/common/accountinfo" model="${[portfolio:portfolio]}"></g:render>
		<g:render template="/templates/common/positions" model="${[holdings:portfolio.short_holdings,title:'Short Positions']}"></g:render>
		<g:render template="/templates/common/positions" model="${[holdings:portfolio.long_holdings,title:'Long Positions']}"></g:render>
		<g:if test="${session.userId}">
			<g:if test="${session.userId==userId}">
				<g:render template="/templates/rankings/friendsalltime"></g:render>
			</g:if>
		</g:if>
	</g:if>
	<g:else>
		<div class="error center"><g:message code="error.problem_ocurred"/></div>
	</g:else>
</aside>
<script type="text/javascript">
	$('#sidebar').sortable({axis: 'y', placeholder: "ui-state-highlight"});
</script>
