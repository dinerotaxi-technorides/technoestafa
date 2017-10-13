<g:if test="${friends.size()>0}">
	<h3>Your Friends</h3>
	<g:each in="${friends}" var="friend">
		<g:if test="${friend.id!=session.userId}">
			<a href="${createUrl(value:'/users/'+friend.id)}"><img  src="http://graph.facebook.com/${friend.social_id?:1}/picture" alt="${friend.name}" width="32" height="32"></a>
		</g:if>
	</g:each>
</g:if>
<g:else>
	<h4><g:message code='notifications.nofriends'/></h4>
</g:else>

