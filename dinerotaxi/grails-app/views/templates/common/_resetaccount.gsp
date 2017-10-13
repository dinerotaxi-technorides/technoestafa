<span class="right"><button class="btn danger"
		onclick="showModal()"><g:message code='resetaccount.title'/></button>
</span>
<div id="confirmation" style="display: none" title="Tradefields Account">
	<h4><g:message code='resetaccount.question'/></h4>
	<g:message code='resetaccount.warning'/>
</div>


<div id="resetModalDialog" class="modal" style="display: none">
	<div class="modal-header">
		<h3>Reset Account?</h3>
		<a href="" class="close">&times;</a>
	</div>
	<div class="modal-body">
		<h4><g:message code='resetaccount.warning'/></h4>
	</div>
	<div class="modal-footer">
		<a onclick="resetAccount();" class="btn danger"><g:message code='resetaccount.reset'/></a>
		<a onclick="$(this).parent().parent().overlay().close();" class="btn secondary"><g:message code='resetaccount.cancel'/></a>
	</div>
</div>
