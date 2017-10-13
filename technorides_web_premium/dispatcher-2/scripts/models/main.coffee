technoridesApp.factory '$main', ['$main.adapter', ($api) ->
  sslCert : (params) ->
    $api.sslCert params
]
