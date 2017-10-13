
technoridesApp.factory '$monthlyReports',( $api, $paginator ) ->

  $monthlyReports =
    list            : []
    remoteList      : []
    page            : 0
    pages           : []
    fields          : [
      'month',
      'trips'
    ]

    getRemoteMonthly: (callback) ->
      $api.send "getMonthlyReports"

    get: (page) ->
      $monthlyReports.list  = $monthlyReports.remoteList
      $monthlyReports.total = ($monthlyReports.list.slice 0, Math.ceil($monthlyReports.remoteList.length / 10)).length
      $paginator.pages      = _.range $monthlyReports.total
      $monthlyReports.list  = $monthlyReports.list.slice (page-1) *10   , ((page-1)*10)+10
      $paginator.page       = page-1
