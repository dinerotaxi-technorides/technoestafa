
<div class="nav">
	<g:if test="${action == 'queEs'}">
		<div class="queEs_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeAdmin" action="queEs" />" class="queEs"></a>
	</g:else>
	<g:if test="${action == 'beneficios'}">
		 <div class="beneficios_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeAdmin" action="beneficios" />" class="beneficios"></a>
	</g:else>
	<g:if test="${action == 'comoFuncionaTaxista'}">
		 <div class="comoFunciona_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeAdmin" action="comoFunciona" />" class="comoFunciona"></a>
	</g:else>
	<g:if test="${action == 'ayuda'}">
		<div class="ayuda_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeAdmin" action="ayuda" />" class="ayuda"></a>
	</g:else>
</div>