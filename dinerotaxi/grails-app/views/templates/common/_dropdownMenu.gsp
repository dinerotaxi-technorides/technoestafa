<ul class="menu-dropdown" style="position:fixed; display:none;">
	<li><a href="${application.getContextPath()}/profile"><g:message code='dropdownmenu.profile'/></a></li>
	<li><a href="${application.getContextPath()}/watchlists"><g:message code='dropdownmenu.watchlist'/></a></li>
	<li><a href="${application.getContextPath()}/settings"><g:message code='dropdownmenu.settings'/></a></li>
	<li><a href="${application.getContextPath()}/help"><g:message code='dropdownmenu.help'/></a></li>
	<li class="divider"></li>
	<li class="signout">
		<g:form controller="ssconnect" action="facebook" name="loginFormFacebook" align="center">            
			<input type="hidden" name="_method" value="DELETE" id="_method">
			<a onclick="socialLogin('Facebook');">Sign Out</a>
		</g:form>
	</li>
</ul>