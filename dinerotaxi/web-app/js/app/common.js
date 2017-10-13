var baseAppUrl= "";
var publicUrl=""
var amount;		
var bought;
var amount_owned;
var sliderValue;
var sliderStepping;
var sliderMin;
var sliderMax;
var value;
var action;
var cash;
var ask;
var bid;
var isFacebook;

function setIsFacebook(value){
	if (value==true){
		baseAppUrl+='/fb';
	}else{
		baseAppUrl= "";
	}
	isFacebook=value;
}

function getIsFacebook(){
	return isFacebook;
}

// Google Analytics
var _gaq=[["_setAccount","UA-18044318-1"],["_trackPageview"]]; 
(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];g.async=1;
g.src=("https:"==location.protocol?"//ssl":"//")+"google-analytics.com/ga.js";
s.parentNode.insertBefore(g,s)}(document,"script"));

function initTradebox() {

	if( $('#value-ask').val()== 1 ){
		if(action=="BUY"){
			value = 0;
		}else{
			value = amount;
			$('#amount').val(amount);
		}
	}else{
		if(action=="SHORT"){
			value=0;
		}else{
			value = amount;
			$('#amount').val(amount);
		}
	}
	
	$('#limit_price_row').hide();
	$('#days_valid_row').hide();

	$('#Limit').click(function() {
		$('#limit_price_row').show();
		$('#days_valid_row').show();
		$('#amount').val(0);
		$('#total').val(0);
		$('#price').val(0);
		$("#slider").slider("option", "value", 0);
		$('#askorbid').html('x ' + 0 + " =");
		$("#askorbidtext").html("(Limit Price)");
	});

	$('#Market').click(function() {
		$('#limit_price_row').hide();
		$('#days_valid_row').hide();
		$('#amount').val(0);
		$('#total').val(0);
		$("#slider").slider("option", "value", 0);
		setAskOrBid();
	});
	
	$("#slider").slider({
		step : sliderStepping,
		value : value,
		min : sliderMin,
		max : sliderMax,
		start : [ sliderValue ],
		slide : function(e, ui) {
			$('#amount').val(ui.value);
			updatePrice();
			updateGain(bought);
			removeInvalid();
		}
	});

	if ($('#value-ask').val() == 1) {
		$('#value_ask_bid').html($('#ask').val());
	} else {
		$('#value_ask_bid').html($('#bid').val());
	}

	if (getUserSetting('POST_FACEBOOK')) {
		$("#postTradeOnFacebook").attr("checked", "checked");
	} else {
		$("#postTradeOnFacebook").removeAttr("checked");
	}

	$('.primary').click(function() {
		$('#tradeBoxContainer').fadeOut();
		$('#tradeBoxContainer').overlay().close();
	});

	$('#closeTradeBox').click(function() {
		$('#tradeBoxContainer').fadeOut();
		$('#tradeBoxContainer').overlay().close();
	});
}

function setAskOrBid(){
	var action = $('.trade-actions').val();
	if($('#Limit').is(':checked')){
		var price = $('#price').val();
		$('#askorbid').html('x ' + price + " =");
		$("#askorbidtext").html("(Limit Price)");
	}else{
		if(action=="BUY" || action=="COVER"){
			$('#askorbid').html('x ' + ask + " =");
			$("#askorbidtext").html("(Ask)");
			$('#value-ask').val('1');
			$('#value-bid').val('0');
		}else{
			$('#askorbid').html('x ' + bid + " =");
			$("#askorbidtext").html("(Bid)");
			$('#value-ask').val('0');
			$('#value-bid').val('1');
		}
	}
	amount = getAmount(cash,amount_owned);
	$( "#slider" ).slider( "option", "max", amount );
	$( "#slider" ).slider( "option", "value", 0 );
}

function setLimitPrice(){
	amount = getAmount(cash,amount_owned);
	$( "#slider" ).slider( "option", "max", amount );
	$( "#slider" ).slider( "option", "value", 0 );
	var price = $('#price').val();
	$('#askorbid').html('x ' + price + " =");
}



function isValid(){
	var amount = validNumber($('#amount'));
	var total = validNumber($('#total'));
	if ($('#Limit').is(':checked')){
		var limit_days = validNumber($('#limit_days'));
		var price = validNumber($('#price'));
		return (amount && total && limit_days && price);
	}else{
		return (amount && total);
	}
}


