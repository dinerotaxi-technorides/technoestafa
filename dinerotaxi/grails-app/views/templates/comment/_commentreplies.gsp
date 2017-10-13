<g:if test="${( (hasMoreReplies) && (comment.replies_count>5) )}">
	<a class="load-more" style="font-size:11px" onclick='getCommentReplies(${comment.id});$(this).remove()'><g:message code="wall.show_more_replies"/></a>	
</g:if>
<g:each in="${comment.replies}" var="reply">
	<g:render model="${[comment:comment, reply:reply]}" template="/templates/comment/commentReplyItem"></g:render>	
</g:each>