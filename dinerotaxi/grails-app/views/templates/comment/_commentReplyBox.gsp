<div class='commentreplybox clearfix' id='commentreplybox_${comment.id}'>
	<form id='replycomment_${comment.id}' style="display:none;" action="">
		<g:hiddenField name="commentid" value="${comment.id}"/>
		<g:textArea name="reply" id="reply_${comment.id}" style="width:98%;" placeholder="Post your reply..."></g:textArea>		
		<div class="right">
			<a onclick='doAjaxCommentReply(${comment.id}, ${g.message(code:'wall.maxLengthErrorMessage')});' class="FBshare btn"><g:message code="button.post"/></a>
			<a onclick='$("#replycomment_${comment.id}").slideUp();' class='btn'><g:message code="button.cancel"/></a>
		</div>
	</form>
	<script type="text/javascript">
		$("#replycomment_${comment.id}").submit(function() {
			  return false;
		});
	</script>
</div>