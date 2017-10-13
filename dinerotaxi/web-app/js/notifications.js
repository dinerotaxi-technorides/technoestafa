function getPostAjax(notif_t,notif_id,user_from){
			var image = '<img style="height: 18px; width: 18px; position:absolute; left:50%; margin-left:-18px; top:100px;" src="'+publicUrl+'/img/indicator.gif" /><p style="position:absolute; left: 50%; margin-left:-25px; top:120px;" >Loading</p>';
			$('.details-pane').html(image);
			$.ajax({
				url: ''+baseUrl+'/notifications/postAjax?'+'notif_t='+notif_t+'&notif_id='+notif_id+'&user_from='+user_from, 
				data : '',
					success: function(data){
						$('.details-pane').html(data);
						FB.XFBML.parse();
					},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					show_error_dialog(errorThrown);
				}
			});
}

function arrowsOperators(event,notif_t,notif_id,user_from){
//		alert($(event.target).parent().parent().hasClass('stream-item-focused'));
		if(!$(event).hasClass('stream-item-focused')){
			$(".details-pane").animate({
		           width: "show",
		           left:  "+=10px"
		       },{duration: 200}
		    );
			$('#my_profile').css('display','none');
//			$('.details-pane').css('display','block');
			$(event).addClass('stream-item-focused');
			$(event).siblings().removeClass('stream-item-focused');
			getPostAjax(notif_t,notif_id,user_from);
		}else{
			$(".details-pane").animate({
	            width: "hide",
	            left:  "-=10px"
	        },{duration: 200}
	        );
			$('#my_profile').css('display','block');
			$('.details-pane').css('display','none');
			$(event).removeClass('stream-item-focused');
		}
}

function postAjaxNotification(div, page){	
	var image = '<img id="imageAjaxLoading" style="height: 11px; width: 16px; margin-left:200px;" src="'+baseUrl+'/img/loading.png"></img>';		
	$('#' + div).append(image);
	$.ajax({
		url: ''+baseUrl+'/notifications/postAjaxNotification?page=' + page + '&rpp=15', 
		data : '',
			success: function(data){				
				var el = document.getElementById('imageAjaxLoading');
				var padre = el.parentNode;				
				padre.removeChild(el);
				$('#' + div).append(data);				 
				FB.XFBML.parse();
			},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			show_error_dialog(errorThrown);
		}
	});		
}

function hidePost(){
	$('#my_profile').css('display','block');
	$(".details-pane").animate({
        width: "hide",
        left:"-=10px"
    },{duration: 200}
    );
	if($('div.stream-item').hasClass('stream-item-focused')){
	    $('div.stream-item').removeClass('stream-item-focused');
	}
}

function getNewNotification(div, quantity)
{
	$.ajax({
		url: ''+baseUrl+'/notifications/getNewNotification?page=' + 1 + '&rpp=' + quantity, 
		data : '',
			success: function(data){
				var newDiv = document.createElement("div");					
				newDiv.innerHTML = data;			
				var idItem = Math.floor(Math.random() * 1000000); 
				newDiv.id = "newItemNotification_" + idItem;
				newDiv.style.display = "none";										
				if (document.getElementById(div).childNodes.length > 0)
				{	
					firstNode = document.getElementById(div).firstChild;
					document.getElementById(div).insertBefore(newDiv, firstNode);															
				}
				else
					$('#' + div).append(newDiv);

				setTimeout("$('#newItemNotification_" + idItem + "').fadeIn(1500)", 1500);
				FB.XFBML.parse();
			},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			show_error_dialog(errorThrown);
		}
	});
}

$(document).ready(function(){
    var height;
    if(self==parent)
    	height = $(window).height() - 140;
    else{
    	height = $('.stream').height();
    }	
    $('.details-pane').height(height);    
});

$(document).ready(function(){
	$('.stream-item a').bind('click',function(e){
		e.stopPropagation();
	});
	$('.stream-item span.stream-timestamp').bind('click',function(e){
		e.stopPropagation();
	});
});