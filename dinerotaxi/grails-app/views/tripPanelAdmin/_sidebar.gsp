	<g:if test="${action == 'online'}">
		<div class="boxTABSS boxTABfxx">ORTAXI</div>
	</g:if>
	<g:else>
	     <a class="boxTABSS_ ml10 boxTABfxx" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="adminUser" action="online"/>">ORTAXI</a>	
	</g:else>
	
		<g:if test="${action == 'trips'}">
		     <div class="boxTABSS">Trips</div>
	</g:if>
	<g:else>
		<a class="boxTABSS_" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="tripPanelAdmin" action="index"/>">Trips</a>
     
	</g:else>
		<g:if test="${action == 'company'}">
		     <div class="boxTABM">Company</div>
	</g:if>
	<g:else>
		<a class="boxTABM_" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="adminUser" action="index"/>">Company</a>
     
	</g:else>
		<g:if test="${action == 'cc'}">
		     <div class="boxTABSS">CC</div>
	</g:if>
	<g:else>
		<a class="boxTABSS_" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="adminUser" action="companyAccount"/>">CC</a>
     
	</g:else>
		<g:if test="${action == 'user'}">
		     <div class="boxTABSS">Users</div>
	</g:if>
	<g:else>
		 <a class="boxTABSS_" href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="adminUser" action="usuarios"/>">Users</a>
		
	</g:else>
	<g:if test="${action == 'configurationApp'}">
		<div class="boxTABSS ">Config</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="configurationApp"/>" class="boxTABSS_">Config</a>
	</g:else>
	<g:if test="${action == 'supportAdmin'}">
		<div class="boxTABSS">Cservice</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="supportAdmin"  />" class="boxTABSS_">Cservice</a>
	</g:else>
	<g:if test="${action == 'enabledCitiesAdmin'}">
		<div class="boxTABSS ">Cities</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="enabledCitiesAdmin" />" class="boxTABSS_">Cities</a>
	</g:else>
	<g:if test="${action == 'settingsPromotions'}">
		<div class="boxTABM ">Promotions</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="settingsPromotions"/>" class="boxTABM_">Promotions</a>
	</g:else>
	<g:if test="${action == 'spam'}">
		<div class="boxTABSS ">Spam</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="spam"/>" class="boxTABSS_">Spam</a>
	</g:else>
	<g:if test="${action == 'audit'}">
		<div class="boxTABSS ">In/Out</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="incomeAndExcome" />" class="boxTABSS_">In/Out</a>
	</g:else>
	<g:if test="${action == 'stadistic'}">
		<div class="boxTABSS ">Stadistic</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="homeAdmin" />" class="boxTABSS_">Stadistic</a>
	</g:else>
	<g:if test="${action == 'role'}">
		<div class="boxTABSS ">Role</div>
	</g:if>
	<g:else>
		<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="roleAdmin" />" class="boxTABSS_">Role</a>
	</g:else>