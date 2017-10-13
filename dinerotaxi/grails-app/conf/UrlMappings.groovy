class UrlMappings {
	static mappings = {

		"/"(controller:"index" ,action:"countries")//this is your index action.
		"/admin/"(controller:"admin")//this is your index action.
		"/$controller/$action?/$id?"{
			constraints {
			}
		}
	
		"/$country/$controller/$action?/$id?" {
			constraints {
				country(matches: "(ar|pe|mx)")
			}
		}
//		"/api/$country/$controller/$action?" (parseRequest:true){
//			constraints {
//			  country(matches: "(ar|pe|mx)")
//			}
//		}
		"/$country/inicio"(controller: "index", view: "inicio"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/ganador-openapp"(controller: "index", view: "ganadorOpenapp"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"500"(view:'/dinerotaxi_error',status:500)
		"404"(view:'/dinerotaxi_error',status:404)

		//		---------------FACEBOOK---------------
		"/fb"(controller:"facebook"){baseUrl='fb'}
		"/fb/profile/"(controller:"profile",action:"showfb"){baseUrl='fb'}
		"/fb/watchlists"(controller:"watch",action:"show"){baseUrl='fb'}
		"/fb/quotes/$symbol"(controller:"stock",action:"show"){baseUrl='fb'}
		"/fb/users/$id?"(controller:"profile",action:"showfb"){baseUrl='fb'}
		"/$country/ayuda"(controller:"index", action: "contact"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/ayuda_usuario"(controller:"index", action: "contact"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/ayuda_usuario"(controller:"index", action: "contact"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}

		 "/$country/registracion"(controller:"index", action: "registration") {
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/se_ha_recuperado_la_clave"(controller:"index", action: "completeForgotPassword"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/gracias_por_registrarte_y_pedir_un_taxi"(controller:"index", action: "completePedir"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/gracias_por_registrar_tu_empresa"(controller:"index", action: "completeCompany"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/gracias_por_registrar_tus_taxis"(controller:"index", action: "completeOwner"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/gracias_por_registrarte"(controller:"index", action: "completeTaxi"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/nosotros"(controller:"index", action: "nosotros"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/registrarse_y_pedir_un_taxi"(controller:"index", action: "pedirw"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/movil"(controller:"index", action: "movil"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/sms"(controller:"index", action: "sms"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/facebook"(controller:"index", action: "fb")
		"/$country/seguro_terminos"(controller:"index", action: "termsAndConditions"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/seguro_politicas"(controller:"index", action: "politic"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/contacto"(controller:"index", action: "contact"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/gracias"(controller:"index", action: "contactShow"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/descarga_aplicacion_para_usuario"(controller:"index", action: "download"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/descarga_app_usuario"(controller:"index", action: "download"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/descarga_aplicacion_para_taxista"(controller:"index", action: "downloadTaxista"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}

		"/$country/que_es_dinero_taxi"(controller:"index", action: "queEs"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/beneficios"(controller:"index", action: "beneficios"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/como_funciona_aplicacion_taxista"(controller:"index", action: "comoFuncionaTaxista"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/registro"(controller:"index", action: "registrarse"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/registro_radio_taxi"(controller:"index", action: "registro"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		//usuario regstrado
		"/$country/pedir_taxi"(controller:"home", action: "pedir"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/pedir_ahora"(controller:"home", action: "pedir_ahora"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/mi_cuenta"(controller:"miPanel", action: "index"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/mis_favoritos"(controller:"miPanel", action: "favorites"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/mis_viajes_programados"(controller:"miPanel", action: "calendar"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/mis_datos_personales"(controller:"miPanel", action: "data"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}

		"/$country/salir"(controller:"logout", action: "index"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/entrar"(controller:"login", action: "auth"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}
		"/$country/descarga"(controller:"index", action: "descarga"){
			constraints {
			  country(matches: "(ar|pe|mx)")
			}
		}

		//fin usuario registrado
	}
}
