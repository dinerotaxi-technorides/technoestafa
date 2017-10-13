technoridesApp.factory '$map', ($log) ->
  # ***** Constants *****

  # Default map options
  DEFAULT_MAP_OPTIONS =
    # center    : new google.maps.LatLng -34.6037019, -58.3818729
    zoom      : 18
    # mapTypeId : google.maps.MapTypeId.ROADMAP

  # Default marker options
  DEFAULT_MARKER_OPTIONS = {}
    # position  : new google.maps.LatLng -34.6037019, -58.3818729

  # ***** Methods *****

  $map =
    # Initialize map parameters and starts the map
    initialize : (id, options) ->
      # Map already defined?
      unless canvas?

        unless id?
          $log.error "Invalid map ID"
          return
        id = "#{id}"

        unless options?
          $log.warn "Map options not defined, using defaults"
          options = DEFAULT_MAP_OPTIONS

        # Map initilization
        $map.id      = id
        $map.canvas  = document.getElementById id

        unless $map.canvas?
          $log.error "Map ID not found"
          return

        $map.options    = options
        $map.markers    = {}
        $map.circles    = {}
        $map.clusters   = {}
        $map.counters   = {}
        $map.visibility = {}
        $map.map        = new google.maps.Map $map.canvas, $map.options


    # Add new circle
    addCircle : (category, id, options) ->
      unless category?
        $log.error "Invalid circle category"
        return
      else
        $map.circles[category] = {} unless $map.circles[category]?

      unless id?
        $log.error "Invalid circle ID"
        return
      id = "#{id}"

      unless options?
        $log.warn "Circle options not defined"
        return

      options.map                = $map.map unless options.map == null
      $map.circles[category][id] = new google.maps.Circle options

    # Update circle
    updateCircle : (category, id, options) ->
      unless category?
        $log.error "Invalid circle category"
        return
      else
        $map.circles[category] = {} unless $map.circles[category]?

      unless id?
        $log.error "Invalid circle ID"
        return
      id = "#{id}"

      unless options?
        $log.warn "Circle options not defined"
        return

      if options.center?
        $map.circles[category][id].setCenter options.center

    # Add new marker
    addMarker : (category, id, options, listeners) ->
      unless category?
        $log.error "Invalid marker category"
        return
      else
        $map.markers[category]  = {} unless $map.markers[category]?
        $map.counters[category] = 0 unless $map.counters[category]?

        unless $map.clusters[category]? or options.doCluster is false
          clusterIcon             = options.icon.replace /\./, "_cluster."
          $map.clusters[category] = new MarkerClusterer $map.map, [], {ignoreHidden: true, gridSize: 50, maxZoom: 14, styles: [{textColor: "white", textSize: 14, width: 35, height: 35, url: clusterIcon, opacity: 0.5}]}

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      unless options?
        $log.warn "Marker options not defined, using defaults"
        options = DEFAULT_MARKER_OPTIONS

      if options.visible isnt undefined
        options.visible          = options.visible
      else
        options.visible          = $map.visibility[category] isnt false

      options.map                = $map.map
      $map.markers[category][id] = new MarkerWithLabel options
      $map.counters[category]++

      $map.clusters[category].addMarker $map.markers[category][id] if options.doCluster isnt false and $map.visibility["clusters"] isnt false

      if listeners?
        for listener in listeners
          $map.addMarkerListener category, id, listener


    addMarkerListener : (category, id, listener) ->
      google.maps.event.addListener $map.markers[category][id], listener.event, (googleMarker) ->
        listener.callback($map.getMarker(category, id), googleMarker)


    # Update marker
    updateMarker : (category, id, options) ->
      unless category?
        $log.error "Invalid marker category"
        return

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      if options is undefined
        $log.warn "Marker options not updated"
        return

      if options.icon?
        $map.markers[category][id].setIcon options.icon

      if options.position?
        $map.markers[category][id].setPosition options.position

      if options.draggable?
        $map.markers[category][id].setDraggable options.draggable

      if options.visible?
        $map.markers[category][id].setVisible options.visible

        if options.visible
          $map.markers[category][id].setMap $map.map
        else
          $map.markers[category][id].setMap null


    # Add or update marker
    addOrUpdateMarker : (category, id, options, listeners) ->
      unless category?
        $log.error "Invalid marker category"
        return

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      if $map.markers[category]?[id]?
        $map.updateMarker category, id, options, listeners
      else
        $map.addMarker category, id, options, listeners


    # Remove marker
    removeMarker : (category, id) ->
      unless category?
        $log.error "Invalid marker category"
        return

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      $map.markers[category][id].setMap null if $map.markers[category]?[id]?
      $map.clusters[category].removeMarker $map.markers[category][id] if $map.markers[category]?[id]? and $map.clusters[category]?

      delete $map.markers[category][id]
      $map.counters[category]--


    # Clear markers
    clearMarkers : (category) ->
      unless category?
        $log.error "Invalid marker ID"
        $log.error "Invalid marker category"
        return

      for id, marker of $map.markers[category]
        $map.removeMarker category, id


    # Hide marker
    hideMarker : (category, id) ->
      unless category?
        $log.error "Invalid marker category"
        return

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      $map.markers[category][id].setMap null
      $map.markers[category][id].setVisible false
      $map.clusters[category].removeMarker $map.markers[category][id] if $map.clusters[category]?


    # Show marker
    showMarker : (category, id) ->
      unless category?
        $log.error "Invalid marker category"
        return

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      $map.markers[category][id].setMap $map.map
      $map.markers[category][id].setVisible true
      $map.clusters[category].addMarker $map.markers[category][id] if $map.clusters[category]? and $map.visibility["clusters"] isnt false


    # Hide circle
    hideCircle : (category, id) ->
      unless category?
        $log.error "Invalid circle category"
        return

      unless id?
        $log.error "Invalid circle ID"
        return
      id = "#{id}"

      $map.circles[category][id].setMap null


    # Show circle
    showCircle : (category, id) ->
      unless category?
        $log.error "Invalid circle category"
        return

      unless id?
        $log.error "Invalid circle ID"
        return
      id = "#{id}"

      $map.circles[category][id].setMap $map.map

    # Hide all circles (bugfixing)

    hideCircles : (category) ->
      for id, circle of $map.circles[category]
        circle.setMap null

    # Show all markers of all the categories, bound based
    showAllMarkers : ->
      bounds = new google.maps.LatLngBounds();
      for id, category of $map.markers
        for id, marker of category
          bounds.extend marker.getPosition() if marker.getVisible()

      $map.map.fitBounds bounds


    # Center the map on marker position based
    centerInMarker : (category, id) ->
      unless category?
        $log.error "Invalid marker category"
        return

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      if $map.markers[category]?[id]?
        $map.map.setCenter $map.markers[category][id].getPosition()
        $map.map.setZoom 18


    centerInMarkerInMultipleCategories : (categories, id) ->
      unless categories?
        $log.error "Invalid marker categories"
        return

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      for category in categories
        if $map.markers[category]?[id]?
          $map.map.setCenter $map.markers[category][id].getPosition()
          $map.map.setZoom 18
          break

    # Returns a marker
    getMarker : (category, id) ->
      unless category?
        $log.error "Invalid marker category"
        return

      unless id?
        $log.error "Invalid marker ID"
        return
      id = "#{id}"

      if $map.markers[category]?[id]?
        $map.markers[category][id]

    # Returns a marker position
    getMarkerPosition : (category, id) ->
      marker = $map.getMarker(category, id)
      marker.getPosition() if marker?

    # Add a map event
    addListener : (event, callback) ->
      $map.map.addListener event, callback


    # Trigger event
    trigger : (event) ->
      google.maps.event.trigger $map.map, event


    # Toggle category
    toggleMarkers : (category) ->
      $map.visibility[category] = !($map.visibility[category] isnt false)

      for key, marker of $map.markers[category]
        marker = $map.getMarker category, key

        if $map.visibility[category]
          $map.showMarker category, key
        else
          $map.hideMarker category, key


    # Toggle clusters
    toggleClusters : () ->
      $map.visibility["clusters"] = !($map.visibility["clusters"] isnt false)
      for category, cluster of $map.clusters
        # Clear all markers
        unless $map.visibility["clusters"]
          $map.clusters[category].clearMarkers()

        # Re-show all markers (without clustering)
        for id, marker of $map.markers[category]
          $map.showMarker category, id if $map.visibility[category] isnt false

      # Map resize to redraw clusters
      $map.trigger "resize"

    geolocate : (callback) ->
      navigator.geolocation.getCurrentPosition(
        (response) ->
          if callback?
            callback response.coords.latitude, response.coords.longitude
      ,
        (message)->
          if message.code is 1
            callback "disabled"
          else
            callback "error"

      ,
        enableHighAccuracy : true
      )

    # Show route
    showRoute : (route) ->
      if route.routes? and route.routes isnt undefined
        path  = google.maps.geometry.encoding.decodePath route.routes[0].overview_polyline.points

        $map.clearRoute()

        $map.route = new google.maps.Polyline(
          path : path
          map  : $map.map
          strokeColor   : "#009a81"
          strokeOpacity : 0.6
          strokeWeight  : 5
        )

    clearRoute : () ->
      $map.route.setMap null if $map.route?
