technoridesApp.factory '$company', ['$cookieStore',($cookieStore) ->

  $company =

    isConfigurationRetrieved : false

    getCompanyData : (response) ->
      for key, value of response
        $company[key] = value


    isClientRegistered : ->
      # Has false value in required fields?
      [
        !!$company.rtaxi
        !!$company.companyName
        !!$company.companyMail
        !!$company.country
        !!$company.countryCode
      ].indexOf(false) is -1


    isConfigurationValid : ->
      # Check if user missed some site configuration
      [
        !!$company.aboutTitle
        !!$company.aboutText
      ].indexOf(false) is -1


]
