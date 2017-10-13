
<div class="nav">
	<g:if test="${action == 'queEs'}">
		<div class="queEs_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="queEs" />" class="queEs"></a>
	</g:else>
	<g:if test="${action == 'beneficios'}">
		 <div class="beneficios_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="beneficios" />" class="beneficios"></a>
	</g:else>
	<g:if test="${action == 'comoFuncionaTaxista'}">
		 <div class="comoFunciona_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="comoFuncionaTaxista" />" class="comoFunciona"></a>
	</g:else>
	<g:if test="${action == 'registroTaxista'}">
		<div class="registrateAhora_"></div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="registro" />" class="registrateAhora"></a>
	</g:else>
</div>