technoridesApp.factory '$parkings', ($api, $map, $user, $company) ->
  $parkings =
    show    : false
    current : {}
    list    : {}
    square  : null
    drawnItems : new L.FeatureGroup();

    deactivateEdit : ->
      for key, parking of $parkings.list
        parking.polygonOut.editing.disable()
        parking.polygonIn.editing.disable()
    activateEdit : (id) ->
      for key, parking of $parkings.list
        if parking.id is id
          parking.polygonOut.editing.enable()
          parking.polygonIn.editing.enable()
        else
          parking.polygonOut.editing.disable()
          parking.polygonIn.editing.disable()
    getSingleParking : (id) ->
      $parkings.list[id]

    eraseLayers : () ->
      if $parkings.square
        $map.provider.map.removeLayer($parkings.drawnItems)
        $map.provider.map.removeControl($parkings.drawControl)
      else
        for key,parking of $parkings.list
          $map.removeMarker "parkings", parking.id
          $map.hideCircle "parking", "#{parking.id}_driver"
          $map.hideCircle "parking", "#{parking.id}_passenger"

    get : (callback) ->

      $map.resize()
      if @.square
        $parkings.drawControl =  new L.Control.Draw
          edit:
            featureGroup: $parkings.drawnItems
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
        $api.send "getSquareParkings", {}, ->

          polygons = []
          length = 0
          for key, parking of $parkings.list
            polygons.push parking.polygonIn
            polygons.push parking.polygonOut
            $parkings.drawnItems.addLayer parking.polygonIn
            $parkings.drawnItems.addLayer parking.polygonOut

          $map.provider.map.addLayer($parkings.drawnItems);

          # Initialise the draw control and pass it the FeatureGroup of editable layers

          $map.provider.map.addControl($parkings.drawControl);
          if callback?
            callback()
      else
        $api.send "getParkings", {}, ->
          for key,parking of $parkings.list
            #circle 1

            options =
              radius   : $company.config.parking.distance.driver
              center : $map.latLng {lat:parking.latitude, lng:parking.longitude}

            $map.addCircle "parking", "#{parking.id}_driver", options

            #circle 2
            options =
              radius : $company.config.parking.distance.passenger
              center : $map.latLng {lat:parking.latitude, lng:parking.longitude}

            $map.addCircle "parking", "#{parking.id}_passenger", options

            $map.showCircle "parking", "#{parking.id}_driver"
            $map.showCircle "parking", "#{parking.id}_passenger"

            ##Marker
            options =
              icon : "/common/assets/markers/parking.png"
              draggable: true
              position : $map.latLng {lat:parking.latitude, lng:parking.longitude}
              markerId : parking.id

            listeners = []
            listeners.push
              event    : "dragend"
              callback : (event) ->
                options =
                  center : event.target.getLatLng()
                $map.updateCircle "parking", "#{event.target.options.markerId}_passenger", options
                $map.updateCircle "parking", "#{event.target.options.markerId}_driver", options
                data =
                  name : $parkings.list[Number(event.target.options.markerId)].name
                  id   : $parkings.list[Number(event.target.options.markerId)].id
                  lat  : event.target.getLatLng().lat
                  lng  : event.target.getLatLng().lng
                $api.send "updateParking", data
            $map.addMarker "parkings", "#{parking.id}", options, listeners



    new : (parking) ->
      $api.send "newSquareParking", {coords:parking.polygon.toGeoJSON().geometry.coordinates[0] , name: parking.name}, ->
        $parkings.get()

    findIndex : (parkingId) ->
      for parking, index in $company.parking.squares
        return index if parking.id is parkingId
      return null

    save : (parking) ->
      $api.send "updateSquareParking", parking, ->

    delete : (id) ->
      console.log id

    dragingShapes : (bol) ->
      $company.parking.dragging = bol

    focus : (parking) ->
      if @.square
        bounds = parking.polygonOut.getBounds()
        $map.provider.map.fitBounds bounds
        $parkings.activateEdit parking.id
      else
        $map.setCenter $map.latLng({lat:parking.latitude, lng:parking.longitude})
