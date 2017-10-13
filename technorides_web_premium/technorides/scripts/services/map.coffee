technoridesApp.factory '$map', ->

  $map =
    zoom        : 15
    center      :
      latitude  : 38.768
      longitude : -75.211638

    events      :
      idle      : (maps, event, args) ->
        unless $map.mapInstance?
          $map.mapInstance = maps


    resize : ->
      if $map.mapInstance?
        google.maps.event.trigger $map.mapInstance, 'resize'

      $map.center =
        latitude  : 38.768
        longitude : -75.211638


    options            :
      scrollwheel      : false
      disableDefaultUI : true
      draggable        : false

    markerHeadqts :
      id          : "home"
      coords      :
        latitude  : 38.765088
        longitude : -75.211638
      icon        : "/technorides/assets/contactmarker.png"
      options     :
        draggable : false
