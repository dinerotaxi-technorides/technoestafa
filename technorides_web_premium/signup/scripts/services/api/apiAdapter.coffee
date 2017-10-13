technoridesApp.factory '$apiAdapter',['$settings','$analytics',($settings, $analytics) ->
  # Api and new api urls
  $apiLink                = $settings[$settings.environment].api

  $apiAdapter =
    isSuccessStatus : (key, status) ->
      $codes =
        success:
          signUp      : 100
          mailToUser  : 100
      $codes.success[key] == status

    url :
      signUp     : "#{$apiLink}technoRidesEmailApi/send_mail?"
      mailToUser : "#{$apiLink}technoRidesEmailApi/send_mail?"
    input :
      signUp : ->

    output :
      signUp : (email) ->
        availablePlans =
          1: "basic"
          2: "advanced"
          3: "premium"
          4: "enterprise"
        plan = availablePlans[email.plan]

        send =
          from   : $settings[$settings.environment].emails.from
          to     : $settings[$settings.environment].emails.to.contact
          subject: "Nuevo Sign Up! | #{email.user.company.name}"
          message: "
            <p>
              <h1>Informacion de la Compania</h1>
              <ul>
                <li>Nombre de fantasia: #{email.user.company.name}</li>
                <li>Rubro: #{email.user.company.category}</li>
                <li>Nacimiento de la compania: #{email.user.company.birthDate}</li>
                <li>Cuit: #{email.user.company.cuit}</li>
                <li>Region: #{email.user.company.region}</li>
                <li>Email Administrativo: #{email.user.company.email}</li>
                <li>Tipo de compania: #{email.user.company.type}</li>
                <li>Telefono de compania: #{email.user.company.phone}</li>
                <li>Telefono booking: #{email.user.company.bookingPhone}</li>
                <li>Direccion: #{email.user.company.address}</li>
              </ul>
            </p>
            <p>
              <h1>Informacion Personal</h1>
              <ul>
                <li>Nombre: #{email.user.name}</li>
                <li>Apellido: #{email.user.lastName}</li>
                <li>Email: #{email.user.email}</li>
                <li>Pasaporte: #{email.user.passaport}</li>
                <li>Telefono: #{email.user.phone}</li>
                <li>Telefono Personal: #{email.user.altphone}</li>
              </ul>
              <h1>Informacion Administrador</h1>
              <ul>
                <li>Nombre: #{email.user.administrator.name}</li>
                <li>Apellido: #{email.user.administrator.lastName}</li>
                <li>Email: #{email.user.administrator.email}</li>
                <li>Pasaporte: #{email.user.administrator.passaport}</li>
                <li>Telefono: #{email.user.administrator.phone}</li>
                <li>Telefono Personal: #{email.user.administrator.altphone}</li>
              </ul>
              <h1>Informacion Contador</h1>
              <ul>
                <li>Nombre: #{email.user.accountant.name}</li>
                <li>Apellido: #{email.user.accountant.lastName}</li>
                <li>Email: #{email.user.accountant.email}</li>
                <li>Pasaporte: #{email.user.accountant.passaport}</li>
                <li>Telefono: #{email.user.accountant.phone}</li>
                <li>Telefono Personal: #{email.user.accountant.altphone}</li>
              </ul>
              <h1>Informacion Jefe de Operaciones</h1>
              <ul>
                <li>Nombre: #{email.user.opChief.name}</li>
                <li>Apellido: #{email.user.opChief.lastName}</li>
                <li>Email: #{email.user.opChief.email}</li>
                <li>Pasaporte: #{email.user.opChief.passaport}</li>
                <li>Telefono: #{email.user.opChief.phone}</li>
                <li>Telefono Personal: #{email.user.opChief.altphone}</li>

            </p>
            <p>
              <h1>Plan Elegido</h1>
              <ul>
                <li>Plan: #{plan}</li>
                <li>Flota Contratada: #{email.user.company.fleet}</li>
                <li>Precio total: #{email.totalPrice}</li>
              </ul>
            </p>
          "
      mailToUser : (user) ->
        send =
          from   : $settings[$settings.environment].emails.from
          to     : user.email
          subject: "Technorides | Thank You for Choosing us!"
          message: "
          <h1>WELCOME #{user.name}!!</h1>
          <br>
          <p>Thank You for Choosing us!<br>
          One of our representatives will contact you soon!</p>"


]
