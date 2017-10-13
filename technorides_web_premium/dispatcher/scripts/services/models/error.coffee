technoridesApp.factory '$error', ->

  $error =
    showError : (data) ->
      jQuery.gritter.add
        title: data.title
        text: data.text
        class_name: 'growl-danger'
        sticky: false
