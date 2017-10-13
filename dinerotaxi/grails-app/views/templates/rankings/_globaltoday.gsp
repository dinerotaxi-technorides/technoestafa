<table class="listings">
	<g:if test="${params.controller!='ranking'}">
		<caption><g:message code='ranking.globaltoday'/></caption>
	</g:if>
	<thead>
	     <tr>
	       <th><g:message code='ranking.rank'/></th>
	       <th><g:message code='ranking.photo'/></th>
	       <th><g:message code='ranking.user'/></th>
	       <th><g:message code='ranking.return'/></th>
	     </tr>
	</thead>
	<tbody id="global_today">          
	    	<tr>
			<td class="no_data" colspan="8">Loading... <img
				src="${resource(dir:'img', file:'spinner.gif')}" alt=""/>
			</td>
		</tr>
	</tbody>
	<tfoot>
		<g:if test="${params.controller!='ranking' && params.action!='guestSidebar'}">
		     <tr>
		        <th colspan="9" scope="colgroup"> <g:link  params="[country:"${params?.country?:''}"]" title="View Full Rankings" controller="ranking"><g:message code='ranking.fullranking'/></g:link></th>
		     </tr>
		</g:if>
	</tfoot>    
</table>

<script type="text/javascript">
	var controller = '${params.controller}';
	if (controller!='ranking'){
		loadGlobalGuestToday();
	}else{
		loadGlobalToday();
	}
</script>
