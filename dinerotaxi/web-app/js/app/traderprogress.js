function loadProfileSideBarProgress(){
	$.ajax({
	type : 'GET', 
	url: baseAppUrl + '/common/profileProgressBarData',
		dataType: 'json',
		success: function(data){
			calculateProgressPercent(data);	
		}	
	});	
}

function calculateProgressPercent(progressData){
	var percent=0;
	var percentItem=(100/getTraderProgressItemCount());	
	
	if(progressData.installed){							
		percent+=percentItem;
	}
	
	if(updateBookmarkItem(progressData.bookmarked)){
		percent+=percentItem;			
	}
	if(updateLikeItem(progressData.like_page)){
		percent+=percentItem;
	}
	
	if(updatePermissionsItem(progressData.permissions)){
		percent+=percentItem;				
	}
	
	// --- Disable Twitter Integration START!
	
	$("#trader_progress").find("#twitter_linked").hide();
	/*if(updateTwitterIntegration(progressData.twitter)){
		percent+=percentItem;
	}*/
	
	// --- Disable Twitter Integration END!
		
	if(percent>=100){				
		$("#trader_progress").remove();	
	}else{
		updateProgressBar(percent);			
	}
}

function updateBookmarkItem(status){
	if(status){
		$("#trader_progress").find("#bookmark_linked").show();
		$("#trader_progress").find("#bookmark_link").hide()
		return true;
	}else{
		$("#trader_progress").find("#bookmark_linked").hide();			
		$("#trader_progress").find("#bookmark_link").show();
		return false;
	}
}

function updateLikeItem(status){
	FB.XFBML.parse();
	return status;
}

function updatePermissionsItem(status){
	if(status){					
		$("#trader_progress").find("#permissions_linked").show();
		$("#trader_progress").find("#permissions_link").hide();
		return true;
	}else{
		$("#trader_progress").find("#permissions_linked").hide();
		$("#trader_progress").find("#permissions_link").show();
		return false;
	}
}

function updateTwitterLinked(status){
	if(status){					
		$("#trader_progress").find("#twitter_linked").show();
		$("#trader_progress").find("#twitter_link").hide();
		return true;
	}else{
		$("#trader_progress").find("#twitter_linked").hide();
		$("#trader_progress").find("#twitter_link").show();
		return false;
	}
}

function updateProgressBar(percent){
	if($("#trader_progress").is(":visible")){
		$("#trader_progress").fadeOut(function(){
			setTraderProgressValue(percent);			
			$("#trader_progress").fadeIn();			
		});
	}else{
		setTraderProgressValue(percent);	
		$("#trader_progress").fadeIn();
	}
}

function setTraderProgressValue(percent){
	percent=Math.round(percent*100)/100;
	$("#trader_progress_bar").progressbar({
		value: percent
	});
	$(".ui-progressbar-value").html(percent + "%");						
}

function getTraderProgressValue(){
	var value=$(".ui-progressbar-value").html();
	if(value.length>0){
		return parseInt(value.substring(0, value.length-1));		
	}else{
		return 0;
	}
}

function getTraderProgressItemCount(){
	return 4;
}