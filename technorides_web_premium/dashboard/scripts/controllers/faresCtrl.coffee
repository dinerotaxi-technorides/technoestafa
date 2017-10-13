technoridesApp.controller 'faresCtrl' , ($scope, $routeParams, $zonePrices, $map, $user, $api, $company, $zones) ->
  $scope.zones = $zones
  $api.send "getCompanyConfiguration", {}, ->
    $api.send "getCompanyData", {}, ->
      $zones.get()
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

  $scope.zonePrices = $zonePrices
  $zonePrices.get(0, "", "")

  $scope.initMap = () ->

    $zones.resetZones()
    $map.resize()
    $map.provider.map.on 'draw:created', (e) ->
      e.layer.on "click", (a) ->
        $zones.deactivateEdit()
        e.layer.editing.enable()
      $scope.toCreate =
        polygon : e.layer
        name    : ""
      $(".new-zone").modal("show")
      false

  $scope.newZone = (zone) ->
    $api.post "newZone", {polygon:zone.polygon, zoneName: zone.name}, ->
      $zones.resetZones()
      $(".new-zone").modal("hide")

  $scope.configFares = (zones, fares, destination) ->
    $api.post "companyFaresConfig", {fares:fares,zones:zones,destination:destination}

  $scope.deleteZone = (id) ->
    $(".delete-zone").modal("hide")
    $api.post "deleteZone", id, ->
      $zones.resetZones()

  $scope.modalDeleteZone = (id) ->
    $scope.toDelete = id
    $(".delete-zone").modal("show")
    false

  $scope.focusZone = (zone) ->
    bounds = zone.polygon.getBounds()
    $map.provider.map.fitBounds bounds
    $zones.activateZoneEdit zone.id

  $scope.modalEditZone = (zone) ->
    $scope.toEdit = zone
    $(".edit-zone").modal("show")
    false

  $scope.editZone = (zone) ->
    $api.post "editZoneName", zone, ->
      $zones.resetZones()
      $(".edit-zone").modal("hide")
      false
