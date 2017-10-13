technoridesApp.config ['$translateProvider', ($translateProvider) ->
    # English
    $translateProvider.translations 'en',
      WelcomeMessage   : 'Welcome to the new TechnoRides panels'
      PanelFeature1    : 'Fully Responsive Layout'
      PanelFeature2    : 'Real time data'
      PanelFeature3    : 'Retina Ready'
      PanelFeature4    : 'Easy to use'
      PanelLastFeature : 'and much more...'
      SignIn           : 'Sign In'
      ForgotPassword   : 'Forgot Your Password?'
      copyRights       : '2014. All Rights Reserved. TechnoRides'
      LoginToAccess    : 'Login to access the Dashboard.'
      stableVersionLink: 'This beta version may not work properly. Click here to go back to the previous version.'
      User             : 'User'
      Password         : 'Password'
      forgotModal      : "If you’re a dispatcher, monitor or call talker please contact your manager to reset your password otherwise if you’re the manager of the account for security reasons you’ll have to send us an email to reset it at support@technorides.com"
      
    # Spanish
    $translateProvider.translations 'es',
      WelcomeMessage   : 'Bienvenido al nuevo panel de operaciones'
      PanelFeature1    : 'Fully Responsive Layout'
      PanelFeature2    : 'Real time data'
      PanelFeature3    : 'Retina Ready'
      PanelFeature4    : 'Easy to use'
      PanelLastFeature : 'and much more...'
      SignIn           : 'Ingresar'
      ForgotPassword   : '¿Olvidaste tu contraseña?'
      copyRights       : '2014. All Rights Reserved. TechnoRides'
      LoginToAccess    : 'Identifíquese para acceder al Panel.'   
      stableVersionLink: 'Esta es una versión beta que puede no andar correctamente. Haga click aquí para volver a la versión anterior.'
      User             : 'Usuario'
      Password         : 'Contraseña'
      forgotModal      : "Si tu rol es operador, monitor y/o telefonista, para restablecer tu contraseña deberas contactarte con el administrador de la cuenta. En el caso que tu rol sea administrador por medidas de seguridad deberas requerir tu nueva contraseña via email a support@technorides.com"
    
    # French
    $translateProvider.translations 'fr',
      WelcomeMessage   : 'Welcome to the new TechnoRides panels'
      PanelFeature1    : 'Fully Responsive Layout'
      PanelFeature2    : 'Real time data'
      PanelFeature3    : 'Retina Ready'
      PanelFeature4    : 'Easy to use'
      PanelLastFeature : 'and much more...'
      SignIn           : 'Sign In'
      ForgotPassword   : 'Forgot Your Password?'
      copyRights       : '2014. All Rights Reserved. TechnoRides'
      LoginToAccess    : 'Login to access the panel.'     
      stableVersionLink: 'Cette version de la page est trés instable, appuyez ici pour une meilleure version.'
      User             : 'Utilisateur'
      Password         : 'Mot de passe'
      forgotModal      : "If you’re a dispatcher, monitor or call talker please contact your manager to reset your password otherwise if you’re the manager of the account for security reasons you’ll have to send us an email to reset it at support@technorides.com"
    # Get browser language and remove localization, i.e en-US > en
    language = navigator.language.replace /-.+/, ""
    # Language supported?
    language = "en" unless $.inArray language, ["en", "es", "fr"]
    # Translate
    $translateProvider.preferredLanguage(language)
]