function validNumber(element){
	valid=false;
	var num= Number(element.val().replace(/,/g,''));
	if (num>0){
		valid=true;
		element.removeClass('invalid');
	}else{
		element.addClass('invalid');
	}
	return valid;
}



$('#amount').click(function() {
	removeInvalid();
});

$('#total').click(function() {
	removeInvalid();
});

function removeInvalid(){
	$('#total').removeClass('invalid');
	$('#amount').removeClass('invalid');
}

function testForm(){
	$("#tradebtn").click('').attr('onclick','');
	$('#tradebtn').removeClass('success');
	$('#tradebtn').addClass('disabled');
	if (isValid()){
		$.ajax({
			type:'POST', 
			data:$("#tradeForm").serialize(), 
			url: baseAppUrl + '/portfolio/doTrade',
			beforeSend: function(){
				if(!beforeTradeActions())
					return false;// invalid form data
			}, 
			error:function(data, textStatus, errorThrown){
				showErrorMessage("<p><strong>Error!</strong> We couldn't place your order. Please try again later</p>");
			},
			success:function(data,textStatus){
				$('#portfolioContainer').html(data);
				showSuccessMessage("<p><strong> Your order has been placed.</strong></p>");
				afterTradeActions();
			},
			complete:function(){
				$('#tradeBoxContainer').overlay().close();
			}
		});	
	}
}


$('#amount').keyup(function () { 
	var reg = /[^\d^]/g;
	checkField($('#amount'),reg);
});

$('#total').keyup(function () { 
	var reg = /[^\d^\.]/g;
	checkField($('#total'),reg);
});

$('#limit_days').keyup(function () { 
	var reg = /[^\d^]/g;
	checkField($('#limit_days'),reg);
});

$('#price').keyup(function () { 
	var reg = /[^\d^\.]/g;
	checkField($('#price'),reg);
});

function checkField(element,reg){
	element.val(element.val().replace(reg,''));
    if (element.val()==''){
    	element.addClass('invalid');
	}else{
		element.removeClass('invalid');
	}
}

function beforeTradeActions(){
	if($("#amount").val()<=0){
		return false;
	}
	return true;
}

function isLogged(){
	return $("#isLogged").text()=='true';
}


$(document).ready(function(){
	$(".tablesorter").tablesorter();
	setTooltip();
});

function initHeader(){
	$("#user-active").click(function(){
		// $("ul.menu-dropdown").toggle();
		
		if($("ul.menu-dropdown").css('display') == 'block'){
			$("ul.menu-dropdown").slideUp();
		}else{
			$("ul.menu-dropdown").slideDown();
		}
	});
	
	$('#search-query').click(function(event) {
		$("#search-query").removeClass("invalid");		
	});

	$('#search-query').keyup(function(event) {
		this.value = this.value.replace(/[^a-zA-Z\.\s]/g,'');
		$("#search-query").removeClass("invalid");
		if (event.keyCode == '13') {			
			findSymbol();
		}
	});

	$(".btn_find").click(function (e) {
		findSymbol();
	});
}

$(function(){
	var top = isFacebook?350:'50%';
	$('#tradeBoxContainer').overlay({
		onBeforeLoad: function() {
	          this.getOverlay().appendTo('body');
	    },
		mask: {			
			color: '#000000'								
		},
		fixed: false,
		closeOnClick: false,
		load: false,
		left:'50%',
		top:top
	});
});

$('.tooltip_content').css('-webkit-border-radius', '10px');	
if (self !=  parent){
	$("a.symbol").bind({
		mousemove : changeTooltipPosition	
	});
}

function openresetModalDialog(title, message){
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/common/renderresetModalDialog',
		data: 'title=' + title + "&message=" + message,
		dataType: 'html',
		success: function(data){
			$("body").append("<div class='modalMessage'>" + data + "</div>");	
		}
	});		
}

