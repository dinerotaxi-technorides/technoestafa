technoridesApp.factory '$inbox', ($api, $apiAdapter, $paginator, $filter) ->
  #starEmail
  #deleteEmail
  $inbox =
    selected : []
    messages : []
    remoteList : []
    showing : "inbox"
    mail : {}
    tab : "DRIVER"
    getMessages : ->
      $api.send "listInboxMessages", $inbox.tab, (response) ->
        $inbox.saveMessages($apiAdapter.input.listInboxMessages response)
        $inbox.showing    = "inbox"
        $paginator.get(1)

    getDeletedEmail : ->
      $api.send "getDeletedEmail", $inbox.tab, (response) ->
        $inbox.saveMessages($apiAdapter.input.listInboxMessages response)
        $inbox.showing    = "deleted"
        $paginator.get(1)

    getStarEmail : ->
      $api.send "getStarEmail", $inbox.tab, (response) ->
        $inbox.saveMessages($apiAdapter.input.listInboxMessages response)
        $inbox.showing    = "star"
        $paginator.get(1)

    saveMessages : (messages) ->
      $inbox.messages      = messages
      $inbox.totalMessages = messages.length
      $inbox.remoteList    = $filter('orderBy')(messages, "-date")


    markAsReaded : (id) ->
      $api.send "markAsReadedEmail", id, ->
        $inbox.loadAcordingView()

    selectMail : (id) ->
      $inbox.selected.push(id)

    deleteEmail : (selected) ->
      for id in selected
        $("#preloader").fadeIn()
        $api.send "deleteEmail", id, ->
          $inbox.loadAcordingView()
      $inbox.selected = []
      $("#preloader").fadeOut()
      false

    setStar : (id) ->
      $api.send "starEmail", id, ->
        $inbox.loadAcordingView()

    loadAcordingView : ->
      switch $inbox.showing
        when "star"
          $inbox.getStarEmail()
        when "deleted"
          $inbox.getDeletedEmail()
        when "inbox"
          $inbox.getMessages()

    show : (mail) ->
      $(".show-email").modal("show")
      $inbox.mail = mail



    get: (page) ->
      $inbox.total     = ($inbox.remoteList.slice 0, Math.ceil($inbox.remoteList.length / 10)).length
      $paginator.pages = _.range $inbox.total
      $inbox.messages  = $inbox.remoteList.slice (page-1) *10   , ((page-1)*10)+10
      $paginator.page  = page-1
