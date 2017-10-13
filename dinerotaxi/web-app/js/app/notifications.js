var page = 1;
var total;
var pageSize;
var maxPage;

function initNotifications(total_noti){
	total=total_noti;
	if (isFacebook){
		$('#body_section').removeClass("span-12");
		$('#body_section').addClass("span-19");
		pageSize=8;
		if(total<pageSize){	
			$('#next').hide();
		}
	}else{
		$('#body_section').removeClass("span-18");
		$('#body_section').addClass("span-25");
		$(".navigation").hide();
		$("footer").hide();
		pageSize=15;
		$(window).scroll(function() {
            if ($('body').height() <= ($(window).height() + $(window).scrollTop())) {
            	if(page<=maxPage){            		
            		renderMore();
            	}
            }
        });
	}
	maxPage = Math.floor(total/pageSize);
	$("#navDot").hide();
	$('.stream-item a').bind('click',function(e){
		e.stopPropagation();
	});
}

function loadRightSide(hightlight){
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/common/todayTrends',
		dataType: 'html',
		success: function(data){
			$("#today_trends").html(data);
		}				
	});
	
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/common/monthlyTrends',
		dataType: 'html',
		success: function(data){
			$("#monthly_trends").html(data);
		}				
	});
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/portfolio/getLastTrade',
		dataType: 'html',
		success: function(data){
			$("#last_trade").html(data);
		}				
	});
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/notifications/friends',
		dataType: 'html',
		success: function(data){
			$("#friends").html(data);
		}				
	});
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/notifications/toptraders',
		dataType: 'html',
		success: function(data){
			$("#top_traders").html(data);
		}				
	});
	
	var notifications=$('li.stream-item');
	for(var a=0;a<hightlight;a++){
		$(notifications[a]).addClass('new-ntf');
	}
	$(".new-ntf").mouseup(function(){
		$(this).removeClass("new-ntf");
	});
}

function nextPage(){
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/notifications/getFeedPage',
		data: "page=" + ++page,
		dataType: 'html',
		success: function(data){
			if(page==maxPage){
				$('#next').fadeOut();						
			}
			$(".stream").html(data);
			shortenizeNotif();
		}				
	});

	if(page>1){
		$("#prev").fadeIn();
	}
}

function prevPage(){
	if(page!=1){
		$.ajax({
			type : 'GET', 
			url: baseAppUrl + '/notifications/getFeedPage',
			data: "page=" + --page,
			dataType: 'html',
			success: function(data){
				$(".stream").html(data);
				shortenizeNotif();
			}				
		});	
		if (page==1){
			$("#prev").fadeOut();
		}
	}

	if($('#next').css('display')=='none'){
		$("#next").fadeIn();
	}
}


function renderMore(){
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/notifications/getFeedPage',
		data: "page=" + ++page,
		dataType: 'html',
		success: function(data){
			$(".stream").append(data);
			shortenizeNotif();
		}				
	});	
}

function renderWallPost(id){
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/wall/renderWallPost',
		data: "id="+id,
		dataType: 'html',
		success: function(data){
			$("#stream-details").html(data);
			$(".stream-item-details").show("slide");
		}				
	});	
	$(".dashboard-content").addClass('faded');
	var a = $("#newsfeed").height();
	$(".stream-item-details").height(a-30);
	$(".stream-item-details").css('max-height',a+'px');
}

function renderComment(id){
	$.ajax({
		type : 'GET', 
		url: baseAppUrl + '/comment/renderComment',
		data: "id="+id,
		dataType: 'html',
		success: function(data){
			$("stream-details").html(data);
			$(".stream-item-details").show("slide");
		}				
	});	
	$(".dashboard-content").addClass('faded');
	var a = $("#newsfeed").css('height');
	a = a.replace("px","");
	$(".stream-item-details").css('height',a-30 + "px");
	$(".stream-item-details").css('max-height',a);
}