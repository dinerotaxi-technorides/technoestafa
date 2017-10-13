technoridesApp.factory '$facebook', ($user) ->
  data : []
  getData: ->
    FB.api(
        "/me"
      ,
        fields: 'last_name'
      ,
        (response) ->
          if !response || response.error
            alert "error"
          else
            console.log response
    )
  login : ->
    FB.login(
        (response)->
          if response.status is 'connected'
            console.log response
          else if response.status is 'not_authorized'
            alert "log to app"
          else
            alert "please login to fill data"
      ,
        {scope: 'public_profile,email'}
    )
