<g:each var="comment" in="${comments}">
	<g:render template="/templates/comment/commentItem" model="${[hasMoreReplies:hasMoreReplies, comment:comment]}"></g:render>
</g:each>
<g:if test="${hasMoreComments}">
	<div>
		<a class="load-more" onclick='getComment(false, "${quoteToPost}");$(this).parent().remove();'><g:message code="wall.show_more"/></a>
	</div>
</g:if>