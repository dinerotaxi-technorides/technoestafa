technoridesApp.factory '$apiAdapter',($settings, $user, $filter, $company) ->
  
  $apiLink    = $settings[$settings.environment].api
  $newApiLink = $settings[$settings.environment].newApi
  
  $apiAdapter = 
    isSuccessStatus : (key, status) ->       
      $codes =
        success                 :
          getCompanyData        : 200
          
      $codes.success[key] == status

    url :
      getCompanyData         : "#{$apiLink}technoRidesUsersApi/jq_get_information_company"
     
    # ---> Input
    # input:               
    input:         
      getCompanyData : (response) ->
        $company.getCompanyData (response)
        
    output:
      getCompanyData : ->
        token : $user.token

     