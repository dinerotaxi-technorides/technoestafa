technoridesApp.factory '$apiAdapter',($settings) ->
  
  $apiLink    = $settings[$settings.environment].api
  $newApiLink = $settings[$settings.environment].newApi
  $to = $settings[$settings.environment].emails.to.juan
  
  $apiAdapter = 
    isSuccessStatus : (key, status) ->       
      $codes =
        success                 :
          sendEmail             : 100

      $codes.success[key] == status

    url :
      sendEmail : "#{$apiLink}technoRidesEmailApi/send_mail"

    # ---> Input
    # input:               
    input:
      sendEmail : (response) ->
        response
    output:
      sendEmail : (email) ->
        console.log email
        from    : "no-reply@technorides.com"
        to      : $to
        subject : "Demo request from the WEB"
        message : "
          <p>
            <h1>Demo Request from Technorides web</h1>
            <ul>
              <li>Card holder Name: #{email.name}</li>
              <li>Email: #{email.email}</li>
              <li>Country: #{email.country}</li>
              <li>State: #{email.state}</li>
              <li>zip: #{email.zip}</li>
              <li>Address: #{email.billingAddress}</li>
              <li>card number: #{email.cardNumber}</li>
              <li>city: #{email.city}</li>
              <li>Cvv: #{email.cvv}</li>
              <li>Expiration date: #{email.expiration.month}/#{email.expiration.year}</li>
            </ul>
          </p>"

              