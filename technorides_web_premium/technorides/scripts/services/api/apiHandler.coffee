technoridesApp.factory '$apiHandler', ['$message', '$translate', ($message, $translate) ->

  $apiHandler =

    onSendEmail : (response, success) ->
      if success
        # $message.success.show "emailSendedSuccess"
        location.href = "/thankyou.html##{$translate.use()}"
      else
        $message.error.show "emailSendedError"


    onFreeTrial : (response, success) ->
      if success
        # $(".free-trial").modal("hide")
        # $message.success.show "freeTrialSendedSuccess"
        location.href = "/thankyou.html##{$translate.use()}"
      else
        $message.error.show "freeTrialSendedError"


]
