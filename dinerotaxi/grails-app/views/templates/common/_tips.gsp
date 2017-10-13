<g:if test="${!session.dismissTips}">
	<div class="box tips" id="table_tips">
		<a class="hide" onclick='closeTip()'>&times;</a>
		<div class="item-tips" id="tipsContainer">
		</div>
	</div>
</g:if>


<script type="text/javascript">
	var first =true;
	function closeTip(){
		$("#table_tips").fadeOut();
		${remoteFunction(controller:'common',action:'dismissTips')}
	}

	function nextTip(){
		${remoteFunction(controller:'tip',action:'nextTip',update:'tipsContainer', onSuccess: '$("#table_tips").fadeIn();', onLoading:'loadingTip();')}
	}
	
	function loadingTip(){
		if(!first){
			$("#table_tips").fadeOut();
		}else{
			loading('tipsContainer');
			first=false;
		}
	}
	
	$(document).ready(function() {
		nextTip();
	});
</script>