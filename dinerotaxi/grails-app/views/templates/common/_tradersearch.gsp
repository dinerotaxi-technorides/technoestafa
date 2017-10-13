<table class="listings">
	<thead>
		<tr>
			<th colspan="2" style="color: green">
				<span class="left"><g:message code='tradersearch.searchuser'/></span>
				<div align="right"><a class="help" title='${message(code:'help.search_user')}'>?</a></div>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><input type="text" id="search_user" class="search" placeholder="${message(code:'tradersearch.lookingforfriend')}"
				autocomplete="off" name="q" maxlength="20" size="20" id="q">
				<button onclick="seachUsers()" class="btn success"><g:message code='tradersearch.search'/></button></td>
		</tr>
	</tbody>
</table>


<div id="searchModalDialog" class="modal" style="display:none">
	<div class="modal-header">
	  <h3><g:message code='tradersearch.tradersfound'/></h3>
	  <a href="" class="close">&times;</a>
	</div>
	<div class="modal-body">
	  <div id="searchBox"></div>
	</div>
	<div class="modal-footer">
	  <a href="#" onclick="$(this).parent().parent().overlay().close();"class="btn secondary"><g:message code='tradersearch.ok'/></a>
	</div>
</div>
