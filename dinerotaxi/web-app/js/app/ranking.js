var global = 0;
var friends = 0;

function initRankings(){
	$('#body_section').removeClass("span-18");
	if (isFacebook){
		$('#body_section').addClass("span-19");
	}else{
		$('#body_section').addClass("span-25");
	}
	$('#sidebar_section').remove();
}

function changeGlobal(){
	if(global==0){
		$("#ranking_global_today").hide();
		$("#ranking_global_all_time").show();
		global = 1;
	}else{
		$("#ranking_global_all_time").hide();
		$("#ranking_global_today").show();
		global = 0;
	}
}

function changeFriends(){
	if(friends==0){
		$("#ranking_friends_today").hide();
		$("#ranking_friends_all_time").show();
		friends = 1;
	}else{
		$("#ranking_friends_all_time").hide();
		$("#ranking_friends_today").show();
		friends = 0;
	}
}

function loadFriendsToday(){
	$.ajax({
    	type:'GET',
    	url:baseAppUrl + '/ranking/friendsToday',
    	success:function(data){
	    	$('#friends_today').html(data);
	    }
    });		    
}


function loadFriendsAllTime(){
	$.ajax({
    	type:'GET',
    	url:baseAppUrl + '/ranking/friendsAllTime',
    	success:function(data){
	    	$('#friends_all_time').html(data);
	    }
    });		    
}

function loadGlobalGuestToday(){
	$.ajax({
    	type:'GET',
    	url:baseAppUrl + '/ranking/globalGuestToday',
    	success:function(data){
	    	$('#global_today').html(data);
	    }
    });		    
}

function loadGlobalToday(){
	$.ajax({
    	type:'GET',
    	url:baseAppUrl + '/ranking/globalToday',
    	success:function(data){
	    	$('#global_today').html(data);
	    }
    });		    
}

function loadGlobalGuestAllTime(){
	$.ajax({
    	type:'GET',
    	url:baseAppUrl + '/ranking/globalGuestAllTime',
    	success:function(data){
	    	$('#global_all_time').html(data);
	    }
    });		    
}

function loadGlobalAllTime(){
	$.ajax({
    	type:'GET',
    	url:baseAppUrl + '/ranking/globalAllTime',
    	success:function(data){
	    	$('#global_all_time').html(data);
	    }
    });		    
}

function loadFriendsBalance(){
	$.ajax({
    	type:'GET',
    	url:baseAppUrl + '/ranking/friendsBalance',
    	success:function(data){
	    	$('#friends_balance').html(data);
	    }
    });		
}