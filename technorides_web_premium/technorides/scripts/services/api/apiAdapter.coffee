technoridesApp.factory '$apiAdapter',[ '$settings', ($settings) ->

  $apiLink    = $settings[$settings.environment].api
  $from       = $settings[$settings.environment].emails.from
  $to         = $settings[$settings.environment].emails.to.contact

  $apiAdapter =

    isSuccessStatus : (key, status) ->
      $codes =
        success     :
          sendEmail : 100
          freeTrial : 100

      $codes.success[key] == status


    url         :
      sendEmail : "#{$apiLink}technoRidesEmailApi/send_mail"
      freeTrial : "#{$apiLink}technoRidesEmailApi/send_mail"


    output      :
      sendEmail : (emailAttributes) ->
        from    : $from
        to      : $to
        subject : emailAttributes.reason + " #{emailAttributes.origin}"
        message : "
          <p>
            <h1>Web Contact</h1>
            <ul>
              <li>Name: #{emailAttributes.name}</li>
              <li>Email: #{emailAttributes.email}</li>
              <li>Phone: #{emailAttributes.phone}</li>
              <li>Mobile: #{emailAttributes.mobile}</li>
              <li>Country: #{emailAttributes.country}</li>
            </ul>
          </p>
          <p>
            <h1>Message:</h1>
            <p>#{emailAttributes.message}</p>
          </p>"


      freeTrial : (mail) ->
        from    : $from
        to      : $to
        subject : "Free trial | #{mail.companyName} #{mail.origin}"
        message : "<p>
            <h1>Free trial Request</h1>
            <ul>
              <li>Name: #{mail.name}</li>
              <li>Company Name : #{mail.companyName}</li>
              <li>Email: #{mail.email}</li>
              <li>Phone: #{mail.phone}</li>
              <li>Mobile: #{mail.mobile}</li>
              <li>Country: #{mail.country}</li>
              <li>Fleet: #{mail.fleet}</li>
              <li>Plan: #{mail.plan}</li>
            </ul>
          </p>"


]
