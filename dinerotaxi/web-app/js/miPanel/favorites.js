
$(document).ready(function() {
	var triggers = $(".agregar").overlay({
	
		mask: {
			color: '#333',
			loadSpeed: 200,
			opacity: 0.9
		},
	
		closeOnClick:true
	        
	        
	});
	
	//SUPRIMIR FAVORITOS
	var triggers = $(".suprimir").overlay({
		top:'30%',
		mask: {
			color: '#333',
			loadSpeed: 200,
			opacity: 0.9,
		
		},
	
		closeOnClick:true       
	     
	});

	//pedir FAVORITOS
	var triggers = $(".pedirTaxi1").overlay({
		top:'30%',
		mask: {
			color: '#333',
			loadSpeed: 200,
			opacity: 0.9,
		
		},
		
		closeOnClick:true       
	     
	});
	//SUPRIMIR FAVORITOS
	var triggers = $(".suprimirTodo").overlay({
		top:'30%',
		mask: {
			color: '#333',
			loadSpeed: 200,
			opacity: 0.9,
		
		},
	
		closeOnClick:true       
	     
	});
	
	var buttons = $("#modal_favoritos a").click(function(e) {	
		// get user input
		var yes = buttons.index(this) === 0;
	});
	
	var buttons = $(".suprimirTodos").click(function(e) {	
		// get user input
		var yes = buttons.index(this) === 0;
	});
	
	var buttons = $(".suprimir").click(function(e) {	
		// get user input
		$('#favorite').val($(this).attr('id'));
		
		
	});

	var buttons = $(".pedirTaxi1").click(function(e) {	
		// get user input
		$('#tripfavorite').val($(this).attr('id'));
	});
	
	//Valido formulario
	$("#formModal").validate({
	
		rules: {
			
		                    name: "required",
		                    placeinput1: "required"
			
		},
		messages: {
		
		                    name:"Por Favor Ingrese el nombre del favorito",
		                    placeinput1: "Por favor ingrese una direccion"
			
		},errorElement: "div"
			
	});  
	
	
	$("#modal_favoritos form").submit(function(e) {
	
	            
		// close the overlay
		triggers.eq(1).overlay().close();
	
		// get user input
		var input = $("input", this).val();
		// do something with the answer
		triggers.eq(1).html(input);
	
		// do not submit the form
		return true;
	});
	
	
	$("#modal_elim_fav form").submit(function(e) {
	
		// close the overlay
		triggers.eq(1).overlay().close();
	
		// get user input
		var input = $("input", this).val();
	
		// do something with the answer
		triggers.eq(1).html(input);
	
		// do not submit the form
		return true;
	});

	$("#modal_elim_all_fav form").submit(function(e) {
	
	    
		// close the overlay
		triggers.eq(1).overlay().close();
	
		// get user input
		var input = $("input", this).val();
	
		// do something with the answer
		triggers.eq(1).html(input);
	
		// do not submit the form
		return true;
	});

	$("#modal_pedir_fav form").submit(function(e) {
	
	    
		// close the overlay
		triggers.eq(0).overlay().close();
	
		// get user input
		var input = $("input", this).val();
	
		// do something with the answer
		triggers.eq(0).html(input);
	
		// do not submit the form
		return true;
	});
});
$(function() {
	// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
	$( "#dialog:ui-dialog" ).dialog( "destroy" );
	$('#placeinput1').multiplace({tokenLimit: 1});
	
});
function setupLabel() {
    if ($('.label_check input').length) {
        $('.label_check').each(function(){ 
            $(this).removeClass('c_on');
        });
        $('.label_check input:checked').each(function(){ 
            $(this).parent('label').addClass('c_on');
        });                
    };
    if ($('.label_radio input').length) {
        $('.label_radio').each(function(){ 
            $(this).removeClass('r_on');
        });
        $('.label_radio input:checked').each(function(){ 
            $(this).parent('label').addClass('r_on');
        });
    };
};
$(document).ready(function(){
    $('body').addClass('has-js');
    $('.label_check, .label_radio').click(function(){
        setupLabel();
    });
    setupLabel(); 
});







