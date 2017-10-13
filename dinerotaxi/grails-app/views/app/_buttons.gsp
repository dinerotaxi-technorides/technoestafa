
<ul class="tabs">
	<g:if test="${action == 'pedido'}">
		<li><a href="#tab1">Pedir</a></li>
	</g:if>
	<g:else>
		<li><a href="#tab1">Pedir</a></li>
	</g:else>
	<g:if test="${action == 'favorites'}">
		<li><a href="#tab2">Mis Pedidos</a></li>
	</g:if>
	<g:else>
		<li><a href="#tab2">Mis Pedidos</a></li>
	</g:else>
	<g:if test="${action == 'data'}">
		<li><a href="#tab3">Mis Datos</a></li>
	</g:if>
	<g:else>
		<li><a href="#tab3">Mis Datos</a></li>
	</g:else>

</ul>