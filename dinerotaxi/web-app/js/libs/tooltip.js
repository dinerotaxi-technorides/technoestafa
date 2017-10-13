function changeGraphicDays(count){
	document.getElementById('day').className = 'actual';
	document.getElementById('month').className = 'toLink';
	document.getElementById('year').className = 'toLink';
	var i;
	for(i=0; i<count; i++){
	   document.getElementById('backgroundDay'+i).style.display = '';
	   document.getElementById('backgroundMonth'+i).style.display = 'none';
	   document.getElementById('backgroundYear'+i).style.display = 'none';
	}
}

function changeGraphicMonth(count){
	document.getElementById('day').className ='toLink';
	document.getElementById('month').className ='actual';
	document.getElementById('year').className ='toLink';
	var i;
	for(i=0; i<count; i++){
	   document.getElementById('backgroundDay'+i).style.display = 'none';
	   document.getElementById('backgroundMonth'+i).style.display = '';
	   document.getElementById('backgroundYear'+i).style.display = 'none';
	}
}

function changeGraphicYear(count){
	document.getElementById('day').className ='toLink';
	document.getElementById('month').className ='toLink';
	document.getElementById('year').className ='actual';
	var i;
	for(i=0; i<count; i++){
	   document.getElementById('backgroundDay'+i).style.display = 'none';
	   document.getElementById('backgroundMonth'+i).style.display = 'none';
	   document.getElementById('backgroundYear'+i).style.display = '';
	}   
}

function callTooltipTrades(tradesTotal){
	$('#trades_total_content').html(tradesTotal+' trades');
} 

function showTooltip(e) {
    
    var tooltip = document.getElementById("tooltip");
    
    //TODO
  //  var top = (e.getAbsoluteTop() - document.getRootElement().getAbsoluteTop()) - 182;
  //  var left = (e.getAbsoluteLeft() - document.getRootElement().getAbsoluteLeft() - 15 );
    
      
     var position = $(e).offset();
     var root_position = $("#iframe_content").offset();
      var top = (position.top - root_position.top) - 182;
      var left = (position.left - root_position.left - 15);

 //    var top = (position.top) - 182;
 //    var left = (position.left - 15 );
     
     
     
    tooltip.style.top =  top + "px";
    tooltip.style.left = left + "px";
    tooltip.style.display = "block";

}

function hideTooltip() {
    var tooltip = document.getElementById("tooltip");
    tooltip.style.display = 'none';
}

/* AJAX LOADING (no se esta usando) */

function loadingGraphicAjax(description,symbol){ 
	$('#stock_chart').html('<div class="loading_message">Loading...</div>');
//	var loadingMessage = "loadingTest";
//	 document.getElementById('stock_chart').setInnerFBML(loadingMessage);
    
	
	//TODO
	/* 
	var ajax = new Ajax();
  	 ajax.responseType = Ajax.FBML;
  	 ajax.requireLogin = true;
  	 ajax.ondone = function(data) {
        document.getElementById('stock_chart').innerHTML(data); 
	 };
	 */
	 var queryParams = { "param1": description, "param2": symbol };

	 $.post("<?=$this->baseUrl()?>watchlist/watchlistAjax", queryParams, 
			 function(data){
		 		$('#stock_chart').html(data); 
			}
	 );
	 
	 //TODO
	 //ajax.onerror = function() { show_error_dialog(el); };

	 
        
 	 //ajax.post('<?=$this->fBCallbackUrl ()?>watchlist/watchlistAjax',queryParams);
}


