technoridesApp.config ($translateProvider) ->

  $translateProvider.translations 'en',
    siteTitle     : "Technorides Free Demo"
    FormTitle     : "Request Demo"
    FormSubtitle  : "Get your free demo now!"
    cardName      : "Card Owner Name"
    Email         : "Email"
    Country       : "Country"
    State         : "State"
    City          : "City"
    Zip           : "Zip code"
    BillingAddress: "Billing address"
    Cardnumber    : "Card number"
    CVV           : "CVV"
    ExpMonth      : "Expiration Month"
    ExpYear       : "Expiration Year"
    Request       : "Request"

  $translateProvider.translations 'es',
    siteTitle     : "Technorides Demo Gratis"
    FormTitle     : "Pedir Demo"
    FormSubtitle  : "¡Obtener una demo gratis ahora!"
    cardName      : "Nombre"
    Email         : "Email"
    Country       : "Pais"
    State         : "Estado"
    City          : "Ciudad"
    Zip           : "Codigo postal"
    BillingAddress: "Direccion"
    Cardnumber    : "Numero de tarjeta"
    CVV           : "CVV o codigo de seguridad"
    ExpMonth      : "Mes de caducidad"
    ExpYear       : "Año de caducidad"
    Request       : "Pedir"

  language = navigator.language.replace /-.+/, ""

  language = "en" unless $.inArray language, ["en", "es"]

  $translateProvider.preferredLanguage(language)
