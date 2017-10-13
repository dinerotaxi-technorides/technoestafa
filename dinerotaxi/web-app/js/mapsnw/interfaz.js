	var marcadorTaller = new google.maps.Marker();
	var globito = new google.maps.InfoWindow();
	
	
	function ocultarPublicidad(){
		
		globito.close();
	}
	
	function quitarPublicidad(){
			
		marcadorTaller.setMap(null);
	}
	function centrarMapaEnPublicidad(){
		map.setCenter(-32.915206,-60.676653);
	}
	
	function abrirVentanaPublicidad(){
	
	  globito.open(map,marcadorTaller);
	}
	
	function prepararPublicidad(){	
	
		
		
		var point = new google.maps.LatLng(-22.915206,-60.676653);
	
		var image = new google.maps.MarkerImage(
		  '/banners/iconos/iconoTaller.png',
		  new google.maps.Size(32,37),
		  new google.maps.Point(0,0),
		  new google.maps.Point(16,37)
		);

		var shadow = new google.maps.MarkerImage(
		  '/banners/iconos/iconoTallerShadow.png',
		  new google.maps.Size(54,37),
		  new google.maps.Point(0,0),
		  new google.maps.Point(16,37)
		);
		var shape = {
		  coord: [30,0,31,1,31,2,31,3,31,4,31,5,31,6,31,7,31,8,31,9,31,10,31,11,31,12,31,13,31,14,31,15,31,16,31,17,31,18,31,19,31,20,31,21,31,22,31,23,31,24,31,25,31,26,31,27,31,28,31,29,31,30,30,31,24,32,23,33,22,34,21,35,20,36,11,36,10,35,9,34,8,33,7,32,1,31,0,30,0,29,0,28,0,27,0,26,0,25,0,24,0,23,0,22,0,21,0,20,0,19,0,18,0,17,0,16,0,15,0,14,0,13,0,12,0,11,0,10,0,9,0,8,0,7,0,6,0,5,0,4,0,3,0,2,0,1,1,0,30,0],
		  type: 'poly'
		};

		marcadorTaller.setShape(shape);
		marcadorTaller.setShadow(shadow);
		marcadorTaller.setIcon(image);
		marcadorTaller.setTitle("Taller Jucala");
		marcadorTaller.setPosition(point);
		
		marcadorTaller.setMap(map);
		globito.setContent('<a href="http://www.tallerjucala.com" target="_blank" ><img src="/banners/tallerJucalaAdd.jpg" style="border-style:none;border:0;" /> </a>');
		//globito.open(map,marcadorTaller);
		
	
		
		google.maps.event.addListener(marcadorTaller, 'click', function() {
			globito.setContent('<a href="http://www.tallerjucala.com" target="_blank" ><img src="/banners/tallerJucalaAdd.jpg" style="border-style:none;border:0;" /> </a>');
			globito.open(map,marcadorTaller);
			
		});
		
		
			
	}
	
	//fin publicidad.js
		var toggleTarifas = true;
		
	
	  function doCheck() {
        if ($(this).hasClass('checked')) {
            $(this).removeClass('checked');
            $(this).children().prop("checked", false);
        } else {
            $(this).addClass('checked');
            $(this).children().prop("checked", true);
        }
    }

    function doDown() {
        $(this).addClass('clicked');
    }

    function doUp() {
        $(this).removeClass('clicked');
    }
	
	
		
	
	
	$(document).ready(function(){
		
		
		
	
		$("#taximetro-print").click(function(event){
			$("#tarifas").css('display','inline');
			$("#taximetro").css('display','none');
			window.print();
			});
		
		$("#taximetro a").click(function(event){
			
			event.preventDefault();
			
			$("#taximetro a").removeClass("activado");
			
			$(this).addClass("activado");
			
			
			cambiarRuta($(this).attr("id"));
			
			
			
			
		})
		
		
		$("#input-mapa-origen").click(function(){
			
			seleccionarPuntoMapa("origen");
		});
		
		
		$("#input-mapa-destino").click(function(){
			
			seleccionarPuntoMapa("destino");
		});
		
		
		
		

$("#taximetro").draggable({ containment: "#cont_tax" });

		
		  
		
		
		
		
		
		
		$("#boton-calcular").click(function(event){
			
			event.preventDefault();
			
			if($("input[name=input-origen]").val() == "Origen"   ||   $("input[name=input-destino]").val() == "Destino" ){
				preCalcular();
				
			}else{
							
				preCalcular();		
				
				var aux_taximetro = $("#taximetro").css('display');
				
				$("#taximetro").css('display','block');
				if (aux_taximetro == "none")
				{
					$("#taximetro").css('top','5px');
					$("#taximetro").css('left','600px');
				}
	
				$("#cartel-real").css('background-position','110px 0');
				
			}
			
			
			
		});
		
		$("#select-origen").change(function(){
			
			$("input[name=input-origen]").val($(this).val());
			
			
		});
		
		
		$("#select-destino").change(function(){
			
			$("input[name=input-destino]").val($(this).val());
			
			
		});
		
		
		
		$("#invertir-rutas").click(function(event){
			
			event.preventDefault();
			
			var i = $("input[name=input-origen]").val();
			
			 $("input[name=input-origen]").val( $("input[name=input-destino]").val());
			 
			 			 
			 $("input[name=input-destino]").val(i);
			 
			 preCalcular();
			
			
		})
		
		$("#boton-tarifa-normal").click(function(){
			$(this).attr("src","../../images/mapsnw/boton-tarifa-normal-check.jpg");			
			$("#boton-tarifa-especial").attr("src","../../images/mapsnw/boton-tarifa-especial.jpg");
			$("input[name=tarifa-normal]").attr("checked",true);
			$("input[name=tarifa-especial]").attr("checked",false);
		});
		
		
	
		
		$("#boton-tarifa-especial").click(function(){
			
			$(this).attr("src","../../images/mapsnw/boton-tarifa-especial-check.jpg");
			$("#boton-tarifa-normal").attr("src","../../images/mapsnw/boton-tarifa-normal.jpg");
			$("input[name=tarifa-normal]").attr("checked",false);
			$("input[name=tarifa-especial]").attr("checked",true);
			
		});
		
		
		


	    $('.check-adicional').each(function() {
	        var span = $('<span class="' + $(this).attr('type') + ' ' + $(this).attr('class') + '"></span>').click(doCheck).mousedown(doDown).mouseup(doUp);
	        if ($(this).is(':checked')) {
	            span.addClass('checked');
	        }
	        $(this).wrap(span).hide();
	    });
	    
	     
		
		
		
		
		
		
		
		$("#ver-tarifas").click(function(){
			
			
			if(toggleTarifas === true){
								
				$("#tarifas").css("display","inline").css("height","0").animate({
							height:"210px",
							"padding-top":"20px"
				},500);
				//console.log("toggle")
			
				
				toggleTarifas = false;
				
			}else{
				$("#tarifas").animate({
							height:"0px",
							"padding-top":"-20px"
				},500 , function(){
						$(this).css("display","none");
				});
				
				toggleTarifas = true;
				
			}
			
		});	
		
		
		$(function() {
    $("#form-calcular").keypress(function (e) {
        if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
            $('#boton-calcular').click();
            return false;
        } else {
            return true;
        }
    });
});
		/*$("#input-origen,#input-destino").keypress(function(event){
			code= (event.keyCode ? event.keyCode : event.which);
            if (code == 13)
            	event.preventDefault();
            
            //calcular tarifa
			
			
		});*/
		
		//tarifa especial / normal
		//$("#boton-tarifa-normal").click();
		//$("#boton-tarifa-especial").click();
			
			    //select all the a tag with name equal to modal
			    
			    
			    
			    
   
	
				
});
	
	