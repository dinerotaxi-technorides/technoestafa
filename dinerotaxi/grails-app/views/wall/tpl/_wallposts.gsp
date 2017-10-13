<g:each var="wallpost" in="${wallPosts}">
	<g:render template="/templates/wall/wallpostItem" model="${[userToPost:userToPost, hasMoreReplies:hasMoreReplies, wallpost:wallpost]}"></g:render>
</g:each>
<g:if test="${hasMorePosts}">
	<div>
		<a id='load-more-wallposts' class="load-more" onclick='getWall(false, ${userToPost});$(this).parent().remove();'><g:message code="wall.show_more"/></a>
	</div>
</g:if>
