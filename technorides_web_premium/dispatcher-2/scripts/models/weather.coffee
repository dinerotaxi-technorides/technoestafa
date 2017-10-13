technoridesApp.factory '$weather',($http, $user) ->

  $weather =
    temperature : ""
    icon        : ""
    update : ->
      return
      if $user.latitude?
        $http.get "http://api.openweathermap.org/data/2.5/weather", params: {appid:'5d6068c9f41f0b65b6707eb5a3151ab6',lat: $user.latitude, lon: $user.longitude, units: "metric"}
          .success (response) ->
            $weather.temperature = "#{response.main.temp}°"
            $weather.icon = "http://openweathermap.org/img/w/#{response.weather[0].icon}.png"
