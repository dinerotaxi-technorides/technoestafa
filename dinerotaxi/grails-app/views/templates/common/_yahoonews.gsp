<table id="news" class="listings">
	<caption><g:message code="common.news" /></caption>
	<thead>
		<tr>
			<th>
				<span class="left">Category</span>	
				<form action="" method="post" id="form-select-feed" class="right">
					<select id="rsslist" onchange="changeRss();" name="selectedFeed" class="nomargin">
						<option value="topstories">Top Stories</option>
						<option value="usmarkets">U. S. Markets</option>
						<option value="economy">Economy</option>
						<option value="mostpopular">Most Popular</option>
						<option value="mergersaquisitions">Mergers &amp;
							Acquisitions</option>
						<option value="investingpicks">Investing Picks</option>
						<option value="banking">Banking</option>
					</select>
				</form>
			</th>
		</tr>
	</thead>
	<tbody id="newstable">
	</tbody>
</table>
	
<script type="text/javascript">
	function changeRss(){
		var item=$('#rsslist option:selected').val();
		${remoteFunction(controller:'common',action:'tablenews',update:'newstable',params:'\'item=\'+item', onLoading:"loading('newstable');")}
	}
	$(document).ready(function(){
		changeRss();
	});
</script>
	