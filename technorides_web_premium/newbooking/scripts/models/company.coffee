technoridesApp.factory '$company', [ 'company.api','$location','$map', '$translate',($api, $location, $map, $translate) ->
  $company =
    rtaxi : ""
    forgotpass : false
    statics : {}

    getInfo : ->
      $api.getInfo(
        rtaxi: $company.rtaxi
        done : (adapted) ->
          $company.info = adapted
          $translate.use $company.info.lang
          # Map Center
          $map.chooseProvider("mapbox")

          if $location.path() is "/booking/"
            $map.initialize "map_canvas",
              latitude         : $company.info.lat
              longitude        : $company.info.lng
              zoom             : 16
              mapTypeId        : "mapbox.streets"
              disableDefaultUI : true

            # Marker options
            options =
              position  : $map.latLng {lat:$company.info.lat, lng:$company.info.lng}
              icon      : "/common/assets/markers/home.png"
              doCluster : false
              visible   : true
              draggable : false

            # Add company marker
            $map.addMarker "company", "home", options

          else if $location.path() is "/"
            $map.initialize "map",
              latitude    : $company.info.lat
              longitude   : $company.info.lng
              zoom      : 16
              mapTypeId : "mapbox.streets"
              disableDefaultUI  : true
              scrollwheel : false
            # Marker options
            options =
              position  : $map.latLng {lat:$company.info.lat, lng:$company.info.lng}
              icon      : "/common/assets/markers/booking/home.png"
              doCluster : false
              visible   : true
              draggable : false
            $map.markers = {}
            # Add company marker
            $map.addMarker "company", "home", options
            $(window).resize ->
              $map.setCenter($map.latLng({lat:$company.info.lat, lng:$company.info.lng}))

        fail : () ->
      )

    getStatics : (params) ->
      $api.getStats
        token : params.token
        corporate_id: params.corporate
        done : (adapted) ->
          $company.statics = adapted

]
