function showForm (){
	$('#name').val("");
	$('#email').val("");
	$('#message').val("");
	$('#email_form').show('blind');
	$('#contact_errors').empty();
}

function sendEmail(){
	var name=$('#name').val();
	var email=$('#email').val();
	var message=$('#message').val();
	
	var valid_name = validateName();
	var valid_email = validateEmail();
	var valid_message = validateMessage();
	if (valid_name && valid_email && valid_message){
		$.ajax({
	    	type:'POST',
	    	data:'name='+name+'&email='+email+'&message='+message,
	    	url:baseAppUrl + '/common/sendEmail',
	    	success:function(data){
		    	$('#contact_errors').html(data);
		    	$("#email_form").hide("blind");
	    	}
		});		
	}
}


function validateName(){
	var valid;
	if ($('#name').val()==""){
		$('#name').addClass('invalid');
		valid=false;
	}else{
		$('#name').removeClass('invalid');
		valid=true;
	}
	return valid;
}
	
function validateEmail(){
   	var valid;
	if (!isValidaEmail($('#email').val())){
		$('#email').addClass('invalid');
		valid=false;
	}else{
		$('#email').removeClass('invalid');
		valid=true;
	}
	return valid;
 }

function validateMessage(){
  	var valid;
 	if ($('#message').val()==""){
		$('#message').addClass('invalid');
		valid=false;
	}else{
		$('#message').removeClass('invalid');
			valid=true;
		}
		return valid;
	}
 
   	function isValidaEmail(email) {
   		var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
	return reg.test(email);
}

function initContact(){
	$('#name').focusout(function() {
		validateName();
	})
	 
	$('#email').focusout(function() {
		validateEmail();
	})
	 
	$('#message').focusout(function() {
		validateMessage();
	})
}