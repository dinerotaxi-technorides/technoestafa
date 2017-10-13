            
	<g:if test="${action == 'pedido'}">
		<div class="boxTAB ml10">Mis Pedidos</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanel" action="index" />" class="boxTAB_ ml10">Mis Pedidos</a>
	</g:else>
	<g:if test="${action == 'favorites'}">
		<div class="boxTAB">Mis Favoritos</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanel" action="favorites" />" class="boxTAB_">Mis Favoritos</a>
	</g:else>
	<g:if test="${action == 'data'}">
		<div class="boxTAB">Mis Datos</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanel" action="data" />" class="boxTAB_">Mis Datos</a>
	</g:else>
	<g:if test="${action == 'calendar'}">
		<div class="boxTAB ">Mi Calendario</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanel" action="calendar" />" class="boxTAB_">Mi Calendario</a>
	</g:else>