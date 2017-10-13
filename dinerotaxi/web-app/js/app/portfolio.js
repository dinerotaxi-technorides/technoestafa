function initPortfolio(){
	if(isFacebook){		
		loadHeader();
		$('#body_section').removeClass("span-12");
		$('#body_section').addClass("span-20");
	}else{
		$('#body_section').addClass("span-18");
		loadSidebar();
	}
	loadLastTrades();
}

function removeOrder(order_id) {
	jQuery.ajax({
		type : 'POST',
		data : 'order_id=' + order_id,
		url : baseAppUrl + '/portfolio/removeOrder',
		success : function(data, textStatus) {
			jQuery('#portfolioContainer').html(data);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

function loadSidebar() {
	jQuery.ajax({
		type : 'POST',
		url : baseAppUrl + '/sidebar/portfolioSidebar',
		success : function(data, textStatus) {
			jQuery('#sidebarContainer').html(data);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

function loadLastTrades(){
	jQuery.ajax({
		type : 'POST',
		url : baseAppUrl + '/portfolio/getLastTrades',
		success : function(data, textStatus) {
			jQuery('#lastTradesContainer').html(data);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

function loadHeader() {
	jQuery.ajax({
		type : 'POST',
		url : baseAppUrl + '/sidebar/portfolioHeader',
		success : function(data, textStatus) {
			jQuery('#portfolioHeader').html(data);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}


