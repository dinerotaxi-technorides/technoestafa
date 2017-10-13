<aside id="sidebar"> <!-- Progress Bar -->
	<g:if test="${!error}">
		<g:if test="${!isFacebook()=='true'}">
		<div id="countdown_sidebar_bar"></div>
			<script type="text/javascript">new marketCountdown("countdown_sidebar_bar");</script>
		</g:if>
		<g:render template="/templates/common/progressbar"></g:render>
		<div id="watchlistContainer"></div>
		<g:render template="/templates/common/tips"></g:render>
		<g:render template="/templates/common/yahoonews"></g:render>
		<g:render template="/templates/common/accountinfo" model="${[portfolio:portfolio]}"></g:render>
		<g:render template="/templates/common/tradersearch"></g:render>
		<g:render template="/templates/common/positions" model="${[holdings:portfolio.short_holdings,title:'Short Positions']}"></g:render>
		<g:render template="/templates/common/positions" model="${[holdings:portfolio.long_holdings,title:'Long Positions']}"></g:render>
	</g:if>
	<g:else>
		<div class="error center"><g:message code="error.problem_ocurred"/></div>
	</g:else>
</aside>

<script type="text/javascript">
<%--	$('#sidebar').sortable({axis: 'y', placeholder: "ui-state-highlight"});--%>

	$(document).ready(function() {
		${remoteFunction(controller:'sidebar', action:'watchlists',update:'watchlistContainer')}
	});
</script>
