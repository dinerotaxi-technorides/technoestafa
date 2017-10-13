technoridesApp.controller 'parkingCtrl' , ($scope, $api, $map, $company, $user, $parkings) ->
  $api.send "getCompanyConfiguration", {}, ->
    $api.send "getCompanyData", {}, ->
      console.log "ready"
  $scope.parkings = $parkings

  $scope.initMap = () ->
    $map.resize()
    $parkings.square = $company.config.parking.square
    $parkings.get(editPolygons);

  unless $map.provider.map
    $map.initialize "pmap_canvas",
      latitude  : $user.latitude
      longitude : $user.longitude
      zoom      : 14
      mapTypeId : "mapbox.streets"
      zoomControl : false

  else
    $map.provider.map = null
    $map.initialize "pmap_canvas",
      latitude  : $user.latitude
      longitude : $user.longitude
      zoom      : 14
      mapTypeId : "mapbox.streets"
      zoomControl : false
    $scope.initMap()
  editPolygons = ->
    $map.provider.map.on 'draw:edited', (e) ->
      e.layers.eachLayer (layer) ->
        $parkings.save layer

    $map.provider.map.on 'draw:created', (e) ->
      $scope.toAdd =
        polygon : e.layer
        name    : ""
      $(".new-parking").modal("show")
      false


  $scope.modalNewParking = (polygon) ->
    if $company.config.parking.square
      $scope.toAdd =
        parking : polygon
        name : ""
    else
      $scope.toAdd =
        parking : ""
        name : ""
    $(".new-parking").modal("show")
    return false

  $scope.addParking = (parking) ->
    if $company.config.parking.square
      $parkings.new(parking)
    else
      data =
        name : parking.name
        coords : $map.provider.map.getCenter()
      $api.send "newParking", data, ->
        $api.send "getParkings", {}, ->
          $parkings.get(editPolygons)
    $(".new-parking").modal("hide")
    return false

  $scope.modalDeleteParking = (id) ->
    $(".delete-parking").modal("show")
    $scope.toDelete = id

  $scope.modalEditParking = (parking) ->
    $scope.toEdit = parking
    $(".edit-parking").modal("show")
    false

  $scope.editParking = (toEdit) ->
    data =
      name      : toEdit.name
      id        : toEdit.id
      isPolygon : $company.config.parking.square
      lat       : toEdit.latitude
      lng       : toEdit.longitude
    if $company.config.parking.square
      data.lat = 0
      data.lng = 0
      data.coordsOut = toEdit.polygonOut.toGeoJSON().geometry.coordinates[0]
      data.coordsIn  = toEdit.polygonIn.toGeoJSON().geometry.coordinates[0]

    $api.send "editParkingName", data, ->
      $(".edit-parking").modal("hide")
      false
  $scope.deleteParking = (id) ->
    if $company.config.parking.square
      $api.send "deleteSquareParking", id, ->

        $parkings.get(editPolygons)
        $(".delete-parking").modal("hide")
    else
      $api.send "deleteParking", id, ->
        $(".delete-parking").modal("hide")
        $parkings.get(editPolygons)
        $map.hideCircle "parking", "#{id}_driver"
        $map.hideCircle "parking", "#{id}_passenger"
        $map.removeMarker "parkings", "#{id}"
