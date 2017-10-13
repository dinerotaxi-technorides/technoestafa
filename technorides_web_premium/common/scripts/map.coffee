technoridesApp.factory '$map', ($http, $settings, $google, $mapbox, $log) ->
  $map =
    useGoogle  : $settings[$settings.environment].googleSearch
    midwareUrl : $settings[$settings.environment].midwareUrl
    #google api key
    keyDevelopment: if $settings.environment is "production" then "AIzaSyDtoVBz1c4Q3t_PfQ1zYDdsd-T7WPIG7WE" else "AIzaSyCWq8xPUxSOPF5qfrVUR74RFGLzFq5u6VY"
    #mapbox api key
    token      : 'pk.eyJ1IjoibWlqYWlsY29oZW4iLCJhIjoiY2lteG93dGNrMDNueHZobTQ2OHh6eWRvdiJ9.LIVfDzHODln9bb66VEnUaQ'
    geocoder   : null
    provider   : {}
    providerName : ""
    makeClusters : false
    markers    : {}
    circles    : {}
    clusters   : {}
    counters   : {}
    visibility :
      newOperation          : true
      company               : true
      drivers_online        : true
      drivers_offline       : true
      drivers_disconnected  : true
      drivers_intravel      : true
      zones                 : false
      parkings              : true
      operations            : true


    markerExists : (id, categoryName) ->
      markerExists = false
      changingDriver = false
      if categoryName.indexOf("drivers_") > -1
        changingDriver = true
      for category, markers of @.markers
        for key, marker of markers
          if category.indexOf(categoryName) > -1
            markerExists = marker if "#{key}" is "#{id}"
          if category.indexOf("drivers_") > -1 and changingDriver
            markerExists = marker if "#{key}" is "#{id}"
      markerExists

    useClusters : (bool) ->
      @.makeClusters = bool
    chooseProvider : (provider) ->
      @.providerName = provider
      if provider is "google"
        @.provider = $google
      else
        @.provider = $mapbox

    # CAPA EXTERIOR
    initialize : (id, options) ->
      @.provider.initialize id, options

    setCenter : (coords) ->
      @.provider.setCenter coords

    resize : ->
      @.provider.resize()

    checkMarker : (category, id, options) ->
      unless category?
        $log.warn "Invalid marker category"
        return false
      else
        @.markers[category]  = {} unless @.markers[category]?
        @.counters[category] = 0 unless @.counters[category]?
        unless @.clusters[category]
          @.clusters[category] = @.provider.newCluster(category)
      unless id?
        $log.warn "Invalid marker ID"
        return false
      id = "#{id}"
      unless options?
        $log.warn "Marker options not defined, using defaults"
      return true

    disableMovement : () ->
      @.provider.disableMovement()

    getCenter : () ->
      @.provider.getCenter()

    updateMarker : (category, id, options) ->
      if @.checkMarker(category, id, options)
        currentMarker = @.markerExists(id, category)
        beforeCluster = @.clusters[currentMarker.markerCategory]
        @.provider.updateMarker currentMarker, options, @.makeClusters, @.clusters[category], beforeCluster
        if category isnt currentMarker.markerCategory
          @.markers[category][id] = currentMarker

          # @.hideMarker(@.markers[category][id],  @.makeClusters, @.clusters[category], @.markers[category])
          delete @.markers[currentMarker.markerCategory][id]
        @.markers[category][id].markerCategory = category

        if @.visibility[category]
          if options.visible or options.visible is undefined
            @.showMarker(@.markers[category][id],  @.makeClusters, @.clusters[category], @.markers[category])
          else
            @.hideMarker(@.markers[category][id],  @.makeClusters, @.clusters[category], @.markers[category])
        else
          @.hideMarker(@.markers[category][id],  @.makeClusters, @.clusters[category], @.markers[category])


    addMarker : (category, id, options, listeners)  ->
      if @.checkMarker(category, id, options)
        id = "#{id}"
        @.counters[category]++
        @.markers[category][id] = @.provider.addMarker(options, listeners, @.makeClusters, @.clusters[category])
        @.markers[category][id].markerCategory = category

        if @.visibility[category]
          if options.visible or options.visible is undefined
            #@.showMarker(@.markers[category][id],  @.makeClusters, @.clusters[category])
          else
            @.hideMarker(@.markers[category][id],  @.makeClusters, @.clusters[category], @.markers[category])
        else
          @.hideMarker(@.markers[category][id],  @.makeClusters, @.clusters[category], @.markers[category])

    addListener : (event, callback) ->
      @.provider.addListener event, callback

    showMarker : (marker, useCluster, cluster) ->
      @.provider.showMarker(marker, useCluster, cluster)

    removeMarker: (category, id) ->
      if @.markers[category]?["#{id}"]?
        @.hideMarker @.markers[category]["#{id}"], @.makeClusters, @.clusters[category], @.markers[category]
        @.counters[category]--

    hideMarker : (marker, useCluster, cluster, markers) ->
      @.provider.hideMarker(marker, useCluster, cluster, markers)

    toggleClusters : () ->

      @.toggleMarkers("operations")
      @.toggleMarkers("drivers_online")
      @.toggleMarkers("drivers_offline")
      @.toggleMarkers("drivers_intravel")
      @.toggleMarkers("drivers_disconnected")
      @.makeClusters = !@.makeClusters
      @.toggleMarkers("operations")
      @.toggleMarkers("drivers_online")
      @.toggleMarkers("drivers_offline")
      @.toggleMarkers("drivers_intravel")
      @.toggleMarkers("drivers_disconnected")


    clearMarkers : (category) ->
      unless category?
        $log.warn "Invalid marker ID"
        $log.warn "Invalid marker category"
        return

      for id, marker of @.markers[category]
        @.hideMarker @.markers[category][id], @.makeClusters, @.clusters[category], @.markers[category]

    showCluster : (category) ->
      if @.clusters[category]
        @.provider.showCluster @.clusters[category], @.markers[category]

    hideCluster : (category) ->
      if @.clusters[category]
        @.provider.hideCluster @.clusters[category], @.markers[category]

    latLng : (coords) ->
      @.provider.latLng coords

    getMarker : (category, id) ->
      if @.markers[category]
        if @.markers[category][id]
          return @.markers[category][id]
        else
          return null
      else
        return null

    addOrUpdateMarker : (category, id, options, listeners) ->
      if @.checkMarkerNoOptions(category, id)
        id = "#{id}"

        currentMarker = $map.markerExists(id, category)

        if currentMarker
          @.updateMarker category, id, options, listeners
        else
          @.addMarker category, id, options, listeners

    toggleMarkers : (category) ->
      @.visibility[category] = !@.visibility[category]
      if @.makeClusters
        if @.visibility[category]
          @.showCluster category
        else
          @.hideCluster category
      else
        for key, marker of $map.markers[category]
          if @.visibility[category]
            @.showMarker @.getMarker(category, key),  @.makeClusters, @.clusters[category], @.markers[category]
          else
            @.hideMarker @.getMarker(category, key),  @.makeClusters, @.clusters[category], @.markers[category]

    ####### CIRCLES ------------------------------------------------------------------------------------------

    checkCircle : (category, id) ->
      unless category?
        $log.warn "Invalid circle category"
        return false

      unless id?
        $log.warn "Invalid circle ID"
        return false

      return true

    showCircle : (category, id) ->
      if @.checkCircle(category, id)
        id = "#{id}"
        @.provider.showCircle(@.circles[category][id])

    updateCircle : (category, id, options) ->
      if @.checkCircle(category, id)
        @.provider.updateCircle(@.circles[category][id], options)

    getCircle : (category, id) ->
      if @.checkCircle(category, id)
        return @.circles[category][id]

    addCircle : (category, id, options) ->
      unless category?
        $log.warn "Invalid circle category"
        return
      else
        $map.circles[category] = {} unless $map.circles[category]?
      unless id?
        $log.warn "Invalid circle ID"
        return
      id = "#{id}"
      unless $map.circles[category][id]
        $map.circles[category][id] = @.provider.addCircle options


    hideCircle : (category, id) ->
      if @.checkCircle(category, id)
        id = "#{id}"
        @.provider.hideCircle @.circles[category][id]

    removeCircle : () ->


    hideCircles : () ->

