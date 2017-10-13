technoridesApp.factory '$apiHandler',($location, $apiAdapter, $user, $message, $translate) ->
  
  $apiHandler = 
    onGetCompanyData : (response, success) ->
      $apiAdapter.input.getCompanyData(response)

  