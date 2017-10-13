technoridesApp.factory '$dailyReports',( $api, $paginator) ->
  $dailyReports =
    list          : []
    remoteList    : []
    page          : 0
    pages         : []
    fields        : [
      'day',
      'trips'
    ]

    getRemote: (callback) ->
      $api.send "getDailyReports"

    get: (page) ->
      $dailyReports.list  = $dailyReports.remoteList
      $dailyReports.total = ($dailyReports.list.slice 0, Math.ceil($dailyReports.remoteList.length / 10)).length
      $paginator.pages    = _.range $dailyReports.total
      $dailyReports.list  = $dailyReports.list.slice (page-1) *10   , ((page-1)*10)+10
      $paginator.page     = page-1
