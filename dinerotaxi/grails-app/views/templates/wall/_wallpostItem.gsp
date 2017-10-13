
<div class="stream-item" id='wallpost_${wallpost.id}'>
	<div class="stream-image">
		<a href="${createUrl(value:'/users/' + wallpost.from.id)}"><img
			class="user-pic" alt=""
			src="https://graph.facebook.com/${wallpost.from.social_id ?: 1}/picture" />
		</a>
	</div>
	<div class="stream-content">
		<div class="stream-row">
			<span class="stream-user-name"> <a
				title="${wallpost.from.name}"
				href="${createUrl(value:'/users/' + wallpost.from.id)}">
					${wallpost.from.name} </a> </span>
		</div>
		<div id='post_content_${wallpost.id}' class="stream-row stream-text" >
					<g:secureMessageText>${wallpost.post}</g:secureMessageText>	
		</div>
		<div class="showmore"></div>
		<div class="stream-row-data">
			<span class="stream-timestamp"> ${wallpost.datetime} </span> &middot; 
			<g:isFacebookLoggedIn>
				<span>
					<g:if test='${(wallpost.from.id==session.userId) || (session.userId==userToPost) || (session.isAdmin)}'>
						<a onclick='doPostDelete(${wallpost.id},${wallpost.from.id});'>Delete</a>
					</g:if>
				</span>&middot; 
				<span class="comment_link"><a
					onclick='$("#replywallpost_${wallpost.id}").slideDown("slow", function(){ $("#reply_${wallpost.id }").focus(); });'><g:message
							code="wall.reply" /> </a> &middot; <span
					id='wallpostLikeBox_${wallpost.id}'> <g:render
							template="/templates/wall/wallpostLikeButtons"
							model="${[wallpost:wallpost]}"></g:render> </span> </span>
			</g:isFacebookLoggedIn>
		</div>
	</div>
	<div id="replies_${wallpost.id}">
		<g:if test="${wallpost.replies_count>0}">
			<g:render
				model="${[userToPost:userToPost, wallpost:wallpost, hasMoreReplies:hasMoreReplies] }"
				template="/templates/wall/wallpostreplies"></g:render>
		</g:if>

	</div>
	<g:isFacebookLoggedIn>
		<g:render model="${[wallpost:wallpost]}"
			template="/templates/wall/wallreplybox"></g:render>
	</g:isFacebookLoggedIn>
	<div id='morerepliesstatus_${wallpost.id}'></div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		wallpostTemplateReadyActions(${wallpost.id});
	});
</script>

