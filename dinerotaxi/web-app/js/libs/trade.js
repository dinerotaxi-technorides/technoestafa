var slider; 
var limit = false;

function showstuff(boxid){
   document.getElementById(boxid).style.display = '';
   limit = true;
}

function hidestuff(boxid){
   document.getElementById(boxid).style.display = "none";
   limit = false;
}

function readOnly(id,readonly) {
	var obj = document.getElementById(id);
	obj.readOnly = readonly;
}

function addCommas(nStr)
{
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
}

function updatePrice(){	
	setTimeout("callback_price()", 10);
}

function callback_price()
{
	var price; 
	if(document.getElementById('Limit').checked == true)
		price = document.getElementById('price').value;
	else
		if( (document.getElementById('value-ask').value == 1) && (document.getElementById('value-bid').value == 0)  ){
		    price = document.getElementById('ask').value;
		}else{
		    price = document.getElementById('bid').value;
		}
	var amount = document.getElementById('amount').value.replace(/\,/g,'');
	var result = (amount*price);
	var cash = document.getElementById('cash').value.replace(/\,/g,'');
	
	document.getElementById('total').value = addCommas(result.toFixed(2));
	
	var type = document.getElementById('type').value;		
	if((type == "BUY" || type == "SHORT") && result > cash)
		document.getElementById('total').style.color = 'red';
	else 
		document.getElementById('total').style.color = 'green';

	if((type == "SELL" || type == "COVER") && amount > amount_owned)
		document.getElementById('amount').style.color = 'red';
	else 
		document.getElementById('amount').style.color = '#333333';
	
	if(type == "SELL" || type == "COVER")
		updateGain(bought);
}

function updateAmount(){
	if(!document.getElementById('Limit').checked)
	    setTimeout("callback_amount()", 10);
}

function callback_amount(){
	var price;	
	if( (document.getElementById('value-ask').value == 1) && (document.getElementById('value-bid').value == 0)  ){
	      price = document.getElementById('ask').value;
	}else{
	      price = document.getElementById('bid').value;
	}

	var cash = document.getElementById('cash').value.replace(/\,/g,'');
	var total = document.getElementById('total').value.replace(/\,/g,'');
	var amount = parseInt(total/(price));
	var result = (amount*price);
	document.getElementById('amount').value = amount;
	document.getElementById('total').value = addCommas(total);
	var type = document.getElementById('type').value;	
	if((type == "BUY" || type == "SHORT") && result > cash)
		document.getElementById('total').style.color = 'red';
	else
		document.getElementById('total').style.color = 'green';
	
	updateGain(bought);
	
	$('#total').bind('blur',function(){
		document.getElementById('total').value = addCommas(result.toFixed(2));
	});
}

function updateOnSell(){
	if( (document.getElementById('type').value == 'COVER') || (document.getElementById('type').value == 'SELL')  )
		actionSell(bought);
}

function getAmount(cash, position)
{	
	var amount = 0;		
	var price = 0;
	if( (document.getElementById('value-ask').value == 1) && (document.getElementById('value-bid').value == 0))
	{
		if(document.getElementById('Limit').checked == true){
			price = price = $('#price').val();
		}else{			
			price = document.getElementById('ask').value;
		}
	    if (document.getElementById('type').value == 'COVER')
	    	amount = parseInt(position);
	    else
	    	amount = parseInt(cash / price);	    
	}
	else
	{	   
		if(document.getElementById('Limit').checked == true){
			price =  price = $('#price').val();
		}else{			
			price = document.getElementById('bid').value;
		}
		if (document.getElementById('type').value == 'SHORT')
			amount = parseInt(cash / price);	    
		else
			amount = parseInt(position);
	}	
	
	if(document.getElementById('Limit').checked == false){
		document.getElementById("amount").value = "0";
		document.getElementById("total").value = "0";
	}
	
	return amount;
}

function updateGain(bought){
	var amount = document.getElementById('amount').value;
	var price; 
	if(document.getElementById('Limit').checked == true){
		price = document.getElementById('price').value;
	}else if (document.getElementById('type').value == 'COVER'){
		amount = -amount;
		price = document.getElementById('ask').value;
	}else{	
		price = document.getElementById('bid').value;
	}
	var result = (amount*(price - bought));
	$('#gainValue').html(addCommas(result.toFixed(2)));
	if(result < 0){
		$('#gainValue').css('color','red');
	}else{
		$('#gainValue').css('color','green');
	}	
}


function checkSubmitFacebook() {
	$('#trade_popup_facebook button.ok_dialog_facebook').html('Sending...');
	$('#trade_popup_facebook button.ok_dialog_facebook').attr('disabled',true);
    return true;
}

function checkSubmit() {
	$('#trade_popup button.ok_dialog').html('Sending...');
	$('#trade_popup button.ok_dialog').attr('disabled',true);
    return true;
}

function updateValueBox(){
	$('#value_ask_bid').html($('#price').val());			
}

function showTwitterWindow() {
	var newwindow = window.open(''+baseUrl+'/twitter-oauth/redirect',"mywindow","width=780,height=800");
	if (window.focus) {newwindow.focus()}
}

function checkFacebook() {
	$('#image_facebook').css('display','none');
	$('#check_facebook').css('display','block');
	$('#checks').val('1');
}

function noCheckFacebook() {
	$('#image_facebook').css('display','block');
	$('#check_facebook').css('display','none');
	$('#checks').val('0');
}

function checkTwitter() {
	$('#image_twitter').css('display','none');
	$('#check_twitter').css('display','block');
	$('#checks_twitter').val('1');
}

function noCheckTwitter() {
	$('#image_twitter').css('display','block');
	$('#check_twitter').css('display','none');
	$('#checks_twitter').val('0');
}

// TOOLTIPS INIT
$('#positions').tooltip({
	tip:'#tooltip_positions',
	relative:true,
	offset:[180,50],
	predelay: 500
});
$('#last_price').tooltip({
	tip:'#tooltip_last_price',
	relative:true,
	offset:[180,50],
	predelay: 500
});
$('#cash_id').tooltip({
	tip:'#tooltip_cash',
	relative:true,
	offset:[180,70],
	predelay: 500
});
$('#order').tooltip({
	tip:'#tooltip_order',
	relative:true,
	offset:[180,70],
	predelay: 500
});
$('#market').tooltip({
	tip:'#tooltip_market',
	relative:true,
	offset:[250,160],
	predelay: 500
});
$('#limit').tooltip({
	tip:'#tooltip_limit',
	relative:true,
	offset:[250,240],
	predelay: 500
});
$('#action').tooltip({
	tip:'#tooltip_action',
	relative:true,
	offset:[190,60],
	predelay: 500
});
$('#limit_price').tooltip({
	tip:'#tooltip_limit_price',
	relative:true,
	offset:[190,40],
	predelay: 500
});
$('#days_valid').tooltip({
	tip:'#tooltip_days_valid',
	relative:true,
	offset:[190,40],
	predelay: 500
});

$('#amount').bind('blur',function(){
	updateAmount();
	updatePrice();
	updateGain(bought);
});

$('#Market').click(function(){
	if( $('#value-ask').val()== 1 ){
		$('#value_ask_bid').html($('#ask').val());
	}else if ( $('#value-bid').val()== 1 ){
		$('#value_ask_bid').html($('#bid').val());
	}
});

$('#limit').click(function(){
	updateValueBox();
});	
