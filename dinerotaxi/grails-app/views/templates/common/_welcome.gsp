<g:if test="${params.controller=='index'}">
	<div class="well clearfix">
	       <h1><g:message code="welcome.title"/></h1>
	       <p><g:message code="welcome.subtitle"/></p>
	       <h4><a href="#" onclick="socialLogin('Facebook')" class="btn success large"><g:message code="welcome.start_trading_now"/></a> <g:message code="welcome.learn_more" args="${[application.getContextPath()+'/about']}"/></h4>
		<hr class="dot"/>  
		<div class="span-7 colspace">
			<h3><g:message code="welcome.title1"/></h3>
			<p><g:message code="welcome.text1"/></p>
		</div>
		<div class="span-6 colspace">
			<h3><g:message code="welcome.title2"/></h3>
			<p><g:message code="welcome.text2"/></p>
		</div>
		<div class="span-7 last">
			<h3><g:message code="welcome.title3"/></h3>
			<p><g:message code="welcome.text3"/></p>
		</div>
	</div>
	<div class="wiki"><g:message code="welcome.ready_to_start" args="${['socialLogin(\'Facebook\')']}"/></div>	
</g:if>