####### CIRCLES ------------------------------------------------------------------------------------------
#
#
# ---------- PHP ALTERNATIVE TO Google Maps ---------------------
    getAddress : (address, callback) ->
      $http.get("#{@.midwareUrl}?service=geocode&address=#{address}&key=#{$map.keyDevelopment}").success (response) ->
        if response.status is "OK"
          callback response.results[0]

    reverseGeolocalizePHP : (coords, callback) ->
      #May be in the future we can also send a api token...
      $http.get("#{@.midwareUrl}?service=reverse&latlng=#{coords.lat},#{coords.lng}&key=#{$map.keyDevelopment}").success (response) ->
        if response.status is "OK"
          callback response.results[0].formatted_address


    geolocalizePHP: (params) ->
      if params.address isnt "" and params.address.length > 3
          #parameters: latitude, longitude, shouldCallback, done, address
          pred = []
          params.address = params.address.replace(" ", ",")
          $http.get("#{@.midwareUrl}?service=autocomplete&types=address&location=#{params.latitude},#{params.longitude}&input=#{params.address}&radius=5000&key=#{$map.keyDevelopment}").success (response) ->
            for prediction in response.predictions
              pred.push(
                name     : prediction.description
                place_id : prediction.place_id
                type     : prediction.types[0]
              ) # if prediction.description.includes($user.country)
            params.done($.unique(pred)) if params.shouldCallback

    getPlacePHP : (params) ->
      $http.get("#{@.midwareUrl}?service=place&placeid=#{params.place}").success (response) ->
        response.result.source = "midware"
        params.done response.result


    # ---------- PHP ALTERNATIVE TO Google Maps ---------------------
    #
    #
    geolocalize : (params) ->
      addresses = []
      # Local search?
      if params.user.useAdminCode
        addresses = [
          [params.address, params.user.adminCode, params.user.country]
          [params.address, params.user.adminCode]
          [params.address, params.user.country]
          [params.address]
        ]
      else
        addresses = [
          [params.address]
        ]

      results = []
      if @.useGoogle
        service = new google.maps.places.AutocompleteService()

      for address, index in addresses
        shouldCallback = index is (addresses.length - 1)
        address        = $.unique(address).join(", ")

        if address? and address isnt ""
          if @.useGoogle
            service.getPlacePredictions(
              {
                input    : address
                location : new google.maps.LatLng params.user.latitude, params.user.longitude
                radius   : 5000
              }
              (predictions, status) ->
                if status is "OK"
                  for prediction in predictions
                    results.push(
                      name     : prediction.description
                      place_id : prediction.place_id
                      type     : prediction.types[0]
                    ) # if prediction.description.includes($user.country)
                  params.done($.unique(results)) if shouldCallback
            )
          else
            parameters =
              latitude : params.user.latitude
              longitude : params.user.longitude
              shouldCallback: shouldCallback
              done : params.done
              address: address
            @.geolocalizePHP(parameters)
    getPlace : (params) ->
      if @.useGoogle
        unless @.placeService?
          @.placeService = new google.maps.places.PlacesService(document.createElement('div'))

        @.placeService.getDetails(
          placeId : params.place
          (place, status) ->
            params.done place
        )
      else
        @.getPlacePHP(params)

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
            callback "warn"

      ,
        enableHighAccuracy : true
      )
    reverseGeolocalize : (coords, callback) ->
      if @.useGoogle
        unless @.geocoder?
          @.geocoder = new google.maps.Geocoder
        @.geocoder.geocode {'location': coords}, (results, status) ->
          if status is google.maps.GeocoderStatus.OK
            callback results[0].formatted_address

      else
        @.reverseGeolocalizePHP(coords, callback)

    checkMarkerNoOptions : (category, id) ->
      unless category?
        $log.warn "Invalid marker category"
        return false

      unless id?
        $log.warn "Invalid marker ID"
        return false
      return true

    centerInMarkerInMultipleCategories : (categories, id) ->
      if @.checkMarkerNoOptions(categories, id)
        id = "#{id}"
        for category in categories
          if @.markers[category]? and @.markers[category][id]?
            @.setCenter(@.getMarkerPosition(category,id))

    showAllMarkers : () ->
      markersToBound = []
      for key, categories of @.markers
        for key, marker of categories
          markersToBound.push marker
      @.provider.centerInMarkers(markersToBound)

    centerInMarker : (category, id) ->
      if @.checkMarkerNoOptions(category, id)
        id = "#{id}"
        if $map.markers[category][id]?
          @.setCenter(@.getMarkerPosition(category,id))

# GEOCODING
# DUMMY METHODS (not yet implemented or migrated things)
    clearRoute : ->

    remove : ->
      @.provider.remove()

    getMarkerPosition : (category, id) ->
      @.provider.getMarkerPosition @.markers[category][id]

    getCallbackMarker : (event, pure) ->
      return @.provider.getCallbackMarker event, pure

    formatLatLng: (coords) ->
      return @.provider.formatLatLng(coords)

    ## ONLY IMPLEMENTED ON MAPBOX
    polygon : (path, options) ->
      @.provider.polygon(path, options)
