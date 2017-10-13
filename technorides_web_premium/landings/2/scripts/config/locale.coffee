technoridesApp.config ['$translateProvider', ($translateProvider) ->
    # English

  $translateProvider.translations 'en',
    phoneWarning    : "You must provide valid phone numbers. Please include country and city prefix."
    siteTitle       : "TechnoRides - Evolve and Grow"
    bannerBigTitle  : "TAKE YOUR COMPANY TO THE NEXT LEVEL"
    bannerSubtitle  : "With passenger and driver applications in Android and iOs, we can help your taxi company evolve and grow while making your brand stronger than ever."
    bannerFeat1     : "Passenger App, available for Android & IOS"
    bannerFeat2     : "Driver App, available for Android & IOS"
    bannerFeat3     : "Dispatcher, Call-taker and monitor Dashboards"
    bannerFeat4     : "All customized with your company brand name!"
    bannerTestimony : "'TechnoRides has helped me evolve to meet my costumers needs and make my dispatching more efficient. It has also allowed me to keep track of my drivers while making their work safer and easier. TechnoRides made my company expand and we now provide over double the amount of rides'"
    bannerFormTitle : "get your free demo today"
    Name            : "Name"
    CompanyName     : "Company name"
    Email           : "E-mail"
    PhoneNumber     : "Phone number"
    MobileNumber    : "Mobile number"
    Fleet           : "Fleet"
    drivers         : "Drivers"
    bannerFormButton: "get free trial"
    thankYou        : "Thank you!"
    thankYouMessage : "Your info has been successfully submitted. In a few minutes, one of our representatives will contact you."
    ok              : "Ok"
    whyTechnorides  : "Why TechnoRides?"
    whyTechnorides1 : "Taxi companies must find ways to stem their losses and provide clients with the simplicity and ease that they demand."
    whyTechnorides2 : "Technorides is a solution for taxi companies, limo and shuttle around all over the world. It can empower these companies to offer to their passengers an unique experience they seek, desire and, for all intents and purposes, demand."
    testimonyTitle  : "What our clients say"
    Testimony1      : "'TechnoRides has helped me evolve to meet my costumers needs and make my dispatching more efficient. It has also allowed me to keep track of my drivers while making their work safer and easier. TechnoRides made my company expand and we now provide over double the amount of rides'"
    feature1        : "Real Time Algorithm"
    feature1Desc    : "Reduce by 95% operation time and avoid cancelled trips with our algorithm"
    feature2        : "Digital radio"
    feature2Desc    : "Forgot your old devices! Make your driver happy with our brand new dispatch radio!"
    feature3        : "Marketing Tools"
    feature3Desc    : "Try new ways to attract more clients. Forget your old competitors!"
    getDemoToday    : "Get your free demo today"
    getTrialButton  : "get free trial"
    privaciPolicy   : "Privacy policy"
    TermsOfUse      : "Terms of use"
    ContactUs       : "Contact us"
    FolowUs         : "Follow us"

  $translateProvider.translations 'es',
    phoneWarning    : "Debe ingresar números de teléfono válidos. Por favor incluya prefijo de país y ciudad."
    siteTitle       : "TechnoRides - Adáptese y Crezca"
    bannerBigTitle  : "LLEVE SU EMPRESA AL PRÓXIMO NIVEL"
    bannerSubtitle  : "Con nuestras aplicaciones para pasajero y conductor disponibles en Android y iOS, podemos ayudarlo a que su empresa de taxi evolucione y crezca manteniendo su marca más fuerte."
    bannerFeat1     : "Aplicación Pasajero, disponible para Android & IOS"
    bannerFeat2     : "Aplicación Conductor, disponible para Android & IOS"
    bannerFeat3     : "Paneles operador, telefonista y monitor"
    bannerFeat4     : "Todo personalizado con su marca!"
    bannerFormTitle : "get your free demo today"
    Name            : "Nombre"
    CompanyName     : "Companía"
    Email           : "E-mail"
    Country         : "Pais"
    PhoneNumber     : "Telefono"
    MobileNumber    : "Celular"
    Fleet           : "Flota"
    drivers         : "Conductores"
    bannerFormButton: "get free trial"
    thankYou        : "¡Gracias!"
    thankYouMessage : "Su información ha sido enviada. En unos minutos, uno de nuestros representantes se contactará con usted."
    ok              : "Ok"
    whyTechnorides  : "¿Por qué TechnoRides?"
    whyTechnorides1 : "Las compañías de taxi deben encontrar maneras de frenar sus perdidas y ofrecer a sus clientes simplicidad y facilidad en el servicio que ellos demandan."
    whyTechnorides2 : "Technorides es la solución para empresas de taxi, limos y autos ejecutivos alrededor del mundo. Alienta y empodera a estas compañías para ofrecer a sus pasajeros una experiencia única."
    testimonyTitle  : "Que dicen nuestros clientes"
    Testimony1      : "'TechnoRides me ha ayudado en evolucionar para atender las necesidades de mis clientes y hacer a mis operadores mas eficientes. También me ha ayudado a monitorear a mis choferes permitiéndoles hacer su trabajo mas facil. TechnoRides hizo que mi compañía se expanda y hoy estamos teniendo el doble de viajes.'"
    feature1        : "Algoritmo en tiempo real"
    feature1Desc    : "Reduzca un 95% el tiempo de operacion evite cancelacion de viajes con nuestro sistema"
    feature2        : "Radio digital"
    feature2Desc    : "¡Olvide sus viejos dispositivos! Haga feliz a su conductor con nuestra nueva radio de despacho!"
    feature3        : "Herramientas de Marketing"
    feature3Desc    : "Pruebe nuevas formas de atraer clientes. ¡olvide sus viejos competidores!"
    getDemoToday    : "¡Pruebe gratis Hoy!"
    getTrialButton  : "¡Prueba Gratis!"
    privaciPolicy   : "Política de privacidad"
    TermsOfUse      : "Términos de uso"
    ContactUs       : "Contáctenos"
    FolowUs         : "Síganos"

  # Get browser language and remove localization, i.e en-US > en
  language = navigator.language.replace /-.+/, ""
  # Language supported?
  language = "en" unless $.inArray language, ["en", "es", "fr"]
  # Translate
  $translateProvider.preferredLanguage(language)
 ]