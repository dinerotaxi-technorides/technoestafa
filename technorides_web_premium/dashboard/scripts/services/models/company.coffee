technoridesApp.factory '$company', ($timeout, $api, $modal, $user, $log) ->
  $company =
    save : (response) ->
      for key, value of response
        $company[key] = value

    config        : {}
    zones         :
      list    : {}
      pages   : 0
      page    : 0
    operationFlow : {}
    statistics    : {}
    parking : {}
