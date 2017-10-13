<div id="modalDialog" class="modal" style="margin-top: 0px; margin-right: auto; margin-bottom: 0px; margin-left: auto; z-index: 2000; top: 94.4px; left: 671.5px; position: absolute; ">
	<div class="modal-header">
		<h3>${title }</h3>
		<a href="#" class="close">×</a>
	</div>
	<div class="modal-body">
		<p>${message }</p>
	</div>
	<div class="modal-footer">
		<a href="#" class="btn secondary" onclick="$('#modalDialog').remove();${callbackFunction};">${buttonText}</a>
	</div>
</div>