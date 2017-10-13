technoridesApp.factory '$messages', ['messages.api' ,($api) ->
  $messages =
    message : ""
    send : ->
      $api.sendMessageToOperators 
        message : $messages.message
        done: ->
          $messages.message = ""
          $(".modal-success").modal("show")
        fail: ->
        ]