function openCallbackDialog(title, msg, callback){
	$("#messagesBox").html(msg);
	$("#messagesBox").dialog({
		modal: true,
		closeOnEscape: true,
		draggable: false,
		resizable: false,
		title: title,
		buttons: {
			Ok: function() {
				$( this ).dialog( "close" );
				callback();
			}
		}
	});
}
function taggify(message, dollar, hash, at, link){
	// link tag
	if(link){
		message = linkify(message);
	}
	// Dollar Tag
	if(dollar){
        message = message.replace(/(^|\s)\$(\.?([a-zA-Z])+(\.[a-zA-Z])?)/g, function(s, group1, group2){         	
        	return group1 + "<span class=\"symbol\"" + "onMouseOver='loadingGraphic(\"" + group2.toUpperCase() + "\");'" + "><a href='" + baseAppUrl + "/quotes/" + group2.toUpperCase() + "\'><img src='http://static.tradefields.com/symbols/icon/" + group2.toUpperCase() + ".ico' alt=''/></a>"+
        	"<a href='" + baseAppUrl + "/quotes/" + group2.toUpperCase() + "'>" + group2.toUpperCase() + "</a></span>"
        });		  
	}
	// Hash Tag
	// if(hash){
		// message = message.replace(/(^|\s)#(\w+)/g, "$1#<a href=baseAppUrl +
		// '/topic/$2'>$2</a>");
	// }
	// at Tag
	// if(at){
		// message = message.replace(/(^|\s)@(\w+)/g, "$1@<a href=baseAppUrl +
		// '/user/$2'>$2</a>");
	// }
	return message;
}

 function linkify(text){
    if (text) {
        text = text.replace(
            /(((https?:\/\/)|(www.))([\w\d\-]+)\.[\w\d.\-?#&$!=\/]+)/gi,
            function(url){
                var full_url = url;
                if (!full_url.match('^https?:\/\/')) {
                    full_url = 'http://' + full_url;
                }
                return '<a target="_blank" href="' + full_url + '">' + url + '</a>';
            }
        );
    }
    return text;
}
 
function getUserSetting(settingName){
	var userSettings=getUserSettings();
	for(var a=0;a<userSettings.length;a++){
		if(userSettings[a].setting_name==settingName){
			return (userSettings[a].value=='true');
		}
	}
	return false;
}

function getUserSettings(){
	var settings = null;
	$.ajax({
		type : 'POST', 
		url: baseAppUrl + '/profile/getUserSettings',
		dataType: 'json',
		async: false,
		success: function(data){
			settings = data.settings;	
		}
	});	
	return settings;
}

function loadingPopover(){
	$("#popoverLoading").fadeIn();
}
	 		

function loadingGraphic(symbol){
	loadingPopover();
	$.ajax({
		type:'POST',
		data:'symbol=' + symbol, 
		url: baseAppUrl + '/common/stockPopover',
		success:function(data,textStatus){
			$('#popoverContent').html(data);
			$("#popoverLoading").fadeOut();
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			
		}
	});		 			 	
}	 	

function loadingModal(div){
	$('#'+div).empty().html('<img style="margin-top:5px; padding-left:45%" alt="" align="center" src=' + publicUrl + '"/img/indicator.gif"/>');
}

function loading(div){
	$('#'+div).empty().html('<img style="margin-top:5px; padding-left:45%" alt="" align="center" src="' + publicUrl+ '/img/indicator.gif"/>');
}

function showSuccessMessage(message){
	$("#messageSuccessContent").html(message);
	$("#messageSuccess").fadeIn(1000).delay(2500).fadeOut(1000);
}

function showErrorMessage(message){
	$("#messageErrorContent").html(message);
	$("#messageError").fadeIn(1000).delay(2500).fadeOut(1000);
}

function setTooltip(){
	$(".symbol").tooltip({
		offset:[10,80],		
		tip:'#tooltip',
		predelay: 500,
		effect: 'slide',
	}).dynamic({ 
		classNames: 'above right below left',
		top: { 
			direction: 'up', 
			bounce: true 
		},			
		left: { 
			direction: 'down', 
			offset:[100,0], 
			bounce: true 
		}, 
		bottom: { 
			direction: 'down',
			bounce: true 
		} 
	});	
	$(".symbol").removeClass('symbol');
}

function setTooltip2(){
	$(".symbol").popover({placement:'above', fallback:'Popover Title'});
}

function changeTooltipPosition(event) {	
	var tooltipX = event.pageX ;	
	if (tooltipX +  parseInt($('#tooltip').css('width')) > $(window).width())	
		tooltipX = $(window).width() - parseInt($('#tooltip').css('width'));
	$('#tooltip').css({left: tooltipX});	
};


function findSymbol(){
	var symbol = $('#search-query').val();
	$.ajax({
    	type:'POST',
    	data:'symbol='+symbol,
    	url:baseAppUrl +'/stock/exists',
    	dataType:'json',
    	success:function(data, textStatus){
	    	if(data.exists){		    		
				location.href = baseAppUrl+ "/quotes/" + symbol;
		    }else{
		    	$("#search-query").addClass("invalid");
			} 	
	    }
	});
}


function renderTradeBox(symbol,type){
	$.ajax({
		type:'POST',
		data:'symbol='+symbol + '&type='+type, 
		url: baseAppUrl + '/portfolio/renderTradeBox',
		success:function(data,textStatus){
			$('#tradeBoxContainer').html(data);
			$("#tradeBoxContainer").overlay().load();
			$('#tradebtn').removeClass('disabled');
			$('#tradebtn').addClass('success');
			$("#tradebtn").click('').attr('onclick','testForm()');
		}
	});
}

function showTradeBox(symbol,type){
	$.ajax({
	   	type:'POST',
	   	data:'symbol='+symbol,
	   	url:'/stock/exists',
	   	dataType:'json',
	   	success:function(data, textStatus){
	    	if(data.exists){
			 	if(type){
			 		renderTradeBox(symbol,type);
				}else{
					renderTradeBox(symbol,'BUY');
				}
		    }else{
		    	$("#search-query").addClass("invalid");
			} 	
	    }
	});	
}


function showGain(column, type){
	if (column==1){
		$("#" + type + '-positions' + ' .dollar').show();
		$("#" + type + '-positions' + ' .percent').hide();
	}else if(column==2){
		$("#" + type + '-positions' + ' .dollar').hide();
		$("#" + type + '-positions' + ' .percent').show();
	}
}


$('#close').click(
	function(){
		$('#error').effect('blind');
		$('#error').overlay().close();
	}
);

function shortenize(){
	$('.stream-text').each(function(){
		var height = $(this).height();
		if (height>54){
			$(this).height(54);
			$(this).parent().children('.showmore').html("<a class='pointer' onclick='showMore($(this))'>Show more</a>");
		}
	});
}

function shortenizeNotif(){
	$('.stream-text').each(function(){
		var height = $(this).height();
		if (height>54){
			$(this).parent().height(54);			
		}
	});
}


function seachUsers(){
	var text = $('#search_user').val();
	if (text!=""){
		$.ajax({
	    	type:'GET',
	    	data:'text='+text,
	    	url:baseAppUrl + '/common/searchUser',
	    	success:function(data){
		    	$('#searchBox').html(data);
		    	showUsers();
		    }
	    });		  
	}
}

function showUsers(){
	var height = $("#search_user").offset().top;
	$('#searchModalDialog').overlay({		
		mask: {			
			color: '#000000'								
		},
		fixed: true,
		closeOnClick: false,
		load: false,
		left: '50%',
		top: (isFacebook?height:'50%')
	});
	$('#searchModalDialog').overlay().load();
}

$('#search_user').keyup(function(event) {
    if (event.keyCode == '13') {            
    	seachUsers();
    }
});
function showMore(element){
	element.parent().parent().children(".stream-text").height("");
	element.parent().html('');
}

function resetAccount(){
	$.ajax({
    	type:'GET',
    	url:baseAppUrl + '/portfolio/resetAccount',
    	complete:function(data){
    		completeResetAccount();
	    }
    });		  
}

function completeResetAccount(){
	$('#resetModalDialog').overlay().close();
	location.reload(true);
}

function showModal(){
	var height = $("#account_table").offset().top+350;
	$('#resetModalDialog').overlay({		
		mask: {			
			color: '#000000'								
		},
		fixed: true,
		closeOnClick: false,
		load: false,
		left: '50%',
		top: (isFacebook?height:'50%')
	});
	$('#resetModalDialog').overlay().load();
}

function stopPropagation(element){
	$(element).bind('click',function(e){
		e.stopPropagation();
	});
}