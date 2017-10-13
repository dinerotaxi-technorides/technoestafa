<div class='wallreplybox clearfix' id='wallreplybox_${wallpost.id}'>
	<form id='replywallpost_${wallpost.id}' style="display:none;" action="">
		<g:hiddenField name="wallpostid" value="${wallpost.id}"/>
		<g:textArea name="reply" id="reply_${wallpost.id}" style="width:98%;" placeholder="Post your reply..."></g:textArea>		
		<div class="right">
			<a onclick='$("#replywallpost_${wallpost.id}").slideUp();' class='btn'><g:message code="button.cancel"/></a>
			<a onclick='doAjaxReply(${wallpost.id}, ${g.message(code:'wall.maxLengthErrorMessage')});' class="btn FBshare"><g:message code="button.post"/></a>
		</div>
	</form>
	<script type="text/javascript">
		$("#replywallpost_${wallpost.id}").submit(function() {
			  return false;
		});
	</script>
</div>