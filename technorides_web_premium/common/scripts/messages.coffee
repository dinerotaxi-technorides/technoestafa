technoridesApp.factory '$message',  ->

  $message =

    # ERROR MESSAGES
    error  :
      show : (message) ->
        $message.error.description = message
        $(".error-modal").modal("show")
        false


      close : ->
        $(".error-modal").modal("hide")
        false


      description : ""

    # SUCCESS MESSAGES
    success :
      show  : (message) ->
        $message.success.description = message
        $(".success-modal").modal("show")
        false


      close : ->
        $(".success-modal").modal("hide")
        false


      description : ""

    # WARNING MESSAGES
    warning :
      show  : (message) ->
        $message.warning.description = message
        $(".warning-modal").modal("show")
        false


      close : ->
        $(".warning-modal").modal("hide")
        false


      description : ""
