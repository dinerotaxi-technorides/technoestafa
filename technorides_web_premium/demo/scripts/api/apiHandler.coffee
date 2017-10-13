technoridesApp.factory '$apiHandler',($settings, $apiAdapter) ->
  $apiHandler =
    onSendEmail : (response, success) ->
      $apiAdapter.input.sendEmail response
      