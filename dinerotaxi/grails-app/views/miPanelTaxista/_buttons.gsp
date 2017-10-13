            
	<g:if test="${action == 'pedido'}">
		<div class="boxTAB ml10">Mis Viajes</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelTaxista" action="index" />" class="boxTAB_ ml10">Mis Viajes</a>
	</g:else>
	<g:if test="${action == 'favorites'}">
		<div class="boxTAB">Mis Clientes</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelTaxista" action="clients" />" class="boxTAB_">Mis Clientes</a>
	</g:else>
	<g:if test="${action == 'data'}">
		<div class="boxTAB">Mis Datos</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelTaxista" action="data" />" class="boxTAB_">Mis Datos</a>
	</g:else>
	<g:if test="${action == 'calendar'}">
		<div class="boxTAB ">Mi Calendario</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelTaxista" action="calendar" />" class="boxTAB_">Mi Calendario</a>
	</g:else>