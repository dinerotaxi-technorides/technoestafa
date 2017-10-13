function initIndexFB(){
	$('#body_section').addClass("span-12");
	$.ajax({
    	type:'GET',
    	url: baseAppUrl + '/sidebar/indexSidebar',
    	success:function(data){
	    	$('#sidebarContainer').html(data);
	    	loadProfileSideBarProgress();
	    }
    });	
}


function initIndex(){
	$('#body_section').addClass("span-18");
	if (isLogged()){
		$.ajax({
	    	type:'GET',
	    	url:baseAppUrl + '/sidebar/indexSidebar',
	    	success:function(data){
		    	$('#sidebarContainer').html(data);
		    	loadProfileSideBarProgress();
		    }
	    });		   
	}else{
		$.ajax({
	    	type:'GET',
	    	url: baseAppUrl + '/sidebar/guestSidebar',
	    	success:function(data){
		    	$('#sidebarContainer').html(data);
		    }
	    });	
	}
}


function getSideWatchlist(element){
	var selectedOption = element.selectedIndex;
	if(selectedOption!=0){
		var watchid = element.options[selectedOption].value;
		loadSideWatchlist(watchid);
	}else{
		setVisibleSideWatchInfo(false);
    }
}


function setVisibleSideWatchInfo(val){
	if(val){
		$('#tickets').show(/*'blind'*/);
	}else{
		$('#tickets').hide(/*'blind'*/);
	}
}

function loadSideWatchlist(id){
	var watchid=id;
	$.ajax({
    	type:'POST',
    	data:'watchid='+watchid, 
    	url:baseAppUrl + '/sidebar/getWatchlist',
    	beforeSend: function(){
	    	loading('tickets');
	    },
    	success:function(data, textStatus){
	    	$('#tickets').html(data);				    	
	    	setVisibleSideWatchInfo(true);
	    }
	});
}


function selectSideWatchlist(){
	var index = $('option:selected', '#watchlistCombo').index()
	if(index!=0){
		var watchid = $('option:selected', '#watchlistCombo').val()
		window.open(baseAppUrl + "/watch/show?wid=" + watchid,'_self');
    }
}

function setVisibleWatchInfo(val){
	if(val){
		$('#tickets').show(/*'blind'*/);
	}else{
		$('#tickets').hide(/*'blind'*/);
	}
}

function changeOptions(symbol){
	$('#'+symbol+"_last_price").hide();
	$('#'+symbol+"_change").hide();
	$('#'+symbol+"_trade_actions").show();
	$('#'+symbol+"_remove").show();
}
function changeInfo(symbol){
	$('#'+symbol+"_trade_actions").hide();
	$('#'+symbol+"_remove").hide();
	$('#'+symbol+"_last_price").show();
	$('#'+symbol+"_change").show();
}

