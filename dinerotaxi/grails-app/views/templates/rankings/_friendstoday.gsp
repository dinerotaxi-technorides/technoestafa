<table class="listings">
	<g:if test="${params.controller!='ranking'}">
		<caption><g:message code='ranking.friendstoday'/></caption>
	</g:if>
	<thead>
	     <tr>
	       <th><g:message code='ranking.rank'/></th>
	       <th><g:message code='ranking.photo'/></th>
	       <th><g:message code='ranking.user'/></th>
	       <th><g:message code='ranking.return'/></th>
	     </tr>
	</thead>
	<tbody id="friends_today">          
	    	<tr>
			<td class="no_data" colspan="8">Loading... <img
				src="${resource(dir:'img', file:'spinner.gif')}" alt="" />
			</td>
		</tr>
	</tbody>
	<tfoot>
	</tfoot>    
</table>

<script type="text/javascript">
	loadFriendsToday();
</script>