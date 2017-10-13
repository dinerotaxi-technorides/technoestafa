technoridesApp.factory '$mapbox', ($log, $http, $settings) ->
  $map =
    map        : null
    token      : 'pk.eyJ1IjoibWlqYWlsY29oZW4iLCJhIjoiY2lteG93dGNrMDNueHZobTQ2OHh6eWRvdiJ9.LIVfDzHODln9bb66VEnUaQ'
    geocoder   : null
    exampleCluster : new L.MarkerClusterGroup()
    #new L.GeoSearch.Provider.Google()
    #new L.GeoSearch.Provider.Esri()
    initialize: (id, options) ->
      L.mapbox.accessToken = @.token
      if options.zoomControl is undefined
        options.zoomControl = true
      @.map = L.mapbox.map(id, options.mapTypeId,{zoomControl: options.zoomControl})

      #center map and zoom
      @.map.setView([options.latitude, options.longitude], options.zoom)
      @.options = options
      @.map.addLayer(@.exampleCluster)
    setCenter : (coords) ->
      $map.setView coords, 16

    latLng : (coords) ->
      L.latLng coords

    setView : (coords, zoom) ->
      @.map.setView coords, zoom

    resize : ->
      @.map._onResize()

    remove: ->
      if @.map
        @.map.remove()
#MARKERS-------------------------------------------------------------------------------
    #ADD MARKER
    addMarker : (options, listeners, useCluster, cluster) ->
      #cause before we where using google maps we adapt to leaflet
      markerIcon = new L.icon({iconUrl: options.icon, iconAnchor: [15, 20]})
      formatedOptions =
        icon      : markerIcon
        draggable : if options.draggable then options.draggable else false
        markerId  : options.markerId

      marker = new L.marker(options.position, formatedOptions)
      #ADD LABEL
      if options.labelContent
        labelOffset = if options.labelContent.length <= 3 then [-12,19] else [-20,15]

        marker.bindLabel(options.labelContent,{noHide: true,offset:labelOffset,className:'markerlabel'})
      if listeners?
        for listener in listeners
          marker.addEventListener(listener.event, listener.callback)

      #add to map or to cluster

      if useCluster
        cluster.addLayer(marker)
      else
        marker.addTo(@.map)
      return marker

    addListener : (event, callback) ->
      $map.map.on "#{event}", ->
        callback()

    getCenter : () ->
      @.map.getCenter()
    centerInMarkers : (markers) ->
      bounds = []
      for key, marker of markers
        bounds.push @.getMarkerPosition marker
      tocenter = new L.LatLngBounds(bounds)

      @.map.fitBounds(tocenter)
    # Update marker
    updateMarker : (marker, options, useCluster, cluster) ->
      if options.icon? and options.icon
        marker.setIcon L.icon({iconUrl: options.icon,iconAnchor: [15, 20]})
        if useCluster
          if @.map.hasLayer(marker)
            @.map.removeLayer marker
          cluster.addLayer marker

      if options.position?
        marker.setLatLng options.position
        marker.update()

      if options.draggable?
        if options.draggable
          if @.map.hasLayer(marker)
            marker.dragging.enable()
        else
          marker.dragging.disable()

    showMarker : (marker, useCluster, cluster) ->
      if useCluster
        unless cluster.hasLayer(marker)
          cluster.addLayer marker
      else
        unless @.map.hasLayer(marker)
          @.map.addLayer marker

    hideMarker : (marker, useCluster, cluster) ->
      if useCluster
        if cluster.hasLayer(marker)
          cluster.removeLayer marker
      else
        if @.map.hasLayer(marker)
          @.map.removeLayer marker


    getMarker : (category, id) ->
      unless category?
        $log.warn "Invalid marker category"
        return

      unless id?
        $log.warn "Invalid marker ID"
        return
      id = "#{id}"

      if $map.markers[category]?[id]?
        $map.markers[category][id]

    # Returns a marker position
    getMarkerPosition : (marker) ->
      marker.getLatLng()


    removeMarker : (category, id) ->
      @.map.removeLayer @.markers[category][id]

    clearRoute : ->
#CIRCLES -------------------------------------------------------------------------------
    removeCircle : (category, id) ->
      unless category?
        $log.warn "Invalid circle category"
        return
      unless id?
        $log.warn "Invalid circle ID"
        return
      id = "#{id}"
      if $map.circles[category][id]
        $map.map.removeLayer $map.circles[category][id]

    addCircle : (options) ->
      unless options.center?
        options.center = L.latLng(0,0)
      circle = L.circle(options.center, options.radius, @.DEFAULT_CIRCLE_OPTIONS)
      return circle

    updateCircle : (circle, options) ->
      if options.center?
        circle.setLatLng options.center

    showCircle : (circle) ->
      @.map.addLayer circle

    hideCircle : (circle) ->
      @.map.removeLayer circle

    getCallbackMarker : (event) ->
      event.target.getLatLng()

    formatLatLng : (coords) ->
      coords

    disableMovement : ->
      $map.map.dragging.disable();
      $map.map.touchZoom.disable();
      $map.map.doubleClickZoom.disable();
      $map.map.scrollWheelZoom.disable();
      $map.map.keyboard.disable();

    polygon : (path, options) ->
      L.polygon(path, options)

    newCluster : (name) ->
      cluster = new L.MarkerClusterGroup(
        iconCreateFunction: (cluster) ->
          L.divIcon
            html: "<div class='cluster_#{name} mapbox_cluster'><span>" + cluster.getChildCount() + '</span></div>'
      )
      @.map.addLayer(cluster)
      cluster.options.clusterName = name
      cluster
    showCluster : (cluster) ->
      @.map.addLayer cluster

    hideCluster : (cluster) ->
      @.map.removeLayer cluster
    DEFAULT_CIRCLE_OPTIONS :
      stroke: true
      color : "#ffffff"
      weight: 1
      opacity: 1
      fill : true
      fillColor: "#ffc700"
      fillOpacity: 0.1
