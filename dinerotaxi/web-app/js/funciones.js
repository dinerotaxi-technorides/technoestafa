$(document).ready(function($) {

	// VALIDACION FORMULARIO REGISTRO
	$("#registrationForm").validate({
		submitHandler : function(form) {
			form.submit();
		},
		rules : {
			firstName : "required",
			lastName : "required",
			name : "required",
			placeinput1 : "required",
			phone : {
				required : true,
				minlength : 5,
				maxlength : 40
			},
			password : {
				required : true,
				minlength : 5
			},

			email : {
				required : true,
				email : true
			},
			password2 : {
				equalTo : "#password"
			},
			agree : "required",
			politics : "required"
		},
		messages : {
			firstName : "Por Favor Ingrese Su Nombre",
			lastName : "Por Favor Ingrese Su Apellido",
			name : "Por Favor Ingrese su Nombre y Apellido o Razón Social",
			placeinput1 : "Por Favor Ingrese Su Direccion",
			phone : {
				required : "Por Favor Ingrese un Telefono Valido",
				minlength : "Debe tener como minimo 10 numeros"
			},
			password : {
				required : "Por Favor Complete el campo Password",
				minlength : "La contraseña debe tener 5 caracteres"
			},
			email : "Por Favor Ingrese un Email Valido",
			politics : "Tilde las politicas de privacidad",
			agree : "Tilde los terminos y condiciones"

		},
		errorElement : "div"

	});

	// VALIDACION FORMULARIO LOGIN
	$("#userLoginInBodyForm").validate({
		submitHandler : function(form) {
			form.submit();
		},
		rules : {
			j_username : {
				required : true,
				email : true
			},
			j_password : {
				required : true,
				minlength : 5
			}

		},
		messages : {
			j_username : "Por Favor Ingrese su usuario",
			j_password : {
				required : "Por Favor Complete el campo Password",
				minlength : "La contraseña debe tener 5 caracteres"
			}

		},
		errorElement : "div"

	});

	// CAMBIO DE PASSWORD
	$("#cambio_password").validate({
		submitHandler : function(form) {
			form.submit();
		},
		rules : {
			password_actual : "required",
			password : {
				required : true,
				minlength : 5
			},
			password2 : {
				equalTo : "#password"
			}

		},
		messages : {
			password_actual : "Por Favor Ingrese su contraseña actual",
			password : {
				required : "Por Favor Complete el campo Password",
				minlength : "La contraseña debe tener 5 caracteres"
			},
			password2 : {
				equalTo : "Las contraseñas no coinciden"
			}

		},
		errorElement : "div"

	});

});

$(function() {
	$('#placeinput1').multiplace({
		tokenLimit : 1
	});
	$('#placeinput2').multiplace({
		tokenLimit : 1
	});

	function customCallback(params) {
		say('custom');
		$('#placeInput1').geoplaces({
			placePane : '#placePane',
			placeTemplate : 'div.template.place',
			map : '#map_canvas',
			get : '/places/get',
			add : '/place/saveAjax',
			del : '/place/deleteAjax',
			delay : 1000
		});
	}

	function onShow(dialog) {
		$(dialog.wrap).find("form").validate({
			errorElement : 'p'
		});
		$('#placeInput1').geoplaces({
			placePane : '#placePane',
			placeTemplate : 'div.template.place',
			map : '.google-map',
			get : '/places/get',
			add : '/place/saveAjax',
			del : '/place/deleteAjax',
			delay : 1000
		});
	}

	function onShowMessage(dialog) {
		$(dialog.wrap).find("form").validate({
			errorElement : 'p'
		});

		$('#to').tokenInput(this.attr('search'), {
			theme : "tbo",
			hintText : "",
			prePopulate : eval(this.attr('prepopulate'))
		});
	}

	function onShowBasicdata1(a) {
		alert("here");
	}
	function onSubmitProduct(data) {
		// simulates similar behavior as an HTTP redirect
		window.location.replace(data);
	}
});

var _gaq = _gaq || [];
_gaq.push([ '_setAccount', 'UA-29162604-1' ]);
_gaq.push([ '_trackPageview' ]);

(function() {
	var ga = document.createElement('script');
	ga.type = 'text/javascript';
	ga.async = true;
	ga.src = ('https:' == document.location.protocol ? 'https://ssl'
			: 'http://www')
			+ '.google-analytics.com/ga.js';
	var s = document.getElementsByTagName('script')[0];
	s.parentNode.insertBefore(ga, s);
})();
