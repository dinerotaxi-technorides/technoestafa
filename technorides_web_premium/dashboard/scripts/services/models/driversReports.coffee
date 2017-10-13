technoridesApp.factory '$driversReports',($api, $paginator) ->
  $driversReports =
    list            : []
    remoteList      : []
    page            : 0
    pages           : []
    fields          : [
      'month',
      'trips',
      'email'
    ]

    getRemoteDrivers: (callback) ->
      $api.send "getDriversReports"

    get: (page) ->
      $driversReports.list  = $driversReports.remoteList
      $driversReports.total = ($driversReports.list.slice 0, Math.ceil($driversReports.remoteList.length / 10)).length
      $paginator.pages      = _.range $driversReports.total
      $driversReports.list  = $driversReports.list.slice (page-1) *10   , ((page-1)*10)+10
      $paginator.page       = page-1
