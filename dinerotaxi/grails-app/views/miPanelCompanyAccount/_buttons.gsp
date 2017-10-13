                       
	<g:if test="${action == 'credits'}">
		<div class="boxTAB ml10">Facturación</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelCompanyAccount" action="index" />" class="boxTAB_ ml10">Facturación</a>
	</g:else> 
	<g:if test="${action == 'employee'}">
		<div class="boxTAB">Empleados</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelCompanyAccount" action="employee" />" class="boxTAB_">Empleados</a>
	</g:else>
	<g:if test="${action == 'controlTrips'}">
		<div class="boxTAB">Control de viajes</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelCompanyAccount" action="controlTrips" />" class="boxTAB_">Control de viajes</a>
	</g:else>
	<g:if test="${action == 'data'}">
		<div class="boxTAB">Mis Datos</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelCompanyAccount" action="data" />" class="boxTAB_">Mis Datos</a>
	</g:else>
	<g:if test="${action == 'calendar'}">
		<div class="boxTAB ">Mi Calendario</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="miPanelCompanyAccount" action="calendar" />" class="boxTAB_">Mi Calendario</a>
	</g:else>