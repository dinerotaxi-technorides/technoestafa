
<div class="stream-item" id='comment_${comment.id}'>
       <div class="stream-image">
		<a href="${createUrl(value:'/users/'+comment?.user?.id)}"><img class="user-pic" src="https://graph.facebook.com/${comment.user.social_id ?: 1}/picture" alt=""/></a>
	   </div>
       <div class="stream-content" style="min-height: 50px;">
		<div class="stream-row">
			<span class="stream-user-name">
				<a title="${comment.user.name}" href="${createUrl(value:'/users/'+comment?.user?.id)}"> ${comment.user.name} </a>
			</span> 
			<g:isFacebookLoggedIn>
				<span class="option">
					<g:if test='${(comment.user.id==session.userId)|| (session.isAdmin)}'>
						<a onclick='doCommentDelete(${comment.id},${comment.user.id});' class='deletePostButton'></a>
					</g:if>
				</span>
			</g:isFacebookLoggedIn>
		</div>
		<div class="stream-row">
			<span id='post_content_${comment.id}' class="stream-text">
<%--				<g:replaceSymbols value="${comment.comment}"/>--%>
					${comment.comment}
			</span> 
		</div>
		<div class="stream-row-data">
			<g:isFacebookLoggedIn>	
				<span class="stream-timestamp">${comment.datetime}</span> &middot; <span class="comment_link"><a onclick='$("#replycomment_${comment.id}").slideDown("slow", function(){ $("#reply_${comment.id }").focus(); });'><g:message code="wall.reply"/></a> &middot;						
					<span id='commentRateBox_${comment.id}'>
						<g:render template="/templates/comment/commentRating" model="${[comment:comment]}"></g:render>					
					</span>					
				</span>
			</g:isFacebookLoggedIn>	
		</div>
	</div>
		<div id="replies_${comment.id}">
			<g:if test="${comment.replies_count>0}">
				<g:render model="${[comment:comment, hasMoreReplies:hasMoreReplies]}" template="/templates/comment/commentreplies"></g:render>
			</g:if>
		</div>
		<g:isFacebookLoggedIn>	
			<g:render model="${[comment:comment]}" template="/templates/comment/commentReplyBox"></g:render>
		</g:isFacebookLoggedIn>
	<div id='morerepliesstatus_${comment.id}'></div>
</div>
<script type="text/javascript">
	$(document).ready(function(){		
		wallpostTemplateReadyActions(${comment.id});					
	});
</script>
