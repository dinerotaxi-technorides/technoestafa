<table class="listings">
	<caption><g:message code='friendsbalance.title'/></caption>
	<thead>
	     <tr>
	       <th><g:message code='friendsbalance.lastweek'/></th>
	     </tr>
	</thead>
	<tbody class="small" id="friends_balance">     
		<tr><td class="no_data"><g:message code='friendsbalance.loading'/><img src="${resource(dir:'img', file:'spinner.gif')}" alt=""/></td></tr>
	</tbody>
</table>

<script type="text/javascript">
	loadFriendsBalance();
</script>