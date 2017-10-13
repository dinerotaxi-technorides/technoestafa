<g:if test="${wallpost.votes.id.contains(session.userId)}">
	<a onclick='doLikePost(${wallpost.id}, 0);'><g:message code="wall.unlike"/></a> <i class="like"></i>								
</g:if>
<g:else>	
	<a onclick='doLikePost(${wallpost.id}, 1);'><g:message code="wall.like"/></a> <i class="like"></i>
</g:else>
<g:if test='${wallpost.likes_count>0}'>
	(<a title="<g:message code='wall.likesbox'/>" onclick='$("#wholikes_${wallpost.id}").toggle("blind");' id='likes_${wallpost.id}'>${wallpost.likes_count}</a>)
	<div id='wholikes_${wallpost.id}' class='stream-row clearfix box' style="display:none;">
	<section style="text-align: left;">
				<g:each in='${wallpost.votes}' var='userWhoLikes'>
					<a title='${userWhoLikes.name}' href="${createUrl(value:'/users/'+userWhoLikes.id)}"><img alt="" class="user-pic" src="https://graph.facebook.com/${userWhoLikes.social_id}/picture" alt="${userWhoLikes.name}" width="32" /></a>
				</g:each>
		</section>
	</div>	
</g:if>
<g:else>
(${wallpost.likes_count})
</g:else>