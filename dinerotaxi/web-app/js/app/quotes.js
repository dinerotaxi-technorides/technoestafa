function initQuotes(symbol,description,google_symbol){
	var type = google_symbol!=''?'indexnews':'stocknews';
	if (!isFacebook){
		loading('sidebarContainer');
		$.ajax({
	    	type:'POST',
	    	data:'symbol='+symbol + '&description='+description, 
	    	url: baseAppUrl + '/common/'+type,
	    	success:function(data){
	    		$('#sidebarContainer').html(data);
		    }
	    });
	}else{
		$('#body_section').removeClass("span-12");
		$('#body_section').addClass("span-19");
		$('#sidebar_section').remove();
		loading('stockNews');
		$.ajax({
	    	type:'POST',
	    	data:'symbol='+symbol + '&description='+description, 
	    	url: baseAppUrl + '/common/'+type,
	    	success:function(data){
		    	$('#stockNews').html(data);
		    }
	    });
	}
	if (google_symbol!=''){
		symbol=google_symbol;
	}
	$.ajax({
    	type:'POST',
    	data:'symbol='+symbol + '&description='+description, 
    	url: baseAppUrl + '/stock/googleGraph',
    	success:function(data){
	    	$('#chart').html(data);
	    }
    });
}

