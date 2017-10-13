//Our JS
$(window).load(function() {
	
	// Creating the Nivo Slider on window load
	
	$('#slideshow').nivoSlider({
		pauseTime:5000,
		directionNav:false,
		controlNav:false	
	});
});

//Animation

		$(function(){
		$('#lorries')
		.animate({
			backgroundPosition: '10000px 0px'
		}, 240000, 'linear');
			
		$('#background-vehicles').animate({
			backgroundPosition:'-8000px 0px'
		}, 140000, 'linear');	
			
		$('#background-small-cranes').animate({
			backgroundPosition:'-10000px 0px'
		}, 500000, 'linear');					
					
		$('#clouds').animate({
			backgroundPosition:'-10000px -0px'
		}, 960000, 'linear');
			
});

//Subscribe Form

$(function() {

  if($('#subscribe-form').length && jQuery()) {
  
    $('form#subscribe-form').submit(function() {

      $('form#subscribe-form .error').remove();
        var hasError = false;

        $('.required').each(function() {
          if(jQuery.trim($(this).val()) === '') {
            var labelText = $(this).prev('label').text();
            $(this).parent().append('<div class="error">Please enter your Email'+labelText+'</div>');
            $(this).addClass('inputError');
            hasError = true;
          } else if($(this).hasClass('email')) {
            var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
            if(!emailReg.test(jQuery.trim($(this).val()))) {
            var labelText = $(this).prev('label').text();
            $(this).parent().append('<div class="error">Please enter a valid email address'+labelText+'</div>');
            $(this).addClass('inputError');
            hasError = true;
            }
          }
        });

        if(!hasError) {
          $('form#subscribe-form input.submit').fadeOut('normal', function() {
            $(this).parent().append('');
          });
          var formInput = $(this).serialize();
          $.post($(this).attr('action'),formInput, function(data){
            $('form#subscribe-form').slideUp("fast", function() {
              $(this).before('<div class="error">Thank you for your subscription!</div>');
            });
          });
        }

        return false;
    });
  }
});