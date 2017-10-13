technoridesApp.factory '$autocomplete', ['$autocomplete.adapter', '$map', '$operations', ($api, $map, $operations) ->
  $autocomplete =
    clickedTo : false
    clickedFrom: false 

    autocompletePassengers : (query, type) ->
      $api.autocompletePassengers
        query : query
        type  : type
        done  : (adapted) ->
          $autocomplete.passengers = adapted


    autocompleteFavorites : (user) ->
      $api.autocompleteFavorites
        user : user
        done : (adapted) ->

          $autocomplete.favorites = adapted


    autocompleteAddress : (direction, callback) ->
      $api.autocompleteAddress
        address : direction.address
        done    : (adapted) ->
          callback(adapted)

    autocompleteAddressFrom : (direction) ->
      $autocomplete.autocompleteAddress direction, (response) ->
        $autocomplete.froms = []
        # Place
        for place in response
          # Result
          $autocomplete.froms.push
            placeName : place.name
            location  : location
            type      : place.type
            place_id  : place.place_id

    autocompleteAddressTo : (direction) ->
      $map.updateMarker "newOperation", "to", visible : true
      $autocomplete.autocompleteAddress direction, (response) ->
        $autocomplete.tos = []
        # Place
        for place in response
          # Result
          $autocomplete.tos.push
            placeName : place.name
            location  : location
            type      : place.type
            place_id  : place.place_id


    getPlace : (type, place) ->
      $map.getPlace
        place : place
        done  : (place) ->
          if place.source is "midware"
            latitude  = place.geometry.location.lat
            longitude = place.geometry.location.lng
          else
            latitude  = place.geometry.location.lat()
            longitude = place.geometry.location.lng()

          latLng = $map.latLng {lat:latitude, lng:longitude}
          $map.setCenter latLng
          $map.updateMarker "newOperation", type,
            visible  : true
            position : latLng
          $operations.calculatePrice()


    geolocateAddress : (type, address) ->
      $map.getAddress address, (response) ->
        typeFormated = type.charAt(0).toUpperCase() + type.slice(1)
        $operations.operation["address#{typeFormated}"].address = response.formatted_address
        latitude = response.geometry.location.lat
        longitude = response.geometry.location.lng
        $map.setCenter $map.latLng {lat:latitude, lng:longitude}
        $map.updateMarker "newOperation", type,
          visible  : true
          position : $map.latLng({lat:latitude, lng:longitude})

        $autocomplete["#{type}s"] = undefined

]
