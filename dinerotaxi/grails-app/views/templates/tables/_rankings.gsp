<g:if test="${!error}">
	<g:if test="${rankings?.size()>0 && !notranked}">
		<g:each var="ranking" in="${rankings}">	
			<tr ${(ranking?.id == session.userId)?'class=\"you\"':''}>
				<td class="rank f1">${ranking?.rank}</td>
				<g:if test="${ranking?.social_id!=null}">	       
					<td class="photo"><a href="${createUrl(value:'/users/'+ranking?.id)}"><img alt="Username" title="${ranking?.name}" src="https://graph.facebook.com/${ranking?.social_id}/picture" class="user-pic"/></a></td>
					<td class="user"><a href="${createUrl(value:'/users/'+ranking?.id)}">${ranking?.name}</a></td>
				</g:if>
				<g:else>
					<td class="photo"><a href="${createUrl(value:'/users/'+ranking?.id)}"><img alt="Username" class="user-pic" title="${ranking?.name}" src="${resource(dir:'img/profiles',file:'fb_pic.jpg')}"/></a></td>
					<td class="user"><a href="${createUrl(value:'/users/'+ranking?.id)}">${ranking?.name}</a></td>
				</g:else>
<%--				<g:if test="${!showOnlyPercent}">--%>
<%--					<td><g:number value="${ranking?.difference}" letters="true" color="true" dollar="true" absolute="true"/></td>--%>
<%--				</g:if>--%>
				<td><g:number value="${ranking?.gain}" color="true" percent="true" absolute="true"/></td>
			</tr>		
		</g:each>
	</g:if>
	<g:else>
		<td class="no_data" colspan="8">Not ranked yet</td>
	</g:else>
</g:if>
<g:else>
	<g:if test="${facebookerror}">
		<td colspan="4">
			<div class="error center">
				<g:message code="error.expired"/>
				<g:form controller="ssconnect" action="facebook" name="loginFormFacebook" align="center" style="margin-top: 5px;margin-bottom: 5px;" >            
<%--			    	<input type="hidden" name="scope" value="user_about_me,read_friendlists">--%>
					<input type="hidden" name="scope" value="email" />
					<span onclick="socialLogin('Facebook')" class="fb-connect"></span>
	          	</g:form>
          	</div>
		</td>
	</g:if>
	<g:else>
		<td colspan="4">
			<div class="error center">
				<g:message code="error.problem_ocurred"/>
			</div>
		</td>
	</g:else>
</g:else>
