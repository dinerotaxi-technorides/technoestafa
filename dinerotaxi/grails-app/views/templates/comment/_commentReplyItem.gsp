<form id='reply_${comment.id}_${reply.id}'>
	<ul class="comment_replies">
		<li>		
			<div class="stream-image">
				<a href="${createUrl(value: '/users/' + reply.user.id)}"><img class="user-pic" src="https://graph.facebook.com/${reply.user.social_id ?: 1}/picture" alt="" /></a>
			</div>
			<div class="stream-content">
				<div class="stream-row">
					<span class="stream-user-name"><a title="${reply.user.name}" href="${createUrl(value: '/users/' + reply.user.id)}">${reply.user.name}</a></span>
					<g:isFacebookLoggedIn>
						<span style='float:right'>
							<g:if test='${(reply.user.id==session.userId)|| (session.isAdmin)}'>
								<a onclick='doCommentReplyDelete(${comment.id}, ${reply.id},${reply.user.id})' class='deletePostButton'></a>
							</g:if>
						</span>
					</g:isFacebookLoggedIn> 
				</div>
				<div class="stream-row">
					<span id='reply_content_${comment.id }_${reply.id}' class="stream-text">
<%--						<g:replaceSymbols value="${reply.content}"/>--%>
						${reply.content}
					</span> 
				</div>
				<div class="stream-row-data">
					<g:isFacebookLoggedIn>
						<span class="stream-timestamp">${reply.datetime}</span><span class="stream-action">
						
<%--						<a onclick='$("#replycomment_${comment.id}").slideDown();'><g:message code="wall.reply"/></a>&middot;						 --%>
<%--							<span id='commentReplyLikeBox_${comment.id}_${reply.id}'>							--%>
<%--								<g:if test="${ true}">--%>
<%--									<a onclick='doLikeReply(${comment.id }, ${reply.id}, 0);'><g:message code="wall.unlike"/></a> (<span id='likes_${comment.id}_${reply.id}'>${reply.status}</span>)--%>
<%--								</g:if>--%>
<%--								<g:else>--%>
<%--									<a onclick='doLikeReply(${comment.id }, ${reply.id}, 1);'><g:message code="wall.like"/></a> (<span id='likes_${comment.id}_${reply.id}'>${reply.status}</span>)--%>
<%--								</g:else>--%>
<%--							</span>							--%>
						</span>
					</g:isFacebookLoggedIn>
				</div>
			</div>
		</li>
	</ul>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		commentReplyTemplateReadyActions(${comment.id}, ${reply.id});	
	});
</script>