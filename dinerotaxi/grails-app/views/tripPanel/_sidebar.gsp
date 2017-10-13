	<g:if test="${action == 'search'}">
		<div class="boxTAB boxTABfxx">Cuenta Corriente</div>
	</g:if>
	<g:else>
	     <a class="boxTAB_ ml10 boxTABfxx" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="tripPanel" action="index"/>">Cuenta Corriente</a>	
	</g:else>
		<g:if test="${action == 'users'}">
		<div class="boxTAB ">Usuarios</div>
	</g:if>
	<g:else>
	     <a class="boxTAB_ ml10 " href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="tripPanel" action="users"/>">Usuarios</a>	
	</g:else>
		<g:if test="${action == 'history'}">
		     <div class="boxTAB">Historial de Pedidos</div>
	</g:if>
	<g:else>
		<a class="boxTAB_" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="tripPanel" action="historyTrips"/>"> Historial de Pedidos</a>
     
	</g:else>
		<g:if test="${action == 'employ'}">
		     <div class="boxTAB">Empleados/Taxistas</div>
	</g:if>
	<g:else>
		<a class="boxTAB_" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="employAdmin" action="index"/>">Empleados/Taxistas</a>
     
	</g:else>
		<g:if test="${action == 'cars'}">
		     <div class="boxTAB">Autos</div>
	</g:if>
	<g:else>
		 <a class="boxTAB_" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="employAdmin" action="vehicle"/>">Autos</a>
		
	</g:else>
	<g:if test="${action == 'data'}">
		<div class="boxTAB ">Mis Datos</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelCompany" action="data" />" class="boxTAB_">Mis Datos</a>
	</g:else>