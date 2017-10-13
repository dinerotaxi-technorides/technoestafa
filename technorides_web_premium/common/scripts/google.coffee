technoridesApp.factory '$google', ($http, $settings) ->
  $map =
    initialize: (id, options) ->
      if options.zoomControl is undefined
        options.zoomControl = true
      $map.map = new google.maps.Map(document.getElementById("#{id}"),
        center:
          lat: options.latitude
          lng: options.longitude
        zoom : options.zoom
        zoomControl: options.zoomControl
    )
    setCenter: (coords) ->
      @.map.setCenter coords

    resize : ->
      google.maps.event.trigger(@.map, 'resize')

    addListener : (event, callback) ->
      $map.map.addListener "#{event}", ->
        callback()

    getCenter : ->
      @.map.getCenter()

    centerInMarkers: (markers) ->
      bounds = new google.maps.LatLngBounds()
      for marker in markers
        bounds.extend(marker.getPosition())
      @.map.fitBounds(bounds)

    addMarker : (options, listeners, useCluster, cluster) ->
      if options.title
        options.title = "#{options.title}"
        if options.title.length < 4
          labelDistance = new google.maps.Point(15, 0)
        else
          labelDistance = new google.maps.Point(25, 0)
      marker = new MarkerWithLabel
        position     : options.position
        icon         : options.icon
        labelContent : if options.title? then "#{options.title}" else null
        labelAnchor  : labelDistance
        labelClass   : if options.title? then "map-labels" else null
        draggable    : unless options.draggable then false else options.draggable
        driver       : options.driver
      if listeners?
        for listener in listeners
          marker.addListener listener.event, listener.callback
      if useCluster
        cluster.addMarker marker, false
      else
        marker.setMap(@.map)

      return marker

    updateMarker : (marker, options, useCluster, cluster, beforeCluster) ->
      if options.icon? and options.icon
        marker.setIcon options.icon

      if options.position?
        marker.setPosition options.position

      if useCluster and cluster.clusterName isnt beforeCluster.clusterName
        beforeCluster.removeMarker(marker)
        cluster.addMarker marker, false

      if options.draggable?
        marker.setDraggable(options.draggable)

    latLng : (coords) ->
      return new google.maps.LatLng coords

    getCallbackMarker : (event) ->
      return event.latLng

    formatLatLng : (coords) ->
      return {lat: coords.lat(), lng: coords.lng()}

    showMarker : (marker,useCluster, cluster) ->
      if useCluster
        cluster.addMarker marker, false
      else
        marker.setMap(@.map)

    hideMarker  : (marker, useCluster, cluster, markers) ->
      marker.setMap(null)
      if useCluster
        cluster.removeMarker marker
        #allMarkers = cluster.getMarkers()
        # cluster.clearMarkers()

        # for mark in allMarkers
        #   cluster.addMarker mark



    getMarkerPosition : (marker) ->
      return marker.getPosition()

    showCircle  : (circle) ->
      circle.setMap(@.map)
    addCircle   : (options) ->
      circle = new google.maps.Circle
        strokeColor   : '#FFFFFF'
        strokeOpacity : 0.3
        strokeWeight  : 0
        fillColor     : '#FFC700'
        fillOpacity   : 0.3,
        map           : null
        center        : options.center
        radius        : options.radius
      return circle
    hideCircle  : (circle) ->
      circle.setMap(null)
    updateCircle : (circle, options) ->
      if options.center?
        circle.setCenter options.center
    centerBounds : (bounds) ->
      b = new google.maps.LatLngBounds()
      for bound in bounds
        b.extend bound
      @.map.fitBounds b
    disableMovement : ->

    newCluster : (name) ->
      url = "/common/assets/markers/"
      switch name
        when "operations" then url += "operation_assigned_cluster"
        when "drivers_disconnected" then url += "driver_disconnected_cluster"
        when "drivers_offline" then url += "driver_offline_cluster"
        when "drivers_online" then url += "driver_online_cluster"
        when "drivers_intravel" then url += "driver_intravel_cluster"
        when "parkings" then url += "parking_cluster"
        else url += "operation_assigned_cluster"
      url += ".png"
      cluster = new MarkerClusterer(@.map, [], {ignoreHidden: true, gridSize: 50, maxZoom: 14, styles: [{textColor: "white", textSize: 14, width: 35, height: 35, url: url, opacity: 0.5}]})
      cluster.clusterName = name
      cluster
    showCluster : (cluster, markers) ->
      for id, marker of markers
        cluster.addMarker marker, false
      cluster.redraw()

    hideCluster : (cluster, markers) ->
      for id, marker of markers
        marker.setMap null
      cluster.clearMarkers()

    polygon : ->
