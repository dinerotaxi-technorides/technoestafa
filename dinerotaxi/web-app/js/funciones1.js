$(document).ready(function($) {
    //VALIDACION FORMULARIO REGISTRO
    $("#forgotForm").validate({
		submitHandler: function(form) {
                   form.submit();
			 },
		rules: {
			username: {
				required: true,
				email: true
			}
		},
		messages: {
			username: "Por Favor Ingrese un Email Valido"
		},errorElement: "div"
			
	});

    //CAMBIO DE PASSWORD
    $("#resetPassword").validate({
		submitHandler: function(form) {
                                   form.submit();
			 },
		rules: {
			password:"required",
                            password: {
				required: true,
				minlength: 5
			},
                            password2: {
			      equalTo: "#password"
			    }
                            
		},
		messages: {
			password: "Por Favor Ingrese su contraseña actual",
                           password: {
				required: "Por Favor Complete el campo Password",
				minlength: "La contraseña debe tener 5 caracteres"
			},
                            password2: {
			      equalTo: "Las contraseñas no coinciden"
			    }
			
		},errorElement: "div"
			
	});
        //VALIDACION FORMULARIO REGISTRO
        $("#registrationForm").validate({
			submitHandler: function(form) {
                                       form.submit();
				 },
			rules: {
				firstName: "required",
				lastName: "required",
                name: "required",
                placeinput1: "required",
				phone: {
					required: true,
					minlength: 5,
					maxlength: 40
				},
				password1: {
					required: true,
					minlength: 5
				},
				
				email: {
					required: true,
					email: true
				},
				password2: {
				      equalTo: "#password1"
				    },
				agree: "required",
				politics: "required"
			},
			messages: {
				firstName: "Por Favor Ingrese Su Nombre",
				lastName: "Por Favor Ingrese Su Apellido",
                name:"Por Favor Ingrese su Nombre y Apellido o Razón Social",
				phone: {
					required: "Por Favor Ingrese un Telefono Valido",
					minlength: "Debe tener como minimo 10 numeros"
				},
				password1: {
					required: "Por Favor Complete el campo Password",
					minlength: "La contraseña debe tener 5 caracteres"
				},
				email: "Por Favor Ingrese un Email Valido",
				politics:"Tilde las politicas de privacidad",
				agree:"Tilde los terminos y condiciones"
			},errorElement: "div"
				
		});
        //CONTACT FORM
        $("#contactForm").validate({
			submitHandler: function(form) {
                                       form.submit();
				 },
			rules: {
				firstName: "required",
				lastName: "required",
				subject: "required",
                comment: "required",
				phone: {
					required: true,
					minlength: 5,
					maxlength: 40
				},
				email: {
					required: true,
					email: true
				},
			
			},
			messages: {
				firstName: "Por Favor Ingrese Su Nombre",
				lastName: "Por Favor Ingrese Su Apellido",
				subject:"Por Favor Ingrese un asunto",
				comment:"Por Favor Ingrese un comentario",
				phone: {
					required: "Por Favor Ingrese un Telefono Valido",
					minlength: "Debe tener como minimo 10 numeros"
				},
				email: "Por Favor Ingrese un Email Valido"
				
			},errorElement: "div"
				
		});
      //CONTACT FORM
        $("#contactFormUser").validate({
			submitHandler: function(form) {
                       form.submit();
				 },
			rules: {
				
				subject: "required",
                comment: "required",
				
			
			},
			messages: {
				
				subject:"Por Favor Ingrese un asunto",
				comment:"Por Favor Ingrese un comentario",
				
				
			},errorElement: "div"
				
		});
                 //VALIDACION FORMULARIO LOGIN
        $("#userLoginInBodyForm").validate({
			submitHandler: function(form) {
                                       form.submit();
				 },
			rules: {
				j_username: {
					required: true,
					email: true
				},
                                j_password: {
					required: true,
					minlength: 5
				}
				
			},
			messages: {
				j_username: "Por Favor Ingrese su usuario",
                                j_password: {
					required: "Por Favor Complete el campo Password",
					minlength: "La contraseña debe tener 5 caracteres"
				}
				
			},errorElement: "div"
				
		});
                
  		
});


$(function() {
    	
        function onShowMessage (dialog) {
            $(dialog.wrap).find("form").validate({errorElement:'p'});
            
            $('#to').tokenInput(
              this.attr('search'), {
              theme: "tbo",
              hintText: "",
              prePopulate: eval(this.attr('prepopulate'))
            });      
        }
                      
      
        function onSubmitProduct (data) {
            // simulates similar behavior as an HTTP redirect
            window.location.replace(data);
        }
      });


