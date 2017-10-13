<g:if test="${( (hasMoreReplies) && (wallpost.replies_count>5) )}">
	<a class="load-more"style="font-size:11px" onclick='getReplies(${wallpost.id});$(this).remove()'><g:message code="wall.show_more_replies"/></a>	
</g:if>
<g:each in="${wallpost.replies}" var="reply">
	<g:render model="${[userToPost:userToPost, wallpost:wallpost,reply:reply]}" template="/templates/wall/wallpostReplyItem"></g:render>	
</g:each>