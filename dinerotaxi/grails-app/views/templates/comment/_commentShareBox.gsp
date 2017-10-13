<form id="commentshareform">
	<div class="comments_add">
		<textarea id="new_post_content" name="new_post_content" class="add_comment_text watermark" placeholder="Post your comment..."></textarea>
		<g:hiddenField name="quoteTo" value="${quoteToPost}"/>
	</div>
	<div class="comments_txt">
		<small><g:message code='wall.wallhelpmessage' args='${createUrl(value:'/support')}'/></small>
	</div>
	<div class="comments_share">
		<a onclick='doAjaxComment(${g.message(code:'wall.maxLengthErrorMessage')});' class='FBshare btn'><g:message code="button.share"/></a>
		<div id='CommentShareStatusDiv'></div>
	</div>
</form>