<form id="wallpostshareform">
	<div class="comments_add">
		<textarea id="new_post_content" name="new_post_content" class="add_comment_text watermark" placeholder="Post your comment..."></textarea>
		<g:hiddenField name="userIdTo" value="${userToPost}"/>
	</div>
	<div class="comments_txt">
		<small><g:message code='wall.wallhelpmessage' args="${[createUrl(value:'/support')]}"/></small>
	</div>
	<div class="comments_share">
		<a onclick='doAjaxWallPost(${g.message(code:'wall.maxLengthErrorMessage')});' class='btn share'><g:message code="button.share"/></a>
		<div id='WPShareStatusDiv'></div>
	</div>
</form>