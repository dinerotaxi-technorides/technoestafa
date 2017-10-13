technoridesApp.factory '$zones', ($api, $map, $user, $company) ->
  $zones =
    list       : {}
    drawnItems : new L.FeatureGroup()
    drawControl : null

    get : ->
      unless $zones.drawControl?
        $zones.drawControl = new L.Control.Draw
          edit:
            featureGroup: $zones.drawnItems
            edit:
              moveMarkers: false
            draw:
              polyline : false
              rectangle: false
              circle   : false
              marker   : false
          polygon:
            allowIntersection: false # Restricts shapes to simple polygons
            drawError:
              color: '#e1e100' #Color the shape will turn when intersects
              message: '<strong>Oh snap!<strong> you can\'t draw that!' # Message that will show when intersect
            shapeOptions:
              color: '#bada55'

      $("#preloader").show()
      $api.send "getZones", {}, ->
        $map.provider.map.addLayer $zones.drawnItems
        $map.provider.map.addControl $zones.drawControl
        $("#preloader").hide()
        $map.resize()
        for key, zone of $zones.list
          #Activate edit on click
          zone.polygon.on "click", (e) ->
            $zones.deactivateEdit()
            e.target.editing.enable()

          #Save zone on edit
          zone.polygon.on "edit", (e) ->
            $api.post "updateZone", e.target, ->

          $zones.drawnItems.addLayer zone.polygon

    activateZoneEdit : (id) ->
      for key, zone of $zones.list
        if zone.id is id
          zone.polygon.editing.enable()
        else
          zone.polygon.editing.disable()
    resetZones : ->
      $api.send "getZones", {}, ->
        #remove all layers
        $zones.drawnItems.eachLayer (layer) ->
          $zones.drawnItems.removeLayer layer
        for key, zone of $zones.list
          $zones.drawnItems.addLayer zone.polygon

    deactivateEdit : ->
      for key, zone of $zones.list
        zone.polygon.editing.disable()
