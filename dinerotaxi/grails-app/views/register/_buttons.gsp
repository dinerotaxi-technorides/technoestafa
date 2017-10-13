
<div class="nav">
	<g:if test="${action == 'pedir'}">
		<div class="pedirPC_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="pedirw" />" class="pediloPC"></a>
	</g:else>
	<g:if test="${action == 'movil'}">
		<div class="pediloAPP_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="movil" />" class="pediloAPP"></a>
	</g:else>
	<g:if test="${action == 'sms'}">
		<div class="pediloMOVIL_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="sms" />" class="pediloMOVIL"></a>
	</g:else>
	<g:if test="${action == 'fb'}">
		<div class="pediloFB_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="fb" />" class="pediloFB"></a>
	</g:else>
</div>