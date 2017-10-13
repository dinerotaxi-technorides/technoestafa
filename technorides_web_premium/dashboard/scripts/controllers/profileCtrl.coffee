technoridesApp.controller 'profileCtrl', ($scope, $user, $map, $company) ->

  if $map.provider.map
    #destroy
    $map.remove()
  $map.initialize "map_canvas",
    latitude  : $user.latitude
    longitude : $user.longitude
    zoom      : 14
    mapTypeId : "mapbox.streets"
  $map.resize();
  $map.reverseGeolocalize({lat: $user.latitude, lng: $user.longitude}, (address) ->
    setAddress(address);
  )
  options =
    position  : L.latLng $user.latitude, $user.longitude
    icon      : "/common/assets/markers/home.png"
    doCluster : false
    visible   : true
    draggable : true

  listeners = []
  listeners.push
    event    : "dragend"
    callback : (event) ->
      $map.reverseGeolocalize event.target.getLatLng(), (address) ->
        setAddress address

  setAddress = (address) ->
    $scope.address = address

  $map.addOrUpdateMarker "home", "home" , options, listeners
  $scope.updateCompanyLocation = ->
    data =
      name : $company.name
      cuit : $company.cuit
      phone: $company.phone
      name : $company.contactName
      celphone: $company.celphone
    position = $map.getMarkerPosition("home", "home");

    $company.latitude = position.lat
    $company.longitude = position.lng
    $api.send "editCompanyData", data
