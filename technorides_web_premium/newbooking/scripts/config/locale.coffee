technoridesApp.config ['$translateProvider', ($translateProvider) ->

  $translateProvider.translations 'en',
    Sended: "Sended"
    Success:  "Success!"
    Congrats: "Congrats!"
    en  : "English"
    es  : "Español"
    page:
      title  : "Technorides"

    alertChrome: "IMPORTANT: This web page can only be used on Google Chrome and Firefox"

    #MAIN PAGE
    index:
      login          :
        username        : "Username"
        password        : "Password"
        forgotPass      : "Forgot password?"
        forgotPassText  : "We will send you a new password to your email account"
        forgotPass  : "Forgot password?"
        retrive     : "Retrieve password"
      banner:
        text : "Want to work with us?"

      sections :
        passengers  : "Passengers"
        drivers     : "Drivers"
        enterprises : "Businesses"
        home        : "Home"
        features    : "Features"
        contact     : "Contact"
        login       : "Login"
        signup      : "Sign up"
        contactUs   : "Contact us"
        howItWorks  : "How it works"
        advantages  : "advantages"
        apps        : "Apps"
      labels :
        user       : "User"
        lastName   : "Last Name"
        password   : "Password"
        cancel     : "Cancel"
        phone      : "Phone"
        address    : "Address"
        name       : "Name"
        youare     : "You are ..."
        driver     : "Driver"
        driverInfo :  "Driver"
        passenger  : "Passenger"
        enterprise  : "Businesses"
        email      : "Email"
        subject    : "Subject"
        message    : "Message"
        send       : "Send"
        companyName: "Company name"
        contactName: "Contact name"

    home :
      separatedTitle1  : "Your"
      separatedTitle2  : "ride"
      separatedTitle3  : "one touch away"
      headerDescription : "The number one taxi solution for consumers and businneses."
      header :
        button1  : "Book now"
        button2  : "View features"
      downloadApps  : "Download our app in your store and enjoy the best taxi solution for your needs"
      users:
        title1  : "The"
        title2  : "best taxi experience"
        title3  : "for everyone"
      features:
        title  : "Features"
        learnMore  : "Learn more"
        passengers :
          feat1  : "Booking web"
          feat1Text  : "Not a mobile user? Don't worry! Book a cab online 24/7"
          feat2  : "Mobile apps"
          feat2Text  : "Find and book a cab easily with the tap of a button, all on a single screen."
        enterprises :
          feat1  : "Keep the control"
          feat1Text   : "Manage all the operations in one place, all-in one billing system."
          feat2  : "Manage your employees"
          feat2Text  :  "Save time and create employees one step at the time."
        drivers :
          feat1  : "Get more trips"
          feat1Text   : "The app sends you requests from consumers and businesses"
          feat2  : "Better communication"
          feat2Text  :  "Chat and send voice messages to your dispatchers and co-workers"

    enterprise:
      separatedTitle1  : "Stop"
      separatedTitle2  : "worrying"
      separatedTitle3  : "about receipts and refunds"
      subTitle         : "Reduce your company's taxi spendings by up to 40% and improve your employees travel experience"
      header :
        button1  : "Hire us"
        button2  : "view features"
      features :
        title  : "The best taxi solution for your company"
        feature1 :
          title : "keep the control"
          description : "Manage your employees, departments and control your expenses. All-in-one billing system. Monitor rides online and download reports 24/7."
          subfeature1  : "Metrics"
          subfeature2  : "Departments"
          subfeature3  : "Employees"
        feature2 :
          title  : "Reduce costs"
          description : "Make it simple by eliminating receipts and using our integrated billing system in the apps. Access all the data anywhere, anytime, one click away."
          subfeature1  : "History"
          subfeature2  : "Reports"
          subfeature3  : "Billing"
        feature3 :
          title  : "Order anywhere"
          description : "Request a Cab cab from your smartphone or the internet, just one click away."
          subfeature1  : "Android"
          subfeature2  : "iPhone"
          subfeature3  : "Web"
      howItWorks :
        title  : "How it works"
        tab1  :
          title  : "Company"
          titleButton  : "start now"
          step1 :
            title  : "1. Register"
            text  : "your Company with {{company}} Corporate"# {{company}} its a variable, do not translate
          step2 :
            title  : "2. Training"
            text  : "Get customized training so you can get the most of our enterprise features"
          step3 :
            title : "3. Set up"
            text  : "Set {{company}} Corporate plataform to meet your needs"# {{company}} its a variable, do not translate
          step4 :
            title : "4. Add your staff"
            text  : "Add your employees and departments. Enjoy the best enterprise taxi solution!"
        tab2 :
          title  : "Employees"
          titleButton  : "start now"
          step1 :
            title  : "1. Wait for registration"
            text  : "You will receive your access information by e-mail"
          step2 :
            title  : "2. Log in the app"
            text  : "Download the app or enter in the booking website with your information"
          step3 :
            title : "3. Ask for your corporate taxi"
            text  : "Connect with the cab that is just 5 minutes away from you by the apps, the booking website or even by phone"
          step4 :
            title : "4. Pay for your ride"
            text  : "Forget about paper receipts, send the receipts to your company from the app."

    driver:
      separatedTitle1  : "Get more"
      separatedTitle2  : "clients"
      separatedTitle3  : "and make more money"
      subTitle         : "The app sends you requests from consumers and business all over the city"
      header :
        button1  : "Join us"
        button2  : "view features"
      advantages :
        title  : "Advantages"
        description : "Accept rides with a tap of a button. It's easy and intuitive. More Passengers = Higher Income!"
        feature1 :
          title : "Stay in touch"
          description  : "Friendly interface that suites your needs, integrated digital radio and chat to connect with your co-workers and dispatchers 24/7 "
        feature2 :
          title  : "Get more trips"
          description  : "See the preview of any trip to accept or decline it depending on your needs. Receive all the nearest trips to your location and accept them with one click. "
        feature3 :
          title  : "Corporate rides"
          description  : "Tired of keeping receipts and complicated math accounts? All-in-one corporate system integrated in the apps. Embrace the digital era, one step at the time."
        feature4 :
          title  : "Geolocation"
          description  : "Get the directions to pick up your passenger integrated in the app with Google Maps. Improve your possition and let your passenger know when you're arriving. "
      apps:
        title  : "Discover our amazing mobile apps"
        android :
          button  : "Android"
          feature1 :
            title  : "Easy to use"
            description  : "Friendly interface that suites your needs"
          feature2 :
            title  : "Digital walkie talkie"
            description  : "Connect with the dispatchers and co-workers in real time by voice messages."
          feature3 :
            title  : "trip history"
            description  : "Get all your trips information in one place, corporate, regular or schedule."
          feature4 :
            title  : "Scheduled agenda"
            description  : "Manage all your incoming trips, preview the trip detail or cancel them as needed."
          feature5 :
            title  : "Messages"
            description  : "Send messages to any dispatcher or co-worker for FREE"
          feature6 :
            title  : "Metrics"
            description  : "Track your corporates rides balance and collect the incomes inside the app."
        iphone :
          button  : "iPhone"
          feature1 :
            title  : "Easy to use"
            description  : "Friendly interface that suites your needs"
          feature2 :
            title  : "Digital walkie talkie"
            description  : "Connect with the dispatchers and co-workers in real time by voice messages."
          feature3 :
            title   : "trip history"
            description   : "Get all your trips information in one place, corporate, regular or schedule."
          feature4 :
            title  : "Scheduled agenda"
            description  : "Manage all your incoming trips, preview the trip detail or cancel them as needed."
          feature5 :
            title  : "Messages"
            description  : "Send messages to any dispatcher or co-worker for FREE"
          feature6 :
            title  : "Metrics"
            description  : "Track your corporates rides balance and collect the incomes inside the app."
      howitWorks :
        button  : "Join us"
        step1 :
          title  : "1. Register"
          text  : "with {{company}} and wait to receive your access information by e-mail"# {{company}} its a variable, do not translate
        step2 :
          title  : "2. Training"
          text  : "Get customized training so you can get the most of our app features."
        step3 :
          title : "3. Login"
          text  : "Download the app on your phone and start accepting trips right away!"
        step4 :
          title : "4. Join our Corporate system"
          text  : "Start accepting corporate rides. Enjoy the best enterprise taxi solution!"
    passenger:
      separatedTitle1  : "Your"
      separatedTitle2  : "ride"
      separatedTitle3  : "one touch away"
      subTitle         : "Turn your booking into an exceptional experience"
      header :
        button1  : "Book now"
        button2  : "view features"
      advantages :
        title  : "Advantages"
        description : "Getting around town is just two taps away. Book a taxi and get to that all important business meeting, your favourite restaurant or the next shopping spree in style. Quick, safe and reliable is right at your fingertips."
        feature1 :
          title  : "Easy to use"
          description  : "Enjoy a seamless app & top-notch service. Effortless payment through your phone. "
        feature2 :
          title  : "Arrive on time"
          description  : "{{company}} is just minutes away and super reliable. We are there when you need us and you can prebook up to four weeks in advance."# {{company}} its a new variable, please add it
        feature3 :
          title  : "Enterprise rides"
          description  : "{{company}} for Business offers reliable, speedy and safe transport for your entire company. Taxis and executive cars can be booked through the app or online with our booking website."# {{company}} its a new variable, please add it
        feature4 :
          title  : "Safer rides"
          description  : "Track your driver's identity and cab info on the go. Only verified drivers. We properly train all our drivers, and perform a thorough background check."
      apps:
        android :
          button  : "Android"
          feature1 :
            title  : "Easy to use"
            description  : "The sleek design encapsulates a dynamic interface with more pickup options, and in-app payment! A friendly interface that suites your needs."
          feature2 :
            title  : "Arrive on time"
            description  : "Follow them on the map and in minutes they'll be at the location you requested."
          feature3 :
            title  : "Trip history"
            description  : "Access to your history trips anytime, and get all the information always."
          feature4 :
            title  : "Scheduled agenda"
            description  : "Prebook up to four weeks in advance any service, corporate or regular."
          feature5 :
            title  : "Messages"
            description  : "Message your driver on the go or call him for any inquiry!"
          feature6 :
            title  : "Metrics"
            description  : "Check your latest payments and update your profile information."
        iphone :
          button  : "iPhone"
          feature1 :
             title  : "Easy to use"
            description  : "The sleek design encapsulates a dynamic interface with more pickup options, and in-app payment! A friendly interface that suites your needs."
          feature2 :
            title : "Arrive on time"
            description  : "Follow them on the map and in minutes they'll be at the location you requested."
          feature3 :
            title  : "Reference point"
            description  : "Let your driver know where to pick you up by writing a reference pick up point."
          feature4 :
            title  : "Options"
            description  : "Let us know if you need special assistance, invoicing, or a big car."
          feature5 :
            title  : "Messages"
            description  : "Message your driver on the go or call him for any inquiry!"
          feature6 :
            title  : "Metrics"
            description  : "Check your latest payments and update your profile information."
      howitWorks :
        button  : "Join us"
        step1 :
          title  : "1. Register"
          text  : "with {{company}} or through the apps"# {{company}} its a variable, do not translate
        step2 :
          title  : "2. Log in"
          text  : "Download the app or enter the booking website and login with your information"
        step3 :
          title : "3. Book a taxi"
          text  : "The app will automatically locate your address using GPS. Tap 'Request'. You are ready to go!"
        step4 :
          title : "4. Enjoy your ride"
          text  : "Watch how the app assigns a nearby taxi, follow them and in minutes they'll be at the location you requested."

    signup :
      title          : "Sign Up"
      mailEnterprise:
        subject  : ""
      mailDriver :
        subject :  ""
      useFacebook  : "sign up with facebook"
      useGoogle  : "sign up with google +"
      title1  : "The"
      title2  : "best transport"
      title3  : "solution for everyone"
      subtitle  : "Signup into our website"
      unique   : "This email its already in use, try another one"
      features :
        title  : "Join now and get instant access"
        feat1 :
          title  : "titulo1"
          text  : "titulo1"
        feat2 :
          title  : "titulo1"
          text  : "titulo1"
        feat3 :
          title  : "titulo1"
          text  : "titulo1"
        feat4 :
          title  : "titulo1"
          text  : "titulo1"
    booking:
      navbar :
        welcome    : "Welcome back"
        order      : "order"
        favorites  : "favorites"
        profile    : "profile"
        history    : "history"
        scheduled  : "scheduled"
        contact    : "contact"
      #common labels
      labels    :
        name         : "Name"
        save         : "Save"
        phoneNumber  : "Phone number"
        mail         : "Email"
        subject      : "Subject"
        content      : "Content"
        send         : "Send"
        lastName     : "Last name"
        password     : "Password"
        cancel       : "Cancel"

      #orderTab
      order :
        estimatedPrice        : "Estimated price"
        title                 : "Request cab"
        pickUp                : "Pick-up"
        address               : "Address"
        floor                 : "Floor"
        apartment             : "Apartment"
        dropOff               : "Drop-off"
        scheduledRide         : "Scheduled ride"
        passengerInformation  : "Passenger information"
        passengerName         : "Passenger name"
        phoneNumber           : "Phone number"
        extras                : "Extras"
        options               : "Options"
        comments              : "Comments"
        order                 : "Order"
        searchingTaxi         : "Searching taxi..."
        pleaseWait            : "Please wait a few seconds"
        opnum                 : "Operation Nº"
        cancel                : "Cancel ride"
        driverInfo            : "Driver information"
        carPlate              : "Car Plate"
        carModel              : "Car Model"
        rideInProgress        : "Ride in progress"
        tankyou               : "Thank you for using"
        problems              : "If you have a problem please call to"
        rideInfo              : "Ride Information"
        sendSms               : "Send SMS"
      #common trip options
      options :
        courier          : "Courier"
        pets             : "Pets"
        airConditioning  : "Air conditioning"
        smoker           : "Smoker"
        specialAsistance : "Special Asistance"
        airport          : "Airport"
        luggage         : "Luggage"
        vip              : "VIP"
        invoice          : "Invoice"
      # profile tab
      profile :
        title                : "My profile"
        personalInfo         : " Personal information"
        changePassword       : "Change password"
        contactInformation   : " Contact information"
        currentPass          : "Current password"
        newPass              : "New password"
        repeatNewPass        : "Repeat new Password"
        change               : "Change"
        mustBeSamePass       : "Password its not the same!"
      # scheduled tab
      scheduled :
        title  : "Scheduled rides"
        norides : "There are no scheduled rides at the time"
      # contact tab
      contact :
        title    : "Contact"
        callUs   : "Call us"
        sendUsEmail : "Send us an email"
      history :
        title    : "History trips"
        norides  : "You have no history trips"
      modals :
        loginAccountLocked: "Your account has been locked, contact us for more information"
        signUpDriver  : "Congratulations!, you have been requested to be one of our drivers! We will contact you soon :)"
        signUpEnterprise  : "Congratulations!, you have been requested our service as a company, one of our representative will contact you soon!"
        geolocationDisabled  : "Goelocation is disabled, please allow browser geolocation service, in your searchbar"
        geolocationError  : "Goelocation error, please try again later"
        ok  : "Ok"
        driverAtDoor  : "Driver is at your door!"
        driverCanceled  : "Driver has canceled your trip, we're searching another driver, please wait..."
        editProfileError : "There's been an error updating your profile, please try again"
        editProfileSuccess  : "Profile edited succesfully!"
        emailError   : "There's been a error sending the mail, please try again"
        emailSuccess  : "Email sended succesfully! we will contact you soon"
        forgotPassError  : "Your email is incorrect, please, try again"
        forgotPassSuccess  : "Email sended succesfully!"
        loginError       : "Incorrect user or password, please try again."
        operationCanceled  : "Operation has been canceled!"
        createOperationError  : "Failed to create trip, please try again!"
        operationFinished  : "Congratulations your trip has finished!"
        passwordChangeIncorrect  : "Your original password is incorrect, please try again"
        passwordChangeShort  : "Your new password is too short, please try again"
        passwordChangeSuccess  : "Your password has been changed correctly!"
        ringUser           : "Driver is buzzing you !"
        scheduledError   : "Scheduled trip failed to be created, please try again"
        scheduledSuccess  : "YAY! you have created a scheduled trip, go to 'scheduled' tab, to check all your scheduled trips!"
        send  : "Send"
        signUpError  : "There's been a problem with your registration, please try again"
        emailExist: "This Email is already registered!"
        sendMessageToDriver :
          wait : "Wait me for 5 minutes"
          waiting  : "Waiting"
          onMyWay  : "On my way"
          ok     : "Ok"
        driverMessages :
          onway   : "I'm arriving"
          wait  : "Heavy traffic. I'll be there on 10 min."
          waiting : "Im waiting"
          ok  : "Ok!"

    corporate :
      modals :
        error              : "An error has ocurred, please try again"
        changedProfile     : "Profile changed succesfuly!"
        profileNotChanged  : "There's been an error updating your profile, please try again"
      profile :
        basicInformation   : "Basic Information"
        companyName        : "Company name"
        taxIdentification  : "Tax identification number"
        phone              : "Telephone"
        location           : "Location"
        address            : "Address"
      NoRecordsAvailable  : "There are no records available"
      sections :
        dashboard    : "Dashboard"
        costCenters  : "Departments"
        employees    : "Employees"
        billing      : "Billing"
        history      : "Operations History"
        orderTaxi    : "Order Taxi"
        logout       : "Log Out"
        profile      : "Profile"
      dashboard :
        toPay  : "To pay"
        totalCost  : "Total cost"
        paid       : "Paid"
        operations  : "Operations"
        lastWeek     : "last week"
        lastMonth    : "last month"
        opsByShift   : "Operations by shift"
        monthExpenses  : "Month expenses"
        Night  : "Night"
        Midday  : "Midday"
        Morning  : "Morning"
        Afternoon  : "Afternoon"
        months  :
          0 : "Junuary"
          1 : "February"
          2 : "March"
          3 : "April"
          4 : "May"
          5 : "June"
          6 : "July"
          7 : "August"
          8 : "September"
          9  : "October"
          10 : "November"
          11 : "December"
      billing :
        informPayment  : "Inform payment"
        enabled  : "Enabled"
        disabled  : "Disabled"
      invoice :
        payments  : "Payments"
        PARTIALLY_PAID : "Partially paid"
        PENDING  : "Pending"
        OVERDUE  : "Overdue"
        PAID  :  "Paid"
        lateFee  : "Late Fee"
        term  : "Term"
        subtotal  : "Subtotal"
        adjustments  : "Adjustments"
        total  : "Total"
        paid  : "Paid"
        remaining  : "Remaining"
        comments  : "Comments"
      labels :
        dateTo  : "Since"
        dateFrom  : "To"
        companyAdmin   : "Company Manager"
        save  : "Save"
        options  : "Options"
        user  : "User"
        tax  : "Tax"
        discount : "Discount"
        price : "Price"
        quantity  : "Quantity"
        itemydesc  : "Item & description"
        date  : "Date"
        invoice  : "Invoice#"
        amount   : "Amount"
        balanceDue  : "Balance Due"
        status  : "Status"
        dueDate  : "Due date"
        id  : "ID#"
        name  : "Name"
        from  : "From"
        to  : "To"
        admin  : "Supervisor"
        passenger  : "Passenger"
        password   : "Password"
        lastName   : "Last name"
        phone    : "Phone"
        email     : "Email"
        cancel   : "Cancel"
        ok     : "Ok"
        reference  : "Reference"
        comments :  "Comments"
        paymentMethod  : "Payment method"
      employees :
        newEmployee  : "+ New Employee"
      employee :
        active : "Active"
        blocked  : "Blocked"
        blockUser  : "Block user"
        totalTrips  : "Total trips*"
        totalExpenses : "Total expenses*"
        monthly:  "*Monthly"
      history :
        operationDetail  : "Operation Details"
      filters :
        noFilter  : "Don't Filter"
        pending  : "Pending"
        overdue   : "Overdue"
        paid      : "Paid"
        partialyPaid  : "Partially paid"
        completed : "Completed"
        canceled  : "Canceled"
        active   : "Active"
        blocked  : "Blocked"
      orders  :
        alfabetic  : "Alphabetical order"
        amount   : "Amount"
        date     : "Date"
        dueDate   : "Due date"
        noOrder  : "Don't Order"
      company :
        taxIdentification  : "Tax identification"
        users : "Users"
        debt  : "Debt"
        editCostCenter : "Edit Departments"
        addCostCenter : "Add Departments"
      filterBy : "Filter by"
      orderBy  : "Order by"
      reportPayment:
        subject    : "Corporate | new payment report"
        reference  : "Reference"
        method     : "Method"
        comments   : "Comments"

  $translateProvider.translations 'es',
    Sended: "Enviado"
    Success:  "Exito!"
    Congrats: "Felicitaciones!"
    en  : "English"
    es  : "Español"
    page:
      title  : "Technorides"

    alertChrome: "IMPORTANTE: Esta pagina es soportada únicamente por Google Chrome y Firefox"

    #MAIN PAGE

    index:
      login:
        username        : "Usuario"
        password        : "Contraseña"
        forgotPass      : "¿Ha olvidado su contraseña?"
        forgotPassText  : "Le enviaremos su nueva contraseña a su correo electrónico."
        forgotPass  : "¿Ha olvidado su contraseña?"
        retrive     : "Recuperar contraseña"

      banner:
        text : "¿Desea trabajar con nosotros?"

      sections :
        passengers_GENERIC  : "Pasajeros"
        passengers_DELIVERY  : "Usuario"
        drivers_GENERIC     : "Conductores"
        drivers_DELIVERY     : "Motorizados"
        enterprises : "Empresas"
        home        : "Inicio"
        features    : "Funcionalidades"
        contact     : "Contacto"
        login       : "Ingresar"
        signup      : "Registrarse"
        contactUs   : "Contacto"
        howItWorks  : "¿Cómo funciona?"
        advantages  : "Ventajas"
        apps        : "Apps"
      labels :
        user       : "Usuario"
        lastName   : "Apellido"
        password   : "Contraseña"
        cancel     : "Cancelar"
        phone      : "Teléfono"
        address    : "Dirección"
        name       : "Nombre"
        youare     : "Eres un..."
        driverInfo  : "Conductor"
        driverInfo_DELIVERY     : "Motorizado"
        driverInfo_GENERIC     : "Conductor"
        passenger_GENERIC  : "Pasajero"
        passenger_DELIVERY  : "Usuario"
        enterprise  : "Empresa"
        email      : "Email"
        subject    : "Asunto"
        message    : "Mensaje"
        send       : "Enviar"
        companyName: "Nombre de empresa"
        contactName: "Nombre de contacto"

    home :
      separatedTitle1  : "El"
      separatedTitle2  : "mejor servicio"
      separatedTitle3  : "al alcance de tu mano"
      headerDescription_GENERIC : "La solución número uno en taxis para clientes y empresas."
      headerDescription_DELIVERY : "La solución número uno en motorizados para clientes y empresas."
      header :
        button1  : "Reservar ahora"
        button2  : "Cómo funciona"
      downloadApps_GENERIC  : "Descarga nuestra app desde cualquier tienda y disfruta de la mejor experiencia de taxis."
      downloadApps_DELIVERY  : "Descarga nuestra app desde cualquier tienda y disfruta de la mejor experiencia de motorizados."
      users:
        title1  : "La"
        title2_GENERIC  : "mejor experiencia de taxis"
        title2_DELIVERY  : "mejor experiencia de motorizados"
        title3  : "para todo el mundo"
      features:
        title  : "Funcionalidades"
        learnMore  : "Saber más"
        passengers :
          feat1  : "Web de Pedidos"
          feat1Text_GENERIC  : "No cuentas con un smartphone? No te preocúpes! Píde tu taxi en línea las 24hs."
          feat1Text_DELIVERY  : "No cuentas con un smartphone? No te preocúpes! Píde tu motorizado en línea."
          feat2  : "Aplicaciónes móviles"
          feat2Text_GENERIC  : "Encuéntra y reserva un taxi rápidamente en tan solo un clíck."
          feat2Text_DELIVERY  : "Encuéntra y reserva un motorizado rápidamente en tan solo un clíck."
        enterprises :
          feat1  : "Mantén el control"
          feat1Text   : "Organiza todas tus operaciones en un mismo lugar a través de nuestro sistema corporativo."
          feat2  : "Maneja tus empleados"
          feat2Text  :  "Ahorra tiempo y ordena tus empleados por áreas."
        drivers :
          feat1  : "Obtén más clientes"
          feat1Text   : "La aplicación te envía solicitudes de clientes y empresas"
          feat2  : "Mantente conectado"
          feat2Text_GENERIC  :  " Envía mensajes de audio y texto a tus operadores y conductores amigos."
          feat2Text_DELIVERY  :  " Envía mensajes de audio y texto a tus operadores y motorizados amigos."

    enterprise:
      separatedTitle1  : "Deja de"
      separatedTitle2  : "preocuparte"
      separatedTitle3  : "por reembolsos y recibos"
      subTitle_GENERIC         : "Reduce los gastos de tu empresa en taxi hasta un 40% y mejora la comodidad de tus empleados"
      subTitle_DELIVERY         : "Reduce los gastos de tu empresa en motorizado hasta un 40% y mejora la comodidad de tus empleados"
      header :
        button1  : "Contrátenos"
        button2  : "Ver funcionalidades"
      features :
        title_GENERIC  : "La solución número uno en taxis para clientes y empresas"
        title_DELIVERY  : "La solución número uno en motorizados para clientes y empresas"
        feature1 :
          title : "Mantén el control"
          description_GENERIC : "Maneja tus empleados, áreas y controla tus gastos. Sistema de facturación corporativo integrado. Monitorea las carreras de manera online y descarga reportes las 24 horas."
          description_DELIVERY : "Maneja tus empleados, áreas y controla tus gastos. Sistema de facturación corporativo integrado. Monitorea las carreras de manera online y descarga reportes."
          subfeature1  : "Métricas"
          subfeature2  : "Centros de Costos"
          subfeature3  : "Empleados"
        feature2 :
          title  : "Reduce costos"
          description : "Olvídate de los recibos en papel y utiliza nuestro sistema digital de facturación integrado en todas las Apps. Accede a tu información en cualquier lugar, en cualquier momento, a un click de distancia."
          subfeature1  : "Historial"
          subfeature2  : "Reportes"
          subfeature3  : "Facturación"
        feature3 :
          title  : "Desde cualquier lugar"
          description_GENERIC : "Solicita un taxi desde tu smartphone o internet, a un click de distancia."
          description_DELIVERY : "Solicita un motorizado desde tu smartphone o internet, a un click de distancia."
          subfeature1  : "Android"
          subfeature2  : "iPhone"
          subfeature3  : "Web"
      howItWorks :
        title   : "¿Cómo funciona?"
        tab1 :
          title   : "Empleados"
          titleButton   : "Empieza ahora"
          step1 :
            title  : "1. Aguarda tu registración"
            text  : "Recibirá su información de acceso via e-mail"
          step2 :
            title  : "2. Ingresa en la app"
            text  : "Descarga la App o ingresa desde la página web de pedidos con tu usuario."
          step3 :
            title_GENERIC : "3. Solicita su taxi corporativo"
            title_DELIVERY : "3. Solicita su motorizado corporativo"
            text_DELIVERY  : "Ve en tiempo real a los motorizados más cercanos al pedir desde las Apps o la página web de pedidos."
            text_GENERIC  : "Ve en tiempo real a los conductores más cercanos al pedir desde las Apps o la página web de pedidos."
          step4 :
            title : "4. Abona tu viaje online"
            text  : "Olvídate de los vouchers  o vales de papel, envía a tu empresa los recibos digitales desde la App."
        tab2 :
          title  : "Empresa"
          titleButton  : "Empezar"
          step1 :
            title  : "1. Regístre"
            text  : "su Empresa en {{company}} Corporativo"# {{company}} its a variable, do not translate
          step2 :
            title  : "2. Capacitación"
            text  : "Obténga capacitaciones ajustadas a su medida para aprovechar al máximo nuestras funcionalidades corporativas."
          step3 :
            title : "3. Configuración"
            text  : "Configure {{company}} Corporativo de acuerdo a sus necesidades"# {{company}} its a variable, do not translate
          step4 :
            title : "4. Agregue su equipo"
            text_GENERIC  : "Agregue sus empleados y áreas. Disfrúte la solución número uno en taxis para empresas!"
            text_DELIVERY  : "Agregue sus empleados y áreas. Disfrúte la solución número uno en motorizados para empresas!"

    driver:
      separatedTitle1  : "Obtiene mas"
      separatedTitle2  : "clientes"
      separatedTitle3 : "y gana mas dinero"
      subTitle         : "La aplicación le envía solicitudes de clientes y empresas alrededor de su ciudad"
      header :
        button1  : "Únete"
        button2  : "Ver funcionalidades"
      advantages :
        title  : "Ventajas"
        description_GENERIC : "Acepta solicitudes tocando un botón, es fácil e intuitivo. Más pasajeros = Ingresos más altos!"
        description_DELIVERY : "Acepta solicitudes tocando un botón, es fácil e intuitivo. Más usuarios = Ingresos más altos!"
        feature1 :
          title  : "Mantente conectado"
          description_GENERIC  : "Nuestra interfaz es amigable e integrada con una Radio Digital para que te conectes con tus operadores las 24hs."
          description_DELIVERY  : "Nuestra interfaz es amigable e integrada con una Radio Digital para que te conectes con tus operadores."
        feature2 :
          title  : "Obtiene mas clientes"
          description  : "Acepta solicitudes por medio de la aplicación. Carreras mas largas, tarifas adicionales y viajes corporativos!"
        feature3 :
          title  : "Miles de clientes corporativos"
          description  : "Clientes corporativos = Mas demanda durante las horas de menor actividad! Utiliza nuestro sistema corporativo digital y olvídate de los recibos."
        feature4 :
          title  : "Geolocalización"
          description_GENERIC  : "Obtiene la dirección para buscar a tu pasajero integrado con Google Maps desde la App. Nuestro sistema siempre prioriza las solicitudes cerca de tu ubicación."
          description_DELIVERY  : "Obtiene la dirección para buscar a tu usuario integrado con Google Maps desde la App. Nuestro sistema siempre prioriza las solicitudes cerca de tu ubicación."
      apps:
        title  : "Descubre nuestras increíbles aplicaciónes móviles"
        android :
          button  : "Android"
          feature1 :
            title  : "Fácil"
            description  : "Interfaz amigable para tus necesidades."
          feature2 :
            title  : "Radio digital online"
            description_GENERIC  : "Envía mensajes de voz a otros conductores o a los operadores GRATIS!"
            description_DELIVERY  : "Envía mensajes de voz a otros motorizados o a los operadores GRATIS!"
          feature3 :
            title  : "Historial de viajes"
            description  : "Obtiene toda la información de sus viajes realizados en un solo lugar, tanto viajes corporativos como regulares."
          feature4 :
            title  : "Viajes programados"
            description  : "Maneja todos tus viajes programados en un mismo lugar, mira la información de detalle del viaje o cancela los mismos de ser necesario.."
          feature5 :
            title  : "Mensajes"
            description_DELIVERY  : "Envía mensajes de texto a otros motorizados o a los operadores GRATIS"
            description_GENERIC  : "Envía mensajes de texto a otros conductores o a los operadores GRATIS"
          feature6 :
            title  : "Métricas"
            description  : "Obtén métricas de tus viajes corporativos y colecta los pagos por los mismos desde la App."
        iphone :
          button  : "iPhone"
          feature1 :
            title  : "Fácil"
            description  : "Interfaz amigable para tus necesidades."
          feature2 :
            title  : "Radio digital online"
            description_GENERIC  : "Envía mensajes de voz a otros conductores o a los operadores GRATIS!"
            description_DELIVERY  : "Envía mensajes de voz a otros motorizados o a los operadores GRATIS!"
          feature3 :
            title  : "Historial de viajes"
            description  : "Obtiene toda la información de sus viajes realizados en un solo lugar, tanto viajes corporativos como regulares."
          feature4 :
            title  : "Viajes programados"
            description  : "Maneja todos tus viajes programados en un mismo lugar, mira la información de detalle del viaje o cancela los mismos de ser necesario.."
          feature5 :
            title  : "Mensajes"
            description_GENERIC  : "Envía mensajes de texto a otros conductores o a los operadores GRATIS"
            description_DELIVERY  : "Envía mensajes de texto a otros motorizados o a los operadores GRATIS"
          feature6 :
            title  : "Métricas"
            description  : "Obtén métricas de tus viajes corporativos y colecta los pagos por los mismos desde la App."
      howitWorks :
        button  : "Únase"
        step1 :
          title  : "1. Regístrese"
          text  : "en {{company}} y aguarde a recibir la información de acceso via e-mail."# {{company}} its a variable, do not translate
        step2 :
          title  : "2. Capacitación"
          text : "Obtiene capacitación personalizada para utilizar nuestra App al máximo."
        step3 :
          title : "3. Ingresa"
          text  : "Descarga la App desde tu teléfono y empieza a aceptar carreras rápidamente!"
        step4 :
          title : "4. Únete a nuestro Sistema Corporativo"
          text  : "Acepta carreras corporativas y disfruta de la mejor experiencia corporativa!"

    passenger:
      separatedTitle1  : "Un magnífico"
      separatedTitle2  : "servicio"
      separatedTitle3  : "al alcance de tus dedos"
      subTitle_GENERIC         : "La solución número uno en taxis para clientes y empresas"
      subTitle_DELIVERY         : "La solución número uno en motorizados para clientes y empresas"
      header :
        button1  : "Reservar ahora"
        button2  : "Ver funcionalidades"
      advantages :
        title  : "Ventajas"
        description_GENERIC : "¿Aún sigues levantando la mano para pedir un taxi? {{company}} es la forma más sencilla de pedirlo. Abre tu app, selecciona tu ubicación, pulsa en recógeme aquí y… ¡listo!"# {{company}} its a new variable, please add it
        description_DELIVERY : "¿Aún sigues levantando la mano para pedir un motorizado? {{company}} es la forma más sencilla de pedirlo. Abre tu app, selecciona tu ubicación, pulsa en recógeme aquí y… ¡listo!"# {{company}} its a new variable, please add it
        feature1 :
          title  : "Fácil de usar"
          description  : "Su diseño presenta una interfaz dinámica con más opciones para elegir y pago por medio de la aplicación. "
        feature2 :
          title  : "Siempre a tiempo"
          description_GENERIC  : "El servicio mas rápido a un click de distancia. En unos minutos tendrás un taxi en tu puerta, además si lo deseas puedes reservarlo hasta con 4 semanas de antelación."
          description_DELIVERY  : "El servicio mas rápido a un click de distancia. En unos minutos tendrás un motorizado en tu puerta, además si lo deseas puedes reservarlo hasta con 4 semanas de antelación."
        feature3 :
          title  : "Viajes Corporativos"
          description  : "Ahorra dinero, recibe facturas electrónicas, elimina recibos y vales físicos. Administra online las áreas y empleados."#
        feature4 :
          title  : "Siempre seguro"
          description_GENERIC  : "Todos nuestros
           conductores son taxistas con licencia en vigor. Además, han sido verificados uno a uno por nuestro equipo. No olvides que tú también puedes valorarles al acabar el trayecto."
          description_DELIVERY  : "Todos nuestros
           conductores son motorizados con licencia en vigor. Además, han sido verificados uno a uno por nuestro equipo. No olvides que tú también puedes valorarles al acabar el trayecto."

      apps:
        android :
          button  : "Android"
          feature1 :
            title  : "Fácil de usar"
            description  : "La aplicación ubicará automáticamente tu dirección usando GPS, haz clic en 'Solicitar'. ¡Y listo!"
          feature2 :
            title  : "Arriba a tiempo"
            description_GENERIC  : "Miles de taxis a sólo dos toques de ti. En unos minutos tendrás un taxi en tu puerta."
            description_DELIVERY  : "Miles de motorizados a sólo dos toques de ti. En unos minutos tendrás un motorizado en tu puerta."
          feature3 :
            title  : "Historial de viajes"
            description  : "Accede al historial de tus viajes en cualquier momento y consulta la información que necesites."
          feature4 :
            title  : "Viajes programados"
            description  : "Reserva viajes hasta con 4 semanas de antelación, tanto regulares como corporativos."
          feature5 :
            title    : "Mensajes"
            description_GENERIC    : "Envía mensajes a tu conductor en camino por cualquier inquietud."
            description_DELIVERY    : "Envía mensajes a tu motorizado en camino por cualquier inquietud."
          feature6 :
            title   : "Métricas"
            description   : "¡No te compliques! Verifica tus últimos pagos y actualiza tu perfil en un click."
        iphone :
          button  : "iPhone"
          feature1 :
            title  : "Fácil de usar"
            description  : "La aplicación ubicará automáticamente tu dirección usando GPS, haz clic en 'Solicitar'. ¡Y listo!"
          feature2 :
            title  : "Llega a tiempo"
            description_GENERIC  : "Miles de taxis a sólo dos toques de ti. En unos minutos tendrás un taxi en tu puerta."
            description_DELIVERY  : "Miles de motorizados a sólo dos toques de ti. En unos minutos tendrás un motorizado en tu puerta."
          feature3 :
            title  : "Punto de referencia"
            description_GENERIC  : "Envíale tu punto de referencia a tu conductor para que te encuentre rápidamente."
            description_DELIVERY  : "Envíale tu punto de referencia a tu motorizado para que te encuentre rápidamente."
          feature4 :
            title_GENERIC  : "Tu taxi a tu medida"
            title_DELIVERY  : "Tu motorizado a tu medida"
            description_GENERIC  : "Necesitas servicios de mensajeria? O un taxi con bahúl vacio? Selecciona la mejor opción a tu medida!"
            description_DELIVERY  : "Necesitas servicios de mensajeria? O un motorizado con bahúl vacio? Selecciona la mejor opción a tu medida!"
          feature5 :
            title  : "Mensajes"
            description_GENERIC  : "Envia mensajes a tu conductor en camino por cualquier inquietud."
            description_DELIVERY  : "Envia mensajes a tu motorizado en camino por cualquier inquietud."
          feature6 :
            title  : "Metricas"
            description  : "¡No te compliques! Verifica tus ultimos pagos y actualiza tu perfil en un click."
      howitWorks :
        button  : "Únase"
        step1:
          title  : "1. Regístrate"
          text  : "en {{company}} o a través de las apps."# {{company}} its a variable, do not translate
        step2 :
          title  : "2. Ingresa"
          text  : "Descarga la App desde tu teléfono o haz click en Ingresar con tu usuario."
        step3 :
          title_GENERIC  : "3. Pide un taxi"
          title_DELIVERY  : "3. Pide un motorizado"
          text  : "La aplicación ubicará automáticamente tu dirección usando GPS. Haz click en 'Solicitar' y listo!"
        step4 :
          title : "4. Disfruta su viaje"
          text_GENERIC  : "Sígue a tu taxista en el mapa y en minutos estarás en la ubicación que solicitaste."
          text_DELIVERY  : "Sígue a tu motorizado en el mapa y en minutos estarás en la ubicación que solicitaste."

    signup :
      title          : "Registración"
      mailEnterprise:
        subject  : ""
      mailDriver :
        subject :  ""
      title1  : "La"
      title2  : "Mejor solucion"
      title3  : "de transporte para todos"
      subtitle  : "Regístrate con nuestro sistema para acceder a los mejores beneficios de forma inmediata."
      useFacebook : "Registrarme con Facebook"
      useGoogle  : "Registrarme con Google+"
      unique   : "Este E-mail ya esta en uso, ingrese otro"
      features :
        title  : "Regístrate ahora para tener acceso inmediato"
        feat1 :
          title  : "titulo1"
          text  : "titulo1"
        feat2 :
          title   : "titulo1"
          text   : "titulo1"
        feat3 :
          title  : "titulo1"
          text  : "titulo1"
        feat4 :
          title  : "titulo1"
          text  : "titulo1"
    booking:
      navbar :
        welcome    : "Bienvenido"
        order      : "Pedir"
        favorites  : "Favoritos"
        profile    : "Perfil"
        history   : "Historial"
        scheduled  : "Programados"
        contact    : "Contacto"
      #common labels
      labels    :
        name         : "Nombre"
        save         : "Guardar"
        phoneNumber  : "Número de teléfono"
        mail         : "Email"
        subject      : "Asunto"
        content      : "Contenido"
        send         : "Enviar"
        lastName     : "Apellido"
        password     : "Contraseña"
        cancel       : "Cancelar"

      #orderTab
      order :
        estimatedPrice        : "Estimated price"
        title_GENERIC         : "Pedir un taxi"
        title_DELIVERY        : "Pedir un motorizado"
        pickUp                : "Origen"
        address               : "Dirección"
        floor                 : "Piso"
        apartment             : "Departamento"
        dropOff               : "Destino"
        scheduledRide         : "Viaje programado"
        passengerInformation_GENERIC  : "Información del pasajero"
        passengerInformation_DELIVERY  : "Información del usuario"
        passengerName_GENERIC         : "Nombre del pasajero"
        passengerName_DELIVERY         : "Nombre del usuario"
        phoneNumber           : "Número de teléfono"
        extras                : "Adicionales"
        options               : "Opciones"
        comments              : "Comentarios"
        order                 : "Pedir"
        searchingTaxi_GENERIC : "Buscando taxi..."
        searchingTaxi_DELIVERY    : "Buscando motorizado..."
        pleaseWait            : "Por favor aguarde unos minutos"
        opnum                 : "Nº de Operación"
        cancel                : "Cancelar pedido"
        driverInfo_GENERIC    : "Información del conductor"
        driverInfo_DELIVERY       : "Información del motorizado"
        carPlate              : "Placa"
        carModel              : "Modelo"
        rideInProgress        : "Viaje en proceso"
        tankyou               : "Gracias por usar"
        problems              : "En el caso que tenga algun inconveniente llame al"
        rideInfo              : "Detalle del viaje"
        sendSms               : "Enviar SMS"
      #common trip options
      options :
        courier          : "Mensajeria"
        pets             : "Mascotas"
        airConditioning  : "Aire acondicionado"
        smoker           : "Fumador"
        specialAsistance : "Asistencia especial"
        airport          : "Aeropuerto"
        luggage          : "Equipaje"
        vip              : "VIP"
        invoice          : "Factura"
      # profile tab
      profile :
        title                : "Mi perfil"
        personalInfo         : " Información personal"
        changePassword       : "Cambiar contraseña"
        contactInformation   : " Información de contacto"
        currentPass          : "Contraseña actual"
        newPass              : "Nueva contraseña"
        repeatNewPass        : "Repetir contraseña"
        change               : "Cambiar"
        mustBeSamePass       : "La contraseña no coincide!"
      # scheduled tab
      scheduled :
        title  : "Viajes programados"
        norides : "No hay viajes programados por el momento"
      # contact tab
      contact :
        title    : "Contacto"
        callUs   : "Llámenos"
        sendUsEmail : "Envíenos un e-mail"
      history :
        title    : "Historial de viajes"
        norides  : "No hay ningún viaje"
      modals :
        loginAccountLocked: "Su cuenta a sido bloqueada, para mas informacion contactese con nosotros"
        signUpDriver  : "Felicitaciones!, hemos recibido su solicitud para unirse a nuestra flota! Lo contactaremos pronto :)"
        signUpEnterprise  : "Felicitaciones!, hemos recibido su solicitud para unirse a nuestro servicio corporativo! Un representante lo contactara a la brevedad!"
        geolocationDisabled  : "La geolocalización esta desactivada, porfavor active los servicios de geolocalización en su navegador"
        geolocationError  : "Error de geolocalización, por favor intente nuevamente."
        ok  : "Ok"
        driverAtDoor_GENERIC  : "El conductor esta en la puerta esperando!"
        driverAtDoor_DELIVERY  : "El motorizado esta en la puerta esperando!"
        driverCanceled_GENERIC  : "El conductor ha cancelado su viaje, estamos buscando otro conductor, por favor aguarde..."
        driverCanceled_DELIVERY  : "El motorizado ha cancelado su viaje, estamos buscando otro motorizado, por favor aguarde..."
        editProfileError : "Ha ocurrido un error actualizando su perfil, por favor intente nuevamente."
        editProfileSuccess  : "Perfil actualizado exitosamente!"
        emailError   : "Ha ocurrido un error enviando el correo, por favor intente nuevamente"
        emailSuccess  : "Correo enviado exitosamente! Lo estaremos contactando a la brevedad"
        forgotPassError  : "Su correo es incorrecto, por favor intente nuevamente"
        forgotPassSuccess  : "Correo enviado exitosamente!"
        loginError       : "Usuario o contraseña incorrecta, por favor intente nuevamente."
        operationCanceled  : "La operación ha sido cancelada!"
        createOperationError  : "Ha ocurrido un error al crear el viaje, por favor intente nuevamente!"
        operationFinished  : "Felicitaciones su viaje ha finalizado!"
        passwordChangeIncorrect  : "Su contraseña original es incorrecta, por favor intente nuevamente"
        passwordChangeShort  : "Su nueva contraseña es muy corta, por favor intente nuevamente"
        passwordChangeSuccess  : "Su contraseña se ha cambiado correctamente!"
        ringUser_GENERIC           : "Atención!  El conductor te está timbrando!"
        ringUser_DELIVERY           : "Atención!  El motorizado te está timbrando!"
        scheduledError   : "Ha ocurrido un error al crear el viaje programado, por favor intente nuevamente"
        scheduledSuccess  : "YAY! Ha creado exitosamente el viaje programado, puede ver los viajes programados desde la solapa 'Programados'!"
        send  : "Enviar"
        signUpError  : "Ha ocurrido un error al registrarse, por favor intente nuevamente"
        emailExist: "Este Email ya se encuentra registrado!"
        sendMessageToDriver :
          wait : "Espérame 5 minutos"
          waiting  : "Estoy esperándote"
          onMyWay  : "Estoy saliendo"
          ok     : "Ok"
        driverMessages :
          onway  : "Estoy llegando"
          wait : "Trafico pesado. Llegaré en 10 minutos."
          waiting: "Estoy esperando"
          ok : "Ok!"
    corporate :
      modals :
        error             : "Ha ocurrido un error, por favor intente nuevamente"
        changedProfile    : "Perfil actualizado correctamente!"
        profileNotChanged : "Ha ocurrido un error actualizando su perfil, por favor intente nuevamente"
      profile :
        basicInformation  : "Información básica"
        companyName       : "Nombre de la Empresa"
        taxIdentification : "Número de identificación fiscal"
        phone             : "Teléfono"
        location          : "Localidad"
        address           : "Dirección"
      NoRecordsAvailable : "No hay ningúna información para mostrar"
      sections :
        dashboard   : "Inicio"
        costCenters : "Area"
        employees   : "Empleados"
        billing     : "Facturación"
        history     : "Historial de Operaciones"
        orderTaxi_GENERIC   : "Pedir un taxi"
        orderTaxi_DELIVERY   : "Pedir un taxi"
        logout      : "Cerrar sesión"
        profile     : "Perfil"
      dashboard :
        toPay : "A pagar"
        totalCost : "Monto total"
        paid      : "Pagado"
        operations : "Operaciones"
        lastWeek    : "Última semana"
        lastMonth   : "Último mes"
        opsByShift  : "Operaciones por turno"
        monthExpenses : "Gastos mensuales"
        Night : "Noche"
        Midday : "Mediodia"
        Morning : "Mañana"
        Afternoon : "Tarde"
        months  :
          0 : "Enero"
          1 : "Febrero"
          2 : "Marzo"
          3 : "Abril"
          4 : "Mayo"
          5 : "Junio"
          6 : "Julio"
          7 : "Agosto"
          8 : "Septiembre"
          9  : "Octubre"
          10 : "Noviembre"
          11 : "Diciembre"
      billing :
        informPayment : "Informar pago"
        enabled : "Activado"
        disabled : "Desactivado"
      invoice :
        payments : "Pagos"
        PARTIALLY_PAID: "Parcialmente pagado"
        PENDING : "Pendiente"
        OVERDUE : "Vencido"
        PAID :  "Pagado"
        lateFee : "Intereses"
        term : "Términos"
        subtotal : "Subtotal"
        adjustments : "Ajustes"
        total : "Total"
        paid : "Pagado"
        remaining : "Restante"
        comments : "Comentarios"
      labels :
        dateTo : "Desde"
        dateFrom : "Hasta"
        companyAdmin  : "Administrador de la Compañia"
        save : "Guardar"
        options : "Opciones"
        user : "Usuario"
        tax : "Impuesto"
        discount: "Descuento"
        price: "Precio"
        quantity : "Cantidad"
        itemydesc : "Item & Descripción"
        date : "Fecha"
        invoice : "Factura#"
        amount  : "Monto"
        balanceDue : "Saldo adeudado"
        status : "Estado"
        dueDate : "Fecha de vencimiento"
        id : "ID#"
        name : "Nombre "
        from : "Desde"
        to : "Hasta"
        admin : "Supervisor"
        passenger_GENERIC : "Pasajero"
        passenger_DELIVERY : "Usuario"
        password  : "Contraseña"
        lastName  : "Apellido"
        phone   : "Teléfono"
        email    : "Email"
        cancel  : "Cancelar"
        ok    : "Ok"
        reference : "Referencia"
        comments:  "Comentarios"
        paymentMethod : "Método de pago"
      employees :
        newEmployee : "+ Nuevo empleado"
      employee :
        active: "Activo"
        blocked : "Bloqueado"
        blockUser : "Bloquear usuario"
        totalTrips : "Total de viajes*"
        totalExpenses: "Total de gastos*"
        monthly:  "*Mensual"
      history :
        operationDetail : "Detalles de operación"
      filters :
        noFilter : "No filtrar"
        pending  : "Pendiente"
        overdue  : "Vencido"
        paid     : "Pagado"
        partialyPaid : "Parcialmente pagado"
        completed: "Completado"
        canceled : "Cancelado"
        active  : "Activo"
        blocked : "Bloqueado"
      orders  :
        alfabetic : "Órden alfabético"
        amount  : "Monto"
        date    : "Fecha"
        dueDate  : "Fecha de vencimiento"
        noOrder : "No ordenar"
      company :
        taxIdentification : "Identificador Fiscal"
        users: "Usuarios"
        debt : "Deuda"
        addCostCenter: "Agregar Area"
        editCostCenter: "Editar Area"
      filterBy: "Filtrar por"
      orderBy : "Ordenar por"
      reportPayment:
        subject   : "Corporativo | nuevo reporte de pago"
        reference : "Referencia"
        method    : "Método"
        comments  : "Comentarios"
  # $translateProvider.fallbackLanguage 'en'

]
